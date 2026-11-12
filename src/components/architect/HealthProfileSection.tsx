import {Activity, Brain, Calculator, Calendar, ClipboardList, ShieldAlert, Sparkles, Wand2} from 'lucide-react';
import type {RefObject} from 'react';
import type {ArchitectDraft} from '../../hooks/useArchitectProfile';
import {injuryDatabase, getInjuryById} from '../../services/injuryDatabase';
import {translateInjury} from '../../services/injuryI18n';
import type {HealthMetrics, HealthProfile} from '../../services/physioNutritionLogic';
import {translations} from '../../services/translations';

type Props = {
  aiDietPlan: string | null;
  architectDraft: ArchitectDraft;
  architectMetrics: HealthMetrics | null;
  architectProfile: HealthProfile;
  architectResultsRef: RefObject<HTMLDivElement | null>;
  calculateArchitectProfile: () => void;
  generateAIDietPlan: () => void;
  isGeneratingPlan: boolean;
  lang: 'en' | 'ar';
  setArchitectProfile: (value: HealthProfile | ((prev: HealthProfile) => HealthProfile)) => void;
  t: (typeof translations)[keyof typeof translations];
  updateArchitectDraft: (
    field: keyof ArchitectDraft,
    value: string,
    sync?: {profileKey: keyof HealthProfile; min?: number},
  ) => void;
};

