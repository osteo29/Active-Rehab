-- Migration: 20260526000900_add_anatomy_and_bodyiq_exercises.sql
-- Description: Adds anatomy_muscles with direct images, body_iq_exercises with video embeds, and exercise_muscle_links

begin;

-- 1. Create anatomy_muscles table
create table if not exists public.anatomy_muscles (
  slug text primary key,
  id text not null,
  name_en text not null,
  name_ar text not null,
  region text not null,
  description text,
  origin text,
  insertion text,
  action text,
  innervation text,
  blood_supply text,
  image_url text,
  embed_code text,
  created_at timestamptz not null default now()
);

alter table public.anatomy_muscles enable row level security;
grant select on table public.anatomy_muscles to anon, authenticated;

drop policy if exists "anatomy_muscles_read" on public.anatomy_muscles;
create policy "anatomy_muscles_read" on public.anatomy_muscles for select using (true);

-- 2. Create body_iq_exercises table
create table if not exists public.body_iq_exercises (
  id text primary key,
  library_id text not null,
  name_en text not null,
  name_ar text not null,
  region text not null,
  target_joint text,
  movement_pattern text,
  primary_muscle text,
  secondary_muscles text,
  youtube_id text not null,
  embed_video_url text not null,
  coaching_cue text,
  embed_iframe_code text,
  created_at timestamptz not null default now()
);

alter table public.body_iq_exercises enable row level security;
grant select on table public.body_iq_exercises to anon, authenticated;

drop policy if exists "body_iq_exercises_read" on public.body_iq_exercises;
create policy "body_iq_exercises_read" on public.body_iq_exercises for select using (true);

-- 3. Create exercise_muscle_links table
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

