const fs = require('fs');

// 1. The 107 Muscles with direct Wikimedia Commons image URLs
const musclesEmbedData = [
  {
    "id": "AN-001",
    "nameEn": "Sternocleidomastoid",
    "nameAr": "العضلة القترية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Sternocleidomastoideus.png/600px-Sternocleidomastoideus.png"
  },
  {
    "id": "AN-002",
    "nameEn": "Splenius Capitis",
    "nameAr": "العضلة الطاحلة الرأسية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Splenius_capitis.png/600px-Splenius_capitis.png"
  },
  {
    "id": "AN-003",
    "nameEn": "Splenius Cervicis",
    "nameAr": "العضلة الطاحلة العنقية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Splenius_cervicis.png/600px-Splenius_cervicis.png"
  },
  {
    "id": "AN-004",
    "nameEn": "Scalenus Anterior",
    "nameAr": "العضلة الأخمصية الأمامية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Scalenus_anterior.png/600px-Scalenus_anterior.png"
  },
  {
    "id": "AN-005",
    "nameEn": "Scalenus Medius",
    "nameAr": "العضلة الأخمصية المتوسطة",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Scalenus_medius.png/600px-Scalenus_medius.png"
  },
  {
    "id": "AN-006",
    "nameEn": "Scalenus Posterior",
    "nameAr": "العضلة الأخمصية الخلفية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Scalenus_posterior.png/600px-Scalenus_posterior.png"
  },
  {
    "id": "AN-007",
    "nameEn": "Longus Colli",
    "nameAr": "العضلة العنقية الطويلة",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Longus_colli.png/600px-Longus_colli.png"
  },
  {
    "id": "AN-008",
    "nameEn": "Longus Capitis",
    "nameAr": "العضلة الرأسية الطويلة",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Longus_capitis.png/600px-Longus_capitis.png"
  },
  {
    "id": "AN-009",
    "nameEn": "Rectus Capitis Anterior",
    "nameAr": "العضلة الرأسية المستقيمة الأمامية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Rectus_capitis_anterior.png/600px-Rectus_capitis_anterior.png"
  },
  {
    "id": "AN-010",
    "nameEn": "Rectus Capitis Lateralis",
    "nameAr": "العضلة الرأسية المستقيمة الوحشية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Rectus_capitis_lateralis.png/600px-Rectus_capitis_lateralis.png"
  },
  {
    "id": "AN-011",
    "nameEn": "Masseter",
    "nameAr": "العضلة المضغية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Masseter.png/600px-Masseter.png"
  },
  {
    "id": "AN-012",
    "nameEn": "Temporalis",
    "nameAr": "العضلة الصدغية",
    "region": "Head & Neck",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Temporalis.png/600px-Temporalis.png"
  },
  {
    "id": "AN-013",
    "nameEn": "Supraspinatus",
    "nameAr": "العضلة فوق الشوكة",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Supraspinatus.png/600px-Supraspinatus.png"
  },
  {
    "id": "AN-014",
    "nameEn": "Infraspinatus",
    "nameAr": "العضلة تحت الشوكة",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Infraspinatus.png/600px-Infraspinatus.png"
  },
  {
    "id": "AN-015",
    "nameEn": "Teres Minor",
    "nameAr": "العضلة المدورة الصغيرة",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Teres_minor.png/600px-Teres_minor.png"
  },
  {
    "id": "AN-016",
    "nameEn": "Subscapularis",
    "nameAr": "العضلة تحت الكتف",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Subscapularis.png/600px-Subscapularis.png"
  },
  {
    "id": "AN-017",
    "nameEn": "Anterior Deltoid",
    "nameAr": "العضلة الدالية الأمامية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png"
  },
  {
    "id": "AN-018",
    "nameEn": "Lateral Deltoid",
    "nameAr": "العضلة الدالية الجانبية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png"
  },
  {
    "id": "AN-019",
    "nameEn": "Posterior Deltoid",
    "nameAr": "العضلة الدالية الخلفية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png"
  },
  {
    "id": "AN-020",
    "nameEn": "Pectoralis Major",
    "nameAr": "العضلة الصدرية الكبرى",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Pectoralis_major.png/600px-Pectoralis_major.png"
  },
  {
    "id": "AN-021",
    "nameEn": "Pectoralis Minor",
    "nameAr": "العضلة الصدرية الصغرى",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Pectoralis_minor.png/600px-Pectoralis_minor.png"
  },
  {
    "id": "AN-022",
    "nameEn": "Subclavius",
    "nameAr": "العضلة تحت الترقوة",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Subclavius.png/600px-Subclavius.png"
  },
  {
    "id": "AN-023",
    "nameEn": "Serratus Anterior",
    "nameAr": "العضلة المنشارية الأمامية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Serratus_anterior.png/600px-Serratus_anterior.png"
  },
  {
    "id": "AN-024",
    "nameEn": "Latissimus Dorsi",
    "nameAr": "العضلة العريضة الظهرية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Latissimus_dorsi.png/600px-Latissimus_dorsi.png"
  },
  {
    "id": "AN-025",
    "nameEn": "Teres Major",
    "nameAr": "العضلة المدورة الكبيرة",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Teres_major.png/600px-Teres_major.png"
  },
  {
    "id": "AN-026",
    "nameEn": "Coracobrachialis",
    "nameAr": "العضلة الغرابية العضدية",
    "region": "Shoulder",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Coracobrachialis.png/600px-Coracobrachialis.png"
  },
  {
    "id": "AN-027",
    "nameEn": "Biceps Brachii Long Head",
    "nameAr": "عضلة البايسبس - الرأس الطويل",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png"
  },
  {
    "id": "AN-028",
    "nameEn": "Biceps Brachii Short Head",
    "nameAr": "عضلة البايسبس - الرأس القصير",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png"
  },
  {
    "id": "AN-029",
    "nameEn": "Brachialis",
    "nameAr": "العضلة العضدية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Brachialis.png/600px-Brachialis.png"
  },
  {
    "id": "AN-030",
    "nameEn": "Brachioradialis",
    "nameAr": "العضلة العضدية الكعبرية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Brachioradialis.png/600px-Brachioradialis.png"
  },
  {
    "id": "AN-031",
    "nameEn": "Triceps Long Head",
    "nameAr": "عضلة الترايسبس - الرأس الطويل",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png"
  },
  {
    "id": "AN-032",
    "nameEn": "Triceps Lateral Head",
    "nameAr": "عضلة الترايسبس - الرأس الوحشي",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png"
  },
  {
    "id": "AN-033",
    "nameEn": "Triceps Medial Head",
    "nameAr": "عضلة الترايسبس - الرأس الإنسي",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png"
  },
  {
    "id": "AN-034",
    "nameEn": "Anconeus",
    "nameAr": "العضلة المرفقية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Anconeus.png/600px-Anconeus.png"
  },
  {
    "id": "AN-035",
    "nameEn": "Pronator Teres",
    "nameAr": "العضلة الكابة المدورة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Pronator_teres.png/600px-Pronator_teres.png"
  },
  {
    "id": "AN-036",
    "nameEn": "Pronator Quadratus",
    "nameAr": "العضلة الكابة المربعة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Pronator_quadratus.png/600px-Pronator_quadratus.png"
  },
  {
    "id": "AN-037",
    "nameEn": "Supinator",
    "nameAr": "العضلة الباطحة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Supinator.png/600px-Supinator.png"
  },
  {
    "id": "AN-038",
    "nameEn": "Flexor Carpi Radialis",
    "nameAr": "العضلة قابضة الرسغ الكعبرية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Flexor_carpi_radialis.png/600px-Flexor_carpi_radialis.png"
  },
  {
    "id": "AN-039",
    "nameEn": "Flexor Carpi Ulnaris",
    "nameAr": "العضلة قابضة الرسغ الزندية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Flexor_carpi_ulnaris.png/600px-Flexor_carpi_ulnaris.png"
  },
  {
    "id": "AN-040",
    "nameEn": "Palmaris Longus",
    "nameAr": "العضلة الراحية الطويلة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Palmaris_longus.png/600px-Palmaris_longus.png"
  },
  {
    "id": "AN-041",
    "nameEn": "Extensor Carpi Radialis Longus",
    "nameAr": "العضلة باسطة الرسغ الكعبرية الطويلة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Extensor_carpi_radialis_longus.png/600px-Extensor_carpi_radialis_longus.png"
  },
  {
    "id": "AN-042",
    "nameEn": "Extensor Carpi Radialis Brevis",
    "nameAr": "العضلة باسطة الرسغ الكعبرية القصيرة",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Extensor_carpi_radialis_brevis.png/600px-Extensor_carpi_radialis_brevis.png"
  },
  {
    "id": "AN-043",
    "nameEn": "Extensor Carpi Ulnaris",
    "nameAr": "العضلة باسطة الرسغ الزندية",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Extensor_carpi_ulnaris.png/600px-Extensor_carpi_ulnaris.png"
  },
  {
    "id": "AN-044",
    "nameEn": "Extensor Digitorum",
    "nameAr": "العضلة باسطة الأصابع",
    "region": "Arm & Forearm",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Extensor_digitorum.png/600px-Extensor_digitorum.png"
  },
  {
    "id": "AN-045",
    "nameEn": "Rectus Abdominis",
    "nameAr": "العضلة البطنية المستقيمة",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Rectus_abdominis.png/600px-Rectus_abdominis.png"
  },
  {
    "id": "AN-046",
    "nameEn": "External Oblique",
    "nameAr": "العضلة المائلة الخارجية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/External_oblique.png/600px-External_oblique.png"
  },
  {
    "id": "AN-047",
    "nameEn": "Internal Oblique",
    "nameAr": "العضلة المائلة الداخلية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Internal_oblique.png/600px-Internal_oblique.png"
  },
  {
    "id": "AN-048",
    "nameEn": "Transverse Abdominis",
    "nameAr": "العضلة البطنية المستعرضة",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Transverse_abdominis.png/600px-Transverse_abdominis.png"
  },
  {
    "id": "AN-049",
    "nameEn": "Quadratus Lumborum",
    "nameAr": "العضلة المربعة القطنية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Quadratus_lumborum.png/600px-Quadratus_lumborum.png"
  },
  {
    "id": "AN-050",
    "nameEn": "Multifidus",
    "nameAr": "العضلة المتعددة الفصوص",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Multifidus.png/600px-Multifidus.png"
  },
  {
    "id": "AN-051",
    "nameEn": "Iliocostalis",
    "nameAr": "العضلة الحرقفية الضلعية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png"
  },
  {
    "id": "AN-052",
    "nameEn": "Longissimus",
    "nameAr": "العضلة الطولى الظهرية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png"
  },
  {
    "id": "AN-053",
    "nameEn": "Spinalis",
    "nameAr": "العضلة الشوكية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png"
  },
  {
    "id": "AN-054",
    "nameEn": "Rotatores",
    "nameAr": "العضلات المدوّرة للعمود الفقري",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Rotatores.png/600px-Rotatores.png"
  },
  {
    "id": "AN-055",
    "nameEn": "Interspinales",
    "nameAr": "العضلات بين الشوكية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Interspinales.png/600px-Interspinales.png"
  },
  {
    "id": "AN-056",
    "nameEn": "Intertransversarii",
    "nameAr": "العضلات بين المستعرضة",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Intertransversarii.png/600px-Intertransversarii.png"
  },
  {
    "id": "AN-057",
    "nameEn": "Diaphragm",
    "nameAr": "عضلة الحجاب الحاجز",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Diaphragm.png/600px-Diaphragm.png"
  },
  {
    "id": "AN-058",
    "nameEn": "Levator Ani",
    "nameAr": "العضلة الرافعة للشرج",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Levator_ani.png/600px-Levator_ani.png"
  },
  {
    "id": "AN-059",
    "nameEn": "Coccygeus",
    "nameAr": "العضلة العصعصية",
    "region": "Trunk & Core",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Coccygeus.png/600px-Coccygeus.png"
  },
  {
    "id": "AN-060",
    "nameEn": "Trapezius Upper",
    "nameAr": "العضلة الشبه منحرفة - العلوي",
    "region": "Trunk & Back",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Trapezius.png/600px-Trapezius.png"
  },
  {
    "id": "AN-061",
    "nameEn": "Gluteus Maximus",
    "nameAr": "العضلة الألية الكبرى",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Gluteus_maximus.png/600px-Gluteus_maximus.png"
  },
  {
    "id": "AN-062",
    "nameEn": "Gluteus Medius",
    "nameAr": "العضلة الألية المتوسطة",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Gluteus_medius.png/600px-Gluteus_medius.png"
  },
  {
    "id": "AN-063",
    "nameEn": "Gluteus Minimus",
    "nameAr": "العضلة الألية الصغرى",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Gluteus_minimus.png/600px-Gluteus_minimus.png"
  },
  {
    "id": "AN-064",
    "nameEn": "Tensor Fasciae Latae",
    "nameAr": "العضلة موترة اللفافة العريضة",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Tensor_fasciae_latae.png/600px-Tensor_fasciae_latae.png"
  },
  {
    "id": "AN-065",
    "nameEn": "Piriformis",
    "nameAr": "العضلة الكمثرية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Piriformis.png/600px-Piriformis.png"
  },
  {
    "id": "AN-066",
    "nameEn": "Obturator Internus",
    "nameAr": "العضلة السدادية الداخلية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Obturator_internus.png/600px-Obturator_internus.png"
  },
  {
    "id": "AN-067",
    "nameEn": "Obturator Externus",
    "nameAr": "العضلة السدادية الخارجية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Obturator_externus.png/600px-Obturator_externus.png"
  },
  {
    "id": "AN-068",
    "nameEn": "Gemellus Superior",
    "nameAr": "العضلة التوأمية العلوية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Gemellus_superior.png/600px-Gemellus_superior.png"
  },
  {
    "id": "AN-069",
    "nameEn": "Gemellus Inferior",
    "nameAr": "العضلة التوأمية السفلية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Gemellus_inferior.png/600px-Gemellus_inferior.png"
  },
  {
    "id": "AN-070",
    "nameEn": "Quadratus Femoris",
    "nameAr": "العضلة المربعة الفخذية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Quadratus_femoris.png/600px-Quadratus_femoris.png"
  },
  {
    "id": "AN-071",
    "nameEn": "Psoas Major",
    "nameAr": "العضلة القطنية الكبرى",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Psoas_major.png/600px-Psoas_major.png"
  },
  {
    "id": "AN-072",
    "nameEn": "Psoas Minor",
    "nameAr": "العضلة القطنية الصغرى",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Psoas_minor.png/600px-Psoas_minor.png"
  },
  {
    "id": "AN-073",
    "nameEn": "Iliacus",
    "nameAr": "العضلة الحرقفية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Iliacus.png/600px-Iliacus.png"
  },
  {
    "id": "AN-074",
    "nameEn": "Pectineus",
    "nameAr": "العضلة العانية",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png"
  },
  {
    "id": "AN-075",
    "nameEn": "Adductor Longus",
    "nameAr": "العضلة المقربة الطويلة",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Adductor_longus.png/600px-Adductor_longus.png"
  },
  {
    "id": "AN-076",
    "nameEn": "Adductor Brevis",
    "nameAr": "العضلة المقربة القصيرة",
    "region": "Hip & Pelvis",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Adductor_brevis.png/600px-Adductor_brevis.png"
  },
  {
    "id": "AN-077",
    "nameEn": "Adductor Magnus",
    "nameAr": "العضلة المقربة الكبيرة",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Adductor_magnus.png/600px-Adductor_magnus.png"
  },
  {
    "id": "AN-078",
    "nameEn": "Gracilis",
    "nameAr": "العضلة الرشيقة",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gracilis.png/600px-Gracilis.png"
  },
  {
    "id": "AN-079",
    "nameEn": "Sartorius",
    "nameAr": "العضلة الخياطية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Sartorius.png/600px-Sartorius.png"
  },
  {
    "id": "AN-080",
    "nameEn": "Rectus Femoris",
    "nameAr": "العضلة الفخذية المستقيمة",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png"
  },
  {
    "id": "AN-081",
    "nameEn": "Vastus Lateralis",
    "nameAr": "العضلة المتسعة الوحشية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Vastus_lateralis.png/600px-Vastus_lateralis.png"
  },
  {
    "id": "AN-082",
    "nameEn": "Vastus Medialis Oblique (VMO)",
    "nameAr": "العضلة المتسعة الإنسية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Vastus_medialis.png/600px-Vastus_medialis.png"
  },
  {
    "id": "AN-083",
    "nameEn": "Vastus Intermedius",
    "nameAr": "العضلة المتسعة المتوسطة",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Vastus_intermedius.png/600px-Vastus_intermedius.png"
  },
  {
    "id": "AN-084",
    "nameEn": "Biceps Femoris Long Head",
    "nameAr": "عضلة الفخذ الخلفية - الرأس الطويل",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png"
  },
  {
    "id": "AN-085",
    "nameEn": "Biceps Femoris Short Head",
    "nameAr": "عضلة الفخذ الخلفية - الرأس القصير",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png"
  },
  {
    "id": "AN-086",
    "nameEn": "Semitendinosus",
    "nameAr": "العضلة نصف الوترية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Semitendinosus.png/600px-Semitendinosus.png"
  },
  {
    "id": "AN-087",
    "nameEn": "Semimembranosus",
    "nameAr": "العضلة نصف الغشائية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Semimembranosus.png/600px-Semimembranosus.png"
  },
  {
    "id": "AN-088",
    "nameEn": "Popliteus",
    "nameAr": "العضلة المأبضية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Popliteus.png/600px-Popliteus.png"
  },
  {
    "id": "AN-089",
    "nameEn": "Plantaris",
    "nameAr": "العضلة الاخمصية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Plantaris.png/600px-Plantaris.png"
  },
  {
    "id": "AN-090",
    "nameEn": "Articularis Genus",
    "nameAr": "العضلة المفصلية للركبة",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png"
  },
  {
    "id": "AN-091",
    "nameEn": "Pectineus Minor",
    "nameAr": "العضلة العانية الفرعية",
    "region": "Thigh & Knee",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png"
  },
  {
    "id": "AN-092",
    "nameEn": "Tibialis Anterior",
    "nameAr": "العضلة القصبية الأمامية",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png"
  },
  {
    "id": "AN-093",
    "nameEn": "Tibialis Posterior",
    "nameAr": "العضلة القصبية الخلفية",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Tibialis_posterior.png/600px-Tibialis_posterior.png"
  },
  {
    "id": "AN-094",
    "nameEn": "Gastrocnemius Lateral Head",
    "nameAr": "عضلة السمانة - الرأس الوحشي",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png"
  },
  {
    "id": "AN-095",
    "nameEn": "Gastrocnemius Medial Head",
    "nameAr": "عضلة السمانة - الرأس الإنسي",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png"
  },
  {
    "id": "AN-096",
    "nameEn": "Soleus",
    "nameAr": "العضلة النعلية",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Soleus.png/600px-Soleus.png"
  },
  {
    "id": "AN-097",
    "nameEn": "Fibularis (Peroneus) Longus",
    "nameAr": "العضلة الشظوية الطويلة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Fibularis_longus.png/600px-Fibularis_longus.png"
  },
  {
    "id": "AN-098",
    "nameEn": "Fibularis (Peroneus) Brevis",
    "nameAr": "العضلة الشظوية القصيرة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Fibularis_brevis.png/600px-Fibularis_brevis.png"
  },
  {
    "id": "AN-099",
    "nameEn": "Fibularis (Peroneus) Tertius",
    "nameAr": "العضلة الشظوية الثالثة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png"
  },
  {
    "id": "AN-100",
    "nameEn": "Extensor Hallucis Longus",
    "nameAr": "العضلة باسطة إبهام القدم الطويلة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Extensor_hallucis_longus.png/600px-Extensor_hallucis_longus.png"
  },
  {
    "id": "AN-101",
    "nameEn": "Extensor Digitorum Longus",
    "nameAr": "العضلة باسطة أصابع القدم الطويلة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Extensor_digitorum_longus.png/600px-Extensor_digitorum_longus.png"
  },
  {
    "id": "AN-102",
    "nameEn": "Flexor Hallucis Longus",
    "nameAr": "العضلة قابضة إبهام القدم الطويلة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Flexor_hallucis_longus.png/600px-Flexor_hallucis_longus.png"
  },
  {
    "id": "AN-103",
    "nameEn": "Flexor Digitorum Longus",
    "nameAr": "العضلة قابضة أصابع القدم الطويلة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Flexor_digitorum_longus.png/600px-Flexor_digitorum_longus.png"
  },
  {
    "id": "AN-104",
    "nameEn": "Extensor Digitorum Brevis",
    "nameAr": "العضلة باسطة أصابع القدم القصيرة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Extensor_digitorum_brevis.png/600px-Extensor_digitorum_brevis.png"
  },
  {
    "id": "AN-105",
    "nameEn": "Flexor Digitorum Brevis",
    "nameAr": "العضلة قابضة أصابع القدم القصيرة",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Flexor_digitorum_brevis.png/600px-Flexor_digitorum_brevis.png"
  },
  {
    "id": "AN-106",
    "nameEn": "Abductor Hallucis",
    "nameAr": "العضلة مبعّدة إبهام القدم",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Abductor_hallucis.png/600px-Abductor_hallucis.png"
  },
  {
    "id": "AN-107",
    "nameEn": "Adductor Hallucis",
    "nameAr": "العضلة مقربة إبهام القدم",
    "region": "Leg & Ankle",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Adductor_hallucis.png/600px-Adductor_hallucis.png"
  }
];

fs.writeFileSync('json/body_iq_muscles_embed.json', JSON.stringify(musclesEmbedData, null, 2), 'utf8');
console.log('Successfully written json/body_iq_muscles_embed.json! Count:', musclesEmbedData.length);
