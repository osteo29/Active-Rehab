/**
 * Clinical Calculator Logic for PhysioNutrition
 */

export interface BMRParams {
  weight: number; // kg
  height: number; // cm
  age: number;
  gender: 'male' | 'female';
  bodyFat?: number; // Optional for Katch-McArdle
}

export interface MacroResult {
  protein: number;
  carbs: number;
  fats: number;
  totalCalories: number;
}

export type GoalType = 'lose' | 'maintain' | 'gain';
export type BodyType = 'ectomorph' | 'mesomorph' | 'endomorph';

export const CalculatorLogic = {
  /**
   * BMI Calculator
   * Formula: weight (kg) / height (m)^2
   */
  calculateBMI: (weight: number, heightCm: number): number => {
    if (weight <= 0 || heightCm <= 0) return 0;
    const heightM = heightCm / 100;
    return parseFloat((weight / (heightM * heightM)).toFixed(1));
  },

  /**
   * Waist-to-Height Ratio (WHtR)
   * A better predictor of health risk than BMI
   */
  calculateWHtR: (waistCm: number, heightCm: number): number => {
    if (waistCm <= 0 || heightCm <= 0) return 0;
    return parseFloat((waistCm / heightCm).toFixed(2));
  },

  /**
   * Calorie Calculator (Mifflin-St Jeor or Katch-McArdle)
   */
  calculateBMR: (params: BMRParams): number => {
    const { weight, height, age, gender, bodyFat } = params;
    
    // Katch-McArdle if bodyFat is provided
    if (bodyFat !== undefined && bodyFat > 0) {
      const lbm = weight * (1 - bodyFat / 100);
      return Math.round(370 + (21.6 * lbm));
    }

    // Mifflin-St Jeor (Default)
    if (weight <= 0 || height <= 0 || age <= 0) return 0;
    
    if (gender === 'male') {
      return Math.round((10 * weight) + (6.25 * height) - (5 * age) + 5);
    } else {
      return Math.round((10 * weight) + (6.25 * height) - (5 * age) - 161);
    }
  },

  /**
   * TDEE Calculator
   */
  calculateTDEE: (bmr: number, activityLevel: number): number => {
    return Math.round(bmr * activityLevel);
  },

  /**
   * Macro Nutrient Calculator
   * Based on TDEE, Goal, and Body Type
   */
  calculateMacros: (tdee: number, goal: GoalType, bodyType: BodyType): MacroResult => {
    let targetCalories = tdee;
    if (goal === 'lose') targetCalories -= 500;
    if (goal === 'gain') targetCalories += 300;

    // Ratios based on Body Type and Goal
    // Default: Balanced 30/40/30
    let ratio = { p: 0.3, c: 0.4, f: 0.3 };

    if (bodyType === 'ectomorph') {
      // High Carb
      ratio = { p: 0.25, c: 0.55, f: 0.2 };
    } else if (bodyType === 'endomorph') {
      // Low Carb / High Fat & Protein
      ratio = { p: 0.35, c: 0.25, f: 0.4 };
    } else {
      // Mesomorph: Balanced / Moderate Carb
      ratio = { p: 0.3, c: 0.4, f: 0.3 };
    }

    // Adjust for Goal
    if (goal === 'lose') {
      ratio.p += 0.05;
      ratio.c -= 0.05;
    }

    return {
      protein: Math.round((targetCalories * ratio.p) / 4),
      carbs: Math.round((targetCalories * ratio.c) / 4),
      fats: Math.round((targetCalories * ratio.f) / 9),
      totalCalories: targetCalories
    };
  },

  /**
   * Protein Intake Calculator
   */
  calculateProteinIntake: (weight: number, factor: number): number => {
    if (weight <= 0) return 0;
    return Math.round(weight * factor);
  },

  /**
   * Ideal Weight Calculator (Devine Formula)
   */
  calculateIdealWeight: (heightCm: number, gender: 'male' | 'female'): number => {
    if (heightCm <= 0) return 0;
    const heightInches = heightCm / 2.54;
    const inchesOver5Feet = Math.max(0, heightInches - 60);
    const baseWeight = gender === 'male' ? 50.0 : 45.5;
    return parseFloat((baseWeight + (2.3 * inchesOver5Feet)).toFixed(1));
  },

  /**
   * Body Fat Calculator (U.S. Navy Method - Metric)
   */
  calculateBodyFat: (params: { gender: 'male' | 'female'; height: number; waist: number; neck: number; hip?: number }): number => {
    const { gender, height, waist, neck, hip } = params;
    if (height <= 0 || waist <= 0 || neck <= 0 || (gender === 'female' && !hip)) return 0;

    if (gender === 'male') {
      // Metric formula: 86.010 * log10(waist - neck) - 70.041 * log10(height) + 36.76
      const bf = 86.010 * Math.log10(waist - neck) - 70.041 * Math.log10(height) + 36.76;
      return parseFloat(Math.max(0, bf).toFixed(1));
    } else {
      // Metric formula: 163.205 * log10(waist + hip - neck) - 97.684 * log10(height) - 78.387
      const bf = 163.205 * Math.log10(waist + (hip || 0) - neck) - 97.684 * Math.log10(height) - 78.387;
      return parseFloat(Math.max(0, bf).toFixed(1));
    }
  },

  /**
   * Body Fat Category
   */
  getBodyFatCategory: (bf: number, gender: 'male' | 'female', lang: 'en' | 'ar'): string => {
    if (bf <= 0) return '-';
    if (gender === 'male') {
      if (bf < 6) return lang === 'en' ? 'Essential Fat' : 'دهون أساسية';
      if (bf < 14) return lang === 'en' ? 'Athletes' : 'رياضي';
      if (bf < 18) return lang === 'en' ? 'Fitness' : 'لياقة';
      if (bf < 25) return lang === 'en' ? 'Average' : 'متوسط';
      return lang === 'en' ? 'Obese' : 'سمنة';
    } else {
      if (bf < 14) return lang === 'en' ? 'Essential Fat' : 'دهون أساسية';
      if (bf < 21) return lang === 'en' ? 'Athletes' : 'رياضي';
      if (bf < 25) return lang === 'en' ? 'Fitness' : 'لياقة';
      if (bf < 32) return lang === 'en' ? 'Average' : 'متوسط';
      return lang === 'en' ? 'Obese' : 'سمنة';
    }
  },
  calculateWaterIntake: (weight: number, activityLevel: number, options?: { hotClimate?: boolean; pregnancy?: boolean }): number => {
    if (weight <= 0) return 0;
    let base = weight * 33;
    if (activityLevel > 1.2) base += 500;
    if (activityLevel > 1.5) base += 500;
    
    if (options?.hotClimate) base += 500;
    if (options?.pregnancy) base += 800; // Average of 700-1000

    return Math.round(base);
  },

  /**
   * Calorie Deficit Calculator
   */
  calculateDeficit: (tdee: number, pace: number): { deficit: number; warning: boolean } => {
    const deficit = tdee - pace;
    return {
      deficit: Math.max(0, deficit),
      warning: deficit < 1200 || pace >= 1000
    };
  }
};
