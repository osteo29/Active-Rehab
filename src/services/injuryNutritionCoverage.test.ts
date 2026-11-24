import {describe, expect, it} from 'vitest';

import {getInjuriesMissingNutritionPlans} from './injuryNutritionCoverage';

describe('getInjuriesMissingNutritionPlans', () => {
  it('has no injury missing a nutrition plan', () => {
    // Regression gate: every injury phase must carry nutrition focus,
    // recommended/avoid foods, supplements, and meal examples.
    expect(getInjuriesMissingNutritionPlans()).toEqual([]);
  });
});
