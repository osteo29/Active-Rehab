
# Generate json/muscles_library.json from body-iq muscles.ts
# Reads the TypeScript source and extracts muscle data via regex

$musclesTs = Get-Content "d:\gpa calc\physio\physionut-main\tmp\body-iq\prisma\seed\muscles.ts" -Raw

# Find the muscles array block
$arrayMatch = [regex]::Match($musclesTs, 'const muscles: MuscleDef\[\] = \[([\s\S]+?)\];\s*\nconst movementMuscleLinks')
if (-not $arrayMatch.Success) {
    # Try alternate pattern
    $arrayMatch = [regex]::Match($musclesTs, 'const muscles: MuscleDef\[\] = \[([\s\S]+?)\];\s*\nexport async')
}

$arrayContent = $arrayMatch.Groups[1].Value

# Match each muscle object { ... }
$musclePattern = '\{\s*slug:\s*"([^"]+)",\s*name:\s*"([^"]+)",\s*description:\s*"(?:[^"\\]|\\.)*",\s*origin:\s*"([^"]+)",\s*insertion:\s*"([^"]+)",\s*action:\s*"([^"]+)",\s*innervation:\s*"([^"]+)",\s*bloodSupply:\s*"([^"]+)"'

$muscles = @{}
$matches = [regex]::Matches($arrayContent, $musclePattern)

foreach ($m in $matches) {
    $slug = $m.Groups[1].Value
    $muscles[$slug] = @{
        name = $m.Groups[2].Value
        origin = $m.Groups[3].Value
        insertion = $m.Groups[4].Value
        action = $m.Groups[5].Value
        innervation = $m.Groups[6].Value
        blood_supply = $m.Groups[7].Value
    }
}

Write-Host "Extracted $($muscles.Count) muscles"

$output = @{
    version = "1.0.0"
    source = "body-iq MIT license"
    muscles = $muscles
}

$json = $output | ConvertTo-Json -Depth 10 -Compress:$false
Set-Content -Path "d:\gpa calc\physio\physionut-main\json\muscles_library.json" -Value $json -Encoding UTF8
Write-Host "Written to json/muscles_library.json"
Write-Host "Muscle count: $($muscles.Count)"
