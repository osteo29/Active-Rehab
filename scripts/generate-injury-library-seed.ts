import fs from 'node:fs';
import path from 'node:path';
import {getAllInjuries} from '../src/services/injuryDatabase';
import {injuryPageContentCatalog} from '../src/services/injuryPageContentCatalog';
import {translateInjury} from '../src/services/injuryI18n';

function sqlText(value?: string | null) {
  if (value == null) return 'null';
  return `'${value.replace(/'/g, "''")}'`;
}

function sqlArray(values?: string[] | null) {
  if (!values?.length) return `ARRAY[]::text[]`;
  return `ARRAY[${values.map((item) => sqlText(item)).join(', ')}]`;
}

function sqlJson(value: unknown) {
  return `'${JSON.stringify(value ?? []).replace(/'/g, "''")}'::jsonb`;
}


function fallbackArabicSummary(injuryNameAr: string, bodyRegionAr: string) {
  return `${injuryNameAr}: خطة تأهيل على مراحل لمنطقة ${bodyRegionAr}، من تهدئة الأعراض حتى العودة التدريجية للنشاط.`;
}

function translatePhaseLabel(label: string, phaseNumber: number) {
  const lower = label.toLowerCase();
  if (lower.includes('acute') || lower.includes('pain-dominant') || lower.includes('immediate')) return `المرحلة ${phaseNumber}: حاد`;
  if (lower.includes('repair') || lower.includes('reload') || lower.includes('rebuild') || lower.includes('protected')) return `المرحلة ${phaseNumber}: إصلاح وإعادة بناء`;
  if (lower.includes('return') || lower.includes('late')) return `المرحلة ${phaseNumber}: العودة للرياضة`;
  if (lower.includes('prehab')) return `المرحلة ${phaseNumber}: تأهيل قبل الجراحة`;
  return `المرحلة ${phaseNumber}`;
}

const injuries = getAllInjuries();

