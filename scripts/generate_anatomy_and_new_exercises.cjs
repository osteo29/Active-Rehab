const fs = require('fs');

// 1. Read muscles_library.json
const rawMuscles = JSON.parse(fs.readFileSync('json/muscles_library.json', 'utf8')).muscles;

// Arabic translations & regions dictionary for the 107 muscles
const muscleMetadata = {
  // Rotator cuff & shoulder
  "supraspinatus": { ar: "العضلة فوق الشوكة", region: "shoulder" },
  "infraspinatus": { ar: "العضلة تحت الشوكة", region: "shoulder" },
  "teres-minor": { ar: "العضلة المدورة الصغيرة", region: "shoulder" },
  "subscapularis": { ar: "العضلة تحت اللوح", region: "shoulder" },
  "deltoid-anterior": { ar: "العضلة الدالية (الأمامية)", region: "shoulder" },
  "deltoid-lateral": { ar: "العضلة الدالية (الجانبية)", region: "shoulder" },
  "deltoid-posterior": { ar: "العضلة الدالية (الخلفية)", region: "shoulder" },
  "deltoid": { ar: "العضلة الدالية (الكتف)", region: "shoulder" },
  "teres-major": { ar: "العضلة المدورة الكبيرة", region: "shoulder" },
  "pectoralis-major-clavicular": { ar: "العضلة الصدرية الكبرى (الجزء الترقوي)", region: "chest" },
  "pectoralis-major-sternocostal": { ar: "العضلة الصدرية الكبرى (الجزء القصي)", region: "chest" },
  "pectoralis-major": { ar: "العضلة الصدرية الكبرى", region: "chest" },
  "pectoralis-minor": { ar: "العضلة الصدرية الصغرى", region: "chest" },
  "subclavius": { ar: "العضلة تحت الترقوة", region: "chest" },
  "serratus-anterior": { ar: "العضلة المنشارية الأمامية", region: "chest" },

  // Upper back & neck
  "trapezius-upper": { ar: "عضلة شبه المنحرف (العلوية)", region: "neck" },
  "trapezius-middle": { ar: "عضلة شبه المنحرف (الوسطى)", region: "spine_core" },
  "trapezius-lower": { ar: "عضلة شبه المنحرف (السفلية)", region: "spine_core" },
  "trapezius": { ar: "عضلة شبه المنحرف (الترابيس)", region: "spine_core" },
  "levator-scapulae": { ar: "العضلة الرافعة للكتف", region: "neck" },
  "rhomboid-major": { ar: "العضلة المعينية الكبرى", region: "spine_core" },
  "rhomboid-minor": { ar: "العضلة المعينية الصغرى", region: "spine_core" },
  "sternocleidomastoid": { ar: "العضلة القصية الترقوية الخشائية", region: "neck" },
  "scalenus-anterior": { ar: "العضلة الأخمعية الأمامية", region: "neck" },
  "scalenus-medius": { ar: "العضلة الأخمعية الوسطى", region: "neck" },
  "scalenus-posterior": { ar: "العضلة الأخمعية الخلفية", region: "neck" },
  "scalenes": { ar: "العضلات الأخمعية", region: "neck" },
  "longus-colli": { ar: "العضلة العنقية الطويلة", region: "neck" },
  "longus-capitis": { ar: "العضلة الرأسية الطويلة", region: "neck" },
  "suboccipitals": { ar: "عضلات تحت القذال", region: "neck" },

  // Back & Spine & Core
  "latissimus-dorsi": { ar: "العضلة الظهرية العريضة (اللور)", region: "spine_core" },
  "erector-spinae": { ar: "العضلة الناصبة للفقار", region: "spine_core" },
  "iliocostalis": { ar: "العضلة الحرقفية الضلعية", region: "spine_core" },
  "longissimus": { ar: "العضلة الطولى الظهرية", region: "spine_core" },
  "spinalis": { ar: "العضلة الشوكية", region: "spine_core" },
  "multifidus": { ar: "العضلة متعددة الفلوق (العامود الفقري)", region: "spine_core" },
  "quadratus-lumborum": { ar: "العضلة المربعة القطنية", region: "spine_core" },
  "rectus-abdominis": { ar: "العضلة المستقيمة البطنية (عضلات البطن)", region: "spine_core" },
  "transversus-abdominis": { ar: "العضلة البطنية المستعرضة", region: "spine_core" },
  "external-oblique": { ar: "العضلة المائلة الخارجية", region: "spine_core" },
  "internal-oblique": { ar: "العضلة المائلة الداخلية", region: "spine_core" },
  "diaphragm": { ar: "عضلة الحجاب الحاجز", region: "spine_core" },

  // Arm & Forearm & Hand
  "biceps-brachii": { ar: "العضلة العضدية ذات الرأسين (البايسبس)", region: "arm" },
  "biceps-long-head": { ar: "البايسبس (الرأس الطويل)", region: "arm" },
  "biceps-short-head": { ar: "البايسبس (الرأس القصير)", region: "arm" },
  "brachialis": { ar: "العضلة العضدية", region: "arm" },
  "brachioradialis": { ar: "العضلة العضدية الكعبرية", region: "arm" },
  "coracobrachialis": { ar: "العضلة الغرابية العضدية", region: "arm" },
  "triceps-brachii": { ar: "العضلة ذات الرؤوس الثلاثة (الترايسبس)", region: "arm" },
  "triceps-long-head": { ar: "الترايسبس (الرأس الطويل)", region: "arm" },
  "triceps-lateral-head": { ar: "الترايسبس (الرأس الوحشي)", region: "arm" },
  "triceps-medial-head": { ar: "الترايسبس (الرأس الإنسي)", region: "arm" },
  "anconeus": { ar: "العضلة المرفقية", region: "arm" },
  "pronator-teres": { ar: "العضلة الكابة المدورة", region: "arm" },
  "pronator-quadratus": { ar: "العضلة الكابة المربعة", region: "arm" },
  "supinator": { ar: "العضلة الباطحة (الاستلقائية)", region: "arm" },
  "flexor-carpi-radialis": { ar: "قابضة الرسغ الكعبرية", region: "arm" },
  "flexor-carpi-ulnaris": { ar: "قابضة الرسغ الزندية", region: "arm" },
  "extensor-carpi-radialis-longus": { ar: "باسطة الرسغ الكعبرية الطويلة", region: "arm" },
  "extensor-carpi-radialis-brevis": { ar: "باسطة الرسغ الكعبرية القصيرة", region: "arm" },
  "extensor-carpi-ulnaris": { ar: "باسطة الرسغ الزندية", region: "arm" },
  "flexor-digitorum-superficialis": { ar: "قابضة الأصابع السطحية", region: "arm" },
  "flexor-digitorum-profundus": { ar: "قابضة الأصابع العميقة", region: "arm" },
  "extensor-digitorum": { ar: "باسطة الأصابع المشتركة", region: "arm" },
  "flexor-pollicis-longus": { ar: "قابضة الإبهام الطويلة", region: "arm" },
  "extensor-pollicis-longus": { ar: "باسطة الإبهام الطويلة", region: "arm" },
  "extensor-pollicis-brevis": { ar: "باسطة الإبهام القصيرة", region: "arm" },
  "abductor-pollicis-longus": { ar: "مبعدة الإبهام الطويلة", region: "arm" },
  "abductor-pollicis-brevis": { ar: "مبعدة الإبهام القصيرة", region: "arm" },
  "adductor-pollicis": { ar: "مقربة الإبهام", region: "arm" },
  "opponens-pollicis": { ar: "العضلة المقابلة للإبهام", region: "arm" },
  "lumbricals-hand": { ar: "العضلات الخراطينية لليد", region: "arm" },
  "interossei-dorsal-hand": { ar: "العضلات بين العظام الظهرية لليد", region: "arm" },
  "interossei-palmar": { ar: "العضلات بين العظام الراحية", region: "arm" },

  // Pelvis & Hip
  "gluteus-maximus": { ar: "العضلة الأليوية الكبرى (الجلوتس)", region: "hip_pelvis" },
  "gluteus-medius": { ar: "العضلة الأليوية الوسطى", region: "hip_pelvis" },
  "gluteus-minimus": { ar: "العضلة الأليوية الصغرى", region: "hip_pelvis" },
  "tensor-fasciae-latae": { ar: "موترة اللفافة العريضة (TFL)", region: "hip_pelvis" },
  "piriformis": { ar: "العضلة الكمثرية", region: "hip_pelvis" },
  "obturator-internus": { ar: "العضلة السدادية الباطنة", region: "hip_pelvis" },
  "obturator-externus": { ar: "العضلة السدادية الظاهرة", region: "hip_pelvis" },
  "gemellus-superior": { ar: "العضلة التوأمية العلوية", region: "hip_pelvis" },
  "gemellus-inferior": { ar: "العضلة التوأمية السفلية", region: "hip_pelvis" },
  "quadratus-femoris": { ar: "العضلة المربعة الفخذية", region: "hip_pelvis" },
  "iliopsoas": { ar: "العضلة الحرقفية القطنية (عضلة الورك)", region: "hip_pelvis" },
  "psoas-major": { ar: "العضلة القطنية الكبيرة", region: "hip_pelvis" },
  "iliacus": { ar: "العضلة الحرقفية", region: "hip_pelvis" },
  "pectineus": { ar: "العضلة العانية", region: "hip_pelvis" },
  "adductor-longus": { ar: "العضلة المقربة الطويلة", region: "hip_pelvis" },
  "adductor-brevis": { ar: "العضلة المقربة القصيرة", region: "hip_pelvis" },
  "adductor-magnus": { ar: "العضلة المقربة الكبيرة", region: "hip_pelvis" },
  "gracilis": { ar: "العضلة الرشيقة", region: "hip_pelvis" },

  // Knee & Thigh
  "quadriceps": { ar: "العضلة الفخذية ذات الرؤوس الأربعة", region: "knee_thigh" },
  "rectus-femoris": { ar: "العضلة المستقيمة الفخذية", region: "knee_thigh" },
  "vastus-medialis": { ar: "العضلة المتسعة الإنسية (VMO)", region: "knee_thigh" },
  "vastus-lateralis": { ar: "العضلة المتسعة الوحشية", region: "knee_thigh" },
  "vastus-intermedius": { ar: "العضلة المتسعة المتوسطة", region: "knee_thigh" },
  "sartorius": { ar: "العضلة الخياطية", region: "knee_thigh" },
  "hamstrings": { ar: "عضلات الفخذ الخلفية (الهامسترنج)", region: "knee_thigh" },
  "biceps-femoris-long-head": { ar: "العضلة الفخذية ذات الرأسين (الرأس الطويل)", region: "knee_thigh" },
  "biceps-femoris-short-head": { ar: "العضلة الفخذية ذات الرأسين (الرأس القصير)", region: "knee_thigh" },
  "biceps-femoris": { ar: "العضلة ذات الرأسين الفخذية", region: "knee_thigh" },
  "semitendinosus": { ar: "العضلة نصف الوترية", region: "knee_thigh" },
  "semimembranosus": { ar: "العضلة نصف الغشائية", region: "knee_thigh" },
  "popliteus": { ar: "العضلة المأبضية (خلف الركبة)", region: "knee_thigh" },

  // Leg & Ankle & Foot
  "tibialis-anterior": { ar: "العضلة الظنبوبية الأمامية", region: "ankle_foot" },
  "extensor-hallucis-longus": { ar: "باسطة إبهام القدم الطويلة", region: "ankle_foot" },
  "extensor-digitorum-longus": { ar: "باسطة أصابع القدم الطويلة", region: "ankle_foot" },
  "peroneus-longus": { ar: "العضلة الشظوية الطويلة", region: "ankle_foot" },
  "peroneus-brevis": { ar: "العضلة الشظوية القصيرة", region: "ankle_foot" },
  "peroneus-tertius": { ar: "العضلة الشظوية الثالثة", region: "ankle_foot" },
  "gastrocnemius": { ar: "عضلة الساق التوأمية (السمانة)", region: "ankle_foot" },
  "gastrocnemius-medial": { ar: "السمانة (الرأس الإنسي)", region: "ankle_foot" },
  "gastrocnemius-lateral": { ar: "السمانة (الرأس الوحشي)", region: "ankle_foot" },
  "soleus": { ar: "العضلة النعلية", region: "ankle_foot" },
  "plantaris": { ar: "العضلة الأخمصية", region: "ankle_foot" },
  "tibialis-posterior": { ar: "العضلة الظنبوبية الخلفية", region: "ankle_foot" },
  "flexor-hallucis-longus": { ar: "قابضة إبهام القدم الطويلة", region: "ankle_foot" },
  "flexor-digitorum-longus": { ar: "قابضة أصابع القدم الطويلة", region: "ankle_foot" },
  "abductor-hallucis": { ar: "مبعدة إبهام القدم", region: "ankle_foot" },
  "flexor-digitorum-brevis": { ar: "قابضة الأصابع القصيرة للقدم", region: "ankle_foot" },
  "lumbricals-foot": { ar: "العضلات الخراطينية للقدم", region: "ankle_foot" }
};

// Build enriched muscles object
const enrichedMuscles = {};
for (const [slug, def] of Object.entries(rawMuscles)) {
  const meta = muscleMetadata[slug] || { ar: def.name, region: "other" };
  enrichedMuscles[slug] = {
    slug,
    name: def.name,
    name_ar: meta.ar,
    region: meta.region,
    description: def.description || "",
    origin: def.origin || "",
    insertion: def.insertion || "",
    action: def.action || "",
    innervation: def.innervation || "",
    blood_supply: def.blood_supply || ""
  };
}

fs.writeFileSync('json/muscles_library.json', JSON.stringify({
  version: "2.0.0",
  total_muscles: Object.keys(enrichedMuscles).length,
  muscles: enrichedMuscles
}, null, 2));

console.log('Successfully enriched json/muscles_library.json with Arabic names and regions!');
console.log('Total muscles:', Object.keys(enrichedMuscles).length);
