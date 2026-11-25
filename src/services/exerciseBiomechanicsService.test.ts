import {describe, expect, it} from 'vitest';
import {getMuscleTargetedExercises, getVideoExercisesForMuscles} from './exerciseBiomechanicsService';
import {getLibraryMuscleSlugsForExerciseRegion} from './crossLinks';
import {getStaticExercises} from './exerciseService';

describe('getVideoExercisesForMuscles', () => {
  it('returns deduped exercises with their owning muscle, primary first', () => {
    const results = getVideoExercisesForMuscles(['anterior-deltoid', 'pectoralis-major'], 10);
    expect(results.length).toBeGreaterThan(0);
    const ids = results.map((r) => r.exercise.id);
    expect(new Set(ids).size).toBe(ids.length);
    for (const r of results) {
      expect(['anterior-deltoid', 'pectoralis-major']).toContain(r.muscleSlug);
      const targeted = getMuscleTargetedExercises(r.muscleSlug);
      const all = [...targeted.primary, ...targeted.stabilizer].map((e) => e.id);
      expect(all).toContain(r.exercise.id);
    }
  });

  it('respects the limit and skips unknown slugs', () => {
    expect(getVideoExercisesForMuscles(['anterior-deltoid'], 2)).toHaveLength(2);
    expect(getVideoExercisesForMuscles(['not_a_muscle'])).toEqual([]);
  });

  it('finds clinical videos for a gym region through the verified alias chain', () => {
    const slugs = getLibraryMuscleSlugsForExerciseRegion(
      getStaticExercises().filter((ex) => ex.region === 'shoulders'),
    );
    expect(slugs.length).toBeGreaterThan(0);
    const videos = getVideoExercisesForMuscles(slugs, 6);
    expect(videos.length).toBeGreaterThan(0);
    expect(videos.length).toBeLessThanOrEqual(6);
    expect(slugs).toContain(videos[0].muscleSlug);
  });
});
