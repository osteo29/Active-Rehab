import {useCallback, useEffect, useMemo, useState} from 'react';
import {checkEnvironment} from '../services/calculators';
import {foodDatabase, type FoodItem} from '../services/foodData';
import {translations, type Language} from '../services/translations';
import {buildCalculators, buildToolGroups} from '../features/tools/app/config';
import type {CalculatorType, MealItem, ToolGroup} from '../features/tools/app/types';
import {buildResultAnalysisPrompt, calculateCalculatorResult, validateCalculatorInputs} from '../logic/appCalculatorLogic';
import type {BodyType, GoalType, HealthInterpretation} from '../logic/physioNutritionLogic';
import type {HealthProfile} from '../logic/physioNutritionEngine';
import {architectNumberToInput} from './useArchitectProfile';
import {normalizeNumericInput, parseLocalizedNumber} from '../utils/numericInput';

const CUSTOM_FOODS_STORAGE_KEY = 'physiohub_custom_foods';

type AppTranslations = (typeof translations)[Language];

type CustomFoodDraft = {
  nameEn: string;
  nameAr: string;
  calories: string;
  protein: string;
  carbs: string;
  fats: string;
};

type Options = {
  architectProfile: HealthProfile;
  initialArchitectProfile: HealthProfile;
  initialCalculatorId?: CalculatorType;
  lang: Language;
  setArchitectProfile: React.Dispatch<React.SetStateAction<HealthProfile>>;
  t: AppTranslations;
};

const emptyMealItem = (): MealItem => ({id: Date.now().toString(), name: '', calories: ''});

const emptyFoodDraft = (): CustomFoodDraft => ({
  nameEn: '',
  nameAr: '',
  calories: '',
  protein: '',
  carbs: '',
  fats: '',
});

function loadCustomFoods() {
  if (typeof window === 'undefined') return [];
  const saved = localStorage.getItem(CUSTOM_FOODS_STORAGE_KEY);
  if (!saved) return [];

  try {
    const parsed = JSON.parse(saved);
    return Array.isArray(parsed) ? (parsed as FoodItem[]) : [];
  } catch {
    return [];
  }
}

