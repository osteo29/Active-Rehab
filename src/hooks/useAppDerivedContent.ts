import {useMemo} from 'react';

import type {HealthInterpretation} from '../logic/physioNutritionLogic';
import type {CalculatorType} from '../features/tools/app/types';
import type {Language} from '../services/translations';

type DerivedContentParams = {
  activeCalculator: CalculatorType;
  healthInterpretation: HealthInterpretation | null;
  lang: Language;
  result: unknown;
};

function toFiniteNumberOrNull(value: unknown) {
  const parsed = typeof value === 'number' ? value : Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

export function useAppDerivedContent({
  activeCalculator,
  healthInterpretation,
  lang,
  result,
}: DerivedContentParams) {
  const practicalGuide = useMemo(() => {
    if (!activeCalculator || result === null) return null;

    if (activeCalculator === 'Macros' && typeof result === 'object') {
      const macros = result as {protein: number; carbs: number; fats: number};
      return {
        title: lang === 'en' ? 'Turn this into meals' : 'حوّل النتيجة إلى وجبات',
        items:
          lang === 'en'
            ? [
                `Aim for about 4 protein feedings across the day.`,
                `A simple split could be ${Math.round(macros.protein / 4)}g protein, ${Math.round(macros.carbs / 4)}g carbs, and ${Math.round(macros.fats / 4)}g fats per meal.`,
                'Use the food database below to build an example meal that matches your targets.',
              ]
            : [
                `استهدف تقريبًا 4 جرعات بروتين خلال اليوم.`,
                `يمكنك تقسيمها مثلًا إلى ${Math.round(macros.protein / 4)} جم بروتين و${Math.round(macros.carbs / 4)} جم كارب و${Math.round(macros.fats / 4)} جم دهون في الوجبة.`,
                'استخدم قاعدة الطعام بالأسفل لبناء وجبة تناسب هدفك.',
              ],
      };
    }

    if (activeCalculator === 'Protein' && typeof result === 'number') {
      return {
        title: lang === 'en' ? 'Easy protein split' : 'تقسيم بروتين سهل',
        items:
          lang === 'en'
            ? [
                `Your target works well as ${Math.ceil(result / 4)}g protein over 4 meals.`,
                'Prioritize one protein source in every meal or snack.',
                'If you are recovering from injury, spread intake evenly instead of taking it all at night.',
              ]
            : [
                `يمكن تقسيم هدفك إلى حوالي ${Math.ceil(result / 4)} جم بروتين على 4 وجبات.`,
                'اجعل في كل وجبة أو سناك مصدر بروتين واضح.',
                'إذا كنت في مرحلة تعافٍ، وزّع البروتين على اليوم بدل جمعه في وجبة واحدة.',
              ],
      };
    }

    if (activeCalculator === 'Water' && typeof result === 'number') {
      return {
        title: lang === 'en' ? 'Hydration plan' : 'خطة الترطيب',
        items:
          lang === 'en'
            ? [
                `That is about ${(result / 1000).toFixed(1)} liters for the day.`,
                `Start with roughly ${Math.round(result / 5)} ml in each of 5 moments during the day.`,
                'Increase around training, hot weather, or heavy sweating.',
              ]
            : [
                `يعادل ذلك تقريبًا ${(result / 1000).toFixed(1)} لتر يوميًا.`,
                `ابدأ بتقسيمه إلى نحو ${Math.round(result / 5)} مل في 5 مرات خلال اليوم.`,
                'زد الكمية مع التمرين أو الجو الحار أو التعرق العالي.',
              ],
      };
    }

    if (activeCalculator === 'Deficit' && typeof result === 'object') {
      return {
        title: lang === 'en' ? 'How to use it safely' : 'كيف تستخدمه بأمان',
        items:
          lang === 'en'
            ? [
                'Treat this as a calorie target, not a reason to cut food quality.',
                'Keep protein high and avoid aggressive cuts unless supervised.',
                'Review progress weekly instead of changing calories every day.',
              ]
            : [
                'تعامل مع الرقم كهدف سعرات، وليس كسبب لتقليل جودة الأكل.',
                'حافظ على البروتين مرتفعًا وتجنب العجز العنيف إلا بإشراف.',
                'راجع التقدم أسبوعيًا بدل تعديل السعرات كل يوم.',
              ],
      };
    }

    if ((activeCalculator === 'BMI' || activeCalculator === 'BodyFat' || activeCalculator === 'WHtR') && healthInterpretation) {
      return {
        title: lang === 'en' ? 'What to do next' : 'ماذا تفعل بعد ذلك',
        items:
          lang === 'en'
            ? [
                'Use this as a screening result, not a full diagnosis.',
                'Combine it with waist, activity, sleep, and recovery context.',
                'If the result looks concerning, move to the recovery dashboard or ask the assistant for context.',
              ]
            : [
                'استخدم هذه النتيجة كمؤشر أولي وليس تشخيصًا كاملًا.',
                'اربطها مع محيط الخصر والنشاط والنوم وسياق التعافي.',
                'إذا كانت النتيجة مقلقة، انتقل إلى لوحة التعافي أو اسأل المساعد لفهمها أكثر.',
              ],
      };
    }

    return {
      title: lang === 'en' ? 'Suggested next step' : 'الخطوة التالية المقترحة',
      items:
        lang === 'en'
          ? [
              'Use this result as a starting point for your recovery or nutrition decision.',
              'Compare it with your current routine before making big changes.',
              'Open the assistant if you want this translated into a practical plan.',
            ]
          : [
              'استخدم هذه النتيجة كنقطة بداية لقرارك الغذائي أو التعافي.',
              'قارنها بروتينك الحالي قبل عمل تغييرات كبيرة.',
              'افتح المساعد إذا أردت تحويلها لخطة عملية.',
            ],
    };
  }, [activeCalculator, healthInterpretation, lang, result]);

  const assessmentSnapshot = useMemo(() => {
    if (result === null || !activeCalculator) {
      return {
        valueLabel: '',
        valueNumeric: null as number | null,
        valueUnit: null as string | null,
      };
    }

    if (activeCalculator === 'Macros' && typeof result === 'object') {
      const macros = result as {totalCalories: number; protein: number; carbs: number; fats: number};
      return {
        valueLabel: `${macros.totalCalories} kcal | P ${macros.protein}g | C ${macros.carbs}g | F ${macros.fats}g`,
        valueNumeric: toFiniteNumberOrNull(macros.totalCalories),
        valueUnit: 'kcal',
      };
    }

    if (activeCalculator === 'Deficit' && typeof result === 'object') {
      const deficit = result as {deficit: number};
      return {
        valueLabel: `${deficit.deficit} kcal`,
        valueNumeric: toFiniteNumberOrNull(deficit.deficit),
        valueUnit: 'kcal',
      };
    }

    if (activeCalculator === 'WHtR' && typeof result === 'object') {
      const ratio = result as {ratio: number; category: string};
      return {
        valueLabel: `${ratio.ratio} (${ratio.category})`,
        valueNumeric: toFiniteNumberOrNull(ratio.ratio),
        valueUnit: 'ratio',
      };
    }

    if (typeof result === 'number') {
      return {
        valueLabel: String(result),
        valueNumeric: result,
        valueUnit:
          activeCalculator === 'Water'
            ? 'ml'
            : activeCalculator === 'Protein'
              ? 'g/day'
              : activeCalculator === 'IdealWeight'
                ? 'kg'
                : activeCalculator === 'BodyFat'
                  ? '%'
                  : activeCalculator === 'BMI'
                    ? 'BMI'
                    : 'kcal',
      };
    }

    return {
      valueLabel: typeof result === 'object' ? JSON.stringify(result) : String(result),
      valueNumeric: null,
      valueUnit: null,
    };
  }, [activeCalculator, result]);

  return {assessmentSnapshot, practicalGuide};
}