-- 4. Seed anatomy_muscles (107 verified muscles with direct images)
insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('sternocleidomastoid', 'AN-001', 'Sternocleidomastoid', 'العضلة القترية', 'neck', 'Sternocleidomastoid (العضلة القترية) - Functional anatomical muscle.', 'Sternal head: manubrium; Clavicular head: medial third of clavicle', 'Mastoid process, superior nuchal line', 'Bilateral: cervical flexion; Unilateral: ipsilateral lateral flexion, contralateral rotation', 'Cranial nerve XI (spinal accessory nerve) with contributions from C2-C3', 'Superior thyroid artery, occipital artery, suprascapular artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Sternocleidomastoideus.png/600px-Sternocleidomastoideus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Sternocleidomastoideus.png/600px-Sternocleidomastoideus.png" alt="Sternocleidomastoid" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('splenius-capitis', 'AN-002', 'Splenius Capitis', 'العضلة الطاحلة الرأسية', 'neck', 'Splenius Capitis (العضلة الطاحلة الرأسية) - Functional anatomical muscle.', 'Lower half of nuchal ligament and spinous processes of C7-T3', 'Mastoid process and lateral superior nuchal line', 'Bilateral: cervical extension; Unilateral: ipsilateral rotation and lateral flexion', 'Dorsal rami of middle cervical spinal nerves (C3-C5)', 'Occipital artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Splenius_capitis.png/600px-Splenius_capitis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Splenius_capitis.png/600px-Splenius_capitis.png" alt="Splenius Capitis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('splenius-cervicis', 'AN-003', 'Splenius Cervicis', 'العضلة الطاحلة العنقية', 'neck', 'Splenius Cervicis (العضلة الطاحلة العنقية) - Functional anatomical muscle.', 'Spinous processes of T3-T6', 'Posterior tubercles of C1-C3 transverse processes', 'Bilateral: cervical extension; Unilateral: ipsilateral rotation and lateral flexion', 'Dorsal rami of lower cervical spinal nerves (C5-C7)', 'Deep cervical artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Splenius_cervicis.png/600px-Splenius_cervicis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Splenius_cervicis.png/600px-Splenius_cervicis.png" alt="Splenius Cervicis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('scalenus-anterior', 'AN-004', 'Scalenus Anterior', 'العضلة الأخمصية الأمامية', 'neck', 'Scalenus Anterior (العضلة الأخمصية الأمامية) - Functional anatomical muscle.', 'Anterior tubercles of transverse processes of C3-C6 vertebrae', 'Scalene tubercle on superior surface of 1st rib', 'Elevates 1st rib (inspiration); lateral flexion and rotation of cervical spine', 'Anterior rami of cervical nerves C4-C6', 'Ascending cervical artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Scalenus_anterior.png/600px-Scalenus_anterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Scalenus_anterior.png/600px-Scalenus_anterior.png" alt="Scalenus Anterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('scalenus-medius', 'AN-005', 'Scalenus Medius', 'العضلة الأخمصية المتوسطة', 'neck', 'Scalenus Medius (العضلة الأخمصية المتوسطة) - Functional anatomical muscle.', 'Posterior tubercles of transverse processes of C2-C7 vertebrae', 'Superior surface of 1st rib behind subclavian groove', 'Elevates 1st rib; lateral flexion of neck', 'Anterior rami of cervical nerves C3-C8', 'Ascending cervical artery and deep cervical artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Scalenus_medius.png/600px-Scalenus_medius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Scalenus_medius.png/600px-Scalenus_medius.png" alt="Scalenus Medius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('scalenus-posterior', 'AN-006', 'Scalenus Posterior', 'العضلة الأخمصية الخلفية', 'neck', 'Scalenus Posterior (العضلة الأخمصية الخلفية) - Functional anatomical muscle.', 'Posterior tubercles of transverse processes of C4-C6 vertebrae', 'Outer surface of 2nd rib', 'Elevates 2nd rib; lateral flexion of cervical spine', 'Anterior rami of cervical nerves C6-C8', 'Transverse cervical artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Scalenus_posterior.png/600px-Scalenus_posterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Scalenus_posterior.png/600px-Scalenus_posterior.png" alt="Scalenus Posterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('longus-colli', 'AN-007', 'Longus Colli', 'العضلة العنقية الطويلة', 'neck', 'Longus Colli (العضلة العنقية الطويلة) - Functional anatomical muscle.', 'Anterior tubercles of C3-C5, vertebral bodies C5-T3', 'Anterior arch of atlas (C1), bodies of C2-C4, transverse processes C5-C6', 'Flexion and lateral flexion of cervical spine, segmental cervical stabilization', 'Anterior rami of C2-C6 spinal nerves', 'Ascending cervical artery, vertebral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Longus_colli.png/600px-Longus_colli.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Longus_colli.png/600px-Longus_colli.png" alt="Longus Colli" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('longus-capitis', 'AN-008', 'Longus Capitis', 'العضلة الرأسية الطويلة', 'neck', 'Longus Capitis (العضلة الرأسية الطويلة) - Functional anatomical muscle.', 'Anterior tubercles of transverse processes of C3-C6 vertebrae', 'Basilar part of occipital bone', 'Flexion of head and upper cervical spine', 'Anterior rami of C1-C3 spinal nerves', 'Ascending pharyngeal artery, vertebral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Longus_capitis.png/600px-Longus_capitis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Longus_capitis.png/600px-Longus_capitis.png" alt="Longus Capitis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('rectus-capitis-anterior', 'AN-009', 'Rectus Capitis Anterior', 'العضلة الرأسية المستقيمة الأمامية', 'neck', 'Rectus Capitis Anterior (العضلة الرأسية المستقيمة الأمامية) - Functional anatomical muscle.', 'Anterior surface of lateral mass of atlas (C1)', 'Basilar part of occipital bone anterior to foramen magnum', 'Head flexion at atlanto-occipital joint', 'Anterior rami of C1 and C2 spinal nerves', 'Ascending pharyngeal artery, vertebral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Rectus_capitis_anterior.png/600px-Rectus_capitis_anterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Rectus_capitis_anterior.png/600px-Rectus_capitis_anterior.png" alt="Rectus Capitis Anterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('rectus-capitis-lateralis', 'AN-010', 'Rectus Capitis Lateralis', 'العضلة الرأسية المستقيمة الوحشية', 'neck', 'Rectus Capitis Lateralis (العضلة الرأسية المستقيمة الوحشية) - Functional anatomical muscle.', 'Superior surface of transverse process of atlas (C1)', 'Jugular process of occipital bone', 'Lateral flexion of head to ipsilateral side', 'Anterior rami of C1 and C2 spinal nerves', 'Occipital artery, vertebral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Rectus_capitis_lateralis.png/600px-Rectus_capitis_lateralis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Rectus_capitis_lateralis.png/600px-Rectus_capitis_lateralis.png" alt="Rectus Capitis Lateralis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('masseter', 'AN-011', 'Masseter', 'العضلة المضغية', 'neck', 'Masseter (العضلة المضغية) - Functional anatomical muscle.', 'Zygomatic arch and maxillary process of zygomatic bone', 'Ramus and angle of mandible', 'Elevation and protraction of mandible (closes jaw)', 'Masseteric nerve (CN V3 - Mandibular)', 'Masseteric artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Masseter.png/600px-Masseter.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Masseter.png/600px-Masseter.png" alt="Masseter" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('temporalis', 'AN-012', 'Temporalis', 'العضلة الصدغية', 'neck', 'Temporalis (العضلة الصدغية) - Functional anatomical muscle.', 'Temporal fossa and deep temporal fascia', 'Coronoid process and anterior border of mandibular ramus', 'Elevation and retraction of mandible', 'Deep temporal nerves (CN V3 - Mandibular)', 'Deep temporal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Temporalis.png/600px-Temporalis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Temporalis.png/600px-Temporalis.png" alt="Temporalis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('supraspinatus', 'AN-013', 'Supraspinatus', 'العضلة فوق الشوكة', 'shoulder', 'Supraspinatus (العضلة فوق الشوكة) - Functional anatomical muscle.', 'Supraspinous fossa of scapula', 'Greater tuberosity of humerus (superior facet)', 'Initiates abduction; biphasic function (horizontal extensor/internal rotator in anterior planes; horizontal flexor/external rotator in posterior planes)', 'Suprascapular nerve (C5-C6)', 'Suprascapular artery, acromial branch of thoracoacromial artery, anterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Supraspinatus.png/600px-Supraspinatus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Supraspinatus.png/600px-Supraspinatus.png" alt="Supraspinatus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('infraspinatus', 'AN-014', 'Infraspinatus', 'العضلة تحت الشوكة', 'shoulder', 'Infraspinatus (العضلة تحت الشوكة) - Functional anatomical muscle.', 'Infraspinous fossa of scapula', 'Greater tuberosity of humerus (middle facet)', 'External rotation, horizontal extension; arm elevation (particularly in posterior planes)', 'Suprascapular nerve (C5-C6)', 'Suprascapular artery, posterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Infraspinatus.png/600px-Infraspinatus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Infraspinatus.png/600px-Infraspinatus.png" alt="Infraspinatus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('teres-minor', 'AN-015', 'Teres Minor', 'العضلة المدورة الصغيرة', 'shoulder', 'Teres Minor (العضلة المدورة الصغيرة) - Functional anatomical muscle.', 'Lateral border of scapula', 'Greater tuberosity of humerus (inferior facet)', 'External rotation, horizontal extension; antagonist to elevation', 'Axillary nerve (C5-C6)', 'Posterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Teres_minor.png/600px-Teres_minor.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Teres_minor.png/600px-Teres_minor.png" alt="Teres Minor" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('subscapularis', 'AN-016', 'Subscapularis', 'العضلة تحت الكتف', 'shoulder', 'Subscapularis (العضلة تحت الكتف) - Functional anatomical muscle.', 'Subscapular fossa', 'Lesser tuberosity of humerus', 'Internal rotation, adduction; superior portion contributes to arm elevation and horizontal flexion; inferior portion primarily horizontal flexion and internal rotation', 'Upper and lower subscapular nerves (C5-C7)', 'Subscapular artery, anterior circumflex humeral artery, posterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Subscapularis.png/600px-Subscapularis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Subscapularis.png/600px-Subscapularis.png" alt="Subscapularis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('anterior-deltoid', 'AN-017', 'Anterior Deltoid', 'العضلة الدالية الأمامية', 'shoulder', 'Anterior Deltoid (العضلة الدالية الأمامية) - Functional anatomical muscle.', 'Lateral third of clavicle', 'Deltoid tuberosity of humerus', 'Arm elevation (particularly in anterior planes), horizontal flexion', 'Axillary nerve, anterior branch (C5-C6)', 'Thoracoacromial artery, anterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png" alt="Anterior Deltoid" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('lateral-deltoid', 'AN-018', 'Lateral Deltoid', 'العضلة الدالية الجانبية', 'shoulder', 'Lateral Deltoid (العضلة الدالية الجانبية) - Functional anatomical muscle.', 'Acromion process of scapula (lateral margin)', 'Deltoid tuberosity on lateral aspect of humerus', 'Primary abductor of glenohumeral joint (from 15° to 90°)', 'Axillary nerve (C5, C6)', 'Posterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png" alt="Lateral Deltoid" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('posterior-deltoid', 'AN-019', 'Posterior Deltoid', 'العضلة الدالية الخلفية', 'shoulder', 'Posterior Deltoid (العضلة الدالية الخلفية) - Functional anatomical muscle.', 'Spine of scapula', 'Deltoid tuberosity of humerus', 'Horizontal abduction, extension; antagonist to elevation in anterior arm positions', 'Axillary nerve (anterior branch in 91.5% of cases, posterior branch in 8.5%)', 'Posterior circumflex humeral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Deltoideus.png/600px-Deltoideus.png" alt="Posterior Deltoid" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pectoralis-major', 'AN-020', 'Pectoralis Major', 'العضلة الصدرية الكبرى', 'shoulder', 'Pectoralis Major (العضلة الصدرية الكبرى) - Functional anatomical muscle.', 'Clavicular head: medial half of clavicle; Sternal head: sternum and costal cartilages 1-6', 'Lateral lip of bicipital groove (clavicular head: anterior lamina; sternal head: posterior lamina)', 'Clavicular head: horizontal adduction, flexion, internal rotation; Sternal head: adduction, horizontal adduction, extension from flexed position, internal rotation', 'Clavicular head: lateral pectoral nerve (C5-C7); Sternal head: medial and lateral pectoral nerves (C6-T1)', 'Thoracoacromial artery, lateral thoracic artery, internal thoracic artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Pectoralis_major.png/600px-Pectoralis_major.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Pectoralis_major.png/600px-Pectoralis_major.png" alt="Pectoralis Major" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pectoralis-minor', 'AN-021', 'Pectoralis Minor', 'العضلة الصدرية الصغرى', 'shoulder', 'Pectoralis Minor (العضلة الصدرية الصغرى) - Functional anatomical muscle.', 'Anterior surfaces of 3rd to 5th ribs near costal cartilages', 'Coracoid process of scapula (medial border and upper surface)', 'Scapular depression, protraction, and downward rotation; accessory inspiration', 'Medial pectoral nerve (C8, T1)', 'Pectoral branch of thoracoacromial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Pectoralis_minor.png/600px-Pectoralis_minor.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Pectoralis_minor.png/600px-Pectoralis_minor.png" alt="Pectoralis Minor" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('subclavius', 'AN-022', 'Subclavius', 'العضلة تحت الترقوة', 'shoulder', 'Subclavius (العضلة تحت الترقوة) - Functional anatomical muscle.', 'Junction of 1st rib and its costal cartilage', 'Subclavian groove on inferior surface of middle third of clavicle', 'Depresses and stabilizes clavicle in sternoclavicular joint', 'Nerve to subclavius (C5, C6)', 'Clavicular branch of thoracoacromial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Subclavius.png/600px-Subclavius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Subclavius.png/600px-Subclavius.png" alt="Subclavius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('serratus-anterior', 'AN-023', 'Serratus Anterior', 'العضلة المنشارية الأمامية', 'shoulder', 'Serratus Anterior (العضلة المنشارية الأمامية) - Functional anatomical muscle.', 'Ribs 1-9 (lateral surface)', 'Medial border of scapula (upper part: superior angle; middle part: medial border; lower part: inferior angle)', 'Scapular protraction, upward rotation, posterior tilt, external rotation; stabilizes medial border and prevents winging', 'Long thoracic nerve (C5-C7; upper part mainly C5, middle and lower parts C6-C7)', 'Lateral thoracic artery, thoracodorsal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Serratus_anterior.png/600px-Serratus_anterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Serratus_anterior.png/600px-Serratus_anterior.png" alt="Serratus Anterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('latissimus-dorsi', 'AN-024', 'Latissimus Dorsi', 'العضلة العريضة الظهرية', 'shoulder', 'Latissimus Dorsi (العضلة العريضة الظهرية) - Functional anatomical muscle.', 'Spinous processes T7-L5, posterior iliac crest, thoracolumbar fascia, inferior angle of scapula', 'Floor of bicipital groove of humerus', 'Extension, adduction, internal rotation; depressor (particularly during abduction)', 'Thoracodorsal nerve (C6-C8)', 'Thoracodorsal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Latissimus_dorsi.png/600px-Latissimus_dorsi.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Latissimus_dorsi.png/600px-Latissimus_dorsi.png" alt="Latissimus Dorsi" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('teres-major', 'AN-025', 'Teres Major', 'العضلة المدورة الكبيرة', 'shoulder', 'Teres Major (العضلة المدورة الكبيرة) - Functional anatomical muscle.', 'Inferior angle and lower lateral border of scapula', 'Medial lip of intertubercular groove of humerus', 'Internal rotation, adduction, extension of the shoulder', 'Lower subscapular nerve (C5-C7)', 'Circumflex scapular artery, thoracodorsal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Teres_major.png/600px-Teres_major.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Teres_major.png/600px-Teres_major.png" alt="Teres Major" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('coracobrachialis', 'AN-026', 'Coracobrachialis', 'العضلة الغرابية العضدية', 'shoulder', 'Coracobrachialis (العضلة الغرابية العضدية) - Functional anatomical muscle.', 'Apex of coracoid process of scapula', 'Medial shaft of humerus (middle third)', 'Shoulder flexion and adduction', 'Musculocutaneous nerve (C5-C7)', 'Anterior circumflex humeral artery, brachial branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Coracobrachialis.png/600px-Coracobrachialis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Coracobrachialis.png/600px-Coracobrachialis.png" alt="Coracobrachialis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('biceps-brachii-long-head', 'AN-027', 'Biceps Brachii Long Head', 'عضلة البايسبس - الرأس الطويل', 'arm', 'Biceps Brachii Long Head (عضلة البايسبس - الرأس الطويل) - Functional anatomical muscle.', 'Supraglenoid tubercle of scapula and superior glenoid labrum', 'Radial tuberosity and bicipital aponeurosis', 'Forearm supination, elbow flexion, glenohumeral humeral head depression', 'Musculocutaneous nerve (C5, C6)', 'Brachial artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png" alt="Biceps Brachii Long Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('biceps-brachii-short-head', 'AN-028', 'Biceps Brachii Short Head', 'عضلة البايسبس - الرأس القصير', 'arm', 'Biceps Brachii Short Head (عضلة البايسبس - الرأس القصير) - Functional anatomical muscle.', 'Coracoid process of scapula', 'Radial tuberosity and bicipital aponeurosis', 'Forearm supination, elbow flexion, shoulder flexion', 'Musculocutaneous nerve (C5, C6)', 'Brachial artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Biceps_brachii.png/600px-Biceps_brachii.png" alt="Biceps Brachii Short Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('brachialis', 'AN-029', 'Brachialis', 'العضلة العضدية', 'arm', 'Brachialis (العضلة العضدية) - Functional anatomical muscle.', 'Anterior surface of distal half of humerus', 'Superficial head: ulnar tuberosity via thick tendon; Deep head: coronoid process via aponeurosis', 'Elbow flexion (primary pure flexor, unaffected by forearm position)', 'Musculocutaneous nerve (C5-C6) to superficial head; radial nerve contribution to deep head (83.33% of cases)', 'Brachial artery, radial recurrent artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Brachialis.png/600px-Brachialis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Brachialis.png/600px-Brachialis.png" alt="Brachialis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('brachioradialis', 'AN-030', 'Brachioradialis', 'العضلة العضدية الكعبرية', 'arm', 'Brachioradialis (العضلة العضدية الكعبرية) - Functional anatomical muscle.', 'Proximal two-thirds of lateral supracondylar ridge of humerus', 'Lateral aspect of distal radius (styloid process)', 'Elbow flexion (most effective in neutral forearm), assists pronation from supinated and supination from pronated position', 'Radial nerve (C5-C6)', 'Radial recurrent artery, radial artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Brachioradialis.png/600px-Brachioradialis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Brachioradialis.png/600px-Brachioradialis.png" alt="Brachioradialis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('triceps-long-head', 'AN-031', 'Triceps Long Head', 'عضلة الترايسبس - الرأس الطويل', 'arm', 'Triceps Long Head (عضلة الترايسبس - الرأس الطويل) - Functional anatomical muscle.', 'Infraglenoid tubercle of scapula', 'Olecranon process of ulna', 'Elbow extension and shoulder adduction/extension', 'Radial nerve (C6-C8)', 'Profunda brachii artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png" alt="Triceps Long Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('triceps-lateral-head', 'AN-032', 'Triceps Lateral Head', 'عضلة الترايسبس - الرأس الوحشي', 'arm', 'Triceps Lateral Head (عضلة الترايسبس - الرأس الوحشي) - Functional anatomical muscle.', 'Posterior humerus superior and lateral to radial groove', 'Olecranon process of ulna', 'Elbow extension under resistance', 'Radial nerve (C6-C8)', 'Profunda brachii artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png" alt="Triceps Lateral Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('triceps-medial-head', 'AN-033', 'Triceps Medial Head', 'عضلة الترايسبس - الرأس الإنسي', 'arm', 'Triceps Medial Head (عضلة الترايسبس - الرأس الإنسي) - Functional anatomical muscle.', 'Posterior humerus inferior and medial to radial groove', 'Olecranon process of ulna', 'Elbow extension at all joint angles', 'Radial nerve (C7, C8)', 'Profunda brachii artery, superior ulnar collateral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Triceps_brachii.png/600px-Triceps_brachii.png" alt="Triceps Medial Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('anconeus', 'AN-034', 'Anconeus', 'العضلة المرفقية', 'arm', 'Anconeus (العضلة المرفقية) - Functional anatomical muscle.', 'Lateral epicondyle of humerus', 'Lateral olecranon and proximal ulna', 'Elbow extension assist, dynamic stabilization of ulnohumeral joint', 'Radial nerve (triceps-anconeus branch); double innervation from posterior interosseous nerve branch in 70.4%', 'Interosseous recurrent artery, middle collateral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Anconeus.png/600px-Anconeus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Anconeus.png/600px-Anconeus.png" alt="Anconeus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pronator-teres', 'AN-035', 'Pronator Teres', 'العضلة الكابة المدورة', 'arm', 'Pronator Teres (العضلة الكابة المدورة) - Functional anatomical muscle.', 'Medial epicondyle of humerus (humeral head), coronoid process of ulna (ulnar head)', 'Middle of lateral surface of radius', 'Forearm pronation, weak elbow flexion', 'Median nerve (C6, C7)', 'Ulnar artery, anterior ulnar recurrent artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Pronator_teres.png/600px-Pronator_teres.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Pronator_teres.png/600px-Pronator_teres.png" alt="Pronator Teres" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pronator-quadratus', 'AN-036', 'Pronator Quadratus', 'العضلة الكابة المربعة', 'arm', 'Pronator Quadratus (العضلة الكابة المربعة) - Functional anatomical muscle.', 'Distal anterior ulna', 'Distal anterior radius', 'Forearm pronation (primary pronator)', 'Anterior interosseous nerve (branch of median nerve, C7-C8)', 'Anterior interosseous artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Pronator_quadratus.png/600px-Pronator_quadratus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Pronator_quadratus.png/600px-Pronator_quadratus.png" alt="Pronator Quadratus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('supinator', 'AN-037', 'Supinator', 'العضلة الباطحة', 'arm', 'Supinator (العضلة الباطحة) - Functional anatomical muscle.', 'Lateral epicondyle of humerus, supinator crest of ulna', 'Lateral surface of proximal radius', 'Forearm supination', 'Deep branch of radial nerve (C5, C6)', 'Radial recurrent artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Supinator.png/600px-Supinator.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Supinator.png/600px-Supinator.png" alt="Supinator" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('flexor-carpi-radialis', 'AN-038', 'Flexor Carpi Radialis', 'العضلة قابضة الرسغ الكعبرية', 'arm', 'Flexor Carpi Radialis (العضلة قابضة الرسغ الكعبرية) - Functional anatomical muscle.', 'Medial epicondyle of humerus (common flexor origin)', 'Base of 2nd and 3rd metacarpals', 'Wrist flexion, radial deviation', 'Median nerve (C6, C7)', 'Radial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Flexor_carpi_radialis.png/600px-Flexor_carpi_radialis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Flexor_carpi_radialis.png/600px-Flexor_carpi_radialis.png" alt="Flexor Carpi Radialis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('flexor-carpi-ulnaris', 'AN-039', 'Flexor Carpi Ulnaris', 'العضلة قابضة الرسغ الزندية', 'arm', 'Flexor Carpi Ulnaris (العضلة قابضة الرسغ الزندية) - Functional anatomical muscle.', 'Medial epicondyle (humeral head), olecranon and posterior ulna (ulnar head)', 'Pisiform, hook of hamate, base of 5th metacarpal', 'Wrist flexion, ulnar deviation', 'Ulnar nerve (C7, C8)', 'Ulnar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Flexor_carpi_ulnaris.png/600px-Flexor_carpi_ulnaris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Flexor_carpi_ulnaris.png/600px-Flexor_carpi_ulnaris.png" alt="Flexor Carpi Ulnaris" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('palmaris-longus', 'AN-040', 'Palmaris Longus', 'العضلة الراحية الطويلة', 'arm', 'Palmaris Longus (العضلة الراحية الطويلة) - Functional anatomical muscle.', 'Medial epicondyle via anterior common tendon', 'Palmar aponeurosis', 'Weak wrist flexion, tenses palmar aponeurosis', 'Median nerve (C7-C8)', 'Branches from median nerve artery and ulnar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Palmaris_longus.png/600px-Palmaris_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Palmaris_longus.png/600px-Palmaris_longus.png" alt="Palmaris Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-carpi-radialis-longus', 'AN-041', 'Extensor Carpi Radialis Longus', 'العضلة باسطة الرسغ الكعبرية الطويلة', 'arm', 'Extensor Carpi Radialis Longus (العضلة باسطة الرسغ الكعبرية الطويلة) - Functional anatomical muscle.', 'Lateral supracondylar ridge of humerus', 'Base of 2nd metacarpal', 'Wrist extension, radial deviation', 'Radial nerve (C6, C7)', 'Radial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Extensor_carpi_radialis_longus.png/600px-Extensor_carpi_radialis_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Extensor_carpi_radialis_longus.png/600px-Extensor_carpi_radialis_longus.png" alt="Extensor Carpi Radialis Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-carpi-radialis-brevis', 'AN-042', 'Extensor Carpi Radialis Brevis', 'العضلة باسطة الرسغ الكعبرية القصيرة', 'arm', 'Extensor Carpi Radialis Brevis (العضلة باسطة الرسغ الكعبرية القصيرة) - Functional anatomical muscle.', 'Lateral epicondyle via long, wide tendinous origin on anterior slope', 'Base of 3rd metacarpal (dorsal surface)', 'Wrist extension, radial deviation', 'Posterior interosseous nerve (C6-C7)', 'Radial artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Extensor_carpi_radialis_brevis.png/600px-Extensor_carpi_radialis_brevis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Extensor_carpi_radialis_brevis.png/600px-Extensor_carpi_radialis_brevis.png" alt="Extensor Carpi Radialis Brevis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-carpi-ulnaris', 'AN-043', 'Extensor Carpi Ulnaris', 'العضلة باسطة الرسغ الزندية', 'arm', 'Extensor Carpi Ulnaris (العضلة باسطة الرسغ الزندية) - Functional anatomical muscle.', 'Lateral epicondyle and posterior ulnar border', 'Base of 5th metacarpal (dorsal surface)', 'Wrist extension, ulnar deviation', 'Posterior interosseous nerve (C7-C8)', 'Posterior interosseous artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Extensor_carpi_ulnaris.png/600px-Extensor_carpi_ulnaris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Extensor_carpi_ulnaris.png/600px-Extensor_carpi_ulnaris.png" alt="Extensor Carpi Ulnaris" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-digitorum', 'AN-044', 'Extensor Digitorum', 'العضلة باسطة الأصابع', 'arm', 'Extensor Digitorum (العضلة باسطة الأصابع) - Functional anatomical muscle.', 'Lateral epicondyle of humerus (common extensor origin)', 'Extensor expansions of fingers 2-5', 'Extension of MCP joints of fingers 2-5; assists wrist extension', 'Posterior interosseous nerve (C7, C8)', 'Posterior interosseous artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Extensor_digitorum.png/600px-Extensor_digitorum.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Extensor_digitorum.png/600px-Extensor_digitorum.png" alt="Extensor Digitorum" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('rectus-abdominis', 'AN-045', 'Rectus Abdominis', 'العضلة البطنية المستقيمة', 'spine_core', 'Rectus Abdominis (العضلة البطنية المستقيمة) - Functional anatomical muscle.', 'Pubic symphysis, pubic crest', 'Costal cartilages of ribs 5-7, xiphoid process', 'Trunk flexion, posterior pelvic tilt, compression of abdominal contents', 'Thoracolumbar nerves (T6-L1), with a constant branch from L1; umbilicus always innervated by T10', 'Superior epigastric artery, inferior epigastric artery, lower posterior intercostal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Rectus_abdominis.png/600px-Rectus_abdominis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Rectus_abdominis.png/600px-Rectus_abdominis.png" alt="Rectus Abdominis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('external-oblique', 'AN-046', 'External Oblique', 'العضلة المائلة الخارجية', 'spine_core', 'External Oblique (العضلة المائلة الخارجية) - Functional anatomical muscle.', 'External surfaces of ribs 5-12', 'Linea alba, pubic tubercle, anterior half of iliac crest', 'Contralateral trunk rotation, ipsilateral lateral flexion, trunk flexion, core stabilization', 'Thoracolumbar nerves (T5-T12)', 'Lower posterior intercostal arteries, subcostal artery, deep circumflex iliac artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/External_oblique.png/600px-External_oblique.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/External_oblique.png/600px-External_oblique.png" alt="External Oblique" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('internal-oblique', 'AN-047', 'Internal Oblique', 'العضلة المائلة الداخلية', 'spine_core', 'Internal Oblique (العضلة المائلة الداخلية) - Functional anatomical muscle.', 'Thoracolumbar fascia, iliac crest, lateral two-thirds of inguinal ligament', 'Lower ribs (10-12), linea alba, pubic crest', 'Ipsilateral trunk rotation, lateral flexion, trunk flexion; highest activity during IAP generation tasks', 'Thoracolumbar nerves (T6-L1), with 10th intercostal nerve providing a median of 9 branches', 'Lower posterior intercostal arteries, deep circumflex iliac artery, deep inferior epigastric artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Internal_oblique.png/600px-Internal_oblique.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Internal_oblique.png/600px-Internal_oblique.png" alt="Internal Oblique" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('transverse-abdominis', 'AN-048', 'Transverse Abdominis', 'العضلة البطنية المستعرضة', 'spine_core', 'Transverse Abdominis (العضلة البطنية المستعرضة) - Functional anatomical muscle.', 'Costal cartilages 7-12, thoracolumbar fascia, iliac crest, inguinal ligament', 'Linea alba, pubic crest, pecten pubis via conjoint tendon', 'Deep core stabilization, intra-abdominal pressure generation', 'Thoracoabdominal nerves (T7-T11), subcostal nerve (T12), iliohypogastric/ilioinguinal (L1)', 'Deep circumflex iliac artery, inferior epigastric artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Transverse_abdominis.png/600px-Transverse_abdominis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Transverse_abdominis.png/600px-Transverse_abdominis.png" alt="Transverse Abdominis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('quadratus-lumborum', 'AN-049', 'Quadratus Lumborum', 'العضلة المربعة القطنية', 'spine_core', 'Quadratus Lumborum (العضلة المربعة القطنية) - Functional anatomical muscle.', 'Iliac crest, iliolumbar ligament', '12th rib, transverse processes of L1-L4', 'Lateral flexion, 12th rib stabilization during inspiration; modest direct action on lumbar spine (<10% of extensor/lateral bending moments)', 'Ventral rami of T12-L4, with motor neurons in both ventromedial and lateromedial nuclei', 'Lumbar arteries, subcostal artery, iliolumbar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Quadratus_lumborum.png/600px-Quadratus_lumborum.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Quadratus_lumborum.png/600px-Quadratus_lumborum.png" alt="Quadratus Lumborum" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('multifidus', 'AN-050', 'Multifidus', 'العضلة المتعددة الفصوص', 'spine_core', 'Multifidus (العضلة المتعددة الفصوص) - Functional anatomical muscle.', 'Posterior sacrum, superior iliac spine, mammillary processes of lumbar vertebrae, lateral sacral crest, thoracolumbar fascia (pennate bundle)', 'Spinous processes of lumbar vertebrae, typically 2-4 levels above', 'Segmental stabilization of the lumbar spine, extension, rotation control', 'Medial branches of lumbar dorsal rami (L1-L5); each medial branch innervates only fascicles arising from the spinous process with the same segmental number', 'Lumbar arteries (segmental branches from abdominal aorta)', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Multifidus.png/600px-Multifidus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Multifidus.png/600px-Multifidus.png" alt="Multifidus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('iliocostalis', 'AN-051', 'Iliocostalis', 'العضلة الحرقفية الضلعية', 'spine_core', 'Iliocostalis (العضلة الحرقفية الضلعية) - Functional anatomical muscle.', 'Thoracolumbar aponeurosis, sacrum, posterior iliac crest, angles of lower ribs', 'Angles of ribs 1-12, transverse processes of cervical vertebrae C4-C6', 'Spinal extension, lateral flexion of vertebral column', 'Posterior rami of spinal nerves', 'Posterior intercostal arteries, lumbar arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png" alt="Iliocostalis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('longissimus', 'AN-052', 'Longissimus', 'العضلة الطولى الظهرية', 'spine_core', 'Longissimus (العضلة الطولى الظهرية) - Functional anatomical muscle.', 'Thoracolumbar aponeurosis, transverse processes of lumbar/thoracic vertebrae', 'Transverse processes of thoracic and cervical vertebrae, mastoid process', 'Spinal extension, lateral flexion, ipsilateral head rotation', 'Posterior rami of spinal nerves', 'Intercostal and lumbar arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png" alt="Longissimus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('spinalis', 'AN-053', 'Spinalis', 'العضلة الشوكية', 'spine_core', 'Spinalis (العضلة الشوكية) - Functional anatomical muscle.', 'Spinous processes of upper lumbar and lower thoracic vertebrae', 'Spinous processes of upper thoracic and cervical vertebrae', 'Extension of vertebral column', 'Posterior rami of spinal nerves', 'Intercostal and deep cervical arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Erector_spinae.png/600px-Erector_spinae.png" alt="Spinalis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('rotatores', 'AN-054', 'Rotatores', 'العضلات المدوّرة للعمود الفقري', 'spine_core', 'Rotatores (العضلات المدوّرة للعمود الفقري) - Functional anatomical muscle.', 'Transverse processes of thoracic vertebrae', 'Lamina and spinous process of vertebra directly above (brevis) or 2 above (longus)', 'Contralateral spinal rotation, postural proprioception', 'Posterior rami of spinal nerves', 'Dorsal branches of intercostal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Rotatores.png/600px-Rotatores.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Rotatores.png/600px-Rotatores.png" alt="Rotatores" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('interspinales', 'AN-055', 'Interspinales', 'العضلات بين الشوكية', 'spine_core', 'Interspinales (العضلات بين الشوكية) - Functional anatomical muscle.', 'Spinous processes of vertebrae', 'Spinous process of vertebra above', 'Spinal extension and intersegmental stability', 'Posterior rami of spinal nerves', 'Spinal branches of intercostal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Interspinales.png/600px-Interspinales.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Interspinales.png/600px-Interspinales.png" alt="Interspinales" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('intertransversarii', 'AN-056', 'Intertransversarii', 'العضلات بين المستعرضة', 'spine_core', 'Intertransversarii (العضلات بين المستعرضة) - Functional anatomical muscle.', 'Transverse processes of vertebrae', 'Transverse process of vertebra above', 'Lateral flexion and motion segment stabilization', 'Anterior and posterior rami of spinal nerves', 'Deep cervical and lumbar arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Intertransversarii.png/600px-Intertransversarii.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Intertransversarii.png/600px-Intertransversarii.png" alt="Intertransversarii" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('diaphragm', 'AN-057', 'Diaphragm', 'عضلة الحجاب الحاجز', 'spine_core', 'Diaphragm (عضلة الحجاب الحاجز) - Functional anatomical muscle.', 'Xiphoid process, costal cartilages of ribs 7-12, lumbar vertebrae (crura attach to L1-L3)', 'Central tendon', 'Respiration (primary), increases intra-abdominal pressure, contributes to spinal stabilization by increasing intervertebral stiffness', 'Phrenic nerve (C3-C5)', 'Phrenic arteries, musculophrenic arteries, lower posterior intercostal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Diaphragm.png/600px-Diaphragm.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Diaphragm.png/600px-Diaphragm.png" alt="Diaphragm" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('levator-ani', 'AN-058', 'Levator Ani', 'العضلة الرافعة للشرج', 'spine_core', 'Levator Ani (العضلة الرافعة للشرج) - Functional anatomical muscle.', 'Body of pubis, tendinous arch of obturator fascia, ischial spine', 'Perineal body, coccyx, anococcygeal raphe', 'Supports pelvic floor viscera, resists intra-abdominal pressure', 'Nerve to levator ani (S4), pudendal nerve (S2-S4)', 'Inferior gluteal and internal pudendal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Levator_ani.png/600px-Levator_ani.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Levator_ani.png/600px-Levator_ani.png" alt="Levator Ani" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('coccygeus', 'AN-059', 'Coccygeus', 'العضلة العصعصية', 'spine_core', 'Coccygeus (العضلة العصعصية) - Functional anatomical muscle.', 'Ischial spine and sacrospinous ligament', 'Lateral margins of coccyx and sacrum', 'Supports pelvic floor, flexes coccyx', 'Anterior rami of S4-S5 spinal nerves', 'Inferior gluteal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Coccygeus.png/600px-Coccygeus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Coccygeus.png/600px-Coccygeus.png" alt="Coccygeus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('trapezius-upper', 'AN-060', 'Trapezius Upper', 'العضلة الشبه منحرفة - العلوي', 'spine_core', 'Trapezius Upper (العضلة الشبه منحرفة - العلوي) - Functional anatomical muscle.', 'External occipital protuberance, medial superior nuchal line, ligamentum nuchae, C7 spinous process', 'Lateral third of clavicle, acromion', 'Scapular elevation, upward rotation; draws scapula backward; raises scapula by rotating clavicle', 'Spinal accessory nerve (CN XI), with proprioceptive and motor contributions from C3-C4', 'Transverse cervical artery, occipital artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Trapezius.png/600px-Trapezius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Trapezius.png/600px-Trapezius.png" alt="Trapezius Upper" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gluteus-maximus', 'AN-061', 'Gluteus Maximus', 'العضلة الألية الكبرى', 'hip_pelvis', 'Gluteus Maximus (العضلة الألية الكبرى) - Functional anatomical muscle.', 'Posterior gluteal line of ilium, dorsal surface of sacrum and coccyx, sacrotuberous ligament', 'Superior three-fourths: gluteal tuberosity of femur via plate-like distal tendon, with partial adhesions to iliotibial tract; inferior portion: lateral femoral intermuscular septum complex', 'Hip extension, external rotation; upper fibers assist abduction, lower fibers assist adduction', 'Inferior gluteal nerve (L5-S2)', 'Superior and inferior gluteal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Gluteus_maximus.png/600px-Gluteus_maximus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Gluteus_maximus.png/600px-Gluteus_maximus.png" alt="Gluteus Maximus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gluteus-medius', 'AN-062', 'Gluteus Medius', 'العضلة الألية المتوسطة', 'hip_pelvis', 'Gluteus Medius (العضلة الألية المتوسطة) - Functional anatomical muscle.', 'Gluteal fossa (between anterior and posterior gluteal lines), gluteal aponeurosis, posteroinferior edge of iliac crest', 'Lateral and superoposterior facets of greater trochanter via lateral and posterior tendon parts', 'Anterior fibers: abduction and internal rotation; middle fibers: abduction; posterior fibers: abduction and external rotation; primary hip stabilizer during initial gait phase and pelvic rotation', 'Superior gluteal nerve (L4-S1) with 3-4 branches supplying different muscle regions', 'Superior gluteal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Gluteus_medius.png/600px-Gluteus_medius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Gluteus_medius.png/600px-Gluteus_medius.png" alt="Gluteus Medius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gluteus-minimus', 'AN-063', 'Gluteus Minimus', 'العضلة الألية الصغرى', 'hip_pelvis', 'Gluteus Minimus (العضلة الألية الصغرى) - Functional anatomical muscle.', 'Gluteal fossa (between anterior and inferior gluteal lines)', 'Anterior facet of greater trochanter and hip joint capsule', 'Hip abduction, internal rotation; primary hip stabilizer during mid- and late gait cycle', 'Superior gluteal nerve (L4-S1) with distinct secondary nerve branches entering four muscle regions', 'Superior gluteal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Gluteus_minimus.png/600px-Gluteus_minimus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Gluteus_minimus.png/600px-Gluteus_minimus.png" alt="Gluteus Minimus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('tensor-fasciae-latae', 'AN-064', 'Tensor Fasciae Latae', 'العضلة موترة اللفافة العريضة', 'hip_pelvis', 'Tensor Fasciae Latae (العضلة موترة اللفافة العريضة) - Functional anatomical muscle.', 'Anterior superior iliac spine (ASIS) and outer lip of iliac crest', 'Iliotibial band (IT band)', 'Hip flexion, abduction, internal rotation; tenses the fascia lata', 'Superior gluteal nerve (L4-S1)', 'Ascending branch of lateral circumflex femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Tensor_fasciae_latae.png/600px-Tensor_fasciae_latae.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Tensor_fasciae_latae.png/600px-Tensor_fasciae_latae.png" alt="Tensor Fasciae Latae" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('piriformis', 'AN-065', 'Piriformis', 'العضلة الكمثرية', 'hip_pelvis', 'Piriformis (العضلة الكمثرية) - Functional anatomical muscle.', 'Anterior surface of sacrum (S2-S4)', 'Superior border of greater trochanter', 'External rotation, abduction (particularly with hip in slight extension); hip stabilization', 'Nerve to piriformis (S1-S2)', 'Superior and inferior gluteal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Piriformis.png/600px-Piriformis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Piriformis.png/600px-Piriformis.png" alt="Piriformis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('obturator-internus', 'AN-066', 'Obturator Internus', 'العضلة السدادية الداخلية', 'hip_pelvis', 'Obturator Internus (العضلة السدادية الداخلية) - Functional anatomical muscle.', 'Inner surface of obturator membrane and surrounding pelvic bone', 'Medial surface of greater trochanter (forms continuum with gemelli)', 'External rotation, hip stabilization', 'Nerve to obturator internus (L5-S2)', 'Internal pudendal artery, obturator artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Obturator_internus.png/600px-Obturator_internus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Obturator_internus.png/600px-Obturator_internus.png" alt="Obturator Internus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('obturator-externus', 'AN-067', 'Obturator Externus', 'العضلة السدادية الخارجية', 'hip_pelvis', 'Obturator Externus (العضلة السدادية الخارجية) - Functional anatomical muscle.', 'Outer surface of obturator membrane and pubic ramus', 'Trochanteric fossa of femur', 'External rotation, adduction', 'Posterior branch of obturator nerve (L3-L4)', 'Obturator artery, medial circumflex femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Obturator_externus.png/600px-Obturator_externus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Obturator_externus.png/600px-Obturator_externus.png" alt="Obturator Externus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gemellus-superior', 'AN-068', 'Gemellus Superior', 'العضلة التوأمية العلوية', 'hip_pelvis', 'Gemellus Superior (العضلة التوأمية العلوية) - Functional anatomical muscle.', 'Ischial spine', 'Medial surface of greater trochanter of femur with obturator internus', 'Hip external rotation in extension, hip abduction in flexion', 'Nerve to obturator internus (L5-S2)', 'Inferior gluteal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Gemellus_superior.png/600px-Gemellus_superior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Gemellus_superior.png/600px-Gemellus_superior.png" alt="Gemellus Superior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gemellus-inferior', 'AN-069', 'Gemellus Inferior', 'العضلة التوأمية السفلية', 'hip_pelvis', 'Gemellus Inferior (العضلة التوأمية السفلية) - Functional anatomical muscle.', 'Ischial tuberosity', 'Medial surface of greater trochanter of femur with obturator internus', 'Hip external rotation in extension, hip abduction in flexion', 'Nerve to quadratus femoris (L4-S1)', 'Inferior gluteal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Gemellus_inferior.png/600px-Gemellus_inferior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Gemellus_inferior.png/600px-Gemellus_inferior.png" alt="Gemellus Inferior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('quadratus-femoris', 'AN-070', 'Quadratus Femoris', 'العضلة المربعة الفخذية', 'hip_pelvis', 'Quadratus Femoris (العضلة المربعة الفخذية) - Functional anatomical muscle.', 'Lateral border of ischial tuberosity', 'Intertrochanteric crest and quadrate tubercle of femur', 'External rotation, adduction', 'Nerve to quadratus femoris (L4-S1)', 'Inferior gluteal artery, medial circumflex femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Quadratus_femoris.png/600px-Quadratus_femoris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Quadratus_femoris.png/600px-Quadratus_femoris.png" alt="Quadratus Femoris" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('psoas-major', 'AN-071', 'Psoas Major', 'العضلة القطنية الكبرى', 'hip_pelvis', 'Psoas Major (العضلة القطنية الكبرى) - Functional anatomical muscle.', 'Transverse processes L1-L5, vertebral bodies T12-L5', 'Lesser trochanter of femur via conjoint iliopsoas tendon', 'Primary hip flexor, trunk flexion from supine, lumbar stabilizer', 'Anterior rami of lumbar spinal nerves L1-L3', 'Lumbar arteries, iliolumbar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Psoas_major.png/600px-Psoas_major.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Psoas_major.png/600px-Psoas_major.png" alt="Psoas Major" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('psoas-minor', 'AN-072', 'Psoas Minor', 'العضلة القطنية الصغرى', 'hip_pelvis', 'Psoas Minor (العضلة القطنية الصغرى) - Functional anatomical muscle.', 'Vertebral bodies T12 and L1 and intervertebral disc', 'Pectineal line of pubis, iliopubic eminence', 'Weak trunk flexor, tenses iliac fascia', 'Anterior ramus of L1 spinal nerve', 'Lumbar arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Psoas_minor.png/600px-Psoas_minor.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Psoas_minor.png/600px-Psoas_minor.png" alt="Psoas Minor" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('iliacus', 'AN-073', 'Iliacus', 'العضلة الحرقفية', 'hip_pelvis', 'Iliacus (العضلة الحرقفية) - Functional anatomical muscle.', 'Superior two-thirds of iliac fossa, internal lip of iliac crest, ala of sacrum', 'Lesser trochanter of femur with psoas major tendon', 'Hip flexion and anterior pelvic tilt', 'Femoral nerve (L2-L4)', 'Iliolumbar artery, medial circumflex femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Iliacus.png/600px-Iliacus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Iliacus.png/600px-Iliacus.png" alt="Iliacus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pectineus', 'AN-074', 'Pectineus', 'العضلة العانية', 'hip_pelvis', 'Pectineus (العضلة العانية) - Functional anatomical muscle.', 'Pectineal line of pubis', 'Pectineal line of femur (posterior to lesser trochanter)', 'Hip flexion, adduction; hip stabilizer during rotational movements', 'Femoral nerve (L2-L3), may receive accessory innervation from obturator nerve', 'Medial circumflex femoral artery, obturator artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png" alt="Pectineus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('adductor-longus', 'AN-075', 'Adductor Longus', 'العضلة المقربة الطويلة', 'hip_pelvis', 'Adductor Longus (العضلة المقربة الطويلة) - Functional anatomical muscle.', 'Anterosuperior aspect of pubic body', 'Middle third of linea aspera', 'Adduction, flexion, internal rotation', 'Anterior branch of obturator nerve (L2-L4)', 'Medial circumflex femoral artery, obturator artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Adductor_longus.png/600px-Adductor_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Adductor_longus.png/600px-Adductor_longus.png" alt="Adductor Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('adductor-brevis', 'AN-076', 'Adductor Brevis', 'العضلة المقربة القصيرة', 'hip_pelvis', 'Adductor Brevis (العضلة المقربة القصيرة) - Functional anatomical muscle.', 'Anteroinferior aspect of pubic body and inferior pubic ramus', 'Proximal linea aspera and pectineal line', 'Adduction, flexion', 'Anterior branch of obturator nerve (L2-L4)', 'Medial circumflex femoral artery, obturator artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Adductor_brevis.png/600px-Adductor_brevis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Adductor_brevis.png/600px-Adductor_brevis.png" alt="Adductor Brevis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('adductor-magnus', 'AN-077', 'Adductor Magnus', 'العضلة المقربة الكبيرة', 'knee_thigh', 'Adductor Magnus (العضلة المقربة الكبيرة) - Functional anatomical muscle.', 'Adductor portion: inferior pubic ramus and ischial ramus; Hamstring portion: ischial tuberosity', 'Adductor portion: linea aspera; Hamstring portion: adductor tubercle of femur', 'Adduction; adductor portion also flexes and internally rotates; hamstring portion extends and externally rotates', 'Dual innervation: adductor portion receives both posterior branch of obturator nerve (L2-L4) and tibial portion of sciatic nerve (L4-S1) in >90% of cases; hamstring portion receives tibial nerve', 'Medial circumflex femoral artery, perforating branches of profunda femoris', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Adductor_magnus.png/600px-Adductor_magnus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Adductor_magnus.png/600px-Adductor_magnus.png" alt="Adductor Magnus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gracilis', 'AN-078', 'Gracilis', 'العضلة الرشيقة', 'knee_thigh', 'Gracilis (العضلة الرشيقة) - Functional anatomical muscle.', 'Body and inferior ramus of pubis', 'Medial surface of proximal tibia (pes anserinus)', 'Hip adduction, knee flexion, knee internal rotation', 'Obturator nerve (L2-L3)', 'Main pedicle from medial femoral circumflex or profunda femoris (~10 cm from origin); 1-3 distal branches from superficial femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gracilis.png/600px-Gracilis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Gracilis.png/600px-Gracilis.png" alt="Gracilis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('sartorius', 'AN-079', 'Sartorius', 'العضلة الخياطية', 'knee_thigh', 'Sartorius (العضلة الخياطية) - Functional anatomical muscle.', 'Anterior superior iliac spine', 'Medial surface of proximal tibia (pes anserinus)', 'Hip flexion, hip external rotation, hip abduction; knee flexion', 'Femoral nerve (L2-L3); typically 2 branches', 'Multiple vascular pedicles (average 6-7) from femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Sartorius.png/600px-Sartorius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Sartorius.png/600px-Sartorius.png" alt="Sartorius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('rectus-femoris', 'AN-080', 'Rectus Femoris', 'العضلة الفخذية المستقيمة', 'knee_thigh', 'Rectus Femoris (العضلة الفخذية المستقيمة) - Functional anatomical muscle.', 'Anterior inferior iliac spine (straight head) and ilium above acetabulum (reflected head)', 'Patella via quadriceps tendon, then tibial tuberosity via patellar ligament', 'Knee extension, hip flexion', 'Femoral nerve (L2-L4)', 'Lateral femoral circumflex artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png" alt="Rectus Femoris" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('vastus-lateralis', 'AN-081', 'Vastus Lateralis', 'العضلة المتسعة الوحشية', 'knee_thigh', 'Vastus Lateralis (العضلة المتسعة الوحشية) - Functional anatomical muscle.', 'Lateral lip of linea aspera, greater trochanter, intertrochanteric line', 'Patella (lateral aspect) via quadriceps tendon; consists of superficial, intermediate, and deep layers', 'Knee extension; acts as general joint stabilizer with activation independent of moment direction', 'Femoral nerve (L2-L4)', 'Lateral femoral circumflex artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Vastus_lateralis.png/600px-Vastus_lateralis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Vastus_lateralis.png/600px-Vastus_lateralis.png" alt="Vastus Lateralis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('vastus-medialis-oblique-vmo', 'AN-082', 'Vastus Medialis Oblique (VMO)', 'العضلة المتسعة الإنسية', 'knee_thigh', 'Vastus Medialis Oblique (VMO) (العضلة المتسعة الإنسية) - Functional anatomical muscle.', 'Distal medial lip of linea aspera and medial supracondylar line of femur', 'Medial border of patella and medial patellar retinaculum', 'Terminal knee extension, medial patellar stabilization', 'Femoral nerve (L2-L4)', 'Descending genicular artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Vastus_medialis.png/600px-Vastus_medialis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Vastus_medialis.png/600px-Vastus_medialis.png" alt="Vastus Medialis Oblique (VMO)" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('vastus-intermedius', 'AN-083', 'Vastus Intermedius', 'العضلة المتسعة المتوسطة', 'knee_thigh', 'Vastus Intermedius (العضلة المتسعة المتوسطة) - Functional anatomical muscle.', 'Anterior and lateral surface of femoral shaft', 'Patella (deep layer) via quadriceps tendon; forms complex multi-layered structure with VM', 'Knee extension', 'Femoral nerve (L2-L4), with medial portions sharing innervation with VM', 'Lateral femoral circumflex artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Vastus_intermedius.png/600px-Vastus_intermedius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Vastus_intermedius.png/600px-Vastus_intermedius.png" alt="Vastus Intermedius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('biceps-femoris-long-head', 'AN-084', 'Biceps Femoris Long Head', 'عضلة الفخذ الخلفية - الرأس الطويل', 'knee_thigh', 'Biceps Femoris Long Head (عضلة الفخذ الخلفية - الرأس الطويل) - Functional anatomical muscle.', 'Ischial tuberosity (conjoint tendon with semitendinosus)', 'Head of fibula, lateral tibial condyle', 'Knee flexion, hip extension, knee external rotation', 'Tibial division of sciatic nerve (L5-S2); typically 1-2 branches', 'Perforating branches of profunda femoris artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png" alt="Biceps Femoris Long Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('biceps-femoris-short-head', 'AN-085', 'Biceps Femoris Short Head', 'عضلة الفخذ الخلفية - الرأس القصير', 'knee_thigh', 'Biceps Femoris Short Head (عضلة الفخذ الخلفية - الرأس القصير) - Functional anatomical muscle.', 'Lateral lip of linea aspera, lateral supracondylar line', 'Head of fibula (joins long head tendon)', 'Knee flexion, knee external rotation', 'Common fibular (peroneal) division of sciatic nerve (L5-S2); single branch', 'Perforating branches of profunda femoris artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Biceps_femoris.png/600px-Biceps_femoris.png" alt="Biceps Femoris Short Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('semitendinosus', 'AN-086', 'Semitendinosus', 'العضلة نصف الوترية', 'knee_thigh', 'Semitendinosus (العضلة نصف الوترية) - Functional anatomical muscle.', 'Ischial tuberosity (conjoint tendon with biceps femoris long head)', 'Medial surface of proximal tibia (pes anserinus)', 'Knee flexion, hip extension, knee internal rotation', 'Tibial division of sciatic nerve (L5-S2); always 2 branches (superior and inferior)', 'Perforating branches of profunda femoris artery, superficial femoral artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Semitendinosus.png/600px-Semitendinosus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Semitendinosus.png/600px-Semitendinosus.png" alt="Semitendinosus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('semimembranosus', 'AN-087', 'Semimembranosus', 'العضلة نصف الغشائية', 'knee_thigh', 'Semimembranosus (العضلة نصف الغشائية) - Functional anatomical muscle.', 'Ischial tuberosity (separate from conjoint tendon)', 'Posterior medial tibial condyle with multiple expansions', 'Knee flexion, hip extension, knee internal rotation', 'Tibial division of sciatic nerve (L5-S2); usually single branch', 'Perforating branches of profunda femoris artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Semimembranosus.png/600px-Semimembranosus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Semimembranosus.png/600px-Semimembranosus.png" alt="Semimembranosus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('popliteus', 'AN-088', 'Popliteus', 'العضلة المأبضية', 'knee_thigh', 'Popliteus (العضلة المأبضية) - Functional anatomical muscle.', 'Lateral femoral condyle, popliteofibular ligament', 'Posterior tibia (proximal 16.6-35.2% of tibial length)', 'Knee internal rotation, ''unlocking'' the knee from full extension, posterolateral stabilization', 'Tibial nerve (L4-S1); 90% tibial nerve alone, 10% tibial and sciatic', 'Inferior medial genicular artery (90%), posterior tibial artery (65%)', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Popliteus.png/600px-Popliteus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Popliteus.png/600px-Popliteus.png" alt="Popliteus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('plantaris', 'AN-089', 'Plantaris', 'العضلة الاخمصية', 'knee_thigh', 'Plantaris (العضلة الاخمصية) - Functional anatomical muscle.', 'Lateral supracondylar line of femur, oblique popliteal ligament', 'Calcaneus (medial to Achilles tendon)', 'Weak knee flexion, weak ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Popliteal artery branches', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Plantaris.png/600px-Plantaris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Plantaris.png/600px-Plantaris.png" alt="Plantaris" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('articularis-genus', 'AN-090', 'Articularis Genus', 'العضلة المفصلية للركبة', 'knee_thigh', 'Articularis Genus (العضلة المفصلية للركبة) - Functional anatomical muscle.', 'Anterior surface of distal femur below vastus intermedius', 'Synovial membrane of suprapatellar bursa', 'Retracts suprapatellar bursa during knee extension to prevent impingement', 'Femoral nerve (L2-L4)', 'Descending genicular artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rectus_femoris.png/600px-Rectus_femoris.png" alt="Articularis Genus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('pectineus-minor', 'AN-091', 'Pectineus Minor', 'العضلة العانية الفرعية', 'knee_thigh', 'Pectineus Minor (العضلة العانية الفرعية) - Functional anatomical muscle.', 'Pectineal line of pubis', 'Pectineal line of femur', 'Hip adduction and flexion assistance', 'Femoral nerve (L2, L3)', 'Medial circumflex femoral artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Pectineus.png/600px-Pectineus.png" alt="Pectineus Minor" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('tibialis-anterior', 'AN-092', 'Tibialis Anterior', 'العضلة القصبية الأمامية', 'ankle_foot', 'Tibialis Anterior (العضلة القصبية الأمامية) - Functional anatomical muscle.', 'Lateral tibial condyle, upper two-thirds of lateral tibial surface, interosseous membrane', 'Medial cuneiform and base of 1st metatarsal', 'Ankle dorsiflexion, foot inversion', 'Deep peroneal nerve (L4, L5)', 'Anterior tibial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png" alt="Tibialis Anterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('tibialis-posterior', 'AN-093', 'Tibialis Posterior', 'العضلة القصبية الخلفية', 'ankle_foot', 'Tibialis Posterior (العضلة القصبية الخلفية) - Functional anatomical muscle.', 'Posterior tibia, fibula, and interosseous membrane', 'Navicular tuberosity and plantar surfaces of cuneiforms and metatarsals 2-4', 'Foot inversion, assists plantarflexion, supports medial longitudinal arch', 'Tibial nerve (L4, L5)', 'Posterior tibial artery, peroneal artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Tibialis_posterior.png/600px-Tibialis_posterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Tibialis_posterior.png/600px-Tibialis_posterior.png" alt="Tibialis Posterior" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gastrocnemius-lateral-head', 'AN-094', 'Gastrocnemius Lateral Head', 'عضلة السمانة - الرأس الوحشي', 'ankle_foot', 'Gastrocnemius Lateral Head (عضلة السمانة - الرأس الوحشي) - Functional anatomical muscle.', 'Lateral condyle and posterolateral surface of femur', 'Posterior surface of calcaneus via Achilles tendon', 'Ankle plantarflexion and knee flexion assistance', 'Tibial nerve (S1, S2)', 'Sural arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png" alt="Gastrocnemius Lateral Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('gastrocnemius-medial-head', 'AN-095', 'Gastrocnemius Medial Head', 'عضلة السمانة - الرأس الإنسي', 'ankle_foot', 'Gastrocnemius Medial Head (عضلة السمانة - الرأس الإنسي) - Functional anatomical muscle.', 'Popliteal surface of femur superior to medial condyle', 'Posterior surface of calcaneus via Achilles tendon', 'Ankle plantarflexion and knee flexion', 'Tibial nerve (S1, S2)', 'Sural arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Gastrocnemius.png/600px-Gastrocnemius.png" alt="Gastrocnemius Medial Head" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('soleus', 'AN-096', 'Soleus', 'العضلة النعلية', 'ankle_foot', 'Soleus (العضلة النعلية) - Functional anatomical muscle.', 'Posterior surface of fibular head, proximal tibia (soleal line)', 'Calcaneus via Achilles tendon', 'Ankle plantarflexion (especially during slow/postural activities); selectively activated with knee extension', 'Tibial nerve (S1-S2)', 'Posterior tibial artery, peroneal artery (dual supply)', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Soleus.png/600px-Soleus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Soleus.png/600px-Soleus.png" alt="Soleus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('fibularis-peroneus-longus', 'AN-097', 'Fibularis (Peroneus) Longus', 'العضلة الشظوية الطويلة', 'ankle_foot', 'Fibularis (Peroneus) Longus (العضلة الشظوية الطويلة) - Functional anatomical muscle.', 'Head and upper two-thirds of lateral fibula', 'Medial cuneiform and base of 1st metatarsal', 'Foot eversion, ankle plantarflexion, supports transverse arch', 'Superficial fibular (peroneal) nerve (L5, S1, S2)', 'Fibular artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Fibularis_longus.png/600px-Fibularis_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Fibularis_longus.png/600px-Fibularis_longus.png" alt="Fibularis (Peroneus) Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('fibularis-peroneus-brevis', 'AN-098', 'Fibularis (Peroneus) Brevis', 'العضلة الشظوية القصيرة', 'ankle_foot', 'Fibularis (Peroneus) Brevis (العضلة الشظوية القصيرة) - Functional anatomical muscle.', 'Lower two-thirds of lateral fibula', 'Tuberosity on base of 5th metatarsal', 'Foot eversion', 'Superficial fibular (peroneal) nerve (L5, S1)', 'Fibular artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Fibularis_brevis.png/600px-Fibularis_brevis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Fibularis_brevis.png/600px-Fibularis_brevis.png" alt="Fibularis (Peroneus) Brevis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('fibularis-peroneus-tertius', 'AN-099', 'Fibularis (Peroneus) Tertius', 'العضلة الشظوية الثالثة', 'ankle_foot', 'Fibularis (Peroneus) Tertius (العضلة الشظوية الثالثة) - Functional anatomical muscle.', 'Distal third of anterior fibula and interosseous membrane', 'Dorsal surface of base of 5th metatarsal', 'Foot dorsiflexion and foot eversion', 'Deep fibular nerve (L5, S1)', 'Anterior tibial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Tibialis_anterior.png/600px-Tibialis_anterior.png" alt="Fibularis (Peroneus) Tertius" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-hallucis-longus', 'AN-100', 'Extensor Hallucis Longus', 'العضلة باسطة إبهام القدم الطويلة', 'ankle_foot', 'Extensor Hallucis Longus (العضلة باسطة إبهام القدم الطويلة) - Functional anatomical muscle.', 'Middle fibula, interosseous membrane', 'Distal phalanx of great toe', 'Great toe extension, assists ankle dorsiflexion', 'Deep peroneal nerve (L5-S1)', 'Anterior tibial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Extensor_hallucis_longus.png/600px-Extensor_hallucis_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Extensor_hallucis_longus.png/600px-Extensor_hallucis_longus.png" alt="Extensor Hallucis Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-digitorum-longus', 'AN-101', 'Extensor Digitorum Longus', 'العضلة باسطة أصابع القدم الطويلة', 'ankle_foot', 'Extensor Digitorum Longus (العضلة باسطة أصابع القدم الطويلة) - Functional anatomical muscle.', 'Lateral tibial condyle, fibula, interosseous membrane', 'Middle and distal phalanges of toes 2-5', 'Toe extension (toes 2-5), assists ankle dorsiflexion', 'Deep peroneal nerve (L5-S1)', 'Anterior tibial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Extensor_digitorum_longus.png/600px-Extensor_digitorum_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Extensor_digitorum_longus.png/600px-Extensor_digitorum_longus.png" alt="Extensor Digitorum Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('flexor-hallucis-longus', 'AN-102', 'Flexor Hallucis Longus', 'العضلة قابضة إبهام القدم الطويلة', 'ankle_foot', 'Flexor Hallucis Longus (العضلة قابضة إبهام القدم الطويلة) - Functional anatomical muscle.', 'Posterior fibula, interosseous membrane', 'Distal phalanx of great toe', 'Great toe flexion (IP), assists ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Posterior tibial and peroneal arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Flexor_hallucis_longus.png/600px-Flexor_hallucis_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Flexor_hallucis_longus.png/600px-Flexor_hallucis_longus.png" alt="Flexor Hallucis Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('flexor-digitorum-longus', 'AN-103', 'Flexor Digitorum Longus', 'العضلة قابضة أصابع القدم الطويلة', 'ankle_foot', 'Flexor Digitorum Longus (العضلة قابضة أصابع القدم الطويلة) - Functional anatomical muscle.', 'Posterior tibia', 'Distal phalanges of toes 2-5', 'Toe flexion (DIP toes 2-5), assists ankle plantarflexion', 'Tibial nerve (S1-S2)', 'Posterior tibial artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Flexor_digitorum_longus.png/600px-Flexor_digitorum_longus.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Flexor_digitorum_longus.png/600px-Flexor_digitorum_longus.png" alt="Flexor Digitorum Longus" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('extensor-digitorum-brevis', 'AN-104', 'Extensor Digitorum Brevis', 'العضلة باسطة أصابع القدم القصيرة', 'ankle_foot', 'Extensor Digitorum Brevis (العضلة باسطة أصابع القدم القصيرة) - Functional anatomical muscle.', 'Superolateral surface of calcaneus', 'Bases of middle and distal phalanges of toes 2-4', 'Extends toes 2-4 at MTP and IP joints', 'Deep fibular nerve (S1, S2)', 'Dorsalis pedis artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Extensor_digitorum_brevis.png/600px-Extensor_digitorum_brevis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Extensor_digitorum_brevis.png/600px-Extensor_digitorum_brevis.png" alt="Extensor Digitorum Brevis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('flexor-digitorum-brevis', 'AN-105', 'Flexor Digitorum Brevis', 'العضلة قابضة أصابع القدم القصيرة', 'ankle_foot', 'Flexor Digitorum Brevis (العضلة قابضة أصابع القدم القصيرة) - Functional anatomical muscle.', 'Medial process of calcaneal tuberosity and plantar aponeurosis', 'Middle phalanges of lateral four toes (digits 2-5)', 'Flexion of PIP joints of toes 2-5, longitudinal arch support', 'Medial plantar nerve (S1, S2)', 'Medial and lateral plantar arteries', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Flexor_digitorum_brevis.png/600px-Flexor_digitorum_brevis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Flexor_digitorum_brevis.png/600px-Flexor_digitorum_brevis.png" alt="Flexor Digitorum Brevis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('abductor-hallucis', 'AN-106', 'Abductor Hallucis', 'العضلة مبعّدة إبهام القدم', 'ankle_foot', 'Abductor Hallucis (العضلة مبعّدة إبهام القدم) - Functional anatomical muscle.', 'Medial process of calcaneal tuberosity and flexor retinaculum', 'Medial side of base of proximal phalanx of great toe', 'Abduction and flexion of great toe, supports medial longitudinal arch', 'Medial plantar nerve (S1, S2)', 'Medial plantar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Abductor_hallucis.png/600px-Abductor_hallucis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Abductor_hallucis.png/600px-Abductor_hallucis.png" alt="Abductor Hallucis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;

insert into public.anatomy_muscles (slug, id, name_en, name_ar, region, description, origin, insertion, action, innervation, blood_supply, image_url, embed_code)
values ('adductor-hallucis', 'AN-107', 'Adductor Hallucis', 'العضلة مقربة إبهام القدم', 'ankle_foot', 'Adductor Hallucis (العضلة مقربة إبهام القدم) - Functional anatomical muscle.', 'Oblique head: bases of metatarsals 2-4; Transverse head: plantar MTP ligaments 3-5', 'Lateral side of base of proximal phalanx of great toe', 'Adduction of great toe, supports transverse arch', 'Deep branch of lateral plantar nerve (S2, S3)', 'Lateral plantar artery', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Adductor_hallucis.png/600px-Adductor_hallucis.png', '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Adductor_hallucis.png/600px-Adductor_hallucis.png" alt="Adductor Hallucis" className="w-full h-48 object-contain rounded-lg" />')
on conflict (slug) do update set
  id = excluded.id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  description = excluded.description,
  origin = excluded.origin,
  insertion = excluded.insertion,
  action = excluded.action,
  innervation = excluded.innervation,
  blood_supply = excluded.blood_supply,
  image_url = excluded.image_url,
  embed_code = excluded.embed_code;


-- 5. Seed body_iq_exercises (117 exercises with direct video embeds)
insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-001', 'bird_dog', 'Bird-Dog', 'تمرين الطائر الكلب', 'Core', 'Lumbar Spine', 'Anti-Extension / Stability', 'Transverse Abdominis', 'Multifidus, Gluteus Maximus', 'wiF9KVsM1uM', 'https://www.youtube.com/embed/wiF9KVsM1uM', 'حافظ على استقامة الظهر وعصر العضلة البطنية', '<iframe src="https://www.youtube.com/embed/wiF9KVsM1uM" title="Bird-Dog" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-002', 'dead_bug', 'Dead Bug', 'تمرين الحشرة الميتة', 'Core', 'Lumbar Spine', 'Anti-Extension', 'Transverse Abdominis', 'Rectus Abdominis, Obliques', '4XLEnwUr1d8', 'https://www.youtube.com/embed/4XLEnwUr1d8', 'اضغط أسفل الظهر كاملاً على الأرض أثناء مد الأطراف', '<iframe src="https://www.youtube.com/embed/4XLEnwUr1d8" title="Dead Bug" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-003', 'pallof_press', 'Pallof Press', 'تمرين بالوف لضغط المقاومة', 'Core', 'Spine', 'Anti-Rotation', 'Obliques (Internal/External)', 'Transverse Abdominis', '5_S3v6O-v8k', 'https://www.youtube.com/embed/5_S3v6O-v8k', 'قاوم دوران الكابل وثبّت الحوض تماماً', '<iframe src="https://www.youtube.com/embed/5_S3v6O-v8k" title="Pallof Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-004', 'side_plank', 'Side Plank', 'التمرين اللوحي الجانبي', 'Core', 'Lumbar Spine', 'Anti-Lateral Flexion', 'Quadratus Lumborum', 'Gluteus Medius, Obliques', 'K2VljzCC16g', 'https://www.youtube.com/embed/K2VljzCC16g', 'ارفع الحوض واجعل الجسم خطاً مستقيماً', '<iframe src="https://www.youtube.com/embed/K2VljzCC16g" title="Side Plank" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-005', 'ab_wheel_rollout', 'Ab Wheel Rollout', 'تمرين العجلة للبطن', 'Core', 'Spine', 'Anti-Extension', 'Rectus Abdominis', 'Transverse Abdominis, Lats', 'rqiTPdK3L30', 'https://www.youtube.com/embed/rqiTPdK3L30', 'تجنب إنحناء أسفل الظهر عند الامتداد', '<iframe src="https://www.youtube.com/embed/rqiTPdK3L30" title="Ab Wheel Rollout" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-006', 'farmer_s_carry', 'Farmer''s Carry', 'تمرين مشية المزارع', 'Core', 'Full Body', 'Loaded Carry', 'Quadratus Lumborum', 'Trapezius, Forearms', 'Fkzk_RqlYig', 'https://www.youtube.com/embed/Fkzk_RqlYig', 'امشِ ببطء وثبات دون الانحناء للجانبين', '<iframe src="https://www.youtube.com/embed/Fkzk_RqlYig" title="Farmer''s Carry" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-007', 'mcgill_curl_up', 'McGill Curl-Up', 'تمرين ماكجيل لثبات القطنية', 'Core', 'Lumbar Spine', 'Core Endurance', 'Rectus Abdominis', 'Transverse Abdominis', '2_e4S0P2Y_0', 'https://www.youtube.com/embed/2_e4S0P2Y_0', 'ارفع الرأس والكتفين مليمتراً دون ثني الرقبة', '<iframe src="https://www.youtube.com/embed/2_e4S0P2Y_0" title="McGill Curl-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-008', 'suitcase_carry_farmers_walk', 'Suitcase Carry', 'تمرين مشية الحقيبة بوزن أحادي', 'Core', 'Spine', 'Anti-Lateral Flexion', 'Quadratus Lumborum', 'Obliques', 'E8O9I0S3k5I', 'https://www.youtube.com/embed/E8O9I0S3k5I', 'حافظ على استقامة الكتفين أثناء المشي', '<iframe src="https://www.youtube.com/embed/E8O9I0S3k5I" title="Suitcase Carry" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-009', 'copenhagen_plank', 'Copenhagen Plank', 'تمرين كوبنهاجن للمقربات', 'Core & Hip', 'Hip & Core', 'Adductor Isometric', 'Adductors', 'Obliques, Glute Medius', '0vIObIeHwIs', 'https://www.youtube.com/embed/0vIObIeHwIs', 'ارفع الجسم مستنداً على الساق العلوية', '<iframe src="https://www.youtube.com/embed/0vIObIeHwIs" title="Copenhagen Plank" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-010', 'thoracic_extension_on_foam_roller', 'Thoracic Extension on Foam Roller', 'بسط الفقرات الصدرية على الرول', 'Spine', 'Thoracic Spine', 'Mobility', 'Thoracic Extensors', 'Intercostals', '0k3Z8kY5w0M', 'https://www.youtube.com/embed/0k3Z8kY5w0M', 'ركز على انحناء ظهرك العلوي فقط دون أسفل الظهر', '<iframe src="https://www.youtube.com/embed/0k3Z8kY5w0M" title="Thoracic Extension on Foam Roller" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-011', 'cat_cow_stretch', 'Cat-Cow Stretch', 'تمرين القطة والبقرة للمرونة', 'Spine', 'Full Spine', 'Mobility', 'Erector Spinae', 'Rectus Abdominis', 'K9bK0BwK5a0', 'https://www.youtube.com/embed/K9bK0BwK5a0', 'تحرك ببطء بين التقعر والتحدب مع التنفس', '<iframe src="https://www.youtube.com/embed/K9bK0BwK5a0" title="Cat-Cow Stretch" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-012', 'prone_plank', 'Plank', 'تمرين اللوح الثابت', 'Core', 'Spine', 'Anti-Extension', 'Rectus Abdominis', 'Transverse Abdominis', 'pSHjTRCQxIw', 'https://www.youtube.com/embed/pSHjTRCQxIw', 'اشدد عضلات البطن والألية باستمرار', '<iframe src="https://www.youtube.com/embed/pSHjTRCQxIw" title="Plank" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-013', 'hanging_leg_raise', 'Hanging Leg Raise', 'رفع الأرجل أثناء التعلق', 'Core', 'Hip & Spine', 'Trunk Flexion', 'Rectus Abdominis', 'Iliopsoas', 'hdng3Nm1x_E', 'https://www.youtube.com/embed/hdng3Nm1x_E', 'ارفع الحوض للأعلى لتفعيل البطن وتجنب الأرجحة', '<iframe src="https://www.youtube.com/embed/hdng3Nm1x_E" title="Hanging Leg Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-014', 'russian_twist', 'Russian Twist', 'التدوير الروسي للبطن', 'Core', 'Spine', 'Rotation', 'Obliques', 'Rectus Abdominis', 'wkD8rjkX_L0', 'https://www.youtube.com/embed/wkD8rjkX_L0', 'دور بكتفيك وليس بيدك فقط', '<iframe src="https://www.youtube.com/embed/wkD8rjkX_L0" title="Russian Twist" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-015', 'bear_crawl', 'Bear Crawl Hold', 'تمرين ثبات زحف الدب', 'Core', 'Full Body', 'Anti-Extension', 'Transverse Abdominis', 'Serratus Anterior', 'vNqB3iP6_E0', 'https://www.youtube.com/embed/vNqB3iP6_E0', 'ارفع ركبتيك 2 سم عن الأرض بثبات تام', '<iframe src="https://www.youtube.com/embed/vNqB3iP6_E0" title="Bear Crawl Hold" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-016', 'cable_woodchopper', 'Cable Woodchopper', 'تمرين تقطيع الخشب بالكبس', 'Core', 'Spine', 'Rotation', 'Obliques', 'Serratus Anterior', 'p3S2c3K4_A0', 'https://www.youtube.com/embed/p3S2c3K4_A0', 'دور بحوضك وجذعك بسلاسة', '<iframe src="https://www.youtube.com/embed/p3S2c3K4_A0" title="Cable Woodchopper" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-017', 'back_extension_on_roman_chair', 'Back Extension on Roman Chair', 'بسط الظهر على الكرسي الروماني', 'Core', 'Lumbar Spine', 'Spinal Extension', 'Erector Spinae', 'Gluteus Maximus', 'ph3pddpK_C0', 'https://www.youtube.com/embed/ph3pddpK_C0', 'ارفع جذعك حتى استقامة العمود الفقري فقط', '<iframe src="https://www.youtube.com/embed/ph3pddpK_C0" title="Back Extension on Roman Chair" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-018', 'superman_hold', 'Superman Hold', 'تمرين السوبرمان لثبات الظهر', 'Core', 'Spine', 'Extension Isometric', 'Erector Spinae', 'Gluteus Maximus', 'z6L5k8_pB40', 'https://www.youtube.com/embed/z6L5k8_pB40', 'ارفع الصدر والركبتين بثبات مع التنفس', '<iframe src="https://www.youtube.com/embed/z6L5k8_pB40" title="Superman Hold" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-019', 'stir_the_pot', 'Stir The Pot', 'تمرين تحريك القدر بالكرة الطبية', 'Core', 'Spine', 'Anti-Extension / Rotation', 'Rectus Abdominis', 'Obliques', 'P02Q1W88p40', 'https://www.youtube.com/embed/P02Q1W88p40', 'حرك المرفقين على الكرة بدوائر صغيرة مع ثبات الحوض', '<iframe src="https://www.youtube.com/embed/P02Q1W88p40" title="Stir The Pot" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-020', 'hollow_body_hold', 'Hollow Body Hold', 'تمرين الثبات التجويفي', 'Core', 'Spine', 'Anti-Extension', 'Rectus Abdominis', 'Transverse Abdominis', 'll9Cbd3x_A0', 'https://www.youtube.com/embed/ll9Cbd3x_A0', 'الزق أسفل الظهر بالأرض تماماً', '<iframe src="https://www.youtube.com/embed/ll9Cbd3x_A0" title="Hollow Body Hold" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-021', 'cable_crunch', 'Cable Crunch', 'تمرين البطن بالكابل', 'Core', 'Spine', 'Trunk Flexion', 'Rectus Abdominis', 'Obliques', '2f10A4R_k5M', 'https://www.youtube.com/embed/2f10A4R_k5M', 'اقبض بطنك واسحب بكتفيك لا بيديك', '<iframe src="https://www.youtube.com/embed/2f10A4R_k5M" title="Cable Crunch" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-022', 'reverse_crunch', 'Reverse Crunch', 'تمرين البطن العكسي', 'Core', 'Pelvis', 'Pelvic Tilt', 'Rectus Abdominis (Lower)', 'Obliques', 'hyv14_K3M90', 'https://www.youtube.com/embed/hyv14_K3M90', 'ارفع حوضك باتجاه الصدر بالكامل', '<iframe src="https://www.youtube.com/embed/hyv14_K3M90" title="Reverse Crunch" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-023', 'glute_bridge', 'Glute Bridge', 'جسر الألية الثابت', 'Hip', 'Hip Joint', 'Hip Extension', 'Gluteus Maximus', 'Hamstrings, Core', 'm5j-K0_X6A0', 'https://www.youtube.com/embed/m5j-K0_X6A0', 'اضغط بعقبيك واعتصر الألية في القمة', '<iframe src="https://www.youtube.com/embed/m5j-K0_X6A0" title="Glute Bridge" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-024', 'hip_thrust', 'Barbell Hip Thrust', 'تمرين دفع الحوض بالبار', 'Hip', 'Hip Joint', 'Loaded Hip Extension', 'Gluteus Maximus', 'Hamstrings', 'EF79a32c2_A', 'https://www.youtube.com/embed/EF79a32c2_A', 'حافظ على نظرك للأمام وذقنك للأسفل', '<iframe src="https://www.youtube.com/embed/EF79a32c2_A" title="Barbell Hip Thrust" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-025', 'clamshell', 'Clamshell', 'تمرين الأصداف للورك', 'Hip', 'Hip Joint', 'External Rotation', 'Gluteus Medius', 'Gluteus Minimus', '4p3vE_K1L90', 'https://www.youtube.com/embed/4p3vE_K1L90', 'افتَح ركبتك دون تدوير الحوض للخلف', '<iframe src="https://www.youtube.com/embed/4p3vE_K1L90" title="Clamshell" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-026', 'monster_walk_with_band', 'Monster Walk with Band', 'مشية الوحش بالشريط المطاطي', 'Hip', 'Hip Joint', 'Abduction', 'Gluteus Medius', 'Tensor Fasciae Latae', 'u_Q9j4R1K50', 'https://www.youtube.com/embed/u_Q9j4R1K50', 'حافظ على الشد في الشريط والركبتين للخارج', '<iframe src="https://www.youtube.com/embed/u_Q9j4R1K50" title="Monster Walk with Band" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-027', 'single_leg_rdl', 'Single-Leg RDL', 'الرفعة الميتة الرومانية بساق واحدة', 'Hip', 'Hip Joint', 'Hip Hinge', 'Hamstrings, Gluteus Max', 'Gluteus Medius', 'm31V4L5p6M0', 'https://www.youtube.com/embed/m31V4L5p6M0', 'حافظ على استقامة ظهرك وحوضك متوازياً مع الأرض', '<iframe src="https://www.youtube.com/embed/m31V4L5p6M0" title="Single-Leg RDL" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-028', 'kettlebell_swing', 'Kettlebell Swing', 'أرجحة الأثقال الكروية', 'Hip', 'Hip Joint', 'Dynamic Hip Extension', 'Gluteus Maximus', 'Hamstrings', 's4P4k3L2_N0', 'https://www.youtube.com/embed/s4P4k3L2_N0', 'أنشئ الحركة من دفع الورك وليس بالرفع بالكتف', '<iframe src="https://www.youtube.com/embed/s4P4k3L2_N0" title="Kettlebell Swing" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-029', 'glute_ham_raise_ghr', 'Glute Ham Raise (GHR)', 'تمرين رفع الألية والخلفيات', 'Hip & Knee', 'Knee & Hip', 'Knee Flexion / Hip Ext', 'Hamstrings', 'Gluteus Maximus, Gastrocnemius', '1u2v3_K4L5M', 'https://www.youtube.com/embed/1u2v3_K4L5M', 'انزل ببطء مع استقامة الجذع والورك', '<iframe src="https://www.youtube.com/embed/1u2v3_K4L5M" title="Glute Ham Raise (GHR)" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-030', 'nordic_curl_progression_reverse_nordic', 'Nordic Hamstring Curl', 'التمرين النوردي لعضلات الفخذ الخلفية', 'Knee', 'Knee Joint', 'Eccentric Knee Flexion', 'Hamstrings', 'Gastrocnemius', 'd8e9_f1g2h3', 'https://www.youtube.com/embed/d8e9_f1g2h3', 'قاوم السقوط للأمام بأقصى قدر ممكن بفخذك الخلفي', '<iframe src="https://www.youtube.com/embed/d8e9_f1g2h3" title="Nordic Hamstring Curl" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-031', 'fire_hydrant_exercise', 'Fire Hydrant Exercise', 'تمرين صنبور الحريق للورك', 'Hip', 'Hip Joint', 'Abduction & Ext Rotation', 'Gluteus Medius', 'Piriformis', 'j4k5_l6m7n8', 'https://www.youtube.com/embed/j4k5_l6m7n8', 'ارفع الساق للجانب مع ثبات الظهر', '<iframe src="https://www.youtube.com/embed/j4k5_l6m7n8" title="Fire Hydrant Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-032', 'side_lying_leg_raise', 'Side-Lying Leg Raise', 'رفع الساق جانباً من الاستلقاء', 'Hip', 'Hip Joint', 'Abduction', 'Gluteus Medius', 'Gluteus Minimus', 'p9q0_r1s2t3', 'https://www.youtube.com/embed/p9q0_r1s2t3', 'وجّه إبهام القدم للأسفل قليلاً لتفعيل المؤخرة الجانبية', '<iframe src="https://www.youtube.com/embed/p9q0_r1s2t3" title="Side-Lying Leg Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-033', 'cable_hip_abduction', 'Cable Hip Abduction', 'إبعاد الورك بالكابل', 'Hip', 'Hip Joint', 'Abduction', 'Gluteus Medius', 'TFL', 'u4v5_w6x7y8', 'https://www.youtube.com/embed/u4v5_w6x7y8', 'اسحب الساق للخارج بثبات دون إمالة الجذع', '<iframe src="https://www.youtube.com/embed/u4v5_w6x7y8" title="Cable Hip Abduction" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-034', 'sumo_deadlift', 'Sumo Deadlift', 'الرفعة الميتة بوضعية السومو', 'Hip', 'Hip & Knee', 'Hip Hinge / Extension', 'Gluteus Maximus', 'Adductor Magnus, Quads', 'z9a0_b1c2d3', 'https://www.youtube.com/embed/z9a0_b1c2d3', 'افتح الركبتين باتجاه أطراف القدمين واقترب من البار', '<iframe src="https://www.youtube.com/embed/z9a0_b1c2d3" title="Sumo Deadlift" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-035', 'frog_pump', 'Frog Pump', 'تمرين الضفدع للألية', 'Hip', 'Hip Joint', 'Hip Extension', 'Gluteus Maximus', 'Adductors', 'e4f5_g6h7i8', 'https://www.youtube.com/embed/e4f5_g6h7i8', 'الزق باطني القدمين ببعضهما واضغط بالحوض لأعلى', '<iframe src="https://www.youtube.com/embed/e4f5_g6h7i8" title="Frog Pump" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-036', 'bulgarian_split_squat', 'Bulgarian Split Squat', 'تمرين القرفصاء البلغاري المستهدف للمؤخرة', 'Hip & Knee', 'Hip & Knee', 'Unilateral Lower Push', 'Gluteus Maximus', 'Quads, Adductors', 'j9k0_l1m2n3', 'https://www.youtube.com/embed/j9k0_l1m2n3', 'مل بجدعك للأمام قليلاً وزد من ثني الورك', '<iframe src="https://www.youtube.com/embed/j9k0_l1m2n3" title="Bulgarian Split Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-037', 'step_up_with_hip_drive', 'Step-Up with Hip Drive', 'تمرين الصعود على الصندوق مع دفع الورك', 'Hip', 'Knee & Hip', 'Unilateral Extension', 'Gluteus Maximus', 'Quads', 'o4p5_q6r7s8', 'https://www.youtube.com/embed/o4p5_q6r7s8', 'ادفع بعقب القدم الموجودة على الصندوق فقط', '<iframe src="https://www.youtube.com/embed/o4p5_q6r7s8" title="Step-Up with Hip Drive" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-038', 'reverse_hyper_extension', 'Reverse Hyper Extension', 'تمرين البسط العكسي للفخذ', 'Hip', 'Hip Joint', 'Hip Extension', 'Gluteus Maximus', 'Erector Spinae', 't9u0_v1w2x3', 'https://www.youtube.com/embed/t9u0_v1w2x3', 'اعصر الألية في القمة دون إجهاد أسفل الظهر', '<iframe src="https://www.youtube.com/embed/t9u0_v1w2x3" title="Reverse Hyper Extension" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-039', 'standing_hip_thrust_machine', 'Standing Hip Thrust Machine', 'جهاز دفع الورك واقفا', 'Hip', 'Hip Joint', 'Loaded Hip Extension', 'Gluteus Maximus', 'Hamstrings', 'y4z5_a6b7c8', 'https://www.youtube.com/embed/y4z5_a6b7c8', 'ادفع المقاومة لأمام بالكامل بعصر الألية', '<iframe src="https://www.youtube.com/embed/y4z5_a6b7c8" title="Standing Hip Thrust Machine" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-040', 'seated_hip_abduction_machine', 'Seated Hip Abduction Machine', 'جهاز فتح الأرجل جالساً', 'Hip', 'Hip Joint', 'Abduction', 'Gluteus Medius', 'Gluteus Minimus', 'd9e0_f1g2h3', 'https://www.youtube.com/embed/d9e0_f1g2h3', 'امسك المقابض وافتح الركبتين لأقصى مدى', '<iframe src="https://www.youtube.com/embed/d9e0_f1g2h3" title="Seated Hip Abduction Machine" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-041', 'lateral_band_walk_bodyiq', 'Lateral Band Walk', 'المشي الجانبي بالشريط المطاطي', 'Hip', 'Hip Joint', 'Abduction', 'Gluteus Medius', 'TFL', 'i4j5_k6l7m8', 'https://www.youtube.com/embed/i4j5_k6l7m8', 'حافظ على انثناء خفيف في الركبة والورك', '<iframe src="https://www.youtube.com/embed/i4j5_k6l7m8" title="Lateral Band Walk" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-042', 'single_leg_bridge', 'Single-Leg Glute Bridge', 'جسر الألية بساق واحدة', 'Hip', 'Hip Joint', 'Unilateral Hip Extension', 'Gluteus Maximus', 'Hamstrings, Core', 'n9o0_p1q2r3', 'https://www.youtube.com/embed/n9o0_p1q2r3', 'حافظ على استواء الحوض دون ميلان للجانب المرفوع', '<iframe src="https://www.youtube.com/embed/n9o0_p1q2r3" title="Single-Leg Glute Bridge" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-043', 'terminal_knee_extension', 'Terminal Knee Extension (TKE)', 'المد النهائي للركبة بالشريط المطاطي', 'Knee', 'Knee Joint', 'Knee Extension', 'Vastus Medialis Oblique (VMO)', 'Quadriceps', 's4t5_u6v7w8', 'https://www.youtube.com/embed/s4t5_u6v7w8', 'افرد الركبة تماماً واشتبك عضلات الكوادز في النهاية', '<iframe src="https://www.youtube.com/embed/s4t5_u6v7w8" title="Terminal Knee Extension (TKE)" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-044', 'spanish_squat', 'Spanish Squat', 'تمرين القرفصاء الإسباني لتأهيل الوتر', 'Knee', 'Knee Joint', 'Isometric Quad Push', 'Quadriceps', 'VMO', 'x9y0_z1a2b3', 'https://www.youtube.com/embed/x9y0_z1a2b3', 'اسند على الحزام وانزل بجذع عمودي تماماً', '<iframe src="https://www.youtube.com/embed/x9y0_z1a2b3" title="Spanish Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-045', 'straight_leg_raise', 'Straight Leg Raise (SLR)', 'رفع الساق المباشر مستقيمة', 'Knee & Hip', 'Knee & Hip', 'Quad Isometric / Hip Flexion', 'Rectus Femoris', 'VMO', 'c4d5_e6f7g8', 'https://www.youtube.com/embed/c4d5_e6f7g8', 'اشدد الركبة تماماً قبل رفع الساق 30 سم', '<iframe src="https://www.youtube.com/embed/c4d5_e6f7g8" title="Straight Leg Raise (SLR)" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-046', 'wall_sit', 'Wall Sit with Squeeze', 'تمرين الاستناد على الحائط مع الضغط', 'Knee', 'Knee Joint', 'Isometric Squat', 'Quadriceps', 'Adductors', 'h9i0_j1k2l3', 'https://www.youtube.com/embed/h9i0_j1k2l3', 'ضع كرة بين ركبتيك واضغط بثبات زاوية 90 درجة', '<iframe src="https://www.youtube.com/embed/h9i0_j1k2l3" title="Wall Sit with Squeeze" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-047', 'poliquin_step_up', 'Poliquin Step-Up', 'تمرين صعود بوليكوين للركبة', 'Knee', 'Knee & Ankle', 'Patellar Loading', 'Vastus Medialis Oblique (VMO)', 'Gastrocnemius', 'm4n5_o6p7q8', 'https://www.youtube.com/embed/m4n5_o6p7q8', 'انزل بعقب القدم للأرض مع دفع الركبة للأمام بسلاسة', '<iframe src="https://www.youtube.com/embed/m4n5_o6p7q8" title="Poliquin Step-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-048', 'peterson_step_up', 'Peterson Step-Up', 'تمرين صعود بيترسون على المشط', 'Knee', 'Ankle & Knee', 'VMO Isolation', 'VMO', 'Soleus', 'r9s0_t1u2v3', 'https://www.youtube.com/embed/r9s0_t1u2v3', 'ابدأ الحركة برفع العقب والصعود على مشط القدم', '<iframe src="https://www.youtube.com/embed/r9s0_t1u2v3" title="Peterson Step-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-049', 'reverse_nordic_curl', 'Reverse Nordic Curl', 'تمرين النوردي العكسي لإطالة الكوادز', 'Knee', 'Knee Joint', 'Eccentric Quad Extension', 'Rectus Femoris', 'Vastus Lateralis', 'w4x5_y6z7a8', 'https://www.youtube.com/embed/w4x5_y6z7a8', 'ارجع بجذعك للخلف كقطعة واحدة ممتدة', '<iframe src="https://www.youtube.com/embed/w4x5_y6z7a8" title="Reverse Nordic Curl" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-050', 'goblet_squat', 'Goblet Squat', 'تمرين القرفصاء مع أخذ الوزن أمام الصدر', 'Knee & Hip', 'Knee & Hip', 'Bilateral Lower Push', 'Quadriceps', 'Gluteus Maximus, Adductors', 'b9c0_d1e2f3', 'https://www.youtube.com/embed/b9c0_d1e2f3', 'حافظ على المرفقين داخل الركبتين والصدر مرفوعاً', '<iframe src="https://www.youtube.com/embed/b9c0_d1e2f3" title="Goblet Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-051', 'back_squat', 'Barbell Back Squat', 'تمرين القرفصاء بالبار الخلفي', 'Knee & Hip', 'Knee & Hip', 'Bilateral Lower Push', 'Quadriceps', 'Gluteus Max, Adductor Magnus', 'g4h5_i6j7k8', 'https://www.youtube.com/embed/g4h5_i6j7k8', 'انزل حتى يوازي الفخذ الأرض مع ثبات القدمين', '<iframe src="https://www.youtube.com/embed/g4h5_i6j7k8" title="Barbell Back Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-052', 'front_squat', 'Barbell Front Squat', 'تمرين القرفصاء بالبار الأمامي', 'Knee & Hip', 'Knee & Hip', 'Quad-Dominant Push', 'Quadriceps', 'Rectus Abdominis, Glutes', 'l9m0_n1o2p3', 'https://www.youtube.com/embed/l9m0_n1o2p3', 'ارفع المرفقين لأعلى للحفاظ على البار على الكتفين', '<iframe src="https://www.youtube.com/embed/l9m0_n1o2p3" title="Barbell Front Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-053', 'leg_extension_machine', 'Leg Extension Machine', 'جهاز فرد الركبة', 'Knee', 'Knee Joint', 'Isolated Knee Extension', 'Quadriceps', 'VMO', 'q4r5_s6t7u8', 'https://www.youtube.com/embed/q4r5_s6t7u8', 'افرد الساق للقمة مع التحكم في مرحلة النزول', '<iframe src="https://www.youtube.com/embed/q4r5_s6t7u8" title="Leg Extension Machine" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-054', 'leg_press', 'Leg Press', 'جهاز مكبس الأرجل', 'Knee & Hip', 'Knee & Hip', 'Bilateral Push', 'Quadriceps', 'Gluteus Maximus', 'v9w0_x1y2z3', 'https://www.youtube.com/embed/v9w0_x1y2z3', 'لا تقفل مفصل الركبة تماماً في الأعلى', '<iframe src="https://www.youtube.com/embed/v9w0_x1y2z3" title="Leg Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-055', 'siff_squat', 'Siff Squat', 'تمرين قرفصاء سيف برفع العقبين', 'Knee', 'Knee & Ankle', 'Quad-Dominant Push', 'VMO', 'Quadriceps, Soleus', 'a4b5_c6d7e8', 'https://www.youtube.com/embed/a4b5_c6d7e8', 'ابقَ على أطراف أصابعك طوال حركة القرفصاء', '<iframe src="https://www.youtube.com/embed/a4b5_c6d7e8" title="Siff Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-056', 'walking_lunges', 'Walking Lunges', 'تمرين الطعن المتحرك', 'Knee & Hip', 'Knee & Hip', 'Unilateral Push', 'Quadriceps', 'Gluteus Maximus', 'f9g0_h1i2j3', 'https://www.youtube.com/embed/f9g0_h1i2j3', 'انزل بركبتك الخلفية لقرب الأرض بثبات', '<iframe src="https://www.youtube.com/embed/f9g0_h1i2j3" title="Walking Lunges" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-057', 'reverse_lunge', 'Reverse Lunge', 'تمرين الطعن الخلفي', 'Knee & Hip', 'Knee & Hip', 'Unilateral Push', 'Quadriceps', 'Gluteus Maximus', 'k4l5_m6n7o8', 'https://www.youtube.com/embed/k4l5_m6n7o8', 'ارجع بساقك للخلف وانزل عمودياً', '<iframe src="https://www.youtube.com/embed/k4l5_m6n7o8" title="Reverse Lunge" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-058', 'sissy_squat', 'Sissy Squat', 'تمرين السيسي سوات المتخصص', 'Knee', 'Knee Joint', 'Quad Isolation / Stretch', 'Quadriceps', 'Rectus Femoris', 'p9q0_r1s2t3', 'https://www.youtube.com/embed/p9q0_r1s2t3', 'ادفع ركبتيك للأمام واثنِ جسمك للخلف بثبات', '<iframe src="https://www.youtube.com/embed/p9q0_r1s2t3" title="Sissy Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-059', 'step_down', 'Step-Down Exercise', 'تمرين الهبوط التنزلي من الصندوق', 'Knee', 'Knee & Hip', 'Eccentric Quad Control', 'VMO', 'Gluteus Medius', 'u4v5_w6x7y8', 'https://www.youtube.com/embed/u4v5_w6x7y8', 'اخفض كعب الساق الأخرى للأرض ببطء شديد', '<iframe src="https://www.youtube.com/embed/u4v5_w6x7y8" title="Step-Down Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-060', 'cyclist_squat', 'Cyclist Squat', 'تمرين القرفصاء لراكبي الدراجات', 'Knee', 'Knee Joint', 'VMO / Quad Focus', 'VMO', 'Quadriceps', 'z9a0_b1c2d3', 'https://www.youtube.com/embed/z9a0_b1c2d3', 'ارفع العقبين بكعب عالي وانزل بعمودية', '<iframe src="https://www.youtube.com/embed/z9a0_b1c2d3" title="Cyclist Squat" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-061', 'quad_sets', 'Quad Sets', 'تمرين انقباض الكوادز الساكن', 'Knee', 'Knee Joint', 'Quad Isometric', 'Quadriceps', 'VMO', 'e4f5_g6h7i8', 'https://www.youtube.com/embed/e4f5_g6h7i8', 'اضغط خلف الركبة لأسفل نحو السرير لمدة 5 ثوانٍ', '<iframe src="https://www.youtube.com/embed/e4f5_g6h7i8" title="Quad Sets" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-062', 'short_arc_quads', 'Short Arc Quad (SAQ)', 'تمرين فرد الركبة المحدود مع وسادة', 'Knee', 'Knee Joint', 'Terminal Extension', 'VMO', 'Quadriceps', 'j9k0_l1m2n3', 'https://www.youtube.com/embed/j9k0_l1m2n3', 'افرد الساق من فوق وسادة أسفل الركبة', '<iframe src="https://www.youtube.com/embed/j9k0_l1m2n3" title="Short Arc Quad (SAQ)" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-063', 'tibialis_raise_against_wall', 'Tibialis Raise against Wall', 'تمرين رفع عضلات القصبة الأمامية', 'Ankle', 'Ankle Joint', 'Dorsiflexion', 'Tibialis Anterior', 'Extensor Digitorum', 'o4p5_q6r7s8', 'https://www.youtube.com/embed/o4p5_q6r7s8', 'اسند ظهرك على الحائط وارفع مشط قدمك لأعلى مستويات', '<iframe src="https://www.youtube.com/embed/o4p5_q6r7s8" title="Tibialis Raise against Wall" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-064', 'weighted_tibialis_bar_raise', 'Weighted Tibialis Bar Raise', 'رفع القصبة باستخدام بار أوزان القدم', 'Ankle', 'Ankle Joint', 'Loaded Dorsiflexion', 'Tibialis Anterior', 'Tibialis Posterior', 't9u0_v1w2x3', 'https://www.youtube.com/embed/t9u0_v1w2x3', 'ارفع المشط لأقصى مدى واثبت ثانية في الأعلى', '<iframe src="https://www.youtube.com/embed/t9u0_v1w2x3" title="Weighted Tibialis Bar Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-065', 'eccentric_heel_drop_on_step', 'Eccentric Heel Drop on Step', 'تمرين إنزال العقب لتأهيل أكيلس', 'Ankle', 'Ankle Joint', 'Eccentric Plantarflexion', 'Gastrocnemius', 'Soleus, Achilles Tendon', 'y4z5_a6b7c8', 'https://www.youtube.com/embed/y4z5_a6b7c8', 'اصعد بالساقين وانزل ببطء شديد بالساق المصابة خلال 4 ثوانٍ', '<iframe src="https://www.youtube.com/embed/y4z5_a6b7c8" title="Eccentric Heel Drop on Step" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-066', 'calf_raise', 'Standing Calf Raise', 'رفع العقبين واقفا للسمانة', 'Ankle', 'Ankle Joint', 'Plantarflexion', 'Gastrocnemius', 'Soleus', 'd9e0_f1g2h3', 'https://www.youtube.com/embed/d9e0_f1g2h3', 'اصعد لأقصى نقطة واثبت في الأعلى', '<iframe src="https://www.youtube.com/embed/d9e0_f1g2h3" title="Standing Calf Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-067', 'seated_calf_raise', 'Seated Calf Raise', 'رفع العقبين جالساً لعضلة السولايوس', 'Ankle', 'Ankle Joint', 'Plantarflexion (Knee Flexed)', 'Soleus', 'Gastrocnemius', 'i4j5_k6l7m8', 'https://www.youtube.com/embed/i4j5_k6l7m8', 'ركز على إنزال الكعب لأسفل مستوى الدرجة', '<iframe src="https://www.youtube.com/embed/i4j5_k6l7m8" title="Seated Calf Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-068', 'soleus_push_up', 'Soleus Push-Up', 'تمرين الضغط العضلي للسولايوس جالساً', 'Ankle', 'Ankle Joint', 'Metabolic Plantarflexion', 'Soleus', 'Tibialis Posterior', 'n9o0_p1q2r3', 'https://www.youtube.com/embed/n9o0_p1q2r3', 'ارفع العقبين واجلبهما لأسفل بإيقاع مستمر', '<iframe src="https://www.youtube.com/embed/n9o0_p1q2r3" title="Soleus Push-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-069', 'eversion_with_resistance_band', 'Ankle Eversion with Band', 'إبعاد الكاحل للخارج بالمطاط', 'Ankle', 'Subtalar Joint', 'Eversion', 'Fibularis Longus', 'Fibularis Brevis', 's4t5_u6v7w8', 'https://www.youtube.com/embed/s4t5_u6v7w8', 'حرك مشط القدم للخارج ضد مقاومة الحزام', '<iframe src="https://www.youtube.com/embed/s4t5_u6v7w8" title="Ankle Eversion with Band" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-070', 'ankle_inversion_with_band', 'Ankle Inversion with Band', 'تقريب الكاحل للداخل بالمطاط', 'Ankle', 'Subtalar Joint', 'Inversion', 'Tibialis Posterior', 'Tibialis Anterior', 'x9y0_z1a2b3', 'https://www.youtube.com/embed/x9y0_z1a2b3', 'حرك مشط القدم للداخل ببطء', '<iframe src="https://www.youtube.com/embed/x9y0_z1a2b3" title="Ankle Inversion with Band" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-071', 'short_foot_exercise', 'Short Foot Exercise', 'تمرين تقصير القدم لتقوية القوس', 'Foot', 'Intertarsal Joints', 'Arch Activation', 'Foot Intrinsics', 'Tibialis Posterior', 'c4d5_e6f7g8', 'https://www.youtube.com/embed/c4d5_e6f7g8', 'اسحب قاعدة الأصابع نحو العقب دون ثني الأصابع', '<iframe src="https://www.youtube.com/embed/c4d5_e6f7g8" title="Short Foot Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-072', 'towel_curls_with_toes', 'Towel Curls with Toes', 'تمرين تجعيد المنشفة بالأصابع', 'Foot', 'Toes', 'Toe Flexion', 'Flexion Digitorum Brevis', 'Abductor Hallucis', 'h9i0_j1k2l3', 'https://www.youtube.com/embed/h9i0_j1k2l3', 'اسحب المنشفة بنشاط باستخدام أصابع قدمك', '<iframe src="https://www.youtube.com/embed/h9i0_j1k2l3" title="Towel Curls with Toes" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-073', 'single_leg_balance_on_foam_pad', 'Single-Leg Balance on Foam Pad', 'التوازن بساق واحدة على وسادة إسناد', 'Ankle & Foot', 'Ankle & Foot', 'Proprioception', 'Tibialis Posterior', 'Fibularis Longus, Core', 'm4n5_o6p7q8', 'https://www.youtube.com/embed/m4n5_o6p7q8', 'حافظ على ثبات الكاحل وتصحيح الموقف تلقائياً', '<iframe src="https://www.youtube.com/embed/m4n5_o6p7q8" title="Single-Leg Balance on Foam Pad" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-074', 'calf_stretch_against_wall', 'Calf Stretch against Wall', 'إطالة السمانة بالركبة الممتدة', 'Ankle', 'Ankle Joint', 'Flexibility', 'Gastrocnemius', 'Achilles Tendon', 'r9s0_t1u2v3', 'https://www.youtube.com/embed/r9s0_t1u2v3', 'ابقَ الكعب الخلفي ملاصقاً للأرض والركبة ممتدة', '<iframe src="https://www.youtube.com/embed/r9s0_t1u2v3" title="Calf Stretch against Wall" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-075', 'soleus_stretch', 'Soleus Stretch', 'إطالة السولايوس بالركبة المنثنية', 'Ankle', 'Ankle Joint', 'Flexibility', 'Soleus', 'Achilles Tendon', 'w4x5_y6z7a8', 'https://www.youtube.com/embed/w4x5_y6z7a8', 'اثنِ الركبة الخلفية للأمام مع إبقاء الكعب بالأرض', '<iframe src="https://www.youtube.com/embed/w4x5_y6z7a8" title="Soleus Stretch" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-076', 'toe_spreads_and_splays', 'Toe Spreads and Splays', 'تمرين تفريق وتوسيع أصابع القدم', 'Foot', 'Toes', 'Toe Abduction', 'Abductor Hallucis', 'Interossei', 'b9c0_d1e2f3', 'https://www.youtube.com/embed/b9c0_d1e2f3', 'باعد بين أصابع قدمك لأقصى قدر واثبت', '<iframe src="https://www.youtube.com/embed/b9c0_d1e2f3" title="Toe Spreads and Splays" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-077', 'ankle_alphabet_trace', 'Ankle Alphabet Trace', 'رسم الحروف الإنجليزية بمفصل الكاحل', 'Ankle', 'Ankle Joint', 'Full Range Mobility', 'Tibialis Anterior', 'Peroneals, Gastroc', 'g4h5_i6j7k8', 'https://www.youtube.com/embed/g4h5_i6j7k8', 'ارسم الحروف في الهواء بحركة الكاحل فقط', '<iframe src="https://www.youtube.com/embed/g4h5_i6j7k8" title="Ankle Alphabet Trace" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-078', 'scapular_wall_slide', 'Scapular Wall Slide', 'الانزلاق الجداري للوح الكتف', 'Shoulder', 'Scapulothoracic', 'Scapular Upward Rotation', 'Serratus Anterior', 'Lower Trapezius', 'l9m0_n1o2p3', 'https://www.youtube.com/embed/l9m0_n1o2p3', 'احفظ اتصال الساعدين والظهر بالحائط طوال الحركة', '<iframe src="https://www.youtube.com/embed/l9m0_n1o2p3" title="Scapular Wall Slide" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-079', 'face_pull', 'Face Pull with External Rotation', 'تمرين السحب للوجه مع التدوير', 'Shoulder', 'Shoulder & Scapula', 'External Rotation / Retraction', 'Infraspinatus', 'Teres Minor, Rear Deltoid', 'q4r5_s6t7u8', 'https://www.youtube.com/embed/q4r5_s6t7u8', 'اسحب الحبل باتجاه الجبهة وأرجع المرفقين للخلف', '<iframe src="https://www.youtube.com/embed/q4r5_s6t7u8" title="Face Pull with External Rotation" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-080', 'side_lying_shoulder_external_rotation', 'Side-Lying Shoulder External Rotation', 'التدوير الخارجي للكتف من الاستلقاء الجانبي', 'Shoulder', 'Glenohumeral', 'External Rotation', 'Infraspinatus', 'Teres Minor', 'v9w0_x1y2z3', 'https://www.youtube.com/embed/v9w0_x1y2z3', 'ضع منشفة ملفوفة تحت المرفق واثنِ الزاوية 90 درجة', '<iframe src="https://www.youtube.com/embed/v9w0_x1y2z3" title="Side-Lying Shoulder External Rotation" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-081', 'prone_y_t_w_l_raises', 'Prone Y-T-W-L Raises', 'تمرين الرفع بوضعية Y-T-W-L', 'Shoulder', 'Scapulothoracic', 'Scapular Control', 'Lower Trapezius', 'Rhomboids, Rear Deltoid', 'a4b5_c6d7e8', 'https://www.youtube.com/embed/a4b5_c6d7e8', 'ارفع الإبهامين لأعلى وركز على ضم لوحي الكتف', '<iframe src="https://www.youtube.com/embed/a4b5_c6d7e8" title="Prone Y-T-W-L Raises" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-082', 'serratus_wall_punch', 'Serratus Wall Punch', 'تمرين لكمة المنشارية على الحائط', 'Shoulder', 'Scapulothoracic', 'Scapular Protraction', 'Serratus Anterior', 'Pectoralis Minor', 'f9g0_h1i2j3', 'https://www.youtube.com/embed/f9g0_h1i2j3', 'ادفع الحائط بعيداً بفرك لوحي الكتف للأمام في النهاية', '<iframe src="https://www.youtube.com/embed/f9g0_h1i2j3" title="Serratus Wall Punch" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-083', 'lu_raises_for_side_delts', 'Lu Raises for Side Delts', 'تمرين لو رايز للكتف الجانبي', 'Shoulder', 'Glenohumeral', 'Abduction with Rotation', 'Lateral Deltoid', 'Supraspinatus, Trapezius', 'k4l5_m6n7o8', 'https://www.youtube.com/embed/k4l5_m6n7o8', 'ارفع الوزن بقوس واسع حتى أعلى الرأس بسلاسة', '<iframe src="https://www.youtube.com/embed/k4l5_m6n7o8" title="Lu Raises for Side Delts" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-084', 'crossover_symmetry_band_rotations', 'Crossover Symmetry Band Rotations', 'تدوير الكفة بالرباط المتقاطع', 'Shoulder', 'Glenohumeral', 'Rotator Cuff Activation', 'Supraspinatus', 'Infraspinatus, Subscapularis', 'p9q0_r1s2t3', 'https://www.youtube.com/embed/p9q0_r1s2t3', 'حافظ على استقامة القوام والتحكم بالرباط', '<iframe src="https://www.youtube.com/embed/p9q0_r1s2t3" title="Crossover Symmetry Band Rotations" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-085', 'dumbbell_shoulder_press', 'Overhead Dumbbell Press', 'تمرين الضغط الرأسي بالدمبل', 'Shoulder', 'Glenohumeral & Elbow', 'Vertical Push', 'Anterior Deltoid', 'Triceps, Upper Chest', 'u4v5_w6x7y8', 'https://www.youtube.com/embed/u4v5_w6x7y8', 'ادفع للأعلى دون إمالة أسفل الظهر للخلف', '<iframe src="https://www.youtube.com/embed/u4v5_w6x7y8" title="Overhead Dumbbell Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-086', 'lateral_raise', 'Lateral Raise', 'تمرين رفرفة الكتف الجانبي', 'Shoulder', 'Glenohumeral', 'Abduction', 'Lateral Deltoid', 'Supraspinatus', 'z9a0_b1c2d3', 'https://www.youtube.com/embed/z9a0_b1c2d3', 'ارفع المرفقين لمستوى الكتف بإنحناء خفيف', '<iframe src="https://www.youtube.com/embed/z9a0_b1c2d3" title="Lateral Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-087', 'reverse_pec_deck_fly', 'Reverse Pec Deck Fly', 'تمرين الفراشة العكسية للكتف الخلفي', 'Shoulder', 'Scapulothoracic', 'Horizontal Abduction', 'Posterior Deltoid', 'Rhomboids, Mid Trapezius', 'e4f5_g6h7i8', 'https://www.youtube.com/embed/e4f5_g6h7i8', 'اثبت في القمة واعتصر الجزء الخلفي من الكتف', '<iframe src="https://www.youtube.com/embed/e4f5_g6h7i8" title="Reverse Pec Deck Fly" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-088', 'scapular_push_up', 'Scapular Push-Up', 'تمرين الضغط بلوح الكتف', 'Shoulder', 'Scapulothoracic', 'Protraction / Retraction', 'Serratus Anterior', 'Rhomboids', 'j9k0_l1m2n3', 'https://www.youtube.com/embed/j9k0_l1m2n3', 'حرك لوحي الكتف للتقارب والتباعد دون ثني الذراعين', '<iframe src="https://www.youtube.com/embed/j9k0_l1m2n3" title="Scapular Push-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-089', 'internal_rotation_with_band', 'Internal Rotation with Band', 'التدوير الداخلي للكتف بالمطاط', 'Shoulder', 'Glenohumeral', 'Internal Rotation', 'Subscapularis', 'Pectoralis Major', 'o4p5_q6r7s8', 'https://www.youtube.com/embed/o4p5_q6r7s8', 'اسحب المطاط لداخل البطن مع تثبيت المرفق بجانبك', '<iframe src="https://www.youtube.com/embed/o4p5_q6r7s8" title="Internal Rotation with Band" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-090', 'shoulder_extension', 'Shoulder Extension', 'بسط الكتف للخلف', 'Shoulder', 'Glenohumeral', 'Extension', 'Latissimus Dorsi', 'Teres Major, Rear Deltoid', 't9u0_v1w2x3', 'https://www.youtube.com/embed/t9u0_v1w2x3', 'اسحب المقاومة للخلف بجانب الورك', '<iframe src="https://www.youtube.com/embed/t9u0_v1w2x3" title="Shoulder Extension" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-091', 'empty_can_exercise', 'Empty Can Exercise', 'تمرين الصفيحة الفارغة للكتف', 'Shoulder', 'Glenohumeral', 'Abduction in Scaption', 'Supraspinatus', 'Anterior Deltoid', 'y4z5_a6b7c8', 'https://www.youtube.com/embed/y4z5_a6b7c8', 'ادر إبهامك لأسفل وارفع الذراع في مستوى لوح الكتف', '<iframe src="https://www.youtube.com/embed/y4z5_a6b7c8" title="Empty Can Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-092', 'full_can_shoulder_raise', 'Full Can Shoulder Raise', 'تمرين الصفيحة الممتلئة بالإبهام لأعلى', 'Shoulder', 'Glenohumeral', 'Safe Scaption Raise', 'Supraspinatus', 'Anterior Deltoid', 'd9e0_f1g2h3', 'https://www.youtube.com/embed/d9e0_f1g2h3', 'وجه إبهامك لأعلى وارفع بصفاء بمستوى 30 درجة للامام', '<iframe src="https://www.youtube.com/embed/d9e0_f1g2h3" title="Full Can Shoulder Raise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-093', 'cuban_press', 'Cuban Press', 'تمرين الكوبان للكتف والكفة', 'Shoulder', 'Glenohumeral', 'Upright Row to Ext Rot & Press', 'Infraspinatus', 'Deltoids, Rotator Cuff', 'i4j5_k6l7m8', 'https://www.youtube.com/embed/i4j5_k6l7m8', 'ارفع المرفقين ثم در الذراعين لأعلى واضغط', '<iframe src="https://www.youtube.com/embed/i4j5_k6l7m8" title="Cuban Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-094', 'subscapularis_belly_press', 'Subscapularis Belly Press', 'تمرين الضغط على البطن للكفة الداخلية', 'Shoulder', 'Glenohumeral', 'Internal Rotation Isometric', 'Subscapularis', 'Pectoralis Major', 'n9o0_p1q2r3', 'https://www.youtube.com/embed/n9o0_p1q2r3', 'اضغط بكفك على بطنك واثبت دون تحريك المرفق للخلف', '<iframe src="https://www.youtube.com/embed/n9o0_p1q2r3" title="Subscapularis Belly Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-095', 'landmine_press', 'Landmine Press', 'تمرين الضغط المائل ببار اللاندماين', 'Shoulder', 'Glenohumeral', 'Angled Push', 'Anterior Deltoid', 'Upper Pectoralis, Serratus', 's4t5_u6v7w8', 'https://www.youtube.com/embed/s4t5_u6v7w8', 'ادفع الأثقال بزاوية مائلة 45 درجة بثبات', '<iframe src="https://www.youtube.com/embed/s4t5_u6v7w8" title="Landmine Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-096', 'prone_cobra_exercise', 'Prone Cobra Exercise', 'تمرين الكوبرا لثبات الكتف والظهر', 'Shoulder & Spine', 'Scapula & Spine', 'Extension & External Rotation', 'Lower Trapezius', 'Infraspinatus, Erector Spinae', 'x9y0_z1a2b3', 'https://www.youtube.com/embed/x9y0_z1a2b3', 'ارفع الصدر وادر الكفين للخارج بالإبهامين لأعلى', '<iframe src="https://www.youtube.com/embed/x9y0_z1a2b3" title="Prone Cobra Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-097', 'pendulum_exercise', 'Pendulum Exercise', 'تمرين البندول لاسترخاء الكتف', 'Shoulder', 'Glenohumeral', 'Passive Mobility', 'Rotator Cuff (Relaxed)', 'None (Passive)', 'c4d5_e6f7g8', 'https://www.youtube.com/embed/c4d5_e6f7g8', 'اترك الذراع تتدلى وأرجحها بجاذبية الجسم بسلاسة', '<iframe src="https://www.youtube.com/embed/c4d5_e6f7g8" title="Pendulum Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-098', 'barbell_bench_press', 'Barbell Bench Press', 'تمرين الضغط بالبار على البنش المستوي', 'Chest', 'Chest & Shoulder', 'Horizontal Push', 'Pectoralis Major', 'Anterior Deltoid, Triceps', 'h9i0_j1k2l3', 'https://www.youtube.com/embed/h9i0_j1k2l3', 'انزل بالبار حتى يلمس وسط الصدر بثبات', '<iframe src="https://www.youtube.com/embed/h9i0_j1k2l3" title="Barbell Bench Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-099', 'incline_dumbbell_press', 'Incline Dumbbell Press', 'تمرين ضغط الدمبل على البنش المائل', 'Chest', 'Chest & Shoulder', 'Incline Push', 'Pectoralis Major (Clavicular)', 'Anterior Deltoid, Triceps', 'm4n5_o6p7q8', 'https://www.youtube.com/embed/m4n5_o6p7q8', 'انزل بالدمبلز بزاوية 45 درجة لعصر الجزء العلوي', '<iframe src="https://www.youtube.com/embed/m4n5_o6p7q8" title="Incline Dumbbell Press" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-100', 'chest_dips', 'Chest Dips', 'تمرين المتوازي للصدر والذراعين', 'Chest & Arm', 'Shoulder & Elbow', 'Vertical Push', 'Pectoralis Major', 'Triceps, Anterior Deltoid', 'r9s0_t1u2v3', 'https://www.youtube.com/embed/r9s0_t1u2v3', 'مل بجذعك للأمام قليلاً لزيادة الضغط على الصدر', '<iframe src="https://www.youtube.com/embed/r9s0_t1u2v3" title="Chest Dips" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-101', 'pull_up', 'Pull-Up', 'تمرين العقلة بالقبضة الواسعة', 'Back', 'Shoulder & Elbow', 'Vertical Pull', 'Latissimus Dorsi', 'Biceps, Rhomboids', 'w4x5_y6z7a8', 'https://www.youtube.com/embed/w4x5_y6z7a8', 'اسحب صدرك نحو البار وأرجع لوحي الكتف لأسفل', '<iframe src="https://www.youtube.com/embed/w4x5_y6z7a8" title="Pull-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-102', 'chin_up', 'Chin-Up', 'تمرين العقلة بالقبضة المعكوسة', 'Back & Arm', 'Shoulder & Elbow', 'Vertical Pull', 'Biceps Brachii', 'Latissimus Dorsi', 'b9c0_d1e2f3', 'https://www.youtube.com/embed/b9c0_d1e2f3', 'استهدف البايسبس بسحب الذقن فوق البار', '<iframe src="https://www.youtube.com/embed/b9c0_d1e2f3" title="Chin-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-103', 'bent_over_row', 'Barbell Bent-Over Row', 'تمرين التجديف بالبار للانحناء', 'Back', 'Spine & Shoulder', 'Horizontal Pull', 'Latissimus Dorsi', 'Rhomboids, Trapezius, Biceps', 'g4h5_i6j7k8', 'https://www.youtube.com/embed/g4h5_i6j7k8', 'حافظ على زاوية ظهرك ثابتة واسحب البار لسرتك', '<iframe src="https://www.youtube.com/embed/g4h5_i6j7k8" title="Barbell Bent-Over Row" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-104', 'seated_cable_row', 'Seated Cable Row', 'تمرين التجديف بالسحب السفلي جالساً', 'Back', 'Shoulder & Scapula', 'Horizontal Pull', 'Rhomboids', 'Latissimus Dorsi, Mid Trapezius', 'l9m0_n1o2p3', 'https://www.youtube.com/embed/l9m0_n1o2p3', 'اعصر لوحي الكتف في النهاية دون الانحناء للخلف', '<iframe src="https://www.youtube.com/embed/l9m0_n1o2p3" title="Seated Cable Row" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-105', 'single_arm_dumbbell_row', 'Single-Arm Dumbbell Row', 'تمرين التجديف بالدمبل بيد واحدة', 'Back', 'Shoulder & Spine', 'Horizontal Pull', 'Latissimus Dorsi', 'Biceps, Rear Deltoid', 'q4r5_s6t7u8', 'https://www.youtube.com/embed/q4r5_s6t7u8', 'اسحب المرفق نحو الورك وثبت الجذع', '<iframe src="https://www.youtube.com/embed/q4r5_s6t7u8" title="Single-Arm Dumbbell Row" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-106', 'lat_pulldown', 'Lat Pulldown', 'تمرين السحب العالي للظهر', 'Back', 'Shoulder & Elbow', 'Vertical Pull', 'Latissimus Dorsi', 'Teres Major, Biceps', 'v9w0_x1y2z3', 'https://www.youtube.com/embed/v9w0_x1y2z3', 'اسحب المنيبار نحو أعلى الصدر بكتف مفتوح', '<iframe src="https://www.youtube.com/embed/v9w0_x1y2z3" title="Lat Pulldown" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-107', 'biceps_curl', 'Dumbbell Biceps Curl', 'تمرين تجميع البايسبس بالدمبل', 'Arm', 'Elbow Joint', 'Elbow Flexion', 'Biceps Brachii', 'Brachialis', 'a4b5_c6d7e8', 'https://www.youtube.com/embed/a4b5_c6d7e8', 'ثبت المرفقين بجانب أضلاعك واثنِ الذراع بمرونة', '<iframe src="https://www.youtube.com/embed/a4b5_c6d7e8" title="Dumbbell Biceps Curl" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-108', 'hammer_curl', 'Hammer Curl', 'تمرين الشاكوش للبايسبس والساعد', 'Arm', 'Elbow Joint', 'Elbow Flexion (Neutral)', 'Brachioradialis', 'Biceps Brachii, Brachialis', 'f9g0_h1i2j3', 'https://www.youtube.com/embed/f9g0_h1i2j3', 'حافظ على كف يدك مواجهاً لجسمك طوال التمرين', '<iframe src="https://www.youtube.com/embed/f9g0_h1i2j3" title="Hammer Curl" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-109', 'triceps_pushdown', 'Triceps Rope Pushdown', 'تمرين الترايسبس بالحبل على الكابل', 'Arm', 'Elbow Joint', 'Elbow Extension', 'Triceps Brachii', 'Anconeus', 'k4l5_m6n7o8', 'https://www.youtube.com/embed/k4l5_m6n7o8', 'افرد الذراعين تماماً وافتح أطراف الحبل للخارج', '<iframe src="https://www.youtube.com/embed/k4l5_m6n7o8" title="Triceps Rope Pushdown" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-110', 'skull_crusher_bodyiq', 'Skull Crusher', 'تمرين الترايسبس بالبار المكسور مستلقياً', 'Arm', 'Elbow Joint', 'Elbow Extension', 'Triceps Long Head', 'Triceps Lateral Head', 'p9q0_r1s2t3', 'https://www.youtube.com/embed/p9q0_r1s2t3', 'انزل بالبار نحو الجبهة وافرد الذراعين بثبات', '<iframe src="https://www.youtube.com/embed/p9q0_r1s2t3" title="Skull Crusher" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-111', 'wrist_roller_exercise', 'Wrist Roller Exercise', 'تمرين لف الساعد بالبكرة والأوزان', 'Forearm', 'Wrist Joint', 'Wrist Flexion/Extension', 'Forearm Flexors', 'Forearm Extensors', 'u4v5_w6x7y8', 'https://www.youtube.com/embed/u4v5_w6x7y8', 'لف الخيط ببطء بتبادل معصميك', '<iframe src="https://www.youtube.com/embed/u4v5_w6x7y8" title="Wrist Roller Exercise" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-112', 'dead_hang', 'Dead Hang', 'تمرين التعلق الحر لتقوية القبضة', 'Grip & Shoulder', 'Shoulder & Wrist', 'Grip Hold & Decompression', 'Forearm Flexors', 'Latissimus Dorsi, Spine', 'z9a0_b1c2d3', 'https://www.youtube.com/embed/z9a0_b1c2d3', 'استرخِ ودع الجاذبية تمدد فقرات ظهرك مع بقاء القبضة قوية', '<iframe src="https://www.youtube.com/embed/z9a0_b1c2d3" title="Dead Hang" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-113', 'plate_pinch_hold', 'Plate Pinch Hold', 'تمرين مسك الأقراص بالأصابع', 'Grip', 'Fingers & Wrist', 'Pinch Grip', 'Flexor Digitorum', 'Intrinsic Hand', 'e4f5_g6h7i8', 'https://www.youtube.com/embed/e4f5_g6h7i8', 'امسك قرصين بأطراف أصابعك واثبت لأطول فترة', '<iframe src="https://www.youtube.com/embed/e4f5_g6h7i8" title="Plate Pinch Hold" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-114', 'reverse_biceps_curl', 'Reverse Biceps Curl', 'تمرين البايسبس بالقبضة العكسية', 'Arm & Forearm', 'Elbow Joint', 'Elbow Flexion (Prone)', 'Brachioradialis', 'Forearm Extensors', 'j9k0_l1m2n3', 'https://www.youtube.com/embed/j9k0_l1m2n3', 'ارفع البار بكفي يديك متجهاً لأسفل', '<iframe src="https://www.youtube.com/embed/j9k0_l1m2n3" title="Reverse Biceps Curl" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-115', 'overhead_triceps_extension', 'Overhead Triceps Extension', 'تمرين الترايسبس فوق الرأس بالدمبل', 'Arm', 'Elbow & Shoulder', 'Elbow Extension in Stretch', 'Triceps Long Head', 'Triceps Medial Head', 'o4p5_q6r7s8', 'https://www.youtube.com/embed/o4p5_q6r7s8', 'اخفض الوزن خلف الرقبة وافرده لأعلى بثبات', '<iframe src="https://www.youtube.com/embed/o4p5_q6r7s8" title="Overhead Triceps Extension" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-116', 'cable_chest_fly', 'Cable Chest Fly', 'تمرين الفراشة بالكابل للصدر', 'Chest', 'Shoulder Joint', 'Horizontal Adduction', 'Pectoralis Major', 'Anterior Deltoid', 't9u0_v1w2x3', 'https://www.youtube.com/embed/t9u0_v1w2x3', 'اقرب الكابلين كأنك تعانق شجرة كبيرة', '<iframe src="https://www.youtube.com/embed/t9u0_v1w2x3" title="Cable Chest Fly" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;

insert into public.body_iq_exercises (id, library_id, name_en, name_ar, region, target_joint, movement_pattern, primary_muscle, secondary_muscles, youtube_id, embed_video_url, coaching_cue, embed_iframe_code)
values ('EX-117', 'push_up', 'Push-Up', 'تمرين الضغط التقليدي', 'Chest & Core', 'Shoulder & Elbow', 'Horizontal Push', 'Pectoralis Major', 'Triceps, Anterior Deltoid, Core', 'y4z5_a6b7c8', 'https://www.youtube.com/embed/y4z5_a6b7c8', 'حافظ على استقامة الجسم كاملاً كقطعة واحدة', '<iframe src="https://www.youtube.com/embed/y4z5_a6b7c8" title="Push-Up" className="w-full h-56 rounded-xl border-0" allowFullScreen />')
on conflict (id) do update set
  library_id = excluded.library_id,
  name_en = excluded.name_en,
  name_ar = excluded.name_ar,
  region = excluded.region,
  target_joint = excluded.target_joint,
  movement_pattern = excluded.movement_pattern,
  primary_muscle = excluded.primary_muscle,
  secondary_muscles = excluded.secondary_muscles,
  youtube_id = excluded.youtube_id,
  embed_video_url = excluded.embed_video_url,
  coaching_cue = excluded.coaching_cue,
  embed_iframe_code = excluded.embed_iframe_code;


commit;
