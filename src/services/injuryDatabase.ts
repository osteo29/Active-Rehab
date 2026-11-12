import {generatedInjuryProtocols} from './injuryProtocolCatalog';
import {applyInjuryExerciseProtocolOverrides} from './injuryExerciseProtocolMerge';

export type InjuryCategory =
  | 'Ligament'
  | 'Tendon'
  | 'Muscle'
  | 'Bone'
  | 'Joint'
  | 'Spine'
  | 'Post-surgery'
  | 'Overuse'
  | 'Sports'
  | 'Pediatric'
  | 'Geriatric';
export type BodyRegion =
  | 'Knee'
  | 'Ankle'
  | 'Shoulder'
  | 'Hip'
  | 'Back'
  | 'Foot'
  | 'Whole body'
  | 'Elbow'
  | 'Wrist'
  | 'Neck'
  | 'Chest'
  | 'Thigh'
  | 'Arm'
  | 'Pelvis'
  | 'Spine'
  | 'Hand'
  | 'Jaw';
export type ActivityProfile = 'general' | 'athlete' | 'older_adult' | 'post_op';
export type RecoveryGoal = 'calm' | 'mobility' | 'strength' | 'return';
export type DietStyle = 'omnivore' | 'vegetarian';
export type RecoveryWindow = 'under_48h' | 'days_3_14' | 'weeks_2_6' | 'over_6_weeks';

export interface SupplementProtocol {
  name: string;
  dose: string;
  reason: string;
  timing?: string;
  caution?: string;
}

export interface MealExamples {
  breakfast: string;
  lunch: string;
  dinner: string;
  snack?: string;
  shoppingList: string[];
}

export interface ExercisePlan {
  label: string;
  sets?: string;
  reps?: string;
  rest?: string;
  equipment?: string;
  alternatives?: string[];
  cues?: string[];
  exerciseId?: string;
}

export interface InjuryPageContentData {
  intro?: string;
  symptoms?: string[];
  faq?: Array<{q: string; a: string}>;
  rehabNotes?: string[];
  nutritionNotes?: string[];
}

export interface InjuryPhase {
  id: string;
  label: string;
  duration: string;
  window: RecoveryWindow;
  goals: string[];
  nutritionFocus: string[];
  recommendedFoods: string[];
  avoidFoods: string[];
  supplements: SupplementProtocol[];
  exercises: string[];
  prohibitedMovements: string[];
  exercisePlans?: ExercisePlan[];
  // Phase focus/progression (editable from /admin/injuries)
  focus?: string;
  progressionMarkers?: string[];
  cautions?: string[];
  nutritionNotes?: string[];
  meals: MealExamples;
  timing?: Partial<Record<'collagen' | 'protein' | 'hydration' | 'carbs', string>>;
  proteinPerKg?: {min: number; max: number};
  hydrationMlPerKg?: number;
  omega3Grams?: number;
  creatineGrams?: number;
  collagenPerKg?: {min: number; max: number};
  vitaminCMg?: number;
  calciumMg?: number;
}

export interface InjuryProtocol {
  id: string;
  name: string;
  category: InjuryCategory;
  bodyRegion: BodyRegion;
  commonIn: string[];
  overview: string;
  rehabSummary: string;
  redFlags: string[];
  relatedCalculators: string[];
  safetyNotes: {medications: string[]; supplements: string[]};
  phases: InjuryPhase[];
  pageContent?: InjuryPageContentData;
  contraindications?: {medications: string[]; supplements: string[]};
  stages?: Record<
    string,
    {
      phase: string;
      focus: string;
      nutrients: {name: string; dosage: string; purpose: string; evidence: string}[];
      foods: string[];
    }
  >;
}

export interface RecoveryPlanInput {
  weightKg: number;
  phase: InjuryPhase;
  profile: ActivityProfile;
  goal: RecoveryGoal;
  dietStyle: DietStyle;
}

