# Known data gaps (clinical content)

This file tracks gaps in `json/protocols_v3.json` that need clinician-authored content.
These were intentionally NOT auto-filled: exercise prescriptions, progression criteria,
and phase timings are clinical decisions that require a sourced review.

## 1. Phase 4 without exercises (98 protocols)

These protocols end with a "maintenance / return to activity" phase that has goals and
precautions but no exercise list. The site shows a continuation message instead.

- [2] ACL Tear — Conservative Management
- [3] Meniscus Repair (Post-operative)
- [4] Patellofemoral Pain Syndrome (PFPS)
- [5] Patellar Tendinopathy
- [6] MCL Sprain (Grade II)
- [7] Total Knee Arthroplasty (TKA)
- [8] PCL Tear — Conservative
- [10] Shoulder Impingement Syndrome
- [11] Frozen Shoulder (Adhesive Capsulitis)
- [12] Anterior Shoulder Dislocation (First-time)
- [13] Lateral Ankle Sprain (Grade I-II)
- [14] Achilles Tendinopathy
- [15] Plantar Fasciitis
- [16] Ankle Fracture (Post-immobilisation)
- [17] Non-specific Low Back Pain (Acute)
- [18] Lumbar Disc Herniation with Radiculopathy
- [19] Cervical Radiculopathy
- [20] Spondylolisthesis (Grade I–II, Conservative)
- [21] Hip Labral Tear (Conservative)
- [22] Total Hip Arthroplasty (THA)
- [23] Lateral Epicondylalgia (Tennis Elbow)
- [24] Distal Radius Fracture (Post-immobilisation)
- [25] Hamstring Strain (Grade II)
- [26] Greater Trochanteric Pain Syndrome (GTPS)
- [27] Iliotibial Band Syndrome
- [28] AC Joint Sprain (Grade I-II)
- [29] Thoracic Outlet Syndrome (TOS)
- [30] Quadriceps Tendinopathy
- [31] Biceps Tendinopathy (Long Head)
- [32] SLAP Lesion (Conservative)
- [33] Posterior Shoulder Instability
- [34] Supraspinatus Tear (Partial — Conservative)
- [35] Calcific Tendinitis
- [36] Medial Epicondylalgia (Golfer's Elbow)
- [37] UCL Sprain — Elbow (Ulnar Collateral
- [38] Carpal Tunnel Syndrome (Conservative)
- [39] De Quervain's Tenosynovitis
- [40] Scaphoid Fracture (Post-immobilisation)
- [41] TFCC Injury — Triangular Fibrocartilage
- [42] Femoroacetabular Impingement (FAI)
- [43] Hip Flexor Strain (Iliopsoas)
- [44] Adductor / Groin Strain
- [45] Piriformis Syndrome
- [46] Hip Osteoarthritis (Conservative)
- [47] Snapping Hip Syndrome (Coxa Saltans)
- [48] Pes Anserine Bursitis
- [49] Baker's Cyst
- [50] Tibial Plateau Fracture (Post-op)
- [51] Knee Osteoarthritis (Conservative)
- [52] Osgood-Schlatter Disease
- [53] Meniscectomy (Post-operative)
- [54] Peroneal Tendinopathy
- [55] Posterior Tibial Tendon Dysfunction (PTTD)
- [56] Sinus Tarsi Syndrome
- [57] 5th Metatarsal Fracture (Jones Fracture)
- [58] Ankle Fracture ORIF (Post-operative)
- [59] Hallux Valgus (Post-surgical Rehabilitation)
- [60] Tibialis Anterior Tendinopathy
- [61] Spinal Stenosis (Lumbar — Conservative)
- [62] Facet Joint Dysfunction (Lumbar)
- [63] Sacroiliac Joint Dysfunction
- [64] Piriformis Syndrome / Sciatic Nerve Compression
- [65] Cervical Facet Joint Pain
- [66] Whiplash Associated Disorder (WAD Grade II)
- [67] Osteoporotic Vertebral Fracture (Conservative)
- [68] Scheuermann's Kyphosis (Conservative)
- [69] Thoracic Disc Herniation
- [70] Post-Laminectomy Rehabilitation
- [71] Cubital Tunnel Syndrome
- [72] Radial Tunnel Syndrome
- [73] Trigger Finger (Post-injection / Post-op)
- [74] Mallet Finger
- [75] Boutonniere Deformity
- [76] Flexor Tendon Repair (Zone II)
- [77] Extensor Tendon Repair
- [78] Dupuytren's Contracture (Post-surgical)
- [79] Thumb UCL Sprain (Skier's Thumb)
- [80] Proximal Humerus Fracture (Non-operative)
- [81] Quadriceps Strain (Grade II)
- [82] Calf Strain (Gastrocnemius)
- [83] Rectus Femoris Strain
- [84] Gluteal Muscle Strain
- [85] Tibial Stress Fracture (Return to Running)
- [86] Medial Tibial Stress Syndrome (Shin Splints)
- [87] Stress Reaction (Femoral Neck)
- [88] Pectoralis Major Tear (Conservative)
- [89] Biceps Rupture — Distal (Post-op)
- [90] Triceps Tendinopathy
- [91] Sever's Disease (Calcaneal
- [92] Little Leaguer's Shoulder (Proximal
- [93] Juvenile Osgood-Schlatter
- [94] Sinding-Larsen-Johansson
- [95] Perthes Disease (Rehabilitation)
- [96] Peripheral Nerve Injury (Peroneal
- [97] Complex Regional Pain Syndrome
- [98] Brachial Plexus Neuropraxia
- [99] Thoracic Hyperkyphosis (Postural)
- [100] Temporomandibular Joint

## 2. Phases without timing (35 phases across 13 protocols)

- [31] Biceps Tendinopathy (Long Head) — phases [1, 2, 3]
- [32] SLAP Lesion (Conservative) — phases [1, 2, 3]
- [33] Posterior Shoulder Instability — phases [1, 2, 3]
- [34] Supraspinatus Tear (Partial — Conservative) — phases [1, 2, 3]
- [35] Calcific Tendinitis — phases [1, 2, 3]
- [48] Pes Anserine Bursitis — phases [1, 2, 3]
- [49] Baker's Cyst — phases [1, 2, 3]
- [50] Tibial Plateau Fracture (Post-op) — phases [1, 2, 3]
- [51] Knee Osteoarthritis (Conservative) — phases [1, 2, 3]
- [52] Osgood-Schlatter Disease — phases [1, 2, 3]
- [53] Meniscectomy (Post-operative) — phases [1, 2, 3]
- [95] Perthes Disease (Rehabilitation) — phases [1]
- [96] Peripheral Nerve Injury (Peroneal — phases [2]

## 3. Protocols 71-85 with empty progression criteria in phases 1-2 (30 phase entries)

- [71] Cubital Tunnel Syndrome — phases [1, 2]
- [72] Radial Tunnel Syndrome — phases [1, 2]
- [73] Trigger Finger (Post-injection / Post-op) — phases [1, 2]
- [74] Mallet Finger — phases [1, 2]
- [75] Boutonniere Deformity — phases [1, 2]
- [76] Flexor Tendon Repair (Zone II) — phases [1, 2]
- [77] Extensor Tendon Repair — phases [1, 2]
- [78] Dupuytren's Contracture (Post-surgical) — phases [1, 2]
- [79] Thumb UCL Sprain (Skier's Thumb) — phases [1, 2]
- [80] Proximal Humerus Fracture (Non-operative) — phases [1, 2]
- [81] Quadriceps Strain (Grade II) — phases [1, 2]
- [82] Calf Strain (Gastrocnemius) — phases [1, 2]
- [83] Rectus Femoris Strain — phases [1, 2]
- [84] Gluteal Muscle Strain — phases [1, 2]
- [85] Tibial Stress Fracture (Return to Running) — phases [1, 2]

## 4. Other tracked gaps

- 5 clinical cues in `json/library_v3.json` were unrecoverable corrupted fragments and are now empty: `progressive_druj_loading`, `progressive_forearm_strengthening`, `resisted_wrist_and_finger_extension`, `rotator_cuff_strengthening`, `tempo_runs`.
- 112 of 117 exercise video entries in `json/body_iq_exercises_embed.json` held placeholder YouTube IDs (now removed); real demo videos need to be sourced.
- 12 muscles in `json/muscles_library.json` have no freely licensed image on Wikimedia Commons (image_url is null, page shows a fallback): internal-oblique, transverse-abdominis, quadratus-lumborum, multifidus, coccygeus, gemellus-inferior, iliacus, adductor-longus, adductor-brevis, adductor-magnus, gracilis, vastus-intermedius.
