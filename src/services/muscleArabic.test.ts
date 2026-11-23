import {describe, expect, it} from 'vitest';
import translations from '../../json/muscles_ar.json';
import {getAllMuscles} from './exerciseBiomechanicsService';

describe('Arabic anatomy details', () => {
  it('covers every muscle without replacing the English source', () => {
    const en = getAllMuscles();
    const ar = getAllMuscles('ar');
    expect(en).toHaveLength(107);
    expect(Object.keys(translations).sort()).toEqual(en.map(m => m.slug).sort());
    ar.forEach((m, i) => {
      expect(m.action).toMatch(/[\u0600-\u06ff]/);
      expect(m.innervation).toMatch(/[\u0600-\u06ff]/);
      expect(m.action).not.toBe(en[i].action);
      expect(m.image_url).toBe(en[i].image_url);
      expect(m.slug).toBe(en[i].slug);
    });
    expect(getAllMuscles('en')).toEqual(en);
  });
});
