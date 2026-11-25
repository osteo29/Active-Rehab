import {describe, expect, it} from 'vitest';
import {countInjuriesForLibraryRegion, countProtocolsForExerciseRegion, getExerciseMuscleLinks, getLibraryMusclesForExerciseRegion, getExerciseRegionForMuscleRegion, getExerciseProtocolLinks, getInjuriesForLibraryRegion, getMusclesForBodyRegion, resolveLibraryMuscleSlugs} from './crossLinks';
import {getLocalCatalogInjuries} from './injuryService';
import {getStaticExercises} from './exerciseService';
import musclesData from '../../json/muscles_library.json';
import {EXERCISES as exercises} from '../components/common/exercise-finder/data/exercises';
import {EXERCISE_FINDER_STATIC_SLUGS} from '../components/common/exercise-finder/constants';
import type {StaticMuscleSlug} from '../components/common/exercise-finder/types';

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
        expect(link.href).toMatch(/^\/en\/anatomy\/[a-z0-9-]+$/);
        const slug = link.href.replace('/en/anatomy/', '');
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
        expect(link.href).toMatch(/^\/en\/anatomy\/[a-z0-9-]+$/);
        const slug = link.href.replace('/en/anatomy/', '');
        expect(librarySlugs.has(slug)).toBe(true);
      }
    }
    expect(getMusclesForBodyRegion('General', 'en')).toEqual([]);
    expect(getMusclesForBodyRegion('Knee', 'en').length).toBeGreaterThan(0);
  });

  it('produces arabic links on arabic routes', () => {
    for (const link of getExerciseMuscleLinks(['gluteus_medius'], 'ar')) {
      expect(link.href.startsWith('/ar/anatomy/')).toBe(true);
    }
  });
});

describe('anatomy outbound links', () => {
  it('maps library regions to real catalog injuries via the verified region map', () => {
    const withInjuries = ['knee_thigh', 'shoulder', 'hip_pelvis', 'ankle_foot', 'arm', 'spine_core'];
    for (const region of withInjuries) {
      const links = getInjuriesForLibraryRegion(region, 'en');
      expect(links.length).toBeGreaterThan(0);
      for (const link of links) {
        expect(link.href).toMatch(/^\/en\/injuries\/[a-z0-9-]+$/);
        expect(catalogSlugs.has(link.href.replace('/en/injuries/', ''))).toBe(true);
      }
      expect(countInjuriesForLibraryRegion(region)).toBeGreaterThanOrEqual(links.length);
    }
  });

  it('returns nothing for a library region with no mapped catalog injuries', () => {
    expect(getInjuriesForLibraryRegion('neck', 'en')).toEqual([]);
    expect(countInjuriesForLibraryRegion('neck')).toBe(0);
    expect(getInjuriesForLibraryRegion('not_a_region', 'en')).toEqual([]);
  });

  it('respects the link limit', () => {
    expect(getInjuriesForLibraryRegion('knee_thigh', 'en', 2)).toHaveLength(2);
  });

  it('maps every library muscle region to a real exercise-finder region slug', () => {
    const libraryRegions = ['shoulder', 'arm', 'spine_core', 'hip_pelvis', 'knee_thigh', 'ankle_foot', 'neck'];
    for (const region of libraryRegions) {
      const slug = getExerciseRegionForMuscleRegion(region);
      expect(slug).not.toBeNull();
      expect(EXERCISE_FINDER_STATIC_SLUGS.includes(slug as StaticMuscleSlug)).toBe(true);
    }
    expect(getExerciseRegionForMuscleRegion('not_a_region')).toBeNull();
  });
});

describe('region hub links', () => {
  it('collects unique anatomy-library muscles for a region from its exercises', () => {
    const shouldersExercises = getStaticExercises().filter((ex) => ex.region === 'shoulders');
    const links = getLibraryMusclesForExerciseRegion(shouldersExercises, 'en');
    expect(links.length).toBeGreaterThan(0);
    const hrefs = links.map((link) => link.href);
    expect(new Set(hrefs).size).toBe(hrefs.length);
    for (const link of links) {
      expect(link.href).toMatch(/^\/en\/anatomy\/[a-z0-9-]+$/);
      expect(librarySlugs.has(link.href.replace('/en/anatomy/', ''))).toBe(true);
    }
  });

  it('returns an empty list when no exercise muscles resolve', () => {
    expect(getLibraryMusclesForExerciseRegion([{muscles: ['not_a_real_muscle']}], 'en')).toEqual([]);
    expect(getLibraryMusclesForExerciseRegion([], 'en')).toEqual([]);
  });

  it('counts all region protocols and can list beyond the default cap', () => {
    const total = countProtocolsForExerciseRegion('shoulders');
    expect(total).toBeGreaterThan(0);
    const defaultLinks = getExerciseProtocolLinks('shoulders', 'en');
    const wideLinks = getExerciseProtocolLinks('shoulders', 'en', total + 5);
    expect(defaultLinks.length).toBeLessThanOrEqual(3);
    expect(wideLinks).toHaveLength(total);
    for (const link of wideLinks) {
      expect(catalogSlugs.has(link.href.replace('/en/injuries/', ''))).toBe(true);
    }
  });
});
