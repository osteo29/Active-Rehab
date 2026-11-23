import {useEffect, useMemo, useState} from 'react';
import {LoaderCircle, Search} from 'lucide-react';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import Seo from '../components/seo/Seo';
import useAdminAccess from '../hooks/useAdminAccess';
import {getSupabaseActionErrorMessage} from '../lib/supabase';
import {
  listSeoPageDefinitions,
  loadSeoOverrides,
  resolveSeoCopy,
  saveSeoPageOverride,
  type SeoPageKey,
} from '../services/managedSeo';
import usePreferredLang from './usePreferredLang';

type SeoDraft = {
  titleEn: string;
  descriptionEn: string;
  titleAr: string;
  descriptionAr: string;
};

function buildDraft(
  pageKey: SeoPageKey,
  overrides?: Awaited<ReturnType<typeof loadSeoOverrides>> | null,
): SeoDraft {
  return {
    titleEn: resolveSeoCopy({pageKey, lang: 'en', overrides}).title,
    descriptionEn: resolveSeoCopy({pageKey, lang: 'en', overrides}).description,
    titleAr: resolveSeoCopy({pageKey, lang: 'ar', overrides}).title,
    descriptionAr: resolveSeoCopy({pageKey, lang: 'ar', overrides}).description,
  };
}

