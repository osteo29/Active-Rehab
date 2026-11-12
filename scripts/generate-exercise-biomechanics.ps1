# Generate json/exercise_biomechanics.json
# Combines body-iq data for 20 matched exercises + tag inference for the rest

Set-Location "d:\gpa calc\physio\physionut-main"

#region ---- Helper: parse exercises.ts ----

$exercisesTs = Get-Content "tmp\body-iq\prisma\seed\exercises.ts" -Raw -Encoding UTF8

# Map: slug -> parsed object
$bodyIqMap = @{}

# Match exercise blocks using slug as anchor; greedily capture until next top-level {
# We'll split on "  {" at top level to get individual exercise blocks
$lines = $exercisesTs -split "\r?\n"
$inArray = $false
$depth = 0
$currentBlock = ""
$blocks = @()

foreach ($line in $lines) {
    if ($line -match "^const exercises: ExerciseDef\[\] = \[") {
        $inArray = $true
        $depth = 0
        continue
    }
    if (-not $inArray) { continue }
    
    # Count braces
    $openCount = ([regex]::Matches($line, '\{')).Count
    $closeCount = ([regex]::Matches($line, '\}')).Count
    
    if ($depth -eq 0 -and $line.Trim() -eq '{') {
        $currentBlock = ""
        $depth = 1
        continue
    }
    
    if ($depth -gt 0) {
        $depth += $openCount - $closeCount
        if ($depth -le 0) {
            # End of block
            $blocks += $currentBlock
            $currentBlock = ""
            $depth = 0
        } else {
            $currentBlock += $line + "`n"
        }
    }
    
    if ($line -match "^\];\s*$" -and $depth -eq 0) { break }
}

Write-Host "Found $($blocks.Count) exercise blocks in exercises.ts"

