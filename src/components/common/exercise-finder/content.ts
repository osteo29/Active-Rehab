import {
  EXERCISE_FINDER_STATIC_ARABIC_LABELS,
  EXERCISE_FINDER_STATIC_LABELS,
  MAIN_MUSCLE_TO_STATIC_GROUP,
  STATIC_GROUP_MUSCLES,
} from './constants';
import {EXERCISES} from './data/exercises';
import {TRAINING_SYSTEMS} from './data/training-systems';
import {WEEKLY_PLANS} from './data/weekly-plans';
import type {Exercise, StaticMuscleSlug} from './types';

type RegionContent = {
  introEn: string;
  introAr: string;
  anatomyEn: string[];
  anatomyAr: string[];
  cuesEn: string[];
  cuesAr: string[];
  keywordsEn: string[];
  keywordsAr: string[];
};

type SystemDetailContent = {
  overviewEn: string;
  overviewAr: string;
  strengthsEn: string[];
  strengthsAr: string[];
  comparisonsEn: Array<{label: string; value: string}>;
  comparisonsAr: Array<{label: string; value: string}>;
  seoSummaryEn: string;
  seoSummaryAr: string;
};

function buildRegionContent(
  introEn: string,
  introAr: string,
  anatomyEn: string[],
  anatomyAr: string[],
  cuesEn: string[],
  cuesAr: string[],
  keywordsEn: string[],
  keywordsAr: string[],
): RegionContent {
  return {introEn, introAr, anatomyEn, anatomyAr, cuesEn, cuesAr, keywordsEn, keywordsAr};
}