export default function AdminSeoPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const definitions = useMemo(() => listSeoPageDefinitions(), []);
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');
  const [savingKey, setSavingKey] = useState<SeoPageKey | ''>('');
  const [drafts, setDrafts] = useState<Record<SeoPageKey, SeoDraft>>(
    () =>
      definitions.reduce<Record<SeoPageKey, SeoDraft>>((acc, definition) => {
        acc[definition.key] = buildDraft(definition.key, null);
        return acc;
      }, {} as Record<SeoPageKey, SeoDraft>),
  );

  useEffect(() => {
    let active = true;

    const load = async () => {
      try {
        setLoading(true);
        const overrides = await loadSeoOverrides(true);
        if (!active) return;

        setDrafts(
          definitions.reduce<Record<SeoPageKey, SeoDraft>>((acc, definition) => {
            acc[definition.key] = buildDraft(definition.key, overrides);
            return acc;
          }, {} as Record<SeoPageKey, SeoDraft>),
        );
        setErrorMessage('');
      } catch (error) {
        if (!active) return;
        setErrorMessage(getSupabaseActionErrorMessage(error, uiLang, 'load'));
      } finally {
        if (active) setLoading(false);
      }
    };

    if (access.canManageSeo) {
      void load();
    } else {
      setLoading(false);
    }

    return () => {
      active = false;
    };
  }, [access.canManageSeo, definitions, uiLang]);

  const filteredDefinitions = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();
    if (!normalizedQuery) {
      return definitions;
    }

    return definitions.filter((definition) => {
      const haystack = [
        definition.labelEn,
        definition.labelAr,
        definition.key,
        definition.pathPattern,
        definition.variables.join(' '),
      ]
        .join(' ')
        .toLowerCase();

      return haystack.includes(normalizedQuery);
    });
  }, [definitions, query]);

  const updateDraft = (pageKey: SeoPageKey, field: keyof SeoDraft, value: string) => {
    setDrafts((current) => ({
      ...current,
      [pageKey]: {
        ...current[pageKey],
        [field]: value,
      },
    }));
  };

  const handleSave = async (pageKey: SeoPageKey) => {
    if (!access.canManageSeo || savingKey || loading) return;
    const draft = drafts[pageKey];

    try {
      setSavingKey(pageKey);
      setErrorMessage('');
      setSuccessMessage('');
      await saveSeoPageOverride({
        pageKey,
        titleEn: draft.titleEn,
        descriptionEn: draft.descriptionEn,
        titleAr: draft.titleAr,
        descriptionAr: draft.descriptionAr,
      });
      setSuccessMessage(
        isAr
          ? `تم حفظ إعدادات SEO لصفحة ${definitions.find((item) => item.key === pageKey)?.labelAr || pageKey}.`
          : `Saved SEO settings for ${pageKey}.`,
      );
    } catch (error) {
      setErrorMessage(getSupabaseActionErrorMessage(error, uiLang, 'save'));
    } finally {
      setSavingKey('');
    }
  };

  return (
    <>
      <Seo
        title={isAr ? 'إدارة SEO' : 'SEO Manager'}
        description={
          isAr
            ? 'تحكم في Title Tag و Meta Description لكل صفحات الموقع بالعربي والإنجليزي.'
            : 'Manage title tags and meta descriptions for every public page in Arabic and English.'
        }
        canonicalPath="/admin/seo"
        noIndex
      />

      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'إدارة SEO' : 'SEO Manager'}
        canonicalPath="/admin/seo"
        requiredPermission="seo"
      >
        <AdminShell
          title={isAr ? 'تحكم كامل في عناوين ووصف الصفحات' : 'Control titles and descriptions across the site'}
          description={
            isAr
              ? 'من هنا تقدر تعدّل Title Tag و Meta Description لكل صفحة عامة في الموقع بالعربي والإنجليزي. الصفحات الديناميكية تدعم متغيرات مثل {injuryName} و {articleTitle}.'
              : 'Edit the title tag and meta description for every public page in both Arabic and English. Dynamic pages support variables like {injuryName} and {articleTitle}.'
          }
          currentTab="seo"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
        >
          <div className="space-y-6">
            <div className="rounded-3xl border border-slate-200 bg-white p-5">
              <div className="flex flex-wrap items-center justify-between gap-4">
                <div>
                  <div className="text-sm font-black text-slate-900">
                    {isAr ? 'البحث داخل الصفحات' : 'Search pages'}
                  </div>
                  <div className="mt-1 text-sm text-slate-500">
                    {isAr
                      ? 'ابحث باسم الصفحة أو المسار أو المفتاح البرمجي.'
                      : 'Search by label, route pattern, or internal page key.'}
                  </div>
                </div>
                <div className="relative w-full max-w-md">
                  <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                  <input
                    aria-label={isAr ? 'البحث في صفحات الموقع' : 'Search site pages'}
                    value={query}
                    onChange={(event) => setQuery(event.target.value)}
                    placeholder={isAr ? 'ابحث عن صفحة...' : 'Search a page...'}
                    className="w-full rounded-2xl border border-slate-200 py-3 pl-10 pr-4 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                  />
                </div>
              </div>
            </div>

            {errorMessage ? (
              <div role="alert" className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-semibold text-rose-700">
                {errorMessage}
              </div>
            ) : null}

            {successMessage ? (
              <div role="status" aria-live="polite" className="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">
                {successMessage}
              </div>
            ) : null}

            {loading ? (
              <div className="flex min-h-[220px] items-center justify-center rounded-3xl border border-slate-200 bg-white">
                <LoaderCircle className="h-5 w-5 animate-spin text-health-green" />
              </div>
            ) : (
              <div className="space-y-5">
                {filteredDefinitions.map((definition) => {
                  const draft = drafts[definition.key];
                  const isSaving = savingKey === definition.key;

                  return (
                    <section key={definition.key} className="rounded-3xl border border-slate-200 bg-white p-6">
                      <div className="flex flex-wrap items-start justify-between gap-4">
                        <div className="space-y-2">
                          <div className="text-xs font-black uppercase tracking-[0.18em] text-health-green">
                            {definition.key}
                          </div>
                          <h3 className="text-xl font-black text-slate-900">
                            {isAr ? definition.labelAr : definition.labelEn}
                          </h3>
                          <div className="text-sm text-slate-500">{definition.pathPattern}</div>
                        </div>
                        <button
                          type="button"
                          onClick={() => void handleSave(definition.key)}
                          disabled={Boolean(savingKey) || loading}
                          className="inline-flex items-center gap-2 rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white transition hover:bg-health-green-dark disabled:cursor-not-allowed disabled:opacity-60"
                        >
                          {isSaving ? <LoaderCircle className="h-4 w-4 animate-spin" /> : null}
                          <span>{isAr ? 'حفظ' : 'Save'}</span>
                        </button>
                      </div>

                      {definition.variables.length ? (
                        <div className="mt-4 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
                          <span className="font-bold">{isAr ? 'المتغيرات المتاحة:' : 'Available variables:'}</span>{' '}
                          {definition.variables.map((item) => `{${item}}`).join(', ')}
                        </div>
                      ) : null}

                      <div className="mt-5 grid gap-5 xl:grid-cols-2">
                        <div className="space-y-4 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                          <div className="text-sm font-black text-slate-900">English</div>
                          <label className="block space-y-2">
                            <span className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">Title</span>
                            <input
                              value={draft?.titleEn || ''}
                              onChange={(event) => updateDraft(definition.key, 'titleEn', event.target.value)}
                              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                            />
                          </label>
                          <label className="block space-y-2">
                            <span className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">Meta description</span>
                            <textarea
                              value={draft?.descriptionEn || ''}
                              onChange={(event) => updateDraft(definition.key, 'descriptionEn', event.target.value)}
                              rows={4}
                              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                            />
                          </label>
                        </div>

                        <div className="space-y-4 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                          <div className="text-sm font-black text-slate-900">العربية</div>
                          <label className="block space-y-2">
                            <span className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">Title</span>
                            <input
                              dir="rtl"
                              value={draft?.titleAr || ''}
                              onChange={(event) => updateDraft(definition.key, 'titleAr', event.target.value)}
                              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                            />
                          </label>
                          <label className="block space-y-2">
                            <span className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">Meta description</span>
                            <textarea
                              dir="rtl"
                              value={draft?.descriptionAr || ''}
                              onChange={(event) => updateDraft(definition.key, 'descriptionAr', event.target.value)}
                              rows={4}
                              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                            />
                          </label>
                        </div>
                      </div>
                    </section>
                  );
                })}
              </div>
            )}
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
