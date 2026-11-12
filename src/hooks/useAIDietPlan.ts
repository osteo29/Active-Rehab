import {useState} from 'react';
import type {HealthMetrics, HealthProfile} from '../logic/physioNutritionEngine';
import type {Language} from '../services/translations';

type Options = {
  architectMetrics: HealthMetrics | null;
  architectProfile: HealthProfile;
  lang: Language;
};

function generateClinicalFallbackPlan(profile: HealthProfile, metrics: HealthMetrics, lang: Language): string {
  const isAr = lang === 'ar';
  const cals = metrics.macros.totalCalories;
  const protein = metrics.macros.protein;
  const carbs = metrics.macros.carbs;
  const fats = metrics.macros.fats;
  const water = metrics.hydrationTarget;
  const injury = profile.injuryType || (isAr ? 'الصحة العامة والتأهيل' : 'General Recovery & Health');

  if (isAr) {
    return `### 🥗 خطة التغذية السريرية والتأهيل المتكامل

**المؤشرات المحسوبة لحالتك:**
* السعرات اليومية المستهدفة: **${cals} سعرة حرارية**
* البروتين المستهدف: **${protein} غرام** (ضروري لترميم الأنسجة العضلية والوترية)
* الكربوهيدرات المعقدة: **${carbs} غرام** (لتجديد مخازن الجلايكوجين والطاقة)
* الدهون الصحية: **${fats} غرام** (لتقليل الالتهابات ودعم الهرمونات)
* الاحتياج اليومي من الماء: **${water} مل** (~${(water / 250).toFixed(1)} أكواب)

---

#### 🍽️ نموذج خطة الوجبات اليومية المقترحة:
1. **وجبة الإفطار (صباحًا):**
   * 3 بيضات مسلوقة أو أومليت مع خضار ورقية (سبانخ/بقدونس).
   * رغيف خبز حبة كاملة أو شوفان بالحليب والمكسرات.
   * ثمرة فاكهة غنية بفيتامين C (برتقال أو كيوي) لدعم تصنيع الكولاجين.

2. **سناك 1 (بين الوجبات):**
   * زبادي يوناني (200 جم) مع ملعقة عسل وبذور شيا.
   * قبضة يد مكسرات نيئة (لوز وجوز).

3. **وجبة الغداء (الرئيسية):**
   * 180 جم صدور دجاج مشوية أو سلمون غني بالأوميغا 3.
   * كوب أرز بني أو بطاطا مشوية.
   * طبق سلطة خضراء مع ملعقة زيت زيتون بكر ممتاز.

4. **سناك 2 (عصرًا):**
   * موزة مع ملعقة زبدة فول سوداني + كوب شاي أخضر.

5. **وجبة العشاء (خفيفة وغنية بالبروتين البطيء):**
   * 150 جم جبن قريش أو تونة مصفاة بالليمون.
   * شرائح خيار وطماطم مع نصف رغيف خبز شوفان.

---

#### 💊 المكملات الغذائية السريرية المقترحة لحالة (${injury}):
* **أوميغا 3 (EPA/DHA):** 1000 - 2000 مجم يوميًا بعد الوجبة لتهدئة الالتهابات الحادة.
* **فيتامين D3 + K2:** 2000 - 5000 وحدة دولية لدعم صحة العظام والمفاصل والمناعة.
* **المغنيسيوم جلايسينات (Magnesium Glycinate):** 300 - 400 مجم قبل النوم لتحسين استرخاء العضلات وجودة النوم.
* **فيتامين C (500 ملجم) مع بروتين الكولاجين:** قبل جلسة التأهيل بـ 45 دقيقة لدعم الأوتار والأربطة.

---

#### 💡 توصيات سريرية مهمة لتسريع التعافي:
* **النوم العميق:** استهدف من 7 إلى 8 ساعات نوم متواصل في غرفة مظلمة؛ لأن هرمون النمو وإصلاح الأنسجة يعملان بكفاءة أثناء النوم العميق.
* **تدرج الحمل الحركي:** لا تضغط على المفصل المصاب عند ظهور ألم حاد يتجاوز 3/10، وتدرج تدريجيًا وفق إرشادات المعالج.`;
  }

  return `### 🥗 Clinical Physio-Nutrition & Recovery Plan

**Target Daily Macronutrients:**
* Target Calories: **${cals} kcal**
* Target Protein: **${protein}g** (essential for muscle & tendon remodeling)
* Complex Carbohydrates: **${carbs}g** (energy & glycogen replenishment)
* Healthy Fats: **${fats}g** (anti-inflammatory signaling & joint health)
* Hydration Target: **${water}ml** (~${(water / 250).toFixed(1)} glasses)

---

#### 🍽️ 1-Day Sample Meal Plan:
1. **Breakfast:**
   * 3 eggs (scrambled or boiled) with spinach and bell peppers.
   * Whole grain toast or 60g oatmeal with berries.
   * 1 kiwi or orange (rich in Vitamin C for collagen synthesis).

2. **Mid-Morning Snack:**
   * Greek yogurt (200g) with 1 tbsp chia seeds and a handful of walnuts.

3. **Lunch:**
   * 180g grilled chicken breast or baked salmon (high in Omega-3).
   * 1 cup brown rice or baked sweet potato.
   * Large mixed green salad drizzled with extra virgin olive oil.

4. **Afternoon Snack:**
   * 1 apple or banana with 1 tbsp almond butter + green tea.

5. **Dinner:**
   * 150g cottage cheese or white fish with steamed broccoli and asparagus.
   * 1 small sweet potato or quinoa.

---

#### 💊 Evidence-Based Supplement Protocol for (${injury}):
* **Omega-3 Fish Oil (EPA/DHA):** 1000 - 2000mg daily to modulate tissue inflammation.
* **Vitamin D3 + K2:** 2000 - 4000 IU daily with breakfast for musculoskeletal health.
* **Magnesium Glycinate:** 300 - 400mg 30 minutes before bed to support muscle relaxation and restorative sleep.
* **Vitamin C (500mg) + Collagen Peptides (10g):** Taken 45 minutes prior to rehabilitation loading.

---

#### 💡 Clinical Recovery Rules:
* **Sleep Quality:** Prioritize 7.5 to 8.5 hours of uninterrupted sleep for peak tissue repair.
* **The 24-Hour Pain Rule:** Exercise pain up to 3/10 is acceptable if it subsides within 1 hour and symptoms do not escalate the following morning.`;
}

export function useAIDietPlan({architectMetrics, architectProfile, lang}: Options) {
  const [aiDietPlan, setAiDietPlan] = useState<string | null>(null);
  const [isGeneratingPlan, setIsGeneratingPlan] = useState(false);

  const generateAIDietPlan = async () => {
    if (!architectMetrics) return;

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
        setAiDietPlan(generateClinicalFallbackPlan(architectProfile, architectMetrics, lang));
      }
    } catch {
      // Seamlessly fall back to instant evidence-based clinical diet plan
      setAiDietPlan(generateClinicalFallbackPlan(architectProfile, architectMetrics, lang));
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
