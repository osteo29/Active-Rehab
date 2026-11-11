import type {FilterState, MainMuscle, StaticMuscleSlug} from './types';

export const MUSCLE_TREE = {
  chest: ['upper_chest', 'middle_chest', 'lower_chest'],
  back: ['lats', 'traps', 'rhomboids', 'erector_spinae'],
  shoulders: ['front_delts', 'side_delts', 'rear_delts'],
  biceps: ['biceps'],
  triceps: ['triceps'],
  forearms: ['forearms'],
  abs: ['upper_abs', 'lower_abs'],
  obliques: ['obliques'],
  lower_back: ['lower_back'],
  glutes: ['glute_max', 'glute_med', 'glute_min'],
  quadriceps: ['rectus_femoris', 'vastus_lateralis', 'vastus_medialis'],
  hamstrings: ['biceps_femoris', 'semitendinosus', 'semimembranosus'],
  calves: ['gastrocnemius', 'soleus'],
} as const;

export const EXERCISE_FINDER_STATIC_LABELS: Record<StaticMuscleSlug, string> = {
  chest: 'Chest',
  back: 'Back',
  shoulders: 'Shoulders',
  biceps: 'Biceps',
  triceps: 'Triceps',
  forearms: 'Forearms',
  abs: 'Abs',
  obliques: 'Obliques',
  lower_back: 'Lower back',
  glutes: 'Glutes',
  quadriceps: 'Quadriceps',
  hamstrings: 'Hamstrings',
  calves: 'Calves',
  arms: 'Arms',
  core: 'Core',
  legs: 'Legs',
  neck: 'Neck rehab',
  hip: 'Hip rehab',
  'wrist-rehab': 'Wrist rehab',
  'full-body-rehab': 'Full-body rehab',
};

export const EXERCISE_FINDER_STATIC_ARABIC_LABELS: Record<StaticMuscleSlug, string> = {
  chest: 'الصدر',
  back: 'الظهر',
  shoulders: 'الكتف',
  biceps: 'البايسبس',
  triceps: 'الترايسبس',
  forearms: 'الساعد',
  abs: 'البطن',
  obliques: 'الخواصر',
  lower_back: 'أسفل الظهر',
  glutes: 'المقعدة',
  quadriceps: 'العضلة الأمامية',
  hamstrings: 'العضلة الخلفية',
  calves: 'السمانة',
  arms: 'الذراع',
  core: 'الجذع',
  legs: 'الرجل',
  neck: 'تأهيل الرقبة',
  hip: 'تأهيل الورك',
  'wrist-rehab': 'تأهيل الرسغ',
  'full-body-rehab': 'تأهيل الجسم بالكامل',
};

export const SUB_MUSCLE_AR_LABELS: Record<string, string> = {
  upper_chest: 'الصدر العلوي',
  middle_chest: 'الصدر الأوسط',
  lower_chest: 'الصدر السفلي',
  lats: 'العضلة العريضة',
  traps: 'الشبشب',
  rhomboids: 'المعيني',
  erector_spinae: 'تقويم العمود',
  front_delts: 'الكتف الأمامي',
  side_delts: 'الكتف الجانبي',
  rear_delts: 'الكتف الخلفي',
  biceps: 'البايسبس',
  triceps: 'الترايسبس',
  forearms: 'الساعد',
  upper_abs: 'البطن العلوي',
  lower_abs: 'البطن السفلي',
  obliques: 'الخواصر',
  lower_back: 'أسفل الظهر',
  glute_max: 'المقعدة الكبرى',
  glute_med: 'المقعدة الوسطى',
  glute_min: 'المقعدة الصغرى',
  rectus_femoris: 'عضلة الفخذ الأمامية',
  vastus_lateralis: 'الفخذ الجانبي',
  vastus_medialis: 'الفخذ الداخلي',
  biceps_femoris: 'الهامسترنج الخارجي',
  semitendinosus: 'الهامسترنج الأوسط',
  semimembranosus: 'الهامسترنج الداخلي',
  gastrocnemius: 'السمانة الكبرى',
  soleus: 'السمانة الصغرى',
};

