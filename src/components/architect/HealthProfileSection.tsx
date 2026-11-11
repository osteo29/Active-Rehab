import {Activity, Brain, Calculator, Calendar, ClipboardList, ShieldAlert, Sparkles} from 'lucide-react';
import type {RefObject} from 'react';
import type {ArchitectDraft} from '../../hooks/useArchitectProfile';
import {injuryDatabase, getInjuryById} from '../../services/injuryDatabase';
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

  return (
    <section className="py-24 bg-slate-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-medical-blue/10 px-4 py-1.5 text-sm font-bold text-medical-blue">
            <Brain className="w-4 h-4" />
            <span>{t.architect.title}</span>
          </div>
          <h2 className="mb-4 text-3xl font-bold text-slate-900 sm:text-4xl">{t.architect.subtitle}</h2>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          <div className="lg:col-span-4 space-y-6">
            <div className="medical-card p-6">
              <h3 className="text-lg font-bold mb-6 flex items-center gap-2">
                <ClipboardList className="w-5 h-5 text-medical-blue" />
                {t.architect.formTitle}
              </h3>

              <div className="space-y-4">
                <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                  <div className="space-y-1">
                    <label htmlFor="architect-age" className="text-xs font-bold text-slate-700 uppercase">{t.forms.age}</label>
                    <input id="architect-age" {...integerInputProps} value={architectDraft.age} onChange={(e) => updateArchitectDraft('age', e.target.value, {profileKey: 'age', min: 1})} placeholder="25" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                  </div>
                  <div className="space-y-1">
                    <label htmlFor="architect-weight" className="text-xs font-bold text-slate-700 uppercase">{t.forms.weight}</label>
                    <input id="architect-weight" {...decimalInputProps} value={architectDraft.weight} onChange={(e) => updateArchitectDraft('weight', e.target.value, {profileKey: 'weight', min: 1})} placeholder="70" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                  </div>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-height" className="text-xs font-bold text-slate-700 uppercase">{t.forms.height}</label>
                  <input id="architect-height" {...integerInputProps} value={architectDraft.height} onChange={(e) => updateArchitectDraft('height', e.target.value, {profileKey: 'height', min: 1})} placeholder="175" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                </div>

                <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                  <div className="space-y-1">
                    <label htmlFor="architect-gender" className="text-xs font-bold text-slate-700 uppercase">{t.architect.gender}</label>
                    <select id="architect-gender" value={architectProfile.gender} onChange={(e) => setArchitectProfile({...architectProfile, gender: e.target.value as 'male' | 'female'})} className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm bg-white">
                      <option value="male">{t.forms.male}</option>
                      <option value="female">{t.forms.female}</option>
                    </select>
                  </div>
                  <div className="space-y-1">
                    <label htmlFor="architect-goal" className="text-xs font-bold text-slate-700 uppercase">{t.architect.goal}</label>
                    <select id="architect-goal" value={architectProfile.goal} onChange={(e) => setArchitectProfile({...architectProfile, goal: e.target.value as HealthProfile['goal']})} className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm bg-white">
                      <option value="maintain">{t.forms.maintain}</option>
                      <option value="lose">{t.forms.lose}</option>
                      <option value="gain">{t.forms.gain}</option>
                      <option value="recovery">{lang === 'en' ? 'Recovery' : 'تعافي'}</option>
                    </select>
                  </div>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-activity-level" className="text-xs font-bold text-slate-700 uppercase">{t.architect.activityLevel}</label>
                  <select id="architect-activity-level" value={architectProfile.activityLevel} onChange={(e) => setArchitectProfile({...architectProfile, activityLevel: Number(e.target.value)})} className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm bg-white">
                    <option value="1.2">{t.forms.sedentary}</option>
                    <option value="1.375">{t.forms.lightly}</option>
                    <option value="1.55">{t.forms.moderately}</option>
                    <option value="1.725">{t.forms.very}</option>
                    <option value="1.9">{t.forms.extra}</option>
                  </select>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-injury-type" className="text-xs font-bold text-slate-700 uppercase">{t.architect.injuryType}</label>
                  <select id="architect-injury-type" value={architectProfile.injuryType || ''} onChange={(e) => setArchitectProfile({...architectProfile, injuryType: e.target.value || null})} className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm bg-white">
                    <option value="">{t.architect.noInjury}</option>
                    {Object.keys(injuryDatabase).map((id) => (
                      <option key={id} value={id}>{id}</option>
                    ))}
                  </select>
                </div>

                {architectProfile.injuryType && (
                  <div className="space-y-1">
                    <label htmlFor="architect-recovery-week" className="text-xs font-bold text-slate-700 uppercase">{t.architect.recoveryWeek}</label>
                  <input id="architect-recovery-week" {...integerInputProps} value={architectDraft.recoveryWeek} onChange={(e) => updateArchitectDraft('recoveryWeek', e.target.value, {profileKey: 'recoveryWeek', min: 1})} className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                </div>
                )}

                <div className="space-y-1">
                  <label htmlFor="architect-waist" className="text-xs font-bold text-slate-700 uppercase">{t.forms.waist} (cm)</label>
                  <input id="architect-waist" {...integerInputProps} value={architectDraft.waist} onChange={(e) => updateArchitectDraft('waist', e.target.value, {profileKey: 'waist', min: 1})} placeholder="80" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-neck" className="text-xs font-bold text-slate-700 uppercase">{t.forms.neck} (cm)</label>
                  <input id="architect-neck" {...integerInputProps} value={architectDraft.neck} onChange={(e) => updateArchitectDraft('neck', e.target.value, {profileKey: 'neck', min: 1})} placeholder="38" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-sleep-hours" className="text-xs font-bold text-slate-700 uppercase">{t.architect.sleep}</label>
                  <input id="architect-sleep-hours" type="range" min="4" max="12" step="0.5" value={architectProfile.sleepHours} onChange={(e) => setArchitectProfile({...architectProfile, sleepHours: Number(e.target.value)})} className="w-full accent-medical-blue" aria-valuetext={`${architectProfile.sleepHours} hours`} />
                  <div className="flex justify-between text-[10px] font-bold text-slate-600">
                    <span>4h</span>
                    <span className="text-blue-700">{architectProfile.sleepHours}h</span>
                    <span>12h</span>
                  </div>
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-water-intake" className="text-xs font-bold text-slate-700 uppercase">{t.architect.water}</label>
                  <input id="architect-water-intake" {...integerInputProps} value={architectDraft.waterIntake} onChange={(e) => updateArchitectDraft('waterIntake', e.target.value, {profileKey: 'waterIntake', min: 1})} placeholder="2500" className="w-full px-3 py-2 rounded-lg border border-slate-200 focus:ring-2 focus:ring-medical-blue outline-none text-sm" />
                </div>

                <div className="space-y-1">
                  <label htmlFor="architect-protein-compliance" className="text-xs font-bold text-slate-700 uppercase">{t.architect.proteinComp}</label>
                  <input id="architect-protein-compliance" type="range" min="0" max="1" step="0.1" value={architectProfile.proteinCompliance} onChange={(e) => setArchitectProfile({...architectProfile, proteinCompliance: Number(e.target.value)})} className="w-full accent-medical-blue" aria-valuetext={`${Math.round(architectProfile.proteinCompliance * 100)} percent`} />
                  <div className="flex justify-between text-[10px] font-bold text-slate-600">
                    <span>0%</span>
                    <span className="text-blue-700">{Math.round(architectProfile.proteinCompliance * 100)}%</span>
                    <span>100%</span>
                  </div>
                </div>

                <div className="pt-3">
                  <button type="button" onClick={calculateArchitectProfile} className="flex w-full items-center justify-center gap-2 rounded-2xl bg-medical-blue px-4 py-3 text-sm font-bold text-white transition-all hover:bg-blue-700">
                    <Calculator className="h-4 w-4" />
                    <span>{lang === 'en' ? 'Calculate now' : 'احسب الآن'}</span>
                  </button>
                  <p className="mt-2 text-center text-xs text-slate-600">
                    {lang === 'en'
                      ? 'Your inputs are saved automatically, and this button updates the dashboard immediately.'
                      : 'بياناتك تُحفظ تلقائيًا، وهذا الزر يحدّث اللوحة فورًا بعد إدخال الأرقام.'}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div id="architect-results" ref={architectResultsRef} className="lg:col-span-8 space-y-8">
            {architectMetrics ? (
              <>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                  <div className="medical-card p-6 flex flex-col items-center justify-center text-center">
                    <h4 className="text-sm font-bold text-slate-700 uppercase mb-4">{t.architect.scoreTitle}</h4>
                    <div className="relative w-32 h-32 flex items-center justify-center">
                      <svg className="w-full h-full transform -rotate-90">
                        <circle cx="64" cy="64" r="58" stroke="currentColor" strokeWidth="8" fill="transparent" className="text-slate-100" />
                        <circle cx="64" cy="64" r="58" stroke="currentColor" strokeWidth="8" fill="transparent" strokeDasharray={364.4} strokeDashoffset={364.4 - (364.4 * architectMetrics.healthScore) / 100} className="text-medical-blue transition-all duration-1000" />
                      </svg>
                      <span className="absolute text-3xl font-black text-slate-900">{architectMetrics.healthScore}</span>
                    </div>
                  </div>

                  <div className="md:col-span-2 medical-card p-6">
                    <h4 className="text-sm font-bold text-slate-700 uppercase mb-6">{t.architect.metricsTitle}</h4>
                    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-4">
                      <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                        <span className="mb-1 block text-[10px] font-bold uppercase text-slate-600">BMI</span>
                        <div className="flex flex-col">
                          <span className="text-lg font-black text-slate-900">{architectMetrics.bmi.toFixed(1)}</span>
                          <span className="text-[9px] font-bold text-blue-700 leading-tight">{architectMetrics.bmiCategory}</span>
                        </div>
                      </div>
                      <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                        <span className="mb-1 block text-[10px] font-bold uppercase text-slate-600">WHtR</span>
                        <div className="flex flex-col">
                          <span className="text-lg font-black text-slate-900">{architectMetrics.whtr.toFixed(2)}</span>
                          <span className={`text-[9px] font-bold leading-tight ${architectMetrics.whtrCategory.includes('Healthy') ? 'text-health-green' : architectMetrics.whtrCategory.includes('Risk') ? 'text-amber-500' : 'text-rose-500'}`}>
                            {architectMetrics.whtrCategory}
                          </span>
                        </div>
                      </div>
                      <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                        <span className="mb-1 block text-[10px] font-bold uppercase text-slate-600">Calories</span>
                        <span className="text-lg font-black text-slate-900">{architectMetrics.macros.totalCalories}</span>
                      </div>
                      <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                        <span className="mb-1 block text-[10px] font-bold uppercase text-slate-600">Protein</span>
                        <span className="text-lg font-black text-slate-900">{architectMetrics.macros.protein}g</span>
                      </div>
                      <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                        <span className="mb-1 block text-[10px] font-bold uppercase text-slate-600">{lang === 'en' ? 'Water' : 'الماء'}</span>
                        <span className="text-lg font-black text-slate-900">{architectMetrics.hydrationTarget}ml</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="medical-card p-6">
                  <h4 className="text-sm font-bold text-slate-700 uppercase mb-6 flex items-center gap-2">
                    <Calendar className="w-4 h-4 text-medical-blue" />
                    {t.architect.recoveryTimeline}
                  </h4>

                  <div className="relative">
                    {architectProfile.injuryType ? (
                      <>
                        <div className="absolute top-1/2 left-0 w-full h-0.5 bg-slate-100 -translate-y-1/2" />
                        <div className="relative flex justify-between">
                          {['week1-2', 'week3-6', 'week7+'].map((stage, idx) => {
                            const isCurrent = (architectProfile.recoveryWeek <= 2 && idx === 0) || (architectProfile.recoveryWeek > 2 && architectProfile.recoveryWeek <= 6 && idx === 1) || (architectProfile.recoveryWeek > 6 && idx === 2);
                            return (
                              <div key={stage} className="flex flex-col items-center relative z-10">
                                <div className={`w-4 h-4 rounded-full border-4 border-white shadow-sm ${isCurrent ? 'bg-medical-blue scale-125' : 'bg-slate-300'}`} />
                                <span className={`mt-2 text-[10px] font-bold uppercase ${isCurrent ? 'text-blue-700' : 'text-slate-600'}`}>{stage.replace('week', 'W')}</span>
                              </div>
                            );
                          })}
                        </div>
                      </>
                    ) : (
                      <div className="flex items-center justify-center py-4 text-slate-400 text-sm font-medium italic">
                        {lang === 'en' ? 'General Health & Longevity Mode' : 'وضع الصحة العامة وطول العمر'}
                      </div>
                    )}
                  </div>

                  <div className="mt-8 p-4 rounded-2xl bg-medical-blue/5 border border-medical-blue/10">
                    <div className="flex items-start gap-4">
                      <div className="bg-medical-blue p-2 rounded-lg text-white">
                        <Activity className="w-5 h-5" />
                      </div>
                      <div>
                        <h5 className="font-bold text-slate-900 mb-1">{architectMetrics.recoveryStage}</h5>
                        <p className="text-sm text-slate-600 mb-4"><span className="font-bold text-medical-blue">{t.architect.focus}:</span> {architectMetrics.recoveryFocus}</p>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                          <div>
                            <h6 className="text-[10px] font-bold text-slate-400 uppercase mb-2">{t.architect.nutrients}</h6>
                            <div className="flex flex-wrap gap-2">
                              {architectMetrics.suggestedNutrients.map((n: any, i: number) => (
                                <span key={i} className="px-2 py-1 rounded-md bg-white border border-slate-200 text-[10px] font-medium text-slate-700">
                                  {n.name} ({n.dosage})
                                </span>
                              ))}
                            </div>
                          </div>
                          <div>
                            <h6 className="text-[10px] font-bold text-slate-400 uppercase mb-2">{t.architect.foods}</h6>
                            <div className="flex flex-wrap gap-2">
                              {architectMetrics.suggestedFoods.map((f, i) => (
                                <span key={i} className="px-2 py-1 rounded-md bg-health-green/10 text-health-green text-[10px] font-bold">
                                  {f}
                                </span>
                              ))}
                            </div>
                          </div>
                        </div>

                        {architectProfile.injuryType && getInjuryById(architectProfile.injuryType)?.contraindications && (
                          <div className="mt-6 pt-6 border-t border-slate-200">
                            <h6 className="text-[10px] font-bold text-red-500 uppercase mb-3 flex items-center gap-1">
                              <ShieldAlert className="w-3 h-3" />
                              {t.architect.contraindications}
                            </h6>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                              <div>
                                <span className="text-[10px] font-bold text-slate-500 block mb-1">{t.architect.meds}</span>
                                <ul className="text-xs text-slate-600 list-disc list-inside">
                                  {getInjuryById(architectProfile.injuryType)?.contraindications?.medications.map((m, i) => (
                                    <li key={i}>{m}</li>
                                  ))}
                                </ul>
                              </div>
                              <div>
                                <span className="text-[10px] font-bold text-slate-500 block mb-1">{t.architect.supps}</span>
                                <ul className="text-xs text-slate-600 list-disc list-inside">
                                  {getInjuryById(architectProfile.injuryType)?.contraindications?.supplements.map((s, i) => (
                                    <li key={i}>{s}</li>
                                  ))}
                                </ul>
                              </div>
                            </div>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>

                <div className="medical-card p-6 overflow-hidden relative">
                  <div className="flex justify-between items-center mb-6">
                    <h4 className="text-sm font-bold text-slate-500 uppercase flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-amber-500" />
                      {t.architect.aiDietTitle}
                    </h4>
                    <button onClick={generateAIDietPlan} disabled={isGeneratingPlan} className="bg-medical-blue text-white px-4 py-2 rounded-xl text-xs font-bold hover:bg-blue-700 transition-all disabled:opacity-50 flex items-center gap-2">
                      {isGeneratingPlan ? <div className="w-3 h-3 border-2 border-white border-t-transparent rounded-full animate-spin" /> : <Brain className="w-3 h-3" />}
                      {t.architect.generatePlan}
                    </button>
                  </div>

                  {aiDietPlan ? (
                    <div className="prose prose-sm max-w-none text-slate-600 bg-slate-50 p-6 rounded-2xl border border-slate-100 max-h-96 overflow-y-auto">
                      <div className="whitespace-pre-line break-words">{aiDietPlan}</div>
                    </div>
                  ) : (
                    <div className="h-48 flex flex-col items-center justify-center text-center p-8 bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                      <Sparkles className="w-8 h-8 text-slate-200 mb-4" />
                      <p className="text-sm text-slate-400">
                        {lang === 'en' ? 'Click the button to generate your personalized AI diet plan based on your recovery stage.' : 'انقر على الزر لإنشاء خطتك الغذائية المخصصة بالذكاء الاصطناعي بناءً على مرحلة تعافيك.'}
                      </p>
                    </div>
                  )}
                </div>
              </>
            ) : (
              <div className="medical-card p-6 md:p-8">
                <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
                  {lang === 'en' ? 'Live dashboard preview' : 'معاينة اللوحة المباشرة'}
                </div>
                <h4 className="text-2xl font-bold text-slate-900 mb-3">
                  {lang === 'en' ? 'Enter your own values to activate the dashboard' : 'أدخل بياناتك الحقيقية لتفعيل اللوحة'}
                </h4>
                <p className="text-sm leading-7 text-slate-600 max-w-2xl">
                  {lang === 'en'
                    ? 'The fields show examples as placeholders only. Nothing is calculated or saved until you enter your own data.'
                    : 'الحقول تعرض أمثلة إرشادية فقط داخل الـ placeholders. لن يتم حساب أو حفظ أي شيء حتى تدخل بياناتك أنت.'}
                </p>
              </div>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
