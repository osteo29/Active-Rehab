-- Injuries 1 to 10 of 100
-- Paste this file into Supabase SQL Editor after running 00_create_injury_page_content.sql
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
    'ankle_sprain',
    'Ankle Sprain',
    'التواء أربطة الكاحل',
    'Ligament',
    'Ankle',
    'الكاحل',
    'Ankle sprains need swelling control first, then progressive loading, balance work, and ligament-friendly fueling.',
    'التواء أربطة الكاحل من إصابات أربطة التي تؤثر على الكاحل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Protect early, restore motion next, then rebuild confidence for cutting and hopping.',
    'التواء أربطة الكاحل: خطة تأهيل على مراحل لمنطقة الكاحل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Field sports', 'Running', 'Daily activity'],
    ARRAY['Unable to bear weight', 'Major deformity', 'Rapid swelling with intense pain'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil or curcumin with blood thinners or before procedures.'],
    ARRAY[]::text[],
    ARRAY['Very high antioxidant dosing is not always better in the first days.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce swelling', 'Protect ligament', 'Maintain protein intake'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Omega-3', 'Vitamin C'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Salmon', 'Kiwi', 'Berries'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Very salty fast food', 'Skipping meals'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Protected range of motion', 'Pain-limited calf pumping'],
    ARRAY[]::text[],
    ARRAY['Aggressive hopping', 'Fast pivots'],
    ARRAY[]::text[],
    1.6,
    2,
    35,
    2,
    null,
    null,
    null,
    500,
    null
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
    'Greek yogurt bowl with berries and oats',
    'Greek yogurt bowl with berries and oats',
    'Salmon, rice, and peppers',
    'Salmon, rice, and peppers',
    'Chicken soup with potatoes and spinach',
    'Chicken soup with potatoes and spinach',
    'Orange with kefir',
    'Orange with kefir',
    ARRAY['Greek yogurt', 'Salmon', 'Oranges', 'Oats', 'Spinach', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control',
    'Supports inflammation control',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building',
    'Supports collagen building',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5-21 days',
    '5-21 days',
    'days_3_14',
    ARRAY['Support ligament repair', 'Restore range of motion', 'Start loading on purpose'],
    ARRAY[]::text[],
    ARRAY['Collagen plus vitamin C before rehab', 'Consistent protein'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Lean beef', 'Lentils'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Long gaps without protein'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Progressive calf raises', 'Balance work'],
    ARRAY[]::text[],
    ARRAY['Painful high-speed change of direction'],
    ARRAY[]::text[],
    1.8,
    2.1,
    35,
    null,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Eggs, sourdough, and fruit',
    'Eggs, sourdough, and fruit',
    'Lean beef, potatoes, and salad',
    'Lean beef, potatoes, and salad',
    'Lentil bowl with vegetables',
    'Lentil bowl with vegetables',
    'Collagen shake and orange before rehab',
    'Collagen shake and orange before rehab',
    ARRAY['Eggs', 'Lean beef', 'Lentils', 'Oranges', 'Potatoes', 'Bell peppers'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '250-500 mg',
    '250-500 mg',
    'Pairs with collagen support',
    'Pairs with collagen support',
    'With collagen before rehab',
    'With collagen before rehab',
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return to sport',
    'المرحلة 3: العودة للرياضة',
    '3-6 weeks',
    '3-6 weeks',
    'weeks_2_6',
    ARRAY['Regain stiffness tolerance', 'Improve confidence', 'Support repeat effort'],
    ARRAY[]::text[],
    ARRAY['High-quality protein', 'Creatine', 'Smart carb timing'],
    ARRAY[]::text[],
    ARRAY['Milk or soy milk', 'Chicken wraps', 'Rice', 'Bananas'],
    ARRAY[]::text[],
    ARRAY['Under-eating on training days'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Hops and landings', 'Single-leg strength', 'Return-to-run progression'],
    ARRAY[]::text[],
    ARRAY['Full sport before passing strength and hop tests'],
    ARRAY[]::text[],
    1.8,
    2.2,
    40,
    null,
    5,
    null,
    null,
    null,
    null
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
    'Oats, milk, banana, and protein',
    'Oats, milk, banana, and protein',
    'Chicken wrap with rice salad',
    'Chicken wrap with rice salad',
    'Rice bowl with tofu or turkey',
    'Rice bowl with tofu or turkey',
    'Banana and yogurt before field work',
    'Banana and yogurt before field work',
    ARRAY['Milk or soy milk', 'Bananas', 'Chicken or tofu', 'Rice', 'Yogurt'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass',
    'Supports strength and lean mass',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'A good ankle sprain plan does more than reduce swelling. It should rebuild balance, calf strength, landing control, and confidence for change of direction so the same ankle does not keep getting reinjured.',
    'التواء أربطة الكاحل من إصابات أربطة التي تؤثر على الكاحل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Outer or inner ankle pain after rolling the foot', 'Swelling and tenderness around the ligaments', 'Fear of stepping, cutting, or landing on the injured side', 'Loss of balance confidence on one leg'],
    ARRAY[]::text[],
    ARRAY['Range of motion and swelling management matter early, but calf strength and balance quickly become key.', 'Mid rehab should include single-leg stability, calf work, and direction-change preparation.', 'Late rehab must restore hopping, landing, and reactive balance, not just walking without pain.'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy and hydration help when appetite and daily movement both dip after injury.', 'Vitamin C and collagen can fit especially well during the loading phase of ligament rehab.', 'Alcohol often worsens recovery quality in the first few days by hurting hydration and sleep.'],
    ARRAY[]::text[],
    '[{"q_en":"Why do ankle sprains keep coming back?","a_en":"Because many people stop rehab once swelling improves. The ankle still needs calf strength, balance retraining, and confidence under faster movement.","q_ar":"Why do ankle sprains keep coming back?","a_ar":"Because many people stop rehab once swelling improves. The ankle still needs calf strength, balance retraining, and confidence under faster movement."},{"q_en":"When can I run again?","a_en":"Usually after walking is comfortable, hopping is controlled, and you can tolerate single-leg loading without next-day flare.","q_ar":"When can I run again?","a_ar":"Usually after walking is comfortable, hopping is controlled, and you can tolerate single-leg loading without next-day flare."},{"q_en":"Does taping replace rehab?","a_en":"No. It may help short-term support, but it does not replace strength, proprioception, and progressive return-to-sport work.","q_ar":"Does taping replace rehab?","a_ar":"No. It may help short-term support, but it does not replace strength, proprioception, and progressive return-to-sport work."}]'::jsonb
  )
  on conflict (injury_id) do update set
    intro_en = excluded.intro_en,
    intro_ar = excluded.intro_ar,
    symptoms_en = excluded.symptoms_en,
    rehab_notes_en = excluded.rehab_notes_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    faq_items = excluded.faq_items,
    updated_at = now();
end
$seed$;

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
    'acl_injury',
    'ACL Injury',
    'إصابة الرباط الصليبي الأمامي',
    'Ligament',
    'Knee',
    'الركبة',
    'ACL rehab needs muscle retention, enough energy, collagen support around loading, and patience across a long return timeline.',
    'إصابة الرباط الصليبي الأمامي من إصابات أربطة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'The knee needs swelling control early, quadriceps retention always, and structured food support through prehab, surgery, and rehab.',
    'إصابة الرباط الصليبي الأمامي: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Football', 'Basketball', 'Pivoting sports'],
    ARRAY['Locked knee', 'Major instability', 'Post-op calf swelling or chest symptoms'],
    ARRAY['Protein intake', 'Water intake', 'Macro calculator']
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
    ARRAY['Review fish oil, curcumin, and high-dose vitamin E around surgery or with anticoagulants.'],
    ARRAY[]::text[],
    ARRAY['Supplements cannot replace surgical or physiotherapy planning.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Prehab / pre-surgery',
    'المرحلة 1: تأهيل قبل الجراحة',
    'Before surgery or early structured rehab',
    'Before surgery or early structured rehab',
    'days_3_14',
    ARRAY['Reduce atrophy', 'Calm swelling', 'Prepare for surgery or rehab'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Creatine', 'Micronutrient sufficiency'],
    ARRAY[]::text[],
    ARRAY['Whey or soy protein', 'Eggs', 'Rice', 'Yogurt'],
    ARRAY[]::text[],
    ARRAY['Crash dieting', 'Under-eating because activity dropped'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Quad setting', 'Range of motion work', 'Prehab strength if cleared'],
    ARRAY[]::text[],
    ARRAY['Pivoting or cutting on an unstable knee'],
    ARRAY[]::text[],
    1.8,
    2.2,
    35,
    null,
    5,
    null,
    null,
    null,
    null
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
    'Eggs, toast, and fruit',
    'Eggs, toast, and fruit',
    'Chicken rice bowl with yogurt',
    'Chicken rice bowl with yogurt',
    'Beans or turkey with potatoes and vegetables',
    'Beans or turkey with potatoes and vegetables',
    'Protein shake after rehab',
    'Protein shake after rehab',
    ARRAY['Eggs', 'Chicken', 'Rice', 'Yogurt', 'Potatoes', 'Protein powder'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Helps preserve lean mass',
    'Helps preserve lean mass',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Protein powder if needed',
    '20-30 g',
    '20-30 g',
    'Convenient protein coverage',
    'Convenient protein coverage',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Post-op acute',
    'المرحلة 2: حاد',
    '0-14 days after surgery',
    '0-14 days after surgery',
    'under_48h',
    ARRAY['Support wound healing', 'Control appetite drop', 'Protect lean mass'],
    ARRAY[]::text[],
    ARRAY['Protein at every meal', 'Vitamin C', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Soup with chicken', 'Greek yogurt', 'Cottage cheese', 'Citrus fruit'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Smoking', 'Low-protein snack-only eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Ankle pumps', 'Quad activation', 'Early extension work as directed'],
    ARRAY[]::text[],
    ARRAY['Unsanctioned loaded knee flexion'],
    ARRAY[]::text[],
    2,
    2.3,
    35,
    null,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Overnight oats with yogurt and berries',
    'Overnight oats with yogurt and berries',
    'Chicken soup with rice and carrots',
    'Chicken soup with rice and carrots',
    'White fish, mashed potatoes, and zucchini',
    'White fish, mashed potatoes, and zucchini',
    'Cottage cheese and kiwi',
    'Cottage cheese and kiwi',
    ARRAY['Greek yogurt', 'Chicken', 'Rice', 'Kiwi', 'Fish', 'Oats'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '15 g/day',
    '15 g/day',
    'May support connective tissue recovery',
    'May support connective tissue recovery',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports tissue healing',
    'Supports tissue healing',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Strength and return phase',
    'المرحلة 3: العودة للرياضة',
    '2 weeks to 9+ months',
    '2 weeks to 9+ months',
    'over_6_weeks',
    ARRAY['Regain quadriceps size', 'Support training output', 'Return to sport safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab', 'Collagen before tendon-heavy sessions'],
    ARRAY[]::text[],
    ARRAY['Milk', 'Rice', 'Lean meat', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Long energy deficits during hard rehab blocks'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Squat progression', 'Split squats', 'Running and hop progressions'],
    ARRAY[]::text[],
    ARRAY['Rushing back before strength benchmarks'],
    ARRAY[]::text[],
    1.8,
    2.2,
    40,
    null,
    5,
    0.12,
    0.18,
    null,
    null
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
    'Protein oats with banana',
    'Protein oats with banana',
    'Turkey or tofu rice bowl',
    'Turkey or tofu rice bowl',
    'Salmon with potatoes and greens',
    'Salmon with potatoes and greens',
    'Collagen drink plus orange before rehab',
    'Collagen drink plus orange before rehab',
    ARRAY['Oats', 'Bananas', 'Turkey or tofu', 'Rice', 'Salmon', 'Oranges'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports rehab performance and strength',
    'Supports rehab performance and strength',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'Useful before tendon or hopping sessions',
    'Useful before tendon or hopping sessions',
    '30-60 min pre-rehab',
    '30-60 min pre-rehab',
    null,
    null,
    1
  );

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'ACL injuries usually need a longer rehab timeline than patients expect. The big priorities are swelling control, quadriceps retention, enough total calories, and a clear progression from prehab to strength and finally return-to-play.',
    'إصابة الرباط الصليبي الأمامي من إصابات أربطة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['A pop during pivoting, landing, or contact', 'Rapid knee swelling in the first hours after injury', 'Instability or loss of trust in cutting and deceleration', 'Quadriceps inhibition and weakness even when pain is settling'],
    ARRAY[]::text[],
    ARRAY['Early work often focuses on extension range, swelling control, and quadriceps activation.', 'Mid rehab usually shifts toward single-leg strength, rate of force development, and running progressions.', 'Late rehab should include hop testing, change-of-direction prep, and sport-specific loading before return.'],
    ARRAY[]::text[],
    ARRAY['High-quality protein matters throughout the entire rehab timeline because muscle loss can happen early.', 'Creatine is especially useful when training volume is reduced or after surgery.', 'Carbohydrate timing becomes more important again once heavy strength work and field sessions return.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does ACL rehab take so long?","a_en":"Because the knee is not only healing tissue. You also need to restore strength, landing confidence, deceleration control, and sport tolerance before return becomes realistic.","q_ar":"Why does ACL rehab take so long?","a_ar":"Because the knee is not only healing tissue. You also need to restore strength, landing confidence, deceleration control, and sport tolerance before return becomes realistic."},{"q_en":"What nutrition mistake hurts ACL rehab most?","a_en":"Under-eating after activity drops. Many people move less, eat far less, and then lose more muscle than expected during rehab.","q_ar":"What nutrition mistake hurts ACL rehab most?","a_ar":"Under-eating after activity drops. Many people move less, eat far less, and then lose more muscle than expected during rehab."},{"q_en":"Is collagen enough for ACL recovery?","a_en":"No. Collagen can be a useful add-on around rehab sessions, but it does not replace protein adequacy, strength work, or good loading progressions.","q_ar":"Is collagen enough for ACL recovery?","a_ar":"No. Collagen can be a useful add-on around rehab sessions, but it does not replace protein adequacy, strength work, or good loading progressions."}]'::jsonb
  )
  on conflict (injury_id) do update set
    intro_en = excluded.intro_en,
    intro_ar = excluded.intro_ar,
    symptoms_en = excluded.symptoms_en,
    rehab_notes_en = excluded.rehab_notes_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    faq_items = excluded.faq_items,
    updated_at = now();
end
$seed$;

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
    'rotator_cuff',
    'Rotator Cuff Injury',
    'إصابة الكفة المدورة',
    'Tendon',
    'Shoulder',
    'الكتف',
    'Shoulder tendon problems usually improve with graded loading, protein adequacy, and collagen timed around rehab.',
    'إصابة الكفة المدورة من إصابات أوتار التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'The cuff dislikes long rest and reckless overhead loading. Nutrition should support repeated rehab exposure and pain-limited progression.',
    'إصابة الكفة المدورة: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Overhead sports', 'Gym training', 'Manual work'],
    ARRAY['Sudden inability to lift the arm', 'Night pain with major weakness', 'Neurological symptoms'],
    ARRAY['Protein intake', 'Macro calculator']
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
    ARRAY['Bleeding risk matters if combining curcumin or fish oil with certain drugs.'],
    ARRAY[]::text[],
    ARRAY['Collagen does not replace progressive shoulder loading.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Pain-dominant phase',
    'المرحلة 1: حاد',
    '0-2 weeks',
    '0-2 weeks',
    'under_48h',
    ARRAY['Reduce irritability', 'Keep protein intake stable', 'Protect sleep quality'],
    ARRAY[]::text[],
    ARRAY['Omega-3', 'Vitamin C', 'Balanced meals during reduced activity'],
    ARRAY[]::text[],
    ARRAY['Fatty fish', 'Citrus fruit', 'Eggs', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['Heavy alcohol use', 'Meal skipping'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Scapular work', 'Gentle range of motion'],
    ARRAY[]::text[],
    ARRAY['Repeated painful overhead pressing'],
    ARRAY[]::text[],
    1.6,
    2,
    35,
    2,
    null,
    null,
    null,
    500,
    null
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
    'Eggs with avocado and toast',
    'Eggs with avocado and toast',
    'Tuna pasta salad',
    'Tuna pasta salad',
    'Salmon with couscous and greens',
    'Salmon with couscous and greens',
    'Cottage cheese and fruit',
    'Cottage cheese and fruit',
    ARRAY['Eggs', 'Avocado', 'Tuna', 'Salmon', 'Cottage cheese', 'Oranges'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports overall anti-inflammatory intake',
    'Supports overall anti-inflammatory intake',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Tendon rebuilding',
    'المرحلة 2: إصلاح وإعادة بناء',
    '2-10 weeks',
    '2-10 weeks',
    'weeks_2_6',
    ARRAY['Support tendon loading', 'Improve cuff strength', 'Restore overhead confidence'],
    ARRAY[]::text[],
    ARRAY['Collagen before rehab', 'High-quality protein', 'Carbs around harder sessions'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Chicken', 'Citrus fruit', 'Rice', 'Kiwi'],
    ARRAY[]::text[],
    ARRAY['Low-energy dieting during hard rehab'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Rotator cuff loading', 'Landmine press progression', 'Scapular strength work'],
    ARRAY[]::text[],
    ARRAY['Fast high-volume overhead work before tolerance is built'],
    ARRAY[]::text[],
    1.8,
    2.2,
    35,
    null,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt with oats and kiwi',
    'Greek yogurt with oats and kiwi',
    'Chicken rice bowl',
    'Chicken rice bowl',
    'Bean chili with potatoes',
    'Bean chili with potatoes',
    'Collagen plus orange before rehab',
    'Collagen plus orange before rehab',
    ARRAY['Greek yogurt', 'Oats', 'Kiwi', 'Chicken', 'Rice', 'Beans'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support tendon rehab',
    'May support tendon rehab',
    '30-60 min before loading',
    '30-60 min before loading',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'May support strength progression',
    'May support strength progression',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Rotator cuff problems often behave like load-management problems as much as tissue problems. Good outcomes usually come from better shoulder loading, enough protein, and patience with overhead progressions.',
    'إصابة الكفة المدورة من إصابات أوتار التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain when reaching overhead or away from the body', 'Night discomfort or pain lying on the shoulder', 'Weakness or heaviness with pressing or lifting', 'Irritation after repeated overhead sets or throwing volume'],
    ARRAY[]::text[],
    ARRAY['Early rehab usually emphasizes pain-limited loading, scapular control, and restoring tolerance rather than full rest.', 'Mid rehab builds cuff strength, overhead capacity, and movement quality under load.', 'Late phases should restore repeated overhead output, not just one pain-free rep.'],
    ARRAY[]::text[],
    ARRAY['Collagen timing before rehab can fit well with shoulder tendon loading sessions.', 'Protein becomes more important when gym volume drops and muscle retention is harder.', 'Under-fueling is a frequent reason overhead athletes plateau during rehab.'],
    ARRAY[]::text[],
    '[{"q_en":"Should I stop all shoulder training?","a_en":"Usually no. Most people do better with modified shoulder loading than with total inactivity, as long as painful volume and exercise selection are managed well.","q_ar":"Should I stop all shoulder training?","a_ar":"Usually no. Most people do better with modified shoulder loading than with total inactivity, as long as painful volume and exercise selection are managed well."},{"q_en":"Why does it hurt more at night?","a_en":"Night pain is common when the shoulder is irritable and compressed positions stay too long without support or movement.","q_ar":"Why does it hurt more at night?","a_ar":"Night pain is common when the shoulder is irritable and compressed positions stay too long without support or movement."},{"q_en":"Can I keep pressing during rehab?","a_en":"Sometimes yes, but exercise choice, range, tempo, and volume often need to change first so the cuff can tolerate the work.","q_ar":"Can I keep pressing during rehab?","a_ar":"Sometimes yes, but exercise choice, range, tempo, and volume often need to change first so the cuff can tolerate the work."}]'::jsonb
  )
  on conflict (injury_id) do update set
    intro_en = excluded.intro_en,
    intro_ar = excluded.intro_ar,
    symptoms_en = excluded.symptoms_en,
    rehab_notes_en = excluded.rehab_notes_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    faq_items = excluded.faq_items,
    updated_at = now();
end
$seed$;

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
    'hamstring_strain',
    'Hamstring Strain',
    'إجهاد عضلات الفخذ الخلفية',
    'Muscle',
    'Hip',
    'الورك',
    'Hamstring strains demand high-quality protein, enough energy, and progressive loading rather than panic rest.',
    'إجهاد عضلات الفخذ الخلفية من إصابات عضلات التي تؤثر على الورك، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Muscle injuries need tissue support early, then increasingly specific loading and sprint prep later.',
    'إجهاد عضلات الفخذ الخلفية: خطة تأهيل على مراحل لمنطقة الورك، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Football', 'Track'],
    ARRAY['Large bruising with severe weakness', 'Suspected tendon avulsion', 'Major power loss'],
    ARRAY['Protein intake', 'Macro calculator']
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
    ARRAY['Curcumin and omega-3 need medication review in sensitive cases.'],
    ARRAY[]::text[],
    ARRAY['High-dose antioxidants are not a substitute for proper rehab progression.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Limit secondary muscle damage', 'Protect appetite', 'Start gentle pain-limited movement'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Omega-3', 'No alcohol'],
    ARRAY[]::text[],
    ARRAY['Protein powder', 'Eggs', 'Berries', 'Fish', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Long fasting windows'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Walking if tolerated', 'Gentle range work'],
    ARRAY[]::text[],
    ARRAY['Max sprinting', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.2,
    35,
    2,
    null,
    null,
    null,
    500,
    null
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
    'Protein oats with berries',
    'Protein oats with berries',
    'Chicken, potatoes, and salad',
    'Chicken, potatoes, and salad',
    'Fish with rice and vegetables',
    'Fish with rice and vegetables',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Protein powder', 'Eggs', 'Berries', 'Chicken', 'Fish', 'Potatoes'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Protein shake if needed',
    '25-30 g',
    '25-30 g',
    'Makes protein coverage easier',
    'Makes protein coverage easier',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports anti-inflammatory intake',
    'Supports anti-inflammatory intake',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5-21 days',
    '5-21 days',
    'days_3_14',
    ARRAY['Support muscle repair', 'Restore length under load', 'Prepare for speed work'],
    ARRAY[]::text[],
    ARRAY['Protein at each meal', 'Collagen before rehab', 'Creatine'],
    ARRAY[]::text[],
    ARRAY['Lean beef', 'Citrus fruit', 'Greek yogurt', 'Rice', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Starting hard running while under-eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Eccentric hamstring work', 'Bridge progression', 'Tempo running later'],
    ARRAY[]::text[],
    ARRAY['Returning to full sprinting before eccentric tolerance'],
    ARRAY[]::text[],
    2,
    2.3,
    40,
    null,
    5,
    0.12,
    0.2,
    500,
    null
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
    'Greek yogurt, granola, and kiwi',
    'Greek yogurt, granola, and kiwi',
    'Lean beef and rice bowl',
    'Lean beef and rice bowl',
    'Bean pasta with turkey or tofu',
    'Bean pasta with turkey or tofu',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Greek yogurt', 'Kiwi', 'Lean beef', 'Rice', 'Turkey or tofu', 'Oranges'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'Useful before rehab sessions',
    'Useful before rehab sessions',
    '30-60 min pre-rehab',
    '30-60 min pre-rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports power and lean mass',
    'Supports power and lean mass',
    null,
    null,
    null,
    null,
    1
  );

end
$seed$;

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
    'stress_fracture',
    'Stress Fracture',
    'كسر الإجهاد',
    'Bone',
    'Foot',
    'القدم',
    'Bone stress injuries need enough energy, enough calcium and vitamin D, and a serious review of training load.',
    'كسر الإجهاد من إصابات عظام التي تؤثر على القدم، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'This is a bone-healing problem first, not just a pain problem. Low energy availability is often part of the story.',
    'كسر الإجهاد: خطة تأهيل على مراحل لمنطقة القدم، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Running', 'Dance', 'Rapid load spikes'],
    ARRAY['Night pain', 'Pain worsening with normal walking', 'Repeated stress injuries'],
    ARRAY['Protein intake', 'Water intake', 'Macro calculator']
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
    ARRAY['Calcium can affect absorption timing of some medications.'],
    ARRAY[]::text[],
    ARRAY['Check vitamin D dosing against labs when possible.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Bone healing',
    'المرحلة 1',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Support bone remodeling', 'Avoid low energy availability', 'Protect tissue'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Chronic under-eating', 'Very low-calorie cuts'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Protected cross-training if cleared', 'Upper-body or non-impact work'],
    ARRAY[]::text[],
    ARRAY['Running through pain', 'Impact work too soon'],
    ARRAY[]::text[],
    1.8,
    2.2,
    35,
    null,
    null,
    null,
    null,
    500,
    1200
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
    'Fortified oats with milk and fruit',
    'Fortified oats with milk and fruit',
    'Beans and rice with yogurt',
    'Beans and rice with yogurt',
    'Salmon or tofu with potatoes and kale',
    'Salmon or tofu with potatoes and kale',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Beans', 'Potatoes', 'Kale', 'Salmon or tofu'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Calcium',
    '1000-1200 mg/day',
    '1000-1200 mg/day',
    'Supports bone health',
    'Supports bone health',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin D',
    '1000-2000 IU/day',
    '1000-2000 IU/day',
    'Supports calcium use and bone health',
    'Supports calcium use and bone health',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Support graded return to impact', 'Protect muscle mass', 'Fuel rising training volume'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium continuity', 'Carbs around loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Dairy or fortified alternatives', 'Eggs', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Returning to impact while still low-energy'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Strength work', 'Plyometric reintroduction', 'Return-to-run progression'],
    ARRAY[]::text[],
    ARRAY['Impact progression without symptom monitoring'],
    ARRAY[]::text[],
    1.8,
    2.2,
    40,
    null,
    5,
    null,
    null,
    null,
    1200
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
    'Eggs, toast, and yogurt',
    'Eggs, toast, and yogurt',
    'Chicken and rice bowl',
    'Chicken and rice bowl',
    'Tofu curry with potatoes',
    'Tofu curry with potatoes',
    'Milk and banana',
    'Milk and banana',
    ARRAY['Eggs', 'Yogurt', 'Chicken', 'Rice', 'Tofu', 'Bananas'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '3-5 g/day',
    '3-5 g/day',
    'May support training quality once strength work increases',
    'May support training quality once strength work increases',
    null,
    null,
    null,
    null,
    0
  );

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Stress fractures are often as much about load history and energy availability as they are about pain. Recovery usually depends on respecting bone-healing time, correcting under-fueling, and rebuilding impact in a patient progression.',
    'كسر الإجهاد من إصابات عظام التي تؤثر على القدم، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain that starts with loading and can become more constant later', 'Tenderness over a specific bone area', 'Pain that worsens with impact or repeated training days', 'A history of rapid volume increase, low intake, or repeated overuse'],
    ARRAY[]::text[],
    ARRAY['Healing phases must respect protected loading first; trying to “push through” bone symptoms often prolongs recovery.', 'Return to impact should build through strength and carefully graded running or jumping exposure.', 'Repeated stress fractures should trigger a wider review of sleep, menstrual health, body composition pressure, or low energy availability.'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories are not optional here. Many stress fractures are harder to heal when energy intake stays too low.', 'Calcium and vitamin D matter, but they work best when the overall diet is sufficient.', 'Protein supports both tissue repair and muscle retention while activity is restricted.'],
    ARRAY[]::text[],
    '[{"q_en":"Why do stress fractures happen even in fit athletes?","a_en":"Because fitness does not fully protect against rapid load spikes, poor recovery, low energy availability, or repeated biomechanical stress.","q_ar":"Why do stress fractures happen even in fit athletes?","a_ar":"Because fitness does not fully protect against rapid load spikes, poor recovery, low energy availability, or repeated biomechanical stress."},{"q_en":"Can I cross-train while it heals?","a_en":"Often yes, if the chosen activity does not aggravate symptoms and has been cleared for the specific injury site.","q_ar":"Can I cross-train while it heals?","a_ar":"Often yes, if the chosen activity does not aggravate symptoms and has been cleared for the specific injury site."},{"q_en":"Is calcium alone enough to fix a stress fracture?","a_en":"No. Calcium helps bone health, but healing also depends on adequate energy intake, vitamin D status, load management, and time.","q_ar":"Is calcium alone enough to fix a stress fracture?","a_ar":"No. Calcium helps bone health, but healing also depends on adequate energy intake, vitamin D status, load management, and time."}]'::jsonb
  )
  on conflict (injury_id) do update set
    intro_en = excluded.intro_en,
    intro_ar = excluded.intro_ar,
    symptoms_en = excluded.symptoms_en,
    rehab_notes_en = excluded.rehab_notes_en,
    nutrition_notes_en = excluded.nutrition_notes_en,
    faq_items = excluded.faq_items,
    updated_at = now();
end
$seed$;

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
    'quadriceps_strain',
    'Quadriceps strain',
    'إجهاد عضلة الفخذ الرباعية',
    'Muscle',
    'Thigh',
    'الفخذ',
    'Quadriceps strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the thigh.',
    'إجهاد عضلة الفخذ الرباعية من إصابات عضلات التي تؤثر على الفخذ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلة الفخذ الرباعية: خطة تأهيل على مراحل لمنطقة الفخذ، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Thigh', 'Muscle'],
    ARRAY['Major bruising with severe weakness', 'Suspected avulsion', 'Loss of function worsening rapidly'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil, curcumin, or pain medication timing if bruising risk is high.'],
    ARRAY[]::text[],
    ARRAY['Supplements help only when loading, sleep, and total energy are in place.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute support',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce irritability in Quadriceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Quadriceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Quadriceps strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    3
  );

end
$seed$;

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
    'calf_strain',
    'Calf strain (Gastrocnemius / Soleus)',
    'إجهاد عضلات الساق (الفتيليس والسمانة)',
    'Muscle',
    'Ankle',
    'الكاحل',
    'Calf strain (Gastrocnemius / Soleus) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the ankle.',
    'إجهاد عضلات الساق (الفتيليس والسمانة) من إصابات عضلات التي تؤثر على الكاحل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الساق (الفتيليس والسمانة): خطة تأهيل على مراحل لمنطقة الكاحل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Ankle', 'Muscle'],
    ARRAY['Major bruising with severe weakness', 'Suspected avulsion', 'Loss of function worsening rapidly'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil, curcumin, or pain medication timing if bruising risk is high.'],
    ARRAY[]::text[],
    ARRAY['Supplements help only when loading, sleep, and total energy are in place.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute support',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce irritability in Calf strain (Gastrocnemius / Soleus)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Calf strain (Gastrocnemius / Soleus)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Calf strain (Gastrocnemius / Soleus)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    3
  );

end
$seed$;

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
    'biceps_strain',
    'Biceps strain',
    'إجهاد العضلة ذات الرأسين',
    'Muscle',
    'Arm',
    'Arm',
    'Biceps strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the arm.',
    'إجهاد العضلة ذات الرأسين من إصابات عضلات التي تؤثر على Arm، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد العضلة ذات الرأسين: خطة تأهيل على مراحل لمنطقة Arm، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Arm', 'Muscle'],
    ARRAY['Major bruising with severe weakness', 'Suspected avulsion', 'Loss of function worsening rapidly'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil, curcumin, or pain medication timing if bruising risk is high.'],
    ARRAY[]::text[],
    ARRAY['Supplements help only when loading, sleep, and total energy are in place.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute support',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce irritability in Biceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Biceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Biceps strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    3
  );

end
$seed$;

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
    'triceps_strain',
    'Triceps strain',
    'إجهاد عضلة ثلاثية الرؤوس',
    'Muscle',
    'Arm',
    'Arm',
    'Triceps strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the arm.',
    'إجهاد عضلة ثلاثية الرؤوس من إصابات عضلات التي تؤثر على Arm، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلة ثلاثية الرؤوس: خطة تأهيل على مراحل لمنطقة Arm، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Arm', 'Muscle'],
    ARRAY['Major bruising with severe weakness', 'Suspected avulsion', 'Loss of function worsening rapidly'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil, curcumin, or pain medication timing if bruising risk is high.'],
    ARRAY[]::text[],
    ARRAY['Supplements help only when loading, sleep, and total energy are in place.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute support',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce irritability in Triceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Triceps strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Triceps strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    3
  );

end
$seed$;

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
    'pectoral_strain',
    'Pectoral strain',
    'إجهاد عضلات الصدر',
    'Muscle',
    'Chest',
    'الصدر',
    'Pectoral strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the chest.',
    'إجهاد عضلات الصدر من إصابات عضلات التي تؤثر على الصدر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الصدر: خطة تأهيل على مراحل لمنطقة الصدر، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Chest', 'Muscle'],
    ARRAY['Major bruising with severe weakness', 'Suspected avulsion', 'Loss of function worsening rapidly'],
    ARRAY['Protein intake', 'Water intake']
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
    ARRAY['Review fish oil, curcumin, or pain medication timing if bruising risk is high.'],
    ARRAY[]::text[],
    ARRAY['Supplements help only when loading, sleep, and total energy are in place.'],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[]
  )
  on conflict (injury_id) do update set
    medications_en = excluded.medications_en,
    supplements_en = excluded.supplements_en,
    contraindication_medications = excluded.contraindication_medications,
    contraindication_supplements = excluded.contraindication_supplements,
    updated_at = now();


  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    1,
    'Acute support',
    'المرحلة 1: حاد',
    '0-5 days',
    '0-5 days',
    'under_48h',
    ARRAY['Reduce irritability in Pectoral strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    2,
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Pectoral strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    null,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.injury_phases (
    injury_id, phase_number, label_en, label_ar, duration_en, duration_ar, recovery_window,
    goals_en, goals_ar, nutrition_focus_en, nutrition_focus_ar, recommended_foods_en, recommended_foods_ar,
    avoid_foods_en, avoid_foods_ar, focus_en, focus_ar, progression_markers_en, progression_markers_ar,
    cautions_en, cautions_ar, nutrition_notes_en, nutrition_notes_ar, exercise_plans, exercises_en, exercises_ar,
    prohibited_movements_en, prohibited_movements_ar, protein_min_per_kg, protein_max_per_kg,
    hydration_ml_per_kg, omega3_grams, creatine_grams, collagen_min_per_kg, collagen_max_per_kg, vitamin_c_mg, calcium_mg
  ) values (
    v_injury_id,
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Pectoral strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Higher protein', 'Vitamin C', 'Structured hydration', 'No alcohol around the early healing phase'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Berries', 'Potatoes'],
    ARRAY[]::text[],
    ARRAY['Alcohol', 'Heavy fast food', 'Long gaps without eating'],
    ARRAY[]::text[],
    null,
    null,
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    ARRAY[]::text[],
    '[]'::jsonb,
    ARRAY['Pain-limited isometrics', 'Range of motion work', 'Progressive strengthening'],
    ARRAY[]::text[],
    ARRAY['Explosive return before strength tolerance', 'Aggressive stretching into pain'],
    ARRAY[]::text[],
    1.8,
    2.3,
    38,
    2,
    5,
    0.12,
    0.18,
    500,
    null
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Chicken or tofu with rice and vegetables',
    'Chicken or tofu with rice and vegetables',
    'Salmon or lentils with potatoes and greens',
    'Salmon or lentils with potatoes and greens',
    'Protein shake and fruit',
    'Protein shake and fruit',
    ARRAY['Greek yogurt', 'Eggs', 'Salmon', 'Potatoes', 'Berries', 'Rice'],
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

  delete from public.supplements where phase_id = v_phase_id;

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Collagen peptides',
    '10-15 g',
    '10-15 g',
    'May support connective tissue loading',
    'May support connective tissue loading',
    '30-60 min before rehab',
    '30-60 min before rehab',
    null,
    null,
    0
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Omega-3',
    '2 g/day',
    '2 g/day',
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
    null,
    null,
    null,
    null,
    1
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
    null,
    null,
    null,
    null,
    2
  );

  insert into public.supplements (
    phase_id, name, dose_en, dose_ar, reason_en, reason_ar, timing_en, timing_ar, caution_en, caution_ar, order_index
  ) values (
    v_phase_id,
    'Vitamin C',
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
    null,
    null,
    null,
    null,
    3
  );

end
$seed$;
