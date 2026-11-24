import {describe, expect, it} from 'vitest';
import {commonDrugInteractions, findCommonDrugInteraction} from './commonDrugInteractions';

describe('commonDrugInteractions data', () => {
  it('every entry is complete and bilingual with a valid status', () => {
    for (const item of commonDrugInteractions) {
      expect(item.id.length).toBeGreaterThan(0);
      expect(item.matchTerms.length).toBeGreaterThan(0);
      expect(['Danger', 'Caution', 'Safe']).toContain(item.status);
      expect(item.title.en.length).toBeGreaterThan(0);
      expect(item.title.ar.length).toBeGreaterThan(0);
      expect(item.summary.en.length).toBeGreaterThan(0);
      expect(item.summary.ar.length).toBeGreaterThan(0);
    }
  });

  it('has unique ids', () => {
    const ids = commonDrugInteractions.map((item) => item.id);
    expect(new Set(ids).size).toBe(ids.length);
  });
});

describe('findCommonDrugInteraction', () => {
  it('returns null for blank or unmatched queries', () => {
    expect(findCommonDrugInteraction('')).toBeNull();
    expect(findCommonDrugInteraction('   ')).toBeNull();
    expect(findCommonDrugInteraction('xyzzy-not-a-drug')).toBeNull();
  });

  it('matches English terms case-insensitively', () => {
    const hit = findCommonDrugInteraction('Can I take DOXYCYCLINE with breakfast?');
    expect(hit).not.toBeNull();
    expect(hit!.matchTerms.map((t) => t.toLowerCase())).toContain('doxycycline');
  });

  it('matches Arabic terms', () => {
    const hit = findCommonDrugInteraction('هل يمكن شرب ألبان مع الدواء؟');
    expect(hit).not.toBeNull();
  });
});
