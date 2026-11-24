import {useEffect, useState} from 'react';
import type {Article} from './articles';
import type {Language} from './translations';
import {
  canCurrentUserManageArticles,
  getCurrentUser,
  isSupabaseConfigured,
  listPublishedArticles,
  replacePublishedArticles,
  supabase,
} from '../lib/supabase';
import type {Json, TableInsert, TableRow, TableUpdate} from '../lib/supabaseDatabase';

export type ArticleWorkflowStatus = 'draft' | 'published' | 'scheduled';

export type ArticleEditorEntry = Article & {
  workflowId?: string;
  tags: string[];
  imageAlt: string;
  seoTitle: string;
  seoDescription: string;
  ogImage?: string;
  canonicalUrl?: string;
  status: ArticleWorkflowStatus;
  scheduledFor?: string;
  publishedAt?: string;
  lastSavedAt?: string;
  revisionCount: number;
};

export type ArticleRevisionRow = TableRow<'article_revisions'>;
type ArticleWorkflowRow = TableRow<'article_workflows'>;
type ArticleWorkflowInsert = TableInsert<'article_workflows'>;
type ArticleWorkflowUpdate = TableUpdate<'article_workflows'>;

async function loadArticlesModule() {
  return import('./articles');
}

function ensureSupabase() {
  if (!supabase) {
    throw new Error('Supabase is not configured.');
  }

  return supabase;
}

function buildSeoTitle(article: Article) {
  return article.title;
}

function buildSeoDescription(article: Article) {
  return article.excerpt;
}

function mapPublicArticleToEditorEntry(article: Article): ArticleEditorEntry {
  return {
    ...article,
    tags: [],
    imageAlt: '',
    seoTitle: buildSeoTitle(article),
    seoDescription: buildSeoDescription(article),
    ogImage: article.image,
    canonicalUrl: '',
    status: 'published',
    revisionCount: 0,
  };
}

function mapWorkflowRowToEditorEntry(row: ArticleWorkflowRow, revisionCount = 0): ArticleEditorEntry {
  return {
    id: revisionCount || Date.parse(row.date) || Math.floor(Math.random() * 100000),
    workflowId: row.id,
    slug: row.slug,
    title: row.title,
    excerpt: row.excerpt,
    content: row.content,
    category: row.category,
    date: row.date,
    icon: row.icon,
    image: row.image || undefined,
    tags: row.tags || [],
    imageAlt: row.image_alt || '',
    seoTitle: row.seo_title || row.title,
    seoDescription: row.seo_description || row.excerpt,
    ogImage: row.og_image || row.image || undefined,
    canonicalUrl: row.canonical_url || '',
    status: row.status,
    scheduledFor: row.scheduled_for || undefined,
    publishedAt: row.published_at || undefined,
    lastSavedAt: row.updated_at,
    revisionCount,
  };
}

function mapEditorEntryToWorkflowPayload(lang: Language, article: ArticleEditorEntry): ArticleWorkflowInsert {
  return {
    lang,
    slug: article.slug.trim(),
    title: article.title.trim(),
    excerpt: article.excerpt.trim(),
    content: article.content,
    category: article.category.trim() || 'General',
    date: article.date,
    icon: article.icon.trim() || 'BookOpen',
    image: article.image?.trim() || null,
    tags: article.tags,
    image_alt: article.imageAlt.trim() || null,
    seo_title: article.seoTitle.trim() || null,
    seo_description: article.seoDescription.trim() || null,
    og_image: article.ogImage?.trim() || null,
    canonical_url: article.canonicalUrl?.trim() || null,
    status: article.status,
    scheduled_for: article.status === 'scheduled' ? article.scheduledFor || null : null,
    published_at: article.status === 'published' ? new Date().toISOString() : article.publishedAt || null,
  };
}

function serializeArticlePayload(article: ArticleEditorEntry): Json {
  return {
    slug: article.slug,
    title: article.title,
    excerpt: article.excerpt,
    content: article.content,
    category: article.category,
    date: article.date,
    icon: article.icon,
    image: article.image || null,
    tags: article.tags,
    imageAlt: article.imageAlt,
    seoTitle: article.seoTitle,
    seoDescription: article.seoDescription,
    ogImage: article.ogImage || null,
    canonicalUrl: article.canonicalUrl || null,
    status: article.status,
    scheduledFor: article.scheduledFor || null,
    publishedAt: article.publishedAt || null,
  };
}

