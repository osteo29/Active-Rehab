/**
 * Supabase Injury Management Service
 * Centralized API for managing injury protocols, phases, supplements, and meals
 */

import {supabase} from '../lib/supabase';
import type {TableInsert, TableRow, TableUpdate} from '../lib/supabaseDatabase';
import type {
  InjuryProtocol,
  InjuryPhase,
  InjuryPageContentData,
  SupplementProtocol,
  MealExamples,
} from './injuryDatabase';
import type {Language} from './translations';
import type {ImportedInjuryProtocol, ProtocolImportSummary} from './injuryProtocolImport';
import {getAllInjuries, type RecoveryWindow} from './injuryDatabase';
import {MedicalTextCore} from './textEncoding';

function getSupabaseClient() {
  if (!supabase) {
    throw new Error('Supabase is not configured.');
  }

  return supabase;
}

export type InjuryRow = TableRow<'injuries'>;
export type InjuryInsert = TableInsert<'injuries'>;
export type InjuryUpdate = TableUpdate<'injuries'>;

export type PhaseRow = TableRow<'injury_phases'>;
export type PhaseInsert = TableInsert<'injury_phases'>;
export type PhaseUpdate = TableUpdate<'injury_phases'>;

export type SupplementRow = TableRow<'supplements'>;
export type SupplementInsert = TableInsert<'supplements'>;
export type SupplementUpdate = TableUpdate<'supplements'>;

export type MealRow = TableRow<'meal_examples'>;
export type MealInsert = TableInsert<'meal_examples'>;
export type MealUpdate = TableUpdate<'meal_examples'>;

export type SafetyNotesRow = TableRow<'safety_notes'>;
export type InjuryPageContentRow = TableRow<'injury_page_content'>;

/**
 * Fetch all injuries from Supabase
 */
export async function fetchInjuriesFromSupabase(): Promise<InjuryRow[]> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('injuries')
      .select('*')
      .order('name_en');

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error('Error fetching injuries:', err);
    return [];
  }
}

/**
 * Fetch specific injury by slug
 */
export async function fetchInjuryBySlug(slug: string): Promise<InjuryRow | null> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('injuries')
      .select('*')
      .in('injury_id_slug', [slug, slug.replace(/-/g, '_'), slug.replace(/_/g, '-')])
      .maybeSingle();

    if (error) throw error;
    return data ? MedicalTextCore.parseDeep(data) : null;
  } catch (err) {
    console.error(`Error fetching injury ${slug}:`, err);
    return null;
  }
}

/**
 * Fetch phases for an injury
 */
export async function fetchPhasesByInjuryId(injuryId: string): Promise<PhaseRow[]> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('injury_phases')
      .select('*')
      .eq('injury_id', injuryId)
      .order('phase_number');

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error(`Error fetching phases for injury ${injuryId}:`, err);
    return [];
  }
}

/**
 * Fetch supplements for a phase
 */
export async function fetchSupplementsByPhaseId(phaseId: string): Promise<SupplementRow[]> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('supplements')
      .select('*')
      .eq('phase_id', phaseId)
      .order('order_index');

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error(`Error fetching supplements for phase ${phaseId}:`, err);
    return [];
  }
}

/**
 * Fetch supplements for several phases in one request. Complete-protocol
 * loading uses this to avoid one network round trip per phase.
 */
export async function fetchSupplementsByPhaseIds(phaseIds: string[]): Promise<SupplementRow[]> {
  if (!phaseIds.length) return [];

  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('supplements')
      .select('*')
      .in('phase_id', phaseIds)
      .order('phase_id')
      .order('order_index');

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error('Error fetching supplements for phases:', err);
    return [];
  }
}

/**
 * Fetch meal examples for a phase
 */
export async function fetchMealsByPhaseId(phaseId: string): Promise<MealRow[]> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('meal_examples')
      .select('*')
      .eq('phase_id', phaseId);

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error(`Error fetching meals for phase ${phaseId}:`, err);
    return [];
  }
}

/**
 * Fetch meal examples for several phases in one request. Keeping this batched
 * prevents complete protocol views from producing an N+1 request pattern.
 */
export async function fetchMealsByPhaseIds(phaseIds: string[]): Promise<MealRow[]> {
  if (!phaseIds.length) return [];

  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('meal_examples')
      .select('*')
      .in('phase_id', phaseIds)
      .order('phase_id');

    if (error) throw error;
    return MedicalTextCore.parseDeep(data || []);
  } catch (err) {
    console.error('Error fetching meals for phases:', err);
    return [];
  }
}

export async function fetchSafetyNotesByInjuryId(injuryId: string): Promise<SafetyNotesRow | null> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('safety_notes')
      .select('*')
      .eq('injury_id', injuryId)
      .maybeSingle();

    if (error) throw error;
    return data ? MedicalTextCore.parseDeep(data) : null;
  } catch (err) {
    console.error(`Error fetching safety notes for injury ${injuryId}:`, err);
    return null;
  }
}

export async function fetchInjuryPageContentByInjuryId(injuryId: string): Promise<InjuryPageContentRow | null> {
  try {
    const db = getSupabaseClient();
    const { data, error } = await db
      .from('injury_page_content')
      .select('*')
      .eq('injury_id', injuryId)
      .maybeSingle();

    if (error) throw error;
    return data ? MedicalTextCore.parseDeep(data) : null;
  } catch (err) {
    console.error(`Error fetching page content for injury ${injuryId}:`, err);
    return null;
  }
}

