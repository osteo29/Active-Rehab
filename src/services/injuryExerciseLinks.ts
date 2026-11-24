import {navigationPaths} from '../utils/langUrlHelper';

type Language = 'en' | 'ar';

type ExerciseSlug =
  | 'chest'
  | 'back'
  | 'shoulders'
  | 'biceps'
  | 'triceps'
  | 'forearms'
  | 'abs'
  | 'obliques'
  | 'lower_back'
  | 'glutes'
  | 'quadriceps'
  | 'hamstrings'
  | 'calves'
  | 'arms'
  | 'core'
  | 'legs';

type ExerciseRecommendationSeed = {
  slug: ExerciseSlug;
  reason: string;
  reasonAr: string;
};

export type InjuryExerciseLink = {
  slug: ExerciseSlug;
  label: string;
  href: string;
  reason: string;
};

const EXERCISE_LABELS: Record<ExerciseSlug, {en: string; ar: string}> = {
  chest: {en: 'Chest exercises', ar: 'تمارين الصدر'},
  back: {en: 'Back exercises', ar: 'تمارين الظهر'},
  shoulders: {en: 'Shoulder exercises', ar: 'تمارين الكتف'},
  biceps: {en: 'Biceps exercises', ar: 'تمارين البايسبس'},
  triceps: {en: 'Triceps exercises', ar: 'تمارين الترايسبس'},
  forearms: {en: 'Forearm exercises', ar: 'تمارين الساعد'},
  abs: {en: 'Abs exercises', ar: 'تمارين البطن'},
  obliques: {en: 'Oblique exercises', ar: 'تمارين الخواصر'},
  lower_back: {en: 'Lower-back exercises', ar: 'تمارين أسفل الظهر'},
  glutes: {en: 'Glute exercises', ar: 'تمارين الجلوتس'},
  quadriceps: {en: 'Quadriceps exercises', ar: 'تمارين الكوادز'},
  hamstrings: {en: 'Hamstring exercises', ar: 'تمارين الهامسترنج'},
  calves: {en: 'Calf exercises', ar: 'تمارين السمانة'},
  arms: {en: 'Arm exercises', ar: 'تمارين الذراع'},
  core: {en: 'Core exercises', ar: 'تمارين الجذع'},
  legs: {en: 'Leg exercises', ar: 'تمارين الأرجل'},
};