export const STATIC_GROUP_MUSCLES: Record<StaticMuscleSlug, MainMuscle[]> = {
  chest: ['chest'],
  back: ['back'],
  shoulders: ['shoulders'],
  biceps: ['biceps'],
  triceps: ['triceps'],
  forearms: ['forearms'],
  abs: ['abs'],
  obliques: ['obliques'],
  lower_back: ['lower_back'],
  glutes: ['glutes'],
  quadriceps: ['quadriceps'],
  hamstrings: ['hamstrings'],
  calves: ['calves'],
  arms: ['biceps', 'triceps', 'forearms'],
  core: ['abs', 'obliques', 'lower_back'],
  legs: ['glutes', 'quadriceps', 'hamstrings', 'calves'],
  neck: ['shoulders', 'back'],
  hip: ['glutes', 'hamstrings', 'quadriceps'],
  'wrist-rehab': ['forearms'],
  'full-body-rehab': ['back', 'shoulders', 'lower_back', 'glutes', 'quadriceps', 'hamstrings', 'calves'],
};

export const MAIN_MUSCLE_TO_STATIC_GROUP: Record<MainMuscle, StaticMuscleSlug> = {
  chest: 'chest',
  back: 'back',
  shoulders: 'shoulders',
  biceps: 'arms',
  triceps: 'arms',
  forearms: 'arms',
  abs: 'core',
  obliques: 'core',
  lower_back: 'core',
  glutes: 'legs',
  quadriceps: 'legs',
  hamstrings: 'legs',
  calves: 'legs',
};

export const INITIAL_FILTERS: FilterState = {
  muscle: 'all',
  subMuscle: 'all',
  level: 'all',
  equipment: 'all',
  exerciseType: 'all',
  search: '',
};

export const EXERCISE_FINDER_STATIC_SLUGS = Object.keys(EXERCISE_FINDER_STATIC_LABELS) as StaticMuscleSlug[];

export const EXERCISE_FINDER_QUICK_GROUPS = [
  {slug: 'chest' as StaticMuscleSlug, accent: 'bg-rose-50 text-rose-700 border-rose-200'},
  {slug: 'back' as StaticMuscleSlug, accent: 'bg-sky-50 text-sky-700 border-sky-200'},
  {slug: 'shoulders' as StaticMuscleSlug, accent: 'bg-amber-50 text-amber-700 border-amber-200'},
  {slug: 'arms' as StaticMuscleSlug, accent: 'bg-violet-50 text-violet-700 border-violet-200'},
  {slug: 'core' as StaticMuscleSlug, accent: 'bg-emerald-50 text-emerald-700 border-emerald-200'},
  {slug: 'legs' as StaticMuscleSlug, accent: 'bg-orange-50 text-orange-700 border-orange-200'},
];

export const LEVEL_COLOR_MAP: Record<string, string> = {
  beginner: 'border-emerald-300 bg-emerald-50 text-emerald-700',
  intermediate: 'border-amber-300 bg-amber-50 text-amber-700',
  advanced: 'border-red-300 bg-red-50 text-red-700',
};

export const EQUIPMENT_COLOR_MAP: Record<string, string> = {
  bodyweight: 'border-violet-300 bg-violet-50 text-violet-700',
  dumbbell: 'border-sky-300 bg-sky-50 text-sky-700',
  barbell: 'border-slate-400 bg-slate-100 text-slate-700',
  machine: 'border-orange-300 bg-orange-50 text-orange-700',
  band: 'border-pink-300 bg-pink-50 text-pink-700',
};

export const TYPE_COLOR_MAP: Record<string, string> = {
  strength: 'border-red-300 bg-red-50 text-red-700',
  hypertrophy: 'border-blue-300 bg-blue-50 text-blue-700',
  endurance: 'border-green-300 bg-green-50 text-green-700',
};
