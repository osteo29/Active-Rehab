-- Migration: 20260526000900_add_anatomy_and_bodyiq_exercises.sql
-- Description: Adds anatomy_muscles, exercise_muscle_links, and seeds 107 muscles + Body IQ exercises into Supabase

begin;

-- 1. Create anatomy_muscles table
create table if not exists public.anatomy_muscles (
  slug text primary key,
  name_en text not null,
  name_ar text not null,
  region text not null,
  description text,
  origin text,
  insertion text,
  action text,
  innervation text,
  blood_supply text,
  created_at timestamptz not null default now()
);

alter table public.anatomy_muscles enable row level security;
grant select on table public.anatomy_muscles to anon, authenticated;

drop policy if exists "anatomy_muscles_read" on public.anatomy_muscles;
create policy "anatomy_muscles_read" on public.anatomy_muscles for select using (true);

-- 2. Create exercise_muscle_links table
create table if not exists public.exercise_muscle_links (
  id uuid primary key default gen_random_uuid(),
  exercise_id text not null,
  muscle_slug text not null references public.anatomy_muscles(slug) on delete cascade,
  role text not null check (role in ('primary', 'stabilizer', 'synergist')),
  created_at timestamptz not null default now(),
  unique(exercise_id, muscle_slug, role)
);

alter table public.exercise_muscle_links enable row level security;
grant select on table public.exercise_muscle_links to anon, authenticated;

drop policy if exists "exercise_muscle_links_read" on public.exercise_muscle_links;
create policy "exercise_muscle_links_read" on public.exercise_muscle_links for select using (true);