const SPECIFIC_INJURY_MAP: Record<string, ExerciseRecommendationSeed[]> = {
  acl_injury: [
    {slug: 'quadriceps', reason: 'Useful for rebuilding knee strength and front-leg control.', reasonAr: 'مفيدة لإعادة بناء قوة الركبة والتحكم الأمامي للساق.'},
    {slug: 'hamstrings', reason: 'Helps restore posterior support around the knee.', reasonAr: 'تساعد على استعادة الدعم الخلفي حول الركبة.'},
    {slug: 'glutes', reason: 'Improves hip control that unloads the knee during rehab.', reasonAr: 'تحسن تحكم الورك وتخفف الحمل عن الركبة أثناء التأهيل.'},
  ],
  meniscus_tear: [
    {slug: 'quadriceps', reason: 'Guided quad work often supports knee function after meniscus irritation.', reasonAr: 'تمارين الكوادز الموجهة تدعم وظيفة الركبة بعد تهيج الغضروف الهلالي.'},
    {slug: 'glutes', reason: 'Hip strength can improve alignment and tolerance in daily movement.', reasonAr: 'قوة الورك قد تحسن المحاذاة والتحمل أثناء الحركة اليومية.'},
    {slug: 'hamstrings', reason: 'Progressive posterior-chain work can support knee stability.', reasonAr: 'التحميل التدريجي للسلسلة الخلفية قد يدعم ثبات الركبة.'},
  ],
  ankle_sprain: [
    {slug: 'calves', reason: 'Calf strength is commonly rebuilt during ankle rehab.', reasonAr: 'قوة السمانة عنصر شائع في إعادة تأهيل الكاحل.'},
    {slug: 'legs', reason: 'Leg control drills help return-to-walk and return-to-run progressions.', reasonAr: 'تمارين التحكم في الساق تساعد في العودة للمشي والجري تدريجيًا.'},
    {slug: 'glutes', reason: 'Hip stability can reduce repeated ankle collapse during stance.', reasonAr: 'ثبات الورك قد يقلل انهيار الكاحل المتكرر أثناء الوقوف.'},
  ],
  rotator_cuff: [
    {slug: 'shoulders', reason: 'Shoulder-specific progressions match cuff loading and control work.', reasonAr: 'التدرج الخاص بالكتف يتماشى مع تحميل الكفة المدورة والتحكم الحركي.'},
    {slug: 'back', reason: 'Upper-back work often supports scapular control during recovery.', reasonAr: 'عمل أعلى الظهر يدعم غالبًا تحكم لوح الكتف أثناء التعافي.'},
    {slug: 'chest', reason: 'Selected pressing progressions can be reintroduced later when tolerated.', reasonAr: 'يمكن إعادة بعض تمارين الدفع لاحقًا بشكل انتقائي عند تحسن التحمل.'},
  ],
  shoulder_impingement: [
    {slug: 'shoulders', reason: 'Useful for restoring shoulder range, control, and tolerance.', reasonAr: 'مفيدة لاستعادة مدى الكتف والتحكم والتحمل.'},
    {slug: 'back', reason: 'Back and scapular control work often complements shoulder rehab.', reasonAr: 'عمل الظهر ولوح الكتف يكمل غالبًا تأهيل الكتف.'},
  ],
  low_back_pain: [
    {slug: 'core', reason: 'Core-focused exercise selection often supports trunk tolerance.', reasonAr: 'اختيار تمارين الجذع يدعم غالبًا تحمل العمود والجذع.'},
    {slug: 'lower_back', reason: 'Graduated lower-back work can help restore spinal endurance.', reasonAr: 'العمل المتدرج لأسفل الظهر قد يساعد في استعادة تحمل العمود الفقري.'},
    {slug: 'glutes', reason: 'Hip strength can reduce repeated stress on the lower back.', reasonAr: 'قوة الورك قد تقلل الضغط المتكرر على أسفل الظهر.'},
  ],
  achilles_tendinopathy: [
    {slug: 'calves', reason: 'Calf loading is central to many Achilles rehab progressions.', reasonAr: 'تحميل السمانة جزء أساسي في كثير من تدرجات تأهيل أخيل.'},
    {slug: 'legs', reason: 'Leg drills help return to gait, hopping, and running demands.', reasonAr: 'تمارين الأرجل تساعد في العودة للمشي والقفز والجري.'},
  ],
  patellar_tendinopathy: [
    {slug: 'quadriceps', reason: 'Knee-extensor loading is often central in patellar tendon rehab.', reasonAr: 'تحميل باسطات الركبة عنصر محوري غالبًا في تأهيل وتر الرضفة.'},
    {slug: 'legs', reason: 'Leg-focused patterns support return to jumping and sport demands.', reasonAr: 'الأنماط الموجهة للأرجل تدعم العودة للقفز ومتطلبات الرياضة.'},
    {slug: 'glutes', reason: 'Hip control can support better landing and knee mechanics.', reasonAr: 'تحكم الورك قد يدعم ميكانيكا أفضل للهبوط والركبة.'},
  ],
};

