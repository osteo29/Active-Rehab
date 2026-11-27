import {describe, expect, it} from 'vitest';

import {REGION_CONTENT} from './content';

describe('REGION_CONTENT text integrity', () => {
  it('has no placeholder question-mark runs and fills every Arabic field', () => {
    for (const [slug, c] of Object.entries(REGION_CONTENT)) {
      const all = [c.introAr, ...c.anatomyAr, ...c.cuesAr, ...c.keywordsAr, c.introEn, ...c.anatomyEn, ...c.cuesEn, ...c.keywordsEn];
      for (const text of all) {
        expect(text, slug).not.toMatch(/\?{2,}/);
        expect(text.trim().length, slug).toBeGreaterThan(0);
      }
      for (const text of [c.introAr, ...c.anatomyAr, ...c.cuesAr, ...c.keywordsAr]) {
        expect(text, slug).toMatch(/[\u0600-\u06FF]/);
      }
    }
  });
});