-- 3. Seed anatomy_muscles
insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-pollicis-longus', 'Flexor Pollicis Longus', 'قابضة الإبهام الطويلة', 'arm', null, 'Anterior surface of radius, interosseous membrane', 'Base of distal phalanx of thumb', 'Flexion of thumb IP joint, assists thumb MCP flexion', 'Anterior interosseous nerve (C7, C8)', 'Anterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('adductor-pollicis', 'Adductor Pollicis', 'مقربة الإبهام', 'arm', null, 'Oblique head: capitate, 2nd-3rd metacarpal bases; Transverse head: 3rd metacarpal shaft', 'Medial side of proximal phalanx of thumb via medial sesamoid', 'Thumb adduction, assists thumb flexion at MCP', 'Ulnar nerve, deep branch (C8, T1)', 'Deep palmar arch')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('latissimus-dorsi', 'Latissimus Dorsi', 'العضلة الظهرية العريضة (اللور)', 'spine_core', null, 'Spinous processes T7-L5, posterior iliac crest, thoracolumbar fascia, inferior angle of scapula', 'Floor of bicipital groove of humerus', 'Extension, adduction, internal rotation; depressor (particularly during abduction)', 'Thoracodorsal nerve (C6-C8)', 'Thoracodorsal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('levator-scapulae', 'Levator Scapulae', 'العضلة الرافعة للكتف', 'neck', null, 'Posterior tubercles of C1-C4 transverse processes', 'Superior angle and medial border of scapula', 'Scapular elevation; assists cervical lateral flexion and rotation', 'Dorsal scapular nerve (C5) and direct branches from C3-C4 cervical plexus', 'Dorsal scapular artery, transverse cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('rectus-femoris', 'Rectus Femoris', 'العضلة المستقيمة الفخذية', 'knee_thigh', null, 'Anterior inferior iliac spine (straight head) and ilium above acetabulum (reflected head)', 'Patella via quadriceps tendon, then tibial tuberosity via patellar ligament', 'Knee extension, hip flexion', 'Femoral nerve (L2-L4)', 'Lateral femoral circumflex artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('diaphragm', 'Diaphragm', 'عضلة الحجاب الحاجز', 'spine_core', null, 'Xiphoid process, costal cartilages of ribs 7-12, lumbar vertebrae (crura attach to L1-L3)', 'Central tendon', 'Respiration (primary), increases intra-abdominal pressure, contributes to spinal stabilization by increasing intervertebral stiffness', 'Phrenic nerve (C3-C5)', 'Phrenic arteries, musculophrenic arteries, lower posterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('vastus-lateralis', 'Vastus Lateralis', 'العضلة المتسعة الوحشية', 'knee_thigh', null, 'Lateral lip of linea aspera, greater trochanter, intertrochanteric line', 'Patella (lateral aspect) via quadriceps tendon; consists of superficial, intermediate, and deep layers', 'Knee extension; acts as general joint stabilizer with activation independent of moment direction', 'Femoral nerve (L2-L4)', 'Lateral femoral circumflex artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('sternocleidomastoid', 'Sternocleidomastoid', 'العضلة القصية الترقوية الخشائية', 'neck', null, 'Sternal head: manubrium; Clavicular head: medial third of clavicle', 'Mastoid process, superior nuchal line', 'Bilateral: cervical flexion; Unilateral: ipsilateral lateral flexion, contralateral rotation', 'Cranial nerve XI (spinal accessory nerve) with contributions from C2-C3', 'Superior thyroid artery, occipital artery, suprascapular artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-carpi-ulnaris', 'Flexor Carpi Ulnaris', 'قابضة الرسغ الزندية', 'arm', null, 'Medial epicondyle (humeral head), olecranon and posterior ulna (ulnar head)', 'Pisiform, hook of hamate, base of 5th metacarpal', 'Wrist flexion, ulnar deviation', 'Ulnar nerve (C7, C8)', 'Ulnar artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('infraspinatus', 'Infraspinatus', 'العضلة تحت الشوكة', 'shoulder', null, 'Infraspinous fossa of scapula', 'Greater tuberosity of humerus (middle facet)', 'External rotation, horizontal extension; arm elevation (particularly in posterior planes)', 'Suprascapular nerve (C5-C6)', 'Suprascapular artery, posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('supinator', 'Supinator', 'العضلة الباطحة (الاستلقائية)', 'arm', null, 'Lateral epicondyle of humerus, supinator crest of ulna', 'Lateral surface of proximal radius', 'Forearm supination', 'Deep branch of radial nerve (C5, C6)', 'Radial recurrent artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('adductor-magnus', 'Adductor Magnus', 'العضلة المقربة الكبيرة', 'hip_pelvis', null, 'Adductor portion: inferior pubic ramus and ischial ramus; Hamstring portion: ischial tuberosity', 'Adductor portion: linea aspera; Hamstring portion: adductor tubercle of femur', 'Adduction; adductor portion also flexes and internally rotates; hamstring portion extends and externally rotates', 'Dual innervation: adductor portion receives both posterior branch of obturator nerve (L2-L4) and tibial portion of sciatic nerve (L4-S1) in >90% of cases; hamstring portion receives tibial nerve', 'Medial circumflex femoral artery, perforating branches of profunda femoris')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('suboccipitals', 'Suboccipital Muscles', 'عضلات تحت القذال', 'neck', null, 'Rectus capitis posterior major: spinous process of C2; Rectus capitis posterior minor: posterior tubercle of C1; Obliquus capitis superior: transverse process of C1; Obliquus capitis inferior: spinous process of C2', 'Rectus major: lateral inferior nuchal line; Rectus minor: medial inferior nuchal line; Obliquus superior: between superior and inferior nuchal lines; Obliquus inferior: transverse process of C1', 'Extension of head (all except obliquus inferior); ipsilateral rotation (rectus major, obliquus inferior â€” obliquus inferior accounts for ~70% of C1-C2 rotation); lateral flexion (obliquus superior); proprioceptive feedback for head position', 'Suboccipital nerve (dorsal ramus of C1) for all four muscles', 'Muscular branches of vertebral and occipital arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('quadriceps', 'Quadriceps Femoris', 'العضلة الفخذية ذات الرؤوس الأربعة', 'knee_thigh', null, 'Rectus femoris: AIIS (straight head) and ilium above acetabulum (reflected head); Vasti: various surfaces of femoral shaft', 'Patella via quadriceps tendon, then tibial tuberosity via patellar ligament', 'Knee extension; rectus femoris also assists hip flexion', 'Femoral nerve (L2-L4)', 'Lateral femoral circumflex artery, femoral artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('trapezius-middle', 'Middle Trapezius', 'عضلة شبه المنحرف (الوسطى)', 'spine_core', null, 'Spinous processes C7-T3', 'Medial acromion, superior spine of scapula', 'Scapular retraction', 'Spinal accessory nerve (CN XI), with proprioceptive and motor contributions from C3-C4', 'Transverse cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('semispinalis-thoracis', 'Semispinalis Thoracis', 'Semispinalis Thoracis', 'other', null, 'Transverse processes of T6-T12', 'Spinous processes of C6-T4', 'Bilateral: thoracic and cervical extension; Unilateral: contralateral rotation', 'Medial branches of posterior rami of thoracic spinal nerves', 'Posterior intercostal arteries, deep cervical artery (upper portions)')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('palmaris-longus', 'Palmaris Longus', 'Palmaris Longus', 'other', null, 'Medial epicondyle via anterior common tendon', 'Palmar aponeurosis', 'Weak wrist flexion, tenses palmar aponeurosis', 'Median nerve (C7-C8)', 'Branches from median nerve artery and ulnar artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('posterior-deltoid', 'Posterior Deltoid', 'Posterior Deltoid', 'other', null, 'Spine of scapula', 'Deltoid tuberosity of humerus', 'Horizontal abduction, extension; antagonist to elevation in anterior arm positions', 'Axillary nerve (anterior branch in 91.5% of cases, posterior branch in 8.5%)', 'Posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('biceps-femoris-short', 'Biceps Femoris â€” Short Head', 'Biceps Femoris â€” Short Head', 'other', null, 'Lateral lip of linea aspera, lateral supracondylar line', 'Head of fibula (joins long head tendon)', 'Knee flexion, knee external rotation', 'Common fibular (peroneal) division of sciatic nerve (L5-S2); single branch', 'Perforating branches of profunda femoris artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('splenius-cervicis', 'Splenius Cervicis', 'Splenius Cervicis', 'other', null, 'Spinous processes of T3-T6', 'Posterior tubercles of C1-C3 transverse processes', 'Bilateral: cervical extension; Unilateral: ipsilateral rotation and lateral flexion', 'Dorsal rami of lower cervical spinal nerves (C5-C7)', 'Deep cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('multifidus', 'Multifidus', 'العضلة متعددة الفلوق (العامود الفقري)', 'spine_core', null, 'Posterior sacrum, superior iliac spine, mammillary processes of lumbar vertebrae, lateral sacral crest, thoracolumbar fascia (pennate bundle)', 'Spinous processes of lumbar vertebrae, typically 2-4 levels above', 'Segmental stabilization of the lumbar spine, extension, rotation control', 'Medial branches of lumbar dorsal rami (L1-L5); each medial branch innervates only fascicles arising from the spinous process with the same segmental number', 'Lumbar arteries (segmental branches from abdominal aorta)')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('external-intercostals', 'External Intercostals', 'External Intercostals', 'other', null, 'Inferior border of rib above (from tubercle to costochondral junction)', 'Superior border of rib below', 'Inspiratory in dorsal portions; rib elevation at end-expiratory volume; mechanical advantage greatest in dorsal rostral interspaces', 'Intercostal nerves (T1-T11)', 'Posterior and anterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('pronator-quadratus', 'Pronator Quadratus', 'العضلة الكابة المربعة', 'arm', null, 'Distal anterior ulna', 'Distal anterior radius', 'Forearm pronation (primary pronator)', 'Anterior interosseous nerve (branch of median nerve, C7-C8)', 'Anterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('quadratus-femoris', 'Quadratus Femoris', 'العضلة المربعة الفخذية', 'hip_pelvis', null, 'Lateral border of ischial tuberosity', 'Intertrochanteric crest and quadrate tubercle of femur', 'External rotation, adduction', 'Nerve to quadratus femoris (L4-S1)', 'Inferior gluteal artery, medial circumflex femoral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('opponens-pollicis', 'Opponens Pollicis', 'العضلة المقابلة للإبهام', 'arm', null, 'Flexor retinaculum, trapezium', 'Lateral border of 1st metacarpal', 'Opposition of thumb (flexion + medial rotation of 1st metacarpal)', 'Median nerve (recurrent branch, C8, T1)', 'Superficial palmar branch of radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-carpi-radialis-longus', 'Extensor Carpi Radialis Longus', 'باسطة الرسغ الكعبرية الطويلة', 'arm', null, 'Lateral supracondylar ridge of humerus', 'Base of 2nd metacarpal', 'Wrist extension, radial deviation', 'Radial nerve (C6, C7)', 'Radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-pollicis-brevis', 'Extensor Pollicis Brevis', 'باسطة الإبهام القصيرة', 'arm', null, 'Posterior radius and interosseous membrane', 'Dorsal base of proximal phalanx of thumb', 'Extension of thumb MCP and CMC joints, mild abduction', 'Posterior interosseous nerve (C7-C8)', 'Posterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('brachialis', 'Brachialis', 'العضلة العضدية', 'arm', null, 'Anterior surface of distal half of humerus', 'Superficial head: ulnar tuberosity via thick tendon; Deep head: coronoid process via aponeurosis', 'Elbow flexion (primary pure flexor, unaffected by forearm position)', 'Musculocutaneous nerve (C5-C6) to superficial head; radial nerve contribution to deep head (83.33% of cases)', 'Brachial artery, radial recurrent artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('tibialis-anterior', 'Tibialis Anterior', 'العضلة الظنبوبية الأمامية', 'ankle_foot', null, 'Lateral tibial condyle, upper two-thirds of lateral tibial surface, interosseous membrane', 'Medial cuneiform and base of 1st metatarsal', 'Ankle dorsiflexion, foot inversion', 'Deep peroneal nerve (L4, L5)', 'Anterior tibial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-carpi-radialis', 'Flexor Carpi Radialis', 'قابضة الرسغ الكعبرية', 'arm', null, 'Medial epicondyle of humerus (common flexor origin)', 'Base of 2nd and 3rd metacarpals', 'Wrist flexion, radial deviation', 'Median nerve (C6, C7)', 'Radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('scalenes', 'Scalene Muscles', 'العضلات الأخمعية', 'neck', null, 'Anterior: anterior tubercles C3-C6; Middle: posterior tubercles C2-C7; Posterior: posterior tubercles C5-C7', 'Anterior: first rib (scalene tubercle); Middle: first rib (posterior to subclavian groove); Posterior: second rib (outer surface)', 'Cervical flexion (anterior), lateral flexion, ipsilateral rotation; rib elevation during inspiration', 'Anterior: anterior rami C4-C6; Middle: anterior rami C3-C8; Posterior: anterior rami C6-C8', 'Ascending cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-digitorum-longus', 'Extensor Digitorum Longus', 'باسطة أصابع القدم الطويلة', 'ankle_foot', null, 'Lateral tibial condyle, fibula, interosseous membrane', 'Middle and distal phalanges of toes 2-5', 'Toe extension (toes 2-5), assists ankle dorsiflexion', 'Deep peroneal nerve (L5-S1)', 'Anterior tibial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('peroneus-longus', 'Peroneus Longus (Fibularis Longus)', 'العضلة الشظوية الطويلة', 'ankle_foot', null, 'Head and upper two-thirds of lateral fibula', 'Base of 1st metatarsal and medial cuneiform (plantar surface)', 'Foot eversion, assists plantarflexion, supports transverse arch', 'Superficial peroneal nerve (L5, S1)', 'Peroneal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gluteus-medius', 'Gluteus Medius', 'العضلة الأليوية الوسطى', 'hip_pelvis', null, 'Gluteal fossa (between anterior and posterior gluteal lines), gluteal aponeurosis, posteroinferior edge of iliac crest', 'Lateral and superoposterior facets of greater trochanter via lateral and posterior tendon parts', 'Anterior fibers: abduction and internal rotation; middle fibers: abduction; posterior fibers: abduction and external rotation; primary hip stabilizer during initial gait phase and pelvic rotation', 'Superior gluteal nerve (L4-S1) with 3-4 branches supplying different muscle regions', 'Superior gluteal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gracilis', 'Gracilis', 'العضلة الرشيقة', 'hip_pelvis', null, 'Body and inferior ramus of pubis', 'Medial surface of proximal tibia (pes anserinus)', 'Hip adduction, knee flexion, knee internal rotation', 'Obturator nerve (L2-L3)', 'Main pedicle from medial femoral circumflex or profunda femoris (~10 cm from origin); 1-3 distal branches from superficial femoral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-digitorum-profundus', 'Flexor Digitorum Profundus', 'قابضة الأصابع العميقة', 'arm', null, 'Proximal three-quarters of anterior and medial ulna, interosseous membrane', 'Bases of distal phalanges of fingers 2-5', 'Flexion of DIP joints (primary), assists PIP and MCP flexion and wrist flexion', 'Lateral half: anterior interosseous nerve (C7, C8); Medial half: ulnar nerve (C8, T1)', 'Anterior interosseous artery, ulnar artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('tibialis-posterior', 'Tibialis Posterior', 'العضلة الظنبوبية الخلفية', 'ankle_foot', null, 'Posterior tibia, fibula, and interosseous membrane', 'Navicular tuberosity and plantar surfaces of cuneiforms and metatarsals 2-4', 'Foot inversion, assists plantarflexion, supports medial longitudinal arch', 'Tibial nerve (L4, L5)', 'Posterior tibial artery, peroneal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('palmar-interossei', 'Palmar Interossei', 'Palmar Interossei', 'other', null, 'Palmar surfaces of 2nd, 4th, and 5th metacarpals', 'Extensor expansions and proximal phalanges of fingers 2, 4, 5', 'Finger adduction (MCP), assist MCP flexion and IP extension', 'Ulnar nerve, deep branch (C8, T1)', 'Palmar metacarpal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('splenius-capitis', 'Splenius Capitis', 'Splenius Capitis', 'other', null, 'Lower half of nuchal ligament and spinous processes of C7-T3', 'Mastoid process and lateral superior nuchal line', 'Bilateral: cervical extension; Unilateral: ipsilateral rotation and lateral flexion', 'Dorsal rami of middle cervical spinal nerves (C3-C5)', 'Occipital artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('vastus-intermedius', 'Vastus Intermedius', 'العضلة المتسعة المتوسطة', 'knee_thigh', null, 'Anterior and lateral surface of femoral shaft', 'Patella (deep layer) via quadriceps tendon; forms complex multi-layered structure with VM', 'Knee extension', 'Femoral nerve (L2-L4), with medial portions sharing innervation with VM', 'Lateral femoral circumflex artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-digitorum-longus', 'Flexor Digitorum Longus', 'قابضة أصابع القدم الطويلة', 'ankle_foot', null, 'Posterior tibia', 'Distal phalanges of toes 2-5', 'Toe flexion (DIP toes 2-5), assists ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Posterior tibial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-hallucis-longus', 'Flexor Hallucis Longus', 'قابضة إبهام القدم الطويلة', 'ankle_foot', null, 'Posterior fibula, interosseous membrane', 'Distal phalanx of great toe', 'Great toe flexion (IP), assists ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Posterior tibial and peroneal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('adductor-longus', 'Adductor Longus', 'العضلة المقربة الطويلة', 'hip_pelvis', null, 'Anterosuperior aspect of pubic body', 'Middle third of linea aspera', 'Adduction, flexion, internal rotation', 'Anterior branch of obturator nerve (L2-L4)', 'Medial circumflex femoral artery, obturator artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('brachioradialis', 'Brachioradialis', 'العضلة العضدية الكعبرية', 'arm', null, 'Proximal two-thirds of lateral supracondylar ridge of humerus', 'Lateral aspect of distal radius (styloid process)', 'Elbow flexion (most effective in neutral forearm), assists pronation from supinated and supination from pronated position', 'Radial nerve (C5-C6)', 'Radial recurrent artery, radial artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('opponens-digiti-minimi', 'Opponens Digiti Minimi', 'Opponens Digiti Minimi', 'other', null, 'Flexor retinaculum and hook of hamate', 'Ulnar border of 5th metacarpal', 'Opposition of 5th digit (flexion and rotation at CMC)', 'Deep branch of ulnar nerve (T1)', 'Ulnar artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gluteus-minimus', 'Gluteus Minimus', 'العضلة الأليوية الصغرى', 'hip_pelvis', null, 'Gluteal fossa (between anterior and inferior gluteal lines)', 'Anterior facet of greater trochanter and hip joint capsule', 'Hip abduction, internal rotation; primary hip stabilizer during mid- and late gait cycle', 'Superior gluteal nerve (L4-S1) with distinct secondary nerve branches entering four muscle regions', 'Superior gluteal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('semitendinosus', 'Semitendinosus', 'العضلة نصف الوترية', 'knee_thigh', null, 'Ischial tuberosity (conjoint tendon with biceps femoris long head)', 'Medial surface of proximal tibia (pes anserinus)', 'Knee flexion, hip extension, knee internal rotation', 'Tibial division of sciatic nerve (L5-S2); always 2 branches (superior and inferior)', 'Perforating branches of profunda femoris artery, superficial femoral artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('vastus-medialis', 'Vastus Medialis', 'العضلة المتسعة الإنسية (VMO)', 'knee_thigh', null, 'Medial lip of linea aspera, intertrochanteric line', 'VML inserts at base of patella; VMO inserts at medial margin of patella; extensive insertion into vastus intermedius aponeurosis', 'Knee extension; VMO contributes to medial patellar tracking', 'Femoral nerve, medial division (L2-L4)', 'Femoral artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('sartorius', 'Sartorius', 'العضلة الخياطية', 'knee_thigh', null, 'Anterior superior iliac spine', 'Medial surface of proximal tibia (pes anserinus)', 'Hip flexion, hip external rotation, hip abduction; knee flexion', 'Femoral nerve (L2-L3); typically 2 branches', 'Multiple vascular pedicles (average 6-7) from femoral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gemelli', 'Gemellus Superior and Inferior', 'Gemellus Superior and Inferior', 'other', null, 'Superior: ischial spine; Inferior: ischial tuberosity', 'Medial surface of greater trochanter (via obturator internus tendon complex)', 'External rotation, hip stabilization', 'Superior: nerve to obturator internus (L5-S1); Inferior: nerve to quadratus femoris (L4-S1)', 'Inferior gluteal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('upper-trapezius', 'Upper Trapezius', 'Upper Trapezius', 'other', null, 'External occipital protuberance, medial superior nuchal line, ligamentum nuchae, C7 spinous process', 'Lateral third of clavicle, acromion', 'Scapular elevation, cervical extension, ipsilateral lateral flexion, contralateral rotation', 'Spinal accessory nerve (CN XI), with proprioceptive and motor contributions from C3-C4', 'Transverse cervical artery, occipital artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('trapezius-upper', 'Upper Trapezius', 'عضلة شبه المنحرف (العلوية)', 'neck', null, 'External occipital protuberance, medial superior nuchal line, ligamentum nuchae, C7 spinous process', 'Lateral third of clavicle, acromion', 'Scapular elevation, upward rotation; draws scapula backward; raises scapula by rotating clavicle', 'Spinal accessory nerve (CN XI), with proprioceptive and motor contributions from C3-C4', 'Transverse cervical artery, occipital artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-digitorum', 'Extensor Digitorum', 'باسطة الأصابع المشتركة', 'arm', null, 'Lateral epicondyle of humerus (common extensor origin)', 'Extensor expansions of fingers 2-5', 'Extension of MCP joints of fingers 2-5; assists wrist extension', 'Posterior interosseous nerve (C7, C8)', 'Posterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('internal-oblique', 'Internal Oblique', 'العضلة المائلة الداخلية', 'spine_core', null, 'Thoracolumbar fascia, iliac crest, lateral two-thirds of inguinal ligament', 'Lower ribs (10-12), linea alba, pubic crest', 'Ipsilateral trunk rotation, lateral flexion, trunk flexion; highest activity during IAP generation tasks', 'Thoracolumbar nerves (T6-L1), with 10th intercostal nerve providing a median of 9 branches', 'Lower posterior intercostal arteries, deep circumflex iliac artery, deep inferior epigastric artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('triceps-brachii', 'Triceps Brachii', 'العضلة ذات الرؤوس الثلاثة (الترايسبس)', 'arm', null, 'Long head: infraglenoid tubercle; Lateral head: posterior humerus (above radial groove); Medial head: posterior humerus (below radial groove)', 'Olecranon process of ulna', 'Elbow extension; long head assists shoulder extension', 'Radial nerve (C6, C7, C8)', 'Deep brachial artery, posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('external-oblique', 'External Oblique', 'العضلة المائلة الخارجية', 'spine_core', null, 'External surfaces of ribs 5-12', 'Linea alba, pubic tubercle, anterior half of iliac crest', 'Contralateral trunk rotation, ipsilateral lateral flexion, trunk flexion, core stabilization', 'Thoracolumbar nerves (T5-T12)', 'Lower posterior intercostal arteries, subcostal artery, deep circumflex iliac artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('soleus', 'Soleus', 'العضلة النعلية', 'ankle_foot', null, 'Posterior surface of fibular head, proximal tibia (soleal line)', 'Calcaneus via Achilles tendon', 'Ankle plantarflexion (especially during slow/postural activities); selectively activated with knee extension', 'Tibial nerve (S1-S2)', 'Posterior tibial artery, peroneal artery (dual supply)')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('anterior-deltoid', 'Anterior Deltoid', 'Anterior Deltoid', 'other', null, 'Lateral third of clavicle', 'Deltoid tuberosity of humerus', 'Arm elevation (particularly in anterior planes), horizontal flexion', 'Axillary nerve, anterior branch (C5-C6)', 'Thoracoacromial artery, anterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('erector-spinae', 'Erector Spinae Group', 'العضلة الناصبة للفقار', 'spine_core', null, 'Iliocostalis lumborum: ilium, erector spinae aponeurosis, L1-4 transverse/accessory processes; Longissimus thoracis: ilium, lumbar intermuscular aponeurosis, erector spinae aponeurosis', 'Iliocostalis: costal elements of L1-4, lower ribs; Longissimus: accessory and transverse processes of lumbar vertebrae, lower thoracic vertebrae and ribs', 'Bilateral: trunk extension, maintains upright posture; Unilateral: lateral flexion; portions have appreciable potential to generate torque about all three orthopedic axes', 'Iliocostalis: lateral branches of lumbar dorsal rami; Longissimus: intermediate branches of lumbar dorsal rami', 'Lumbar arteries, posterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('obturator-internus', 'Obturator Internus', 'العضلة السدادية الباطنة', 'hip_pelvis', null, 'Inner surface of obturator membrane and surrounding pelvic bone', 'Medial surface of greater trochanter (forms continuum with gemelli)', 'External rotation, hip stabilization', 'Nerve to obturator internus (L5-S2)', 'Internal pudendal artery, obturator artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-pollicis-brevis', 'Flexor Pollicis Brevis', 'Flexor Pollicis Brevis', 'other', null, 'Superficial head: flexor retinaculum, trapezium; Deep head: trapezoid, capitate', 'Lateral side of proximal phalanx of thumb via lateral sesamoid', 'Flexion of thumb MCP joint, assists opposition', 'Superficial head: median nerve (C8, T1); Deep head: ulnar nerve (C8, T1)', 'Superficial palmar branch of radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('pronator-teres', 'Pronator Teres', 'العضلة الكابة المدورة', 'arm', null, 'Medial epicondyle of humerus (humeral head), coronoid process of ulna (ulnar head)', 'Middle of lateral surface of radius', 'Forearm pronation, weak elbow flexion', 'Median nerve (C6, C7)', 'Ulnar artery, anterior ulnar recurrent artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('popliteus', 'Popliteus', 'العضلة المأبضية (خلف الركبة)', 'knee_thigh', null, 'Lateral femoral condyle, popliteofibular ligament', 'Posterior tibia (proximal 16.6-35.2% of tibial length)', 'Knee internal rotation, ''unlocking'' the knee from full extension, posterolateral stabilization', 'Tibial nerve (L4-S1); 90% tibial nerve alone, 10% tibial and sciatic', 'Inferior medial genicular artery (90%), posterior tibial artery (65%)')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('rectus-abdominis', 'Rectus Abdominis', 'العضلة المستقيمة البطنية (عضلات البطن)', 'spine_core', null, 'Pubic symphysis, pubic crest', 'Costal cartilages of ribs 5-7, xiphoid process', 'Trunk flexion, posterior pelvic tilt, compression of abdominal contents', 'Thoracolumbar nerves (T6-L1), with a constant branch from L1; umbilicus always innervated by T10', 'Superior epigastric artery, inferior epigastric artery, lower posterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('rotatores-thoracis', 'Rotatores (Thoracis)', 'Rotatores (Thoracis)', 'other', null, 'Transverse processes of thoracic vertebrae', 'Lamina and base of spinous process of vertebra 1-2 segments superior', 'Contralateral rotation, segmental stabilization, proprioception', 'Medial branches of posterior rami of thoracic spinal nerves', 'Posterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-carpi-ulnaris', 'Extensor Carpi Ulnaris', 'باسطة الرسغ الزندية', 'arm', null, 'Lateral epicondyle and posterior ulnar border', 'Base of 5th metacarpal (dorsal surface)', 'Wrist extension, ulnar deviation', 'Posterior interosseous nerve (C7-C8)', 'Posterior interosseous artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('subscapularis', 'Subscapularis', 'العضلة تحت اللوح', 'shoulder', null, 'Subscapular fossa', 'Lesser tuberosity of humerus', 'Internal rotation, adduction; superior portion contributes to arm elevation and horizontal flexion; inferior portion primarily horizontal flexion and internal rotation', 'Upper and lower subscapular nerves (C5-C7)', 'Subscapular artery, anterior circumflex humeral artery, posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('abductor-digiti-minimi', 'Abductor Digiti Minimi', 'Abductor Digiti Minimi', 'other', null, 'Pisiform and pisohamate ligament', 'Ulnar base of 5th proximal phalanx and extensor expansion', 'Abduction of 5th digit at MCP', 'Deep branch of ulnar nerve (T1)', 'Ulnar artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('dorsal-interossei', 'Dorsal Interossei (Hand)', 'Dorsal Interossei (Hand)', 'other', null, 'Adjacent sides of two metacarpals each', 'Lateral sides of proximal phalanges and extensor expansions of fingers 2-4', 'Finger abduction (MCP), assist MCP flexion and IP extension', 'Ulnar nerve, deep branch (C8, T1)', 'Dorsal and palmar metacarpal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('biceps-femoris-long', 'Biceps Femoris â€” Long Head', 'Biceps Femoris â€” Long Head', 'other', null, 'Ischial tuberosity (conjoint tendon with semitendinosus)', 'Head of fibula, lateral tibial condyle', 'Knee flexion, hip extension, knee external rotation', 'Tibial division of sciatic nerve (L5-S2); typically 1-2 branches', 'Perforating branches of profunda femoris artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('lumbricals', 'Lumbricals (Hand)', 'Lumbricals (Hand)', 'other', null, 'Tendons of flexor digitorum profundus', 'Lateral sides of extensor expansions of fingers 2-5', 'MCP flexion with simultaneous IP extension (lumbrical position)', 'Lateral two: median nerve (C8, T1); Medial two: ulnar nerve (C8, T1)', 'Superficial palmar arch, common palmar digital arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('abductor-pollicis-longus', 'Abductor Pollicis Longus', 'مبعدة الإبهام الطويلة', 'arm', null, 'Posterior radius, ulna, and interosseous membrane', 'Radial base of 1st metacarpal (may have slips to trapezium and APB)', 'Radial abduction and extension at CMC; important in wrist radial deviation', 'Posterior interosseous nerve (C7-C8)', 'Posterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-pollicis-longus', 'Extensor Pollicis Longus', 'باسطة الإبهام الطويلة', 'arm', null, 'Middle third of posterior ulna, interosseous membrane', 'Base of distal phalanx of thumb', 'Extension of thumb IP and MCP joints, assists wrist extension and thumb adduction', 'Posterior interosseous nerve (C7, C8)', 'Posterior interosseous artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('pectineus', 'Pectineus', 'العضلة العانية', 'hip_pelvis', null, 'Pectineal line of pubis', 'Pectineal line of femur (posterior to lesser trochanter)', 'Hip flexion, adduction; hip stabilizer during rotational movements', 'Femoral nerve (L2-L3), may receive accessory innervation from obturator nerve', 'Medial circumflex femoral artery, obturator artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('semimembranosus', 'Semimembranosus', 'العضلة نصف الغشائية', 'knee_thigh', null, 'Ischial tuberosity (separate from conjoint tendon)', 'Posterior medial tibial condyle with multiple expansions', 'Knee flexion, hip extension, knee internal rotation', 'Tibial division of sciatic nerve (L5-S2); usually single branch', 'Perforating branches of profunda femoris artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('adductor-group', 'Adductor Group (Longus/Brevis/Magnus)', 'Adductor Group (Longus/Brevis/Magnus)', 'other', null, 'Pubic bone (various surfaces for each muscle)', 'Linea aspera of femur (longus/brevis); linea aspera and adductor tubercle (magnus)', 'Hip adduction; magnus also assists hip extension and flexion depending on fiber direction', 'Obturator nerve (L2-L4); hamstring portion of magnus: tibial nerve (L4-S1)', 'Medial circumflex femoral artery, obturator artery, perforating branches of profunda femoris')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-carpi-radialis-brevis', 'Extensor Carpi Radialis Brevis', 'باسطة الرسغ الكعبرية القصيرة', 'arm', null, 'Lateral epicondyle via long, wide tendinous origin on anterior slope', 'Base of 3rd metacarpal (dorsal surface)', 'Wrist extension, radial deviation', 'Posterior interosseous nerve (C6-C7)', 'Radial artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('teres-minor', 'Teres Minor', 'العضلة المدورة الصغيرة', 'shoulder', null, 'Lateral border of scapula', 'Greater tuberosity of humerus (inferior facet)', 'External rotation, horizontal extension; antagonist to elevation', 'Axillary nerve (C5-C6)', 'Posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('anconeus', 'Anconeus', 'العضلة المرفقية', 'arm', null, 'Lateral epicondyle of humerus', 'Lateral olecranon and proximal ulna', 'Elbow extension assist, dynamic stabilization of ulnohumeral joint', 'Radial nerve (triceps-anconeus branch); double innervation from posterior interosseous nerve branch in 70.4%', 'Interosseous recurrent artery, middle collateral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('supraspinatus', 'Supraspinatus', 'العضلة فوق الشوكة', 'shoulder', null, 'Supraspinous fossa of scapula', 'Greater tuberosity of humerus (superior facet)', 'Initiates abduction; biphasic function (horizontal extensor/internal rotator in anterior planes; horizontal flexor/external rotator in posterior planes)', 'Suprascapular nerve (C5-C6)', 'Suprascapular artery, acromial branch of thoracoacromial artery, anterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('plantaris', 'Plantaris', 'العضلة الأخمصية', 'ankle_foot', null, 'Lateral supracondylar line of femur, oblique popliteal ligament', 'Calcaneus (medial to Achilles tendon)', 'Weak knee flexion, weak ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Popliteal artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('iliopsoas', 'Iliopsoas', 'العضلة الحرقفية القطنية (عضلة الورك)', 'hip_pelvis', null, 'Iliacus: iliac fossa, anterior sacroiliac ligament; Psoas major: transverse processes, vertebral bodies, and intervertebral discs of T12-L5', 'Lesser trochanter of femur; psoas tendon inserts separately from iliacus into crest running from superior to anterior aspect of lesser trochanter', 'Hip flexion (primary); psoas also assists lumbar spine flexion; iliacus can selectively stabilize pelvis during contralateral hip extension', 'Iliacus: femoral nerve (L2-L4); Psoas: ventral rami L1-L4, with L2-L3 branches most robust; nerve branches commonly cross L2-3, L3-4, L4-5 discs obliquely', 'Lumbar arteries, iliolumbar artery, deep circumflex iliac artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('serratus-anterior', 'Serratus Anterior', 'العضلة المنشارية الأمامية', 'chest', null, 'Ribs 1-9 (lateral surface)', 'Medial border of scapula (upper part: superior angle; middle part: medial border; lower part: inferior angle)', 'Scapular protraction, upward rotation, posterior tilt, external rotation; stabilizes medial border and prevents winging', 'Long thoracic nerve (C5-C7; upper part mainly C5, middle and lower parts C6-C7)', 'Lateral thoracic artery, thoracodorsal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('semispinalis-cervicis', 'Semispinalis Cervicis', 'Semispinalis Cervicis', 'other', null, 'Transverse processes of T1-T6', 'Spinous processes of C2-C5', 'Cervical extension, segmental stabilization', 'Dorsal rami of cervical and upper thoracic spinal nerves', 'Deep cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('tensor-fasciae-latae', 'Tensor Fasciae Latae', 'موترة اللفافة العريضة (TFL)', 'hip_pelvis', null, 'Anterior superior iliac spine (ASIS) and outer lip of iliac crest', 'Iliotibial band (IT band)', 'Hip flexion, abduction, internal rotation; tenses the fascia lata', 'Superior gluteal nerve (L4-S1)', 'Ascending branch of lateral circumflex femoral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gluteus-maximus', 'Gluteus Maximus', 'العضلة الأليوية الكبرى (الجلوتس)', 'hip_pelvis', null, 'Posterior gluteal line of ilium, dorsal surface of sacrum and coccyx, sacrotuberous ligament', 'Superior three-fourths: gluteal tuberosity of femur via plate-like distal tendon, with partial adhesions to iliotibial tract; inferior portion: lateral femoral intermuscular septum complex', 'Hip extension, external rotation; upper fibers assist abduction, lower fibers assist adduction', 'Inferior gluteal nerve (L5-S2)', 'Superior and inferior gluteal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('adductor-brevis', 'Adductor Brevis', 'العضلة المقربة القصيرة', 'hip_pelvis', null, 'Anteroinferior aspect of pubic body and inferior pubic ramus', 'Proximal linea aspera and pectineal line', 'Adduction, flexion', 'Anterior branch of obturator nerve (L2-L4)', 'Medial circumflex femoral artery, obturator artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('abductor-pollicis-brevis', 'Abductor Pollicis Brevis', 'مبعدة الإبهام القصيرة', 'arm', null, 'Flexor retinaculum, scaphoid, trapezium', 'Lateral side of proximal phalanx of thumb', 'Thumb abduction, assists opposition', 'Median nerve (recurrent branch, C8, T1)', 'Superficial palmar branch of radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('transversus-abdominis', 'Transversus Abdominis', 'العضلة البطنية المستعرضة', 'spine_core', null, 'Lateral third of inguinal ligament, iliac crest, thoracolumbar fascia, costal cartilages of ribs 7-12', 'Linea alba, pubic crest, conjoint tendon; vertical dimension attaching to lumbar spine via thoracolumbar fascia averages 5.2 cm', 'Increases intra-abdominal pressure, trunk stabilization, compression of abdominal contents', 'Thoracolumbar nerves (T6-L1), traveling within the transversus abdominis plane (TAP)', 'Lower posterior intercostal arteries, subcostal artery, deep circumflex iliac artery, deep inferior epigastric artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('gastrocnemius', 'Gastrocnemius', 'عضلة الساق التوأمية (السمانة)', 'ankle_foot', null, 'Medial head: posterior surface of medial femoral condyle; Lateral head: posterior surface of lateral femoral condyle', 'Calcaneus via Achilles tendon', 'Ankle plantarflexion (primary), knee flexion (secondary)', 'Tibial nerve (S1-S2)', 'Sural arteries from popliteal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('pectoralis-major', 'Pectoralis Major', 'العضلة الصدرية الكبرى', 'chest', null, 'Clavicular head: medial half of clavicle; Sternal head: sternum and costal cartilages 1-6', 'Lateral lip of bicipital groove (clavicular head: anterior lamina; sternal head: posterior lamina)', 'Clavicular head: horizontal adduction, flexion, internal rotation; Sternal head: adduction, horizontal adduction, extension from flexed position, internal rotation', 'Clavicular head: lateral pectoral nerve (C5-C7); Sternal head: medial and lateral pectoral nerves (C6-T1)', 'Thoracoacromial artery, lateral thoracic artery, internal thoracic artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('deep-cervical-flexors', 'Deep Cervical Flexors', 'Deep Cervical Flexors', 'other', null, 'Longus colli: anterior tubercles C3-C5 (superior oblique), bodies C5-T3 (vertical), transverse processes C5-C6 (inferior oblique); Longus capitis: anterior tubercles C3-C6 transverse processes', 'Longus colli: anterior tubercle of C1 atlas (superior oblique), bodies C2-C4 (vertical), bodies C5-C6 (inferior oblique); Longus capitis: basilar part of occipital bone (inferior surface)', 'Craniocervical flexion (capitis at C0-C1), cervical flexion (colli at C2-C3), segmental cervical stabilization', 'Longus colli: anterior rami C1-C6; Longus capitis: anterior rami C1-C5', 'Segmental branches of ascending cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('quadratus-lumborum', 'Quadratus Lumborum', 'العضلة المربعة القطنية', 'spine_core', null, 'Iliac crest, iliolumbar ligament', '12th rib, transverse processes of L1-L4', 'Lateral flexion, 12th rib stabilization during inspiration; modest direct action on lumbar spine (<10% of extensor/lateral bending moments)', 'Ventral rami of T12-L4, with motor neurons in both ventromedial and lateromedial nuclei', 'Lumbar arteries, subcostal artery, iliolumbar artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('teres-major', 'Teres Major', 'العضلة المدورة الكبيرة', 'shoulder', null, 'Inferior angle and lower lateral border of scapula', 'Medial lip of intertubercular groove of humerus', 'Internal rotation, adduction, extension of the shoulder', 'Lower subscapular nerve (C5-C7)', 'Circumflex scapular artery, thoracodorsal artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('biceps-brachii', 'Biceps Brachii', 'العضلة العضدية ذات الرأسين (البايسبس)', 'arm', null, 'Long head: supraglenoid tubercle; Short head: coracoid process of scapula', 'Radial tuberosity, bicipital aponeurosis', 'Elbow flexion, forearm supination, weak shoulder flexion', 'Musculocutaneous nerve (C5, C6)', 'Brachial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('semispinalis-capitis', 'Semispinalis Capitis', 'Semispinalis Capitis', 'other', null, 'Transverse processes of C4-T6', 'Between superior and inferior nuchal lines of occipital bone', 'Bilateral: cervical and head extension; Unilateral: ipsilateral lateral flexion', 'Dorsal rami of cervical spinal nerves (C1-C6)', 'Deep cervical artery, occipital artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('piriformis', 'Piriformis', 'العضلة الكمثرية', 'hip_pelvis', null, 'Anterior surface of sacrum (S2-S4)', 'Superior border of greater trochanter', 'External rotation, abduction (particularly with hip in slight extension); hip stabilization', 'Nerve to piriformis (S1-S2)', 'Superior and inferior gluteal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-digiti-minimi-brevis', 'Flexor Digiti Minimi Brevis', 'Flexor Digiti Minimi Brevis', 'other', null, 'Flexor retinaculum and hook of hamate', 'Ulnar base of 5th proximal phalanx', 'Flexion of 5th digit at MCP', 'Deep branch of ulnar nerve (T1)', 'Ulnar artery branches')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('internal-intercostals', 'Internal Intercostals', 'Internal Intercostals', 'other', null, 'Superior border and costal groove of rib below (from sternum to angle of rib)', 'Inferior border of rib above', 'Interosseous portions: expiratory (caudal interspaces); Parasternal portions: inspiratory; action depends on rib cage volume and interspace location', 'Intercostal nerves (T1-T11)', 'Posterior and anterior intercostal arteries')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('rhomboid-major', 'Rhomboid Major', 'العضلة المعينية الكبرى', 'spine_core', null, 'Spinous processes T2-T5', 'Medial border of scapula (between spine and inferior angle)', 'Scapular retraction, downward rotation, elevation', 'Dorsal scapular nerve (C5)', 'Dorsal scapular artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('obturator-externus', 'Obturator Externus', 'العضلة السدادية الظاهرة', 'hip_pelvis', null, 'Outer surface of obturator membrane and pubic ramus', 'Trochanteric fossa of femur', 'External rotation, adduction', 'Posterior branch of obturator nerve (L3-L4)', 'Obturator artery, medial circumflex femoral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('trapezius-lower', 'Lower Trapezius', 'عضلة شبه المنحرف (السفلية)', 'spine_core', null, 'Spinous processes T4-T12', 'Deltoid tubercle (medial spine of scapula)', 'Scapular depression, upward rotation, retraction', 'Spinal accessory nerve (CN XI), with proprioceptive and motor contributions from C3-C4', 'Dorsal scapular artery, transverse cervical artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('extensor-hallucis-longus', 'Extensor Hallucis Longus', 'باسطة إبهام القدم الطويلة', 'ankle_foot', null, 'Middle fibula, interosseous membrane', 'Distal phalanx of great toe', 'Great toe extension, assists ankle dorsiflexion', 'Deep peroneal nerve (L5-S1)', 'Anterior tibial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('flexor-digitorum-superficialis', 'Flexor Digitorum Superficialis', 'قابضة الأصابع السطحية', 'arm', null, 'Medial epicondyle, coronoid process, anterior radius', 'Middle phalanges of fingers 2-5', 'Flexion of PIP joints, assists MCP and wrist flexion', 'Median nerve (C7, C8, T1)', 'Ulnar artery, radial artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('peroneus-brevis', 'Peroneus Brevis (Fibularis Brevis)', 'العضلة الشظوية القصيرة', 'ankle_foot', null, 'Lateral fibula (distal two-thirds)', 'Fifth metatarsal base', 'Foot eversion, assists ankle plantarflexion', 'Superficial peroneal nerve (L5-S1)', 'Peroneal artery, anterior tibial artery branch')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('hamstrings', 'Hamstrings (Group)', 'عضلات الفخذ الخلفية (الهامسترنج)', 'knee_thigh', null, 'Ischial tuberosity (long heads); biceps short head: lateral lip of linea aspera', 'Biceps: head of fibula; Semimembranosus: posterior medial tibial condyle; Semitendinosus: pes anserinus', 'Knee flexion, hip extension; medial hamstrings assist internal rotation of knee; biceps assists external rotation', 'Tibial division of sciatic nerve (L5-S2) for long heads and medial hamstrings; common fibular division for biceps short head', 'Perforating branches of profunda femoris artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;

insert into public.anatomy_muscles (slug, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply)
values ('middle-deltoid', 'Middle Deltoid', 'Middle Deltoid', 'other', null, 'Acromion (typically 4-5 tendinous bands)', 'Deltoid tuberosity of humerus', 'Primary abductor (35-65% contribution to abduction torque, particularly in posterior planes and higher elevation angles)', 'Axillary nerve, anterior branch (C5-C6)', 'Thoracoacromial artery, posterior circumflex humeral artery')
on conflict (slug) do update set
  name_ar = excluded.name_ar,
  region = excluded.region,
  action = excluded.action,
  origin = excluded.origin,
  insertion = excluded.insertion,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply;


-- 4. Seed new Body IQ exercises into exercise_library_entries
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('back_squat', 'Back Squat (Barbell)', 'quadriceps', 'Set a barbell across the upper trapezius (high-bar) or posterior deltoids/scapular spine (low-bar), unrack, and stand with feet shoulder-width apart a', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('front_squat', 'Front Squat', 'quadriceps', 'Rack a barbell across the front of the shoulders in a clean grip (elbows high, fingertips under the bar) or crossed-arm position. Squat down by bendin', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('dumbbell_bench_press', 'Dumbbell Bench Press', 'pectoralis-major', 'Lie supine on a flat bench with feet planted on the floor, holding a dumbbell in each hand at chest level with wrists stacked over elbows. Press both ', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('barbell_row', 'Barbell Row', 'latissimus-dorsi', 'Stand with feet hip-width apart, hinge at the hips to roughly 30-45 degrees of trunk lean (or near-parallel for the strict variation) with a neutral s', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('bent_over_row', 'Bent-Over Row', 'latissimus-dorsi', 'Stand holding a barbell or dumbbells, hinge at the hips to roughly 30-45 degrees of trunk inclination with a neutral spine and soft knees, and let the', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('lat_pulldown', 'Lat Pulldown', 'latissimus-dorsi', 'Sit at a cable pulldown station with thighs secured under the pad, grasp the bar with a pronated grip slightly wider than shoulder width, and lean bac', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('seated_cable_row', 'Seated Cable Row', 'latissimus-dorsi', 'Sit tall at a cable row station with knees slightly bent and feet braced on the platform, holding the handle with arms extended. Pull the handle towar', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('pull_up', 'Pull-Up', 'latissimus-dorsi', 'Hang from an overhead bar with a pronated (palms-away) grip slightly wider than shoulder width, arms fully extended. Initiate by depressing and downwa', 'advanced', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('chin_up', 'Chin-Up', 'latissimus-dorsi', 'Hang from a bar with a supinated (palms-facing-you) grip about shoulder-width apart, arms fully extended. Initiate by drawing the shoulder blades down', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('parallel_bar_dip', 'Dip', 'pectoralis-major', 'Support yourself on parallel bars with elbows locked and shoulders down. Bend the elbows and let the shoulders travel back into extension, lowering un', 'advanced', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('dumbbell_shoulder_press', 'Dumbbell Shoulder Press', 'anterior-deltoid', 'Hold a dumbbell in each hand at shoulder height, palms facing forward or slightly inward, forearms vertical. Press both dumbbells overhead until the e', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('lateral_raise', 'Lateral Raise', 'middle-deltoid', 'Stand tall holding a dumbbell in each hand at your sides with a soft bend in the elbows. Raise both arms out to the sides in the frontal plane until t', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('biceps_curl', 'Biceps Curl', 'biceps-brachii', 'Stand or sit holding a dumbbell in each hand with arms at your sides, palms facing forward. Keeping the upper arms pinned to your torso, bend the elbo', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('hammer_curl', 'Hammer Curl', 'brachioradialis', 'Stand holding a dumbbell in each hand at your sides with palms facing your thighs (neutral grip). Keeping the elbows pinned to your ribs and the thumb', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('triceps_pushdown', 'Triceps Pushdown', 'triceps-brachii', 'Stand facing a cable column with a straight bar or rope attachment set at upper-chest height. With elbows pinned to your sides and a slight forward hi', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('skull_crusher', 'Skull Crusher (Lying Triceps Extension)', 'triceps-brachii', 'Lie supine on a flat bench holding an EZ-curl bar or dumbbells with arms extended over the chest, shoulders flexed to roughly 90 degrees. Keeping the ', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('leg_extension', 'Leg Extension', 'quadriceps', 'An open-kinetic-chain, single-joint knee extension performed on a leg extension machine. Sit tall with your back and hips against the pads, hips flexe', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('leg_curl', 'Leg Curl', 'hamstrings', 'A single-joint knee-flexion exercise that isolates the hamstrings, performed on a machine (prone/lying or seated) or with a band/ankle weight. Set up ', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('seated_calf_raise', 'Seated Calf Raise', 'soleus', 'Sit upright on a bench or seated calf-raise machine with the knees bent to roughly 90 degrees and the balls of both feet on a raised platform or foot ', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('sit_up', 'Sit-Up', 'rectus-abdominis', 'Lie supine with knees bent to about 90 degrees and feet flat on the floor, arms crossed over the chest or hands lightly behind the ears. Curl the trun', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('crunch', 'Crunch', 'rectus-abdominis', 'Lie supine with knees bent about 90 degrees and feet flat on the floor, hands lightly supporting the head or crossed over the chest. Exhale and curl t', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('russian_twist', 'Russian Twist', 'external-oblique', 'Sit on the floor with knees bent and heels resting lightly on the ground, then lean the trunk back about 45 degrees while keeping the spine long and c', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('mountain_climber', 'Mountain Climber', 'iliopsoas', 'Begin in a high plank with hands under shoulders, body in a straight line from head to heels. Drive one knee toward the chest, then quickly switch leg', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('burpee', 'Burpee', 'quadriceps', 'From standing, squat down and place both hands on the floor just inside the feet, jump or step the feet back into a rigid high plank, perform an optio', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('jumping_jack', 'Jumping Jack', 'gluteus-medius', 'Stand tall with feet together and arms at your sides. Jump both feet out wider than hip-width while swinging straight arms out and overhead, then imme', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('jump_squat', 'Jump Squat', 'quadriceps', 'Stand with feet shoulder-width apart, descend quickly into a quarter-to-half squat with arms swinging back, then explosively extend the hips, knees, a', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wall_sit', 'Wall Sit', 'quadriceps', 'Stand with your back flat against a wall, feet hip-width apart and about 1.5-2 foot-lengths away from the wall. Slide down until your hips and knees a', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('superman', 'Superman', 'erector-spinae', 'Lie prone with arms extended overhead and legs straight. Simultaneously lift both arms, chest, and both legs a few centimeters off the floor by extend', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('bear_crawl', 'Bear Crawl', 'serratus-anterior', 'Start in quadruped with hands under shoulders, toes tucked, and knees lifted about 2-5 cm off the floor. Crawl forward by moving the opposite hand and', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('chest_fly', 'Chest Fly', 'pectoralis-major', 'Lie supine on a flat bench holding dumbbells above the chest with palms facing each other and a soft bend in the elbows. Lower the arms out to the sid', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('pec_deck', 'Pec Deck', 'pectoralis-major', 'Sit tall on the machine with your back and head against the pad, feet flat, and forearms or hands on the lever pads with elbows at roughly chest heigh', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('hanging_leg_raise', 'Hanging Leg Raise', 'iliopsoas', 'Hang from a pull-up bar with an overhand grip, shoulders actively packed (pulled down away from the ears). Keeping the knees straight or nearly straig', 'advanced', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('cobra_pose', 'Cobra Pose', 'erector-spinae', 'Lie prone with legs extended, tops of the feet on the mat, and palms flat under the shoulders with elbows tucked close to the ribs. Press the pubic bo', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('downward_dog', 'Downward Dog (Adho Mukha Svanasana)', 'anterior-deltoid', 'From hands-and-knees, tuck the toes and lift the hips up and back until the body forms an inverted V, arms and spine in one long line and knees softly', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('worlds_greatest_stretch', 'World''s Greatest Stretch', 'external-oblique', 'A multi-segment dynamic mobility drill that chains a deep lunge, a hip/adductor opener, a thoracic rotation reach, and a hamstring lengthening in one ', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('copenhagen_adduction', 'Copenhagen Adduction Exercise', 'adductor-group', 'Side-lying with top leg on a bench, performing hip adduction by lifting body with the bottom leg. Produces 108% MVIC adductor longus — the highest amo', 'advanced', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('side_lying_hip_adduction', 'Side-Lying Hip Adduction', 'adductor-longus', 'Lying on one side with the top leg crossed over and supported in front, the bottom leg is lifted toward the ceiling against gravity, isolating the hip', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('thumb_radial_abduction', 'Thumb Radial Abduction', 'abductor-pollicis-longus', 'A targeted hand-strengthening exercise in which the thumb is moved away from the index finger within the plane of the palm (radial abduction / extensi', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('resisted_forearm_pronation', 'Resisted Forearm Pronation', 'pronator-quadratus', 'A targeted forearm-strengthening exercise in which the seated athlete rotates the palm from a face-up (supinated) or neutral position toward face-down', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('prone_cervical_extension', 'Prone Cervical Extension', 'semispinalis-cervicis', 'A prone neck-strengthening exercise in which the client lies face-down with the head off the edge of a table (or over a rolled towel) and lifts the he', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('deep_neck_extensor_endurance', 'Deep Neck Extensor Endurance', 'semispinalis-cervicis', 'A low-load motor-control exercise that trains the endurance and tonic activation of the deep cervical extensors — chiefly semispinalis cervicis and ce', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('single_leg_sit_to_stand', 'Single-Leg Sit-to-Stand', 'quadriceps', 'Sit on the front edge of a sturdy chair, extend one leg out in front, and stand up using only the planted leg, then lower back down under control. The', 'advanced', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wall_angel', 'Wall Angel', 'trapezius-lower', 'Stand with your back, hips, and head lightly touching a wall, arms raised into a goalpost with the backs of the hands and forearms pressed to the wall', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('countertop_incline_push_up', 'Countertop Incline Push-Up', 'pectoralis-major', 'A scaled push-up performed with both hands planted shoulder-width on the edge of a kitchen countertop while the feet stay back on the floor, creating ', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('knee_to_wall_ankle', 'Knee-to-Wall Ankle Mobilization', 'tibialis-anterior', 'Stand facing a wall in a short lunge with the front foot a few inches away, keep that heel firmly planted, and drive the knee straight forward until i', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('legs_up_the_wall', 'Legs-Up-the-Wall', 'diaphragm', 'A restorative pose (Viparita Karani): lie on your back with your buttocks close to a wall and rest your straight legs vertically up the wall, arms rel', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wall_hamstring_stretch', 'Wall Hamstring Stretch', 'general_conditioning', 'Lie on your back in a doorway with the leg to be stretched raised and resting straight against the wall or door frame; the other leg extends flat thro', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('doorway_lat_stretch', 'Doorway Lat Stretch', 'general_conditioning', 'Standing in an open doorway, grip the frame or the top of the jamb with one hand at or above shoulder height, keep that elbow straight, then hinge the', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('doorway_isometric_row', 'Doorway Isometric Row', 'latissimus-dorsi', 'Stand in a doorway, grip both sides of the doorframe with elbows bent about 90 degrees, and pull as though rowing while the fixed frame prevents any m', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('chair_supported_balance', 'Chair-Supported Single-Leg Balance', 'gluteus-medius', 'Stand tall behind or beside a sturdy chair, resting your fingertips lightly on the chair back for support. Shift your weight onto one leg and lift the', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('tandem_stance', 'Tandem Stance Balance', 'general_conditioning', 'Stand with one foot placed directly in front of the other in a heel-to-toe line, so the heel of the front foot touches the toes of the back foot, and ', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('heel_to_toe_walk', 'Heel-to-Toe Walk', 'general_conditioning', 'Standing in a clear hallway, walk forward in a straight line placing the heel of the front foot directly in front of (and touching) the toes of the ba', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('desk_wrist_flexor_stretch', 'Desk Wrist Flexor Stretch', 'general_conditioning', 'Seated at a desk, place the palm flat on the desktop with the fingers pointing back toward the body and the elbow straight, then gently lean away from', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('desk_wrist_extensor_stretch', 'Desk Wrist Extensor Stretch', 'general_conditioning', 'Standing or sitting at a desk, place the back of the affected hand flat on the desk with the palm facing up and fingers pointing toward your body, elb', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('towel_row', 'Towel Row', 'rhomboid-major', 'Standing horizontal pull done at home by looping a towel around both handles of a sturdy closed door; hold an end in each hand, walk the feet in and l', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('towel_scapular_retraction', 'Towel Scapular Retraction', 'trapezius-middle', 'Sit or stand tall and grip a rolled bath towel with both hands roughly shoulder-width apart, arms out in front at about chest height. Keeping the elbo', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('stair_calf_raise', 'Stair Calf Raise', 'gastrocnemius', 'Standing on a stair with the balls of both feet on the edge and heels hanging off, hold the handrail or wall for balance, press up onto your toes, the', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('eccentric_stair_descent', 'Eccentric Stair Descent', 'quadriceps', 'Standing at the top of a staircase, slowly lower yourself one step at a time, letting the trailing (top-step) leg bend under control to accept most of', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('backpack_weighted_carry', 'Backpack Weighted Carry', 'erector-spinae', 'Load a sturdy backpack with books or water bottles, wear it snug on both shoulders with the load high and close to the spine, brace the trunk, and wal', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('water_bottle_lateral_raise', 'Water Bottle Lateral Raise', 'middle-deltoid', 'Standing tall, hold a filled water bottle in each hand at your sides. With a soft elbow, raise both arms out to the sides in the frontal plane until t', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('prone_press_up', 'Prone Press-Up (McKenzie)', 'triceps-brachii', 'Lie face-down on the floor (no equipment needed) and press your upper body up with your arms while your hips and low back stay relaxed, letting the lu', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('hollow_body_hold', 'Hollow Body Hold', 'rectus-abdominis', 'Lie supine on the floor (or an exercise mat), flatten your low back into the ground, then lift the shoulder blades, arms, and straight legs a few inch', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('bodyweight_hip_hinge', 'Bodyweight Hip Hinge', 'gluteus-maximus', 'Standing hip-dominant bend performed with bodyweight only, optionally holding a broomstick vertically against the spine (touching the back of the head', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wall_sit_isometric', 'Wall Sit Isometric', 'quadriceps', 'Stand with your back flat against a wall, then slide down until your hips and knees are bent toward 90 degrees, as if sitting in an invisible chair, a', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('doorframe_calf_stretch', 'Doorframe Calf Stretch', 'general_conditioning', 'Standing facing a doorway, place both hands on the doorframe at chest height and step one leg back. Keep the back knee straight and the heel flat on t', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('countertop_supported_squat', 'Countertop-Supported Squat', 'quadriceps', 'Stand facing a sturdy kitchen countertop with feet shoulder-width apart, resting your hands lightly on the edge. Push your hips back and bend your kne', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('chair_triceps_dip', 'Chair Triceps Dip', 'triceps-brachii', 'Sit at the edge of a sturdy chair, grip the front edge with hands beside your hips, slide your hips off the seat, then bend and straighten your elbows', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('bird_dog_elbow_knee', 'Bird Dog to Elbow-Knee', 'multifidus', 'On the floor (a mat or carpet cushions the knees), start in quadruped with hands under shoulders and knees under hips. Reach the opposite arm forward ', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('prone_ytw_raise', 'Prone Y-T-W Raise', 'trapezius-lower', 'Lie face down on the floor (a carpet or exercise mat for comfort), arms hanging off to the sides. With thumbs pointing up, lift the arms just off the ', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('standing_hip_abduction_support', 'Standing Hip Abduction (Counter Support)', 'gluteus-medius', 'Stand tall beside a kitchen countertop, resting one hand on it for balance. Keeping the moving leg straight and the toes pointing forward, lift that l', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('stair_edge_calf_raise', 'Calf Raise off Stair Edge', 'gastrocnemius', 'Standing on a stair with the balls of both feet on the step edge and heels hanging off, rise onto the toes then lower the heels below the edge through', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('towel_hamstring_curl', 'Towel Hamstring Curl', 'hamstrings', 'Lie face-up with knees bent and heels resting on a folded towel on a smooth floor. Lift into a bridge, then slowly slide the heels away from you until', 'intermediate', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wall_ball_squat', 'Wall Ball Squat', 'quadriceps', 'Standing with an exercise ball pinned between the low back and a wall (a plain wall works too), slide down until the knees bend toward roughly 90 degr', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('stair_step_up', 'Step-Up on Stairs', 'quadriceps', 'Standing at the bottom of a staircase, place one whole foot on the first step, then drive through that leg to lift your body up until you are standing', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('seated_knee_extension', 'Seated Knee Extension (Bodyweight)', 'quadriceps', 'Sit tall on a sturdy chair with feet flat. Straighten one knee to lift the foot until the leg is nearly parallel to the floor, hold briefly at the top', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('standing_calf_stretch_step', 'Standing Calf Stretch on Step', 'general_conditioning', 'Stand on a stair or step with the balls of both feet on the edge and heels hanging off the back. Hold the railing or wall for balance and let your hee', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('active_anterior_pelvic_tilt', 'Active Anterior Pelvic Tilt', 'iliopsoas', 'A foundational pelvic motor-control drill in which you actively roll the top of the pelvis forward (rotating the sitting bones back and up), producing', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('pelvic_clock_mobilization', 'Pelvic Clock Mobilization', 'rectus-abdominis', 'Add the supine pelvic clock mobilization drill to the pelvis region.', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('standing_hip_hike', 'Standing Hip Hike', 'gluteus-medius', 'A standing frontal-plane exercise for the pelvis and hip. Standing on one leg at the edge of a low step with the other leg hanging free, you let the p', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('cervical_protraction_awareness', 'Cervical Protraction Awareness', 'sternocleidomastoid', 'A slow, controlled motor-control drill that teaches you to feel and steer your head between a forward "protracted" glide and a neutral, stacked positi', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('upper_cervical_rotation_drill', 'Upper Cervical Rotation Drill', 'suboccipitals', 'A gentle, controlled drill that isolates rotation at the top of the neck — the atlanto-axial (C1-C2) joint, which produces roughly half of the head''s ', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('seated_cervical_flexion_arom', 'Seated Cervical Flexion AROM', 'deep-cervical-flexors', 'A seated active range-of-motion drill in which you slowly nod and lower your chin toward your chest, moving the neck through its available forward-ben', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('upper_cervical_extension_control', 'Upper Cervical Extension Control', 'suboccipitals', 'A slow, small-range motor-control drill that trains you to extend the head at the top of the neck (the skull rocking back on the first vertebra) while', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('radial_deviation_strengthening', 'Radial Deviation Strengthening', 'flexor-carpi-radialis', 'A targeted wrist exercise that trains radial deviation — tilting the hand toward the thumb side. Sitting with the forearm supported and the thumb poin', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('ulnar_deviation_strengthening', 'Ulnar Deviation Strengthening', 'flexor-carpi-ulnaris', 'A targeted wrist exercise that trains the muscles moving the hand toward the little-finger side (ulnar deviation). With the forearm supported and thum', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('dart_throwers_motion', 'Dart Thrower''s Motion', 'extensor-carpi-radialis-longus', 'A controlled wrist movement along the natural diagonal (oblique) plane the wrist prefers for everyday tasks. The hand travels from a "cocked-back" pos', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;
insert into public.exercise_library_entries (slug, name, region, description, difficulty, video_url, thumbnail_path, source)
values ('wrist_circles_arom', 'Wrist Circles (AROM)', 'flexor-carpi-radialis', 'A gentle active range-of-motion drill in which the hand is drawn through slow, full circles at the wrist, blending flexion, extension, radial deviatio', 'beginner', null, '/exercises/thumbnails/exercise-thumb-fallback.svg', 'body_iq')
on conflict (slug) do nothing;

commit;