const BODY_REGION_MAP: Record<string, ExerciseRecommendationSeed[]> = {
  Shoulder: [
    {slug: 'shoulders', reason: 'Direct shoulder progressions fit many shoulder-related recovery plans.', reasonAr: 'التدرج المباشر لتمارين الكتف يناسب كثيرًا من خطط التعافي المرتبطة بالكتف.'},
    {slug: 'back', reason: 'Back work often supports shoulder-blade position and control.', reasonAr: 'تمارين الظهر تدعم غالبًا وضعية لوح الكتف والتحكم فيه.'},
  ],
  Knee: [
    {slug: 'quadriceps', reason: 'Quad work is commonly used to restore knee function and loading tolerance.', reasonAr: 'عمل الكوادز يستخدم كثيرًا لاستعادة وظيفة الركبة وتحمل التحميل.'},
    {slug: 'hamstrings', reason: 'Hamstring strength can support knee mechanics and confidence.', reasonAr: 'قوة الهامسترنج قد تدعم ميكانيكا الركبة والثقة الحركية.'},
    {slug: 'glutes', reason: 'Hip strength often improves alignment above the knee.', reasonAr: 'قوة الورك تحسن غالبًا المحاذاة فوق الركبة.'},
  ],
  Ankle: [
    {slug: 'calves', reason: 'Calf capacity is important for ankle function and push-off.', reasonAr: 'قدرة السمانة مهمة لوظيفة الكاحل والدفع.'},
    {slug: 'legs', reason: 'Leg work helps restore stance, walking, and running tolerance.', reasonAr: 'عمل الأرجل يساعد في استعادة الوقوف والمشي والجري.'},
  ],
  Foot: [
    {slug: 'calves', reason: 'Calf loading often supports foot and ankle rehab progressions.', reasonAr: 'تحميل السمانة يدعم غالبًا تدرجات تأهيل القدم والكاحل.'},
    {slug: 'legs', reason: 'Leg strength helps distribute load better during gait.', reasonAr: 'قوة الأرجل تساعد على توزيع الحمل بشكل أفضل أثناء المشي.'},
  ],
  Back: [
    {slug: 'core', reason: 'Core work often supports trunk control and symptom-guided progression.', reasonAr: 'تمارين الجذع تدعم غالبًا التحكم الحركي والتدرج حسب الأعراض.'},
    {slug: 'lower_back', reason: 'Lower-back progressions may help restore spinal endurance.', reasonAr: 'تدرجات أسفل الظهر قد تساعد في استعادة تحمل العمود.'},
    {slug: 'glutes', reason: 'Glute strength can unload the back in daily tasks and lifting.', reasonAr: 'قوة الجلوتس قد تخفف الحمل عن الظهر في النشاط اليومي والرفع.'},
  ],
  Spine: [
    {slug: 'core', reason: 'Core control supports many spine-focused rehab strategies.', reasonAr: 'التحكم في الجذع يدعم كثيرًا من استراتيجيات تأهيل العمود الفقري.'},
    {slug: 'lower_back', reason: 'Selected lower-back drills may help rebuild tolerance gradually.', reasonAr: 'بعض تمارين أسفل الظهر قد تعيد بناء التحمل تدريجيًا.'},
  ],
  Elbow: [
    {slug: 'forearms', reason: 'Forearm loading is often useful in elbow tendon and gripping problems.', reasonAr: 'تحميل الساعد مفيد غالبًا في مشاكل أوتار المرفق والقبضة.'},
    {slug: 'arms', reason: 'Arm progressions may support return to pressing or pulling tasks.', reasonAr: 'تدرجات الذراع قد تدعم العودة لمهام الدفع أو السحب.'},
  ],
  Wrist: [
    {slug: 'forearms', reason: 'Forearm work supports grip and wrist tolerance in many cases.', reasonAr: 'عمل الساعد يدعم القبضة وتحمل الرسغ في كثير من الحالات.'},
    {slug: 'arms', reason: 'Arm drills can support upper-limb return-to-load plans.', reasonAr: 'تمارين الذراع تدعم خطط العودة لتحميل الطرف العلوي.'},
  ],
  Hip: [
    {slug: 'glutes', reason: 'Glute strength is central to many hip rehab progressions.', reasonAr: 'قوة الجلوتس عنصر أساسي في كثير من تدرجات تأهيل الورك.'},
    {slug: 'legs', reason: 'Leg patterns help restore squat, step, and gait tolerance.', reasonAr: 'أنماط الأرجل تساعد في استعادة تحمل السكوات والخطوات والمشي.'},
    {slug: 'hamstrings', reason: 'Posterior-chain work can support hip extension and control.', reasonAr: 'عمل السلسلة الخلفية قد يدعم تمديد الورك والتحكم.'},
  ],
  Chest: [
    {slug: 'chest', reason: 'Chest-focused progressions can become relevant later in recovery when tolerated.', reasonAr: 'قد تصبح تمارين الصدر مهمة لاحقًا في التعافي عند تحسن التحمل.'},
    {slug: 'shoulders', reason: 'Shoulder control often influences chest and pressing tolerance.', reasonAr: 'تحكم الكتف يؤثر غالبًا على تحمل الصدر وتمارين الدفع.'},
  ],
};

function uniqueSeeds(items: ExerciseRecommendationSeed[]) {
  return items.filter((item, index) => items.findIndex((entry) => entry.slug === item.slug) === index);
}

export function getInjuryExerciseLinks({
  injuryId,
  bodyRegion,
  lang,
}: {
  injuryId: string;
  bodyRegion: string;
  lang: Language;
}): InjuryExerciseLink[] {
  const seeds = uniqueSeeds([...(SPECIFIC_INJURY_MAP[injuryId] || []), ...(BODY_REGION_MAP[bodyRegion] || [])]).slice(0, 3);

  return seeds.map((item) => ({
    slug: item.slug,
    label: EXERCISE_LABELS[item.slug][lang],
    href: navigationPaths.exercisesMuscle(lang, item.slug),
    reason: lang === 'ar' ? item.reasonAr : item.reason,
  }));
}

/** True when the injury's recommendation seeds include the given exercise region. */
export function injuryRecommendsRegion(injuryId: string, bodyRegion: string, regionSlug: string): boolean {
  const seeds = uniqueSeeds([...(SPECIFIC_INJURY_MAP[injuryId] || []), ...(BODY_REGION_MAP[bodyRegion] || [])]);
  return seeds.some((seed) => seed.slug === regionSlug);
}