/**
 * Fetch complete injury protocol with all related data
 */
export async function fetchCompleteInjuryProtocol(
  slug: string,
  lang: Language = 'en'
): Promise<InjuryProtocol | null> {
  try {
    const injury = await fetchInjuryBySlug(slug);
    if (!injury) return null;

    const [phases, safetyNotes, pageContent] = await Promise.all([
      fetchPhasesByInjuryId(injury.id),
      fetchSafetyNotesByInjuryId(injury.id),
      fetchInjuryPageContentByInjuryId(injury.id),
    ]);
    const useArabic = lang === 'ar';
    const normalizeList = (value: unknown): string[] => {
      if (Array.isArray(value)) {
        return value.map((v) => (typeof v === 'string' ? v.trim() : '')).filter(Boolean);
      }
      if (typeof value === 'string') {
        return value
          .split('\n')
          .map((item) => item.trim())
          .filter(Boolean);
      }
      return [];
    };
    const pickLocalizedList = (arabicValue: unknown, englishValue: unknown): string[] => {
      const englishList = normalizeList(englishValue);
      const arabicList = normalizeList(arabicValue);
      return useArabic && arabicList.length ? arabicList : englishList;
    };

    // Batch related records rather than making two requests for every phase.
    const phaseIds = phases.map((phase) => phase.id);
    const [allSupplements, allMeals] = await Promise.all([
      fetchSupplementsByPhaseIds(phaseIds),
      fetchMealsByPhaseIds(phaseIds),
    ]);
    const supplementsByPhaseId = new Map<string, SupplementRow[]>();
    const mealsByPhaseId = new Map<string, MealRow[]>();

    allSupplements.forEach((supplement) => {
      const items = supplementsByPhaseId.get(supplement.phase_id) || [];
      items.push(supplement);
      supplementsByPhaseId.set(supplement.phase_id, items);
    });
    allMeals.forEach((meal) => {
      const items = mealsByPhaseId.get(meal.phase_id) || [];
      items.push(meal);
      mealsByPhaseId.set(meal.phase_id, items);
    });

    const phasesWithData = phases.map((phase) => {
        const supplements = supplementsByPhaseId.get(phase.id) || [];
        const mealRows = mealsByPhaseId.get(phase.id) || [];

        // Convert supplements
        const supplementsConverted: SupplementProtocol[] = supplements.map((s) => ({
          name: s.name,
          dose: useArabic ? s.dose_ar || s.dose_en : s.dose_en,
          reason: useArabic ? s.reason_ar || s.reason_en : s.reason_en,
          timing: useArabic ? s.timing_ar || s.timing_en || undefined : s.timing_en || undefined,
          caution: useArabic ? s.caution_ar || s.caution_en || undefined : s.caution_en || undefined,
        }));

        // Convert meals (taking first or default diet type)
        const mealData = mealRows[0];
        const mealsConverted: MealExamples = mealData
          ? {
              breakfast: useArabic ? mealData.breakfast_ar || mealData.breakfast_en : mealData.breakfast_en,
              lunch: useArabic ? mealData.lunch_ar || mealData.lunch_en : mealData.lunch_en,
              dinner: useArabic ? mealData.dinner_ar || mealData.dinner_en : mealData.dinner_en,
              snack: useArabic
                ? mealData.snack_ar || mealData.snack_en || undefined
                : mealData.snack_en || undefined,
              shoppingList: useArabic
                ? mealData.shopping_list_ar?.length
                  ? mealData.shopping_list_ar
                  : mealData.shopping_list_en
                : mealData.shopping_list_en,
            }
          : {
              breakfast: '',
              lunch: '',
              dinner: '',
              shoppingList: [],
            };

        return {
          id: phase.id,
          label: useArabic ? phase.label_ar || phase.label_en : phase.label_en,
          duration: useArabic ? phase.duration_ar || phase.duration_en : phase.duration_en,
          window: phase.recovery_window as any,
          goals: pickLocalizedList(phase.goals_ar, phase.goals_en),
          nutritionFocus: pickLocalizedList(phase.nutrition_focus_ar, phase.nutrition_focus_en),
          recommendedFoods: pickLocalizedList(phase.recommended_foods_ar, phase.recommended_foods_en),
          avoidFoods: pickLocalizedList(phase.avoid_foods_ar, phase.avoid_foods_en),
          supplements: supplementsConverted,
          exercises: pickLocalizedList(phase.exercises_ar, phase.exercises_en),
          prohibitedMovements: pickLocalizedList(phase.prohibited_movements_ar, phase.prohibited_movements_en),
          exercisePlans: (phase.exercise_plans || []).map((p: any) => ({
            label: useArabic
              ? (p?.label_ar ?? p?.exercise_ar ?? p?.label_en ?? p?.exercise_en ?? '')
              : (p?.label_en ?? p?.exercise_en ?? p?.label_ar ?? p?.exercise_ar ?? ''),
            sets: p?.sets ?? undefined,
            reps: p?.reps ?? undefined,
            rest: p?.rest ?? undefined,
            equipment: useArabic ? p?.equipment_ar ?? p?.equipment_en ?? p?.equipment ?? undefined : p?.equipment_en ?? p?.equipment_ar ?? p?.equipment ?? undefined,
            alternatives: useArabic ? normalizeList(p?.alternatives_ar ?? p?.alternatives) : normalizeList(p?.alternatives_en ?? p?.alternatives),
            cues: useArabic ? normalizeList(p?.cues_ar ?? p?.cues) : normalizeList(p?.cues_en ?? p?.cues),
          })),
          focus: (useArabic ? phase.focus_ar : phase.focus_en) || undefined,
          progressionMarkers: pickLocalizedList(phase.progression_markers_ar, phase.progression_markers_en),
          cautions: pickLocalizedList(phase.cautions_ar, phase.cautions_en),
          nutritionNotes: pickLocalizedList(phase.nutrition_notes_ar, phase.nutrition_notes_en),
          meals: mealsConverted,
          proteinPerKg:
            phase.protein_min_per_kg && phase.protein_max_per_kg
              ? {
                  min: Number(phase.protein_min_per_kg),
                  max: Number(phase.protein_max_per_kg),
                }
              : undefined,
          hydrationMlPerKg: phase.hydration_ml_per_kg || undefined,
          omega3Grams: phase.omega3_grams ? Number(phase.omega3_grams) : undefined,
          creatineGrams: phase.creatine_grams ? Number(phase.creatine_grams) : undefined,
          collagenPerKg:
            phase.collagen_min_per_kg && phase.collagen_max_per_kg
              ? {
                  min: Number(phase.collagen_min_per_kg),
                  max: Number(phase.collagen_max_per_kg),
                }
              : undefined,
          vitaminCMg: phase.vitamin_c_mg || undefined,
          calciumMg: phase.calcium_mg || undefined,
        } as InjuryPhase;
      });

    const faqItems = Array.isArray(pageContent?.faq_items) ? pageContent.faq_items : [];
    const mappedPageContent: InjuryPageContentData | undefined =
      pageContent
        ? {
            intro: useArabic ? pageContent.intro_ar || pageContent.intro_en || undefined : pageContent.intro_en || undefined,
            symptoms:
              useArabic && pageContent.symptoms_ar?.length
                ? pageContent.symptoms_ar
                : pageContent.symptoms_en || [],
            rehabNotes:
              useArabic && pageContent.rehab_notes_ar?.length
                ? pageContent.rehab_notes_ar
                : pageContent.rehab_notes_en || [],
            nutritionNotes:
              useArabic && pageContent.nutrition_notes_ar?.length
                ? pageContent.nutrition_notes_ar
                : pageContent.nutrition_notes_en || [],
            faq: faqItems
              .map((item) => {
                if (!item || typeof item !== 'object') return null;
                const faqObj = item as any;
                const qEn = typeof faqObj.q_en === 'string' ? faqObj.q_en : typeof faqObj.q === 'string' ? faqObj.q : '';
                const aEn = typeof faqObj.a_en === 'string' ? faqObj.a_en : typeof faqObj.a === 'string' ? faqObj.a : '';
                const qAr = typeof faqObj.q_ar === 'string' ? faqObj.q_ar : qEn;
                const aAr = typeof faqObj.a_ar === 'string' ? faqObj.a_ar : aEn;
                const q = useArabic ? qAr || qEn : qEn || qAr;
                const a = useArabic ? aAr || aEn : aEn || aAr;
                return q && a ? {q, a} : null;
              })
              .filter(Boolean) as Array<{q: string; a: string}>,
          }
        : undefined;

    const protocol: InjuryProtocol = {
      id: injury.injury_id_slug,
      name: useArabic ? injury.name_ar || injury.name_en : injury.name_en,
      category: injury.category as any,
      bodyRegion: (useArabic ? injury.body_region_ar || injury.body_region_en : injury.body_region_en) as any,
      commonIn: normalizeList(injury.common_in),
      overview: useArabic ? injury.overview_ar || injury.overview_en : injury.overview_en,
      rehabSummary: useArabic ? injury.rehab_summary_ar || injury.rehab_summary_en : injury.rehab_summary_en,
      redFlags: normalizeList(injury.red_flags),
      relatedCalculators: normalizeList(injury.related_calculators),
      safetyNotes: {
        medications:
          pickLocalizedList(safetyNotes?.medications_ar, safetyNotes?.medications_en),
        supplements:
          pickLocalizedList(safetyNotes?.supplements_ar, safetyNotes?.supplements_en),
      },
      phases: phasesWithData,
      pageContent: mappedPageContent,
    };

    return MedicalTextCore.parseDeep(protocol);
  } catch (err) {
    console.error(`Error fetching complete protocol for ${slug}:`, err);
    return null;
  }
}

