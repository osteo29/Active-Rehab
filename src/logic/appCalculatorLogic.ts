import {ClinicalCalculators, type BodyType, type GoalType, type HealthInterpretation} from './physioNutritionLogic';
import type {CalculatorType, MealItem} from '../features/tools/app/types';
import {translations, type Language} from '../services/translations';
import {parseLocalizedNumber} from '../utils/numericInput';

type AppTranslations = (typeof translations)[Language];

export type CalculatorFormValues = {
  activeCalculator: CalculatorType;
  weight: string;
  height: string;
  age: string;
  gender: 'male' | 'female';
  activity: string;
  waist: string;
  neck: string;
  hip: string;
  goal: GoalType;
  bodyType: BodyType;
  pace: number;
  unitSystem: 'metric' | 'imperial';
  knowBodyFat: boolean;
  bodyFatInput: string;
  hotClimate: boolean;
  pregnancy: boolean;
  mealItems: MealItem[];
};

export type CalculatorResultPayload = {
  result: unknown;
  healthInterpretation: HealthInterpretation | null;
};

type ValidationOptions = {
  values: CalculatorFormValues;
  lang: Language;
  t: AppTranslations;
};

type CalculationOptions = ValidationOptions;

const requiresHeight = ['BMI', 'BMR', 'TDEE', 'Macros', 'IdealWeight', 'BodyFat', 'Deficit', 'WHtR'] as const;
const requiresAge = ['BMR', 'TDEE', 'Macros', 'Deficit'] as const;
const requiresWaist = ['BodyFat', 'WHtR'] as const;
const requiresWeight = ['BMI', 'BMR', 'TDEE', 'Macros', 'Protein', 'Water', 'Deficit'] as const;

function includesCalculator(list: readonly Exclude<CalculatorType, null>[], calculator: CalculatorType) {
  return calculator ? list.includes(calculator as Exclude<CalculatorType, null>) : false;
}

