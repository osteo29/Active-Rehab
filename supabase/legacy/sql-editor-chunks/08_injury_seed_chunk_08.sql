-- Injuries 71 to 80 of 100
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
    'lumbar_disc_herniation',
    'Lumbar disc herniation',
    'Lumbar disc herniation',
    'Overuse',
    'Back',
    'الظهر',
    'Lumbar disc herniation needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the back.',
    'Lumbar disc herniation من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'Lumbar disc herniation: خطة تأهيل على مراحل لمنطقة الظهر، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Back', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in Lumbar disc herniation', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Lumbar disc herniation', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Lumbar disc herniation', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Lumbar disc herniation often improves best with smart movement selection, graded trunk and hip loading, and a patient return to bending tolerance. The aim is to reduce leg symptoms and rebuild daily function step by step.',
    'Lumbar disc herniation من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Low back pain with radiation to the buttock or leg', 'Tingling, numbness, or burning below the knee', 'Pain that worsens with bending, sitting, coughing, or sneezing', 'Loss of confidence with lifting or prolonged sitting'],
    ARRAY[]::text[],
    ARRAY['Early phases often emphasize directional preference work, walking tolerance, and calming leg symptoms.', 'As symptoms centralize, trunk endurance, hip strength, and graded bending become more important.', 'Late return should rebuild lifting, work tasks, and impact gradually rather than all at once.'],
    ARRAY[]::text[],
    ARRAY['Protein intake helps protect lean mass when pain reduces training load.', 'Hydration and fiber matter if pain medication slows appetite or digestion.', 'Avoid aggressive dieting while trying to restore spinal load tolerance.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does sitting often feel worse than walking?","a_en":"Because some disc-sensitive cases tolerate repeated low-level walking better than sustained flexed sitting pressure.","q_ar":"Why does sitting often feel worse than walking?","a_ar":"Because some disc-sensitive cases tolerate repeated low-level walking better than sustained flexed sitting pressure."},{"q_en":"Does a disc bulge always explain every symptom?","a_en":"Not always. Imaging findings and real symptoms do not match perfectly, so the clinical picture still matters.","q_ar":"Does a disc bulge always explain every symptom?","a_ar":"Not always. Imaging findings and real symptoms do not match perfectly, so the clinical picture still matters."}]'::jsonb
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
    'lumbar_spinal_stenosis',
    'Lumbar spinal stenosis',
    'Lumbar spinal stenosis',
    'Overuse',
    'Back',
    'الظهر',
    'Lumbar spinal stenosis needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the back.',
    'Lumbar spinal stenosis من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'Lumbar spinal stenosis: خطة تأهيل على مراحل لمنطقة الظهر، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Back', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in Lumbar spinal stenosis', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Lumbar spinal stenosis', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Lumbar spinal stenosis', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Lumbar spinal stenosis often behaves like a tolerance problem with standing and walking rather than a single pain-only issue. Good plans improve flexion-based comfort, strength, and practical daily pacing.',
    'Lumbar spinal stenosis من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Back or leg symptoms that build during standing or walking', 'Relief when sitting or bending forward', 'Heaviness or fatigue in the legs with distance', 'Shorter comfortable walking tolerance over time'],
    ARRAY[]::text[],
    ARRAY['Many patients do well with flexion-biased positions, supported cardio, and graded walking plans.', 'Hip and trunk strength can improve daily capacity even when imaging remains unchanged.', 'Progress should be judged by function, walking distance, and tolerance, not only pain on one day.'],
    ARRAY[]::text[],
    ARRAY['Weight management can help some cases, but severe restriction is rarely the answer.', 'Protein remains important because walking limitation can reduce general activity and muscle stimulus.', 'Simple, repeatable meals often work best for older adults managing chronic symptoms.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does leaning on a cart feel easier when walking?","a_en":"Because a flexed posture can reduce extension-related symptom provocation in some stenosis presentations.","q_ar":"Why does leaning on a cart feel easier when walking?","a_ar":"Because a flexed posture can reduce extension-related symptom provocation in some stenosis presentations."},{"q_en":"Can exercise still help even if the canal is narrowed?","a_en":"Often yes. Strength, pacing, and position-specific training can improve function even when anatomy does not fully change.","q_ar":"Can exercise still help even if the canal is narrowed?","a_ar":"Often yes. Strength, pacing, and position-specific training can improve function even when anatomy does not fully change."}]'::jsonb
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
    'de_quervain_tenosynovitis',
    'De Quervain tenosynovitis',
    'De Quervain tenosynovitis',
    'Overuse',
    'Wrist',
    'الرسغ',
    'De Quervain tenosynovitis needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the wrist.',
    'De Quervain tenosynovitis من إصابات إجهاد مزمن التي تؤثر على الرسغ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'De Quervain tenosynovitis: خطة تأهيل على مراحل لمنطقة الرسغ، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Wrist', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in De Quervain tenosynovitis', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in De Quervain tenosynovitis', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for De Quervain tenosynovitis', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'De Quervain symptoms usually respond to reducing thumb overload, calming irritability, and gradually rebuilding pinch and grip tolerance. The main target is making daily hand use comfortable again.',
    'De Quervain tenosynovitis من إصابات إجهاد مزمن التي تؤثر على الرسغ، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain on the thumb side of the wrist', 'Irritation with gripping, lifting, or picking up a child', 'Tenderness near the base of the thumb', 'Pain that builds with repeated thumb positioning'],
    ARRAY[]::text[],
    ARRAY['Early phases often use splinting or activity modification to reduce repeated thumb stress.', 'As pain settles, thumb range, grip tolerance, and forearm support work become more useful.', 'Return should build through manageable hand tasks instead of sudden high-volume use.'],
    ARRAY[]::text[],
    ARRAY['Protein and consistent meals help tissue recovery when pain interrupts daily function.', 'Omega-3 and anti-inflammatory food quality can support overall recovery habits.', 'Supplements alone will not offset repeated thumb overload if the daily trigger remains unchanged.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does holding my phone or baby make it worse?","a_en":"Because those positions often keep the thumb tendons under repeated low-level strain for long periods.","q_ar":"Why does holding my phone or baby make it worse?","a_ar":"Because those positions often keep the thumb tendons under repeated low-level strain for long periods."},{"q_en":"Can the pain return after it improves?","a_en":"Yes, especially if the same repetitive thumb loading returns quickly without better hand pacing.","q_ar":"Can the pain return after it improves?","a_ar":"Yes, especially if the same repetitive thumb loading returns quickly without better hand pacing."}]'::jsonb
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
    'greater_trochanteric_pain_syndrome',
    'Greater trochanteric pain syndrome',
    'Greater trochanteric pain syndrome',
    'Overuse',
    'Hip',
    'الورك',
    'Greater trochanteric pain syndrome needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the hip.',
    'Greater trochanteric pain syndrome من إصابات إجهاد مزمن التي تؤثر على الورك، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'Greater trochanteric pain syndrome: خطة تأهيل على مراحل لمنطقة الورك، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Hip', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in Greater trochanteric pain syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Greater trochanteric pain syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Greater trochanteric pain syndrome', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'cubital_tunnel_syndrome',
    'Cubital tunnel syndrome',
    'Cubital tunnel syndrome',
    'Overuse',
    'Elbow',
    'الكوع',
    'Cubital tunnel syndrome needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the elbow.',
    'Cubital tunnel syndrome من إصابات إجهاد مزمن التي تؤثر على الكوع، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'Cubital tunnel syndrome: خطة تأهيل على مراحل لمنطقة الكوع، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Elbow', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in Cubital tunnel syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Cubital tunnel syndrome', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Cubital tunnel syndrome', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Cubital tunnel symptoms usually improve when elbow position, nerve irritation, and hand-forearm loading are managed together. The aim is to calm tingling and preserve hand function before weakness becomes more established.',
    'Cubital tunnel syndrome من إصابات إجهاد مزمن التي تؤثر على الكوع، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Numbness or tingling in the ring and little fingers', 'Symptoms worsening with prolonged elbow bending', 'Weak grip or clumsier fine hand control', 'Inner elbow discomfort that can spread down the forearm'],
    ARRAY[]::text[],
    ARRAY['Night positioning and avoiding long elbow flexion often help early symptom control.', 'Later phases can include nerve glides, hand strengthening, and posture or workstation changes.', 'Progress should focus on daily hand use and symptom frequency, not only pain intensity.'],
    ARRAY[]::text[],
    ARRAY['Regular protein intake helps when symptoms reduce training and hand use confidence.', 'B12 adequacy matters in broader nerve-health discussions, but supplementation should be context-aware.', 'Sleep quality matters because night symptoms often amplify fatigue and pain sensitivity.'],
    ARRAY[]::text[],
    '[{"q_en":"Why is it worse when I sleep with my elbow bent?","a_en":"Because prolonged flexion can increase pressure on the ulnar nerve around the elbow during the night.","q_ar":"Why is it worse when I sleep with my elbow bent?","a_ar":"Because prolonged flexion can increase pressure on the ulnar nerve around the elbow during the night."},{"q_en":"Can gym training continue with cubital tunnel symptoms?","a_en":"Often yes, but gripping dose, elbow angles, and total upper-limb load may need modification first.","q_ar":"Can gym training continue with cubital tunnel symptoms?","a_ar":"Often yes, but gripping dose, elbow angles, and total upper-limb load may need modification first."}]'::jsonb
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
    'sciatica',
    'Sciatica / lumbar radicular pain',
    'Sciatica / lumbar radicular pain',
    'Overuse',
    'Back',
    'الظهر',
    'Sciatica / lumbar radicular pain needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the back.',
    'Sciatica / lumbar radicular pain من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Chronic irritation usually improves with load management, sleep, recovery nutrition, and a slower build back up.',
    'Sciatica / lumbar radicular pain: خطة تأهيل على مراحل لمنطقة الظهر، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
    ARRAY['Repetitive training', 'Desk work', 'Load accumulation', 'Back', 'Overuse'],
    ARRAY['Pain that is spreading', 'Persistent neurological symptoms', 'Night pain or unexplained weakness'],
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
    ARRAY['Medication interactions matter if adding curcumin, fish oil, or high-dose magnesium.'],
    ARRAY[]::text[],
    ARRAY['Do not stack many supplements while ignoring sleep, stress, and load management.'],
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
    ARRAY['Reduce irritability in Sciatica / lumbar radicular pain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Repair and reload',
    'المرحلة 2: إصلاح وإعادة بناء',
    '5 days to 6 weeks',
    '5 days to 6 weeks',
    'days_3_14',
    ARRAY['Reduce irritability in Sciatica / lumbar radicular pain', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    3,
    'Return phase',
    'المرحلة 3: العودة للرياضة',
    '6+ weeks',
    '6+ weeks',
    'over_6_weeks',
    ARRAY['Progress loading tolerance for Sciatica / lumbar radicular pain', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
    ARRAY[]::text[],
    ARRAY['Steady protein intake', 'Hydration', 'Anti-inflammatory food pattern', 'Adequate carbs for training tolerance'],
    ARRAY[]::text[],
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish'],
    ARRAY[]::text[],
    ARRAY['Meal skipping', 'Alcohol binges', 'Long low-energy days'],
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
    ARRAY['Load management', 'Mobility work', 'Progressive strengthening', 'Gradual return to volume'],
    ARRAY[]::text[],
    ARRAY['Volume spikes', 'Repeated painful technique work without recovery'],
    ARRAY[]::text[],
    1.6,
    2,
    37,
    2,
    5,
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
    'Overnight oats with yogurt and fruit',
    'Overnight oats with yogurt and fruit',
    'Bean and rice bowl with olive oil',
    'Bean and rice bowl with olive oil',
    'Fish or tofu with potatoes and vegetables',
    'Fish or tofu with potatoes and vegetables',
    'Yogurt and banana',
    'Yogurt and banana',
    ARRAY['Fruit', 'Olive oil', 'Beans', 'Greek yogurt', 'Fatty fish', 'Rice'],
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
    'Supports inflammation control and food quality',
    'Supports inflammation control and food quality',
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
    'Sciatica is usually a nerve-sensitivity presentation rather than just a back-only problem. Good recovery depends on calming the irritated pathway, restoring movement, and avoiding repeated flare patterns.',
    'Sciatica / lumbar radicular pain من إصابات إجهاد مزمن التي تؤثر على الظهر، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain traveling from the low back or buttock into the leg', 'Pins and needles, burning, or numbness below the knee', 'Symptoms worsening with sitting or certain bending positions', 'Reduced confidence with walking, lifting, or long travel'],
    ARRAY[]::text[],
    ARRAY['Early phases often emphasize symptom reduction, walking tolerance, and position changes that calm the leg.', 'As irritability settles, nerve mobility, trunk work, and hip strength become more useful.', 'Long-term success depends on managing recurring triggers, not only waiting for pain to vanish.'],
    ARRAY[]::text[],
    ARRAY['Steady meals, hydration, and enough protein can support recovery when movement drops.', 'Very high supplement dosing is less useful than fixing low sleep, low movement quality, and inconsistent eating.', 'Fiber and hydration matter if medication side effects affect bowel function.'],
    ARRAY[]::text[],
    '[{"q_en":"Is sciatica always caused by a disc problem?","a_en":"Not always. Discs are common causes, but other sources can also irritate the nerve pathway or mimic similar leg symptoms.","q_ar":"Is sciatica always caused by a disc problem?","a_ar":"Not always. Discs are common causes, but other sources can also irritate the nerve pathway or mimic similar leg symptoms."},{"q_en":"Why does sitting aggravate it so much?","a_en":"Because sustained positions can keep the nerve system or the involved spinal tissues under more constant irritation.","q_ar":"Why does sitting aggravate it so much?","a_ar":"Because sustained positions can keep the nerve system or the involved spinal tissues under more constant irritation."}]'::jsonb
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
    'acl_meniscus_combined',
    'ACL + Meniscus combined injury',
    'ACL + Meniscus combined injury',
    'Sports',
    'Knee',
    'الركبة',
    'ACL + Meniscus combined injury needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'ACL + Meniscus combined injury من إصابات إصابات رياضية التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'ACL + Meniscus combined injury: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
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
    ARRAY['Reduce irritability in ACL + Meniscus combined injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in ACL + Meniscus combined injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for ACL + Meniscus combined injury', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'Combined ACL and meniscus injuries need a more careful plan than either injury alone because swelling, range limits, quad inhibition, and rotational confidence all overlap. The rehab timeline usually depends on both stability demands and the exact meniscus management.',
    'ACL + Meniscus combined injury من إصابات إصابات رياضية التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['A twisting knee injury followed by swelling and instability', 'Joint line pain or catching alongside ligament-related giving way', 'Reduced confidence with pivoting, stairs, or deceleration', 'Persistent quadriceps weakness and limited loaded knee flexion'],
    ARRAY[]::text[],
    ARRAY['Early rehab often balances swelling control, extension range, quadriceps activation, and any meniscus-related protection rules.', 'Mid rehab should rebuild single-leg strength and movement quality without rushing rotation-heavy drills.', 'Late return to sport needs both ligament confidence and good tolerance to compression, landing, and change of direction.'],
    ARRAY[]::text[],
    ARRAY['High-quality protein is crucial because muscle loss can be significant when both stability and joint symptoms reduce loading.', 'Creatine is often a useful support when strength work is limited early or after surgery.', 'Avoid large calorie deficits while trying to rebuild knee function and muscle mass.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does this injury usually take longer than a simple knee sprain?","a_en":"Because the knee has to recover both rotational stability and joint tolerance, not just calm pain or swelling.","q_ar":"Why does this injury usually take longer than a simple knee sprain?","a_ar":"Because the knee has to recover both rotational stability and joint tolerance, not just calm pain or swelling."},{"q_en":"Can I progress strength if the meniscus is still irritable?","a_en":"Usually yes, but exercise depth, rotation, and loading angles often need more careful adjustment.","q_ar":"Can I progress strength if the meniscus is still irritable?","a_ar":"Usually yes, but exercise depth, rotation, and loading angles often need more careful adjustment."},{"q_en":"What is the main early nutrition priority?","a_en":"Enough energy and protein to reduce muscle loss while the knee is not tolerating normal training.","q_ar":"What is the main early nutrition priority?","a_ar":"Enough energy and protein to reduce muscle loss while the knee is not tolerating normal training."}]'::jsonb
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
    'rotator_cuff_labrum_complex',
    'Rotator cuff + Labrum complex shoulder injury',
    'Rotator cuff + Labrum complex shoulder injury',
    'Sports',
    'Shoulder',
    'الكتف',
    'Rotator cuff + Labrum complex shoulder injury needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'Rotator cuff + Labrum complex shoulder injury من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'Rotator cuff + Labrum complex shoulder injury: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
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
    ARRAY['Reduce irritability in Rotator cuff + Labrum complex shoulder injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Rotator cuff + Labrum complex shoulder injury', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Rotator cuff + Labrum complex shoulder injury', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'Complex shoulder injuries involving both the rotator cuff and labrum usually need a bigger focus on stability, repeated overhead tolerance, and movement quality under fatigue. The goal is to rebuild a dependable shoulder, not just a temporarily quiet one.',
    'Rotator cuff + Labrum complex shoulder injury من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Deep shoulder pain with overhead loading or repeated throwing', 'Weakness, instability, or clicking in high-range positions', 'Loss of trust during pressing, catching, or overhead sport work', 'Symptoms that return under fatigue or repeated sets'],
    ARRAY[]::text[],
    ARRAY['Early rehab often blends pain-limited cuff loading with stability-focused movement control.', 'Mid phases need cuff strength, scapular support, and progressive overhead exposure together.', 'Return to sport should include repeated high-quality overhead output, not only clinic-style exercises.'],
    ARRAY[]::text[],
    ARRAY['Protein and total calories matter because upper-body deconditioning happens quickly when shoulder load drops.', 'Creatine can support strength retention during reduced training phases.', 'Under-fueling is a common reason complex shoulder rehab stalls once harder training is reintroduced.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does the shoulder feel okay in the gym but unstable in sport?","a_en":"Because sport often adds speed, fatigue, and repeated overhead force that simple gym movements may not reproduce.","q_ar":"Why does the shoulder feel okay in the gym but unstable in sport?","a_ar":"Because sport often adds speed, fatigue, and repeated overhead force that simple gym movements may not reproduce."},{"q_en":"Do I need complete rest from all shoulder work?","a_en":"Usually no. Most athletes do better with modified loading than with total inactivity.","q_ar":"Do I need complete rest from all shoulder work?","a_ar":"Usually no. Most athletes do better with modified loading than with total inactivity."},{"q_en":"What matters most before return to play?","a_en":"Repeated strength, overhead tolerance, and position-specific confidence under real sport demands.","q_ar":"What matters most before return to play?","a_ar":"Repeated strength, overhead tolerance, and position-specific confidence under real sport demands."}]'::jsonb
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
    'overhead_throwers_shoulder',
    'Overhead thrower’s shoulder (internal impingement)',
    'كتف الرامي',
    'Sports',
    'Shoulder',
    'الكتف',
    'Overhead thrower’s shoulder (internal impingement) needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the shoulder.',
    'كتف الرامي من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'كتف الرامي: خطة تأهيل على مراحل لمنطقة الكتف، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
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
    ARRAY['Reduce irritability in Overhead thrower’s shoulder (internal impingement)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Overhead thrower’s shoulder (internal impingement)', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Overhead thrower’s shoulder (internal impingement)', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'Thrower’s shoulder usually reflects a high-speed overload problem across the cuff, labrum, scapula, and trunk, not just one painful structure. The right plan reduces irritability first, then rebuilds shoulder output and throwing tolerance in stages.',
    'كتف الرامي من إصابات إصابات رياضية التي تؤثر على الكتف، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Pain during late cocking or acceleration while throwing', 'Loss of velocity, command, or shoulder trust', 'Posterior shoulder tightness or deep joint discomfort', 'Symptoms that appear after higher throw volume or intensity blocks'],
    ARRAY[]::text[],
    ARRAY['Early management often reduces throwing dose while restoring cuff and scapular control.', 'Thoracic mobility, trunk contribution, and lower-body sequencing often matter as much as the shoulder itself.', 'Return to full throwing needs a structured interval plan and workload monitoring, not guesswork.'],
    ARRAY[]::text[],
    ARRAY['Throwers need enough total energy and carbohydrate to recover from repeated high-output sessions when volume increases again.', 'Protein supports shoulder and trunk strength retention during reduced-throw periods.', 'Poor recovery between bullpen or throwing days often slows progress more than any single supplement choice.'],
    ARRAY[]::text[],
    '[{"q_en":"Why does my shoulder hurt mainly when I throw hard?","a_en":"Because maximal throwing exposes high-speed shoulder positions and forces that normal gym work may not reproduce.","q_ar":"Why does my shoulder hurt mainly when I throw hard?","a_ar":"Because maximal throwing exposes high-speed shoulder positions and forces that normal gym work may not reproduce."},{"q_en":"Can mechanics really change symptoms that much?","a_en":"Yes. Scapular control, trunk timing, and lower-body contribution can all influence how much stress reaches the shoulder and elbow.","q_ar":"Can mechanics really change symptoms that much?","a_ar":"Yes. Scapular control, trunk timing, and lower-body contribution can all influence how much stress reaches the shoulder and elbow."},{"q_en":"Should I stop lifting while returning to throw?","a_en":"Usually no, but the lifting plan should support throwing recovery rather than compete with it.","q_ar":"Should I stop lifting while returning to throw?","a_ar":"Usually no, but the lifting plan should support throwing recovery rather than compete with it."}]'::jsonb
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
    'runners_knee_patellar_tendon',
    'Runner’s knee / Patellar tendinopathy',
    'Runner’s knee / Patellar tendinopathy',
    'Sports',
    'Knee',
    'الركبة',
    'Runner’s knee / Patellar tendinopathy needs a staged plan that matches tissue healing, pain behavior, and progressive rehab loading in the knee.',
    'Runner’s knee / Patellar tendinopathy من إصابات إصابات رياضية التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    'Complex sport injuries need enough energy, enough protein, and careful return-to-play fueling around longer rehab blocks.',
    'Runner’s knee / Patellar tendinopathy: خطة تأهيل على مراحل لمنطقة الركبة، من تهدئة الأعراض حتى العودة التدريجية للنشاط.',
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
    ARRAY['Reduce irritability in Runner’s knee / Patellar tendinopathy', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Reduce irritability in Runner’s knee / Patellar tendinopathy', 'Protect tissue quality and appetite', 'Build the next rehab step safely'],
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
    ARRAY['Progress loading tolerance for Runner’s knee / Patellar tendinopathy', 'Restore movement confidence and function', 'Prepare for return to work, sport, or daily activity'],
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
    'Runner’s knee and patellar tendon irritation often happen when training load rises faster than tissue tolerance. Good results usually come from better load planning, lower-limb strength, and enough fuel to support adaptation.',
    'Runner’s knee / Patellar tendinopathy من إصابات إصابات رياضية التي تؤثر على الركبة، وتحتاج إلى تدرج جيد في العلاج والتغذية والعودة للنشاط.',
    ARRAY['Anterior knee pain during runs, stairs, or hills', 'Pain that builds with mileage or speed work', 'Stiffness around the kneecap or tendon after sessions', 'Reduced confidence in downhill, tempo, or jump work'],
    ARRAY[]::text[],
    ARRAY['Running load often needs adjustment first, but strength work usually drives the long-term fix.', 'Quadriceps, calf, and hip capacity all matter in returning the knee to regular mileage.', 'The return to speed should be layered in after steady easy running and strength are tolerable.'],
    ARRAY[]::text[],
    ARRAY['Under-fueling is common in runners and can quietly slow tendon and joint adaptation.', 'Protein supports strength retention while run volume is modified.', 'Carbohydrates are especially important if symptoms started during higher mileage or intensity blocks.'],
    ARRAY[]::text[],
    '[{"q_en":"Should I stop running completely?","a_en":"Not always. Some runners can stay running with smart mileage changes, while others need a short reset before building back up.","q_ar":"Should I stop running completely?","a_ar":"Not always. Some runners can stay running with smart mileage changes, while others need a short reset before building back up."},{"q_en":"Why do hills make it worse?","a_en":"Because they increase knee loading and often raise demand on the patellofemoral joint or tendon beyond current tolerance.","q_ar":"Why do hills make it worse?","a_ar":"Because they increase knee loading and often raise demand on the patellofemoral joint or tendon beyond current tolerance."},{"q_en":"Does foam rolling fix runner’s knee?","a_en":"It may help symptoms temporarily, but long-term progress usually needs better strength and better run-load management.","q_ar":"Does foam rolling fix runner’s knee?","a_ar":"It may help symptoms temporarily, but long-term progress usually needs better strength and better run-load management."}]'::jsonb
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
