import {HelpCircle, Info, Plus, Search, Trash2, X, Calculator as CalculatorIcon} from 'lucide-react';
import {lazy, Suspense} from 'react';
import {Link} from 'react-router-dom';
import type {CalculatorWorkspaceController} from '../../hooks/useCalculatorWorkspace';
import {statusToTextClass} from '../../logic/physioNutritionLogic';
import {translations, type Language} from '../../services/translations';
import {normalizeNumericInput} from '../../utils/numericInput';

const ResultCharts = lazy(() => import('../results/ResultCharts'));
const ResultAssistantPanel = lazy(() => import('../results/ResultAssistantPanel'));

type AppTranslations = (typeof translations)[Language];

type Props = {
  assessmentSnapshot: {
    valueLabel: string;
    valueNumeric: number | null;
    valueUnit: string | null;
  };
  controller: CalculatorWorkspaceController;
  lang: Language;
  practicalGuide: {title: string; items: string[]} | null;
  t: AppTranslations;
};

const decimalInputProps = {
  type: 'text',
  inputMode: 'decimal' as const,
  dir: 'ltr' as const,
};

const integerInputProps = {
  type: 'text',
  inputMode: 'numeric' as const,
  dir: 'ltr' as const,
};

export default function CalculatorSection({assessmentSnapshot, controller, lang, practicalGuide, t}: Props) {
  const {
    activeCalculator,
    activeCalculatorMeta,
    activeToolGroup,
    activity,
    age,
    analysisPrompt,
    bodyFatInput,
    bodyType,
    clearAllMealItems,
    error,
    gender,
    goal,
    handleCalculate,
    healthInterpretation,
    height,
    hip,
    hotClimate,
    isCustomModalOpen,
    isTooltipModalOpen,
    isWristModalOpen,
    knowBodyFat,
    mealItems,
    neck,
    newFood,
    openResultAnalysis,
    pace,
    pregnancy,
    removeMealItem,
    resetForm,
    result,
    saveCustomFood,
    setActiveCalculator,
    setActiveToolGroup,
    setActivity,
    setAge,
    setAnalysisPrompt,
    setBodyFatInput,
    setBodyType,
    setGender,
    setGoal,
    setHeight,
    setHip,
    setHotClimate,
    setIsCustomModalOpen,
    setIsTooltipModalOpen,
    setIsWristModalOpen,
    setKnowBodyFat,
    setNeck,
    setNewFood,
    setPace,
    setPregnancy,
    setUnitSystem,
    setWaist,
    setWeight,
    showTooltip,
    tooltipData,
    toolGroups,
    unitSystem,
    updateMealItem,
    visibleCalculators,
    waist,
    weight,
    addMealItem,
  } = controller;

  const objectResult = result as Record<string, any> | null;

  return (
    <>
      <section className="bg-white py-16 sm:py-20 lg:py-24">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mb-10 flex flex-col gap-6 sm:mb-12">
            <div className="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
              <div>
                <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green">
                  <CalculatorIcon className="h-3.5 w-3.5" />
                  <span>{lang === 'en' ? 'Tool hub' : 'مركز الأدوات'}</span>
                </div>
                <h2 className="mb-3 text-3xl font-bold text-slate-900">{t.calculators.sectionTitle}</h2>
                <p className="max-w-2xl text-slate-600">
                  {lang === 'en'
                    ? 'Choose a tool category first, then open the calculator that matches your goal.'
                    : 'اختر فئة الأداة أولًا، ثم افتح الحاسبة المناسبة لهدفك.'}
                </p>
              </div>

              <div className="rounded-[1.75rem] border border-slate-200 bg-slate-50 p-4 lg:max-w-sm">
                <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.18em] text-slate-600">
                  {lang === 'en' ? 'Selected tool' : 'الأداة المختارة'}
                </div>
                <div className="mb-1 font-bold text-slate-900">
                  {activeCalculatorMeta?.title || (lang === 'en' ? 'No tool selected yet' : 'لم يتم اختيار أداة بعد')}
                </div>
                <p className="text-sm leading-6 text-slate-600">
                  {activeCalculatorMeta?.desc || (lang === 'en' ? 'Pick a calculator to see only the inputs you need.' : 'اختر حاسبة لعرض الحقول المطلوبة فقط.')}
                </p>
              </div>
            </div>

            <div className="flex gap-3 overflow-x-auto pb-1 sm:flex-wrap sm:overflow-visible">
              {toolGroups.map((group) => (
                <button
                  key={group.id}
                  onClick={() => setActiveToolGroup(group.id)}
                  className={`min-w-[150px] rounded-2xl border px-4 py-3 text-left transition-all sm:min-w-0 ${
                    activeToolGroup === group.id
                      ? 'border-health-green bg-soft-blue text-health-green shadow-sm'
                      : 'border-slate-200 bg-white text-slate-800 hover:border-health-green/30'
                  }`}
                >
                  <div className="text-sm font-bold">{group.label}</div>
                  <div className="mt-1 text-xs opacity-80">{group.desc}</div>
                </button>
              ))}
            </div>
          </div>

          <div className="mb-10 grid grid-cols-1 gap-4 sm:mb-12 sm:grid-cols-2 xl:grid-cols-3">
            {visibleCalculators.map((calculator) => (
              <button
                key={calculator.id}
                onClick={() => {
                  setActiveCalculator(calculator.id);
                  resetForm();
                }}
                aria-label={calculator.title}
                className={`medical-card group relative flex h-full flex-col items-start p-4 text-left transition-all sm:p-5 md:p-6 ${
                  activeCalculator === calculator.id ? 'bg-soft-blue ring-2 ring-health-green' : ''
                }`}
              >
                <div className="mb-4 flex w-full items-start justify-between gap-3">
                  <div className={`rounded-2xl p-3 ${activeCalculator === calculator.id ? 'bg-health-green text-white' : 'bg-soft-blue text-health-green'}`}>
                    {calculator.icon}
                  </div>
                  <span className="text-[10px] font-bold uppercase tracking-[0.16em] text-slate-600">
                    {toolGroups.find((group) => group.id === calculator.group)?.label}
                  </span>
                </div>
                <h3 className="mb-2 flex items-center gap-2 text-base font-bold text-slate-900">
                  {calculator.title}
                  <div className="opacity-0 transition-opacity group-hover:opacity-100">
                    <HelpCircle className="h-3 w-3 text-slate-600" />
                  </div>
                </h3>
                <p className="mb-3 text-sm leading-6 text-slate-600">{calculator.desc}</p>
                <div className="text-xs font-medium text-slate-600">{calculator.hint}</div>
                <div className="pointer-events-none absolute inset-0 rounded-2xl ring-0 ring-health-green/10 transition-all group-hover:ring-4" />
              </button>
            ))}
          </div>

          {!activeCalculator && (
            <div className="mb-8 rounded-[1.75rem] border border-dashed border-slate-200 bg-slate-50 p-5 text-center sm:mb-10 sm:p-6">
              <div className="mb-2 font-bold text-slate-900">
                {lang === 'en' ? 'Pick a calculator to continue' : 'اختر حاسبة للمتابعة'}
              </div>
              <p className="mx-auto max-w-2xl text-sm text-slate-600">
                {lang === 'en'
                  ? 'The form below adapts automatically based on the selected tool, so you only see the relevant inputs.'
                  : 'النموذج بالأسفل يتغير تلقائيًا حسب الأداة المختارة، حتى ترى فقط الحقول المهمة.'}
              </p>
            </div>
          )}

          {activeCalculator && (
            <div id="calculator-workspace" className="rounded-[2rem] border border-slate-200 bg-slate-50 p-4 sm:p-6 md:p-8">
              <div className="mx-auto max-w-3xl">
                <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                  <div>
                    <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
                      {toolGroups.find((group) => group.id === activeCalculatorMeta?.group)?.label}
                    </div>
                    <h3 className="flex items-center gap-2 text-2xl font-bold">{activeCalculatorMeta?.title}</h3>
                    <p className="mt-2 text-sm leading-6 text-slate-600">{activeCalculatorMeta?.desc}</p>
                  </div>
                  <button
                    onClick={resetForm}
                    className="rounded-xl border border-slate-200 px-4 py-2 text-sm font-bold text-slate-800 transition-all hover:border-health-green hover:text-health-green"
                  >
                    {lang === 'en' ? 'Clear inputs' : 'مسح الحقول'}
                  </button>
                </div>

                <div className="mb-8 grid grid-cols-1 gap-6 sm:grid-cols-2">
                  <div className="space-y-2 sm:col-span-2">
                    <div className="flex items-center justify-between">
                      <label className="text-sm font-semibold text-slate-700">{t.forms.weight}</label>
                      <div className="text-[10px] font-bold uppercase tracking-widest text-slate-600">Required</div>
                    </div>
                    <input
                      {...decimalInputProps}
                      value={weight}
                      onChange={(event) => setWeight(normalizeNumericInput(event.target.value))}
                      placeholder={t.forms.placeholderWeight}
                      className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                    />
                  </div>

                  {['BMI', 'WHtR', 'BMR', 'TDEE', 'Macros', 'IdealWeight', 'BodyFat', 'Deficit'].includes(activeCalculator) && (
                    <div className="space-y-2">
                      <label className="flex items-center gap-1 text-sm font-semibold text-slate-700">
                        {t.forms.height}
                        {activeCalculator === 'IdealWeight' && (
                          <button type="button" onClick={() => showTooltip(t.forms.height, t.tooltips.ideal)}>
                            <Info className="h-3 w-3 text-slate-400" />
                          </button>
                        )}
                      </label>
                      <input
                        {...integerInputProps}
                        value={height}
                        onChange={(event) => setHeight(normalizeNumericInput(event.target.value, {allowDecimal: false}))}
                        placeholder={t.forms.placeholderHeight}
                        className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                      />
                    </div>
                  )}

                  {['BMR', 'TDEE', 'Macros', 'Deficit'].includes(activeCalculator) && (
                    <div className="space-y-2">
                      <label className="flex items-center gap-1 text-sm font-semibold text-slate-700">
                        {t.forms.age}
                        {activeCalculator === 'BMR' && (
                          <button type="button" onClick={() => showTooltip(t.forms.age, t.tooltips.bmr)}>
                            <Info className="h-3 w-3 text-slate-400" />
                          </button>
                        )}
                      </label>
                      <input
                        {...integerInputProps}
                        value={age}
                        onChange={(event) => setAge(normalizeNumericInput(event.target.value, {allowDecimal: false}))}
                        placeholder={t.forms.placeholderAge}
                        className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                      />
                    </div>
                  )}

                  {['BMR', 'TDEE', 'Macros', 'IdealWeight', 'BodyFat', 'Deficit', 'WHtR'].includes(activeCalculator) && (
                    <div className="space-y-2">
                      <label className="text-sm font-semibold text-slate-700">{t.forms.gender}</label>
                      <div className="flex rounded-xl bg-slate-200 p-1">
                        <button
                          type="button"
                          onClick={() => setGender('male')}
                          className={`flex-1 rounded-lg py-2 text-sm font-bold transition-all ${gender === 'male' ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                        >
                          {t.forms.male}
                        </button>
                        <button
                          type="button"
                          onClick={() => setGender('female')}
                          className={`flex-1 rounded-lg py-2 text-sm font-bold transition-all ${gender === 'female' ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                        >
                          {t.forms.female}
                        </button>
                      </div>
                    </div>
                  )}

                  {['BodyFat', 'WHtR'].includes(activeCalculator) && (
                    <>
                      <div className="space-y-2 sm:col-span-2">
                        <label className="flex items-center gap-1 text-sm font-semibold text-slate-700">
                          {t.forms.unitSystem}
                          <button type="button" onClick={() => showTooltip(t.forms.unitSystem, t.tooltips.navy)}>
                            <Info className="h-3 w-3 text-slate-400" />
                          </button>
                        </label>
                        <div className="flex rounded-xl bg-slate-200 p-1">
                          <button
                            type="button"
                            onClick={() => setUnitSystem('metric')}
                            className={`flex-1 rounded-lg py-2 text-xs font-bold transition-all ${unitSystem === 'metric' ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                          >
                            {t.forms.metric}
                          </button>
                          <button
                            type="button"
                            onClick={() => setUnitSystem('imperial')}
                            className={`flex-1 rounded-lg py-2 text-xs font-bold transition-all ${unitSystem === 'imperial' ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                          >
                            {t.forms.imperial}
                          </button>
                        </div>
                      </div>
                      <div className="space-y-2">
                        <label className="text-sm font-semibold text-slate-700">{t.forms.waist} ({unitSystem === 'metric' ? 'cm' : 'in'})</label>
                        <input
                          {...decimalInputProps}
                          value={waist}
                          onChange={(event) => setWaist(normalizeNumericInput(event.target.value))}
                          placeholder={t.forms.placeholderWaist}
                          className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                        />
                      </div>
                      <div className="space-y-2">
                        <label className="text-sm font-semibold text-slate-700">{t.forms.neck} ({unitSystem === 'metric' ? 'cm' : 'in'})</label>
                        <input
                          {...decimalInputProps}
                          value={neck}
                          onChange={(event) => setNeck(normalizeNumericInput(event.target.value))}
                          placeholder={t.forms.placeholderNeck}
                          className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                        />
                      </div>
                      {gender === 'female' && (
                        <div className="space-y-2">
                          <label className="text-sm font-semibold text-slate-700">{t.forms.hip} ({unitSystem === 'metric' ? 'cm' : 'in'})</label>
                          <input
                            {...decimalInputProps}
                            value={hip}
                            onChange={(event) => setHip(normalizeNumericInput(event.target.value))}
                            placeholder={t.forms.placeholderHip}
                            className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                          />
                        </div>
                      )}
                    </>
                  )}

                  {['TDEE', 'Macros', 'Water', 'Deficit'].includes(activeCalculator) && (
                    <div className="space-y-2 sm:col-span-2">
                      <label className="flex items-center gap-1 text-sm font-semibold text-slate-700">
                        {t.forms.activityLevel}
                        {['TDEE', 'Macros'].includes(activeCalculator) && (
                          <button type="button" onClick={() => showTooltip(t.forms.activityLevel, t.tooltips.tdee)}>
                            <Info className="h-3 w-3 text-slate-400" />
                          </button>
                        )}
                      </label>
                      <div className="grid grid-cols-1 gap-2 sm:grid-cols-3 md:grid-cols-5">
                        {[
                          {val: '1.2', label: t.forms.sedentary.split('(')[0]},
                          {val: '1.375', label: t.forms.lightly.split('(')[0]},
                          {val: '1.55', label: t.forms.moderately.split('(')[0]},
                          {val: '1.725', label: t.forms.very.split('(')[0]},
                          {val: '1.9', label: t.forms.extra.split('(')[0]},
                        ].map((option) => (
                          <button
                            key={option.val}
                            type="button"
                            onClick={() => setActivity(option.val)}
                            className={`rounded-xl border px-3 py-2 text-xs font-bold transition-all ${
                              activity === option.val
                                ? 'border-health-green bg-health-green text-white shadow-md'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-health-green'
                            }`}
                          >
                            {option.label}
                          </button>
                        ))}
                      </div>
                    </div>
                  )}

                  {['BMR', 'TDEE', 'Macros', 'Deficit'].includes(activeCalculator) && (
                    <div className="space-y-4 sm:col-span-2">
                      <div className="flex items-center gap-2">
                        <input
                          id="knowBF"
                          type="checkbox"
                          checked={knowBodyFat}
                          onChange={(event) => setKnowBodyFat(event.target.checked)}
                          className="h-4 w-4 accent-health-green"
                        />
                        <label htmlFor="knowBF" className="flex items-center gap-1 text-sm font-semibold text-slate-700">
                          {t.forms.knowBodyFat}
                          <button type="button" onClick={() => showTooltip(t.forms.knowBodyFat, t.tooltips.katch)}>
                            <Info className="h-3 w-3 text-slate-400" />
                          </button>
                        </label>
                      </div>
                      {knowBodyFat && (
                        <div className="space-y-2">
                          <label className="text-sm font-semibold text-slate-700">{t.forms.bodyFat}</label>
                          <input
                            {...decimalInputProps}
                            value={bodyFatInput}
                            onChange={(event) => setBodyFatInput(normalizeNumericInput(event.target.value))}
                            placeholder="e.g. 15"
                            className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                          />
                        </div>
                      )}
                    </div>
                  )}

                  {activeCalculator === 'Macros' && (
                    <>
                      <div className="space-y-2 sm:col-span-2">
                        <label className="text-sm font-semibold text-slate-700">{t.forms.goal}</label>
                        <div className="flex rounded-xl bg-slate-200 p-1">
                          {[
                            {id: 'lose', label: t.forms.lose},
                            {id: 'maintain', label: t.forms.maintain},
                            {id: 'gain', label: t.forms.gain},
                          ].map((item) => (
                            <button
                              key={item.id}
                              type="button"
                              onClick={() => setGoal(item.id as typeof goal)}
                              className={`flex-1 rounded-lg py-2 text-xs font-bold transition-all ${goal === item.id ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                            >
                              {item.label}
                            </button>
                          ))}
                        </div>
                      </div>
                      <div className="space-y-2 sm:col-span-2">
                        <label className="flex items-center gap-2 text-sm font-semibold text-slate-700">
                          {t.somatotype.title}
                          <button type="button" onClick={() => setIsWristModalOpen(true)}>
                            <HelpCircle className="h-3 w-3 text-health-green" />
                          </button>
                        </label>
                        <div className="flex rounded-xl bg-slate-200 p-1">
                          {[
                            {id: 'ectomorph', label: t.somatotype.ecto},
                            {id: 'mesomorph', label: t.somatotype.meso},
                            {id: 'endomorph', label: t.somatotype.endo},
                          ].map((item) => (
                            <button
                              key={item.id}
                              type="button"
                              onClick={() => setBodyType(item.id as typeof bodyType)}
                              className={`flex-1 rounded-lg py-2 text-xs font-bold transition-all ${bodyType === item.id ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                            >
                              {item.label}
                            </button>
                          ))}
                        </div>
                        <p className="text-[10px] font-medium italic text-health-green">
                          {bodyType === 'ectomorph' ? t.somatotype.ectoTip : bodyType === 'mesomorph' ? t.somatotype.mesoTip : t.somatotype.endoTip}
                        </p>
                      </div>
                    </>
                  )}

                  {activeCalculator === 'Deficit' && (
                    <div className="space-y-2 sm:col-span-2">
                      <label className="text-sm font-semibold text-slate-700">{t.forms.pace}</label>
                      <div className="flex rounded-xl bg-slate-200 p-1">
                        {[
                          {id: 250, label: t.forms.conservative},
                          {id: 500, label: t.forms.normal},
                          {id: 1000, label: t.forms.aggressive},
                        ].map((item) => (
                          <button
                            key={item.id}
                            type="button"
                            onClick={() => setPace(item.id)}
                            className={`flex-1 rounded-lg py-2 text-[10px] font-bold transition-all ${pace === item.id ? 'bg-white text-health-green shadow-sm' : 'text-slate-700'}`}
                          >
                            {item.label}
                          </button>
                        ))}
                      </div>
                    </div>
                  )}

                  {activeCalculator === 'Water' && (
                    <div className="space-y-4 sm:col-span-2">
                      <div className="flex items-center gap-4">
                        <div className="flex items-center gap-2">
                          <input id="hotClimate" type="checkbox" checked={hotClimate} onChange={(event) => setHotClimate(event.target.checked)} className="h-4 w-4 accent-health-green" />
                          <label htmlFor="hotClimate" className="text-sm font-semibold text-slate-700">{t.forms.hotClimate}</label>
                        </div>
                        <div className="flex items-center gap-2">
                          <input id="pregnancy" type="checkbox" checked={pregnancy} onChange={(event) => setPregnancy(event.target.checked)} className="h-4 w-4 accent-health-green" />
                          <label htmlFor="pregnancy" className="text-sm font-semibold text-slate-700">{t.forms.pregnancy}</label>
                        </div>
                      </div>
                    </div>
                  )}

                  {activeCalculator === 'Protein' && (
                    <div className="space-y-2 sm:col-span-2">
                      <label className="text-sm font-semibold text-slate-700">{t.forms.activityGoal}</label>
                      <div className="grid grid-cols-1 gap-2 sm:grid-cols-2 md:grid-cols-5">
                        {[
                          {val: '0.8', label: t.forms.proteinSedentary.split('(')[0]},
                          {val: '1.2', label: t.forms.proteinModerate.split('(')[0]},
                          {val: '1.6', label: t.forms.proteinStrength.split('(')[0]},
                          {val: '2.0', label: t.forms.proteinAthlete.split('(')[0]},
                          {val: '1.8', label: t.forms.proteinInjury.split('(')[0]},
                        ].map((option) => (
                          <button
                            key={option.val}
                            type="button"
                            onClick={() => setActivity(option.val)}
                            className={`rounded-xl border px-3 py-2 text-[10px] font-bold transition-all ${
                              activity === option.val
                                ? 'border-health-green bg-health-green text-white shadow-md'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-health-green'
                            }`}
                          >
                            {option.label}
                          </button>
                        ))}
                      </div>
                    </div>
                  )}

                  {activeCalculator === 'Meal' && (
                    <div className="space-y-4 sm:col-span-2">
                      <label className="text-sm font-semibold text-slate-700">{t.forms.mealIngredients}</label>
                      {mealItems.map((item) => (
                        <div key={item.id} className="flex items-center gap-2">
                          <input
                            type="text"
                            placeholder={t.forms.ingredientName}
                            value={item.name}
                            onChange={(event) => updateMealItem(item.id, 'name', event.target.value)}
                            className="flex-1 rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                          />
                          <input
                            {...decimalInputProps}
                            placeholder={t.forms.calories}
                            value={item.calories}
                            onChange={(event) => updateMealItem(item.id, 'calories', event.target.value)}
                            className="w-24 rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green"
                          />
                          <button type="button" onClick={() => removeMealItem(item.id)} className="rounded-xl p-3 text-red-500 transition-colors hover:bg-red-50">
                            <Trash2 className="h-5 w-5" />
                          </button>
                        </div>
                      ))}
                      <div className="flex flex-wrap gap-4 border-t border-slate-200 pt-4">
                        <button type="button" onClick={addMealItem} className="flex items-center gap-2 text-sm font-bold text-health-green hover:underline">
                          <Plus className="h-4 w-4" /> {t.forms.addIngredient}
                        </button>
                        <button type="button" onClick={clearAllMealItems} className="flex items-center gap-2 text-sm font-bold text-red-500 hover:underline">
                          <Trash2 className="h-4 w-4" /> {t.ux.clearAll}
                        </button>
                      </div>
                      <div className="pt-4">
                        <a href="#food-db" className="flex items-center gap-2 text-sm font-medium text-slate-500 transition-colors hover:text-health-green">
                          <Search className="h-4 w-4" />
                          {t.forms.browseFoodDb}
                        </a>
                      </div>
                    </div>
                  )}
                </div>

                {error && <div className="mb-6 rounded-xl bg-red-50 p-4 text-sm font-medium text-red-600">{error}</div>}

                <button onClick={handleCalculate} className="w-full rounded-2xl bg-health-green py-4 text-lg font-bold text-white shadow-lg shadow-health-green/20 transition-all hover:bg-health-green-dark">
                  {t.forms.calculate}
                </button>

                {result !== null && (
                  <div className="relative mt-10 overflow-hidden rounded-3xl border border-white/20 bg-white/40 p-8 shadow-2xl backdrop-blur-xl">
                    <div className="absolute left-0 top-0 h-1 w-full bg-gradient-to-r from-health-green to-medical-blue" />
                    <div className="relative z-10 text-center">
                      <span className="mb-2 block text-sm font-bold uppercase tracking-widest text-health-green">{t.results.yourResult}</span>
                      <div className="mb-4 text-5xl font-bold text-slate-900">
                        {typeof result === 'object' && activeCalculator === 'WHtR' ? (
                          <div className="space-y-2">
                            <div className="text-5xl font-bold text-slate-900">{objectResult?.ratio}</div>
                            <div className={`text-lg font-bold uppercase ${
                              String(objectResult?.category || '').includes('Healthy') || String(objectResult?.category || '').includes('صحي')
                                ? 'text-health-green'
                                : String(objectResult?.category || '').includes('Risk') || String(objectResult?.category || '').includes('مخاطر')
                                  ? 'text-amber-500'
                                  : 'text-rose-500'
                            }`}>
                              {objectResult?.category}
                            </div>
                          </div>
                        ) : typeof result === 'object' && activeCalculator === 'Macros' ? (
                          <div className="space-y-8">
                            <div className="grid grid-cols-3 gap-4 text-2xl">
                              <div><div className="text-health-green">{objectResult?.protein}g</div><div className="text-xs uppercase text-slate-400">{t.results.protein}</div></div>
                              <div><div className="text-medical-blue">{objectResult?.carbs}g</div><div className="text-xs uppercase text-slate-400">{t.results.carbs}</div></div>
                              <div><div className="text-orange-500">{objectResult?.fats}g</div><div className="text-xs uppercase text-slate-400">{t.results.fats}</div></div>
                            </div>
                            <div className="rounded-2xl border border-slate-100 bg-slate-50 p-4 text-center">
                              <div className="mb-1 text-sm font-bold uppercase tracking-widest text-slate-400">{lang === 'en' ? 'Target Calories' : 'السعرات المستهدفة'}</div>
                              <div className="text-3xl font-bold text-health-green">{objectResult?.totalCalories} <span className="text-sm">kcal</span></div>
                            </div>
                            <Suspense fallback={<div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-sm text-slate-500">{lang === 'en' ? 'Loading chart...' : 'جارٍ تحميل الرسم...'}</div>}>
                              <ResultCharts activeCalculator="Macros" lang={lang} result={result as any} t={t} />
                            </Suspense>
                          </div>
                        ) : typeof result === 'object' && activeCalculator === 'Deficit' ? (
                          <div className="space-y-8">
                            <div>
                              {objectResult?.deficit} <span className="text-2xl">{lang === 'en' ? 'kcal' : 'سعرة'}</span>
                              {objectResult?.warning && (
                                <div className="mt-4 flex items-center justify-center gap-2 rounded-xl bg-amber-50 p-3 text-sm font-bold text-amber-700">
                                  <Info className="h-4 w-4" /> {pace >= 1000 ? t.results.aggressiveWarning : t.results.warning}
                                </div>
                              )}
                            </div>
                            <Suspense fallback={<div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-sm text-slate-500">{lang === 'en' ? 'Loading chart...' : 'جارٍ تحميل الرسم...'}</div>}>
                              <ResultCharts activeCalculator="Deficit" lang={lang} pace={pace} result={result as any} t={t} />
                            </Suspense>
                          </div>
                        ) : activeCalculator === 'BodyFat' ? (
                          <div className="space-y-2">
                            <div className="text-5xl font-bold text-slate-900">{String(result)}%</div>
                            {'category' in (healthInterpretation || {}) ? <div className={`text-lg font-bold uppercase ${statusToTextClass((healthInterpretation as any).status)}`}>{(healthInterpretation as any).category}</div> : null}
                          </div>
                        ) : activeCalculator === 'BMI' ? (
                          <div className="space-y-2">
                            <div className="text-5xl font-bold text-slate-900">{String(result)}</div>
                            {'category' in (healthInterpretation || {}) ? <div className={`text-lg font-bold uppercase ${statusToTextClass((healthInterpretation as any).status)}`}>{(healthInterpretation as any).category}</div> : null}
                          </div>
                        ) : (
                          `${String(result)}${activeCalculator === 'Water' ? (lang === 'en' ? ' ml' : ' مل') : activeCalculator === 'IdealWeight' ? (lang === 'en' ? ' kg' : ' كجم') : (lang === 'en' ? ' kcal' : ' سعرة')}`
                        )}
                        {activeCalculator === 'Protein' && (lang === 'en' ? 'g/day' : 'جم/يوم')}
                      </div>

                      {healthInterpretation?.message && <div className={`mt-3 text-sm font-bold ${statusToTextClass(healthInterpretation.status)}`}>{healthInterpretation.message}</div>}

                      <div className="mt-6 flex items-start gap-3 rounded-2xl bg-soft-blue p-4 text-left">
                        <Info className="mt-0.5 h-5 w-5 shrink-0 text-health-green" />
                        <p className="text-sm italic leading-relaxed text-slate-600">
                          <strong>{t.results.note}</strong>{' '}
                          {activeCalculator === 'BMI' ? t.results.bmiNote : activeCalculator === 'WHtR' ? t.results.whtrNote : activeCalculator === 'BMR' ? t.results.bmrNote : activeCalculator === 'TDEE' ? t.results.tdeeNote : activeCalculator === 'Macros' ? t.results.macrosNote : activeCalculator === 'Protein' ? t.results.proteinNote : activeCalculator === 'IdealWeight' ? t.results.idealWeightNote : activeCalculator === 'BodyFat' ? t.results.bodyFatNote : activeCalculator === 'Water' ? t.results.waterNote : activeCalculator === 'Deficit' ? t.results.deficitNote : t.results.mealNote}
                        </p>
                      </div>

                      {practicalGuide && (
                        <div className="mt-6 rounded-2xl border border-slate-200 bg-white/80 p-5 text-left">
                          <div className="mb-3 text-xs font-bold uppercase tracking-[0.16em] text-health-green">{practicalGuide.title}</div>
                          <div className="space-y-2">
                            {practicalGuide.items.map((item, index) => (
                              <div key={`${item}-${index}`} className="flex items-start gap-3 text-sm leading-6 text-slate-700">
                                <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-soft-blue text-xs font-black text-health-green">{index + 1}</div>
                                <p>{item}</p>
                              </div>
                            ))}
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {result !== null && activeCalculator && (
                  <div className="mt-8">
                    <div className="mb-4 flex flex-wrap gap-3">
                      <button onClick={openResultAnalysis} className="rounded-2xl bg-slate-900 px-4 py-3 text-sm font-bold text-white transition-all hover:bg-slate-800">
                        {lang === 'en' ? 'Analyze with AI' : 'حلل بالذكاء الاصطناعي'}
                      </button>
                      <Link to={`/${lang}/dashboard`} className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-bold text-slate-700 transition-all hover:border-health-green/30">
                        {lang === 'en' ? 'Open tracking dashboard' : 'افتح لوحة المتابعة'}
                      </Link>
                    </div>
                    <Suspense fallback={<div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-sm text-slate-500">{lang === 'en' ? 'Loading save and AI tools...' : 'جارٍ تحميل أدوات الحفظ والذكاء الاصطناعي...'}</div>}>
                      <ResultAssistantPanel
                        analysisPrompt={analysisPrompt}
                        assessmentSnapshot={assessmentSnapshot}
                        activeCalculator={activeCalculator}
                        healthInterpretation={healthInterpretation}
                        inputs={{weight, height, age, gender, activity, goal, bodyType, unitSystem}}
                        lang={lang}
                        result={result as any}
                        setAnalysisPrompt={setAnalysisPrompt}
                      />
                    </Suspense>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </section>

      {isCustomModalOpen && (
        <div className="fixed inset-0 z-[70] flex items-center justify-center p-4">
          <div onClick={() => setIsCustomModalOpen(false)} className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" />
          <div className="relative max-h-[calc(100vh-2rem)] w-full max-w-md overflow-y-auto rounded-3xl bg-white p-5 shadow-2xl sm:p-8">
            <h3 className="mb-6 text-2xl font-bold text-slate-900">{t.customFood.title}</h3>
            <div className="mb-8 space-y-4">
              <div>
                <label className="mb-1 block text-sm font-semibold text-slate-700">{t.customFood.nameLabel}</label>
                <input type="text" value={newFood.nameEn} onChange={(event) => setNewFood({...newFood, nameEn: event.target.value})} placeholder={t.customFood.namePlaceholder} className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green" />
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                {[
                  {key: 'calories', label: t.customFood.calsLabel},
                  {key: 'protein', label: t.customFood.proteinLabel},
                  {key: 'carbs', label: t.customFood.carbsLabel},
                  {key: 'fats', label: t.customFood.fatsLabel},
                ].map((field) => (
                  <div key={field.key}>
                    <label className="mb-1 block text-sm font-semibold text-slate-700">{field.label}</label>
                    <input {...decimalInputProps} value={newFood[field.key as keyof typeof newFood]} onChange={(event) => setNewFood({...newFood, [field.key]: normalizeNumericInput(event.target.value)})} className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green" />
                  </div>
                ))}
              </div>
            </div>
            <div className="flex flex-col gap-3 sm:flex-row sm:gap-4">
              <button onClick={() => setIsCustomModalOpen(false)} className="flex-1 rounded-xl py-3 font-bold text-slate-500 transition-all hover:bg-slate-100">{t.ux.cancel}</button>
              <button onClick={saveCustomFood} className="flex-1 rounded-xl bg-health-green py-3 font-bold text-white shadow-lg shadow-health-green/20 transition-all hover:bg-health-green-dark">{t.ux.saveFood}</button>
            </div>
          </div>
        </div>
      )}

      {isWristModalOpen && (
        <div className="fixed inset-0 z-[70] flex items-center justify-center p-4">
          <div onClick={() => setIsWristModalOpen(false)} className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" />
          <div className="relative max-h-[calc(100vh-2rem)] w-full max-w-md overflow-y-auto rounded-3xl bg-white p-5 shadow-2xl sm:p-8">
            <div className="mb-6 flex items-center justify-between">
              <h3 className="text-2xl font-bold text-slate-900">{t.somatotype.wristTest}</h3>
              <button onClick={() => setIsWristModalOpen(false)} className="rounded-full p-2 hover:bg-slate-100"><X className="h-5 w-5" /></button>
            </div>
            <div className="space-y-6">
              <div className="rounded-2xl border border-health-green/10 bg-soft-blue p-4"><h4 className="mb-2 font-bold text-health-green">{t.somatotype.ecto}</h4><p className="text-sm text-slate-600">{t.somatotype.ectoWrist}</p></div>
              <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4"><h4 className="mb-2 font-bold text-medical-blue">{t.somatotype.meso}</h4><p className="text-sm text-slate-600">{t.somatotype.mesoWrist}</p></div>
              <div className="rounded-2xl border border-orange-100 bg-orange-50 p-4"><h4 className="mb-2 font-bold text-orange-500">{t.somatotype.endo}</h4><p className="text-sm text-slate-600">{t.somatotype.endoWrist}</p></div>
            </div>
            <button onClick={() => setIsWristModalOpen(false)} className="mt-8 w-full rounded-xl bg-health-green py-4 font-bold text-white transition-all hover:bg-health-green-dark">{t.ux.cancel}</button>
          </div>
        </div>
      )}

      {isTooltipModalOpen && (
        <div className="fixed inset-0 z-[80] flex items-center justify-center p-4">
          <div onClick={() => setIsTooltipModalOpen(false)} className="absolute inset-0 bg-slate-900/40 backdrop-blur-[2px]" />
          <div className="relative max-h-[calc(100vh-2rem)] w-full max-w-sm overflow-y-auto rounded-2xl border border-slate-100 bg-white p-5 shadow-2xl sm:p-6">
            <div className="mb-4 flex items-center gap-3">
              <div className="rounded-lg bg-soft-blue p-2 text-health-green"><Info className="h-5 w-5" /></div>
              <h3 className="text-lg font-bold text-slate-900">{tooltipData.title}</h3>
            </div>
            <p className="mb-6 text-sm leading-relaxed text-slate-600">{tooltipData.text}</p>
            <button onClick={() => setIsTooltipModalOpen(false)} className="w-full rounded-xl py-3 font-bold text-health-green transition-all hover:bg-soft-blue">
              {lang === 'en' ? 'Got it' : 'فهمت'}
            </button>
          </div>
        </div>
      )}
    </>
  );
}