/**
 * ADMIN: Create new injury
 */
export async function createInjury(data: InjuryInsert) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('injuries') as any)
      .insert([data])
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error creating injury:', err);
    throw err;
  }
}

/**
 * ADMIN: Update injury
 */
export async function updateInjury(id: string, data: InjuryUpdate) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('injuries') as any)
      .update(data as any)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error updating injury:', err);
    throw err;
  }
}

/**
 * ADMIN: Delete injury (cascades to phases, supplements, meals)
 */
export async function deleteInjury(id: string) {
  try {
    const db = getSupabaseClient();
    const { error } = await db.from('injuries').delete().eq('id', id);

    if (error) throw error;
    return true;
  } catch (err) {
    console.error('Error deleting injury:', err);
    throw err;
  }
}

// ==========================================================================
// PHASES
// ==========================================================================

/**
 * ADMIN: Create phase
 */
export async function createPhase(data: PhaseInsert) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('injury_phases') as any)
      .insert([data])
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error creating phase:', err);
    throw err;
  }
}

/**
 * ADMIN: Update phase
 */
export async function updatePhase(id: string, data: PhaseUpdate) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('injury_phases') as any)
      .update(data as any)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error updating phase:', err);
    throw err;
  }
}

/**
 * ADMIN: Delete phase
 */