function toPositiveNumber(value: string) {
  const parsed = parseLocalizedNumber(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
}

export type CalculatorWorkspaceController = ReturnType<typeof useCalculatorWorkspace>;

export function useCalculatorWorkspace({
  architectProfile,
  initialArchitectProfile,
  initialCalculatorId = null,
  lang,
  setArchitectProfile,
  t,
}: Options) {
  const [activeCalculator, setActiveCalculator] = useState<CalculatorType>('BMI');
  const [activeToolGroup, setActiveToolGroup] = useState<ToolGroup>('all');

  // Initialize from architectProfile or sensible defaults
  const [weight, setWeight] = useState(() =>
    architectProfile.weight > 0
      ? String(architectProfile.weight)
      : architectNumberToInput(initialArchitectProfile.weight),
  );
  const [height, setHeight] = useState(() =>
    architectProfile.height > 0
      ? String(architectProfile.height)
      : architectNumberToInput(initialArchitectProfile.height),
  );
  const [age, setAge] = useState(() =>
    architectProfile.age > 0
      ? String(architectProfile.age)
      : architectNumberToInput(initialArchitectProfile.age),
  );
  const [gender, setGender] = useState<'male' | 'female'>(architectProfile.gender || 'male');
  const [activity, setActivity] = useState(() => String(architectProfile.activityLevel || 1.375));
  const [waist, setWaist] = useState(() =>
    architectProfile.waist && architectProfile.waist > 0 ? String(architectProfile.waist) : '',
  );
  const [neck, setNeck] = useState(() =>
    architectProfile.neck && architectProfile.neck > 0 ? String(architectProfile.neck) : '',
  );
  const [hip, setHip] = useState('');
  const [goal, setGoal] = useState<GoalType>(() => {
    const g = String(architectProfile.goal);
    if (g === 'lose' || g === 'gain') return g as GoalType;
    return 'maintain';
  });
  const [bodyType, setBodyType] = useState<BodyType>('mesomorph');
  const [pace, setPace] = useState(500);
  const [unitSystem, setUnitSystem] = useState<'metric' | 'imperial'>('metric');
  const [knowBodyFat, setKnowBodyFat] = useState(false);
  const [bodyFatInput, setBodyFatInput] = useState('');
  const [hotClimate, setHotClimate] = useState(false);
  const [pregnancy, setPregnancy] = useState(false);

  const [mealItems, setMealItems] = useState<MealItem[]>([{id: '1', name: '', calories: ''}]);
  const [foodSearch, setFoodSearch] = useState('');
  const [foodCategory, setFoodCategory] = useState('all');
  const [customFoods, setCustomFoods] = useState<FoodItem[]>(() => loadCustomFoods());
  const [newFood, setNewFood] = useState<CustomFoodDraft>(() => emptyFoodDraft());

  const [isCustomModalOpen, setIsCustomModalOpen] = useState(false);
  const [isWristModalOpen, setIsWristModalOpen] = useState(false);
  const [isTooltipModalOpen, setIsTooltipModalOpen] = useState(false);
  const [showFoodTable, setShowFoodTable] = useState(false);
  const [tooltipData, setTooltipData] = useState({title: '', text: ''});

  const [result, setResult] = useState<unknown>(null);
  const [healthInterpretation, setHealthInterpretation] = useState<HealthInterpretation | null>(null);
  const [error, setError] = useState('');
  const [justCalculated, setJustCalculated] = useState(false);
  const [analysisPrompt, setAnalysisPrompt] = useState<string | null>(null);

  const calculators = useMemo(() => buildCalculators(t), [t]);
  const toolGroups = useMemo(() => buildToolGroups(lang), [lang]);
  const visibleCalculators =
    activeToolGroup === 'all'
      ? calculators
      : calculators.filter((calculator) => calculator.group === activeToolGroup);
  const activeCalculatorMeta = calculators.find((calculator) => calculator.id === activeCalculator);

  const filteredFoods = useMemo(() => {
    const allFoods = [...customFoods, ...foodDatabase];
    return allFoods.filter((food) => {
      const matchesSearch =
        food.name.en.toLowerCase().includes(foodSearch.toLowerCase()) ||
        food.name.ar.includes(foodSearch);
      const matchesCategory = foodCategory === 'all' || food.category === foodCategory;
      return matchesSearch && matchesCategory;
    });
  }, [customFoods, foodCategory, foodSearch]);

  useEffect(() => {
    checkEnvironment();
  }, []);

  useEffect(() => {
    try {
      localStorage.setItem(CUSTOM_FOODS_STORAGE_KEY, JSON.stringify(customFoods));
    } catch {
      // ignore
    }
  }, [customFoods]);

  // One-way sync from architectProfile if calculator fields are currently empty
  useEffect(() => {
    if (architectProfile.weight > 0 && !weight) {
      setWeight(String(architectProfile.weight));
    }
    if (architectProfile.height > 0 && !height) {
      setHeight(String(architectProfile.height));
    }
    if (architectProfile.age > 0 && !age) {
      setAge(String(architectProfile.age));
    }
    if (architectProfile.waist && architectProfile.waist > 0 && !waist) {
      setWaist(String(architectProfile.waist));
    }
    if (architectProfile.neck && architectProfile.neck > 0 && !neck) {
      setNeck(String(architectProfile.neck));
    }
  }, [architectProfile.weight, architectProfile.height, architectProfile.age, architectProfile.waist, architectProfile.neck]);

  // Real-time automatic calculation when inputs are valid!
  useEffect(() => {
    if (!activeCalculator) return;
    if (activeCalculator === 'Meal') {
      const total = mealItems.reduce((acc, item) => acc + (toPositiveNumber(item.calories) || 0), 0);
      if (total > 0) {
        setResult(total);
        setError('');
      }
      return;
    }

    const values = {
      activeCalculator,
      weight,
      height,
      age,
      gender,
      activity,
      waist,
      neck,
      hip,
      goal,
      bodyType,
      pace,
      unitSystem,
      knowBodyFat,
      bodyFatInput,
      hotClimate,
      pregnancy,
      mealItems,
    };

    const validationError = validateCalculatorInputs({values, lang, t});
    if (!validationError) {
      try {
        const next = calculateCalculatorResult({values, lang, t});
        setError('');
        setResult(next.result);
        setHealthInterpretation(next.healthInterpretation);
      } catch {
        // ignore incomplete intermediate state
      }
    }
  }, [
    activeCalculator,
    weight,
    height,
    age,
    gender,
    activity,
    waist,
    neck,
    hip,
    goal,
    bodyType,
    pace,
    unitSystem,
    knowBodyFat,
    bodyFatInput,
    hotClimate,
    pregnancy,
    mealItems,
    lang,
    t,
  ]);

  // Haptic & audio feedback on explicit calculation
  useEffect(() => {
    if (!justCalculated) return;

    try {
      if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
        (navigator as Navigator & {vibrate?: (pattern: number) => void}).vibrate?.(15);
      }

      const AudioCtx =
        window.AudioContext ||
        (window as typeof window & {webkitAudioContext?: typeof AudioContext}).webkitAudioContext;
      if (AudioCtx) {
        const ctx = new AudioCtx();
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.value = 880;
        gain.gain.value = 0.0001;
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        gain.gain.exponentialRampToValueAtTime(0.05, ctx.currentTime + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + 0.12);
        osc.stop(ctx.currentTime + 0.13);
        setTimeout(() => ctx.close(), 250);
      }
    } catch {
      // Ignore
    }

    const timer = setTimeout(() => setJustCalculated(false), 0);
    return () => clearTimeout(timer);
  }, [justCalculated]);

  useEffect(() => {
    if (!initialCalculatorId) return;

    const nextCalculator = calculators.find((item) => item.id === initialCalculatorId);
    if (!nextCalculator) return;

    setActiveCalculator(nextCalculator.id);
    setActiveToolGroup(nextCalculator.group);
  }, [calculators, initialCalculatorId]);

  // Does NOT wipe user's basic physical stats so switching tools feels seamless
  function resetForm() {
    setHip('');
    setPace(500);
    setKnowBodyFat(false);
    setBodyFatInput('');
    setHotClimate(false);
    setPregnancy(false);
    setMealItems([{id: '1', name: '', calories: ''}]);
    setError('');
    setAnalysisPrompt(null);
  }

  function clearAllFields() {
    setWeight('');
    setHeight('');
    setAge('');
    setWaist('');
    setNeck('');
    setHip('');
    setMealItems([{id: '1', name: '', calories: ''}]);
    setResult(null);
    setHealthInterpretation(null);
    setError('');
    setAnalysisPrompt(null);
  }

  function handleCalculate() {
    const values = {
      activeCalculator,
      weight,
      height,
      age,
      gender,
      activity,
      waist,
      neck,
      hip,
      goal,
      bodyType,
      pace,
      unitSystem,
      knowBodyFat,
      bodyFatInput,
      hotClimate,
      pregnancy,
      mealItems,
    };

    const validationError = validateCalculatorInputs({values, lang, t});
    if (validationError) {
      setError(validationError);
      return;
    }

    const next = calculateCalculatorResult({values, lang, t});
    setError('');
    setResult(next.result);
    setHealthInterpretation(next.healthInterpretation);
    setJustCalculated(true);

    // Sync non-empty values back to architectProfile safely
    const numWeight = toPositiveNumber(weight);
    const numHeight = toPositiveNumber(height);
    const numAge = toPositiveNumber(age);
    const numWaist = toPositiveNumber(waist);
    const numNeck = toPositiveNumber(neck);
    const numActivity = toPositiveNumber(activity);

    setArchitectProfile((prev) => ({
      ...prev,
      weight: numWeight > 0 ? numWeight : prev.weight,
      height: numHeight > 0 ? numHeight : prev.height,
      age: numAge > 0 ? numAge : prev.age,
      waist: numWaist > 0 ? numWaist : prev.waist,
      neck: numNeck > 0 ? numNeck : prev.neck,
      activityLevel: numActivity > 0 ? numActivity : prev.activityLevel,
      gender,
    }));
  }

  function showTooltip(title: string, text: string) {
    setTooltipData({title, text});
    setIsTooltipModalOpen(true);
  }

  function addMealItem() {
    setMealItems((previous) => [...previous, emptyMealItem()]);
  }

  function clearAllMealItems() {
    setMealItems([emptyMealItem()]);
    setResult(null);
    setHealthInterpretation(null);
  }

  function removeMealItem(id: string) {
    setMealItems((previous) => (previous.length > 1 ? previous.filter((item) => item.id !== id) : previous));
  }

  function updateMealItem(id: string, field: 'name' | 'calories', value: string) {
    setMealItems((previous) =>
      previous.map((item) =>
        item.id === id
          ? {
              ...item,
              [field]: field === 'calories' ? normalizeNumericInput(value) : value,
            }
          : item,
      ),
    );
  }

  function addFoodToMeal(food: FoodItem) {
    const newItem: MealItem = {
      id: Date.now().toString(),
      name: food.name[lang],
      calories: food.calories.toString(),
    };

    setMealItems((previous) =>
      previous.length === 1 && !previous[0].name && !previous[0].calories
        ? [newItem]
        : [...previous, newItem],
    );

    document.getElementById('calculators')?.scrollIntoView({behavior: 'smooth'});
    setActiveCalculator('Meal');
  }

  function saveCustomFood() {
    if (!newFood.nameEn || !newFood.calories) {
      setError(lang === 'en' ? 'Please fill in required fields' : 'يرجى ملء الحقول المطلوبة');
      return;
    }

    const food: FoodItem = {
      id: `custom-${Date.now()}`,
      name: {
        en: newFood.nameEn,
        ar: newFood.nameAr || newFood.nameEn,
      },
      category: 'cooked',
      calories: parseLocalizedNumber(newFood.calories),
      protein: parseLocalizedNumber(newFood.protein) || 0,
      carbs: parseLocalizedNumber(newFood.carbs) || 0,
      fats: parseLocalizedNumber(newFood.fats) || 0,
    };

    setCustomFoods((previous) => [food, ...previous]);
    setIsCustomModalOpen(false);
    setNewFood(emptyFoodDraft());
    setError('');
  }

  function openResultAnalysis() {
    setAnalysisPrompt(buildResultAnalysisPrompt(activeCalculator, lang));
    document.getElementById('result-ai-panel')?.scrollIntoView({
      behavior: 'smooth',
      block: 'start',
    });
  }

  return {
    activeCalculator,
    activeCalculatorMeta,
    activeToolGroup,
    activity,
    age,
    analysisPrompt,
    bodyFatInput,
    bodyType,
    calculators,
    clearAllFields,
    clearAllMealItems,
    customFoods,
    error,
    filteredFoods,
    foodCategory,
    foodSearch,
    gender,
    goal,
    handleCalculate,
    height,
    hip,
    hotClimate,
    isCustomModalOpen,
    isTooltipModalOpen,
    isWristModalOpen,
    justCalculated,
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
    healthInterpretation,
    saveCustomFood,
    setActiveCalculator,
    setActiveToolGroup,
    setActivity,
    setAge,
    setAnalysisPrompt,
    setBodyFatInput,
    setBodyType,
    setFoodCategory,
    setFoodSearch,
    setGender,
    setGoal,
    setHeight,
    setHip,
    setHotClimate,
    setIsCustomModalOpen,
    setIsTooltipModalOpen,
    setIsWristModalOpen,
    setKnowBodyFat,
    setMealItems,
    setNeck,
    setNewFood,
    setPace,
    setPregnancy,
    setShowFoodTable,
    setUnitSystem,
    setWaist,
    setWeight,
    showFoodTable,
    showTooltip,
    toolGroups,
    tooltipData,
    unitSystem,
    updateMealItem,
    visibleCalculators,
    waist,
    weight,
    addFoodToMeal,
    addMealItem,
  };
}