function hydrateArticlePayload(payload: Json, fallback: Partial<ArticleEditorEntry> = {}): ArticleEditorEntry {
  const obj = typeof payload === 'object' && payload && !Array.isArray(payload) ? payload : {};
  const imageValue = typeof obj.image === 'string' ? obj.image : undefined;
  const ogImageValue = typeof obj.ogImage === 'string' ? obj.ogImage : undefined;
  return {
    id: fallback.id || Math.floor(Math.random() * 100000),
    workflowId: fallback.workflowId,
    slug: typeof obj.slug === 'string' ? obj.slug : fallback.slug || 'article',
    title: typeof obj.title === 'string' ? obj.title : fallback.title || '',
    excerpt: typeof obj.excerpt === 'string' ? obj.excerpt : fallback.excerpt || '',
    content: typeof obj.content === 'string' ? obj.content : fallback.content || '',
    category: typeof obj.category === 'string' ? obj.category : fallback.category || 'General',
    date: typeof obj.date === 'string' ? obj.date : fallback.date || new Date().toISOString().slice(0, 10),
    icon: typeof obj.icon === 'string' ? obj.icon : fallback.icon || 'BookOpen',
    image: imageValue || fallback.image,
    tags: Array.isArray(obj.tags) ? obj.tags.filter((item): item is string => typeof item === 'string') : fallback.tags || [],
    imageAlt: typeof obj.imageAlt === 'string' ? obj.imageAlt : fallback.imageAlt || '',
    seoTitle: typeof obj.seoTitle === 'string' ? obj.seoTitle : fallback.seoTitle || fallback.title || '',
    seoDescription:
      typeof obj.seoDescription === 'string' ? obj.seoDescription : fallback.seoDescription || fallback.excerpt || '',
    ogImage: ogImageValue || fallback.ogImage,
    canonicalUrl: typeof obj.canonicalUrl === 'string' ? obj.canonicalUrl : fallback.canonicalUrl || '',
    status:
      obj.status === 'draft' || obj.status === 'published' || obj.status === 'scheduled'
        ? obj.status
        : fallback.status || 'draft',
    scheduledFor: typeof obj.scheduledFor === 'string' ? obj.scheduledFor : fallback.scheduledFor,
    publishedAt: typeof obj.publishedAt === 'string' ? obj.publishedAt : fallback.publishedAt,
    lastSavedAt: fallback.lastSavedAt,
    revisionCount: fallback.revisionCount || 0,
  };
}

async function listWorkflowRows(lang: Language) {
  const client = ensureSupabase();
  const {data, error} = await client
    .from('article_workflows')
    .select('*')
    .eq('lang', lang)
    .order('updated_at', {ascending: false});

  if (error) throw error;
  return data || [];
}

async function deleteMissingWorkflowRows(lang: Language, keepSlugs: string[]) {
  const client = ensureSupabase();
  const existingRows = await listWorkflowRows(lang);
  const slugsToDelete = existingRows.map((row) => row.slug).filter((slug) => !keepSlugs.includes(slug));

  if (!slugsToDelete.length) return;

  const {error} = await client.from('article_workflows').delete().eq('lang', lang).in('slug', slugsToDelete);
  if (error) throw error;
}

async function getRevisionCounts(workflowIds: string[]) {
  if (!workflowIds.length) return new Map<string, number>();
  const client = ensureSupabase();
  const {data, error} = await client
    .from('article_revisions')
    .select('workflow_id')
    .in('workflow_id', workflowIds);

  if (error) throw error;

  const counts = new Map<string, number>();
  for (const row of data || []) {
    counts.set(row.workflow_id, (counts.get(row.workflow_id) || 0) + 1);
  }
  return counts;
}

export async function getFallbackArticles(lang: Language): Promise<Article[]> {
  const {getArticles} = await loadArticlesModule();
  return getArticles(lang);
}

export function mergeCloudWithFallback(cloudArticles: Article[], fallbackArticles: Article[]): Article[] {
  const cloudSlugs = new Set(cloudArticles.map((article) => article.slug));
  const merged = [
    ...cloudArticles,
    ...fallbackArticles.filter((article) => !cloudSlugs.has(article.slug)),
  ];
  return merged.sort((a, b) => (Date.parse(b.date) || 0) - (Date.parse(a.date) || 0));
}

export async function loadPublishedArticles(lang: Language): Promise<Article[]> {
  const fallbackArticles = await getFallbackArticles(lang);
  if (!isSupabaseConfigured) return fallbackArticles;

  try {
    const cloudArticles = await listPublishedArticles(lang);
    return mergeCloudWithFallback(cloudArticles, fallbackArticles);
  } catch {
    return fallbackArticles;
  }
}

