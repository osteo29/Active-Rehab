-- Injuries 41 to 50 of 100
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
    'patella_fracture',
    'Patella fracture',
    'كسر عظم الرضفة',
    'Bone',
    'Knee',
    'الركبة',
    'Patella fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'كسر عظم الرضفة من إصابات عظام التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Bone healing needs adequate energy, protein, calcium support, and respect for protected loading timelines.',
    'كسر عظم الرضفة: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Contact trauma', 'Load spikes', 'Knee', 'Bone'],
    ARRAY['Night pain', 'Deformity', 'Neurovascular symptoms', 'Pain worsening at rest'],
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
    ARRAY['Calcium timing can affect absorption of thyroid, iron, or some antibiotics.'],
    ARRAY[]::text[],
    ARRAY['Check vitamin D dosing against clinician guidance when possible.'],
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
    ARRAY['Reduce irritability in Patella fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    ARRAY['Progress loading tolerance for Patella fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    'talus_fracture',
    'Talus fracture',
    'كسر عظم التالوس',
    'Bone',
    'Ankle',
    'الكاحل',
    'Talus fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the ankle.',
    'كسر عظم التالوس من إصابات عظام التي تؤثر على الكاحل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Bone healing needs adequate energy, protein, calcium support, and respect for protected loading timelines.',
    'كسر عظم التالوس: خطة تأهيل على مراحل لمنطقة الكاحل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Contact trauma', 'Load spikes', 'Ankle', 'Bone'],
    ARRAY['Night pain', 'Deformity', 'Neurovascular symptoms', 'Pain worsening at rest'],
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
    ARRAY['Calcium timing can affect absorption of thyroid, iron, or some antibiotics.'],
    ARRAY[]::text[],
    ARRAY['Check vitamin D dosing against clinician guidance when possible.'],
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
    ARRAY['Reduce irritability in Talus fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    ARRAY['Progress loading tolerance for Talus fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    'humeral_head_fracture',
    'Humeral head fracture',
    'كسر رأس عظم العضد',
    'Bone',
    'Shoulder',
    'الكتف',
    'Humeral head fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'كسر رأس عظم العضد من إصابات عظام التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Bone healing needs adequate energy, protein, calcium support, and respect for protected loading timelines.',
    'كسر رأس عظم العضد: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Contact trauma', 'Load spikes', 'Shoulder', 'Bone'],
    ARRAY['Night pain', 'Deformity', 'Neurovascular symptoms', 'Pain worsening at rest'],
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
    ARRAY['Calcium timing can affect absorption of thyroid, iron, or some antibiotics.'],
    ARRAY[]::text[],
    ARRAY['Check vitamin D dosing against clinician guidance when possible.'],
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
    ARRAY['Reduce irritability in Humeral head fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    ARRAY['Progress loading tolerance for Humeral head fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    'pelvic_avulsion_fracture',
    'Pelvic avulsion fracture',
    'كسر الحوض بالانفصال',
    'Bone',
    'Pelvis',
    'الحوض',
    'Pelvic avulsion fracture needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the pelvis.',
    'كسر الحوض بالانفصال من إصابات عظام التي تؤثر على الحوض، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Bone healing needs adequate energy, protein, calcium support, and respect for protected loading timelines.',
    'كسر الحوض بالانفصال: خطة تأهيل على مراحل لمنطقة الحوض، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Falls', 'Contact trauma', 'Load spikes', 'Pelvis', 'Bone'],
    ARRAY['Night pain', 'Deformity', 'Neurovascular symptoms', 'Pain worsening at rest'],
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
    ARRAY['Calcium timing can affect absorption of thyroid, iron, or some antibiotics.'],
    ARRAY[]::text[],
    ARRAY['Check vitamin D dosing against clinician guidance when possible.'],
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
    ARRAY['Reduce irritability in Pelvic avulsion fracture', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    ARRAY['Progress loading tolerance for Pelvic avulsion fracture', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein', 'Calcium', 'Vitamin D', 'Consistent overall energy intake'],
    ARRAY[]::text[],
    ARRAY['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
    ARRAY[]::text[],
    ARRAY['Very low-calorie cutting', 'Smoking', 'Alcohol excess'],
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
    ARRAY['Protected mobility', 'Strength work for uninvolved areas', 'Cross-training if cleared'],
    ARRAY[]::text[],
    ARRAY['Impact or loading progression before medical clearance'],
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
    'Fish or tofu with potatoes and greens',
    'Fish or tofu with potatoes and greens',
    'Cheese and fruit',
    'Cheese and fruit',
    ARRAY['Milk or soy milk', 'Yogurt', 'Eggs', 'Beans', 'Potatoes', 'Leafy greens'],
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
    'meniscus_tear',
    'Meniscus tear (Knee, Medial/Lateral)',
    'تمزق الغضروف الهلالي',
    'Joint',
    'Knee',
    'الركبة',
    'Meniscus tear (Knee, Medial/Lateral) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'تمزق الغضروف الهلالي من إصابات مفاصل التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'تمزق الغضروف الهلالي: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Knee', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in Meniscus tear (Knee, Medial/Lateral)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in Meniscus tear (Knee, Medial/Lateral)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for Meniscus tear (Knee, Medial/Lateral)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Meniscus tears vary a lot. Some patients mainly struggle with swelling and twisting pain, while others have catching, locking, or surgery-related restrictions. The rehab plan should match the exact irritability and loading tolerance of the knee.',
    'تمزق الغضروف الهلالي من إصابات مفاصل التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Joint line pain when squatting or twisting', 'Swelling after training or long walking', 'Locking, catching, or a blocked feeling in the knee', 'Reduced confidence with stairs, pivots, and deep flexion'],
    ARRAY[]::text[],
    ARRAY['Early goals are usually symptom calming, restoring extension, and avoiding irritated twisting positions.', 'As the knee settles, loading builds through controlled squats, split-stance work, and rotation tolerance.', 'Return to sport depends more on symptom-free loading, hopping, and cutting tolerance than on time alone.'],
    ARRAY[]::text[],
    ARRAY['Protein distribution matters because the knee often limits training volume and muscle stimulus early on.', 'Collagen plus vitamin C can fit well before planned rehab sessions if tolerated.', 'Large energy deficits are a bad idea when the goal is to retain quad and calf strength.'],
    ARRAY[]::text[],
    '[{"q_en":"Should I rest completely with a meniscus tear?","a_en":"Usually no. Most patients do better with symptom-guided loading than with prolonged total rest, unless a clinician has given strict protection instructions.","q_ar":"Should I rest completely with a meniscus tear?","a_ar":"Usually no. Most patients do better with symptom-guided loading than with prolonged total rest, unless a clinician has given strict protection instructions."},{"q_en":"Why does twisting hurt more than straight-line walking?","a_en":"Because the meniscus helps manage rotation and compression together. Twisting often loads the irritated tissue more than straight-line activity.","q_ar":"Why does twisting hurt more than straight-line walking?","a_ar":"Because the meniscus helps manage rotation and compression together. Twisting often loads the irritated tissue more than straight-line activity."},{"q_en":"Does every meniscus tear need surgery?","a_en":"No. Some tears are managed conservatively, while others are repaired or trimmed depending on symptoms, location, and mechanical issues like locking.","q_ar":"Does every meniscus tear need surgery?","a_ar":"No. Some tears are managed conservatively, while others are repaired or trimmed depending on symptoms, location, and mechanical issues like locking."}]'::jsonb
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
    'labrum_tear',
    'Labrum tear (Shoulder / Hip)',
    'تمزق الشفا الحقية',
    'Joint',
    'Shoulder',
    'الكتف',
    'Labrum tear (Shoulder / Hip) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'تمزق الشفا الحقية من إصابات مفاصل التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'تمزق الشفا الحقية: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Shoulder', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in Labrum tear (Shoulder / Hip)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in Labrum tear (Shoulder / Hip)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for Labrum tear (Shoulder / Hip)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Labral injuries can be very different depending on whether the shoulder or hip is involved, but in both cases the plan should improve joint control, loading confidence, and tolerance to repeated motion instead of chasing pain only.',
    'تمزق الشفا الحقية من إصابات مفاصل التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Deep joint pain in the shoulder or hip', 'Clicking, catching, or instability sensations', 'Pain in end-range positions or under repeated sport loading', 'Loss of confidence with rotation, pivoting, or overhead work'],
    ARRAY[]::text[],
    ARRAY['Movement quality and strength around the joint often matter more than passive rest alone.', 'The program should match whether symptoms are more instability-driven, compression-driven, or surgery-related.', 'Return to sport or hard training needs repeated high-quality exposure, not just one good session.'],
    ARRAY[]::text[],
    ARRAY['Protein is especially important when shoulder or hip pain reduces normal training volume.', 'Collagen and vitamin C may fit around connective tissue loading sessions in later rehab.', 'Avoid very low-energy dieting while trying to rebuild stability and strength around a labral injury.'],
    ARRAY[]::text[],
    '[{"q_en":"Does every labral tear need surgery?","a_en":"No. Some patients respond well to rehabilitation, while others need surgery depending on instability, locking, sport demands, or persistent symptoms.","q_ar":"Does every labral tear need surgery?","a_ar":"No. Some patients respond well to rehabilitation, while others need surgery depending on instability, locking, sport demands, or persistent symptoms."},{"q_en":"Why does the joint click even if pain is not constant?","a_en":"Clicking can happen when the joint is irritated or less stable, but the sound itself matters less than whether it is painful or limiting.","q_ar":"Why does the joint click even if pain is not constant?","a_ar":"Clicking can happen when the joint is irritated or less stable, but the sound itself matters less than whether it is painful or limiting."},{"q_en":"Can I still train around a labral injury?","a_en":"Often yes, but exercise selection, depth, speed, and weekly volume usually need more careful management.","q_ar":"Can I still train around a labral injury?","a_ar":"Often yes, but exercise selection, depth, speed, and weekly volume usually need more careful management."}]'::jsonb
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
    'ac_joint_injury',
    'AC joint injury',
    'إصابة مفصل الأخرم والترقوة',
    'Joint',
    'Shoulder',
    'الكتف',
    'AC joint injury needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'إصابة مفصل الأخرم والترقوة من إصابات مفاصل التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'إصابة مفصل الأخرم والترقوة: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Shoulder', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in AC joint injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in AC joint injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for AC joint injury', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'AC joint injuries often behave like persistent top-of-shoulder load intolerance. Good outcomes usually come from smarter pressing progressions, scapular support, and reducing repeated compression rather than forcing through every upper-body session.',
    'إصابة مفصل الأخرم والترقوة من إصابات مفاصل التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Top-of-shoulder pain with pressing or reaching across the body', 'Tenderness at the AC joint after contact or overload', 'Pain lying on the shoulder or carrying heavy objects', 'Reduced tolerance for dips, benching, or overhead volume'],
    ARRAY[]::text[],
    ARRAY['The early priority is usually to reduce painful compression while restoring comfortable shoulder motion.', 'Mid rehab works best when it rebuilds cuff and scapular strength alongside gradual pressing tolerance.', 'Late return needs repeated upper-body loading and sport-specific shoulder confidence if relevant.'],
    ARRAY[]::text[],
    ARRAY['Protein intake helps protect upper-body muscle when pressing and overhead volume are temporarily reduced.', 'Creatine can support shoulder strength retention during modified training blocks.', 'Sleep and pillow position can matter because top-of-shoulder compression often worsens nighttime symptoms.'],
    ARRAY[]::text[],
    '[{"q_en":"Why do benching and dips irritate the AC joint so easily?","a_en":"Because those positions often increase shoulder compression and stress at the top of the joint.","q_ar":"Why do benching and dips irritate the AC joint so easily?","a_ar":"Because those positions often increase shoulder compression and stress at the top of the joint."},{"q_en":"Is full rest the best plan for AC joint pain?","a_en":"Usually no. Modified loading often works better than total inactivity once the most painful positions are identified.","q_ar":"Is full rest the best plan for AC joint pain?","a_ar":"Usually no. Modified loading often works better than total inactivity once the most painful positions are identified."},{"q_en":"Can I return to contact sport with a previous AC issue?","a_en":"Often yes, but repeated loading and contact readiness should be rebuilt gradually.","q_ar":"Can I return to contact sport with a previous AC issue?","a_ar":"Often yes, but repeated loading and contact readiness should be rebuilt gradually."}]'::jsonb
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
    'patellofemoral_pain',
    'Patellofemoral pain syndrome',
    'متلازمة الألم الرضفي الفخذي',
    'Joint',
    'Knee',
    'الركبة',
    'Patellofemoral pain syndrome needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'متلازمة الألم الرضفي الفخذي من إصابات مفاصل التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'متلازمة الألم الرضفي الفخذي: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Knee', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in Patellofemoral pain syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in Patellofemoral pain syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for Patellofemoral pain syndrome', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'Patellofemoral pain often reflects how the whole lower limb is handling load, not only what the kneecap itself is doing. The strongest plans usually rebuild tolerance through hip strength, quad strength, and smarter volume management.',
    'متلازمة الألم الرضفي الفخذي من إصابات مفاصل التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain around or behind the kneecap', 'Symptoms with stairs, squats, running, or long sitting', 'Irritation after sudden increases in knee-heavy training', 'Reduced confidence in deep knee bending or downhill loading'],
    ARRAY[]::text[],
    ARRAY['Hip and quadriceps capacity are often more important than passive treatments alone.', 'Early progress usually comes from reducing aggravating volume and improving controlled knee loading.', 'Return to harder running or jumping should wait until repeated knee-dominant work is tolerable.'],
    ARRAY[]::text[],
    ARRAY['Weight management can matter here, but large deficits often reduce rehab quality.', 'Consistent protein supports quadriceps retention when knee loading is limited.', 'Hydration and regular fueling help when training load is being rebuilt.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does sitting too long make the knee hurt?","a_en":"Because the patellofemoral joint can become more sensitive in flexed positions for long periods, especially when overall knee load tolerance is low.","q_ar":"Why does sitting too long make the knee hurt?","a_ar":"Because the patellofemoral joint can become more sensitive in flexed positions for long periods, especially when overall knee load tolerance is low."},{"q_en":"Is it only a kneecap tracking issue?","a_en":"Usually not. Hip control, training volume, quadriceps capacity, and overall lower-limb loading all matter.","q_ar":"Is it only a kneecap tracking issue?","a_ar":"Usually not. Hip control, training volume, quadriceps capacity, and overall lower-limb loading all matter."},{"q_en":"Can I still squat with patellofemoral pain?","a_en":"Often yes, but depth, tempo, range, and total volume may need adjustment until the knee becomes less reactive.","q_ar":"Can I still squat with patellofemoral pain?","a_ar":"Often yes, but depth, tempo, range, and total volume may need adjustment until the knee becomes less reactive."}]'::jsonb
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
    'ankle_instability',
    'Ankle instability',
    'عدم استقرار الكاحل',
    'Joint',
    'Ankle',
    'الكاحل',
    'Ankle instability needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the ankle.',
    'عدم استقرار الكاحل من إصابات مفاصل التي تؤثر على الكاحل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'عدم استقرار الكاحل: خطة تأهيل على مراحل لمنطقة الكاحل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Ankle', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in Ankle instability', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in Ankle instability', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for Ankle instability', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    'osteoarthritis_flare',
    'Osteoarthritis flare (Knee, Hip, Shoulder)',
    'هشاشة (خشونة) المفاصل',
    'Joint',
    'Whole body',
    'الجسم بالكامل',
    'Osteoarthritis flare (Knee, Hip, Shoulder) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the whole body.',
    'هشاشة (خشونة) المفاصل من إصابات مفاصل التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Joint and cartilage problems need swelling control, symptom-guided loading, and patient progression back to impact.',
    'هشاشة (خشونة) المفاصل: خطة تأهيل على مراحل لمنطقة الجسم بالكامل، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Cutting sports', 'Falls', 'Repetitive joint loading', 'Whole body', 'Joint'],
    ARRAY['Locking', 'Repeated giving way', 'Joint deformity', 'Neurological symptoms'],
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
    ARRAY['Review anti-inflammatory use and bleeding-risk supplements with clinicians when appropriate.'],
    ARRAY[]::text[],
    ARRAY['Food and supplements support joint rehab, but mechanics and load progression still drive outcomes.'],
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
    ARRAY['Reduce irritability in Osteoarthritis flare (Knee, Hip, Shoulder)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Reduce irritability in Osteoarthritis flare (Knee, Hip, Shoulder)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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
    ARRAY['Progress loading tolerance for Osteoarthritis flare (Knee, Hip, Shoulder)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Protein adequacy', 'Hydration', 'Weight management without under-eating', 'Collagen support before loading'],
    ARRAY[]::text[],
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil'],
    ARRAY[]::text[],
    ARRAY['High alcohol intake', 'Under-eating during rehab', 'Very salty processed food'],
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
    ARRAY['Mobility work', 'Strengthening', 'Balance and control drills'],
    ARRAY[]::text[],
    ARRAY['Twisting under pain', 'Full-intensity sport before control returns'],
    ARRAY[]::text[],
    1.6,
    2.1,
    35,
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
    'Greek yogurt, berries, and oats',
    'Greek yogurt, berries, and oats',
    'Rice bowl with fish or tofu',
    'Rice bowl with fish or tofu',
    'Bean stew with vegetables and olive oil',
    'Bean stew with vegetables and olive oil',
    'Fruit and cottage cheese',
    'Fruit and cottage cheese',
    ARRAY['Greek yogurt', 'Berries', 'Beans', 'Fish', 'Olive oil', 'Rice'],
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

  insert into public.injury_page_content (
    injury_id, intro_en, intro_ar, symptoms_en, symptoms_ar, rehab_notes_en, rehab_notes_ar,
    nutrition_notes_en, nutrition_notes_ar, faq_items
  ) values (
    v_injury_id,
    'An osteoarthritis flare, especially knee OA, is usually a load-tolerance problem rather than a signal to stop moving forever. The best plans calm the flare, maintain daily function, and then rebuild joint confidence with steady strength work, walking tolerance, and pacing.',
    'هشاشة (خشونة) المفاصل من إصابات مفاصل التي تؤثر على الجسم بالكامل، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Joint stiffness after rest or in the morning', 'Pain that rises after too much standing, walking, or heavy loading', 'Swelling or aching in a knee, hip, or shoulder during flare periods', 'Reduced confidence with stairs, carrying, or longer activity blocks'],
    ARRAY[]::text[],
    ARRAY['Short-term calming often depends on pacing, symptom-guided movement, and avoiding sudden volume spikes.', 'Long-term progress usually comes from strength work, walking tolerance, and consistent daily loading rather than inactivity, especially in knee OA where quadriceps strength matters a lot.', 'A flare should be used to adjust dose, not to abandon all movement unless a clinician has said otherwise.'],
    ARRAY[]::text[],
    ARRAY['Weight management can help many patients, but aggressive restriction during a painful flare often worsens energy and function.', 'Protein remains important because lower activity can quickly reduce muscle quality around the affected joint.', 'Regular meals, hydration, and sleep quality often influence flare tolerance more than people expect.'],
    ARRAY[]::text[],
    '[{"q_en":"Should I rest completely during an arthritis flare?","a_en":"Usually no. Gentle, tolerable movement often helps more than complete rest, as long as the total dose is scaled down.","q_ar":"Should I rest completely during an arthritis flare?","a_ar":"Usually no. Gentle, tolerable movement often helps more than complete rest, as long as the total dose is scaled down."},{"q_en":"What helps knee OA most in the long run?","a_en":"For many people, the biggest wins come from better quadriceps strength, steady walking tolerance, body-weight management when relevant, and avoiding big activity spikes.","q_ar":"What helps knee OA most in the long run?","a_ar":"For many people, the biggest wins come from better quadriceps strength, steady walking tolerance, body-weight management when relevant, and avoiding big activity spikes."},{"q_en":"Why does stiffness improve once I get moving?","a_en":"Because joints often feel less stiff after circulation, temperature, and repeated motion improve, even when the joint is still sensitive.","q_ar":"Why does stiffness improve once I get moving?","a_ar":"Because joints often feel less stiff after circulation, temperature, and repeated motion improve, even when the joint is still sensitive."},{"q_en":"Is pain during a flare the same as more damage?","a_en":"Not necessarily. Flares often reflect temporary irritability and overload rather than a sudden large structural change.","q_ar":"Is pain during a flare the same as more damage?","a_ar":"Not necessarily. Flares often reflect temporary irritability and overload rather than a sudden large structural change."}]'::jsonb
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
