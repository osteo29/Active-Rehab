import {describe, expect, it} from 'vitest';
import {getInjuryExerciseLinks} from './injuryExerciseLinks';

const VALID_REGION_SLUG = /^\/(en|ar)\/exercises\/[a-z_-]+$/;

describe('getInjuryExerciseLinks', () => {
  it('returns at most three links with valid region routes', () => {
    const links = getInjuryExerciseLinks({injuryId: 'acl_injury', bodyRegion: 'Knee', lang: 'en'});
    expect(links.length).toBeGreaterThan(0);
    expect(links.length).toBeLessThanOrEqual(3);
    for (const link of links) {
      expect(link.href).toMatch(VALID_REGION_SLUG);
      expect(link.label.length).toBeGreaterThan(0);
      expect(link.reason.length).toBeGreaterThan(0);
    }
  });

  it('deduplicates seeds shared between the injury map and the region map', () => {
    const links = getInjuryExerciseLinks({injuryId: 'acl_injury', bodyRegion: 'Knee', lang: 'en'});
    const slugs = links.map((link) => link.slug);
    expect(new Set(slugs).size).toBe(slugs.length);
  });

  it('falls back to the body region map for unknown injuries', () => {
    const links = getInjuryExerciseLinks({injuryId: 'no_such_injury', bodyRegion: 'Knee', lang: 'en'});
    expect(links.length).toBeGreaterThan(0);
  });

  it('returns empty for unknown injury and unknown region', () => {
    expect(getInjuryExerciseLinks({injuryId: 'no_such_injury', bodyRegion: 'Nowhere', lang: 'en'})).toEqual([]);
  });

  it('uses Arabic labels and routes for ar', () => {
    const links = getInjuryExerciseLinks({injuryId: 'acl_injury', bodyRegion: 'Knee', lang: 'ar'});
    expect(links.length).toBeGreaterThan(0);
    for (const link of links) {
      expect(link.href.startsWith('/ar/exercises/')).toBe(true);
    }
  });
});