function toPositiveNumber(value: string) {
  if (/[-−]/.test(value)) return 0;
  const parsed = parseLocalizedNumber(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
}

function toMetricIfNeeded(value: number, unitSystem: 'metric' | 'imperial') {
  return unitSystem === 'imperial' ? value * 2.54 : value;
}

export function validateCalculatorInputs({values, lang, t}: ValidationOptions) {
  if (values.activeCalculator === 'Meal') return null;
  if (includesCalculator(requiresWeight, values.activeCalculator) && toPositiveNumber(values.weight) <= 0) return t.errors.weight;
  if (includesCalculator(requiresHeight, values.activeCalculator) && toPositiveNumber(values.height) <= 0) return t.errors.height;
  if (includesCalculator(requiresAge, values.activeCalculator) && toPositiveNumber(values.age) <= 0) return t.errors.age;
  if (includesCalculator(requiresWaist, values.activeCalculator)) {
    if (toPositiveNumber(values.waist) <= 0) return t.errors.waist;
    if (values.activeCalculator === 'BodyFat' && toPositiveNumber(values.neck) <= 0) return t.errors.neck;
    if (values.gender === 'female' && values.activeCalculator === 'BodyFat' && toPositiveNumber(values.hip) <= 0) {
      return t.errors.hip;
    }
  }

  if (values.knowBodyFat && includesCalculator(['BMR', 'TDEE', 'Macros', 'Deficit'], values.activeCalculator) && toPositiveNumber(values.bodyFatInput) <= 0) {
    return lang === 'en' ? 'Please enter body fat percentage' : 'يرجى إدخال نسبة الدهون';
  }

  return null;
}

export function calculateCalculatorResult({values, lang}: CalculationOptions): CalculatorResultPayload {
  const w = parseLocalizedNumber(values.weight);
  const h = parseLocalizedNumber(values.height);
  const a = parseLocalizedNumber(values.age);
  const wa = parseLocalizedNumber(values.waist);
  const ne = parseLocalizedNumber(values.neck);
  const hi = parseLocalizedNumber(values.hip);

  switch (values.activeCalculator) {
    case 'BMI': {
      const bmi = ClinicalCalculators.bmi(w, h);
      return {result: bmi, healthInterpretation: ClinicalCalculators.interpretBMI(bmi, lang)};
    }
    case 'BMR': {
      const bmr = ClinicalCalculators.bmrMifflinStJeor({
        weightKg: w,
        heightCm: h,
        ageYears: a,
        gender: values.gender,
      });
      return {result: bmr, healthInterpretation: ClinicalCalculators.interpretBMR(bmr, lang)};
    }
    case 'TDEE': {
      const bmr = ClinicalCalculators.bmrMifflinStJeor({
        weightKg: w,
        heightCm: h,
        ageYears: a,
        gender: values.gender,
      });
      const tdee = ClinicalCalculators.tdee(bmr, Number(values.activity));
      return {result: tdee, healthInterpretation: ClinicalCalculators.interpretTDEE(tdee, lang)};
    }
    case 'Macros': {
      const bmr = ClinicalCalculators.bmrMifflinStJeor({
        weightKg: w,
        heightCm: h,
        ageYears: a,
        gender: values.gender,
      });
      const tdee = ClinicalCalculators.tdee(bmr, Number(values.activity));
      const macros = ClinicalCalculators.macrosFromGoal(tdee, values.goal);
      return {result: macros, healthInterpretation: ClinicalCalculators.interpretMacros(values.goal, lang)};
    }
    case 'Protein': {
      const protein = ClinicalCalculators.proteinNeedsG(w, Number(values.activity));
      return {result: protein, healthInterpretation: ClinicalCalculators.interpretProtein(Number(values.activity), lang)};
    }
    case 'IdealWeight': {
      const ibw = ClinicalCalculators.idealBodyWeightDevine(h, values.gender);
      return {result: ibw, healthInterpretation: ClinicalCalculators.interpretIBW(ibw, lang)};
    }
    case 'WHtR': {
      const calcWaist = toMetricIfNeeded(wa, values.unitSystem);
      const calcHeight = toMetricIfNeeded(h, values.unitSystem);
      const ratio = calcWaist > 0 && calcHeight > 0 ? Number((calcWaist / calcHeight).toFixed(2)) : 0;
      const category =
        ratio <= 0
          ? '-'
          : ratio < 0.5
            ? lang === 'en'
              ? 'Healthy'
              : 'صحي'
            : ratio < 0.6
              ? lang === 'en'
                ? 'Increased Risk'
                : 'مخاطر متزايدة'
              : lang === 'en'
                ? 'High Risk'
                : 'مخاطر عالية';
      return {result: {ratio, category}, healthInterpretation: null};
    }
    case 'BodyFat': {
      const bodyFat = ClinicalCalculators.bodyFatUSNavy({
        gender: values.gender,
        heightCm: toMetricIfNeeded(h, values.unitSystem),
        waistCm: toMetricIfNeeded(wa, values.unitSystem),
        neckCm: toMetricIfNeeded(ne, values.unitSystem),
        hipCm: values.gender === 'female' ? toMetricIfNeeded(hi, values.unitSystem) : undefined,
      });
      return {
        result: bodyFat,
        healthInterpretation: ClinicalCalculators.interpretBodyFat(bodyFat, values.gender, lang),
      };
    }
    case 'Water': {
      const water = ClinicalCalculators.waterIntakeMl(w, Number(values.activity), {
        hotClimate: values.hotClimate,
        pregnancy: values.pregnancy,
      });
      return {result: water, healthInterpretation: ClinicalCalculators.interpretWater(water, lang)};
    }
    case 'Deficit': {
      const bmr = ClinicalCalculators.bmrMifflinStJeor({
        weightKg: w,
        heightCm: h,
        ageYears: a,
        gender: values.gender,
      });
      const tdee = ClinicalCalculators.tdee(bmr, Number(values.activity));
      const deficit = ClinicalCalculators.calorieAdjustmentFromTDEE(tdee, values.pace);
      return {
        result: deficit,
        healthInterpretation: ClinicalCalculators.interpretCalorieAdjustment(values.pace, lang),
      };
    }
    case 'Meal': {
      const total = ClinicalCalculators.mealCalories(values.mealItems);
      return {result: total, healthInterpretation: ClinicalCalculators.interpretMeal(total, lang)};
    }
    default:
      return {result: null, healthInterpretation: null};
  }
}

export function buildResultAnalysisPrompt(activeCalculator: CalculatorType, lang: Language) {
  if (!activeCalculator) return null;
  return lang === 'en'
    ? `Analyze this ${activeCalculator} result and give me a short practical recommendation for rehab or nutrition follow-up.`
    : `حلل نتيجة ${activeCalculator} وأعطني توصية قصيرة وعملية للمتابعة في التعافي أو التغذية.`;
}
