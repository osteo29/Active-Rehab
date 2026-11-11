import {supabase} from '../lib/supabase';
import type {TableInsert, TableUpdate} from '../lib/supabaseDatabase';
import type {InjuryPhase, InjuryProtocol} from './injuryDatabase';
import {getAllInjuries} from './injuryDatabase';
import {
  getGeneratedInjuryProtocolBySlug,
  getGeneratedRehabExerciseRows,
  getGeneratedRehabPhaseRows,
  getGeneratedRehabProtocolRows,
  getGeneratedRehabProtocolSlug,
  inferGeneratedBodyRegion,
  inferGeneratedRecoveryWindow,
  type RehabExerciseRow,
  type RehabPhaseRow,
  type RehabProtocolRow,
} from './generatedRehabProtocolSource';
import {decodeMojibake} from './textEncoding';
import type {Language} from './translations';

export type {RehabProtocolRow, RehabPhaseRow, RehabExerciseRow};
export {getGeneratedRehabProtocolRows};

type RehabProtocolDataSource = 'supabase' | 'generated';

type LocalNutritionMatch = InjuryProtocol & {
  score: number;
};

let lastRehabProtocolSource: RehabProtocolDataSource = 'generated';

function cleanText(value: string | null | undefined) {
  return value ? decodeMojibake(value).trim() : '';
}

