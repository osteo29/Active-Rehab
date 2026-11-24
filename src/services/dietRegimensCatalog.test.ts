import {describe, expect, it} from 'vitest';

import {dietRegimensCatalog} from './dietRegimensCatalog';

describe('dietRegimensCatalog', () => {
  it('uses unique ids', () => {
    const ids = dietRegimensCatalog.map((item) => item.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('provides complete bilingual content for every regimen', () => {
    for (const item of dietRegimensCatalog) {
      expect(item.title.en.trim(), `${item.id} title.en`).not.toBe('');
      expect(item.title.ar.trim(), `${item.id} title.ar`).not.toBe('');
      expect(item.summary.en.trim(), `${item.id} summary.en`).not.toBe('');
      expect(item.summary.ar.trim(), `${item.id} summary.ar`).not.toBe('');
      expect(item.goals.en.length, `${item.id} goals.en`).toBeGreaterThan(0);
      expect(item.goals.ar.length, `${item.id} goals.ar`).toBeGreaterThan(0);
      expect(item.keyPrinciples.en.length, `${item.id} keyPrinciples.en`).toBeGreaterThan(0);
      expect(item.keyPrinciples.ar.length, `${item.id} keyPrinciples.ar`).toBeGreaterThan(0);
      expect(item.practicalGuide.en.length, `${item.id} practicalGuide.en`).toBeGreaterThan(0);
      expect(item.practicalGuide.ar.length, `${item.id} practicalGuide.ar`).toBeGreaterThan(0);
      expect(item.cautions.en.length, `${item.id} cautions.en`).toBeGreaterThan(0);
      expect(item.cautions.ar.length, `${item.id} cautions.ar`).toBeGreaterThan(0);
      expect(item.exampleDay.breakfast.en.trim(), `${item.id} breakfast.en`).not.toBe('');
      expect(item.exampleDay.breakfast.ar.trim(), `${item.id} breakfast.ar`).not.toBe('');
      expect(item.exampleDay.lunch.en.trim(), `${item.id} lunch.en`).not.toBe('');
      expect(item.exampleDay.lunch.ar.trim(), `${item.id} lunch.ar`).not.toBe('');
      expect(item.exampleDay.dinner.en.trim(), `${item.id} dinner.en`).not.toBe('');
      expect(item.exampleDay.dinner.ar.trim(), `${item.id} dinner.ar`).not.toBe('');
    }
  });
});
