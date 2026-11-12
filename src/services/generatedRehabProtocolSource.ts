import rehabExerciseLibrary from '../../json/library_v3.json';
import rehabProtocolsJson from '../../json/protocols_v3.json';
import type {TableRow} from '../lib/supabaseDatabase';
import type {InjuryPhase, InjuryProtocol, RecoveryWindow} from './injuryDatabase';
import {getAllInjuries} from './injuryDatabase';
import {decodeMojibake} from './textEncoding';
import type {Language} from './translations';

export type RehabProtocolRow = TableRow<'protocols'>;
export type RehabPhaseRow = TableRow<'phases'>;
export type RehabExerciseRow = TableRow<'exercises'>;

type JsonExerciseLibraryEntry = {
  id: string;
  canonical_name: string;
  clinical_cue?: string;
  default_tags?: string[];
  status?: string;
};

type JsonProtocolExercise = {
  exercise_ref: string;
  dosage?: {
    sets?: number | null;
    reps?: number | null;
    duration_sec?: number | null;
    frequency_per_week?: number | null;
    exercise_type?: string | null;
    raw?: string | null;
  };
  tags?: string[];
  clinical_cue_override?: string | null;
};

type JsonProtocolPhase = {
  phase_number: number;
  title: string;
  timing: string;
  goals: string[];
  precautions: string[];
  criteria_to_progress: string[];
  exercises: JsonProtocolExercise[];
  progression_logic?: {
    rpe_target?: number;
    load_progression?: string;
    regression_options?: string[];
  };
};

type JsonProtocol = {
  id: number;
  slug: string;
  title: string;
  region: string;
  protocol_version?: string;
  is_active?: boolean;
  metadata?: {
    body_region?: string;
  };
  references?: Array<{
    raw?: string;
    title?: string;
    authors?: string;
    journal?: string;
    year?: number;
    doi?: string;
  }>;
  phases: JsonProtocolPhase[];
};

type LocalNutritionMatch = InjuryProtocol & {
  score: number;
};

const generatedRehabProtocols = rehabProtocolsJson as JsonProtocol[];
const rehabExerciseLibraryEntries = rehabExerciseLibrary as JsonExerciseLibraryEntry[];
const rehabExerciseLibraryById = new Map(rehabExerciseLibraryEntries.map((entry) => [entry.id, entry]));

function cleanText(value: string | null | undefined) {
  return value ? decodeMojibake(value).trim() : '';
}

function cleanList(value: string[] | null | undefined) {
  return (value || []).map((item) => cleanText(item)).filter(Boolean);
}

function formatJsonDosage(dosage?: JsonProtocolExercise['dosage']) {
  const raw = cleanText(dosage?.raw);
  if (raw) return raw;

  const parts: string[] = [];
  if (typeof dosage?.sets === 'number') parts.push(`${dosage.sets} sets`);
  if (typeof dosage?.reps === 'number') parts.push(`${dosage.reps} reps`);
  if (typeof dosage?.duration_sec === 'number') parts.push(`${dosage.duration_sec} sec`);
  if (typeof dosage?.frequency_per_week === 'number') parts.push(`${dosage.frequency_per_week}/week`);
  return parts.join(', ');
}

function getExerciseLibraryEntry(exerciseRef: string) {
  return rehabExerciseLibraryById.get(exerciseRef);
}

function getExerciseName(exercise: JsonProtocolExercise) {
  return cleanText(getExerciseLibraryEntry(exercise.exercise_ref)?.canonical_name) || cleanText(exercise.exercise_ref);
}

function getExerciseCue(exercise: JsonProtocolExercise) {
  return (
    cleanText(exercise.clinical_cue_override || undefined) ||
    cleanText(getExerciseLibraryEntry(exercise.exercise_ref)?.clinical_cue)
  );
}

