import type {Language} from '../../../services/translations';

import {MUSCLE_TREE} from './constants';

export type MainMuscle = keyof typeof MUSCLE_TREE;
export type SubMuscle = (typeof MUSCLE_TREE)[MainMuscle][number];
export type Level = 'beginner' | 'intermediate' | 'advanced';
export type Equipment = 'bodyweight' | 'dumbbell' | 'barbell' | 'machine' | 'band';
export type ExerciseType = 'strength' | 'hypertrophy' | 'endurance';
export type TrainingSystemFocus = ExerciseType | 'mixed';
export type TrainingSystemEquipment = Equipment | 'mixed';
export type StaticMuscleSlug = MainMuscle | 'arms' | 'core' | 'legs' | 'neck' | 'hip' | 'wrist-rehab' | 'full-body-rehab';

export type Exercise = {
  name: string;
  nameAr?: string;
  mainMuscle: MainMuscle;
  muscles: string[];
  level: Level;
  equipment: Equipment;
  exerciseType: ExerciseType;
  description: string;
  descriptionAr?: string;
  tips: string;
  tipsAr?: string;
  rehabTip?: string;
  rehabTipAr?: string;
  imageUrl?: string;
  imageAlt?: string;
  videoUrl?: string;
};

export type FilterState = {
  muscle: MainMuscle | 'all';
  subMuscle: SubMuscle | 'all';
  level: Level | 'all';
  equipment: Equipment | 'all';
  exerciseType: ExerciseType | 'all';
  search: string;
};

export type TrainingSystem = {
  id: string;
  title: string;
  titleAr: string;
  summary: string;
  summaryAr: string;
  split: string;
  splitAr: string;
  frequency: string;
  frequencyAr: string;
  recovery: string;
  recoveryAr: string;
  idealFor: string;
  idealForAr: string;
  focus: TrainingSystemFocus;
  equipment: TrainingSystemEquipment;
  levels: Level[];
  muscleGroups: StaticMuscleSlug[];
  accent: string;
};

export type WeeklyDayPlan = {
  day: string;
  dayAr: string;
  title: string;
  titleAr: string;
  details: string;
  detailsAr: string;
  sessionGoal: string;
  sessionGoalAr: string;
  prescriptions: WorkoutPrescription[];
};

export type WeeklyPlan = {
  systemId: string;
  days: WeeklyDayPlan[];
};

export type WorkoutPrescription = {
  exerciseName: string;
  sets: string;
  reps: string;
  rest: string;
  notes: string;
  notesAr: string;
};

export type ExerciseFinderProps = {
  canonicalBasePath?: string;
  enableSeo?: boolean;
  lang?: Language;
  pathMuscle?: StaticMuscleSlug | null;
};

export type Option = {value: string; label: string};
