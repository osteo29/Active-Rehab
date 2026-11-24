import {describe, expect, it} from 'vitest';

import {CalculatorLogic} from './calculators';

describe('CalculatorLogic.calculateBMI', () => {
  it('computes BMI from metric inputs', () => {
    expect(CalculatorLogic.calculateBMI(70, 175)).toBe(22.9);
  });

  it('returns 0 for non-positive input', () => {
    expect(CalculatorLogic.calculateBMI(0, 175)).toBe(0);
    expect(CalculatorLogic.calculateBMI(70, -1)).toBe(0);
  });
});

describe('CalculatorLogic.calculateWHtR', () => {
  it('computes the waist-to-height ratio', () => {
    expect(CalculatorLogic.calculateWHtR(80, 175)).toBe(0.46);
  });
});

describe('CalculatorLogic.calculateBMR', () => {
  it('applies Mifflin-St Jeor for males', () => {
    expect(CalculatorLogic.calculateBMR({weight: 80, height: 180, age: 30, gender: 'male'})).toBe(1780);
  });

  it('applies Mifflin-St Jeor for females', () => {
    expect(CalculatorLogic.calculateBMR({weight: 60, height: 165, age: 25, gender: 'female'})).toBe(1345);
  });

  it('uses Katch-McArdle when body fat is provided', () => {
    expect(CalculatorLogic.calculateBMR({weight: 80, height: 180, age: 30, gender: 'male', bodyFat: 20})).toBe(1752);
  });

  it('returns 0 for invalid input without body fat', () => {
    expect(CalculatorLogic.calculateBMR({weight: 0, height: 180, age: 30, gender: 'male'})).toBe(0);
  });
});

describe('CalculatorLogic.calculateTDEE', () => {
  it('scales BMR by the activity factor', () => {
    expect(CalculatorLogic.calculateTDEE(1780, 1.55)).toBe(2759);
  });
});

describe('CalculatorLogic.calculateMacros', () => {
  it('applies the deficit and mesomorph split for fat loss', () => {
    const result = CalculatorLogic.calculateMacros(2500, 'lose', 'mesomorph');
    expect(result.totalCalories).toBe(2000);
    expect(result.protein).toBe(175);
    expect(result.carbs).toBe(175);
    expect(result.fats).toBe(67);
  });

  it('uses the ectomorph high-carb split when maintaining', () => {
    const result = CalculatorLogic.calculateMacros(2500, 'maintain', 'ectomorph');
    expect(result.totalCalories).toBe(2500);
    expect(result.protein).toBe(156);
    expect(result.carbs).toBe(344);
    expect(result.fats).toBe(56);
  });
});

describe('CalculatorLogic.calculateProteinIntake', () => {
  it('multiplies weight by the factor', () => {
    expect(CalculatorLogic.calculateProteinIntake(80, 2)).toBe(160);
    expect(CalculatorLogic.calculateProteinIntake(0, 2)).toBe(0);
  });
});

describe('CalculatorLogic.calculateIdealWeight', () => {
  it('applies the Devine formula per gender', () => {
    expect(CalculatorLogic.calculateIdealWeight(180, 'male')).toBe(75);
    expect(CalculatorLogic.calculateIdealWeight(165, 'female')).toBe(56.9);
  });
});

describe('CalculatorLogic.calculateBodyFat', () => {
  it('applies the US Navy metric formula for males', () => {
    expect(CalculatorLogic.calculateBodyFat({gender: 'male', height: 180, waist: 85, neck: 38})).toBe(22.6);
  });

  it('applies the US Navy metric formula for females with hip', () => {
    expect(CalculatorLogic.calculateBodyFat({gender: 'female', height: 165, waist: 70, neck: 32, hip: 95})).toBe(51.6);
  });

  it('returns 0 when required measurements are missing', () => {
    expect(CalculatorLogic.calculateBodyFat({gender: 'female', height: 165, waist: 70, neck: 32})).toBe(0);
    expect(CalculatorLogic.calculateBodyFat({gender: 'male', height: 0, waist: 85, neck: 38})).toBe(0);
  });
});

describe('CalculatorLogic.getBodyFatCategory', () => {
  it('maps boundaries per gender in both languages', () => {
    expect(CalculatorLogic.getBodyFatCategory(5, 'male', 'en')).toBe('Essential Fat');
    expect(CalculatorLogic.getBodyFatCategory(13, 'male', 'en')).toBe('Athletes');
    expect(CalculatorLogic.getBodyFatCategory(30, 'female', 'en')).toBe('Average');
    expect(CalculatorLogic.getBodyFatCategory(33, 'female', 'ar')).toBe('سمنة');
    expect(CalculatorLogic.getBodyFatCategory(0, 'male', 'en')).toBe('-');
  });
});

describe('CalculatorLogic.calculateWaterIntake', () => {
  it('scales with weight, activity and conditions', () => {
    expect(CalculatorLogic.calculateWaterIntake(70, 1.2)).toBe(2310);
    expect(CalculatorLogic.calculateWaterIntake(70, 1.55)).toBe(3310);
    expect(CalculatorLogic.calculateWaterIntake(70, 1.2, {hotClimate: true, pregnancy: true})).toBe(3610);
    expect(CalculatorLogic.calculateWaterIntake(0, 1.2)).toBe(0);
  });
});

describe('CalculatorLogic.calculateDeficit', () => {
  it('computes the deficit and warns on aggressive plans', () => {
    expect(CalculatorLogic.calculateDeficit(2500, 500)).toEqual({deficit: 2000, warning: false});
    expect(CalculatorLogic.calculateDeficit(2500, 1500).warning).toBe(true);
    expect(CalculatorLogic.calculateDeficit(2500, 3000).deficit).toBe(0);
  });
});