export const REGION_CONTENT: Record<StaticMuscleSlug, RegionContent> = {
  chest: buildRegionContent(
    'Chest training is built around horizontal and angled pressing, with the pecs working alongside the front delts and triceps.',
    'تدريب الصدر يعتمد على الضغط الأفقي والمائل مع مشاركة الكتف الأمامي والترايسبس.',
    ['Upper chest usually responds best to low-incline pressing.', 'Flat pressing and push-up patterns drive most middle-chest work.', 'Lower chest gets more emphasis from dips and decline-style angles.'],
    ['الجزء العلوي يستجيب غالبًا للضغط المائل الخفيف.', 'الضغط المستوي وتمارين الضغط يخدمان الجزء الأوسط بقوة.', 'الجزء السفلي يتأثر أكثر بالديبس والزوايا المائلة لأسفل.'],
    ['Set the shoulder blades before pressing.', 'Use a pain-free pressing path instead of forcing one grip.', 'Balance chest volume with enough pulling work.'],
    ['ثبّت لوحي الكتف قبل الضغط.', 'استخدم مسار ضغط مريح بدل فرض قبضة واحدة.', 'وازن حجم الصدر مع السحب المناسب.'],
    ['upper chest exercises', 'best chest exercises gym', 'dumbbell chest workout', 'lower chest exercises'],
    ['تمارين صدر علوي', 'أفضل تمارين صدر', 'تمارين صدر بالدمبل', 'تمارين أسفل الصدر'],
  ),
  back: buildRegionContent(
    'Back work combines width, thickness, posture, and hinge support across the lats, traps, rhomboids, and spinal erectors.',
    'تدريب الظهر يجمع بين العرض والسماكة ووضعية الجسم ودعم الهيب هنج عبر اللاتس والترابيس والرومبويد وعضلات العمود.',
    ['Vertical pulls usually bias the lats.', 'Rows build more mid-back density and scapular control.', 'Hinge-support work trains the erectors and trunk endurance.'],
    ['السحب الرأسي يميل لاستهداف اللاتس.', 'الرو يبني سماكة منتصف الظهر والتحكم في لوح الكتف.', 'تمارين الهيب هنج تدرب العضلات الداعمة للعمود وتحمل الجذع.'],
    ['Match vertical pulls with horizontal rows.', 'Pause at the top instead of using momentum.', 'Train grip and upper-back control together.'],
    ['وازن بين السحب الرأسي والرو الأفقي.', 'توقف لحظة بدل استخدام الزخم.', 'درّب القبضة والتحكم في أعلى الظهر معًا.'],
    ['back exercises for lats', 'best back workout gym', 'row exercises', 'lower back exercises'],
    ['تمارين ظهر', 'تمارين لاتس', 'أفضل تمارين ظهر', 'تمارين أسفل الظهر'],
  ),
  shoulders: buildRegionContent(
    'Shoulder training works best when front, side, and rear delt work is balanced with good scapular control.',
    'تدريب الكتف يكون أفضل عندما يتوازن الجزء الأمامي والجانبي والخلفي مع التحكم الجيد في لوح الكتف.',
    ['Front delts overlap heavily with pressing.', 'Side delts usually need direct raise volume.', 'Rear delts respond well to rows, flyes, and face pulls.'],
    ['الكتف الأمامي يتداخل كثيرًا مع الضغط.', 'الكتف الجانبي يحتاج غالبًا حجمًا مباشرًا.', 'الكتف الخلفي يستجيب للرو والفلاي والفيس بول.'],
    ['Do not force painful overhead ranges.', 'Keep shrugging from taking over raises.', 'Use rear-delt work to support pressing mechanics.'],
    ['لا تفرض مدى علويًا مؤلمًا.', 'لا تسمح للترابيس بالسيطرة على الرفعات.', 'استخدم عمل الكتف الخلفي لدعم الضغط.'],
    ['shoulder exercises gym', 'side delt exercises', 'rear delt workout', 'shoulder workout dumbbells'],
    ['تمارين كتف', 'تمارين كتف جانبي', 'تمارين كتف خلفي', 'تمارين كتف بالدمبل'],
  ),
  biceps: buildRegionContent(
    'Biceps training supports both arm size and pulling strength, especially when curl choices match elbow comfort.',
    'تدريب البايسبس يدعم حجم الذراع وقوة السحب خصوصًا عندما تتوافق التمارين مع راحة الكوع.',
    ['Supinated curls bias the biceps more directly.', 'Neutral-grip curls often feel better on irritated elbows.', 'Pulling compounds still add meaningful biceps stimulus.'],
    ['القبضة المقلوبة للخارج تستهدف البايسبس مباشرة أكثر.', 'قبضة الهامر غالبًا ألطف على الكوع.', 'تمارين السحب المركبة تضيف تحفيزًا مهمًا للبايسبس.'],
    ['Control the lowering phase.', 'Do not swing the torso for hard reps.', 'Match direct arm work to your pull volume.'],
    ['تحكم في النزول.', 'لا تهز الجذع لإكمال العدات الصعبة.', 'وازن تمارين الذراع مع حجم السحب.'],
    ['biceps exercises', 'best curls for biceps', 'hammer curl workout', 'arm day biceps'],
    ['تمارين بايسبس', 'أفضل تمارين بايسبس', 'تمارين هامر', 'يوم الذراع'],
  ),
  triceps: buildRegionContent(
    'Triceps size and pressing performance are tightly linked, so direct triceps work often improves lockout strength too.',
    'حجم الترايسبس وأداء الضغط مرتبطان جدًا، لذلك عمل الترايسبس المباشر يحسن قوة اللوك آوت أيضًا.',
    ['Pushdowns are simple and easy to recover from.', 'Overhead extensions challenge the long head differently.', 'Pressing compounds already contribute a lot of triceps work.'],
    ['الضغط لأسفل بسيط وسهل الاستشفاء.', 'التمارين فوق الرأس تستهدف الرأس الطويل بشكل مختلف.', 'الضغط المركب يمنح الترايسبس حجمًا كبيرًا أصلًا.'],
    ['Keep the elbow path stable.', 'Use full lockout without shoulder compensation.', 'Avoid stacking too much arm work over pressing fatigue.'],
    ['ثبّت مسار الكوع.', 'استخدم امتدادًا كاملًا دون تعويض من الكتف.', 'لا تكدّس حجم ذراع مبالغًا فوق إجهاد الضغط.'],
    ['triceps exercises', 'best triceps workout', 'cable pressdown benefits', 'overhead triceps extension'],
    ['تمارين ترايسبس', 'أفضل تمارين ترايسبس', 'كيبل ترايسبس', 'ترايسبس فوق الرأس'],
  ),
  forearms: buildRegionContent(
    'Forearm training improves grip, wrist tolerance, and the quality of many rows, carries, and curls.',
    'تدريب الساعد يحسن القبضة وتحمل الرسغ وجودة كثير من تمارين الرو والحمل والكيرل.',
    ['Rows and carries already train the forearms indirectly.', 'Direct wrist work fills weak points.', 'Neutral-grip patterns are often easier on wrists.'],
    ['الرو والحمل يدربان الساعد بشكل غير مباشر.', 'تمارين الرسغ المباشرة تسد نقاط الضعف.', 'القبضة المحايدة غالبًا ألطف على الرسغ.'],
    ['Train grip through holds and carries.', 'Build tolerance gradually when elbows are sensitive.', 'Use forearm work to support bigger lifts.'],
    ['درّب القبضة عبر الثبات والحمل.', 'ابنِ التحمل تدريجيًا عند حساسية الكوع.', 'استخدم تمارين الساعد لدعم التمارين الكبرى.'],
    ['forearm exercises', 'grip strength workout', 'wrist exercises gym', 'forearm dumbbell workout'],
    ['تمارين ساعد', 'تمارين قبضة', 'تمارين رسغ', 'تمارين ساعد بالدمبل'],
  ),
  abs: buildRegionContent(
    'Abs work should improve trunk control and bracing, not just create fatigue.',
    'تمارين البطن يجب أن تحسن التحكم في الجذع والثبات لا أن تصنع إجهادًا فقط.',
    ['Crunch patterns train controlled trunk flexion.', 'Reverse crunch variations add pelvic control.', 'Bracing work supports nearly every compound lift.'],
    ['أنماط الكرنش تدرب ثني الجذع بشكل مضبوط.', 'الريفيرس كرنش يضيف تحكمًا في الحوض.', 'الثبات يدعم تقريبًا كل تمرين مركب.'],
    ['Keep the ribs stacked.', 'Choose progressions you can control.', 'Pair direct abs work with breathing awareness.'],
    ['حافظ على وضع الأضلاع متزنًا.', 'اختر تدرجات يمكنك التحكم بها.', 'اربط تمارين البطن بالوعي بالتنفس.'],
    ['abs exercises', 'core workout gym', 'best ab exercises', 'lower abs workout'],
    ['تمارين بطن', 'تمارين كور', 'أفضل تمارين بطن', 'تمارين بطن سفلية'],
  ),
  obliques: buildRegionContent(
    'Oblique training improves rotation control, side stability, and athletic trunk transfer.',
    'تدريب الخواصر يحسن التحكم الدوراني والثبات الجانبي ونقل القوة رياضيًا.',
    ['Anti-rotation drills are highly practical.', 'Controlled rotation matters more than speed.', 'Carry variations often train the obliques well.'],
    ['تمارين مقاومة الدوران عملية جدًا.', 'التحكم في الدوران أهم من السرعة.', 'تمارين الحمل تدرب الخواصر جيدًا.'],
    ['Keep the pelvis quiet during anti-rotation drills.', 'Breathe behind the brace.', 'Use carries, chops, and side-plank progressions strategically.'],
    ['حافظ على ثبات الحوض في مقاومة الدوران.', 'تنفس داخل الثبات.', 'استخدم الحمل والقطع والسايد بلانك بذكاء.'],
    ['oblique exercises', 'side abs workout', 'anti rotation exercises', 'waist core training'],
    ['تمارين خواصر', 'تمارين بطن جانبي', 'تمارين مقاومة الدوران', 'تمارين وسط الجسم'],
  ),
  lower_back: buildRegionContent(
    'Lower-back work should improve endurance and hinge control more than it chases reckless fatigue.',
    'تدريب أسفل الظهر يجب أن يحسن التحمل والتحكم في الهيب هنج أكثر من مطاردة الإجهاد العنيف.',
    ['Back extensions build tolerance with a simple pattern.', 'Carries and hinges also train the lower back indirectly.', 'More range is not always better if position quality disappears.'],
    ['الهايبر إكستنشن تبني التحمل بنمط بسيط.', 'الحمل والهيب هنج يدربان أسفل الظهر أيضًا بشكل غير مباشر.', 'المدى الأكبر ليس أفضل إذا اختفت الجودة.'],
    ['Own the hinge before loading it hard.', 'Use tempo to build confidence.', 'Train it as part of the whole posterior chain.'],
    ['أتقن الهيب هنج قبل التحميل القوي.', 'استخدم الإيقاع لبناء الثقة.', 'درّبه كجزء من السلسلة الخلفية كلها.'],
    ['lower back exercises', 'back extension workout', 'posterior chain exercises', 'hinge exercises'],
    ['تمارين أسفل الظهر', 'هايبر إكستنشن', 'تمارين السلسلة الخلفية', 'تمارين هيب هنج'],
  ),
  glutes: buildRegionContent(
    'Glute work matters for strength, sprinting, hip stability, and lower-body shape.',
    'تدريب الجلوتس مهم للقوة والسرعة وثبات الحوض وشكل الجزء السفلي.',
    ['Hip thrusts train strong lockout and hip extension.', 'Single-leg work challenges pelvic stability.', 'Squats and hinges already train the glutes, but direct work fills gaps.'],
    ['الهيب ثرست يدرب مد الحوض بقوة.', 'تمارين الرجل الواحدة تتحدى ثبات الحوض.', 'السكوات والهيب هنج يدربان الجلوتس أصلًا لكن التمارين المباشرة تكمل النقص.'],
    ['Finish with glute tension, not low-back extension.', 'Use unilateral work for control.', 'Match glute volume to your full lower-body week.'],
    ['أنهِ الحركة بانقباض الجلوتس لا أسفل الظهر.', 'استخدم التمارين الأحادية للتحكم.', 'وازن حجم الجلوتس مع أسبوع الرجل كله.'],
    ['glute exercises', 'hip thrust workout', 'glute training gym', 'best glute exercises'],
    ['تمارين جلوتس', 'هيب ثرست', 'تمارين مؤخرة', 'أفضل تمارين جلوتس'],
  ),
  quadriceps: buildRegionContent(
    'Quad training drives knee-dominant leg strength and many hypertrophy-focused lower-body sessions.',
    'تدريب الكوادز يقود قوة الرجل الأمامية وكثيرًا من حصص التضخيم للجزء السفلي.',
    ['Squats and leg presses give the biggest total quad stimulus.', 'Split squats reveal side-to-side differences.', 'Tempo and Spanish squat work can load the quads without huge weights.'],
    ['السكوات والليج برس يمنحان أكبر تحفيز إجمالي للكوادز.', 'السبليت سكوات يكشف الفروق بين الجانبين.', 'التمبو والسبانيش سكوات يحمّلان الكوادز دون أوزان ضخمة.'],
    ['Use consistent depth.', 'Let the knee move when the exercise allows it.', 'Keep trunk and hip position stable under fatigue.'],
    ['استخدم عمقًا ثابتًا.', 'اسمح للركبة بالحركة حين يسمح التمرين.', 'حافظ على ثبات الجذع والحوض تحت التعب.'],
    ['quad exercises', 'leg day quads', 'best quadriceps workout', 'front squat benefits'],
    ['تمارين كوادز', 'تمارين الفخذ الأمامي', 'أفضل تمارين كوادز', 'تمارين رجل أمامي'],
  ),
  hamstrings: buildRegionContent(
    'Hamstrings support sprinting, hinging, knee flexion, and overall lower-body balance.',
    'الهامسترينج تدعم السرعة والهيب هنج وثني الركبة وتوازن الجزء السفلي.',
    ['Hip-hinge work loads the hamstrings at longer lengths.', 'Curl patterns train knee-flexion strength directly.', 'Posterior-chain work supports hip and knee balance together.'],
    ['الهيب هنج يحمّل الهامسترينج في أطوال أكبر.', 'تمارين الكيرل تدرب قوة ثني الركبة مباشرة.', 'تدريب السلسلة الخلفية يدعم توازن الحوض والركبة معًا.'],
    ['Do not turn every hinge into low-back work.', 'Use slow eccentrics on curls.', 'Pair hamstrings with glute and calf support.'],
    ['لا تحول كل هيب هنج إلى أسفل ظهر.', 'استخدم نزولًا بطيئًا في تمارين الكيرل.', 'اربط الهامسترينج بدعم الجلوتس والسمانة.'],
    ['hamstring exercises', 'posterior chain workout', 'RDL hamstring', 'hamstring curl workout'],
    ['تمارين هامسترينج', 'تمارين خلفية الرجل', 'تمارين RDL', 'كيرل هامسترينج'],
  ),
  calves: buildRegionContent(
    'Calf work supports ankle stiffness, running economy, and better lower-leg development.',
    'تدريب السمانة يدعم صلابة الكاحل واقتصاد الجري وتطور الجزء السفلي من الساق.',
    ['Standing calf raises often bias the gastrocnemius.', 'Seated versions usually bias the soleus more.', 'Long pauses often make calf work more effective.'],
    ['الرفع واقفًا يميل إلى استهداف الجاستروكنيميوس.', 'الرفع جالسًا يركز غالبًا على السوليوس.', 'التوقف الطويل يجعل تدريب السمانة أكثر فعالية.'],
    ['Train the full range instead of bouncing.', 'Use enough weekly frequency.', 'Pair calf work with ankle-control drills when needed.'],
    ['درّب المدى الكامل بدل الارتداد.', 'استخدم تكرارًا أسبوعيًا كافيًا.', 'اربط تمارين السمانة بالتحكم في الكاحل عند الحاجة.'],
    ['calf exercises', 'standing calf raise', 'best calf workout', 'soleus exercises'],
    ['تمارين سمانة', 'أفضل تمارين سمانة', 'رفع سمانة واقف', 'تمارين السوليوس'],
  ),
  arms: buildRegionContent(
    'Arms programming combines biceps, triceps, and forearm work so users can build size while supporting bigger push and pull days.',
    'برمجة الذراع تجمع بين البايسبس والترايسبس والساعد ليبني المستخدم الحجم ويدعم أيام السحب والدفع.',
    ['Biceps usually gain extra stimulus from pulling.', 'Triceps usually gain extra stimulus from pressing.', 'Forearms support grip and elbow tolerance across many lifts.'],
    ['البايسبس تحصل على تحفيز إضافي من السحب.', 'الترايسبس تحصل على تحفيز إضافي من الضغط.', 'الساعد تدعم القبضة وتحمل الكوع في تمارين كثيرة.'],
    ['Do not separate arm work from push and pull volume.', 'Use a mix of supinated, neutral, and extension patterns.', 'Protect elbows by managing total load.'],
    ['لا تفصل تمارين الذراع عن حجم السحب والضغط.', 'استخدم مزيجًا من القبضات والزوايا.', 'احمِ الكوع عبر إدارة الحمل الكلي.'],
    ['arm exercises', 'arm day workout', 'biceps and triceps workout', 'forearm arm workout'],
    ['تمارين ذراع', 'يوم الذراع', 'تمارين بايسبس وترايسبس', 'تمارين ساعد'],
  ),
  core: buildRegionContent(
    'Core training ties together abs, obliques, and lower-back support to build a stronger trunk for lifting and daily movement.',
    'تدريب الكور يجمع بين البطن والخواصر ودعم أسفل الظهر ليبني جذعًا أقوى للرفع والحركة اليومية.',
    ['Abs often manage flexion and anti-extension.', 'Obliques support rotation and side stability.', 'Lower-back muscles maintain position during loaded patterns.'],
    ['البطن تدير الثني ومقاومة التمدد.', 'الخواصر تدعم الدوران والثبات الجانبي.', 'أسفل الظهر يحافظ على الوضع أثناء الأحمال.'],
    ['Use flexion, anti-extension, and anti-rotation patterns.', 'Train trunk control to support bigger lifts.', 'Choose progressions that improve position, not just soreness.'],
    ['استخدم أنماط الثني ومقاومة التمدد ومقاومة الدوران.', 'درّب تحكم الجذع لدعم التمارين الأكبر.', 'اختر تدرجات تحسن الوضعية لا مجرد الألم.'],
    ['core exercises', 'ab and oblique workout', 'lower back core exercises', 'gym core workout'],
    ['تمارين كور', 'تمارين بطن وخواصر', 'تمارين كور للجيم', 'تمارين جذع'],
  ),
  neck: buildRegionContent(
    'Neck rehab work should improve control, posture, and shoulder-blade support rather than chasing hard fatigue.',
    '????? ?????? ????? ????? ?????? ?????? ???????? ???? ??? ????? ???? ?? ????? ?? ????? ???? ????.',
    ['Shoulder-blade control often changes how the neck feels under load.', 'Gentle pulling and rear-shoulder work usually fits better than aggressive shrugging.', 'Thoracic posture and breathing can reduce repeated neck tension.'],
    ['?????? ?? ??? ????? ????? ?????? ???? ?????? ????? ???????.', '?????? ????? ??????? ???? ????? ?????? ???? ???? ?? ????? ????? ?? ????? ?????? ?????.', '????? ????? ??????? ?? ?????? ???? ??????? ?? ??????.'],
    ['Use low-irritation pulling patterns first.', 'Keep the ribs stacked and avoid jutting the chin forward.', 'Progress from control drills into tolerable shoulder strength work.'],
    ['???? ?????? ??? ?????? ????????? ?????.', '???? ??? ????? ????? ?????? ????? ??? ????? ??????.', '????? ?? ?????? ?????? ??? ????? ????? ???? ?????? ??????.'],
    ['neck rehab exercises', 'cervical rehab workout', 'shoulder blade exercises for neck pain', 'posture exercises for neck'],
    ['?????? ????? ??????', '?????? ?????? ??????', '?????? ??? ????? ????? ??????', '?????? ????? ??????'],
  ),
  hip: buildRegionContent(
    'Hip rehab needs glute strength, hamstring support, single-leg control, and enough range to restore daily movement quality.',
    '????? ????? ????? ??? ??????? ???? ??????????? ????? ????? ??????? ???? ???? ???? ???????? ???? ?????? ???????.',
    ['Glutes often lead hip stability and pelvic control.', 'Hamstrings and split-stance work support hip extension tolerance.', 'Hip rehab usually improves faster when core and trunk control stay involved.'],
    ['??????? ???? ?????? ???? ????? ????? ?????.', '??????????? ?????? ?? ???????? ???????? ?????? ???? ??? ?????.', '????? ????? ????? ???? ???? ???? ????? ???? ????? ??????? ?? ??????.'],
    ['Use unilateral work to expose side-to-side differences.', 'Own hip extension without leaning into the low back.', 'Start with control and tempo before chasing heavier load.'],
    ['?????? ???????? ???????? ?????? ?????? ??? ????????.', '???? ??? ????? ??? ??????? ?? ???? ?????.', '???? ??????? ???????? ??? ????? ?? ??? ????.'],
    ['hip rehab exercises', 'glute and hamstring rehab', 'hip stability workout', 'single-leg hip control'],
    ['?????? ????? ?????', '????? ??????? ????????????', '?????? ???? ?????', '???? ????? ?????? ???????'],
  ),
  'wrist-rehab': buildRegionContent(
    'Wrist rehab benefits from forearm loading, grip tolerance, and gradual return to pressure-bearing tasks.',
    '????? ????? ?????? ?? ????? ?????? ????? ?????? ??????? ????????? ?????? ???? ????? ??? ????? ??? ?????.',
    ['Forearm strength gives the wrist more support than isolated stretching alone.', 'Neutral-grip work is often better tolerated early.', 'Carry and hold drills can rebuild confidence without complex setup.'],
    ['??? ?????? ???? ????? ????? ???? ?? ??????? ???????? ?????.', '?????? ???????? ???? ?????? ???? ?????? ?? ??????? ??????.', '?????? ????? ???????? ?? ???? ????? ??? ??????? ?????.'],
    ['Keep the wrist position clean before adding volume.', 'Progress from supported grip work into harder carries or curls.', 'Stop short of sharp wrist pain and build tolerance gradually.'],
    ['???? ??? ??? ????? ?????? ??? ????? ????? ????????.', '????? ?? ??? ?????? ??????? ??? ??? ?? ????? ???? ???? ??????.', '???? ??? ????? ????? ????? ?????? ????????.'],
    ['wrist rehab exercises', 'forearm rehab workout', 'grip rehab training', 'wrist stability exercises'],
    ['?????? ????? ?????', '????? ??????', '????? ????? ??????', '?????? ???? ?????'],
  ),
  'full-body-rehab': buildRegionContent(
    'Full-body rehab works best when the week reconnects trunk control, hips, shoulders, and gait rather than overloading one area too early.',
    '????? ????? ??????? ???? ???? ????? ???? ??? ???? ????? ?????? ?????? ?????? ??? ????? ????? ????? ?????? ???? ????? ???.',
    ['Simple patterns should rebuild confidence first.', 'Posterior-chain and shoulder-blade work usually give the best return early.', 'A smart return-to-training week mixes strength, control, and low-cost conditioning.'],
    ['??????? ??????? ??? ?? ???? ???? ????? ?????.', '??? ??????? ??????? ???? ????? ???? ?????? ???? ???? ????.', '????? ?????? ????? ??????? ???? ??? ????? ??????? ???????? ?????? ???????.'],
    ['Use pain-calmed movement first, then add density slowly.', 'Pick exercises that leave the next day manageable.', 'Return-to-training plans should feel repeatable, not heroic.'],
    ['???? ????? ????? ?????? ?????? ?? ?? ??????? ????.', '???? ?????? ???? ????? ?????? ??????? ?? ??????.', '??? ?????? ??????? ??? ?? ???? ????? ??????? ?? ?????? ???????? ????.'],
    ['full body rehab exercises', 'return to training workout', 'post rehab gym plan', 'whole body recovery workout'],
    ['?????? ????? ????? ???????', '??? ?????? ???????', '?????? ??? ??? ???????', '????? ????? ???? ?????'],
  ),
  legs: buildRegionContent(
    'Leg training combines quads, hamstrings, glutes, and calves so users can organize complete lower-body sessions around strength and muscle gain.',
    'تدريب الرجل يجمع الكوادز والهامسترينج والجلوتس والسمانة لتنظيم حصص كاملة للجزء السفلي حول القوة والعضلات.',
    ['Quads drive squat and step patterns.', 'Hamstrings and glutes dominate hinge work.', 'Calves and ankle control matter more than many lifters expect.'],
    ['الكوادز تقود السكوات والصعود.', 'الهامسترينج والجلوتس تسيطران على الهيب هنج.', 'السمانة والتحكم في الكاحل أهم مما يتوقع كثيرون.'],
    ['Use one heavy lower-body anchor each week.', 'Add unilateral work for balance.', 'Cover knee, hip, and ankle function across the week.'],
    ['استخدم تمرينًا رئيسيًا ثقيلًا أسبوعيًا.', 'أضف تمارين أحادية الرجل للتوازن.', 'غطِّ وظائف الركبة والحوض والكاحل خلال الأسبوع.'],
    ['leg exercises gym', 'best leg day workout', 'glute hamstring quad workout', 'lower body exercises'],
    ['تمارين رجل', 'أفضل يوم رجل', 'تمارين الجزء السفلي', 'تمارين كوادز وجلوتس وهامسترينج'],
  ),
};