function Extract-StringField($block, $fieldName) {
    $m = [regex]::Match($block, "$fieldName`:\s*""((?:[^""\\]|\\.)*)""")
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

function Extract-StringArrayField($block, $fieldName) {
    $m = [regex]::Match($block, "$fieldName`:\s*\[([^\]]*)\]")
    if (-not $m.Success) { return @() }
    $inner = $m.Groups[1].Value
    $items = [regex]::Matches($inner, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    return @($items)
}

function Extract-MuscleRoles($block) {
    $primary = @(); $stabilizers = @(); $secondary = @()
    $rolesSection = [regex]::Match($block, 'muscleRoles:\s*\[([\s\S]+?)\]')
    if (-not $rolesSection.Success) { return @{primary=@(); stabilizers=@(); secondary=@()} }
    $inner = $rolesSection.Groups[1].Value
    $roleMatches = [regex]::Matches($inner, 'muscleSlug:\s*"([^"]+)",\s*role:\s*"([^"]+)"')
    foreach ($rm in $roleMatches) {
        $slug = $rm.Groups[1].Value
        $role = $rm.Groups[2].Value
        switch ($role) {
            "primary"   { $primary    += $slug }
            "stabilizer"{ $stabilizers += $slug }
            "secondary" { $secondary  += $slug }
            "synergist" { $secondary  += $slug }
        }
    }
    return @{primary=$primary; stabilizers=$stabilizers; secondary=$secondary}
}

function Extract-Progressions($block) {
    $section = [regex]::Match($block, 'progressions:\s*\[([\s\S]+?)\](?=\s*,?\s*(?:cues|regressions|functionalTask|\}))')
    if (-not $section.Success) { return @() }
    $items = [regex]::Matches($section.Groups[1].Value, 'name:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    # Convert names to snake_case slugs by guessing (best effort: lowercase + replace space/hyphen with underscore)
    return @($items | ForEach-Object { $_.ToLower() -replace '[^a-z0-9]+','_' -replace '^_|_$','' })
}

function Extract-Regressions($block) {
    $section = [regex]::Match($block, 'regressions:\s*\[([\s\S]+?)\](?=\s*,?\s*(?:cues|progressions|functionalTask|\}))')
    if (-not $section.Success) { return @() }
    $items = [regex]::Matches($section.Groups[1].Value, 'name:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    return @($items | ForEach-Object { $_.ToLower() -replace '[^a-z0-9]+','_' -replace '^_|_$','' })
}

foreach ($block in $blocks) {
    $slugLine = [regex]::Match($block, 'slug:\s*"([^"]+)"')
    if (-not $slugLine.Success) { continue }
    $slug = $slugLine.Groups[1].Value
    
    $muscles = Extract-MuscleRoles $block
    $movs = Extract-StringArrayField $block "movementSlugs"
    
    # Determine kinetic chain from movements
    $kc = "open"
    $closedMovs = @("hip-extension","knee-extension","squat","sit-to-stand","hip-flexion","ankle-plantarflexion")
    if ($movs | Where-Object { $closedMovs -contains $_ }) { $kc = "closed" }
    
    $bodyIqMap[$slug] = @{
        primary_muscles   = $muscles.primary
        stabilizers       = $muscles.stabilizers
        movements         = $movs
        kinetic_chain     = $kc
        contraction_type  = if ((Extract-StringField $block "bodyPosition") -and $block -match "isometric") { "isometric" } else { "dynamic" }
        body_position     = Extract-StringField $block "bodyPosition"
        difficulty        = Extract-StringField $block "difficulty"
        equipment         = Extract-StringArrayField $block "equipment"
        evidence_level    = Extract-StringField $block "evidenceLevel"
        emg_notes         = Extract-StringField $block "emgNotes"
        progressions      = Extract-Progressions $block
        regressions       = Extract-Regressions $block
    }
}

Write-Host "Parsed $($bodyIqMap.Count) exercises from body-iq"

#endregion

#region ---- Also check extensions for serratus-anterior ----
$extensionsDir = "tmp\body-iq\prisma\seed\extensions"
$serratusBlock = $null
Get-ChildItem $extensionsDir -Filter "*.ts" | ForEach-Object {
    $ext = Get-Content $_.FullName -Raw -Encoding UTF8
    if ($ext -match '"serratus-anterior"' -or $ext -match "slug.*serratus") {
        # Look for a serratus entry
        $m = [regex]::Match($ext, '(?ms)slug[:\s]+["'']serratus-anterior["''].*?(?=\n\s*\{|\Z)')
        if ($m.Success) { $serratusBlock = $m.Value }
    }
}
# Since serratus-anterior is not in main exercises.ts as a full exercise entry, we'll craft it
if (-not $bodyIqMap.ContainsKey("serratus-anterior")) {
    $bodyIqMap["serratus-anterior"] = @{
        primary_muscles  = @("serratus-anterior")
        stabilizers      = @("trapezius-middle","trapezius-lower")
        movements        = @("scapular-protraction","shoulder-flexion")
        kinetic_chain    = "closed"
        contraction_type = "dynamic"
        body_position    = "standing"
        difficulty       = "beginner"
        equipment        = @()
        evidence_level   = "moderate"
        emg_notes        = "Best activated by wall slide and push-up plus variations [Decker 1999]"
        progressions     = @("push_up_plus")
        regressions      = @()
    }
}
#endregion

#region ---- Mapping: library ID -> body-iq slug ----
$matchMap = @{
    "straight_leg_raise"           = "straight-leg-raise"
    "terminal_knee_extension"      = "terminal-knee-extension"
    "clamshell"                    = "clamshell"
    "spanish_squat"                = "spanish-squat"
    "lateral_bounds"               = "lateral-bounds"
    "sit_to_stand"                 = "sit-to-stand"
    "pendulum_exercise"            = "pendulum-exercise"
    "full_can_exercise"            = "full-can-exercise"
    "push_up_plus"                 = "push-up-plus"
    "overhead_press"               = "overhead-press"
    "diaphragmatic_breathing"      = "diaphragmatic-breathing"
    "bird_dog"                     = "bird-dog"
    "bridge"                       = "bridge"
    "side_plank"                   = "side-plank"
    "pallof_press"                 = "pallof-press"
    "deep_neck_flexor_training"    = "deep-neck-flexor-training"
    "serratus_anterior"            = "serratus-anterior"
    "grip_strengthening"           = "grip-strengthening"
    "tendon_gliding_exercises"     = "tendon-gliding-exercises"
    "forearm_pronation_supination" = "forearm-pronation-supination"
}
#endregion

#region ---- Tag-based inference for remaining exercises ----
function Infer-FromTags($tags) {
    $entry = @{
        primary_muscles  = @()
        stabilizers      = @()
        movements        = @()
        kinetic_chain    = $null
        contraction_type = $null
        body_position    = $null
        difficulty       = "beginner"
        equipment        = @()
        evidence_level   = "moderate"
        emg_notes        = $null
        progressions     = @()
        regressions      = @()
    }
    
    foreach ($tag in $tags) {
        switch -Wildcard ($tag) {
            "isometric"    { $entry.contraction_type = "isometric" }
            "open_chain"   { $entry.kinetic_chain = "open" }
            "closed_chain" { $entry.kinetic_chain = "closed" }
            "mobility"     { if (-not $entry.contraction_type) { $entry.contraction_type = "dynamic" } }
            "strength"     { $entry.evidence_level = "moderate" }
            "quad"         { if ($entry.primary_muscles -notcontains "quadriceps") { $entry.primary_muscles += "quadriceps" } }
            "hamstring"    { if ($entry.primary_muscles -notcontains "hamstrings") { $entry.primary_muscles += "hamstrings" } }
            "glute"        { 
                if ($entry.primary_muscles -notcontains "gluteus-maximus") { $entry.primary_muscles += "gluteus-maximus" }
                if ($entry.primary_muscles -notcontains "gluteus-medius") { $entry.primary_muscles += "gluteus-medius" }
            }
            "shoulder"     { if ($entry.primary_muscles -notcontains "rotator-cuff") { $entry.primary_muscles += "rotator-cuff" } }
            "hip"          { if ($entry.primary_muscles -notcontains "hip-flexors") { $entry.primary_muscles += "hip-flexors" } }
            "ankle"        { 
                if ($entry.primary_muscles -notcontains "tibialis-anterior") { $entry.primary_muscles += "tibialis-anterior" }
                if ($entry.primary_muscles -notcontains "gastrocnemius") { $entry.primary_muscles += "gastrocnemius" }
            }
            "core"         { 
                if ($entry.primary_muscles -notcontains "transversus-abdominis") { $entry.primary_muscles += "transversus-abdominis" }
                if ($entry.primary_muscles -notcontains "multifidus") { $entry.primary_muscles += "multifidus" }
            }
            "spine"        { 
                if ($entry.primary_muscles -notcontains "erector-spinae") { $entry.primary_muscles += "erector-spinae" }
                if ($entry.primary_muscles -notcontains "multifidus") { $entry.primary_muscles += "multifidus" }
            }
        }
    }
    
    # Defaults if nothing inferred
    if (-not $entry.kinetic_chain) { $entry.kinetic_chain = "open" }
    if (-not $entry.contraction_type) { $entry.contraction_type = "dynamic" }
    if ($entry.primary_muscles.Count -eq 0) { $entry.primary_muscles = @("unspecified") }
    
    return $entry
}
#endregion

#region ---- Build entries ----
$library = Get-Content "json\library_v3.json" | ConvertFrom-Json

$entries = @{}

foreach ($ex in $library) {
    $id = $ex.id
    
    if ($matchMap.ContainsKey($id)) {
        # Use body-iq data
        $biqSlug = $matchMap[$id]
        if ($bodyIqMap.ContainsKey($biqSlug)) {
            $biq = $bodyIqMap[$biqSlug]
            $entry = @{
                primary_muscles  = @($biq.primary_muscles)
                stabilizers      = @($biq.stabilizers)
                movements        = @($biq.movements)
                kinetic_chain    = $biq.kinetic_chain
                contraction_type = $biq.contraction_type
                body_position    = $biq.body_position
                difficulty       = $biq.difficulty
                equipment        = @($biq.equipment)
                evidence_level   = $biq.evidence_level
                emg_notes        = $biq.emg_notes
                progressions     = @($biq.progressions)
                regressions      = @($biq.regressions)
            }
            $entries[$id] = $entry
        } else {
            Write-Warning "body-iq slug not found: $biqSlug (for $id) - falling back to tag inference"
            $entries[$id] = Infer-FromTags $ex.default_tags
        }
    } else {
        # Tag-based inference
        $entries[$id] = Infer-FromTags $ex.default_tags
    }
}

Write-Host "Built $($entries.Count) exercise entries"
#endregion

#region ---- Write output ----
$output = [ordered]@{
    version = "1.0.0"
    source  = "body-iq + clinical curation"
    entries = $entries
}

$json = $output | ConvertTo-Json -Depth 10 -Compress:$false
Set-Content -Path "json\exercise_biomechanics.json" -Value $json -Encoding UTF8
Write-Host "Written to json/exercise_biomechanics.json"
Write-Host "Total entries: $($entries.Count)"
#endregion