export async function deletePhase(id: string) {
  try {
    const db = getSupabaseClient();
    const { error } = await db.from('injury_phases').delete().eq('id', id);

    if (error) throw error;
    return true;
  } catch (err) {
    console.error('Error deleting phase:', err);
    throw err;
  }
}

// ==========================================================================
// SUPPLEMENTS
// ==========================================================================

/**
 * ADMIN: Create supplement
 */
export async function createSupplement(
  data: SupplementInsert
) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('supplements') as any)
      .insert([data])
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error creating supplement:', err);
    throw err;
  }
}

/**
 * ADMIN: Update supplement
 */
export async function updateSupplement(id: string, data: SupplementUpdate) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('supplements') as any)
      .update(data as any)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error updating supplement:', err);
    throw err;
  }
}

/**
 * ADMIN: Delete supplement
 */
export async function deleteSupplement(id: string) {
  try {
    const db = getSupabaseClient();
    const { error } = await db.from('supplements').delete().eq('id', id);

    if (error) throw error;
    return true;
  } catch (err) {
    console.error('Error deleting supplement:', err);
    throw err;
  }
}

// ==========================================================================
// MEALS
// ==========================================================================

/**
 * ADMIN: Create meal
 */
export async function createMeal(data: MealInsert) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('meal_examples') as any)
      .insert([data])
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error creating meal:', err);
    throw err;
  }
}

/**
 * ADMIN: Update meal
 */
export async function updateMeal(id: string, data: MealUpdate) {
  try {
    const db = getSupabaseClient();
    const { data: result, error } = await (db.from('meal_examples') as any)
      .update(data as any)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return result;
  } catch (err) {
    console.error('Error updating meal:', err);
    throw err;
  }
}

/**
 * ADMIN: Delete meal
 */
export async function deleteMeal(id: string) {
  try {
    const db = getSupabaseClient();
    const { error } = await db.from('meal_examples').delete().eq('id', id);

    if (error) throw error;
    return true;
  } catch (err) {
    console.error('Error deleting meal:', err);
    throw err;
  }
}

export async function upsertSafetyNotes(injuryId: string, data: Omit<TableInsert<'safety_notes'>, 'id' | 'injury_id' | 'created_at' | 'updated_at'>) {
  try {
    const db = getSupabaseClient();
    const { data: existing } = await db.from('safety_notes').select('id').eq('injury_id', injuryId).maybeSingle() as { data: { id: string } | null };
    
    if (existing) {
      const { data: result, error } = await (db.from('safety_notes') as any).update(data as any).eq('id', existing.id).select().single();
      if (error) throw error;
      return result;
    } else {
      const { data: result, error } = await (db.from('safety_notes') as any).insert([{ injury_id: injuryId, ...data }]).select().single();
      if (error) throw error;
      return result;
    }
  } catch (err) {
    console.error('Error upserting safety notes:', err);
    throw err;
  }
}

export async function upsertInjuryPageContent(injuryId: string, data: Omit<TableInsert<'injury_page_content'>, 'id' | 'injury_id' | 'created_at' | 'updated_at'>) {
  try {
    const db = getSupabaseClient();
    const { data: existing } = await db.from('injury_page_content').select('id').eq('injury_id', injuryId).maybeSingle() as { data: { id: string } | null };
    
    if (existing) {
      const { data: result, error } = await (db.from('injury_page_content') as any).update(data as any).eq('id', existing.id).select().single();
      if (error) throw error;
      return result;
    } else {
      const { data: result, error } = await (db.from('injury_page_content') as any).insert([{ injury_id: injuryId, ...data }]).select().single();
      if (error) throw error;
      return result;
    }
  } catch (err) {
    console.error('Error upserting injury page content:', err);
    throw err;
  }
}

type ImportRunStatus = 'preview' | 'imported' | 'failed';

export type InjuryProtocolImportRunRow = {
  id: string;
  source_name: string | null;
  raw_text: string;
  parsed_count: number;
  matched_count: number;
  unmatched_count: number;
  imported_slugs: string[];
  unmatched_titles: string[];
  status: ImportRunStatus;
  notes: string | null;
  created_by: string | null;
  created_by_email: string | null;
  created_at: string;
  updated_at: string;
};

function formatImportPermissionError(error: unknown) {
  const code = (error as any)?.code;
  const message = (error as any)?.message || String(error);
  if (code === '42501' || message.toLowerCase().includes('policy')) {
    return 'Permission denied. Ensure you are signed in and have admin rights.';
  }
  return message;
}