export default function HealthProfileSection({
  aiDietPlan,
  architectDraft,
  architectMetrics,
  architectProfile,
  architectResultsRef,
  calculateArchitectProfile,
  generateAIDietPlan,
  isGeneratingPlan,
  lang,
  setArchitectProfile,
  t,
  updateArchitectDraft,
}: Props) {
  const isAr = lang === 'ar';

  const integerInputProps = {
    type: 'text' as const,
    inputMode: 'numeric' as const,
    dir: 'ltr' as const,
  };

  const decimalInputProps = {
    type: 'text' as const,
    inputMode: 'decimal' as const,
    dir: 'ltr' as const,
  };

  const handleFillSampleData = () => {
    updateArchitectDraft('age', '28', {profileKey: 'age'});
    updateArchitectDraft('weight', '74', {profileKey: 'weight'});
    updateArchitectDraft('height', '176', {profileKey: 'height'});
    updateArchitectDraft('waist', '82', {profileKey: 'waist'});
    updateArchitectDraft('neck', '38', {profileKey: 'neck'});
    updateArchitectDraft('recoveryWeek', '3', {profileKey: 'recoveryWeek'});
    updateArchitectDraft('waterIntake', '2800', {profileKey: 'waterIntake'});
    setArchitectProfile((prev) => ({
      ...prev,
      age: 28,
      weight: 74,
      height: 176,
      gender: 'male',
      goal: 'recovery',
      activityLevel: 1.55,
      injuryType: 'acl_tear',
      recoveryWeek: 3,
      sleepHours: 8,
      waterIntake: 2800,
      proteinCompliance: 0.85,
    }));
  };

  return (
    <section className="bg-slate-50 py-16 dark:bg-slate-950 sm:py-20">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-12 text-center">
          <div className="mb-3 inline-flex items-center gap-2 rounded-full bg-health-green/10 px-4 py-1.5 text-xs font-bold uppercase tracking-wider text-health-green">
            <Brain className="h-4 w-4" />
            <span>{t.architect.title}</span>
          </div>
          <h2 className="text-2xl font-black text-slate-900 dark:text-white sm:text-4xl">
            {t.architect.subtitle}
          </h2>
          <p className="mx-auto mt-2 max-w-2xl text-xs text-slate-500 sm:text-sm">
            {isAr
              ? 'احسب احتياجاتك من السعرات والماكروز وفق مرحلة التعافي الفعلية وتوصيات الغذاء والمكملات السريرية.'
              : 'Calculate calories, protein requirements, and phased anti-inflammatory nutrition for your recovery.'}
          </p>
        </div>

        <div className="grid grid-cols-1 gap-8 lg:grid-cols-12">
          {/* Left Form Column */}
          <div className="space-y-6 lg:col-span-4">
            <div className="medical-card p-5 sm:p-6 dark:border-slate-800 dark:bg-slate-900">
              <div className="mb-5 flex items-center justify-between">
                <h3 className="flex items-center gap-2 text-base font-bold text-slate-900 dark:text-white">
                  <ClipboardList className="h-5 w-5 text-health-green" />
                  <span>{t.architect.formTitle}</span>
                </h3>
                <button
                  type="button"
                  onClick={handleFillSampleData}
                  className="inline-flex items-center gap-1 rounded-lg border border-health-green/30 bg-health-green/10 px-2.5 py-1 text-[11px] font-bold text-health-green transition hover:bg-health-green/20"
                >
                  <Wand2 className="h-3 w-3" />
                  <span>{isAr ? 'تجربة بنموذج' : 'Load Demo'}</span>
                </button>
              </div>

              <div className="space-y-4 text-xs">
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label htmlFor="architect-age" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.forms.age}
                    </label>
                    <input
                      id="architect-age"
                      {...integerInputProps}
                      value={architectDraft.age}
                      onChange={(e) => updateArchitectDraft('age', e.target.value, {profileKey: 'age', min: 1})}
                      placeholder="28"
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    />
                  </div>
                  <div className="space-y-1">
                    <label htmlFor="architect-weight" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.forms.weight} (kg)
                    </label>
                    <input
                      id="architect-weight"
                      {...decimalInputProps}
                      value={architectDraft.weight}
                      onChange={(e) => updateArchitectDraft('weight', e.target.value, {profileKey: 'weight', min: 1})}
                      placeholder="74"
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    />
                  </div>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-height" className="font-bold text-slate-700 dark:text-slate-300">
                    {t.forms.height} (cm)
                  </label>
                  <input
                    id="architect-height"
                    {...integerInputProps}
                    value={architectDraft.height}
                    onChange={(e) => updateArchitectDraft('height', e.target.value, {profileKey: 'height', min: 1})}
                    placeholder="176"
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label htmlFor="architect-gender" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.architect.gender}
                    </label>
                    <select
                      id="architect-gender"
                      value={architectProfile.gender}
                      onChange={(e) => setArchitectProfile({...architectProfile, gender: e.target.value as 'male' | 'female'})}
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    >
                      <option value="male">{t.forms.male}</option>
                      <option value="female">{t.forms.female}</option>
                    </select>
                  </div>
                  <div className="space-y-1">
                    <label htmlFor="architect-goal" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.architect.goal}
                    </label>
                    <select
                      id="architect-goal"
                      value={architectProfile.goal}
                      onChange={(e) => setArchitectProfile({...architectProfile, goal: e.target.value as HealthProfile['goal']})}
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    >
                      <option value="recovery">{isAr ? 'التعافي من الإصابة' : 'Injury Recovery'}</option>
                      <option value="maintain">{t.forms.maintain}</option>
                      <option value="lose">{t.forms.lose}</option>
                      <option value="gain">{t.forms.gain}</option>
                    </select>
                  </div>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-injury-type" className="font-bold text-slate-700 dark:text-slate-300">
                    {t.architect.injuryType}
                  </label>
                  <select
                    id="architect-injury-type"
                    value={architectProfile.injuryType || ''}
                    onChange={(e) => setArchitectProfile({...architectProfile, injuryType: e.target.value || null})}
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                  >
                    <option value="">{t.architect.noInjury}</option>
                    {Object.entries(injuryDatabase).map(([id, item]) => {
                      const translated = translateInjury(
                        {
                          slugOrId: id,
                          nameEn: item.name,
                          category: item.category,
                          regionEn: item.bodyRegion,
                          overviewEn: '',
                        },
                        lang,
                      );
                      return (
                        <option key={id} value={id}>
                          {translated.name} ({translated.bodyRegion})
                        </option>
                      );
                    })}
                  </select>
                </div>

                {architectProfile.injuryType && (
                  <div className="space-y-1">
                    <label htmlFor="architect-recovery-week" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.architect.recoveryWeek}
                    </label>
                    <input
                      id="architect-recovery-week"
                      {...integerInputProps}
                      value={architectDraft.recoveryWeek}
                      onChange={(e) => updateArchitectDraft('recoveryWeek', e.target.value, {profileKey: 'recoveryWeek', min: 1})}
                      placeholder="3"
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    />
                  </div>
                )}

                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label htmlFor="architect-waist" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.forms.waist} (cm)
                    </label>
                    <input
                      id="architect-waist"
                      {...integerInputProps}
                      value={architectDraft.waist}
                      onChange={(e) => updateArchitectDraft('waist', e.target.value, {profileKey: 'waist', min: 1})}
                      placeholder="80"
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    />
                  </div>
                  <div className="space-y-1">
                    <label htmlFor="architect-neck" className="font-bold text-slate-700 dark:text-slate-300">
                      {t.forms.neck} (cm)
                    </label>
                    <input
                      id="architect-neck"
                      {...integerInputProps}
                      value={architectDraft.neck}
                      onChange={(e) => updateArchitectDraft('neck', e.target.value, {profileKey: 'neck', min: 1})}
                      placeholder="38"
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none focus:border-health-green dark:border-slate-800 dark:bg-slate-950 dark:text-white"
                    />
                  </div>
                </div>

                <div className="space-y-1">
                  <div className="flex justify-between font-bold text-slate-700 dark:text-slate-300">
                    <span>{t.architect.sleep}</span>
                    <span className="text-health-green">{architectProfile.sleepHours}h</span>
                  </div>
                  <input
                    id="architect-sleep-hours"
                    type="range"
                    min="4"
                    max="12"
                    step="0.5"
                    value={architectProfile.sleepHours}
                    onChange={(e) => setArchitectProfile({...architectProfile, sleepHours: Number(e.target.value)})}
                    className="w-full accent-health-green"
                  />
                </div>

                <div className="pt-2">
                  <button
                    type="button"
                    onClick={calculateArchitectProfile}
                    className="flex w-full items-center justify-center gap-2 rounded-xl bg-health-green px-4 py-3 text-sm font-bold text-slate-950 shadow-md transition hover:bg-[#d3aa54]"
                  >
                    <Calculator className="h-4 w-4" />
                    <span>{isAr ? 'حساب وتحديث اللوحة' : 'Calculate & Update'}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Right Results Dashboard */}
          <div id="architect-results" ref={architectResultsRef} className="space-y-6 lg:col-span-8">
            {architectMetrics ? (
              <>
                {/* Metrics Cards */}
                <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-4">
                  <div className="medical-card p-5 dark:border-slate-800 dark:bg-slate-900">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                      {t.architect.scoreTitle}
                    </div>
                    <div className="mt-2 text-3xl font-black text-health-green">
                      {architectMetrics.healthScore}
                      <span className="text-xs font-medium text-slate-400">/100</span>
                    </div>
                    <div className="mt-1 text-xs text-slate-500">
                      {isAr ? 'مؤشر كفاءة التعافي' : 'Recovery readiness'}
                    </div>
                  </div>

                  <div className="medical-card p-5 dark:border-slate-800 dark:bg-slate-900">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                      BMI & WHtR
                    </div>
                    <div className="mt-2 text-2xl font-black text-slate-900 dark:text-white">
                      {architectMetrics.bmi.toFixed(1)}
                    </div>
                    <div className="mt-1 text-xs font-bold text-health-green">
                      {architectMetrics.bmiCategory}
                    </div>
                  </div>

                  <div className="medical-card p-5 dark:border-slate-800 dark:bg-slate-900">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                      {isAr ? 'السعرات المستهدفة' : 'Target Calories'}
                    </div>
                    <div className="mt-2 text-2xl font-black text-slate-900 dark:text-white">
                      {architectMetrics.macros.totalCalories}
                    </div>
                    <div className="mt-1 text-xs text-slate-500">kcal / day</div>
                  </div>

                  <div className="medical-card p-5 dark:border-slate-800 dark:bg-slate-900">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                      {isAr ? 'البروتين المستهدف' : 'Target Protein'}
                    </div>
                    <div className="mt-2 text-2xl font-black text-health-green">
                      {architectMetrics.macros.protein}g
                    </div>
                    <div className="mt-1 text-xs text-slate-500">
                      {isAr ? 'لترميم الأنسجة' : 'For tissue repair'}
                    </div>
                  </div>
                </div>

                {/* Recovery Stage & Phased Guidance */}
                <div className="medical-card p-6 dark:border-slate-800 dark:bg-slate-900">
                  <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                    <h4 className="flex items-center gap-2 text-base font-bold text-slate-900 dark:text-white">
                      <Activity className="h-5 w-5 text-health-green" />
                      <span>{architectMetrics.recoveryStage || (isAr ? 'مرحلة التعافي' : 'Recovery Phase')}</span>
                    </h4>
                    <span className="rounded-full bg-health-green/10 px-3 py-1 text-xs font-bold text-health-green">
                      {t.architect.focus}: {architectMetrics.recoveryFocus}
                    </span>
                  </div>

                  <div className="mt-6 grid grid-cols-1 gap-5 md:grid-cols-2">
                    <div className="rounded-2xl border border-slate-100 bg-slate-50 p-4 dark:border-slate-800 dark:bg-slate-950">
                      <div className="mb-2 text-xs font-bold uppercase tracking-wider text-slate-400">
                        {t.architect.nutrients}
                      </div>
                      <div className="flex flex-wrap gap-2">
                        {architectMetrics.suggestedNutrients.map((n: any, i: number) => (
                          <span
                            key={i}
                            className="rounded-lg border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
                          >
                            {n.name} ({n.dosage})
                          </span>
                        ))}
                      </div>
                    </div>

                    <div className="rounded-2xl border border-slate-100 bg-slate-50 p-4 dark:border-slate-800 dark:bg-slate-950">
                      <div className="mb-2 text-xs font-bold uppercase tracking-wider text-slate-400">
                        {t.architect.foods}
                      </div>
                      <div className="flex flex-wrap gap-2">
                        {architectMetrics.suggestedFoods.map((f, i) => (
                          <span
                            key={i}
                            className="rounded-lg bg-health-green/15 px-2.5 py-1 text-xs font-bold text-health-green"
                          >
                            {f}
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>

                {/* AI / Clinical Diet Generator */}
                <div className="medical-card p-6 dark:border-slate-800 dark:bg-slate-900">
                  <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                    <div>
                      <h4 className="flex items-center gap-2 text-base font-bold text-slate-900 dark:text-white">
                        <Sparkles className="h-4 w-4 text-health-green" />
                        <span>{t.architect.aiDietTitle}</span>
                      </h4>
                      <p className="mt-1 text-xs text-slate-500">
                        {isAr
                          ? 'خطة غذائية مفصلة تدعم مرحلة تأهيلك وتقلل الالتهابات'
                          : 'Personalized meal plan aligned with your rehabilitation stage'}
                      </p>
                    </div>

                    <button
                      type="button"
                      onClick={generateAIDietPlan}
                      disabled={isGeneratingPlan}
                      className="inline-flex items-center justify-center gap-2 rounded-xl bg-health-green px-4 py-2.5 text-xs font-bold text-slate-950 shadow-sm transition hover:bg-[#d3aa54] disabled:opacity-50"
                    >
                      {isGeneratingPlan ? (
                        <div className="h-3.5 w-3.5 animate-spin rounded-full border-2 border-slate-950 border-t-transparent" />
                      ) : (
                        <Sparkles className="h-3.5 w-3.5" />
                      )}
                      <span>{t.architect.generatePlan}</span>
                    </button>
                  </div>

                  {aiDietPlan ? (
                    <div className="mt-5 max-h-[30rem] overflow-y-auto rounded-2xl border border-slate-100 bg-slate-50 p-5 text-sm leading-relaxed text-slate-700 dark:border-slate-800 dark:bg-slate-950 dark:text-slate-300">
                      <div className="whitespace-pre-line break-words">{aiDietPlan}</div>
                    </div>
                  ) : (
                    <div className="mt-5 flex flex-col items-center justify-center rounded-2xl border border-dashed border-slate-200 bg-slate-50/50 p-8 text-center dark:border-slate-800 dark:bg-slate-950/50">
                      <Sparkles className="h-8 w-8 text-slate-300 dark:text-slate-600" />
                      <p className="mt-3 text-xs text-slate-400">
                        {isAr
                          ? 'اضغط على الزر بالأعلى لإنشاء خطتك الغذائية السريرية المتوافقة مع مرحلة تأهيلك.'
                          : 'Click the button above to generate your clinical recovery diet plan.'}
                      </p>
                    </div>
                  )}
                </div>
              </>
            ) : (
              <div className="medical-card p-8 text-center dark:border-slate-800 dark:bg-slate-900">
                <Brain className="mx-auto h-12 w-12 text-slate-300 dark:text-slate-600" />
                <h4 className="mt-4 text-xl font-bold text-slate-900 dark:text-white">
                  {isAr ? 'أدخل بياناتك لتشغيل اللوحة' : 'Enter Your Information to Activate'}
                </h4>
                <p className="mx-auto mt-2 max-w-md text-xs leading-relaxed text-slate-500">
                  {isAr
                    ? 'أدخل العمر، الوزن، والطول في النموذج على اليمين، أو اضغط زر التجربة بنموذج لترى النتائج فورًا.'
                    : 'Fill in your age, weight, and height in the form, or click "Load Demo" to see instant results.'}
                </p>
                <div className="mt-5">
                  <button
                    type="button"
                    onClick={handleFillSampleData}
                    className="inline-flex items-center gap-2 rounded-xl bg-health-green px-5 py-2.5 text-xs font-bold text-slate-950 shadow-sm transition hover:bg-[#d3aa54]"
                  >
                    <Wand2 className="h-4 w-4" />
                    <span>{isAr ? 'تجربة بنموذج جاهز الآن' : 'Load Demo Profile'}</span>
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
