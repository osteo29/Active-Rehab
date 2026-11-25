import {navigationPaths} from '../utils/langUrlHelper';
import musclesData from '../../json/muscles_library.json';
import {injuryRecommendsRegion} from './injuryExerciseLinks';
import {getLocalCatalogInjuries} from './injuryService';

type Language = 'en' | 'ar';

export type CrossLink = {label: string; href: string};

type MuscleEntry = {name?: string; name_ar?: string; slug?: string};

const muscles = (musclesData as any).muscles as Record<string, MuscleEntry>;
const librarySlugs = new Set(Object.keys(muscles));
const nameToSlug = new Map<string, string>();
for (const [slug, entry] of Object.entries(muscles)) {
  if (entry.name) nameToSlug.set(entry.name.toLowerCase(), slug);
}

/**
 * Curated aliases from exercise-finder gym names to anatomically matching
 * library slugs. Multi-head muscles link to every head. Ids with no real
 * library counterpart (e.g. "rhomboids", "forearms") stay unmapped: no link
 * is invented.
 */
const MUSCLE_ID_ALIASES: Record<string, string[]> = {
  upper_chest: ['pectoralis-major'],
  middle_chest: ['pectoralis-major'],
  lower_chest: ['pectoralis-major'],
  front_delts: ['anterior-deltoid'],
  side_delts: ['lateral-deltoid'],
  rear_delts: ['posterior-deltoid'],
  triceps: ['triceps-long-head', 'triceps-lateral-head', 'triceps-medial-head'],
  biceps: ['biceps-brachii-long-head', 'biceps-brachii-short-head'],
  lats: ['latissimus-dorsi'],
  traps: ['trapezius-upper'],
  erector_spinae: ['iliocostalis', 'longissimus', 'spinalis'],
  lower_back: ['iliocostalis', 'longissimus', 'spinalis'],
  glute_max: ['gluteus-maximus'],
  glute_med: ['gluteus-medius'],
  glute_min: ['gluteus-minimus'],
  hamstrings: ['biceps-femoris-long-head', 'biceps-femoris-short-head', 'semimembranosus', 'semitendinosus'],
  upper_abs: ['rectus-abdominis'],
  lower_abs: ['rectus-abdominis'],
  obliques: ['external-oblique', 'internal-oblique'],
  vastus_medialis: ['vastus-medialis-oblique-vmo'],
  biceps_femoris: ['biceps-femoris-long-head', 'biceps-femoris-short-head'],
  gastrocnemius: ['gastrocnemius-lateral-head', 'gastrocnemius-medial-head'],
};

/**
 * Resolve an exercise-finder sub-muscle id (e.g. "gluteus_medius",
 * "front_delts") to muscle-library slugs. Empty array when no library entry
 * matches - callers must not invent a link.
 */
export function resolveLibraryMuscleSlugs(id: string): string[] {
  const key = id.toLowerCase().trim();
  const alias = MUSCLE_ID_ALIASES[key];
  if (alias) return alias.filter((slug) => librarySlugs.has(slug));
  const normalized = key.replace(/[_\s]+/g, '-');
  if (librarySlugs.has(normalized)) return [normalized];
  const byName = nameToSlug.get(key.replace(/_/g, ' '));
  return byName ? [byName] : [];
}

/** Exercise -> its muscles in the anatomy library (only verified slugs). */
export function getExerciseMuscleLinks(muscleIds: string[], lang: Language): CrossLink[] {
  const seen = new Set<string>();
  const links: CrossLink[] = [];
  for (const id of muscleIds) {
    for (const slug of resolveLibraryMuscleSlugs(id)) {
      if (seen.has(slug)) continue;
      seen.add(slug);
      const entry = muscles[slug];
      links.push({
        label: lang === 'ar' ? entry.name_ar || entry.name || slug : entry.name || slug,
        href: `${navigationPaths.anatomy(lang)}/${slug}`,
      });
    }
  }
  return links;
}

/** Exercise -> injury rehab protocols that recommend its region (verified ids only). */
export function getExerciseProtocolLinks(regionSlug: string, lang: Language, limit = 3): CrossLink[] {
  const catalog = getLocalCatalogInjuries(lang);
  const links: CrossLink[] = [];
  for (const injury of catalog) {
    if (!injuryRecommendsRegion(injury.id, injury.bodyRegion, regionSlug)) continue;
    links.push({label: injury.name, href: navigationPaths.injuryDetail(lang, injury.slug)});
    if (links.length >= limit) break;
  }
  return links;
}

/** Total catalog protocols that recommend an exercise-finder region (drives "view all" labels). */
export function countProtocolsForExerciseRegion(regionSlug: string): number {
  const catalog = getLocalCatalogInjuries('en');
  let count = 0;
  for (const injury of catalog) {
    if (injuryRecommendsRegion(injury.id, injury.bodyRegion, regionSlug)) count += 1;
  }
  return count;
}