function inferRecoveryWindow(phaseNumber: number): RecoveryWindow {
  if (phaseNumber <= 1) return 'under_48h';
  if (phaseNumber === 2) return 'days_3_14';
  if (phaseNumber === 3) return 'weeks_2_6';
  return 'over_6_weeks';
}

function getLocalProtocolMap() {
  return new Map(getAllInjuries().map((injury) => [injury.id, injury]));
}

function stripParentheticalAcronyms(value: string) {
  return value.replace(/\(([A-Z]{2,8})\)/g, ' ');
}

function normalizeImportValue(value: string) {
  return value
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[()[\]{}]/g, ' ')
    .replace(/[^a-z0-9\s]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function normalizeAliasImportValue(value: string) {
  return normalizeImportValue(stripParentheticalAcronyms(value))
    .split(' ')
    .filter((word) => !['syndrome', 'disorder', 'pain'].includes(word))
    .join(' ')
    .trim();
}

function slugifyImportTitle(value: string) {
  const normalized = normalizeImportValue(value);
  return normalized ? normalized.replace(/\s+/g, '_') : 'imported_protocol';
}

function titleCaseWords(value: string) {
  return value
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ');
}

function inferBodyRegionFromHeading(heading: string) {
  const match = heading.match(/^([A-Z][A-Z\s/&-]+?)\s+\d+\./);
  return match?.[1] ? titleCaseWords(match[1].replace(/[&/-]+/g, ' ')) : 'Imported protocol';
}

function shouldReuseMatchedSlug(imported: ImportedInjuryProtocol, localProtocol?: InjuryProtocol) {
  if (!imported.matchedSlug || !localProtocol) return false;

  const sourceTitle = normalizeImportValue(imported.sourceTitle);
  const localName = normalizeImportValue(localProtocol.name);
  const localId = normalizeImportValue(localProtocol.id.replace(/_/g, ' '));

  if (sourceTitle === localName || sourceTitle === localId) return true;

  const sourceAlias = normalizeAliasImportValue(imported.sourceTitle);
  const localNameAlias = normalizeAliasImportValue(localProtocol.name);
  const localIdAlias = normalizeAliasImportValue(localProtocol.id.replace(/_/g, ' '));

  return sourceAlias === localNameAlias || sourceAlias === localIdAlias;
}

function buildProtocolSlug(
  imported: ImportedInjuryProtocol,
  localProtocol: InjuryProtocol | undefined,
  remoteBySlug: Map<string, InjuryRow>,
  usedSlugs: Set<string>,
) {
  if (imported.requestedSlug) return imported.requestedSlug.trim().toLowerCase();
  if (shouldReuseMatchedSlug(imported, localProtocol) && imported.matchedSlug) return imported.matchedSlug;

  const baseSlug = slugifyImportTitle(imported.sourceTitle);
  let slug = baseSlug;
  let counter = 2;

  while (usedSlugs.has(slug) && !remoteBySlug.has(slug)) {
    slug = `${baseSlug}_${counter}`;
    counter += 1;
  }

  return slug;
}

function buildFallbackInjuryInsert(slug: string, sourceTitle: string, heading: string): InjuryInsert {
  const bodyRegion = inferBodyRegionFromHeading(heading);

  return {
    injury_id_slug: slug,
    name_en: sourceTitle,
    name_ar: sourceTitle,
    category: bodyRegion,
    body_region_en: bodyRegion,
    body_region_ar: bodyRegion,
    overview_en: `Imported protocol for ${sourceTitle}.`,
    overview_ar: `Imported protocol for ${sourceTitle}.`,
    rehab_summary_en: 'Imported from bulk protocol workflow.',
    rehab_summary_ar: 'Imported from bulk protocol workflow.',
    common_in: [],
    red_flags: [],
    related_calculators: [],
  };
}

function buildLocalInjuryInsert(injury: InjuryProtocol, overrideSlug?: string): InjuryInsert {
  return {
    injury_id_slug: overrideSlug || injury.id,
    name_en: injury.name,
    name_ar: injury.name,
    category: injury.category,
    body_region_en: injury.bodyRegion,
    body_region_ar: injury.bodyRegion,
    overview_en: injury.overview,
    overview_ar: injury.overview,
    rehab_summary_en: injury.rehabSummary,
    rehab_summary_ar: injury.rehabSummary,
    common_in: injury.commonIn,
    red_flags: injury.redFlags,
    related_calculators: injury.relatedCalculators,
  };
}

function parsePrescriptionDetails(prescription: string | undefined) {
  if (!prescription) {
    return {
      prescription: null,
      sets: null,
      reps: null,
      rest: null,
      cue: null,
    };
  }

  const cleaned = prescription.trim();
  const setsRepsMatch = cleaned.match(/(\d+)\s*x\s*(\d+(?:\s*-\s*\d+)?)(?:\s*(reps?))?/i);
  const restMatch = cleaned.match(/(\d+\s*(?:sec|secs|seconds|min|mins|minutes))(?:\s*(?:rest|hold))?/i);

  let cue = cleaned;
  if (setsRepsMatch?.[0]) {
    cue = cue.replace(setsRepsMatch[0], '').trim();
  }
  if (restMatch?.[0]) {
    cue = cue.replace(restMatch[0], '').trim();
  }
  cue = cue.replace(/^[-,:;\s]+/, '').trim();

  return {
    prescription: cleaned,
    sets: setsRepsMatch?.[1] || null,
    reps: setsRepsMatch ? `${setsRepsMatch[2]}${setsRepsMatch[3] ? ` ${setsRepsMatch[3]}` : ''}` : null,
    rest: restMatch?.[1] || null,
    cue: cue || null,
  };
}

function buildPhasePayload(
  injuryId: string,
  phaseNumber: number,
  importedPhase: ImportedInjuryProtocol['phases'][number],
  existingPhase?: PhaseRow,
  basePhase?: InjuryPhase,
): PhaseInsert | PhaseUpdate {
  const fallbackLabel = importedPhase.label || basePhase?.label || `Phase ${phaseNumber}`;
  const fallbackDuration = importedPhase.duration || basePhase?.duration || '';
  const fallbackWindow = existingPhase?.recovery_window || basePhase?.window || inferRecoveryWindow(phaseNumber);

  return {
    injury_id: injuryId,
    phase_number: phaseNumber,
    label_en: importedPhase.label || existingPhase?.label_en || basePhase?.label || fallbackLabel,
    label_ar: existingPhase?.label_ar || importedPhase.label || basePhase?.label || fallbackLabel,
    duration_en: importedPhase.duration || existingPhase?.duration_en || basePhase?.duration || fallbackDuration,
    duration_ar: existingPhase?.duration_ar || importedPhase.duration || basePhase?.duration || fallbackDuration,
    recovery_window: fallbackWindow,
    goals_en: importedPhase.goals.length ? importedPhase.goals : existingPhase?.goals_en || basePhase?.goals || [],
    goals_ar: existingPhase?.goals_ar || basePhase?.goals || importedPhase.goals,
    nutrition_focus_en: existingPhase?.nutrition_focus_en || basePhase?.nutritionFocus || [],
    nutrition_focus_ar: existingPhase?.nutrition_focus_ar || basePhase?.nutritionFocus || [],
    recommended_foods_en: existingPhase?.recommended_foods_en || basePhase?.recommendedFoods || [],
    recommended_foods_ar: existingPhase?.recommended_foods_ar || basePhase?.recommendedFoods || [],
    avoid_foods_en: existingPhase?.avoid_foods_en || basePhase?.avoidFoods || [],
    avoid_foods_ar: existingPhase?.avoid_foods_ar || basePhase?.avoidFoods || [],
    focus_en: existingPhase?.focus_en || basePhase?.focus || '',
    focus_ar: existingPhase?.focus_ar || basePhase?.focus || '',
    progression_markers_en: importedPhase.progressionMarkers.length
      ? importedPhase.progressionMarkers
      : existingPhase?.progression_markers_en || basePhase?.progressionMarkers || [],
    progression_markers_ar: existingPhase?.progression_markers_ar || basePhase?.progressionMarkers || importedPhase.progressionMarkers,
    cautions_en: importedPhase.cautions.length ? importedPhase.cautions : existingPhase?.cautions_en || basePhase?.cautions || [],
    cautions_ar: existingPhase?.cautions_ar || basePhase?.cautions || importedPhase.cautions,
    nutrition_notes_en: existingPhase?.nutrition_notes_en || basePhase?.nutritionNotes || [],
    nutrition_notes_ar: existingPhase?.nutrition_notes_ar || basePhase?.nutritionNotes || [],
    exercise_plans: importedPhase.exercisePlans.length ? importedPhase.exercisePlans : existingPhase?.exercise_plans || basePhase?.exercisePlans || [],
    exercises_en: importedPhase.exercises.length ? importedPhase.exercises : existingPhase?.exercises_en || basePhase?.exercises || [],
    exercises_ar: existingPhase?.exercises_ar || basePhase?.exercises || importedPhase.exercises,
    prohibited_movements_en: existingPhase?.prohibited_movements_en || basePhase?.prohibitedMovements || [],
    prohibited_movements_ar: existingPhase?.prohibited_movements_ar || basePhase?.prohibitedMovements || [],
    protein_min_per_kg: existingPhase?.protein_min_per_kg ?? basePhase?.proteinPerKg?.min ?? null,
    protein_max_per_kg: existingPhase?.protein_max_per_kg ?? basePhase?.proteinPerKg?.max ?? null,
    hydration_ml_per_kg: existingPhase?.hydration_ml_per_kg ?? basePhase?.hydrationMlPerKg ?? null,
    omega3_grams: existingPhase?.omega3_grams ?? basePhase?.omega3Grams ?? null,
    creatine_grams: existingPhase?.creatine_grams ?? basePhase?.creatineGrams ?? null,
    collagen_min_per_kg: existingPhase?.collagen_min_per_kg ?? basePhase?.collagenPerKg?.min ?? null,
    collagen_max_per_kg: existingPhase?.collagen_max_per_kg ?? basePhase?.collagenPerKg?.max ?? null,
    vitamin_c_mg: existingPhase?.vitamin_c_mg ?? basePhase?.vitaminCMg ?? null,
    calcium_mg: existingPhase?.calcium_mg ?? basePhase?.calciumMg ?? null,
  };
}

async function syncPhaseGoals(phaseId: string, goals: string[]) {
  const db = getSupabaseClient();
  await db.from('phase_goals').delete().eq('phase_id', phaseId);

  if (!goals.length) return;

  const {error} = await (db.from('phase_goals') as any).insert(
    goals.map((goal, index) => ({
      phase_id: phaseId,
      order_index: index,
      text_en: goal,
      text_ar: goal,
    })),
  );

  if (error) throw error;
}

async function syncPhasePrecautions(phaseId: string, precautions: string[]) {
  const db = getSupabaseClient();
  await db.from('phase_precautions').delete().eq('phase_id', phaseId);

  if (!precautions.length) return;

  const {error} = await (db.from('phase_precautions') as any).insert(
    precautions.map((precaution, index) => ({
      phase_id: phaseId,
      order_index: index,
      text_en: precaution,
      text_ar: precaution,
    })),
  );

  if (error) throw error;
}

async function syncPhaseExercises(phaseId: string, importedPhase: ImportedInjuryProtocol['phases'][number]) {
  const db = getSupabaseClient();
  await db.from('phase_exercises').delete().eq('phase_id', phaseId);

  const sourceExercises: Array<{plan: ImportedInjuryProtocol['phases'][number]['exercisePlans'][number]; index: number}> = importedPhase.exercisePlans.length
    ? importedPhase.exercisePlans.map((plan, index) => ({plan, index}))
    : importedPhase.exercises.map((exercise, index) => ({plan: {label: exercise, sets: undefined, cues: []}, index}));

  if (!sourceExercises.length) return;

  const {error} = await (db.from('phase_exercises') as any).insert(
    sourceExercises.map(({plan, index}) => {
      const parsed = parsePrescriptionDetails(plan.sets);
      return {
        phase_id: phaseId,
        order_index: index,
        name_en: plan.label,
        name_ar: plan.label,
        prescription_en: parsed.prescription,
        prescription_ar: parsed.prescription,
        sets: parsed.sets,
        reps: parsed.reps,
        rest: parsed.rest,
        cue_en: parsed.cue,
        cue_ar: parsed.cue,
        notes_en: plan.sets || null,
        notes_ar: plan.sets || null,
      };
    }),
  );

  if (error) throw error;
}


export async function createInjuryProtocolImportRun(data: {
  rawText: string;
  sourceName?: string;
  summary: ProtocolImportSummary;
  status?: ImportRunStatus;
  notes?: string;
  actor?: {id?: string | null; email?: string | null};
}): Promise<InjuryProtocolImportRunRow> {
  try {
    const db = getSupabaseClient();
    const {data: result, error} = await (db.from('injury_protocol_import_runs') as any)
      .insert([
        {
          source_name: data.sourceName || null,
          raw_text: data.rawText,
          parsed_count: data.summary.parsedCount,
          matched_count: data.summary.matchedCount,
          unmatched_count: data.summary.unmatchedCount,
          imported_slugs: data.summary.matched.map((item) => item.matchedSlug).filter(Boolean),
          unmatched_titles: data.summary.unmatched.map((item) => item.sourceTitle),
          status: data.status || 'preview',
          notes: data.notes || null,
          created_by: data.actor?.id || null,
          created_by_email: data.actor?.email || null,
        } as any,
      ])
      .select()
      .single();

    if (error) throw error;
    return result as InjuryProtocolImportRunRow;
  } catch (err) {
    console.error('Error creating injury protocol import run:', err);
    throw new Error(formatImportPermissionError(err));
  }
}

export async function updateInjuryProtocolImportRun(
  id: string,
  data: Partial<Pick<InjuryProtocolImportRunRow, 'status' | 'notes' | 'parsed_count' | 'matched_count' | 'unmatched_count' | 'imported_slugs' | 'unmatched_titles'>>,
) {
  try {
    const db = getSupabaseClient();
    const {data: result, error} = await (db.from('injury_protocol_import_runs') as any)
      .update(data as any)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return result as InjuryProtocolImportRunRow;
  } catch (err) {
    console.error('Error updating injury protocol import run:', err);
    throw err;
  }
}

export async function importExerciseProtocolsToSupabase(params: {
  rawText: string;
  parsedInjuries: ImportedInjuryProtocol[];
  sourceName?: string;
  actor?: {id?: string | null; email?: string | null};
}) {
  const summary = {
    parsedCount: params.parsedInjuries.length,
    matchedCount: params.parsedInjuries.filter((item) => item.matchedSlug).length,
    unmatchedCount: params.parsedInjuries.filter((item) => !item.matchedSlug).length,
    matched: params.parsedInjuries.filter((item) => item.matchedSlug),
    unmatched: params.parsedInjuries.filter((item) => !item.matchedSlug),
  } satisfies ProtocolImportSummary;

  const run = await createInjuryProtocolImportRun({
    rawText: params.rawText,
    sourceName: params.sourceName,
    summary,
    status: 'preview',
    actor: params.actor,
  });

  try {
    const localProtocols = getLocalProtocolMap();
    const remoteRows = await fetchInjuriesFromSupabase();
    const remoteBySlug = new Map(remoteRows.map((row) => [row.injury_id_slug, row]));
    const usedSlugs = new Set(remoteRows.map((row) => row.injury_id_slug));
    let importedCount = 0;
    const importedSlugs: string[] = [];

    for (const imported of params.parsedInjuries) {
      const localProtocol = imported.matchedSlug ? localProtocols.get(imported.matchedSlug) : undefined;
      const targetSlug = buildProtocolSlug(imported, localProtocol, remoteBySlug, usedSlugs);
      let remoteInjury = remoteBySlug.get(targetSlug) || null;
      const injuryPayload =
        localProtocol && shouldReuseMatchedSlug(imported, localProtocol)
          ? buildLocalInjuryInsert(localProtocol, targetSlug)
          : buildFallbackInjuryInsert(targetSlug, imported.sourceTitle, imported.heading);

      if (!remoteInjury) {
        remoteInjury = await createInjury(injuryPayload);
        remoteBySlug.set(targetSlug, remoteInjury);
        usedSlugs.add(targetSlug);
      } else {
        remoteInjury = await updateInjury(remoteInjury.id, injuryPayload);
        remoteBySlug.set(targetSlug, remoteInjury);
      }

      const existingPhases = await fetchPhasesByInjuryId(remoteInjury.id);
      const existingByNumber = new Map(existingPhases.map((phase) => [phase.phase_number, phase]));

      for (const importedPhase of imported.phases) {
        const existing = existingByNumber.get(importedPhase.phaseNumber);
        const basePhase = localProtocol?.phases[importedPhase.phaseNumber - 1];
        const payload = buildPhasePayload(remoteInjury.id, importedPhase.phaseNumber, importedPhase, existing, basePhase);

        let phaseId: string;
        if (existing) {
          const result = await updatePhase(existing.id, payload as PhaseUpdate);
          if (!result) throw new Error('Failed to update phase');
          phaseId = (result as any).id;
        } else {
          const result = await createPhase(payload as PhaseInsert);
          if (!result) throw new Error('Failed to create phase');
          phaseId = (result as any).id;
        }

        await syncPhaseGoals(phaseId, importedPhase.goals);
        await syncPhasePrecautions(phaseId, importedPhase.cautions);
        await syncPhaseExercises(phaseId, importedPhase);

        const db = getSupabaseClient();
        await db.from('supplements').delete().eq('phase_id', phaseId);
        if (basePhase?.supplements?.length) {
          for (let i = 0; i < basePhase.supplements.length; i += 1) {
            const supp = basePhase.supplements[i];
            await createSupplement({
              phase_id: phaseId,
              name: supp.name,
              dose_en: supp.dose,
              dose_ar: supp.dose,
              reason_en: supp.reason,
              reason_ar: supp.reason,
              timing_en: supp.timing || '',
              timing_ar: supp.timing || '',
              caution_en: supp.caution || '',
              caution_ar: supp.caution || '',
              order_index: i,
            });
          }
        }

        await db.from('meal_examples').delete().eq('phase_id', phaseId);
        if (basePhase?.meals && basePhase.meals.breakfast) {
          await createMeal({
            phase_id: phaseId,
            diet_style: 'omnivore',
            breakfast_en: basePhase.meals.breakfast,
            breakfast_ar: basePhase.meals.breakfast,
            lunch_en: basePhase.meals.lunch,
            lunch_ar: basePhase.meals.lunch,
            dinner_en: basePhase.meals.dinner,
            dinner_ar: basePhase.meals.dinner,
            snack_en: basePhase.meals.snack || '',
            snack_ar: basePhase.meals.snack || '',
            shopping_list_en: basePhase.meals.shoppingList || [],
            shopping_list_ar: basePhase.meals.shoppingList || [],
          });
        }
      }

      if (localProtocol?.safetyNotes) {
        await upsertSafetyNotes(remoteInjury.id, {
          medications_en: localProtocol.safetyNotes.medications || [],
          medications_ar: localProtocol.safetyNotes.medications || [],
          supplements_en: localProtocol.safetyNotes.supplements || [],
          supplements_ar: localProtocol.safetyNotes.supplements || [],
          contraindication_medications: [],
          contraindication_supplements: [],
        });
      }

      if (localProtocol?.pageContent) {
        await upsertInjuryPageContent(remoteInjury.id, {
          intro_en: localProtocol.pageContent.intro || '',
          intro_ar: localProtocol.pageContent.intro || '',
          symptoms_en: localProtocol.pageContent.symptoms || [],
          symptoms_ar: localProtocol.pageContent.symptoms || [],
          rehab_notes_en: localProtocol.pageContent.rehabNotes || [],
          rehab_notes_ar: localProtocol.pageContent.rehabNotes || [],
          nutrition_notes_en: localProtocol.pageContent.nutritionNotes || [],
          nutrition_notes_ar: localProtocol.pageContent.nutritionNotes || [],
          faq_items: localProtocol.pageContent.faq as any || [],
        });
      }

      importedSlugs.push(targetSlug);
      importedCount += 1;
    }

    await updateInjuryProtocolImportRun(run.id, {
      status: 'imported',
      imported_slugs: importedSlugs,
      notes: `Imported ${importedCount} protocol records into Supabase.`,
    });

    return {
      runId: run.id,
      importedCount,
      summary,
    };
  } catch (error) {
    await updateInjuryProtocolImportRun(run.id, {
      status: 'failed',
      notes: error instanceof Error ? error.message : 'Import failed',
    });
    throw error;
  }
}