export async function loadArticleEditorEntries(lang: Language): Promise<ArticleEditorEntry[]> {
  if (!isSupabaseConfigured || !supabase) {
    return (await getFallbackArticles(lang)).map(mapPublicArticleToEditorEntry);
  }

  try {
    const rows = await listWorkflowRows(lang);
    if (!rows.length) {
      return (await loadPublishedArticles(lang)).map(mapPublicArticleToEditorEntry);
    }

    const revisionCounts = await getRevisionCounts(rows.map((row) => row.id));
    return rows.map((row, index) => ({
      ...mapWorkflowRowToEditorEntry(row, revisionCounts.get(row.id) || 0),
      id: index + 1,
    }));
  } catch {
    return (await loadPublishedArticles(lang)).map(mapPublicArticleToEditorEntry);
  }
}

export async function loadPublishedArticleBySlug(lang: Language, slug: string): Promise<Article | undefined> {
  const {getArticleBySlug} = await loadArticlesModule();
  const articles = await loadPublishedArticles(lang);
  return articles.find((article) => article.slug === slug) ?? getArticleBySlug(lang, slug);
}

async function getNextRevisionNumber(workflowId: string) {
  const client = ensureSupabase();
  const {data, error} = await client
    .from('article_revisions')
    .select('revision_number')
    .eq('workflow_id', workflowId)
    .order('revision_number', {ascending: false})
    .limit(1)
    .maybeSingle();

  if (error) throw error;
  return (data?.revision_number || 0) + 1;
}

async function createRevision(
  workflowId: string,
  lang: Language,
  article: ArticleEditorEntry,
  changeNote?: string,
) {
  const client = ensureSupabase();
  const currentUser = await getCurrentUser().catch(() => null);
  const revisionNumber = await getNextRevisionNumber(workflowId);

  const {error} = await client.from('article_revisions').insert({
    workflow_id: workflowId,
    lang,
    slug: article.slug,
    revision_number: revisionNumber,
    status: article.status,
    change_note: changeNote || null,
    payload: serializeArticlePayload(article),
    saved_by: currentUser?.id || null,
  });

  if (error) throw error;
}

async function upsertArticleWorkflow(lang: Language, article: ArticleEditorEntry, changeNote?: string) {
  const client = ensureSupabase();
  const payload = mapEditorEntryToWorkflowPayload(lang, article);

  const {data, error} = await client
    .from('article_workflows')
    .upsert(payload, {onConflict: 'lang,slug'})
    .select('*')
    .single();

  if (error) throw error;
  await createRevision(data.id, lang, {...article, workflowId: data.id}, changeNote);
  return data;
}

function mapEditorEntryToPublishedArticle(entry: ArticleEditorEntry): Article {
  return {
    id: entry.id,
    slug: entry.slug,
    title: entry.title,
    excerpt: entry.excerpt,
    content: entry.content,
    category: entry.category,
    date: entry.date,
    icon: entry.icon,
    image: entry.image,
  };
}

async function syncPublishedArticlesFromWorkflows(lang: Language) {
  const client = ensureSupabase();
  const nowIso = new Date().toISOString();
  const {data, error} = await client
    .from('article_workflows')
    .select('*')
    .eq('lang', lang)
    .or(`status.eq.published,and(status.eq.scheduled,scheduled_for.lte.${nowIso})`)
    .order('date', {ascending: false})
    .order('updated_at', {ascending: false});

  if (error) throw error;
  await replacePublishedArticles(lang, (data || []).map((row, index) => ({
    ...mapEditorEntryToPublishedArticle(mapWorkflowRowToEditorEntry(row)),
    id: index + 1,
  })));
}

export async function saveArticleDrafts(lang: Language, articles: ArticleEditorEntry[], changeNote?: string) {
  if (!(await canCurrentUserManageArticles())) {
    throw new Error('You do not have permission to manage article drafts.');
  }

  await deleteMissingWorkflowRows(
    lang,
    articles.map((article) => article.slug.trim()),
  );

  const workflows: ArticleWorkflowRow[] = [];
  for (const article of articles) {
    const savedWorkflow = await upsertArticleWorkflow(lang, article, changeNote);
    workflows.push(savedWorkflow);
  }

  if (typeof window !== 'undefined') {
    window.dispatchEvent(new CustomEvent('physiohub-article-drafts-updated', {detail: {lang}}));
  }

  return workflows;
}

export async function publishArticles(lang: Language, articles: ArticleEditorEntry[]) {
  if (!(await canCurrentUserManageArticles())) {
    throw new Error('You do not have permission to publish article changes.');
  }

  const normalizedArticles = articles.map((article) =>
    article.status === 'draft' ? {...article, status: 'published' as const, publishedAt: new Date().toISOString()} : article,
  );
  await saveArticleDrafts(lang, normalizedArticles, 'Published from article studio');
  await syncPublishedArticlesFromWorkflows(lang);

  if (typeof window !== 'undefined') {
    window.dispatchEvent(new CustomEvent('physiohub-articles-updated', {detail: {lang}}));
  }
}

