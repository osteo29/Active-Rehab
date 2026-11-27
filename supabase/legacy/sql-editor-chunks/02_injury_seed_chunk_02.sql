-- Injuries 11 to 20 of 100
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
    'deltoid_strain',
    'Deltoid strain',
    'إجهاد عضلة الكتف الدالية',
    'Muscle',
    'Shoulder',
    'الكتف',
    'Deltoid strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'إجهاد عضلة الكتف الدالية من إصابات عضلات التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلة الكتف الدالية: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Shoulder', 'Muscle'],
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
    ARRAY['Reduce irritability in Deltoid strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Deltoid strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Deltoid strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'forearm_strain',
    'Forearm flexor/extensor strain',
    'إجهاد عضلات الساعد (المرنة والباسطة)',
    'Muscle',
    'Wrist',
    'الرسغ',
    'Forearm flexor/extensor strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the wrist.',
    'إجهاد عضلات الساعد (المرنة والباسطة) من إصابات عضلات التي تؤثر على الرسغ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الساعد (المرنة والباسطة): خطة تأهيل على مراحل لمنطقة الرسغ، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Wrist', 'Muscle'],
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
    ARRAY['Reduce irritability in Forearm flexor/extensor strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Forearm flexor/extensor strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Forearm flexor/extensor strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'glute_strain',
    'Gluteus maximus / medius strain',
    'إجهاد عضلات الأرداف (العريضة والوسطى)',
    'Muscle',
    'Hip',
    'الورك',
    'Gluteus maximus / medius strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the hip.',
    'إجهاد عضلات الأرداف (العريضة والوسطى) من إصابات عضلات التي تؤثر على الورك، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الأرداف (العريضة والوسطى): خطة تأهيل على مراحل لمنطقة الورك، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Hip', 'Muscle'],
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
    ARRAY['Reduce irritability in Gluteus maximus / medius strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Gluteus maximus / medius strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Gluteus maximus / medius strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'oblique_strain',
    'Oblique strain',
    'إجهاد عضلات البطن المائلة',
    'Muscle',
    'Whole body',
    'الجسم بالكامل',
    'Oblique strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the whole body.',
    'إجهاد عضلات البطن المائلة من إصابات عضلات التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات البطن المائلة: خطة تأهيل على مراحل لمنطقة الجسم بالكامل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Whole body', 'Muscle'],
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
    ARRAY['Reduce irritability in Oblique strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Oblique strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Oblique strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'erector_spinae_strain',
    'Erector spinae strain',
    'إجهاد عضلات الظهر الفاردة للعمود الفقري',
    'Muscle',
    'Back',
    'الظهر',
    'Erector spinae strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the back.',
    'إجهاد عضلات الظهر الفاردة للعمود الفقري من إصابات عضلات التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الظهر الفاردة للعمود الفقري: خطة تأهيل على مراحل لمنطقة الظهر، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Back', 'Muscle'],
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
    ARRAY['Reduce irritability in Erector spinae strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Erector spinae strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Erector spinae strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'neck_muscle_strain',
    'Neck muscles strain (Sternocleidomastoid, Trapezius)',
    'إجهاد عضلات الرقبة',
    'Muscle',
    'Neck',
    'الرقبة',
    'Neck muscles strain (Sternocleidomastoid, Trapezius) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the neck.',
    'إجهاد عضلات الرقبة من إصابات عضلات التي تؤثر على الرقبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الرقبة: خطة تأهيل على مراحل لمنطقة الرقبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Neck', 'Muscle'],
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
    ARRAY['Reduce irritability in Neck muscles strain (Sternocleidomastoid, Trapezius)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Neck muscles strain (Sternocleidomastoid, Trapezius)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Neck muscles strain (Sternocleidomastoid, Trapezius)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'adductor_strain',
    'Adductor strain (Groin pull)',
    'إجهاد عضلات الفخذ الداخلية (شد الفخذ)',
    'Muscle',
    'Hip',
    'الورك',
    'Adductor strain (Groin pull) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the hip.',
    'إجهاد عضلات الفخذ الداخلية (شد الفخذ) من إصابات عضلات التي تؤثر على الورك، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلات الفخذ الداخلية (شد الفخذ): خطة تأهيل على مراحل لمنطقة الورك، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Hip', 'Muscle'],
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
    ARRAY['Reduce irritability in Adductor strain (Groin pull)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Adductor strain (Groin pull)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Adductor strain (Groin pull)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'tibialis_anterior_strain',
    'Tibialis anterior strain',
    'إجهاد عضلة أمام الساق',
    'Muscle',
    'Foot',
    'القدم',
    'Tibialis anterior strain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the foot.',
    'إجهاد عضلة أمام الساق من إصابات عضلات التي تؤثر على القدم، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Calm symptoms first, then rebuild tissue tolerance with progressive loading and regular protein feedings.',
    'إجهاد عضلة أمام الساق: خطة تأهيل على مراحل لمنطقة القدم، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Sprinting', 'Gym training', 'Field sports', 'Foot', 'Muscle'],
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
    ARRAY['Reduce irritability in Tibialis anterior strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Tibialis anterior strain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Tibialis anterior strain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'pcl_injury',
    'PCL tear / sprain',
    'إصابة الرباط الصليبي الخلفي',
    'Ligament',
    'Knee',
    'الركبة',
    'PCL tear / sprain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'إصابة الرباط الصليبي الخلفي من إصابات أربطة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Protect the joint early, then build stiffness, confidence, and repeatable loading capacity.',
    'إصابة الرباط الصليبي الخلفي: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Contact play', 'Knee', 'Ligament'],
    ARRAY['Mechanical instability', 'Rapid swelling with severe pain', 'Inability to bear load'],
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
    ARRAY['Check bleeding risk around surgery or procedures before using fish oil or curcumin.'],
    ARRAY[]::text[],
    ARRAY['Collagen support should sit beside structured rehab, not replace it.'],
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
    ARRAY['Reduce irritability in PCL tear / sprain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in PCL tear / sprain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for PCL tear / sprain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    'mcl_sprain',
    'MCL sprain (Medial collateral ligament)',
    'التواء الرباط الجانبي الإنسي للركبة',
    'Ligament',
    'Knee',
    'الركبة',
    'MCL sprain (Medial collateral ligament) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'التواء الرباط الجانبي الإنسي للركبة من إصابات أربطة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Protect the joint early, then build stiffness, confidence, and repeatable loading capacity.',
    'التواء الرباط الجانبي الإنسي للركبة: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Contact play', 'Knee', 'Ligament'],
    ARRAY['Mechanical instability', 'Rapid swelling with severe pain', 'Inability to bear load'],
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
    ARRAY['Check bleeding risk around surgery or procedures before using fish oil or curcumin.'],
    ARRAY[]::text[],
    ARRAY['Collagen support should sit beside structured rehab, not replace it.'],
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
    ARRAY['Reduce irritability in MCL sprain (Medial collateral ligament)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in MCL sprain (Medial collateral ligament)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for MCL sprain (Medial collateral ligament)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Collagen plus vitamin C before rehab', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Eggs', 'Citrus fruit', 'Greek yogurt', 'Lean meat', 'Beans'],
    ARRAY[]::text[],
    ARRAY['Skipping rehab fuel', 'Low-protein snacking all day'],
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
    ARRAY['Protected range of motion', 'Balance drills', 'Progressive strength work'],
    ARRAY[]::text[],
    ARRAY['Uncleared cutting or pivoting', 'High-speed loading before control returns'],
    ARRAY[]::text[],
    1.8,
    2.2,
    36,
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
    'Eggs, toast, and kiwi',
    'Eggs, toast, and kiwi',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Bean pasta with vegetables',
    'Bean pasta with vegetables',
    'Collagen drink and orange before rehab',
    'Collagen drink and orange before rehab',
    ARRAY['Eggs', 'Greek yogurt', 'Oranges', 'Lean meat', 'Beans', 'Rice'],
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
    '500 mg/day',
    '500 mg/day',
    'Supports collagen building and tissue healing',
    'Supports collagen building and tissue healing',
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
    'MCL sprains usually recover better than people expect when valgus stress is calmed early and strength is rebuilt without rushing pivots. The main priorities are swelling control, medial knee confidence, and gradual return to cutting or contact.',
    'التواء الرباط الجانبي الإنسي للركبة من إصابات أربطة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain on the inner side of the knee after twisting or contact', 'Tenderness along the medial ligament and discomfort with side-to-side stress', 'Swelling or stiffness after walking, cutting, or stairs', 'Loss of trust when planting or changing direction'],
    ARRAY[]::text[],
    ARRAY['Early rehab usually protects the knee from repeated valgus stress while restoring comfortable motion and gait.', 'Mid phases focus on quadriceps, adductor, and single-leg control so the knee tolerates frontal-plane load again.', 'Return to sport should include cutting, deceleration, and contact confidence rather than straight-line running only.'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy matters because knee injuries can reduce lower-limb loading quickly and lead to strength loss.', 'Collagen plus vitamin C can fit before planned ligament-loading sessions if tolerated.', 'Avoid large calorie cuts while you are trying to regain knee strength and confidence.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does the knee feel unstable even if I can walk?","a_en":"Because walking demands much less frontal-plane control than pivoting, cutting, or side-step loading on an irritated MCL.","q_ar":"Why does the knee feel unstable even if I can walk?","a_ar":"Because walking demands much less frontal-plane control than pivoting, cutting, or side-step loading on an irritated MCL."},{"q_en":"Do braces replace rehab for MCL sprains?","a_en":"No. A brace may help early protection, but real recovery still depends on strength, control, and progressive loading.","q_ar":"Do braces replace rehab for MCL sprains?","a_ar":"No. A brace may help early protection, but real recovery still depends on strength, control, and progressive loading."},{"q_en":"When can side-to-side drills return?","a_en":"Usually after straight-line loading is calm, single-leg control is solid, and lateral stress does not trigger next-day flare.","q_ar":"When can side-to-side drills return?","a_ar":"Usually after straight-line loading is calm, single-leg control is solid, and lateral stress does not trigger next-day flare."}]'::jsonb
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
