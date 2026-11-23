import {getInjuryById} from '../services/injuryDatabase';
import {ClinicalCalculators} from './physioNutritionLogic';

export interface HealthProfile {
  age: number;
  weight: number;
  height: number;
  gender: 'male' | 'female';
  activityLevel: number;
  goal: 'recovery' | 'maintain' | 'lose' | 'gain';
  waist?: number;
  neck?: number;
  injuryType: string | null;
  recoveryWeek: number;
  sleepHours: number;
  waterIntake: number;
  proteinCompliance: number;
}

export interface HealthMetrics {
  bmi: number;
  bmiCategory: string;
  whtr: number;
  whtrCategory: string;
  bmr: number;
  tdee: number;
  macros: {
    protein: number;
    fats: number;
    carbs: number;
    totalCalories: number;
  };
  healthScore: number;
  hydrationTarget: number;
  recoveryStage: string;
  recoveryFocus: string;
  suggestedNutrients: any[];
  suggestedFoods: string[];
}

function resolveRecoveryStage(injuryType: string | null, recoveryWeek: number) {
  let recoveryStage = 'General Health';
  let recoveryFocus = 'Maintenance & Longevity';
  let suggestedNutrients: any[] = [];
  let suggestedFoods: string[] = [];

  if (!injuryType || injuryType === 'none') {
    return {recoveryStage, recoveryFocus, suggestedNutrients, suggestedFoods};
  }

  const injury = getInjuryById(injuryType);
  if (!injury) {
    return {recoveryStage, recoveryFocus, suggestedNutrients, suggestedFoods};
  }

  let stageKey = 'week1-2';
  if (recoveryWeek > 2 && recoveryWeek <= 6) stageKey = 'week3-6';
  if (recoveryWeek > 6) stageKey = 'week7+';

  const stage = injury.stages[stageKey] ?? Object.values(injury.stages)[0];
  return {
    recoveryStage: stage.phase,
    recoveryFocus: stage.focus,
    suggestedNutrients: stage.nutrients,
    suggestedFoods: stage.foods,
  };
}

export const PhysioNutritionLogic = {
  calculateAllMetrics(profile: HealthProfile): HealthMetrics {
    const {age, weight, height, gender, activityLevel, goal, sleepHours, waterIntake, proteinCompliance, injuryType, recoveryWeek} = profile;

    const bmi = ClinicalCalculators.bmi(weight, height);
    const bmiCategory = ClinicalCalculators.interpretBMI(bmi, 'en').category;

    let whtr = 0;
    let whtrCategory = 'N/A';
    if (profile.waist && profile.waist > 0) {
      whtr = profile.waist / height;
      if (whtr < 0.4) whtrCategory = 'Extremely Slim';
      else if (whtr <= 0.5) whtrCategory = 'Healthy / Low Risk';
      else if (whtr <= 0.6) whtrCategory = 'Overweight / Increased Risk';
      else whtrCategory = 'Obese / High Risk';
    }

    const bmr = ClinicalCalculators.bmrMifflinStJeor({
      weightKg: weight,
      heightCm: height,
      ageYears: age,
      gender,
    });

    const tdee = ClinicalCalculators.tdee(bmr, activityLevel);
    const normalizedGoal = goal;
    const macros = ClinicalCalculators.macrosFromGoal(
      tdee,
      normalizedGoal === 'recovery' ? 'maintain' : normalizedGoal,
    );

    const proteinFloorPerKg =
      normalizedGoal === 'gain' ? 2.0 : normalizedGoal === 'lose' ? 1.8 : 1.6;
    const injuryFloor = injuryType && injuryType !== 'none' ? 2.0 : proteinFloorPerKg;
    const proteinFloor = Math.round(weight * injuryFloor);
    const hydrationTarget = ClinicalCalculators.waterIntakeMl(weight, activityLevel);
    const recovery = resolveRecoveryStage(injuryType, recoveryWeek);

    let bmiScore = 0;
    if (bmi >= 18.5 && bmi <= 24.9) bmiScore = 25;
    else if (bmi >= 25 && bmi <= 29.9) bmiScore = 15;
    else bmiScore = 5;

    const activityScore = Math.min(((activityLevel - 1.2) / (1.9 - 1.2)) * 20, 20);
    const proteinScore = proteinCompliance * 20;
    const waterScore = Math.min((waterIntake / hydrationTarget) * 15, 15);
    const sleepScore = Math.min((sleepHours / 8) * 20, 20);
    const healthScore = Math.max(
      0,
      Math.min(100, Math.round(bmiScore + activityScore + proteinScore + waterScore + sleepScore)),
    );

    return {
      bmi,
      bmiCategory,
      whtr: parseFloat(whtr.toFixed(2)),
      whtrCategory,
      bmr,
      tdee,
      macros: {
        protein: Math.max(macros.protein, proteinFloor),
        fats: macros.fats,
        carbs: macros.carbs,
        totalCalories: macros.totalCalories,
      },
      healthScore,
      hydrationTarget: Math.round(hydrationTarget),
      recoveryStage: recovery.recoveryStage,
      recoveryFocus: recovery.recoveryFocus,
      suggestedNutrients: recovery.suggestedNutrients,
      suggestedFoods: recovery.suggestedFoods,
    };
  },
};

export function saveProfile(profile: HealthProfile) {
  localStorage.setItem('activerehab_health_profile', JSON.stringify(profile));
}

export function loadProfile(): HealthProfile | null {
  const data = localStorage.getItem('activerehab_health_profile');
  return data ? JSON.parse(data) : null;
}