export interface RecoveryPlanOutput {
  proteinTotalGrams: number;
  proteinRange: {min: number; max: number};
  proteinDistribution: {breakfast: number; lunch: number; dinner: number; snack: number};
  hydrationTargetMl: number;
  collagenDoseGrams?: number;
  creatineGrams?: number;
  omega3Grams?: number;
  vitaminCMg?: number;
  calciumMg?: number;
  timingTips: string[];
  meals: {breakfast: string; lunch: string; dinner: string; snack?: string};
}

const injuryProtocols: InjuryProtocol[] = [
  {
    id: 'ankle_sprain',
    name: 'Ankle Sprain',
    category: 'Ligament',
    bodyRegion: 'Ankle',
    commonIn: ['Field sports', 'Running', 'Daily activity'],
    overview: 'Ankle sprains need swelling control first, then progressive loading, balance work, and ligament-friendly fueling.',
    rehabSummary: 'Protect early, restore motion next, then rebuild confidence for cutting and hopping.',
    redFlags: ['Unable to bear weight', 'Major deformity', 'Rapid swelling with intense pain'],
    relatedCalculators: ['Protein intake', 'Water intake'],
    safetyNotes: {
      medications: ['Review fish oil or curcumin with blood thinners or before procedures.'],
      supplements: ['Very high antioxidant dosing is not always better in the first days.'],
    },
    phases: [
      {
        id: 'acute',
        label: 'Acute',
        duration: '0-5 days',
        window: 'under_48h',
        goals: ['Reduce swelling', 'Protect ligament', 'Maintain protein intake'],
        nutritionFocus: ['Protein adequacy', 'Omega-3', 'Vitamin C'],
        recommendedFoods: ['Greek yogurt', 'Salmon', 'Kiwi', 'Berries'],
        avoidFoods: ['Alcohol', 'Very salty fast food', 'Skipping meals'],
        supplements: [
          {name: 'Omega-3', dose: '2 g/day', reason: 'Supports inflammation control'},
          {name: 'Vitamin C', dose: '500 mg/day', reason: 'Supports collagen building'},
        ],
        exercises: ['Protected range of motion', 'Pain-limited calf pumping'],
        prohibitedMovements: ['Aggressive hopping', 'Fast pivots'],
        meals: {
          breakfast: 'Greek yogurt bowl with berries and oats',
          lunch: 'Salmon, rice, and peppers',
          dinner: 'Chicken soup with potatoes and spinach',
          snack: 'Orange with kefir',
          shoppingList: ['Greek yogurt', 'Salmon', 'Oranges', 'Oats', 'Spinach', 'Rice'],
        },
        timing: {
          protein: 'Split protein across 3-4 meals instead of one heavy dinner.',
          hydration: 'Sip fluids steadily during the day.',
        },
        proteinPerKg: {min: 1.6, max: 2},
        hydrationMlPerKg: 35,
        omega3Grams: 2,
        vitaminCMg: 500,
      },
      {
        id: 'repair',
        label: 'Repair',
        duration: '5-21 days',
        window: 'days_3_14',
        goals: ['Support ligament repair', 'Restore range of motion', 'Start loading on purpose'],
        nutritionFocus: ['Collagen plus vitamin C before rehab', 'Consistent protein'],
        recommendedFoods: ['Eggs', 'Citrus fruit', 'Lean beef', 'Lentils'],
        avoidFoods: ['Skipping rehab fuel', 'Long gaps without protein'],
        supplements: [
          {name: 'Collagen peptides', dose: '10-15 g', reason: 'May support connective tissue loading', timing: '30-60 min before rehab'},
          {name: 'Vitamin C', dose: '250-500 mg', reason: 'Pairs with collagen support', timing: 'With collagen before rehab'},
        ],
        exercises: ['Progressive calf raises', 'Balance work'],
        prohibitedMovements: ['Painful high-speed change of direction'],
        meals: {
          breakfast: 'Eggs, sourdough, and fruit',
          lunch: 'Lean beef, potatoes, and salad',
          dinner: 'Lentil bowl with vegetables',
          snack: 'Collagen shake and orange before rehab',
          shoppingList: ['Eggs', 'Lean beef', 'Lentils', 'Oranges', 'Potatoes', 'Bell peppers'],
        },
        timing: {
          collagen: 'Take collagen 30-60 minutes before loading or rehab.',
        },
        proteinPerKg: {min: 1.8, max: 2.1},
        hydrationMlPerKg: 35,
        collagenPerKg: {min: 0.12, max: 0.18},
        vitaminCMg: 500,
      },
      {
        id: 'return',
        label: 'Return to sport',
        duration: '3-6 weeks',
        window: 'weeks_2_6',
        goals: ['Regain stiffness tolerance', 'Improve confidence', 'Support repeat effort'],
        nutritionFocus: ['High-quality protein', 'Creatine', 'Smart carb timing'],
        recommendedFoods: ['Milk or soy milk', 'Chicken wraps', 'Rice', 'Bananas'],
        avoidFoods: ['Under-eating on training days'],
        supplements: [{name: 'Creatine monohydrate', dose: '5 g/day', reason: 'Supports strength and lean mass'}],
        exercises: ['Hops and landings', 'Single-leg strength', 'Return-to-run progression'],
        prohibitedMovements: ['Full sport before passing strength and hop tests'],
        meals: {
          breakfast: 'Oats, milk, banana, and protein',
          lunch: 'Chicken wrap with rice salad',
          dinner: 'Rice bowl with tofu or turkey',
          snack: 'Banana and yogurt before field work',
          shoppingList: ['Milk or soy milk', 'Bananas', 'Chicken or tofu', 'Rice', 'Yogurt'],
        },
        timing: {carbs: 'Add more carbs around training and return-to-run sessions.'},
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 40,
        creatineGrams: 5,
      },
    ],
  },
  {
    id: 'acl_injury',
    name: 'ACL Injury',
    category: 'Ligament',
    bodyRegion: 'Knee',
    commonIn: ['Football', 'Basketball', 'Pivoting sports'],
    overview: 'ACL rehab needs muscle retention, enough energy, collagen support around loading, and patience across a long return timeline.',
    rehabSummary: 'The knee needs swelling control early, quadriceps retention always, and structured food support through prehab, surgery, and rehab.',
    redFlags: ['Locked knee', 'Major instability', 'Post-op calf swelling or chest symptoms'],
    relatedCalculators: ['Protein intake', 'Water intake', 'Macro calculator'],
    safetyNotes: {
      medications: ['Review fish oil, curcumin, and high-dose vitamin E around surgery or with anticoagulants.'],
      supplements: ['Supplements cannot replace surgical or physiotherapy planning.'],
    },
    phases: [
      {
        id: 'prehab',
        label: 'Prehab / pre-surgery',
        duration: 'Before surgery or early structured rehab',
        window: 'days_3_14',
        goals: ['Reduce atrophy', 'Calm swelling', 'Prepare for surgery or rehab'],
        nutritionFocus: ['Higher protein', 'Creatine', 'Micronutrient sufficiency'],
        recommendedFoods: ['Whey or soy protein', 'Eggs', 'Rice', 'Yogurt'],
        avoidFoods: ['Crash dieting', 'Under-eating because activity dropped'],
        supplements: [
          {name: 'Creatine monohydrate', dose: '5 g/day', reason: 'Helps preserve lean mass'},
          {name: 'Protein powder if needed', dose: '20-30 g', reason: 'Convenient protein coverage'},
        ],
        exercises: ['Quad setting', 'Range of motion work', 'Prehab strength if cleared'],
        prohibitedMovements: ['Pivoting or cutting on an unstable knee'],
        meals: {
          breakfast: 'Eggs, toast, and fruit',
          lunch: 'Chicken rice bowl with yogurt',
          dinner: 'Beans or turkey with potatoes and vegetables',
          snack: 'Protein shake after rehab',
          shoppingList: ['Eggs', 'Chicken', 'Rice', 'Yogurt', 'Potatoes', 'Protein powder'],
        },
        timing: {protein: 'Get a protein feeding within 1-2 hours after rehab.'},
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 35,
        creatineGrams: 5,
      },
      {
        id: 'postop_acute',
        label: 'Post-op acute',
        duration: '0-14 days after surgery',
        window: 'under_48h',
        goals: ['Support wound healing', 'Control appetite drop', 'Protect lean mass'],
        nutritionFocus: ['Protein at every meal', 'Vitamin C', 'Hydration'],
        recommendedFoods: ['Soup with chicken', 'Greek yogurt', 'Cottage cheese', 'Citrus fruit'],
        avoidFoods: ['Alcohol', 'Smoking', 'Low-protein snack-only eating'],
        supplements: [
          {name: 'Collagen peptides', dose: '15 g/day', reason: 'May support connective tissue recovery'},
          {name: 'Vitamin C', dose: '500 mg/day', reason: 'Supports tissue healing'},
        ],
        exercises: ['Ankle pumps', 'Quad activation', 'Early extension work as directed'],
        prohibitedMovements: ['Unsanctioned loaded knee flexion'],
        meals: {
          breakfast: 'Overnight oats with yogurt and berries',
          lunch: 'Chicken soup with rice and carrots',
          dinner: 'White fish, mashed potatoes, and zucchini',
          snack: 'Cottage cheese and kiwi',
          shoppingList: ['Greek yogurt', 'Chicken', 'Rice', 'Kiwi', 'Fish', 'Oats'],
        },
        timing: {hydration: 'Keep fluids up if pain meds lower appetite.'},
        proteinPerKg: {min: 2, max: 2.3},
        hydrationMlPerKg: 35,
        collagenPerKg: {min: 0.12, max: 0.18},
        vitaminCMg: 500,
      },
      {
        id: 'rehab',
        label: 'Strength and return phase',
        duration: '2 weeks to 9+ months',
        window: 'over_6_weeks',
        goals: ['Regain quadriceps size', 'Support training output', 'Return to sport safely'],
        nutritionFocus: ['High protein', 'Creatine', 'Carbs around rehab', 'Collagen before tendon-heavy sessions'],
        recommendedFoods: ['Milk', 'Rice', 'Lean meat', 'Beans', 'Fruit'],
        avoidFoods: ['Long energy deficits during hard rehab blocks'],
        supplements: [
          {name: 'Creatine monohydrate', dose: '5 g/day', reason: 'Supports rehab performance and strength'},
          {name: 'Collagen peptides', dose: '10-15 g', reason: 'Useful before tendon or hopping sessions', timing: '30-60 min pre-rehab'},
        ],
        exercises: ['Squat progression', 'Split squats', 'Running and hop progressions'],
        prohibitedMovements: ['Rushing back before strength benchmarks'],
        meals: {
          breakfast: 'Protein oats with banana',
          lunch: 'Turkey or tofu rice bowl',
          dinner: 'Salmon with potatoes and greens',
          snack: 'Collagen drink plus orange before rehab',
          shoppingList: ['Oats', 'Bananas', 'Turkey or tofu', 'Rice', 'Salmon', 'Oranges'],
        },
        timing: {
          collagen: 'Use before plyometric or tendon-loading sessions if part of plan.',
          carbs: 'Place more carbs around long rehab or field sessions.',
        },
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 40,
        collagenPerKg: {min: 0.12, max: 0.18},
        creatineGrams: 5,
      },
    ],
  },
  {
    id: 'rotator_cuff',
    name: 'Rotator Cuff Injury',
    category: 'Tendon',
    bodyRegion: 'Shoulder',
    commonIn: ['Overhead sports', 'Gym training', 'Manual work'],
    overview: 'Shoulder tendon problems usually improve with graded loading, protein adequacy, and collagen timed around rehab.',
    rehabSummary: 'The cuff dislikes long rest and reckless overhead loading. Nutrition should support repeated rehab exposure and pain-limited progression.',
    redFlags: ['Sudden inability to lift the arm', 'Night pain with major weakness', 'Neurological symptoms'],
    relatedCalculators: ['Protein intake', 'Macro calculator'],
    safetyNotes: {
      medications: ['Bleeding risk matters if combining curcumin or fish oil with certain drugs.'],
      supplements: ['Collagen does not replace progressive shoulder loading.'],
    },
    phases: [
      {
        id: 'acute',
        label: 'Pain-dominant phase',
        duration: '0-2 weeks',
        window: 'under_48h',
        goals: ['Reduce irritability', 'Keep protein intake stable', 'Protect sleep quality'],
        nutritionFocus: ['Omega-3', 'Vitamin C', 'Balanced meals during reduced activity'],
        recommendedFoods: ['Fatty fish', 'Citrus fruit', 'Eggs', 'Olive oil'],
        avoidFoods: ['Heavy alcohol use', 'Meal skipping'],
        supplements: [{name: 'Omega-3', dose: '2 g/day', reason: 'Supports overall anti-inflammatory intake'}],
        exercises: ['Pain-limited isometrics', 'Scapular work', 'Gentle range of motion'],
        prohibitedMovements: ['Repeated painful overhead pressing'],
        meals: {
          breakfast: 'Eggs with avocado and toast',
          lunch: 'Tuna pasta salad',
          dinner: 'Salmon with couscous and greens',
          snack: 'Cottage cheese and fruit',
          shoppingList: ['Eggs', 'Avocado', 'Tuna', 'Salmon', 'Cottage cheese', 'Oranges'],
        },
        proteinPerKg: {min: 1.6, max: 2},
        hydrationMlPerKg: 35,
        omega3Grams: 2,
        vitaminCMg: 500,
      },
      {
        id: 'rebuild',
        label: 'Tendon rebuilding',
        duration: '2-10 weeks',
        window: 'weeks_2_6',
        goals: ['Support tendon loading', 'Improve cuff strength', 'Restore overhead confidence'],
        nutritionFocus: ['Collagen before rehab', 'High-quality protein', 'Carbs around harder sessions'],
        recommendedFoods: ['Greek yogurt', 'Chicken', 'Citrus fruit', 'Rice', 'Kiwi'],
        avoidFoods: ['Low-energy dieting during hard rehab'],
        supplements: [
          {name: 'Collagen peptides', dose: '10-15 g', reason: 'May support tendon rehab', timing: '30-60 min before loading'},
          {name: 'Creatine monohydrate', dose: '5 g/day', reason: 'May support strength progression'},
        ],
        exercises: ['Rotator cuff loading', 'Landmine press progression', 'Scapular strength work'],
        prohibitedMovements: ['Fast high-volume overhead work before tolerance is built'],
        meals: {
          breakfast: 'Greek yogurt with oats and kiwi',
          lunch: 'Chicken rice bowl',
          dinner: 'Bean chili with potatoes',
          snack: 'Collagen plus orange before rehab',
          shoppingList: ['Greek yogurt', 'Oats', 'Kiwi', 'Chicken', 'Rice', 'Beans'],
        },
        timing: {
          collagen: 'Use before structured cuff loading sessions.',
          protein: 'Aim for a meaningful protein dose after rehab too.',
        },
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 35,
        creatineGrams: 5,
        collagenPerKg: {min: 0.12, max: 0.18},
        vitaminCMg: 500,
      },
    ],
  },
  {
    id: 'hamstring_strain',
    name: 'Hamstring Strain',
    category: 'Muscle',
    bodyRegion: 'Hip',
    commonIn: ['Sprinting', 'Football', 'Track'],
    overview: 'Hamstring strains demand high-quality protein, enough energy, and progressive loading rather than panic rest.',
    rehabSummary: 'Muscle injuries need tissue support early, then increasingly specific loading and sprint prep later.',
    redFlags: ['Large bruising with severe weakness', 'Suspected tendon avulsion', 'Major power loss'],
    relatedCalculators: ['Protein intake', 'Macro calculator'],
    safetyNotes: {
      medications: ['Curcumin and omega-3 need medication review in sensitive cases.'],
      supplements: ['High-dose antioxidants are not a substitute for proper rehab progression.'],
    },
    phases: [
      {
        id: 'acute',
        label: 'Acute',
        duration: '0-5 days',
        window: 'under_48h',
        goals: ['Limit secondary muscle damage', 'Protect appetite', 'Start gentle pain-limited movement'],
        nutritionFocus: ['Higher protein', 'Vitamin C', 'Omega-3', 'No alcohol'],
        recommendedFoods: ['Protein powder', 'Eggs', 'Berries', 'Fish', 'Potatoes'],
        avoidFoods: ['Alcohol', 'Long fasting windows'],
        supplements: [
          {name: 'Protein shake if needed', dose: '25-30 g', reason: 'Makes protein coverage easier'},
          {name: 'Omega-3', dose: '2 g/day', reason: 'Supports anti-inflammatory intake'},
        ],
        exercises: ['Pain-limited isometrics', 'Walking if tolerated', 'Gentle range work'],
        prohibitedMovements: ['Max sprinting', 'Aggressive stretching into pain'],
        meals: {
          breakfast: 'Protein oats with berries',
          lunch: 'Chicken, potatoes, and salad',
          dinner: 'Fish with rice and vegetables',
          snack: 'Protein shake and fruit',
          shoppingList: ['Protein powder', 'Eggs', 'Berries', 'Chicken', 'Fish', 'Potatoes'],
        },
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 35,
        omega3Grams: 2,
        vitaminCMg: 500,
      },
      {
        id: 'reload',
        label: 'Repair and reload',
        duration: '5-21 days',
        window: 'days_3_14',
        goals: ['Support muscle repair', 'Restore length under load', 'Prepare for speed work'],
        nutritionFocus: ['Protein at each meal', 'Collagen before rehab', 'Creatine'],
        recommendedFoods: ['Lean beef', 'Citrus fruit', 'Greek yogurt', 'Rice', 'Beans'],
        avoidFoods: ['Starting hard running while under-eating'],
        supplements: [
          {name: 'Collagen peptides', dose: '10-15 g', reason: 'Useful before rehab sessions', timing: '30-60 min pre-rehab'},
          {name: 'Creatine monohydrate', dose: '5 g/day', reason: 'Supports power and lean mass'},
        ],
        exercises: ['Eccentric hamstring work', 'Bridge progression', 'Tempo running later'],
        prohibitedMovements: ['Returning to full sprinting before eccentric tolerance'],
        meals: {
          breakfast: 'Greek yogurt, granola, and kiwi',
          lunch: 'Lean beef and rice bowl',
          dinner: 'Bean pasta with turkey or tofu',
          snack: 'Collagen drink and orange before rehab',
          shoppingList: ['Greek yogurt', 'Kiwi', 'Lean beef', 'Rice', 'Turkey or tofu', 'Oranges'],
        },
        timing: {collagen: 'Best used before hamstring loading or sprint prep sessions.'},
        proteinPerKg: {min: 2, max: 2.3},
        hydrationMlPerKg: 40,
        collagenPerKg: {min: 0.12, max: 0.2},
        creatineGrams: 5,
        vitaminCMg: 500,
      },
    ],
  },
  {
    id: 'stress_fracture',
    name: 'Stress Fracture',
    category: 'Bone',
    bodyRegion: 'Foot',
    commonIn: ['Running', 'Dance', 'Rapid load spikes'],
    overview: 'Bone stress injuries need enough energy, enough calcium and vitamin D, and a serious review of training load.',
    rehabSummary: 'This is a bone-healing problem first, not just a pain problem. Low energy availability is often part of the story.',
    redFlags: ['Night pain', 'Pain worsening with normal walking', 'Repeated stress injuries'],
    relatedCalculators: ['Protein intake', 'Water intake', 'Macro calculator'],
    safetyNotes: {
      medications: ['Calcium can affect absorption timing of some medications.'],
      supplements: ['Check vitamin D dosing against labs when possible.'],
    },
    phases: [
      {
        id: 'healing',
        label: 'Bone healing',
        duration: '0-6 weeks',
        window: 'days_3_14',
        goals: ['Support bone remodeling', 'Avoid low energy availability', 'Protect tissue'],
        nutritionFocus: ['Protein', 'Calcium', 'Vitamin D', 'Overall energy intake'],
        recommendedFoods: ['Milk or fortified soy milk', 'Yogurt', 'Eggs', 'Beans', 'Leafy greens'],
        avoidFoods: ['Chronic under-eating', 'Very low-calorie cuts'],
        supplements: [
          {name: 'Calcium', dose: '1000-1200 mg/day', reason: 'Supports bone health'},
          {name: 'Vitamin D', dose: '1000-2000 IU/day', reason: 'Supports calcium use and bone health'},
        ],
        exercises: ['Protected cross-training if cleared', 'Upper-body or non-impact work'],
        prohibitedMovements: ['Running through pain', 'Impact work too soon'],
        meals: {
          breakfast: 'Fortified oats with milk and fruit',
          lunch: 'Beans and rice with yogurt',
          dinner: 'Salmon or tofu with potatoes and kale',
          snack: 'Cheese and fruit',
          shoppingList: ['Milk or soy milk', 'Yogurt', 'Beans', 'Potatoes', 'Kale', 'Salmon or tofu'],
        },
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 35,
        calciumMg: 1200,
        vitaminCMg: 500,
      },
      {
        id: 'reload',
        label: 'Reload',
        duration: '6+ weeks',
        window: 'over_6_weeks',
        goals: ['Support graded return to impact', 'Protect muscle mass', 'Fuel rising training volume'],
        nutritionFocus: ['Protein', 'Calcium continuity', 'Carbs around loading'],
        recommendedFoods: ['Rice', 'Dairy or fortified alternatives', 'Eggs', 'Fruit'],
        avoidFoods: ['Returning to impact while still low-energy'],
        supplements: [{name: 'Creatine monohydrate', dose: '3-5 g/day', reason: 'May support training quality once strength work increases'}],
        exercises: ['Strength work', 'Plyometric reintroduction', 'Return-to-run progression'],
        prohibitedMovements: ['Impact progression without symptom monitoring'],
        meals: {
          breakfast: 'Eggs, toast, and yogurt',
          lunch: 'Chicken and rice bowl',
          dinner: 'Tofu curry with potatoes',
          snack: 'Milk and banana',
          shoppingList: ['Eggs', 'Yogurt', 'Chicken', 'Rice', 'Tofu', 'Bananas'],
        },
        proteinPerKg: {min: 1.8, max: 2.2},
        hydrationMlPerKg: 40,
        calciumMg: 1200,
        creatineGrams: 5,
      },
    ],
  },
  ...generatedInjuryProtocols,
];

