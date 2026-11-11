import {
  fetchCompleteRehabProtocol,
  fetchRehabProtocolsFromSupabase,
  getGeneratedRehabProtocolRows,
  getLastRehabProtocolSource,
  getRehabProtocolSlug,
  type RehabProtocolRow,
} from './rehabProtocolSupabaseService';
import {translateInjury} from './injuryI18n';
import type {InjuryProtocol} from './injuryDatabase';
import {safeMedicalText, safeMedicalTextDeep} from './textEncoding';
import type {Language} from './translations';

export type InjuryCatalogSource = 'supabase' | 'generated' | 'local';

export type InjuryCatalogEntry = {
  id: string;
  slug: string;
  name: string;
  category: string;
  bodyRegion: string;
  overview: string;
  commonIn: string[];
  source: InjuryCatalogSource;
  remoteRef?: RehabProtocolRow;
};

let remoteInjuryRowsCache: RehabProtocolRow[] | null = null;
let remoteInjuryRowsPromise: Promise<RehabProtocolRow[]> | null = null;

function sanitizeCatalogEntry(entry: InjuryCatalogEntry): InjuryCatalogEntry {
  return safeMedicalTextDeep(entry);
}

function mapGeneratedInjury(row: RehabProtocolRow, lang: Language, source: InjuryCatalogSource): InjuryCatalogEntry {
  const slug = getRehabProtocolSlug(row.name);
  const regionEn = row.category || 'General';
  const overviewEn =
    row.description ||
    `${row.name} rehab protocol with phased goals, precautions, and progression criteria.`;

  const translated = translateInjury(
    {
      slugOrId: slug,
      nameEn: row.name,
      regionEn,
      overviewEn,
    },
    lang,
  );

  return sanitizeCatalogEntry({
    id: slug.replace(/-/g, '_'),
    slug,
    name: safeMedicalText(translated.name),
    category: safeMedicalText(translated.bodyRegion),
    bodyRegion: safeMedicalText(translated.bodyRegion),
    overview: safeMedicalText(translated.overview),
    commonIn: [],
    source,
    remoteRef: row,
  });
}

export async function getRemoteInjuryRows(options?: {force?: boolean}) {
  if (options?.force) {
    remoteInjuryRowsCache = null;
    remoteInjuryRowsPromise = null;
  }

  if (remoteInjuryRowsCache) {
    return remoteInjuryRowsCache;
  }

  if (!remoteInjuryRowsPromise) {
    remoteInjuryRowsPromise = fetchRehabProtocolsFromSupabase()
      .then((rows) => {
        const sanitizedRows = rows.map((row) => safeMedicalTextDeep(row));
        remoteInjuryRowsCache = sanitizedRows;
        return sanitizedRows;
      })
      .catch((error) => {
        remoteInjuryRowsPromise = null;
        throw error;
      });
  }

  return remoteInjuryRowsPromise;
}

export async function getCatalogInjuries(
  lang: Language,
): Promise<{injuries: InjuryCatalogEntry[]; source: InjuryCatalogSource}> {
  const rows = await getRemoteInjuryRows();
  const source = getLastRehabProtocolSource() === 'supabase' ? 'supabase' : 'generated';

  return {
    injuries: rows.map((row) => mapGeneratedInjury(row, lang, source)).sort((left, right) => left.name.localeCompare(right.name, lang)),
    source,
  };
}

export function getLocalCatalogInjuries(lang: Language): InjuryCatalogEntry[] {
  return getGeneratedProtocolCatalog(lang);
}

export async function getInjuryProtocolBySlugWithFallback(
  slug: string,
  lang: Language,
): Promise<{injury: InjuryProtocol | null; source: InjuryCatalogSource; remoteIds: string[]}> {
  const rowsPromise = getRemoteInjuryRows();
  const protocolPromise = rowsPromise.then((rows) => fetchCompleteRehabProtocol(slug, lang, rows));
  const [protocol, rows] = await Promise.all([protocolPromise, rowsPromise]);
  const source = getLastRehabProtocolSource() === 'supabase' ? 'supabase' : 'generated';

  return {
    injury: protocol ? safeMedicalTextDeep(protocol) : null,
    source,
    remoteIds: rows.map((row) => getRehabProtocolSlug(row.name).replace(/-/g, '_')),
  };
}

export async function getRelatedCatalogInjuriesByIds(
  ids: string[],
  lang: Language,
): Promise<InjuryCatalogEntry[]> {
  const normalizedIds = [...new Set(ids.filter(Boolean))];
  if (!normalizedIds.length) return [];

  const rows = await getRemoteInjuryRows();
  const source = getLastRehabProtocolSource() === 'supabase' ? 'supabase' : 'generated';
  const remoteById = new Map(rows.map((row) => [getRehabProtocolSlug(row.name).replace(/-/g, '_'), row]));

  return normalizedIds
    .map((id) => {
      const remote = remoteById.get(id);
      return remote ? mapGeneratedInjury(remote, lang, source) : null;
    })
    .filter((item): item is InjuryCatalogEntry => Boolean(item));
}

function getGeneratedProtocolCatalog(lang: Language) {
  return remoteInjuryRowsCache
    ? remoteInjuryRowsCache.map((row) => mapGeneratedInjury(row, lang, 'generated')).sort((left, right) => left.name.localeCompare(right.name, lang))
    : getGeneratedRowsSnapshot(lang);
}

function getGeneratedRowsSnapshot(lang: Language) {
  return getGeneratedRehabProtocolRows()
    .map((row) => mapGeneratedInjury(row, lang, 'generated'))
    .sort((left, right) => left.name.localeCompare(right.name, lang));
}