export function getGeneratedRehabProtocolSlug(name: string) {
  return cleanText(name)
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/["']/g, '')
    .replace(/[()]/g, ' ')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function normalizeForMatch(value: string) {
  return cleanText(value)
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[()'".,]/g, ' ')
    .replace(/[^a-z0-9\s]+/g, ' ')
    .replace(
      /\b(post|postoperative|post-operative|conservative|grade|first|time|management|repair|reconstruction|rehabilitation|rehab|syndrome|injury)\b/g,
      ' ',
    )
    .replace(/\s+/g, ' ')
    .trim();
}

function tokenize(value: string) {
  return normalizeForMatch(value)
    .split(' ')
    .filter((token) => token.length > 2);
}

export function inferGeneratedBodyRegion(category: string, fallback?: string) {
  const cleanCategory = cleanText(category) || cleanText(fallback);
  const normalized = cleanCategory.toLowerCase();

  if (normalized.includes('knee')) return 'Knee';
  if (normalized.includes('shoulder')) return 'Shoulder';
  if (normalized.includes('ankle')) return 'Ankle';
  if (normalized.includes('foot')) return 'Foot';
  if (normalized.includes('spine')) return 'Spine';
  if (normalized.includes('back')) return 'Back';
  if (normalized.includes('hip')) return 'Hip';
  if (normalized.includes('elbow')) return 'Elbow';
  if (normalized.includes('wrist')) return 'Wrist';
  if (normalized.includes('upper limb')) return 'Arm';
  if (normalized.includes('paediatric')) return 'Whole body';
  if (normalized.includes('neurological')) return 'Whole body';
  if (normalized.includes('sports')) return 'Whole body';
  if (normalized.includes('trauma')) return 'Whole body';

  return cleanCategory || 'Whole body';
}

export function inferGeneratedRecoveryWindow(timeline: string, phaseNumber: number, phaseCount: number): RecoveryWindow {
  const normalized = cleanText(timeline).toLowerCase();

  if (/0\s*[-–]?\s*(2|3)\s*(day|days)/.test(normalized) || normalized.includes('immediate') || normalized.includes('acute')) {
    return 'under_48h';
  }

  if (
    /week\s*0/.test(normalized) ||
    /week\s*1/.test(normalized) ||
    /week\s*2/.test(normalized) ||
    /day\s*3/.test(normalized)
  ) {
    return 'days_3_14';
  }

  if (/week\s*(3|4|5|6|7|8)/.test(normalized) || normalized.includes('month 2') || normalized.includes('early strengthening')) {
    return 'weeks_2_6';
  }

  if (/month/.test(normalized) || /week\s*(9|10|11|12)/.test(normalized) || normalized.includes('return to sport') || normalized.includes('ongoing')) {
    return 'over_6_weeks';
  }

  if (phaseNumber <= 1) return 'under_48h';
  if (phaseNumber === phaseCount) return 'over_6_weeks';
  if (phaseNumber >= Math.ceil(phaseCount / 2)) return 'weeks_2_6';
  return 'days_3_14';
}

function findBestLocalNutritionMatch(name: string, category: string) {
  const remoteName = cleanText(name);
  const remoteTokens = new Set(tokenize(remoteName));
  const remoteBodyRegion = inferGeneratedBodyRegion(category);

  let bestMatch: LocalNutritionMatch | null = null;

  for (const local of getAllInjuries()) {
    const localName = cleanText(local.name);
    const localTokens = tokenize(localName);
    const localIdTokens = tokenize(local.id.replace(/_/g, ' '));
    const comparableTokens = new Set([...localTokens, ...localIdTokens]);

    let score = 0;
    if (normalizeForMatch(remoteName) === normalizeForMatch(localName)) score += 10;
    if (normalizeForMatch(remoteName) === normalizeForMatch(local.id.replace(/_/g, ' '))) score += 8;
    if (inferGeneratedBodyRegion(category) === local.bodyRegion) score += 2;

    for (const token of remoteTokens) {
      if (comparableTokens.has(token)) score += 1;
    }

    if (remoteBodyRegion === local.bodyRegion && comparableTokens.size > 0) score += 1;

    if (!bestMatch || score > bestMatch.score) {
      bestMatch = {...local, score};
    }
  }

  return bestMatch && bestMatch.score >= 3 ? bestMatch : null;
}

function getLocalizedNutritionArray(lang: Language, englishValues: string[], fallbackValues: string[]) {
  return lang === 'ar' && fallbackValues.length ? fallbackValues : englishValues;
}

function mapPhaseNutrition(phaseNumber: number, localMatch: InjuryProtocol | null, lang: Language) {
  const localPhase = localMatch?.phases[Math.min(Math.max(phaseNumber - 1, 0), (localMatch?.phases.length || 1) - 1)];

  if (!localPhase) {
    return {
      nutritionFocus: [],
      recommendedFoods: [],
      avoidFoods: [],
      supplements: [],
      prohibitedMovements: [],
      nutritionNotes: [],
      meals: {
        breakfast: '',
        lunch: '',
        dinner: '',
        shoppingList: [],
      },
      proteinPerKg: undefined,
      hydrationMlPerKg: undefined,
      omega3Grams: undefined,
      creatineGrams: undefined,
      collagenPerKg: undefined,
      vitaminCMg: undefined,
      calciumMg: undefined,
    };
  }

  return {
    nutritionFocus: getLocalizedNutritionArray(lang, localPhase.nutritionFocus, localPhase.nutritionFocus),
    recommendedFoods: getLocalizedNutritionArray(lang, localPhase.recommendedFoods, localPhase.recommendedFoods),
    avoidFoods: getLocalizedNutritionArray(lang, localPhase.avoidFoods, localPhase.avoidFoods),
    supplements: localPhase.supplements,
    prohibitedMovements: localPhase.prohibitedMovements,
    nutritionNotes: localPhase.nutritionNotes || [],
    meals: localPhase.meals,
    proteinPerKg: localPhase.proteinPerKg,
    hydrationMlPerKg: localPhase.hydrationMlPerKg,
    omega3Grams: localPhase.omega3Grams,
    creatineGrams: localPhase.creatineGrams,
    collagenPerKg: localPhase.collagenPerKg,
    vitaminCMg: localPhase.vitaminCMg,
    calciumMg: localPhase.calciumMg,
  };
}

function buildOverview(name: string, category: string, phaseCount: number, phases: JsonProtocolPhase[] = []) {
  const region = inferGeneratedBodyRegion(category);
  const firstGoals = cleanList(phases[0]?.goals).slice(0, 2);
  const laterGoals = cleanList(phases[phases.length - 1]?.goals).slice(0, 2);
  const progression = [...firstGoals, ...laterGoals].filter(Boolean);

  return [
    `${cleanText(name)} is a ${region.toLowerCase()} rehabilitation pathway with ${phaseCount} staged phase${phaseCount === 1 ? '' : 's'}.`,
    progression.length
      ? `It starts with ${progression[0].toLowerCase()} and progresses toward ${progression[progression.length - 1].toLowerCase()}.`
      : 'It is organized around symptom control, progressive loading, and return-to-activity decisions.',
  ].join(' ');
}

function buildPhaseNotes(phase: JsonProtocolPhase) {
  const notes: string[] = [];
  const loadProgression = cleanText(phase.progression_logic?.load_progression);
  if (loadProgression) notes.push(loadProgression);
  if (typeof phase.progression_logic?.rpe_target === 'number') {
    notes.push(`Target effort: RPE ${phase.progression_logic.rpe_target}.`);
  }
  return notes;
}

function hasAnyKeyword(value: string, keywords: string[]) {
  const normalized = cleanText(value).toLowerCase();
  return keywords.some((keyword) => normalized.includes(keyword));
}

function buildGeneratedCommonIn(name: string, bodyRegion: string, category: string) {
  const contexts: string[] = [];

  if (hasAnyKeyword(name, ['acl', 'meniscus', 'mcl', 'pcl', 'patellar', 'jumper'])) {
    contexts.push('Pivoting sports', 'Jumping sports', 'Gym training');
  } else if (bodyRegion === 'Shoulder') {
    contexts.push('Overhead sports', 'Gym training', 'Manual work');
  } else if (bodyRegion === 'Ankle' || bodyRegion === 'Foot') {
    contexts.push('Running', 'Field sports', 'Walking or standing loads');
  } else if (bodyRegion === 'Spine' || bodyRegion === 'Back' || bodyRegion === 'Neck') {
    contexts.push('Desk work', 'Lifting tasks', 'Daily activity');
  } else if (bodyRegion === 'Hip') {
    contexts.push('Running', 'Field sports', 'Single-leg loading');
  } else if (bodyRegion === 'Elbow' || bodyRegion === 'Wrist' || bodyRegion === 'Hand' || bodyRegion === 'Arm') {
    contexts.push('Gripping tasks', 'Racket or throwing sports', 'Manual work');
  } else {
    contexts.push('Sport', 'Daily activity', 'Return-to-training');
  }

  if (category === 'Post-surgery') contexts.unshift('Post-operative rehab');
  if (category === 'Pediatric') contexts.unshift('Growing athletes');
  if (category === 'Geriatric') contexts.unshift('Older adults');
  if (category === 'Bone') contexts.unshift('Bone-loading sports');

  return [...new Set(contexts)].slice(0, 4);
}

function buildGeneratedRedFlags(name: string, bodyRegion: string, category: string) {
  const redFlags = ['Rapidly worsening pain or swelling', 'Loss of function that does not match the expected rehab phase'];

  if (category === 'Post-surgery') {
    redFlags.push('Fever, wound changes, calf swelling, chest pain, or shortness of breath after surgery');
  }
  if (category === 'Bone' || hasAnyKeyword(name, ['fracture', 'stress reaction'])) {
    redFlags.push('Night pain, pain at rest, or pain that worsens with normal walking');
  }
  if (hasAnyKeyword(name, ['nerve', 'radiculopathy', 'tunnel', 'plexus'])) {
    redFlags.push('New numbness, spreading tingling, or progressive weakness');
  }
  if (bodyRegion === 'Spine' || bodyRegion === 'Back' || bodyRegion === 'Neck') {
    redFlags.push('Changes in bladder or bowel control, saddle symptoms, or severe neurological changes');
  }
  if (bodyRegion === 'Knee' || bodyRegion === 'Ankle' || bodyRegion === 'Hip') {
    redFlags.push('Inability to bear weight, giving way, or a locked joint');
  }
  if (bodyRegion === 'Shoulder' || bodyRegion === 'Elbow' || bodyRegion === 'Wrist' || bodyRegion === 'Hand' || bodyRegion === 'Arm') {
    redFlags.push('Sudden deformity, marked weakness, or loss of hand sensation');
  }

  return [...new Set(redFlags)].slice(0, 4);
}

function buildGeneratedSymptoms(name: string, bodyRegion: string, category: string) {
  const symptoms = [`Pain or sensitivity around the ${bodyRegion.toLowerCase()}`, 'Reduced tolerance to normal loading'];

  if (category === 'Tendon') symptoms.push('Stiffness or discomfort that changes with warm-up and load');
  if (category === 'Ligament') symptoms.push('Instability, swelling, or apprehension during direction changes');
  if (category === 'Muscle') symptoms.push('Local tenderness, weakness, or pain with resisted movement');
  if (category === 'Joint') symptoms.push('Stiffness, catching, or discomfort near end-range movement');
  if (category === 'Bone') symptoms.push('Focal pain that increases with impact or repeated loading');
  if (category === 'Post-surgery') symptoms.push('Expected post-operative stiffness, swelling, and strength loss');
  if (hasAnyKeyword(name, ['tunnel', 'nerve', 'radiculopathy'])) symptoms.push('Numbness, tingling, or symptoms spreading along a nerve path');

  return [...new Set(symptoms)].slice(0, 4);
}

function buildGeneratedRehabNotes(phases: JsonProtocolPhase[]) {
  const firstPhase = phases[0];
  const lastPhase = phases[phases.length - 1];
  const notes = [
    ...cleanList(firstPhase?.goals).slice(0, 2),
    ...cleanList(firstPhase?.precautions).slice(0, 1),
    ...cleanList(lastPhase?.criteria_to_progress).slice(0, 2),
  ];

  return [...new Set(notes)].slice(0, 5);
}

function buildGeneratedFaq(name: string, bodyRegion: string, phases: JsonProtocolPhase[], exerciseCount: number) {
  const firstDuration = cleanText(phases[0]?.timing) || 'the first phase';
  const lastDuration = cleanText(phases[phases.length - 1]?.timing) || 'the final phase';

  return [
    {
      q: `What does the ${cleanText(name)} protocol focus on?`,
      a: `It organizes ${bodyRegion.toLowerCase()} rehab into ${phases.length} phases, starting around ${firstDuration} and progressing toward ${lastDuration}.`,
    },
    {
      q: `How many exercises are included?`,
      a: `This pathway includes ${exerciseCount} exercise entries across the visible phases, with dosage, cues, precautions, and progression markers where available.`,
    },
    {
      q: `When should this plan be adjusted?`,
      a: 'Scale back and seek qualified clinical advice if pain, swelling, instability, neurological symptoms, or post-operative warning signs increase.',
    },
  ];
}

export function getGeneratedRehabProtocolRows(): RehabProtocolRow[] {
  return generatedRehabProtocols.map((protocol, index) => ({
    id: index + 1,
    name: cleanText(protocol.title),
    category: cleanText(protocol.region),
    description: null,
    created_at: null,
  }));
}

export function getGeneratedRehabPhaseRows(protocolId: number): RehabPhaseRow[] {
  const protocol = generatedRehabProtocols[protocolId - 1];
  if (!protocol) return [];

  return protocol.phases.map((phase, index) => ({
    id: protocolId * 100 + index + 1,
    protocol_id: protocolId,
    phase_number: phase.phase_number,
    title: cleanText(phase.title),
    timeline: cleanText(phase.timing),
    goals: cleanList(phase.goals),
    precautions: cleanList(phase.precautions),
    criteria_to_progress: cleanList(phase.criteria_to_progress),
    created_at: null,
  }));
}

export function getGeneratedRehabExerciseRows(phaseIds: number[]): RehabExerciseRow[] {
  const wanted = new Set(phaseIds);
  const rows: RehabExerciseRow[] = [];

  generatedRehabProtocols.forEach((protocol, protocolIndex) => {
    protocol.phases.forEach((phase, phaseIndex) => {
      const phaseId = (protocolIndex + 1) * 100 + phaseIndex + 1;
      if (!wanted.has(phaseId)) return;

      phase.exercises.forEach((exercise, exerciseIndex) => {
        rows.push({
          id: phaseId * 1000 + exerciseIndex + 1,
          phase_id: phaseId,
          name: getExerciseName(exercise),
          parameters: formatJsonDosage(exercise.dosage) || null,
          clinical_cue_rationale: getExerciseCue(exercise) || null,
          created_at: null,
        });
      });
    });
  });

  return rows;
}

function mapGeneratedProtocol(protocolId: number, lang: Language): InjuryProtocol | null {
  const protocol = generatedRehabProtocols[protocolId - 1];
  if (!protocol) return null;

  const title = cleanText(protocol.title);
  const region = cleanText(protocol.region);
  const localNutritionMatch = findBestLocalNutritionMatch(title, region);
  const bodyRegion =
    localNutritionMatch?.bodyRegion || inferGeneratedBodyRegion(protocol.metadata?.body_region || region, region);
  const category = localNutritionMatch?.category || region || bodyRegion;

  const mappedPhases: InjuryPhase[] = protocol.phases.map((phase, index) => {
    const nutrition = mapPhaseNutrition(phase.phase_number, localNutritionMatch, lang);
    const progressionNotes = buildPhaseNotes(phase);
    const regressionNotes = cleanList(phase.progression_logic?.regression_options);

    return {
      id: `protocol-${protocolId}-phase-${index + 1}`,
      label: cleanText(phase.title),
      duration: cleanText(phase.timing),
      window: inferGeneratedRecoveryWindow(cleanText(phase.timing), phase.phase_number, protocol.phases.length),
      goals: cleanList(phase.goals),
      nutritionFocus: nutrition.nutritionFocus,
      recommendedFoods: nutrition.recommendedFoods,
      avoidFoods: nutrition.avoidFoods,
      supplements: nutrition.supplements,
      exercises: phase.exercises.map((exercise) => getExerciseName(exercise)),
      prohibitedMovements: nutrition.prohibitedMovements,
      exercisePlans: phase.exercises.map((exercise) => ({
        exerciseId: exercise.exercise_ref,
        label: getExerciseName(exercise),
        sets: formatJsonDosage(exercise.dosage) || undefined,
        alternatives: cleanList(exercise.tags),
        cues: getExerciseCue(exercise) ? [getExerciseCue(exercise)] : [],
      })),
      focus: index === 0 ? buildOverview(title, region, protocol.phases.length) : undefined,
      progressionMarkers: [...cleanList(phase.criteria_to_progress), ...progressionNotes],
      cautions: [...cleanList(phase.precautions), ...regressionNotes],
      nutritionNotes: nutrition.nutritionNotes,
      meals: nutrition.meals,
      proteinPerKg: nutrition.proteinPerKg,
      hydrationMlPerKg: nutrition.hydrationMlPerKg,
      omega3Grams: nutrition.omega3Grams,
      creatineGrams: nutrition.creatineGrams,
      collagenPerKg: nutrition.collagenPerKg,
      vitaminCMg: nutrition.vitaminCMg,
      calciumMg: nutrition.calciumMg,
    };
  });

  const exercisePlanCount = mappedPhases.reduce((total, phase) => total + (phase.exercisePlans?.length || 0), 0);
  const generatedPageContent = {
    intro: buildOverview(title, region, mappedPhases.length, protocol.phases),
    symptoms: buildGeneratedSymptoms(title, bodyRegion, category),
    faq: buildGeneratedFaq(title, bodyRegion, protocol.phases, exercisePlanCount),
    rehabNotes: buildGeneratedRehabNotes(protocol.phases),
    nutritionNotes: mappedPhases.flatMap((phase) => phase.nutritionFocus).filter(Boolean).slice(0, 5),
  };

  return {
    id: cleanText(protocol.slug).replace(/-/g, '_') || getGeneratedRehabProtocolSlug(title).replace(/-/g, '_'),
    name: title,
    category: category as InjuryProtocol['category'],
    bodyRegion: bodyRegion as InjuryProtocol['bodyRegion'],
    commonIn: buildGeneratedCommonIn(title, bodyRegion, category),
    overview: generatedPageContent.intro,
    rehabSummary: mappedPhases.length
      ? `${mappedPhases.length}-phase ${bodyRegion.toLowerCase()} rehab progression with ${exercisePlanCount} exercise entries, phase goals, precautions, and progression rules.`
      : 'Structured rehab progression.',
    redFlags: buildGeneratedRedFlags(title, bodyRegion, category),
    relatedCalculators: ['Protein intake', 'Water intake'],
    safetyNotes: localNutritionMatch?.safetyNotes || {medications: [], supplements: []},
    contraindications: localNutritionMatch?.contraindications || {medications: [], supplements: []},
    phases: mappedPhases,
    pageContent: localNutritionMatch?.pageContent
      ? {
          intro: localNutritionMatch.pageContent.intro || generatedPageContent.intro,
          symptoms: localNutritionMatch.pageContent.symptoms?.length
            ? localNutritionMatch.pageContent.symptoms
            : generatedPageContent.symptoms,
          faq: localNutritionMatch.pageContent.faq?.length ? localNutritionMatch.pageContent.faq : generatedPageContent.faq,
          rehabNotes: localNutritionMatch.pageContent.rehabNotes?.length
            ? localNutritionMatch.pageContent.rehabNotes
            : generatedPageContent.rehabNotes,
          nutritionNotes: localNutritionMatch.pageContent.nutritionNotes?.length
            ? localNutritionMatch.pageContent.nutritionNotes
            : generatedPageContent.nutritionNotes,
        }
      : generatedPageContent,
  };
}

export function getGeneratedInjuryProtocolBySlug(slug: string, lang: Language): InjuryProtocol | null {
  const protocolId = getGeneratedRehabProtocolRows().find((row) => getGeneratedRehabProtocolSlug(row.name) === slug)?.id;
  return protocolId ? mapGeneratedProtocol(protocolId, lang) : null;
}

export function getGeneratedInjuryProtocols(lang: Language): InjuryProtocol[] {
  return getGeneratedRehabProtocolRows()
    .map((row) => mapGeneratedProtocol(row.id, lang))
    .filter((protocol): protocol is InjuryProtocol => Boolean(protocol));
}