const seedChunks = injuries.map((injury) => {
  const translated = translateInjury(
    {
      slugOrId: injury.id,
      nameEn: injury.name,
      category: injury.category,
      regionEn: injury.bodyRegion,
      overviewEn: injury.overview,
    },
    'ar',
  );
  const nameAr = translated.name;
  const bodyRegionAr = translated.bodyRegion;
  const overviewAr = translated.overview;
  const rehabSummaryAr = fallbackArabicSummary(nameAr, bodyRegionAr);
  const pageContent = injuryPageContentCatalog[injury.id];

  const phaseBlocks = injury.phases.map((phase, index) => {
    const phaseNumber = index + 1;
    const phaseLabelAr = translatePhaseLabel(phase.label, phaseNumber);

    const supplementsSql = [
      `delete from public.supplements where phase_id = v_phase_id;`,
      ...phase.supplements.map(
        (supplement, supplementIndex) => `
  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    ${sqlText(supplement.name)},
    ${sqlText(supplement.dose)},
    ${sqlText(supplement.dose)},
    ${sqlText(supplement.reason)},
    ${sqlText(supplement.reason)},
    ${sqlText(supplement.timing ?? null)},
    ${sqlText(supplement.timing ?? null)},
    ${sqlText(supplement.caution ?? null)},
    ${sqlText(supplement.caution ?? null)},
    ${supplementIndex}
  );`,
      ),
    ].join('\n');

    return `
  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    ${phaseNumber},
    ${sqlText((phase.label))},
    ${sqlText(phaseLabelAr)},
    ${sqlText((phase.duration))},
    ${sqlText((phase.duration))},
    ${sqlText(phase.window)},
    ${sqlArray(phase.goals)},
    ARRAY[]::text[],
    ${sqlArray(phase.nutritionFocus)},
    ARRAY[]::text[],
    ${sqlArray(phase.recommendedFoods)},
    ARRAY[]::text[],
    ${sqlArray(phase.avoidFoods)},
    ARRAY[]::text[],
    ${sqlText(phase.focus ? (phase.focus) : null)},
    ${sqlText(phase.focus ? (phase.focus) : null)},
    ${sqlArray(phase.progressionMarkers || [])},
    ARRAY[]::text[],
    ${sqlArray(phase.cautions || [])},
    ARRAY[]::text[],
    ${sqlArray(phase.nutritionNotes || [])},
    ARRAY[]::text[],
    ${sqlJson(phase.exercisePlans ?? [])},
    ${sqlArray(phase.exercises)},
    ARRAY[]::text[],
    ${sqlArray(phase.prohibitedMovements)},
    ARRAY[]::text[],
    ${phase.proteinPerKg?.min ?? 'null'},
    ${phase.proteinPerKg?.max ?? 'null'},
    ${phase.hydrationMlPerKg ?? 'null'},
    ${phase.omega3Grams ?? 'null'},
    ${phase.creatineGrams ?? 'null'},
    ${phase.collagenPerKg?.min ?? 'null'},
    ${phase.collagenPerKg?.max ?? 'null'},
    ${phase.vitaminCMg ?? 'null'},
    ${phase.calciumMg ?? 'null'}
  )
  on conflict (injury_id, phase_number) do update set
    label_en = excluded.label_en,
    label_ar = excluded.label_ar,
    duration_en = excluded.duration_en,
    duration_ar = excluded.duration_ar,
    recovery_window = excluded.recovery_window,
    goals_en = excluded.goals_en,
    nutrition_focus_en = excluded.nutrition_focus_en,
    recommended_foods_en = excluded.recommended_foods_en,
    avoid_foods_en = excluded.avoid_foods_en,
    focus_en = excluded.focus_en,
    progression_markers_en = excluded.progression_markers_en,
    cautions_en = excluded.cautions_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    exercise_plans = excluded.exercise_plans,
    exercises_en = excluded.exercises_en,
    prohibited_movements_en = excluded.prohibited_movements_en,
    protein_min_per_kg = excluded.protein_min_per_kg,
    protein_max_per_kg = excluded.protein_max_per_kg,
    hydration_ml_per_kg = excluded.hydration_ml_per_kg,
    omega3_grams = excluded.omega3_grams,
    creatine_grams = excluded.creatine_grams,
    collagen_min_per_kg = excluded.collagen_min_per_kg,
    collagen_max_per_kg = excluded.collagen_max_per_kg,
    vitamin_c_mg = excluded.vitamin_c_mg,
    calcium_mg = excluded.calcium_mg,
    updated_at = now()
  returning id into v_phase_id;

  insert into public.meal_examples (
    phase_id, diet_style, breakfast_en, breakfast_ar, lunch_en, lunch_ar, dinner_en, dinner_ar,
    snack_en, snack_ar, shopping_list_en, shopping_list_ar
  ) values (
    v_phase_id,
    'omnivore',
    ${sqlText((phase.meals.breakfast))},
    ${sqlText((phase.meals.breakfast))},
    ${sqlText((phase.meals.lunch))},
    ${sqlText((phase.meals.lunch))},
    ${sqlText((phase.meals.dinner))},
    ${sqlText((phase.meals.dinner))},
    ${sqlText(phase.meals.snack ? (phase.meals.snack) : null)},
    ${sqlText(phase.meals.snack ? (phase.meals.snack) : null)},
    ${sqlArray(phase.meals.shoppingList)},
    ARRAY[]::text[]
  )
  on conflict (phase_id, diet_style) do update set
    breakfast_en = excluded.breakfast_en,
    breakfast_ar = excluded.breakfast_ar,
    lunch_en = excluded.lunch_en,
    lunch_ar = excluded.lunch_ar,
    dinner_en = excluded.dinner_en,
    dinner_ar = excluded.dinner_ar,
    snack_en = excluded.snack_en,
    snack_ar = excluded.snack_ar,
    shopping_list_en = excluded.shopping_list_en,
    updated_at = now();

  ${supplementsSql}`;
  });

  const pageContentSql = pageContent
    ? `
  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    ${sqlText((pageContent.intro || injury.overview))},
    ${sqlText(overviewAr)},
    ${sqlArray((pageContent.symptoms || []))},
    ARRAY[]::text[],
    ${sqlArray((pageContent.rehabNotes || []))},
    ARRAY[]::text[],
    ${sqlArray((pageContent.nutritionNotes || []))},
    ARRAY[]::text[],
    ${sqlJson(
      (pageContent.faq || []).map((item) => ({
        q_en: (item.q),
        a_en: (item.a),
        q_ar: (item.q),
        a_ar: (item.a),
      })),
    )}
  )
  on conflict (injury_id) do update set
    intro_en = excluded.intro_en,
    intro_ar = excluded.intro_ar,
    symptoms_en = excluded.symptoms_en,
    rehab_notes_en = excluded.rehab_notes_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    faq_items = excluded.faq_items,
    updated_at = now();`
    : '';

  return `
do $seed$
declare
  v_injury_id uuid;
  v_phase_id uuid;
begin
  insert into public.injuries (
    injury_id_slug, name_en, name_ar, category, body_region_en, body_region_ar,
    overview_en, overview_ar, rehab_summary_en, rehab_summary_ar,
    common_in, red_flags, related_calculators
  ) values (
    ${sqlText(injury.id)},
    ${sqlText((injury.name))},
    ${sqlText(nameAr)},
    ${sqlText((injury.category))},
    ${sqlText((injury.bodyRegion))},
    ${sqlText(bodyRegionAr)},
    ${sqlText((injury.overview))},
    ${sqlText(overviewAr)},
    ${sqlText((injury.rehabSummary))},
    ${sqlText(rehabSummaryAr)},
    ${sqlArray(injury.commonIn)},
    ${sqlArray(injury.redFlags)},
    ${sqlArray(injury.relatedCalculators)}
  )
  on conflict (injury_id_slug) do update set
    name_en = excluded.name_en,
    name_ar = excluded.name_ar,
    category = excluded.category,
    body_region_en = excluded.body_region_en,
    body_region_ar = excluded.body_region_ar,
    overview_en = excluded.overview_en,
    overview_ar = excluded.overview_ar,
    rehab_summary_en = excluded.rehab_summary_en,
    rehab_summary_ar = excluded.rehab_summary_ar,
    common_in = excluded.common_in,
    red_flags = excluded.red_flags,
    related_calculators = excluded.related_calculators,
    updated_at = now()
  returning id into v_injury_id;

  insert into public.safety_notes (
    injury_id, medications_en, medications_ar, supplements_en, supplements_ar,
    contraindication_medications, contraindication_supplements
  ) values (
    v_injury_id,
    ${sqlArray(injury.safetyNotes.medications)},
    ARRAY[]::text[],
    ${sqlArray(injury.safetyNotes.supplements)},
    ARRAY[]::text[],
    ${sqlArray((injury.contraindications?.medications || []))},
    ${sqlArray((injury.contraindications?.supplements || []))}
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();

${phaseBlocks.join('\n')}
${pageContentSql}
end
$seed$;`;
});

const header = `-- Auto-generated injury library seed\n-- Generated from src/services/injuryDatabase.ts and injuryPageContentCatalog.ts\n-- Injury count: ${injuries.length}\n`;
const output = `${header}\n${seedChunks.join('\n\n')}\n`;

const outputPath = path.resolve(process.cwd(), 'supabase', 'seed_injury_library.sql');
fs.writeFileSync(outputPath, output, 'utf8');

console.log(`Generated ${outputPath} with ${injuries.length} injuries.`);