export const SYSTEM_DETAIL_CONTENT: Record<string, SystemDetailContent> = {
  'full-body-foundation': {
    overviewEn: 'A beginner-friendly weekly structure that covers all major patterns without overwhelming recovery.',
    overviewAr: 'هيكل أسبوعي مناسب للمبتدئين يغطي الأنماط الأساسية دون الضغط على الاستشفاء.',
    strengthsEn: ['Reinforces the main movement patterns every week.', 'Easy to recover from and easy to stick to.', 'Missed sessions are less disruptive than specialized splits.'],
    strengthsAr: ['يعيد تثبيت الأنماط الأساسية كل أسبوع.', 'سهل في الاستشفاء والالتزام.', 'تفويت حصة أقل ضررًا من التقسيمات المتخصصة.'],
    comparisonsEn: [{label: 'Versus Push Pull Legs', value: 'Less specialization, but simpler recovery and consistency.'}, {label: 'Versus Upper Lower', value: 'Lower schedule pressure with slightly less volume per region.'}],
    comparisonsAr: [{label: 'مقارنة بـ Push Pull Legs', value: 'تخصص أقل لكن استشفاء والتزام أسهل.'}, {label: 'مقارنة بـ Upper Lower', value: 'ضغط تنظيمي أقل مع حجم أقل قليلًا لكل منطقة.'}],
    seoSummaryEn: 'A beginner full body workout plan with weekly structure, linked exercises, and clear progression guidance.',
    seoSummaryAr: 'خطة جسم كامل للمبتدئين مع تنظيم أسبوعي وروابط تمارين وتوجيه واضح للتدرج.',
  },
  'upper-lower-balance': {
    overviewEn: 'A four-day split that separates upper and lower fatigue for organized muscle gain.',
    overviewAr: 'تقسيم أربعة أيام يفصل إجهاد الجزء العلوي والسفلي لزيادة عضلية منظمة.',
    strengthsEn: ['Gives enough frequency for hypertrophy.', 'Keeps recovery windows predictable.', 'Works well for users who can reliably train four days weekly.'],
    strengthsAr: ['يعطي تكرارًا مناسبًا للتضخيم.', 'يبقي نوافذ الاستشفاء واضحة.', 'يناسب من يلتزم بأربعة أيام أسبوعيًا.'],
    comparisonsEn: [{label: 'Versus Full Body', value: 'More volume per region, but less forgiving if sessions are missed.'}, {label: 'Versus Strength Triad', value: 'Better for hypertrophy volume, less focused on low-rep strength.'}],
    comparisonsAr: [{label: 'مقارنة بـ Full Body', value: 'حجم أكبر لكل منطقة لكنه أقل مرونة إذا فاتتك حصة.'}, {label: 'مقارنة بـ Strength Triad', value: 'أفضل لحجم التضخيم وأقل تركيزًا على القوة القليلة التكرار.'}],
    seoSummaryEn: 'A four-day upper lower workout split with linked weekly sessions, comparisons, and exercise recommendations.',
    seoSummaryAr: 'تقسيم علوي سفلي لأربعة أيام مع خطة أسبوعية ومقارنات وروابط تمارين موصى بها.',
  },
  'push-pull-legs': {
    overviewEn: 'A classic hypertrophy split for users who want focused gym days and higher exercise variety.',
    overviewAr: 'تقسيم تضخيم كلاسيكي لمن يريد أيامًا مركزة داخل الجيم وتنوعًا أعلى في التمارين.',
    strengthsEn: ['Each day has a clear movement theme.', 'Scales from three to six days.', 'Lets users push chest, back, and leg volume harder when recovery is good.'],
    strengthsAr: ['لكل يوم موضوع حركي واضح.', 'يمكن توسيعه من ثلاثة إلى ستة أيام.', 'يسمح برفع حجم الصدر والظهر والرجل عندما يكون الاستشفاء جيدًا.'],
    comparisonsEn: [{label: 'Versus Upper Lower', value: 'More specialization and variety, but harder to recover from.'}, {label: 'Versus Dumbbell Anywhere', value: 'Better for full-gym progression and machine or barbell access.'}],
    comparisonsAr: [{label: 'مقارنة بـ Upper Lower', value: 'تخصص وتنوع أكبر لكنه أصعب في الاستشفاء.'}, {label: 'مقارنة بـ Dumbbell Anywhere', value: 'أفضل للتقدم داخل جيم كامل ومعدات أوسع.'}],
    seoSummaryEn: 'A detailed push pull legs workout system with comparisons, weekly planning, and links to related exercise pages.',
    seoSummaryAr: 'شرح كامل لنظام Push Pull Legs مع مقارنات وخطة أسبوعية وروابط لصفحات التمارين المرتبطة.',
  },
  'strength-triad': {
    overviewEn: 'A compact three-day system built around measurable strength work on the main lifts.',
    overviewAr: 'نظام مختصر لثلاثة أيام مبني حول عمل قوة قابل للقياس في الرفعات الرئيسية.',
    strengthsEn: ['Protects recovery so heavy lifts stay high quality.', 'Keeps accessory work purposeful.', 'Fits lifters who care about performance more than pump chasing.'],
    strengthsAr: ['يحمي الاستشفاء حتى تبقى الرفعات الثقيلة عالية الجودة.', 'يبقي التمارين المساعدة هادفة.', 'يناسب من يهتم بالأداء أكثر من الضخ فقط.'],
    comparisonsEn: [{label: 'Versus Upper Lower', value: 'Less hypertrophy volume, but stronger low-rep focus.'}, {label: 'Versus Return to Training', value: 'Far more demanding and not ideal while rebuilding tolerance.'}],
    comparisonsAr: [{label: 'مقارنة بـ Upper Lower', value: 'حجم تضخيم أقل لكن تركيز أقوى على الأداء قليل التكرار.'}, {label: 'مقارنة بـ Return to Training', value: 'أصعب بكثير وليس مثاليًا أثناء استعادة التحمل.'}],
    seoSummaryEn: 'A three-day strength workout system centered on squats, presses, rows, and hinges with linked weekly planning.',
    seoSummaryAr: 'نظام قوة لثلاثة أيام يرتكز على السكوات والضغط والرو والهيب هنج مع ربط بالخطة الأسبوعية.',
  },
  'dumbbell-hotel-plan': {
    overviewEn: 'A minimal-equipment plan for home setups, travel weeks, and users limited to dumbbells and a bench.',
    overviewAr: 'خطة بمعدات محدودة للبيت أو السفر أو لمن يملك دمبل ومقعدًا فقط.',
    strengthsEn: ['Reduces overthinking around limited equipment.', 'A/B structure makes progression straightforward.', 'Easy to keep running during busy or disrupted weeks.'],
    strengthsAr: ['تقلل المبالغة في التفكير بسبب نقص المعدات.', 'هيكل A/B يجعل التدرج واضحًا.', 'سهلة الاستمرار أثناء الأسابيع المزدحمة أو المضطربة.'],
    comparisonsEn: [{label: 'Versus Push Pull Legs', value: 'Much lower equipment demand, but less loading precision.'}, {label: 'Versus Bodyweight Conditioning', value: 'Better for hypertrophy because external load is easier to progress.'}],
    comparisonsAr: [{label: 'مقارنة بـ Push Pull Legs', value: 'تحتاج معدات أقل بكثير لكن بدقة تحميل أقل.'}, {label: 'مقارنة بـ Bodyweight Conditioning', value: 'أفضل للتضخيم لأن الحمل الخارجي أسهل في التطوير.'}],
    seoSummaryEn: 'A dumbbell-only workout system for home or travel with weekly structure and linked exercise recommendations.',
    seoSummaryAr: 'نظام تدريب بالدمبل فقط للبيت أو السفر مع هيكل أسبوعي وروابط تمارين موصى بها.',
  },
  'bodyweight-conditioning': {
    overviewEn: 'A repeatable bodyweight system for general fitness, endurance, and training with minimal setup.',
    overviewAr: 'نظام وزن جسم قابل للتكرار للياقة العامة والتحمل والتدريب بأقل تجهيز.',
    strengthsEn: ['Low setup friction makes consistency easier.', 'Improves conditioning and muscular endurance together.', 'Works as a bridge into more structured gym training.'],
    strengthsAr: ['قلة التجهيز تجعل الالتزام أسهل.', 'يحسن التحمل والقدرة العضلية معًا.', 'يعمل كجسر نحو تدريب جيم أكثر تنظيمًا.'],
    comparisonsEn: [{label: 'Versus Dumbbell Anywhere', value: 'Needs even less equipment, but progression is more limited.'}, {label: 'Versus Full Body', value: 'More conditioning-oriented and less strength-focused.'}],
    comparisonsAr: [{label: 'مقارنة بـ Dumbbell Anywhere', value: 'يحتاج معدات أقل لكن التدرج فيه محدود أكثر.'}, {label: 'مقارنة بـ Full Body', value: 'أكثر ميلًا للتحمل وأقل تركيزًا على القوة.'}],
    seoSummaryEn: 'A bodyweight workout system for fitness and conditioning with weekly structure and links to push, pull, core, and leg exercises.',
    seoSummaryAr: 'نظام وزن جسم للياقة والتحمل مع هيكل أسبوعي وروابط لتمارين الدفع والسحب والكور والرجل.',
  },
  'return-to-training': {
    overviewEn: 'A low-stress weekly template for rebuilding tolerance after layoffs, rehab phases, or fatigue spikes.',
    overviewAr: 'قالب أسبوعي منخفض الضغط لإعادة بناء التحمل بعد الانقطاع أو التأهيل أو ارتفاع الإجهاد.',
    strengthsEn: ['Keeps training density conservative.', 'Uses controlled, easy-to-autoregulate exercise choices.', 'Transitions smoothly into Full Body or Upper Lower later.'],
    strengthsAr: ['يحافظ على كثافة تدريبية محافظة.', 'يستخدم اختيارات حركة مضبوطة وسهلة الضبط الذاتي.', 'ينتقل بسلاسة لاحقًا إلى Full Body أو Upper Lower.'],
    comparisonsEn: [{label: 'Versus Full Body', value: 'Less ambitious, but often the smarter first step back.'}, {label: 'Versus Strength Triad', value: 'Far easier to tolerate and not built around heavy performance.'}],
    comparisonsAr: [{label: 'مقارنة بـ Full Body', value: 'أقل طموحًا لكنه غالبًا الخطوة الأذكى أولًا.'}, {label: 'مقارنة بـ Strength Triad', value: 'أسهل بكثير في التحمل وليس مبنيًا على الأداء الثقيل.'}],
    seoSummaryEn: 'A low-stress return to gym workout plan with controlled weekly structure, linked exercises, and clear comparisons.',
    seoSummaryAr: 'خطة عودة هادئة للجيم مع تنظيم أسبوعي مضبوط وروابط تمارين ومقارنات واضحة.',
  },
};

export function getExercisesForRegion(region: StaticMuscleSlug): Exercise[] {
  const allowed = new Set(STATIC_GROUP_MUSCLES[region]);
  return EXERCISES.filter((exercise) => allowed.has(exercise.mainMuscle));
}

export function getExerciseRegion(exercise: Exercise): StaticMuscleSlug {
  return MAIN_MUSCLE_TO_STATIC_GROUP[exercise.mainMuscle];
}

export function getSystemsForRegion(region: StaticMuscleSlug) {
  return TRAINING_SYSTEMS.filter((system) => system.muscleGroups.includes(region));
}

export function getSystemById(systemId: string) {
  return TRAINING_SYSTEMS.find((system) => system.id === systemId) ?? null;
}

export function getWeeklyPlanForSystem(systemId: string) {
  return WEEKLY_PLANS.find((plan) => plan.systemId === systemId) ?? null;
}

export function getRegionsForSystem(systemId: string) {
  return (getSystemById(systemId)?.muscleGroups ?? []).map((slug) => ({
    slug,
    labelEn: EXERCISE_FINDER_STATIC_LABELS[slug],
    labelAr: EXERCISE_FINDER_STATIC_ARABIC_LABELS[slug],
  }));
}
