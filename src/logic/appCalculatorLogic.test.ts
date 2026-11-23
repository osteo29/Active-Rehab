import {describe, expect, it} from 'vitest';
import {calculateCalculatorResult, validateCalculatorInputs, type CalculatorFormValues} from './appCalculatorLogic';
import {translations} from '../services/translations';

const t = translations.ar;

function createValues(overrides: Partial<CalculatorFormValues> = {}): CalculatorFormValues {
  return {
    activeCalculator: 'WHtR',
    weight: '70',
    height: '170',
    age: '30',
    gender: 'male',
    activity: '1.2',
    waist: '80',
    neck: '38',
    hip: '',
    goal: 'maintain',
    bodyType: 'mesomorph',
    pace: 500,
    unitSystem: 'metric',
    knowBodyFat: false,
    bodyFatInput: '',
    hotClimate: false,
    pregnancy: false,
    mealItems: [{id: '1', name: '', calories: ''}],
    ...overrides,
  };
}

describe('appCalculatorLogic localized numeric input', () => {
  it('validates required fields based on the active calculator', () => {
    expect(
      validateCalculatorInputs({
        values: createValues({activeCalculator: 'BMI', weight: ''}),
        lang: 'en',
        t: translations.en,
      }),
    ).toBe(translations.en.errors.weight);

    expect(
      validateCalculatorInputs({
        values: createValues({
          activeCalculator: 'BodyFat',
          gender: 'female',
          hip: '',
        }),
        lang: 'en',
        t: translations.en,
      }),
    ).toBe(translations.en.errors.hip);
  });

  it('calculates WHtR in imperial mode using metric conversion', () => {
    const {result, healthInterpretation} = calculateCalculatorResult({
      values: createValues({
        unitSystem: 'imperial',
        waist: '30',
        height: '70',
      }),
      lang: 'en',
      t: translations.en,
    });

    expect(result).toEqual({ratio: 0.43, category: 'Healthy'});
    expect(healthInterpretation).toBeNull();
  });

  it('totals meal calories from mixed numeric strings', () => {
    const {result} = calculateCalculatorResult({
      values: createValues({
        activeCalculator: 'Meal',
        mealItems: [
          {id: '1', name: 'Chicken', calories: '200'},
          {id: '2', name: 'Rice', calories: '150.5'},
          {id: '3', name: 'Salad', calories: '0'},
        ],
      }),
      lang: 'en',
      t: translations.en,
    });

    expect(result).toBe(350.5);
  });

  it('accepts Arabic digits during validation for WHtR', () => {
    const error = validateCalculatorInputs({
      values: createValues({
        height: '١٧٠',
        waist: '٨٥',
        neck: '٣٨',
      }),
      lang: 'ar',
      t,
    });

    expect(error).toBeNull();
  });

  it('calculates WHtR from Arabic digits', () => {
    const {result} = calculateCalculatorResult({
      values: createValues({
        height: '١٧٠',
        waist: '٨٥',
      }),
      lang: 'ar',
      t,
    });

    expect(result).toEqual({ratio: 0.5, category: 'مخاطر متزايدة'});
  });

  it('calculates body fat from localized metric inputs', () => {
    const {result} = calculateCalculatorResult({
      values: createValues({
        activeCalculator: 'BodyFat',
        height: '١٨٠',
        waist: '٩٠',
        neck: '٤٠',
      }),
      lang: 'ar',
      t,
    });

    expect(result).toBeTypeOf('number');
    expect(result).toBeGreaterThan(0);
  });

  it('returns localized guidance labels for WHtR thresholds', () => {
    const {result} = calculateCalculatorResult({
      values: createValues({
        height: '١٧٠',
        waist: '٧٥',
      }),
      lang: 'ar',
      t,
    });

    expect(result).toEqual({ratio: 0.44, category: 'صحي'});
  });
});
