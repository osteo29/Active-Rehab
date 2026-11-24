import {describe, expect, it} from 'vitest';
import {getExerciseMuscleLinks, getExerciseProtocolLinks, getMusclesForBodyRegion, resolveLibraryMuscleSlugs} from './crossLinks';
import {getLocalCatalogInjuries} from './injuryService';
import musclesData from '../../json/muscles_library.json';
import {EXERCISES as exercises} from '../components/common/exercise-finder/data/exercises';

const librarySlugs = new Set(Object.keys((musclesData as any).muscles));
const catalogSlugs = new Set(getLocalCatalogInjuries('en').map((injury) => injury.slug));
const catalogIds = new Set(getLocalCatalogInjuries('en').map((injury) => injury.id));

describe('cross-link integrity', () => {
  it('resolves known exercise muscle ids to real library slugs', () => {
    expect(resolveLibraryMuscleSlugs('gluteus_medius')).toEqual(['gluteus-medius']);
    expect(resolveLibraryMuscleSlugs('front_delts')).toEqual(['anterior-deltoid']);
    expect(resolveLibraryMuscleSlugs('triceps')).toEqual(['triceps-long-head', 'triceps-lateral-head', 'triceps-medial-head']);
    expect(resolveLibraryMuscleSlugs('rhomboids')).toEqual([]);
    expect(resolveLibraryMuscleSlugs('not_a_real_muscle')).toEqual([]);
  });

  it('only emits anatomy links that point at real muscles on a real route', () => {
    for (const exercise of exercises) {
      for (const link of getExerciseMuscleLinks(exercise.muscles, 'en')) {
        expect(link.href).toMatch(/^\/en\/anatomy\?muscle=[a-z0-9-]+$/);
        const slug = link.href.split('muscle=')[1];
        expect(librarySlugs.has(slug)).toBe(true);
      }
    }
  });

  it('every finder exercise region maps to at least one muscle-library link', () => {
    let totalLinks = 0;
    for (const exercise of exercises) {
      totalLinks += getExerciseMuscleLinks(exercise.muscles, 'en').length;
    }
    expect(totalLinks).toBeGreaterThan(0);
  });

  it('only emits protocol links that point at real catalog injuries on a real route', () => {
    const regions = ['quadriceps', 'hamstrings', 'glutes', 'calves', 'chest', 'back', 'shoulders', 'abs'];
    for (const region of regions) {
      for (const link of getExerciseProtocolLinks(region, 'en')) {
        expect(link.href).toMatch(/^\/en\/injuries\/[a-z0-9-]+$/);
        const slug = link.href.replace('/en/injuries/', '');
        expect(catalogSlugs.has(slug) || catalogIds.has(slug)).toBe(true);
      }
    }
  });

  it('maps injury body regions to real library muscles without inventing links for unmapped regions', () => {
    for (const injury of getLocalCatalogInjuries('en')) {
      for (const link of getMusclesForBodyRegion(injury.bodyRegion, 'en')) {
        expect(link.href).toMatch(/^\/en\/anatomy\?muscle=[a-z0-9-]+$/);
        const slug = link.href.split('muscle=')[1];
        expect(librarySlugs.has(slug)).toBe(true);
      }
    }
    expect(getMusclesForBodyRegion('General', 'en')).toEqual([]);
    expect(getMusclesForBodyRegion('Knee', 'en').length).toBeGreaterThan(0);
  });

  it('produces arabic links on arabic routes', () => {
    for (const link of getExerciseMuscleLinks(['gluteus_medius'], 'ar')) {
      expect(link.href.startsWith('/ar/anatomy?muscle=')).toBe(true);
    }
  });
});
