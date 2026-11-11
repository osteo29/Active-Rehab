import type {StaticMuscleSlug} from './types';

export const SEO_INTROS: Record<
  StaticMuscleSlug | 'general',
  {
    titleEn: string;
    titleAr: string;
    bodyEn: string;
    bodyAr: string;
  }
> = {
  general: {
    titleEn: 'Gym exercise finder for muscle-focused training',
    titleAr: 'دليل تمارين جيم مخصص لاستهداف العضلات',
    bodyEn:
      'Use this exercise finder to discover gym exercises by muscle group, sub-muscle, equipment, level, and training goal. It helps users understand what each region does, why a movement is useful for strength or muscle gain, and how to pick safer exercise options when rebuilding after pain, stiffness, or time away from training.',
    bodyAr:
      'استخدم دليل التمارين ده لاكتشاف تمارين الجيم حسب العضلة الأساسية، العضلة الفرعية، المعدات، المستوى، وهدف التمرين. الصفحة كمان بتساعدك تفهم وظيفة كل منطقة، وفائدة كل تمرين للقوة أو الضخامة، وإزاي تختار خيارات أكثر أمانًا لو كنت راجع من ألم أو تيبّس أو فترة انقطاع.',
  },
  chest: {
    titleEn: 'Chest exercises for upper, middle, and lower chest training',
    titleAr: 'تمارين صدر لاستهداف أعلى ووسط وأسفل الصدر',
    bodyEn:
      'Browse chest exercises for upper chest, middle chest, and lower chest development with options for dumbbells, barbells, bodyweight, and machines. This section explains how pressing patterns support chest size and pushing strength, and it also helps users returning from shoulder irritation choose more controlled chest-training options.',
    bodyAr:
      'استعرض تمارين الصدر لاستهداف الجزء العلوي والوسط والسفلي مع خيارات بالدمبل والبار ووزن الجسم والأجهزة. الجزء ده يوضح كيف تخدم تمارين الضغط بناء الصدر وقوة الدفع، ويساعد أيضًا من يعود من تهيج الكتف على اختيار بدائل أكثر تحكمًا.',
  },
  back: {
    titleEn: 'Back exercises for lats, traps, rhomboids, and lower back',
    titleAr: 'تمارين ظهر للاتس والترابيس والرومبويد وأسفل الظهر',
    bodyEn:
      'Find back exercises for width, thickness, posture, and pulling strength. The page covers lats, traps, rhomboids, and spinal erectors so users can build a stronger back using bodyweight, dumbbells, barbells, bands, or machines, with useful options for people who need better posture or a gradual return after low-back or neck tension.',
    bodyAr:
      'اعثر على تمارين ظهر مناسبة للعرض والسماكة والقوة ووضعية الجسم. الصفحة تغطي اللاتس والترابيس والرومبويد وعضلات أسفل الظهر لمساعدة المستخدم على بناء ظهر أقوى باستخدام وزن الجسم أو الدمبل أو البار أو الأجهزة، مع خيارات مفيدة لتحسين القوام أو العودة التدريجية بعد شد أسفل الظهر أو الرقبة.',
  },
  shoulders: {
    titleEn: 'Shoulder exercises for front, side, and rear delts',
    titleAr: 'تمارين كتف للجزء الأمامي والجانبي والخلفي',
    bodyEn:
      'Explore shoulder exercises for front delts, side delts, and rear delts with a mix of presses, raises, and shoulder-friendly strength work. It is useful for balanced shoulder development, scapular control, and users who need smarter exercise choices after overhead pain or limited range of motion.',
    bodyAr:
      'استكشف تمارين الكتف للجزء الأمامي والجانبي والخلفي مع خليط من الضغط والرفرفة وتمارين قوة مناسبة للكتف. هذا مفيد لبناء كتف متوازن وتحسين التحكم بلوح الكتف، خاصة لمن يحتاج اختيارات أذكى بعد ألم الرفع فوق الرأس أو محدودية المدى الحركي.',
  },
  arms: {
    titleEn: 'Arm exercises for biceps, triceps, and forearms',
    titleAr: 'تمارين ذراع للبايسبس والترايسبس والساعد',
    bodyEn:
      'Review arm exercises that target biceps, triceps, and forearms through direct isolation work and compound pulling or pressing patterns. This section is designed for users comparing arm-day options, improving grip and elbow comfort, and choosing accessory work that supports bigger lifts without unnecessary joint stress.',
    bodyAr:
      'راجع تمارين الذراع التي تستهدف البايسبس والترايسبس والساعد من خلال تمارين عزل مباشرة وتمارين مركبة للسحب والدفع. هذا القسم مناسب لمن يقارن بين اختيارات arm day، أو يريد تحسين القبضة وراحة الكوع، أو اختيار تمارين إكسسوري تدعم التمارين الكبرى بدون ضغط مفصلي زائد.',
  },
  core: {
    titleEn: 'Core exercises for abs, obliques, and lower back',
    titleAr: 'تمارين كور للبطن والخواصر وأسفل الظهر',
    bodyEn:
      'Find core exercises for abs, obliques, and lower back stability with options that support trunk strength, control, and endurance. These exercises fit users who want athletic core work instead of random ab routines, and they are especially useful when rebuilding trunk control after low-back discomfort or poor bracing habits.',
    bodyAr:
      'اعثر على تمارين كور للبطن والخواصر وأسفل الظهر مع خيارات تدعم الثبات والقوة والتحمل. التمارين هنا مناسبة لمن يريد عملًا رياضيًا مفيدًا للجذع بدل روتين بطن عشوائي، وهي مفيدة أيضًا لاستعادة التحكم بعد انزعاج أسفل الظهر أو ضعف الثبات.',
  },
  legs: {
    titleEn: 'Leg exercises for glutes, quads, hamstrings, and calves',
    titleAr: 'تمارين رجل للجلووتس والكوادز والهامسترينج والسمانة',
    bodyEn:
      'Browse leg exercises for glutes, quadriceps, hamstrings, and calves with options for strength blocks, hypertrophy work, and lower-body endurance. This section helps users plan full leg sessions based on their equipment and experience, while also highlighting smarter lower-body choices when returning after knee stiffness, hip weakness, or ankle limitation.',
    bodyAr:
      'استعرض تمارين الرجل للجلووتس والكوادز والهامسترينج والسمانة مع خيارات للقوة والضخامة والتحمل. هذا القسم يساعد المستخدم على تخطيط يوم رجل كامل حسب المعدات والخبرة، مع الإشارة أيضًا لاختيارات أذكى عند العودة بعد تيبس الركبة أو ضعف الورك أو محدودية الكاحل.',
  },
  biceps: {
    titleEn: 'Biceps exercises for arm growth and pulling support',
    titleAr: 'تمارين بايسبس للنمو ودعم السحب',
    bodyEn: 'Compare biceps exercises for arm size, elbow flexion strength, and smarter accessory work around pull sessions.',
    bodyAr: 'قارن بين تمارين البايسبس لتحسين الحجم والقوة وتمارين الإكسسوري حول أيام السحب.',
  },
  triceps: {
    titleEn: 'Triceps exercises for pressing strength and arm size',
    titleAr: 'تمارين ترايسبس للقوة والحجم',
    bodyEn: 'Review triceps exercises that improve pressing power, lockout strength, and arm development with cable, dumbbell, and bodyweight options.',
    bodyAr: 'راجع تمارين الترايسبس التي تحسن قوة الدفع واللوك آوت وتطور حجم الذراع مع خيارات متنوعة.',
  },
  forearms: {
    titleEn: 'Forearm exercises for grip, wrist control, and arm balance',
    titleAr: 'تمارين ساعد للقبضة وثبات الرسغ',
    bodyEn: 'Find forearm exercises for grip strength, wrist control, and balanced arm training using simple equipment.',
    bodyAr: 'اعثر على تمارين الساعد لتحسين قوة القبضة وثبات الرسغ وتوازن تدريب الذراع باستخدام معدات بسيطة.',
  },
  abs: {
    titleEn: 'Abs exercises for trunk control and midline strength',
    titleAr: 'تمارين بطن للتحكم والقوة',
    bodyEn: 'Explore abs exercises that build trunk control and midline strength with practical progressions.',
    bodyAr: 'استكشف تمارين البطن التي تبني التحكم في الجذع وقوة المنتصف بتدرج عملي.',
  },
  obliques: {
    titleEn: 'Oblique exercises for rotation control and side core strength',
    titleAr: 'تمارين خواصر للتحكم والدعم الجانبي',
    bodyEn: 'Browse oblique exercises that improve anti-rotation control, side-core strength, and athletic trunk stability.',
    bodyAr: 'تصفح تمارين الخواصر التي تحسن التحكم ضد الدوران والقوة الجانبية وثبات الجذع.',
  },
  lower_back: {
    titleEn: 'Lower back exercises for spinal support and hip hinge strength',
    titleAr: 'تمارين أسفل الظهر للدعم والقوة',
    bodyEn: 'Review lower back exercises that support hip hinge mechanics, trunk endurance, and posterior-chain control.',
    bodyAr: 'راجع تمارين أسفل الظهر التي تدعم ميكانيكا الهيب هنج وتحمل الجذع والتحكم في السلسلة الخلفية.',
  },
  glutes: {
    titleEn: 'Glute exercises for strength, power, and hip stability',
    titleAr: 'تمارين جلووتس للقوة والثبات',
    bodyEn: 'Find glute exercises for hip extension strength, stability, and lower-body performance.',
    bodyAr: 'اعثر على تمارين الجلووتس لتحسين قوة مد الحوض والثبات وأداء الجزء السفلي.',
  },
  quadriceps: {
    titleEn: 'Quadriceps exercises for knee-dominant leg strength',
    titleAr: 'تمارين كوادز لقوة الجزء الأمامي',
    bodyEn: 'Compare quadriceps exercises for knee-dominant strength, hypertrophy, and leg-day volume.',
    bodyAr: 'قارن بين تمارين الكوادز لبناء القوة والضخامة وحجم التدريب في يوم الرجل.',
  },
  hamstrings: {
    titleEn: 'Hamstring exercises for posterior-chain strength and control',
    titleAr: 'تمارين هامسترينج للقوة والتحكم الخلفي',
    bodyEn: 'Browse hamstring exercises for posterior-chain strength, sprint support, and hip hinge control.',
    bodyAr: 'تصفح تمارين الهامسترينج لتحسين قوة السلسلة الخلفية ودعم السرعة والتحكم في الهيب هنج.',
  },
  calves: {
    titleEn: 'Calf exercises for ankle strength, stiffness, and lower-leg development',
    titleAr: 'تمارين سمانة للقوة والتطور العضلي',
    bodyEn: 'Review calf exercises that improve ankle strength, stiffness, and lower-leg development for gym and sport.',
    bodyAr: 'راجع تمارين السمانة لتحسين قوة الكاحل والتطور العضلي ودعم الأداء الرياضي.',
  },
  neck: {
    titleEn: 'Neck rehab exercises for posture, shoulder-blade control, and training tolerance',
    titleAr: 'تمارين تأهيل الرقبة لتحسين الوضعية والتحمل',
    bodyEn:
      'Find neck-friendly exercise options that emphasize posture, scapular control, and gradual return to training without forcing high-irritation shrugging or loaded neck work. These drills are useful when neck symptoms are linked to desk posture, upper-trap dominance, or returning to pulling days after flare-ups.',
    bodyAr:
      'اعثر على خيارات مناسبة لتأهيل الرقبة تركّز على الوضعية والتحكم في لوح الكتف والعودة التدريجية للتدريب دون فرض تمارين مزعجة أو تحميل مباشر زائد على الرقبة. هذه الخيارات مفيدة عندما تكون الأعراض مرتبطة بوضعية الجلوس أو سيطرة الترابيس العلوية أو العودة ليوم السحب بعد نوبات تهيج.',
  },
  hip: {
    titleEn: 'Hip rehab exercises for pelvic control, glute strength, and return to movement',
    titleAr: 'تمارين تأهيل الورك للتحكم الحركي والعودة للحركة',
    bodyEn:
      'Browse hip rehab exercise options built around glute strength, pelvic control, split-stance work, and safe progressions for rebuilding lower-body confidence. This page is useful for users managing hip stiffness, weak single-leg control, or gradual return after groin, glute, or lateral-hip irritation.',
    bodyAr:
      'تصفح خيارات تأهيل الورك المبنية على قوة الجلوتس والتحكم في الحوض والعمل الأحادي والتدرج الآمن لاستعادة الثقة في الجزء السفلي. الصفحة مفيدة لمن يدير تيبس الورك أو ضعف الاتزان على رجل واحدة أو العودة التدريجية بعد تهيج المغبن أو الجلوتس أو جانب الورك.',
  },
  'wrist-rehab': {
    titleEn: 'Wrist rehab exercises for grip tolerance, control, and gradual loading',
    titleAr: 'تمارين تأهيل الرسغ لتحمل القبضة والتحميل التدريجي',
    bodyEn:
      'Explore wrist rehab exercise options that support grip tolerance, forearm strength, and controlled loading so users can return to pressing, carrying, and pulling more comfortably. They are especially relevant after overuse from push-ups, heavy curls, gripping fatigue, or long breaks that reduce wrist tolerance.',
    bodyAr:
      'استكشف خيارات تأهيل الرسغ التي تدعم تحمل القبضة وقوة الساعد والتحميل المضبوط حتى يتمكن المستخدم من العودة للضغط والحمل والسحب براحة أكبر. وهي مفيدة خصوصًا بعد الإجهاد الزائد من الضغط الأرضي أو الكيرلز الثقيلة أو إرهاق القبضة أو فترات الانقطاع التي تقلل تحمل الرسغ.',
  },
  'full-body-rehab': {
    titleEn: 'Full-body rehab exercises for controlled return to training',
    titleAr: 'تمارين تأهيل الجسم بالكامل للعودة التدريجية للتدريب',
    bodyEn:
      'Review full-body rehab exercise options that reconnect trunk control, lower-body support, shoulder function, and low-cost conditioning in a manageable weekly flow. This section is built for users returning after layoffs, multi-area stiffness, or deconditioning who need a complete but conservative weekly structure.',
    bodyAr:
      'راجع خيارات تأهيل الجسم بالكامل التي تعيد ربط التحكم في الجذع ودعم الجزء السفلي ووظيفة الكتف والتحمل الخفيف ضمن تدفق أسبوعي يمكن الالتزام به. هذا القسم مناسب لمن يعود بعد انقطاع طويل أو تيبس في أكثر من منطقة أو تراجع عام في اللياقة ويحتاج هيكلًا محافظًا لكن متكاملًا.',
  },
};
