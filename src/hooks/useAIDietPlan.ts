import {useState} from 'react';
import type {HealthMetrics, HealthProfile} from '../logic/physioNutritionEngine';
import type {Language} from '../services/translations';

type Options = {
  architectMetrics: HealthMetrics | null;
  architectProfile: HealthProfile;
  lang: Language;
};

export function useAIDietPlan({architectMetrics, architectProfile, lang}: Options) {
  const [aiDietPlan, setAiDietPlan] = useState<string | null>(null);
  const [isGeneratingPlan, setIsGeneratingPlan] = useState(false);
  const unavailableMessage = lang === 'ar'
    ? 'تعذر إنشاء خطة التغذية. حاول مرة أخرى لاحقًا. لم يتم إنشاء خطة شخصية. راجع مختصًا قبل تغيير نظامك الغذائي أو استخدام مكملات.'
    : 'The nutrition plan could not be generated. Try again later. No personalized plan was created. Consult a qualified professional before changing your diet or using supplements.';

  const generateAIDietPlan = async () => {
    if (!architectMetrics) return;

    setAiDietPlan(null);
    setIsGeneratingPlan(true);
    try {
      const {askGeminiText} = await import('../ai/gemini');
      const response = await askGeminiText({
        system:
          'You are a senior clinical nutritionist and physiotherapist. Give practical, safe, evidence-aligned guidance. Use clean markdown only, with no HTML.',
        user: `Generate a highly professional and evidence-based Physio-Nutrition Diet Plan for the following user:
          
          USER PROFILE:
          - Age: ${architectProfile.age}
          - Weight: ${architectProfile.weight}kg
          - Height: ${architectProfile.height}cm
          - Gender: ${architectProfile.gender}
          - Activity Level: ${architectProfile.activityLevel}
          - Health Goal: ${architectProfile.goal}
          - Current Injury: ${architectProfile.injuryType || 'None'}
          - Recovery Week: ${architectProfile.recoveryWeek}
          
          CALCULATED METRICS:
          - BMI: ${architectMetrics.bmi} (${architectMetrics.bmiCategory})
          - Target Calories: ${architectMetrics.macros.totalCalories} kcal
          - Protein: ${architectMetrics.macros.protein}g
          - Carbs: ${architectMetrics.macros.carbs}g
          - Fats: ${architectMetrics.macros.fats}g
          - Hydration Target: ${architectMetrics.hydrationTarget}ml
          
          RECOVERY CONTEXT:
          - Stage: ${architectMetrics.recoveryStage}
          - Focus: ${architectMetrics.recoveryFocus}
          
          INSTRUCTIONS:
          1. Provide a 1-day sample meal plan (Breakfast, Lunch, Dinner, 2 Snacks).
          2. Focus on anti-inflammatory foods and specific nutrients for ${architectMetrics.recoveryFocus}.
          3. Suggest 2-3 evidence-based supplements (with dosages) relevant to the injury or goal.
          4. Include 2-3 specific lifestyle tips for recovery (e.g., sleep, stress, mobility).
          5. Use a professional, encouraging tone.
          
          FORMAT:
          - Use clean Markdown with bold headers.
          - Use bullet points for lists.
          - Language: ${lang === 'en' ? 'English' : 'Arabic'}.`,
      });

      if (response && response.trim().length > 50) {
        setAiDietPlan(response);
      } else {
        setAiDietPlan(unavailableMessage);
      }
    } catch {
      // Never present an unreviewed generic plan as a personalized model result.
      setAiDietPlan(unavailableMessage);
    } finally {
      setIsGeneratingPlan(false);
    }
  };

  return {
    aiDietPlan,
    generateAIDietPlan,
    isGeneratingPlan,
  };
}
