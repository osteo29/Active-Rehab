-- Injuries 81 to 90 of 100
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
    'jumpers_knee',
    'Jumper’s knee',
    'Jumper’s knee',
    'Sports',
    'Knee',
    'الركبة',
    'Jumper’s knee needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'Jumper’s knee من إصابات إصابات رياضية التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'Jumper’s knee: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Competitive sport', 'High-speed change of direction', 'High-volume practice', 'Knee', 'Sports'],
    ARRAY['Combined instability', 'Fast swelling with loss of function', 'Symptoms worsening when sport resumes'],
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
    ARRAY['Medication and supplement review is more important when surgery or injections are involved.'],
    ARRAY[]::text[],
    ARRAY['Use supplements to support training blocks, not to rush return-to-play decisions.'],
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
    ARRAY['Reduce irritability in Jumper’s knee', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Reduce irritability in Jumper’s knee', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Progress loading tolerance for Jumper’s knee', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    'gymnast_wrist_injury',
    'Gymnast wrist injury',
    'Gymnast wrist injury',
    'Sports',
    'Wrist',
    'الرسغ',
    'Gymnast wrist injury needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the wrist.',
    'Gymnast wrist injury من إصابات إصابات رياضية التي تؤثر على الرسغ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'Gymnast wrist injury: خطة تأهيل على مراحل لمنطقة الرسغ، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Competitive sport', 'High-speed change of direction', 'High-volume practice', 'Wrist', 'Sports'],
    ARRAY['Combined instability', 'Fast swelling with loss of function', 'Symptoms worsening when sport resumes'],
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
    ARRAY['Medication and supplement review is more important when surgery or injections are involved.'],
    ARRAY[]::text[],
    ARRAY['Use supplements to support training blocks, not to rush return-to-play decisions.'],
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
    ARRAY['Reduce irritability in Gymnast wrist injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Reduce irritability in Gymnast wrist injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Progress loading tolerance for Gymnast wrist injury', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Gymnast wrist injuries usually reflect repeated high-volume compression through an immature or overloaded wrist. The best plans reduce irritability, protect growth-related tissue when relevant, and rebuild loading tolerance gradually.',
    'Gymnast wrist injury من إصابات إصابات رياضية التي تؤثر على الرسغ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Wrist pain during hand support, vaulting, or tumbling', 'Irritation after repeated extension loading', 'Reduced confidence in weight-bearing through the hands', 'Tenderness or stiffness that worsens with practice volume'],
    ARRAY[]::text[],
    ARRAY['Early management often includes reducing loaded wrist extension volume and modifying practice.', 'Forearm, shoulder, and hand support strength become more important as symptoms settle.', 'A full return should rebuild impact and hand-loading tolerance step by step, not session by session.'],
    ARRAY[]::text[],
    ARRAY['Young athletes especially need enough total calories to support both training and tissue healing.', 'Protein and calcium-rich foods matter more when growth and recovery are happening at the same time.', 'Low-energy availability can make repeated wrist overload much harder to recover from.'],
    ARRAY[]::text[],
    '[{"q_en":"Why are gymnast wrist injuries so common?","a_en":"Because gymnastics loads the wrist like a weight-bearing joint repeatedly, often under high volume and high extension angles.","q_ar":"Why are gymnast wrist injuries so common?","a_ar":"Because gymnastics loads the wrist like a weight-bearing joint repeatedly, often under high volume and high extension angles."},{"q_en":"Can wrist supports fix the problem alone?","a_en":"No. They may help symptoms, but practice modification and progressive reloading still matter.","q_ar":"Can wrist supports fix the problem alone?","a_ar":"No. They may help symptoms, but practice modification and progressive reloading still matter."},{"q_en":"Should young athletes keep training through wrist pain?","a_en":"Usually that is risky, especially if growth-related tissue is involved. Symptoms should be assessed and training modified early.","q_ar":"Should young athletes keep training through wrist pain?","a_ar":"Usually that is risky, especially if growth-related tissue is involved. Symptoms should be assessed and training modified early."}]'::jsonb
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
    'swimmer_shoulder_impingement',
    'Swimmer shoulder impingement',
    'انحشار كتف السباح',
    'Sports',
    'Shoulder',
    'الكتف',
    'Swimmer shoulder impingement needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'انحشار كتف السباح من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'انحشار كتف السباح: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Competitive sport', 'High-speed change of direction', 'High-volume practice', 'Shoulder', 'Sports'],
    ARRAY['Combined instability', 'Fast swelling with loss of function', 'Symptoms worsening when sport resumes'],
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
    ARRAY['Medication and supplement review is more important when surgery or injections are involved.'],
    ARRAY[]::text[],
    ARRAY['Use supplements to support training blocks, not to rush return-to-play decisions.'],
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
    ARRAY['Reduce irritability in Swimmer shoulder impingement', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Reduce irritability in Swimmer shoulder impingement', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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
    ARRAY['Progress loading tolerance for Swimmer shoulder impingement', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['High protein', 'Creatine', 'Carbs around rehab and skill work', 'Collagen around connective tissue loading'],
    ARRAY[]::text[],
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or fortified soy milk'],
    ARRAY[]::text[],
    ARRAY['Under-fueling on double-session days', 'Crash dieting during rehab'],
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
    ARRAY['Strength work', 'Field or skill progressions', 'Power reintroduction'],
    ARRAY[]::text[],
    ARRAY['Return to play before passing objective criteria'],
    ARRAY[]::text[],
    1.8,
    2.3,
    40,
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
    'Oats with milk, fruit, and protein',
    'Oats with milk, fruit, and protein',
    'Lean meat or tofu rice bowl',
    'Lean meat or tofu rice bowl',
    'Salmon or beans with potatoes',
    'Salmon or beans with potatoes',
    'Yogurt, banana, and a sports drink around rehab',
    'Yogurt, banana, and a sports drink around rehab',
    ARRAY['Rice', 'Yogurt', 'Lean meat', 'Fruit', 'Milk or soy milk', 'Oats'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Swimmer’s shoulder tends to build when overhead volume stays high but cuff and scapular support cannot keep up. The plan should improve shoulder mechanics, manage stroke volume, and restore repeated overhead tolerance without constant flare-ups.',
    'انحشار كتف السباح من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Shoulder pain during pull-through or higher swim volume', 'Pinching overhead or when reaching forward repeatedly', 'Fatigue and loss of shoulder control late in sessions', 'Irritation that spikes with paddles, sprint sets, or poor recovery'],
    ARRAY[]::text[],
    ARRAY['Training volume and stroke irritability usually need adjustment early while strength and control are rebuilt.', 'Cuff endurance, scapular support, and thoracic mobility often become major priorities in rehab.', 'A good return to swimming should rebuild repeated overhead capacity, not just one pain-free practice.'],
    ARRAY[]::text[],
    ARRAY['Swimmers often need more carbohydrate support than they realize once volume climbs again.', 'Protein intake helps preserve shoulder strength when pool volume is temporarily reduced.', 'Poor fueling between sessions can make repeated overhead tolerance much worse.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does the shoulder hurt more late in swim sessions?","a_en":"Because fatigue reduces cuff and scapular control, so the shoulder can tolerate repeated overhead strokes less efficiently.","q_ar":"Why does the shoulder hurt more late in swim sessions?","a_ar":"Because fatigue reduces cuff and scapular control, so the shoulder can tolerate repeated overhead strokes less efficiently."},{"q_en":"Do paddles make swimmer’s shoulder worse?","a_en":"They can, because they often increase shoulder loading quickly if irritability is already present.","q_ar":"Do paddles make swimmer’s shoulder worse?","a_ar":"They can, because they often increase shoulder loading quickly if irritability is already present."},{"q_en":"Is dry-land strength really that important for swimmers?","a_en":"Yes. Better cuff, scapular, and trunk strength often improves swim tolerance and reduces recurring shoulder overload.","q_ar":"Is dry-land strength really that important for swimmers?","a_ar":"Yes. Better cuff, scapular, and trunk strength often improves swim tolerance and reduces recurring shoulder overload."}]'::jsonb
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
    'growth_plate_fracture',
    'Growth plate fractures',
    'Growth plate fractures',
    'Pediatric',
    'Whole body',
    'الجسم بالكامل',
    'Growth plate fractures needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the whole body.',
    'Growth plate fractures من إصابات أطفال التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Pediatric cases need symptom-guided protection, age-appropriate loading, and enough total calories for growth plus healing.',
    'Growth plate fractures: خطة تأهيل على مراحل لمنطقة الجسم بالكامل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Youth sport', 'Growth spurts', 'School activity', 'Whole body', 'Pediatric'],
    ARRAY['Growth plate tenderness', 'Inability to use the limb', 'Night pain or systemic symptoms'],
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
    ARRAY['Parents should review any supplement plan with pediatric clinicians.'],
    ARRAY[]::text[],
    ARRAY['Avoid adult-style high-dose supplementation without professional guidance.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Growth plate fractures', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Growth plate fractures', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'osgood_schlatter',
    'Osgood-Schlatter',
    'Osgood-Schlatter',
    'Pediatric',
    'Knee',
    'الركبة',
    'Osgood-Schlatter needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'Osgood-Schlatter من إصابات أطفال التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Pediatric cases need symptom-guided protection, age-appropriate loading, and enough total calories for growth plus healing.',
    'Osgood-Schlatter: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Youth sport', 'Growth spurts', 'School activity', 'Knee', 'Pediatric'],
    ARRAY['Growth plate tenderness', 'Inability to use the limb', 'Night pain or systemic symptoms'],
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
    ARRAY['Parents should review any supplement plan with pediatric clinicians.'],
    ARRAY[]::text[],
    ARRAY['Avoid adult-style high-dose supplementation without professional guidance.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Osgood-Schlatter', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Osgood-Schlatter', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'severs_disease',
    'Sever’s disease',
    'Sever’s disease',
    'Pediatric',
    'Foot',
    'القدم',
    'Sever’s disease needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the foot.',
    'Sever’s disease من إصابات أطفال التي تؤثر على القدم، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Pediatric cases need symptom-guided protection, age-appropriate loading, and enough total calories for growth plus healing.',
    'Sever’s disease: خطة تأهيل على مراحل لمنطقة القدم، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Youth sport', 'Growth spurts', 'School activity', 'Foot', 'Pediatric'],
    ARRAY['Growth plate tenderness', 'Inability to use the limb', 'Night pain or systemic symptoms'],
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
    ARRAY['Parents should review any supplement plan with pediatric clinicians.'],
    ARRAY[]::text[],
    ARRAY['Avoid adult-style high-dose supplementation without professional guidance.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Sever’s disease', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Sever’s disease', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Adequate total calories', 'Protein spread across meals', 'Calcium-rich foods', 'Hydration'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Skipping breakfast', 'Energy drink dependence', 'Low-calorie restriction during growth'],
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
    ARRAY['Protected activity', 'Technique work', 'Gradual return to play'],
    ARRAY[]::text[],
    ARRAY['Playing through pain', 'Aggressive loading on open growth plates'],
    ARRAY[]::text[],
    1.5,
    1.9,
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
    'Milk, oats, and fruit',
    'Milk, oats, and fruit',
    'Egg or chicken wrap with yogurt',
    'Egg or chicken wrap with yogurt',
    'Beans or fish with rice and vegetables',
    'Beans or fish with rice and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Milk or soy milk', 'Eggs', 'Yogurt', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'geriatric_vertebral_compression_fracture',
    'Geriatric vertebral compression fracture',
    'Geriatric vertebral compression fracture',
    'Geriatric',
    'Spine',
    'العمود الفقري',
    'Geriatric vertebral compression fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the spine.',
    'Geriatric vertebral compression fracture من إصابات كبار السن التي تؤثر على العمود الفقري، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Older adults benefit from protein-dense meals, hydration support, and strength-focused nutrition during recovery.',
    'Geriatric vertebral compression fracture: خطة تأهيل على مراحل لمنطقة العمود الفقري، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Bone fragility', 'Low reserve during illness', 'Spine', 'Geriatric'],
    ARRAY['Confusion', 'Rapid mobility decline', 'Inability to transfer', 'Chest symptoms after a fall'],
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
    ARRAY['Check supplement plans against osteoporosis, heart, and anticoagulant medications.'],
    ARRAY[]::text[],
    ARRAY['Keep supplement plans simple and clinician-reviewed when many prescriptions are present.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Geriatric vertebral compression fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Geriatric vertebral compression fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'geriatric_hip_fracture',
    'Geriatric hip fracture',
    'Geriatric hip fracture',
    'Geriatric',
    'Hip',
    'الورك',
    'Geriatric hip fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the hip.',
    'Geriatric hip fracture من إصابات كبار السن التي تؤثر على الورك، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Older adults benefit from protein-dense meals, hydration support, and strength-focused nutrition during recovery.',
    'Geriatric hip fracture: خطة تأهيل على مراحل لمنطقة الورك، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Bone fragility', 'Low reserve during illness', 'Hip', 'Geriatric'],
    ARRAY['Confusion', 'Rapid mobility decline', 'Inability to transfer', 'Chest symptoms after a fall'],
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
    ARRAY['Check supplement plans against osteoporosis, heart, and anticoagulant medications.'],
    ARRAY[]::text[],
    ARRAY['Keep supplement plans simple and clinician-reviewed when many prescriptions are present.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Geriatric hip fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Geriatric hip fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'geriatric_osteoarthritis_flare',
    'Geriatric osteoarthritis flare',
    'Geriatric osteoarthritis flare',
    'Geriatric',
    'Whole body',
    'الجسم بالكامل',
    'Geriatric osteoarthritis flare needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the whole body.',
    'Geriatric osteoarthritis flare من إصابات كبار السن التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Older adults benefit from protein-dense meals, hydration support, and strength-focused nutrition during recovery.',
    'Geriatric osteoarthritis flare: خطة تأهيل على مراحل لمنطقة الجسم بالكامل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Bone fragility', 'Low reserve during illness', 'Whole body', 'Geriatric'],
    ARRAY['Confusion', 'Rapid mobility decline', 'Inability to transfer', 'Chest symptoms after a fall'],
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
    ARRAY['Check supplement plans against osteoporosis, heart, and anticoagulant medications.'],
    ARRAY[]::text[],
    ARRAY['Keep supplement plans simple and clinician-reviewed when many prescriptions are present.'],
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
    'Protected healing',
    'المرحلة 1: إصلاح وإعادة بناء',
    '0-6 weeks',
    '0-6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Geriatric osteoarthritis flare', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Reload and return',
    'المرحلة 2: إصلاح وإعادة بناء',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Geriatric osteoarthritis flare', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein density', 'Calcium', 'Vitamin D', 'Hydration and appetite support'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Milk or fortified soy milk', 'Eggs', 'Soft beans', 'Fruit'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Very low protein soups only', 'Alcohol excess'],
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
    ARRAY['Sit-to-stand progressions', 'Walking if cleared', 'Balance and strength work'],
    ARRAY[]::text[],
    ARRAY['Unsupervised progression after major fracture or flare'],
    ARRAY[]::text[],
    1.6,
    2,
    34,
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
    'Greek yogurt, oats, and berries',
    'Greek yogurt, oats, and berries',
    'Soft rice bowl with eggs or chicken',
    'Soft rice bowl with eggs or chicken',
    'Fish or lentils with potatoes and greens',
    'Fish or lentils with potatoes and greens',
    'Milk and fruit',
    'Milk and fruit',
    ARRAY['Greek yogurt', 'Milk or soy milk', 'Eggs', 'Beans', 'Fruit', 'Oats'],
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
    '1200 mg/day',
    '1200 mg/day',
    'Supports bone health and remodeling',
    'Supports bone health and remodeling',
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
    'Geriatric osteoarthritis flares often need a practical plan centered on daily function, walking tolerance, and confidence rather than aggressive exercise complexity. The aim is to reduce flare intensity while preserving independence and strength.',
    'Geriatric osteoarthritis flare من إصابات كبار السن التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Morning stiffness and slower movement after sitting', 'Pain with longer walks, stairs, or standing tasks', 'Reduced confidence carrying groceries or getting up from a chair', 'Flares after unusually active days or poor recovery'],
    ARRAY[]::text[],
    ARRAY['Chair rises, walking tolerance, balance, and manageable lower-body strengthening are often key priorities.', 'Pacing matters a lot because older adults may flare after doing too much on a good day.', 'Consistency usually matters more than intensity spikes in osteoarthritis management.'],
    ARRAY[]::text[],
    ARRAY['Protein becomes especially important for preserving muscle and function in older adults.', 'Hydration, regular meals, and vitamin D adequacy can support better day-to-day tolerance.', 'Severe calorie restriction is usually a poor fit when the main goal is preserving mobility and independence.'],
    ARRAY[]::text[],
    '[{"q_en":"What helps older adults with knee OA most functionally?","a_en":"Steady walking tolerance, chair-rise strength, manageable body-weight control when relevant, and avoiding inactivity after flare days.","q_ar":"What helps older adults with knee OA most functionally?","a_ar":"Steady walking tolerance, chair-rise strength, manageable body-weight control when relevant, and avoiding inactivity after flare days."},{"q_en":"Should painful days mean no movement at all?","a_en":"Usually no. Gentle, scaled activity often helps maintain function better than complete rest.","q_ar":"Should painful days mean no movement at all?","a_ar":"Usually no. Gentle, scaled activity often helps maintain function better than complete rest."},{"q_en":"Why does weakness matter so much in osteoarthritis?","a_en":"Because strength supports joint loading, balance, and daily independence even when the joint itself stays sensitive.","q_ar":"Why does weakness matter so much in osteoarthritis?","a_ar":"Because strength supports joint loading, balance, and daily independence even when the joint itself stays sensitive."}]'::jsonb
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
    'acl_reconstruction',
    'ACL reconstruction',
    'جراحة إعادة بناء الرباط الصليبي الأمامي',
    'Post-surgery',
    'Knee',
    'الركبة',
    'ACL reconstruction needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'جراحة إعادة بناء الرباط الصليبي الأمامي من إصابات ما بعد الجراحة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'After surgery, appetite, hydration, protein timing, and wound-healing support matter from day one through late rehab.',
    'جراحة إعادة بناء الرباط الصليبي الأمامي: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Structured rehab', 'Athletic return', 'Orthopedic follow-up', 'Knee', 'Post-surgery'],
    ARRAY['Post-op calf swelling', 'Fever or wound changes', 'Unexpected pain spike with function drop'],
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
    ARRAY['Medication review is essential because analgesics, anticoagulants, and antibiotics may change supplement safety.'],
    ARRAY[]::text[],
    ARRAY['Supplement use should fit the surgeon and physio plan, especially near procedures.'],
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
    'Immediate post-op',
    'المرحلة 1: حاد',
    '0-14 days',
    '0-14 days',
    'under_48h',
    ARRAY['Reduce irritability in ACL reconstruction', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein at each meal', 'Collagen and vitamin C where appropriate', 'Hydration', 'Carbs around rehab'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Soup with chicken', 'Rice', 'Eggs', 'Citrus fruit'],
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
    ARRAY['Protected mobility', 'Surgeon-guided strengthening', 'Phase-based rehab progression'],
    ARRAY[]::text[],
    ARRAY['Jumping ahead of protocol milestones', 'Uncleared loading'],
    ARRAY[]::text[],
    1.9,
    2.3,
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
    'Overnight oats with yogurt and berries',
    'Overnight oats with yogurt and berries',
    'Chicken soup with rice and carrots',
    'Chicken soup with rice and carrots',
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cottage cheese and kiwi',
    'Cottage cheese and kiwi',
    ARRAY['Greek yogurt', 'Chicken', 'Rice', 'Eggs', 'Oranges', 'Oats'],
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
    'Protected rebuild',
    'المرحلة 2: إصلاح وإعادة بناء',
    '2-8 weeks',
    '2-8 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in ACL reconstruction', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein at each meal', 'Collagen and vitamin C where appropriate', 'Hydration', 'Carbs around rehab'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Soup with chicken', 'Rice', 'Eggs', 'Citrus fruit'],
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
    ARRAY['Protected mobility', 'Surgeon-guided strengthening', 'Phase-based rehab progression'],
    ARRAY[]::text[],
    ARRAY['Jumping ahead of protocol milestones', 'Uncleared loading'],
    ARRAY[]::text[],
    1.9,
    2.3,
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
    'Overnight oats with yogurt and berries',
    'Overnight oats with yogurt and berries',
    'Chicken soup with rice and carrots',
    'Chicken soup with rice and carrots',
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cottage cheese and kiwi',
    'Cottage cheese and kiwi',
    ARRAY['Greek yogurt', 'Chicken', 'Rice', 'Eggs', 'Oranges', 'Oats'],
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
    'Late rehab and return',
    'المرحلة 3: العودة للرياضة',
    '8+ weeks',
    '8+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for ACL reconstruction', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein at each meal', 'Collagen and vitamin C where appropriate', 'Hydration', 'Carbs around rehab'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Soup with chicken', 'Rice', 'Eggs', 'Citrus fruit'],
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
    ARRAY['Protected mobility', 'Surgeon-guided strengthening', 'Phase-based rehab progression'],
    ARRAY[]::text[],
    ARRAY['Jumping ahead of protocol milestones', 'Uncleared loading'],
    ARRAY[]::text[],
    1.9,
    2.3,
    36,
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
    'Overnight oats with yogurt and berries',
    'Overnight oats with yogurt and berries',
    'Chicken soup with rice and carrots',
    'Chicken soup with rice and carrots',
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cottage cheese and kiwi',
    'Cottage cheese and kiwi',
    ARRAY['Greek yogurt', 'Chicken', 'Rice', 'Eggs', 'Oranges', 'Oats'],
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
    'Creatine monohydrate',
    '5 g/day',
    '5 g/day',
    'Supports strength and lean mass during rehab',
    'Supports strength and lean mass during rehab',
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'ACL reconstruction is a post-surgical marathon, not a short block. Nutrition and rehab need to support wound healing early, preserve lean mass through restrictions, and later power high-quality strength and field work.',
    'جراحة إعادة بناء الرباط الصليبي الأمامي من إصابات ما بعد الجراحة التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Post-op swelling, stiffness, and appetite disruption', 'Quadriceps inhibition and weakness after surgery', 'Fatigue during early rehab because loading capacity drops fast', 'Loss of confidence with running, deceleration, and direction changes later on'],
    ARRAY[]::text[],
    ARRAY['The first phase is about extension, swelling control, wound healing, and reducing early muscle loss.', 'Mid rehab usually builds strength symmetry, single-leg loading, and running tolerance.', 'Late rehab must restore explosive confidence, hop quality, and sport-specific endurance before return.'],
    ARRAY[]::text[],
    ARRAY['Post-op appetite loss makes protein planning even more important in the first weeks.', 'Creatine fits well once regular rehab and strength work are underway.', 'Collagen may be useful before tendon or jumping sessions in later phases, but it is not the main driver.'],
    ARRAY[]::text[],
    '[{"q_en":"Why is protein so important after ACL reconstruction?","a_en":"Because surgery plus reduced loading creates a strong environment for muscle loss, especially in the quadriceps, unless protein and rehab are handled well.","q_ar":"Why is protein so important after ACL reconstruction?","a_ar":"Because surgery plus reduced loading creates a strong environment for muscle loss, especially in the quadriceps, unless protein and rehab are handled well."},{"q_en":"When does nutrition matter most after surgery?","a_en":"Immediately. Appetite, hydration, protein quality, and total calorie intake matter from the first week onward, not only later in rehab.","q_ar":"When does nutrition matter most after surgery?","a_ar":"Immediately. Appetite, hydration, protein quality, and total calorie intake matter from the first week onward, not only later in rehab."},{"q_en":"Can I diet aggressively after surgery?","a_en":"Usually that is a bad tradeoff. Aggressive restriction can worsen muscle retention, energy, and rehab quality in the early post-op period.","q_ar":"Can I diet aggressively after surgery?","a_ar":"Usually that is a bad tradeoff. Aggressive restriction can worsen muscle retention, energy, and rehab quality in the early post-op period."}]'::jsonb
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