function buildLegacyStages(phases: InjuryPhase[]) {
  const keys = ['week1-2', 'week3-6', 'week7+'];
  return Object.fromEntries(
    phases.slice(0, 3).map((phase, index) => [
      keys[index] || `phase-${index + 1}`,
      {
        phase: phase.label,
        focus: phase.goals.join(' • '),
        nutrients: phase.supplements.map((item) => ({
          name: item.name,
          dosage: item.dose,
          purpose: item.reason,
          evidence: 'Practice-based',
        })),
        foods: phase.recommendedFoods,
      },
    ]),
  );
}

const mergedInjuryProtocols = applyInjuryExerciseProtocolOverrides(injuryProtocols);

export const injuryDatabase: Record<string, InjuryProtocol> = Object.fromEntries(
  mergedInjuryProtocols.map((injury) => [
    injury.id,
    {
      ...injury,
      contraindications: injury.safetyNotes,
      stages: buildLegacyStages(injury.phases),
    },
  ]),
);

export const getAllInjuries = () => mergedInjuryProtocols;
export const getAllCategories = (): InjuryCategory[] => [...new Set(mergedInjuryProtocols.map((injury) => injury.category))] as InjuryCategory[];
export const getAllBodyRegions = (): BodyRegion[] => [...new Set(mergedInjuryProtocols.map((injury) => injury.bodyRegion))] as BodyRegion[];
export const getInjurySlug = (injury: InjuryProtocol) => injury.id.replace(/_/g, '-');
export const getInjuryPath = (injury: InjuryProtocol, lang?: string) => {
  const slug = getInjurySlug(injury);
  return lang ? `/${lang}/injuries/${slug}` : `/injuries/${slug}`;
};
export const getInjuryById = (id: string) => injuryDatabase[id];
export const getInjuryBySlug = (slug: string) =>
  mergedInjuryProtocols.find((injury) => getInjurySlug(injury) === slug);
