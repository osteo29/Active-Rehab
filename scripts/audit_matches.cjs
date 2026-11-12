const fs = require('fs');

const library = JSON.parse(fs.readFileSync('json/library_v3.json', 'utf8'));

// Parse all exercises from exercises.ts
const fileContent = fs.readFileSync('tmp/body-iq/prisma/seed/exercises.ts', 'utf8');

// Also load extension files
const extFiles = [
  'common-exercises-2026-07.json',
  'home-exercises-2026-07.json',
  'coverage-exercises-2026-07.json',
  'region-exercises-2026-07.json'
];

const bodyIqList = [];

// extract from extensions
for (const f of extFiles) {
  try {
    const data = JSON.parse(fs.readFileSync('tmp/body-iq/prisma/seed/extensions/' + f, 'utf8'));
    if (Array.isArray(data)) {
      for (const item of data) {
        if (item.slug && item.name) {
          bodyIqList.push({
            slug: item.slug,
            name: item.name,
            source: f,
            data: item
          });
        }
      }
    }
  } catch(e) {}
}

// Extract slug and name from main exercises.ts using block splitting
const exerciseBlocks = fileContent.split(/\n\s*\{\s*\n\s*slug:\s*"/).slice(1);
for (const block of exerciseBlocks) {
  const slugMatch = block.match(/^([^"]+)"/);
  const nameMatch = block.match(/name:\s*"([^"]+)"/);
  if (slugMatch && nameMatch) {
    bodyIqList.push({
      slug: slugMatch[1],
      name: nameMatch[1],
      source: 'exercises.ts'
    });
  }
}

console.log('Total extracted Body IQ exercises:', bodyIqList.length);

function normalize(str) {
  return (str || '').toLowerCase().replace(/[^a-z0-9]/g, ' ').replace(/\s+/g, ' ').trim();
}

const bodyByNormName = new Map();
const bodyBySlug = new Map();

for (const b of bodyIqList) {
  bodyBySlug.set(b.slug, b);
  bodyByNormName.set(normalize(b.name), b);
  bodyByNormName.set(normalize(b.slug), b);
}

// Synonyms map: your library_v3 ID -> Body IQ slugs or candidate names
const synonyms = {
  "quad_sets": ["quadriceps-isometrics", "quad-set", "isometric-quad-contraction", "quadriceps-activation"],
  "heel_slides": ["heel-slide", "supine-knee-flexion"],
  "calf_raises": ["heel-raise", "standing-calf-raise", "calf-raise"],
  "seated_calf_raises": ["seated-heel-raise", "seated-calf-raise"],
  "mini_squats": ["partial-squat", "wall-squat-partial-range", "chair-squat", "squat"],
  "wall_slides": ["wall-slide", "scapular-wall-slide"],
  "scapular_retraction": ["scapular-retraction", "scapular-pinches"],
  "glute_bridge": ["bridge", "hip-thrust"],
  "bridges": ["bridge"],
  "plank": ["prone-plank", "plank-hold"],
  "prone_extension": ["prone-press-up", "prone-spine-extension", "back-extension"],
  "external_rotation": ["shoulder-external-rotation", "side-lying-external-rotation"],
  "internal_rotation": ["shoulder-internal-rotation"],
  "hip_abduction": ["side-lying-hip-abduction", "hip-abduction"],
  "hip_adduction": ["side-lying-hip-adduction", "hip-adduction"],
  "hamstring_curls": ["leg-curl", "prone-hamstring-curl", "seated-leg-curl"],
  "knee_extension": ["leg-extension", "terminal-knee-extension"],
  "dead_bug": ["dead-bug"],
  "cat_camel": ["cat-cow", "cat-camel"],
  "chin_tucks": ["chin-tuck", "cervical-retraction"],
  "lat_pull_downs": ["lat-pulldown", "neutral-grip-lat-pulldown"],
  "push_ups": ["push-up", "pushup"],
  "biceps_curls": ["biceps-curl"],
  "triceps_extensions": ["triceps-pushdown", "skull-crusher"],
  "lateral_raises": ["lateral-raise", "dumbbell-lateral-raise"],
  "face_pulls": ["face-pull"],
  "band_walks": ["monster-walk", "lateral-band-walk"],
  "monster_walk": ["monster-walk"],
  "seated_row": ["seated-cable-row", "seated-row"],
  "deadlift": ["romanian-deadlift", "deadlift"]
};

let directMatch = 0;
let nameMatch = 0;
let synonymMatch = 0;
const matchedDetails = [];
const unmatchedList = [];

for (const ex of library) {
  const exSlugKebab = ex.id.replace(/_/g, '-');
  const exNormName = normalize(ex.canonical_name);
  
  if (bodyBySlug.has(exSlugKebab)) {
    directMatch++;
    matchedDetails.push({ id: ex.id, name: ex.canonical_name, matchedTo: bodyBySlug.get(exSlugKebab).slug, type: 'direct_slug' });
  } else if (bodyByNormName.has(exNormName)) {
    nameMatch++;
    matchedDetails.push({ id: ex.id, name: ex.canonical_name, matchedTo: bodyByNormName.get(exNormName).slug, type: 'normalized_name' });
  } else if (synonyms[ex.id]) {
    const candidates = synonyms[ex.id];
    let found = null;
    for (const cand of candidates) {
      if (bodyBySlug.has(cand)) { found = bodyBySlug.get(cand); break; }
      if (bodyByNormName.has(normalize(cand))) { found = bodyByNormName.get(normalize(cand)); break; }
    }
    if (found) {
      synonymMatch++;
      matchedDetails.push({ id: ex.id, name: ex.canonical_name, matchedTo: found.slug, type: 'clinical_synonym' });
    } else {
      unmatchedList.push({ id: ex.id, name: ex.canonical_name, default_tags: ex.default_tags });
    }
  } else {
    unmatchedList.push({ id: ex.id, name: ex.canonical_name, default_tags: ex.default_tags });
  }
}

console.log('--- AUDIT RESULTS ---');
console.log('Total Library Exercises:', library.length);
console.log('Direct Slug Matches:', directMatch);
console.log('Normalized Name Matches:', nameMatch);
console.log('Clinical Synonym Matches:', synonymMatch);
console.log('Total Verified Matches:', directMatch + nameMatch + synonymMatch);
console.log('Remaining Inferred Exercises:', unmatchedList.length);

fs.writeFileSync('tmp/verified_matches.json', JSON.stringify(matchedDetails, null, 2));
fs.writeFileSync('tmp/unmatched_exercises.json', JSON.stringify(unmatchedList, null, 2));