/** Exercise-finder region -> anatomy-library slugs its exercises target (verified aliases only). */
export function getLibraryMuscleSlugsForExerciseRegion(
  exercises: Array<{muscles?: string[]}>,
): string[] {
  const seen = new Set<string>();
  const slugs: string[] = [];
  for (const exercise of exercises) {
    if (!exercise.muscles) continue;
    for (const id of exercise.muscles) {
      for (const slug of resolveLibraryMuscleSlugs(id)) {
        if (seen.has(slug)) continue;
        seen.add(slug);
        slugs.push(slug);
      }
    }
  }
  return slugs;
}

/** Library slugs -> anatomy page links, skipping any slug missing from the library. */
export function getMuscleLinksForSlugs(slugs: string[], lang: Language): CrossLink[] {
  const links: CrossLink[] = [];
  for (const slug of slugs) {
    const entry = muscles[slug];
    if (!entry) continue;
    links.push({
      label: lang === 'ar' ? entry.name_ar || entry.name || slug : entry.name || slug,
      href: `${navigationPaths.anatomy(lang)}/${slug}`,
    });
  }
  return links;
}

/**
 * Exercise-finder region -> the anatomy-library muscles its exercises target.
 * Built purely from the exercises' own muscle ids resolved through the
 * curated alias map, so every link is one an exercise card would already
 * show. Callers pass the region's exercises; nothing is invented for
 * regions whose exercises carry no resolvable muscle ids.
 */
export function getLibraryMusclesForExerciseRegion(
  exercises: Array<{muscles?: string[]}>,
  lang: Language,
): CrossLink[] {
  return getMuscleLinksForSlugs(getLibraryMuscleSlugsForExerciseRegion(exercises), lang);
}

const BODY_REGION_TO_LIBRARY_REGION: Record<string, string> = {
  'ankle & foot': 'ankle_foot',
  shoulder: 'shoulder',
  knee: 'knee_thigh',
  hip: 'hip_pelvis',
  'upper limb': 'arm',
  'elbow & wrist': 'arm',
  spine: 'spine_core',
  neck: 'neck',
};

/** Protocol/injury -> muscle-library entries for its body region (verified mapping only). */
export function getMusclesForBodyRegion(bodyRegion: string, lang: Language): CrossLink[] {
  const libraryRegion = BODY_REGION_TO_LIBRARY_REGION[bodyRegion.toLowerCase().trim()];
  if (!libraryRegion) return [];
  const links: CrossLink[] = [];
  for (const [slug, entry] of Object.entries(muscles)) {
    if ((entry as any).region !== libraryRegion) continue;
    links.push({
      label: lang === 'ar' ? entry.name_ar || entry.name || slug : entry.name || slug,
      href: `${navigationPaths.anatomy(lang)}/${slug}`,
    });
    if (links.length >= 3) break;
  }
  return links;
}

/**
 * Library muscle region -> injury catalog entries. Exact inverse of
 * BODY_REGION_TO_LIBRARY_REGION, so every emitted link rests on the same
 * verified region mapping used elsewhere on the site. Regions with no
 * mapped catalog injuries (e.g. neck) return an empty list rather than an
 * invented link.
 */
export function getInjuriesForLibraryRegion(libraryRegion: string, lang: Language, limit = 4): CrossLink[] {
  const catalog = getLocalCatalogInjuries(lang);
  const links: CrossLink[] = [];
  for (const injury of catalog) {
    const mapped = BODY_REGION_TO_LIBRARY_REGION[injury.bodyRegion.toLowerCase().trim()];
    if (mapped !== libraryRegion) continue;
    links.push({label: injury.name, href: navigationPaths.injuryDetail(lang, injury.slug)});
    if (links.length >= limit) break;
  }
  return links;
}

/** Total catalog injuries mapped to a library region (drives "view all" labels). */
export function countInjuriesForLibraryRegion(libraryRegion: string): number {
  const catalog = getLocalCatalogInjuries('en');
  let count = 0;
  for (const injury of catalog) {
    const mapped = BODY_REGION_TO_LIBRARY_REGION[injury.bodyRegion.toLowerCase().trim()];
    if (mapped === libraryRegion) count += 1;
  }
  return count;
}

/**
 * Library muscle region -> exercise-finder region slug, for "train this
 * region" links from anatomy pages. Values are verified against
 * EXERCISE_FINDER_STATIC_SLUGS in crossLinks.test.ts; a region with no
 * honest counterpart maps to nothing.
 */
const LIBRARY_REGION_TO_EXERCISE_REGION: Record<string, string> = {
  shoulder: 'shoulders',
  arm: 'arms',
  spine_core: 'core',
  hip_pelvis: 'glutes',
  knee_thigh: 'legs',
  ankle_foot: 'calves',
  neck: 'neck',
};

export function getExerciseRegionForMuscleRegion(libraryRegion: string): string | null {
  return LIBRARY_REGION_TO_EXERCISE_REGION[libraryRegion] || null;
}
