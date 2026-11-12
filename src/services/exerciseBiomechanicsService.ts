import biomechanicsData from '../../json/exercise_biomechanics.json';
import musclesData from '../../json/muscles_library.json';
import muscleIndexData from '../../json/muscle_exercises_index.json';

export type MuscleRole = 'primary' | 'secondary' | 'stabilizer' | 'synergist';

export type BiomechanicsProvenance = 'body_iq_verified' | 'protocol_inferred';

export type DataAuditInfo = {
  is_peer_reviewed: boolean;
  matched_source: string;
  validation_status: 'verified' | 'heuristic_inferred';
  missing_fields: string[];
};

export type ExerciseBiomechanics = {
  exercise_id: string;
  canonical_name: string;
  provenance: BiomechanicsProvenance;
  confidence_score: number;
  evidence_level?: string;
  difficulty?: string;
  body_position?: string | null;
  primary_muscles: string[];
  stabilizers?: string[];
  movements?: string[];
  kinetic_chain?: 'open' | 'closed' | 'unspecified';
  contraction_type?: 'isometric' | 'concentric' | 'eccentric' | 'dynamic';
  emg_notes?: string | null;
  dosing_recommendation?: string | null;
  data_audit?: DataAuditInfo;
};

export type MuscleDetail = {
  slug: string;
  name: string;
  name_ar: string;
  region: string;
  description?: string;
  origin?: string;
  insertion?: string;
  action?: string;
  innervation?: string;
  blood_supply?: string;
};

export type MuscleExerciseReference = {
  id: string;
  name: string;
  provenance: BiomechanicsProvenance;
};

export type MuscleTargetedExercises = {
  primary: MuscleExerciseReference[];
  stabilizer: MuscleExerciseReference[];
};

export function getExerciseBiomechanics(exerciseId: string): ExerciseBiomechanics | null {
  const entries = (biomechanicsData as any).entries;
  return entries[exerciseId] || null;
}

export function isExerciseBiomechanicallyVerified(exerciseId: string): boolean {
  const entry = getExerciseBiomechanics(exerciseId);
  return entry?.provenance === 'body_iq_verified';
}

export function getMuscleDetail(muscleSlug: string): MuscleDetail | null {
  const muscles = (musclesData as any).muscles;
  return muscles[muscleSlug] || null;
}

export function getAllMuscles(): MuscleDetail[] {
  const muscles = (musclesData as any).muscles;
  return Object.values(muscles) as MuscleDetail[];
}

export function getMusclesByRegion(region: string): MuscleDetail[] {
  return getAllMuscles().filter((m) => m.region === region);
}

export function getMuscleTargetedExercises(muscleSlug: string): MuscleTargetedExercises {
  const index = (muscleIndexData as any)[muscleSlug];
  if (!index) return { primary: [], stabilizer: [] };
  return {
    primary: index.primary || [],
    stabilizer: index.stabilizer || []
  };
}

export function getExercisePrimaryMuscleDetails(exerciseId: string): MuscleDetail[] {
  const bio = getExerciseBiomechanics(exerciseId);
  if (!bio?.primary_muscles) return [];
  return bio.primary_muscles
    .map((slug) => getMuscleDetail(slug))
    .filter(Boolean) as MuscleDetail[];
}

export function getBiomechanicsAuditSummary() {
  return (biomechanicsData as any).audit_summary || null;
}
