import {describe, expect, it} from 'vitest';
import {getInjuryRehabLinks} from './injuryRehabLinks';

describe('getInjuryRehabLinks', () => {
  it('returns at most two links with valid region routes', () => {
    const links = getInjuryRehabLinks({injuryId: 'acl_injury', bodyRegion: 'Knee', lang: 'en'});
    expect(links.length).toBeLessThanOrEqual(2);
    for (const link of links) {
      expect(link.href).toMatch(/^\/(en|ar)\/exercises\/[a-z_-]+$/);
      expect(link.label.length).toBeGreaterThan(0);
    }
  });

  it('deduplicates and returns empty for unknown injury and region', () => {
    const links = getInjuryRehabLinks({injuryId: 'acl_injury', bodyRegion: 'Knee', lang: 'en'});
    const slugs = links.map((link) => link.slug);
    expect(new Set(slugs).size).toBe(slugs.length);
    expect(getInjuryRehabLinks({injuryId: 'nope', bodyRegion: 'Nowhere', lang: 'en'})).toEqual([]);
  });
});