export const getSuggestedPhaseForWindow = (injury: InjuryProtocol, window: RecoveryWindow) =>
  injury.phases.find((phase) => phase.window === window) || injury.phases[0];

export function generateRecoveryPlan({
  weightKg,
  phase,
  profile,
  goal,
  dietStyle,
}: RecoveryPlanInput): RecoveryPlanOutput | null {
  if (!Number.isFinite(weightKg) || weightKg <= 0) return null;

  const baseMin = phase.proteinPerKg?.min ?? 1.6;
  const baseMax = phase.proteinPerKg?.max ?? 2;
  const profileBoost = profile === 'athlete' ? 0.15 : profile === 'older_adult' ? 0.1 : 0;
  const goalBoost = goal === 'strength' || goal === 'return' ? 0.1 : goal === 'calm' ? -0.05 : 0;
  const proteinMin = Math.round(weightKg * Math.max(1.4, baseMin + profileBoost + goalBoost));
  const proteinMax = Math.round(weightKg * Math.max(proteinMin / weightKg, baseMax + profileBoost + goalBoost));
  const chosenProtein = goal === 'calm' ? proteinMin : goal === 'mobility' ? Math.round((proteinMin + proteinMax) / 2) : proteinMax;
  const hydrationTargetMl = Math.round(weightKg * (phase.hydrationMlPerKg ?? 35) + (profile === 'athlete' ? 350 : 0));
  const collagenDoseGrams = phase.collagenPerKg
    ? Math.max(10, Math.min(20, Math.round(weightKg * ((phase.collagenPerKg.min + phase.collagenPerKg.max) / 2))))
    : undefined;
  const breakfast = Math.round(chosenProtein * 0.28);
  const lunch = Math.round(chosenProtein * 0.32);
  const snack = Math.max(15, Math.round(chosenProtein * 0.15));
  const dinner = chosenProtein - breakfast - lunch - snack;

  const vegetarianSwap = (text: string) =>
    dietStyle === 'vegetarian'
      ? text
          .replace(/chicken/gi, 'tofu')
          .replace(/turkey/gi, 'tempeh')
          .replace(/salmon/gi, 'tofu')
          .replace(/fish/gi, 'soy protein')
          .replace(/lean beef/gi, 'lentils')
      : text;

  return {
    proteinTotalGrams: chosenProtein,
    proteinRange: {min: proteinMin, max: proteinMax},
    proteinDistribution: {breakfast, lunch, dinner, snack},
    hydrationTargetMl,
    collagenDoseGrams,
    creatineGrams: phase.creatineGrams,
    omega3Grams: phase.omega3Grams,
    vitaminCMg: phase.vitaminCMg,
    calciumMg: phase.calciumMg,
    timingTips: [phase.timing?.collagen, phase.timing?.protein, phase.timing?.carbs, phase.timing?.hydration].filter(Boolean) as string[],
    meals: {
      breakfast: vegetarianSwap(phase.meals.breakfast),
      lunch: vegetarianSwap(phase.meals.lunch),
      dinner: vegetarianSwap(phase.meals.dinner),
      snack: phase.meals.snack ? vegetarianSwap(phase.meals.snack) : undefined,
    },
  };
}