export async function importFallbackArticlesToSupabase(lang: Language) {
  const fallbackArticles = (await getFallbackArticles(lang)).map(mapPublicArticleToEditorEntry);
  await saveArticleDrafts(lang, fallbackArticles, 'Imported fallback content');
  await publishArticles(lang, fallbackArticles.map((article) => ({...article, status: 'published'})));
  return fallbackArticles;
}

export function createBlankArticle(lang: Language, existingArticles: ArticleEditorEntry[]): ArticleEditorEntry {
  const nextId = existingArticles.reduce((max, article) => Math.max(max, article.id), 0) + 1;

  return {
    id: nextId,
    slug: lang === 'en' ? `new-article-${nextId}` : `maqal-jadid-${nextId}`,
    title: lang === 'en' ? 'New article title' : 'عنوان مقال جديد',
    excerpt:
      lang === 'en'
        ? 'Short summary that appears on the cards and search previews.'
        : 'ملخص قصير يظهر في كروت المقالات ونتائج البحث.',
    content:
      lang === 'en'
        ? `Write your introduction here.\n\n## First heading\nAdd your paragraph.\n\n* First point\n* Second point\n\n## Conclusion\nFinish the article here.`
        : `اكتب مقدمة المقال هنا.\n\n## العنوان الأول\nاكتب الفقرة هنا.\n\n* النقطة الأولى\n* النقطة الثانية\n\n## الخلاصة\nاختم المقال هنا.`,
    category: lang === 'en' ? 'General' : 'عام',
    date: new Date().toISOString().slice(0, 10),
    icon: 'BookOpen',
    tags: [],
    imageAlt: '',
    seoTitle: lang === 'en' ? 'New article title' : 'عنوان مقال جديد',
    seoDescription:
      lang === 'en'
        ? 'Short summary that appears on the cards and search previews.'
        : 'ملخص قصير يظهر في كروت المقالات ونتائج البحث.',
    status: 'draft',
    revisionCount: 0,
  };
}

export function slugifyArticleTitle(title: string): string {
  return title
    .trim()
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s-]/gu, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-');
}

export async function listArticleRevisions(lang: Language, slug: string): Promise<ArticleRevisionRow[]> {
  if (!isSupabaseConfigured || !supabase) return [];
  const client = ensureSupabase();
  const {data: workflow, error: workflowError} = await client
    .from('article_workflows')
    .select('id')
    .eq('lang', lang)
    .eq('slug', slug)
    .maybeSingle();

  if (workflowError) throw workflowError;
  if (!workflow?.id) return [];

  const {data, error} = await client
    .from('article_revisions')
    .select('*')
    .eq('workflow_id', workflow.id)
    .order('revision_number', {ascending: false})
    .limit(10);

  if (error) throw error;
  return data || [];
}

export async function restoreArticleRevision(lang: Language, revisionId: string) {
  const client = ensureSupabase();
  const {data, error} = await client.from('article_revisions').select('*').eq('id', revisionId).single();
  if (error) throw error;

  const restoredEntry = hydrateArticlePayload(data.payload, {
    status: 'draft',
    publishedAt: undefined,
    revisionCount: data.revision_number,
  });

  await upsertArticleWorkflow(lang, restoredEntry, `Restored revision ${data.revision_number}`);
  return restoredEntry;
}

export async function deleteArticleWorkflow(lang: Language, slug: string) {
  if (!(await canCurrentUserManageArticles())) {
    throw new Error('You do not have permission to delete articles.');
  }

  const client = ensureSupabase();
  const {error} = await client.from('article_workflows').delete().eq('lang', lang).eq('slug', slug);
  if (error) throw error;

  await syncPublishedArticlesFromWorkflows(lang);

  if (typeof window !== 'undefined') {
    window.dispatchEvent(new CustomEvent('physiohub-article-drafts-updated', {detail: {lang}}));
    window.dispatchEvent(new CustomEvent('physiohub-articles-updated', {detail: {lang}}));
  }
}

export function usePublishedArticles(lang: Language) {
  const [articles, setArticles] = useState<Article[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;

    const refresh = async () => {
      setLoading(true);
      const nextArticles = await loadPublishedArticles(lang);
      if (!active) return;
      setArticles(nextArticles);
      setLoading(false);
    };

    void refresh();

    const handleUpdate = (event: Event) => {
      const customEvent = event as CustomEvent<{lang?: Language}>;
      if (!customEvent.detail?.lang || customEvent.detail.lang === lang) {
        void refresh();
      }
    };

    window.addEventListener('physiohub-articles-updated', handleUpdate);

    return () => {
      active = false;
      window.removeEventListener('physiohub-articles-updated', handleUpdate);
    };
  }, [lang]);

  return {articles, loading};
}