function cleanList(value: string[] | null | undefined) {
  return (value || []).map((item) => cleanText(item)).filter(Boolean);
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

function buildOverview(name: string, category: string, phaseCount: number) {
  const region = inferGeneratedBodyRegion(category);
  return `${cleanText(name)} is a structured rehab protocol for the ${region.toLowerCase()} with ${phaseCount} staged rehab phase${phaseCount === 1 ? '' : 's'}.`;
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
    if (remoteBodyRegion === local.bodyRegion) score += 2;

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

function buildProtocolFromRows(
  protocolRow: RehabProtocolRow,
  phaseRows: RehabPhaseRow[],
  exerciseRows: RehabExerciseRow[],
  lang: Language,
): InjuryProtocol {
  const localNutritionMatch = findBestLocalNutritionMatch(protocolRow.name, protocolRow.category);
  const bodyRegion = localNutritionMatch?.bodyRegion || inferGeneratedBodyRegion(protocolRow.category);
  const category = localNutritionMatch?.category || cleanText(protocolRow.category) || bodyRegion;

  const exercisesByPhaseId = new Map<number, RehabExerciseRow[]>();
  exerciseRows.forEach((exercise) => {
    const bucket = exercisesByPhaseId.get(exercise.phase_id) || [];
    bucket.push(exercise);
    exercisesByPhaseId.set(exercise.phase_id, bucket);
  });

  const mappedPhases: InjuryPhase[] = phaseRows.map((phase, index) => {
    const phaseExercises = exercisesByPhaseId.get(phase.id) || [];
    const nutrition = mapPhaseNutrition(phase.phase_number, localNutritionMatch, lang);

    return {
      id: `protocol-${protocolRow.id}-phase-${index + 1}`,
      label: cleanText(phase.title),
      duration: cleanText(phase.timeline),
      window: inferGeneratedRecoveryWindow(cleanText(phase.timeline), phase.phase_number, phaseRows.length),
      goals: cleanList(phase.goals),
      nutritionFocus: nutrition.nutritionFocus,
      recommendedFoods: nutrition.recommendedFoods,
      avoidFoods: nutrition.avoidFoods,
      supplements: nutrition.supplements,
      exercises: phaseExercises.map((exercise) => cleanText(exercise.name)),
      prohibitedMovements: nutrition.prohibitedMovements,
      exercisePlans: phaseExercises.map((exercise) => ({
        label: cleanText(exercise.name),
        sets: cleanText(exercise.parameters) || undefined,
        cues: cleanText(exercise.clinical_cue_rationale) ? [cleanText(exercise.clinical_cue_rationale)] : [],
      })),
      focus: index === 0 ? buildOverview(protocolRow.name, protocolRow.category, phaseRows.length) : undefined,
      progressionMarkers: cleanList(phase.criteria_to_progress),
      cautions: cleanList(phase.precautions),
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

  return {
    id: getGeneratedRehabProtocolSlug(protocolRow.name).replace(/-/g, '_'),
    name: cleanText(protocolRow.name),
    category: category as InjuryProtocol['category'],
    bodyRegion: bodyRegion as InjuryProtocol['bodyRegion'],
    commonIn: [],
    overview: buildOverview(protocolRow.name, protocolRow.category, mappedPhases.length),
    rehabSummary: mappedPhases.length
      ? `Structured ${mappedPhases.length}-phase rehab progression with goals, precautions, and exercise cues.`
      : 'Structured rehab progression.',
    redFlags: [],
    relatedCalculators: ['Protein intake', 'Water intake'],
    safetyNotes: localNutritionMatch?.safetyNotes || {medications: [], supplements: []},
    contraindications: localNutritionMatch?.contraindications || {medications: [], supplements: []},
    phases: mappedPhases,
    pageContent: localNutritionMatch?.pageContent
      ? {
          intro: localNutritionMatch.pageContent.intro,
          symptoms: localNutritionMatch.pageContent.symptoms,
          faq: localNutritionMatch.pageContent.faq,
          rehabNotes: localNutritionMatch.pageContent.rehabNotes,
          nutritionNotes: localNutritionMatch.pageContent.nutritionNotes,
        }
      : undefined,
  };
}

function getSupabaseClient() {
  return supabase;
}

export function getRehabProtocolSlug(name: string) {
  return getGeneratedRehabProtocolSlug(name);
}

export function getLastRehabProtocolSource() {
  return lastRehabProtocolSource;
}

export type RehabProtocolInsert = TableInsert<'protocols'>;
export type RehabProtocolUpdate = TableUpdate<'protocols'>;
export type RehabPhaseInsert = TableInsert<'phases'>;
export type RehabPhaseUpdate = TableUpdate<'phases'>;
export type RehabExerciseInsert = TableInsert<'exercises'>;
export type RehabExerciseUpdate = TableUpdate<'exercises'>;

export async function fetchRehabProtocolsFromSupabase(): Promise<RehabProtocolRow[]> {
  const db = getSupabaseClient();
  if (!db) {
    lastRehabProtocolSource = 'generated';
    return getGeneratedRehabProtocolRows();
  }

  try {
    const {data, error} = await db.from('protocols').select('*').order('id', {ascending: true});
    if (error) throw error;
    if (data?.length) {
      lastRehabProtocolSource = 'supabase';
      return data;
    }
  } catch (error) {
    console.warn('Falling back to generated rehab protocol rows.', error);
  }

  lastRehabProtocolSource = 'generated';
  return getGeneratedRehabProtocolRows();
}

export async function fetchRehabProtocolBySlug(slug: string): Promise<RehabProtocolRow | null> {
  const rows = await fetchRehabProtocolsFromSupabase();
  return rows.find((row) => getGeneratedRehabProtocolSlug(row.name) === slug) || null;
}

export async function fetchRehabPhasesByProtocolId(protocolId: number): Promise<RehabPhaseRow[]> {
  const db = getSupabaseClient();
  if (!db || lastRehabProtocolSource !== 'supabase') {
    return getGeneratedRehabPhaseRows(protocolId);
  }

  try {
    const {data, error} = await db
      .from('phases')
      .select('*')
      .eq('protocol_id', protocolId)
      .order('phase_number', {ascending: true})
      .order('id', {ascending: true});

    if (error) throw error;
    return data || [];
  } catch (error) {
    console.warn(`Falling back to generated rehab phase rows for protocol ${protocolId}.`, error);
    lastRehabProtocolSource = 'generated';
    return getGeneratedRehabPhaseRows(protocolId);
  }
}

export async function fetchRehabExercisesByPhaseIds(phaseIds: number[]): Promise<RehabExerciseRow[]> {
  const db = getSupabaseClient();
  if (!db || lastRehabProtocolSource !== 'supabase' || !phaseIds.length) {
    return getGeneratedRehabExerciseRows(phaseIds);
  }

  try {
    const {data, error} = await db
      .from('exercises')
      .select('*')
      .in('phase_id', phaseIds)
      .order('id', {ascending: true});

    if (error) throw error;
    return data || [];
  } catch (error) {
    console.warn('Falling back to generated rehab exercise rows.', error);
    lastRehabProtocolSource = 'generated';
    return getGeneratedRehabExerciseRows(phaseIds);
  }
}

export async function fetchCompleteRehabProtocol(
  slug: string,
  lang: Language = 'en',
  protocolRows?: RehabProtocolRow[],
): Promise<InjuryProtocol | null> {
  // Detail pages commonly already requested the catalog. Reuse those rows so
  // opening a protocol does not issue a second full protocols-table request.
  const protocolRow = protocolRows
    ? protocolRows.find((row) => getGeneratedRehabProtocolSlug(row.name) === slug) || null
    : await fetchRehabProtocolBySlug(slug);
  if (!protocolRow) {
    lastRehabProtocolSource = 'generated';
    return getGeneratedInjuryProtocolBySlug(slug, lang);
  }

  if (lastRehabProtocolSource !== 'supabase') {
    return getGeneratedInjuryProtocolBySlug(slug, lang);
  }

  const phaseRows = await fetchRehabPhasesByProtocolId(protocolRow.id);
  const exerciseRows = await fetchRehabExercisesByPhaseIds(phaseRows.map((phase) => phase.id));
  return buildProtocolFromRows(protocolRow, phaseRows, exerciseRows, lang);
}

function ensureSupabase() {
  if (!supabase) {
    throw new Error('Supabase is not configured.');
  }

  return supabase;
}

export async function createRehabProtocol(data: RehabProtocolInsert) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('protocols') as any).insert([data as any]).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabProtocolRow;
}

export async function updateRehabProtocol(id: number, data: RehabProtocolUpdate) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('protocols') as any).update(data as any).eq('id', id).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabProtocolRow;
}

export async function deleteRehabProtocol(id: number) {
  const db = ensureSupabase();
  const {error} = await db.from('protocols').delete().eq('id', id);
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
}

export async function createRehabPhase(data: RehabPhaseInsert) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('phases') as any).insert([data as any]).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabPhaseRow;
}

export async function updateRehabPhase(id: number, data: RehabPhaseUpdate) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('phases') as any).update(data as any).eq('id', id).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabPhaseRow;
}

export async function deleteRehabPhase(id: number) {
  const db = ensureSupabase();
  const {error} = await db.from('phases').delete().eq('id', id);
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
}

export async function createRehabExercise(data: RehabExerciseInsert) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('exercises') as any).insert([data as any]).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabExerciseRow;
}

export async function updateRehabExercise(id: number, data: RehabExerciseUpdate) {
  const db = ensureSupabase();
  const {data: result, error} = await (db.from('exercises') as any).update(data as any).eq('id', id).select().single();
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
  return result as RehabExerciseRow;
}

export async function deleteRehabExercise(id: number) {
  const db = ensureSupabase();
  const {error} = await db.from('exercises').delete().eq('id', id);
  if (error) throw error;
  lastRehabProtocolSource = 'supabase';
}
