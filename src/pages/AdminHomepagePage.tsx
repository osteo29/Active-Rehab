import {isSafeContentLink} from '../services/adminValidation';
import {useEffect, useState} from 'react';
import Seo from '../components/seo/Seo';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import useAdminAccess from '../hooks/useAdminAccess';
import usePreferredLang from './usePreferredLang';
import {listHomepageSettings, type HomepageSettingsInsert, upsertHomepageSettings} from '../services/adminCms';

type DraftMap = Record<'en' | 'ar', HomepageSettingsInsert>;

const defaultDrafts: DraftMap = {
  en: {
    lang: 'en',
    hero_badge: 'Featured',
    hero_title: 'Move better with practical rehab guidance',
    hero_description: 'A limited homepage CMS for hero content, featured posts, section order, and banners.',
    hero_cta_label: 'Explore injuries',
    hero_cta_href: '/en/injuries',
    featured_post_slugs: [],
    section_order: ['injuries', 'articles', 'exercises', 'calculators'],
    banner_title: '',
    banner_body: '',
    banner_cta_label: '',
    banner_cta_href: '',
  },
  ar: {
    lang: 'ar',
    hero_badge: 'مميز',
    hero_title: 'تحكم عملي في محتوى الصفحة الرئيسية',
    hero_description: 'لوحة محدودة للـ hero والمحتوى المميز وترتيب الأقسام والبنرات فقط.',
    hero_cta_label: 'استكشف الإصابات',
    hero_cta_href: '/ar/injuries',
    featured_post_slugs: [],
    section_order: ['injuries', 'articles', 'exercises', 'calculators'],
    banner_title: '',
    banner_body: '',
    banner_cta_label: '',
    banner_cta_href: '',
  },
};

function listToText(values?: string[] | null) {
  return (values || []).join('\n');
}

function textToList(value: string) {
  return value
    .split('\n')
    .map((item) => item.trim())
    .filter(Boolean);
}

export default function AdminHomepagePage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const [activeLang, setActiveLang] = useState<'en' | 'ar'>(uiLang);
  const [drafts, setDrafts] = useState<DraftMap>(defaultDrafts);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [notice, setNotice] = useState('');

  useEffect(() => {
    if (!access.authChecked || !access.canManageHomepage) {
      setLoading(false);
      return;
    }
    let active = true;
    const load = async () => {
      try {
        setLoading(true);
        const rows = await listHomepageSettings();
        if (!active) return;
        const nextDrafts: DraftMap = {...defaultDrafts};
        rows.forEach((row) => {
          nextDrafts[row.lang] = {
            lang: row.lang,
            hero_badge: row.hero_badge || '',
            hero_title: row.hero_title,
            hero_description: row.hero_description || '',
            hero_cta_label: row.hero_cta_label || '',
            hero_cta_href: row.hero_cta_href || '',
            featured_post_slugs: row.featured_post_slugs || [],
            section_order: row.section_order || [],
            banner_title: row.banner_title || '',
            banner_body: row.banner_body || '',
            banner_cta_label: row.banner_cta_label || '',
            banner_cta_href: row.banner_cta_href || '',
          };
        });
        setDrafts(nextDrafts);
      } catch (error) {
        if (!active) return;
        setNotice(error instanceof Error ? error.message : isAr ? 'تعذر تحميل إعدادات الصفحة الرئيسية.' : 'Could not load homepage settings.');
      } finally {
        if (active) setLoading(false);
      }
    };

    void load();
    return () => {
      active = false;
    };
  }, [isAr, access.authChecked, access.canManageHomepage]);

  const draft = drafts[activeLang];

  const updateDraft = (field: keyof HomepageSettingsInsert, value: string | string[]) => {
    setDrafts((current) => ({
      ...current,
      [activeLang]: {
        ...current[activeLang],
        [field]: value,
      },
    }));
  };

  const handleSave = async () => {
    if (!access.canManageHomepage || saving) return;
    if (!draft.hero_title.trim()) {
      setNotice(isAr ? 'عنوان الصفحة مطلوب.' : 'A hero title is required.');
      return;
    }
    if (![draft.hero_cta_href || '', draft.banner_cta_href || ''].every(isSafeContentLink)) {
      setNotice(isAr ? 'استخدم رابطًا محليًا يبدأ بـ / أو رابط HTTP أو HTTPS صالحًا.' : 'Use a local / path or a valid HTTP or HTTPS link.');
      return;
    }
    try {
      setSaving(true);
      await upsertHomepageSettings(draft);
      setNotice(isAr ? 'تم حفظ إعدادات الصفحة الرئيسية.' : 'Homepage settings saved.');
    } catch (error) {
      setNotice(error instanceof Error ? error.message : isAr ? 'تعذر حفظ الإعدادات.' : 'Could not save settings.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <Seo
        title={isAr ? 'إدارة الصفحة الرئيسية' : 'Homepage CMS'}
        description={isAr ? 'تحكم محدود في محتوى الصفحة الرئيسية فقط.' : 'Limited homepage content management only.'}
        canonicalPath="/admin/homepage"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'إدارة الصفحة الرئيسية' : 'Homepage CMS'}
        canonicalPath="/admin/homepage"
        requiredPermission="homepage"
      >
        <AdminShell
          title={isAr ? 'تحكم محدود في الصفحة الرئيسية' : 'Limited homepage controls'}
          description={
            isAr
              ? 'يمكنك هنا تعديل الـ hero والمقالات المميزة وترتيب الأقسام والبنرات فقط. بنية الواجهة تبقى ثابتة.'
              : 'Edit hero content, featured posts, section order, and banners only. The frontend structure remains fixed.'
          }
          currentTab="homepage"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
        >
          <div className="rounded-3xl border border-slate-200 bg-white p-6">
            <div className="flex flex-wrap gap-3">
              {(['ar', 'en'] as const).map((lang) => (
                <button
                  key={lang}
                  type="button"
                  onClick={() => setActiveLang(lang)}
                  className={`rounded-full px-4 py-2 text-sm font-bold ${activeLang === lang ? 'bg-health-green text-white' : 'bg-slate-100 text-slate-700'}`}
                >
                  {lang === 'ar' ? 'العربية' : 'English'}
                </button>
              ))}
            </div>

            {loading ? (
              <p className="mt-6 text-sm text-slate-500">{isAr ? 'جار التحميل...' : 'Loading...'}</p>
            ) : (
              <div className="mt-6 grid gap-4">
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'شارة الـ hero' : 'Hero badge'}</span>
                  <input value={draft.hero_badge || ''} onChange={(event) => updateDraft('hero_badge', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'عنوان الـ hero' : 'Hero title'}</span>
                  <input value={draft.hero_title || ''} onChange={(event) => updateDraft('hero_title', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'وصف الـ hero' : 'Hero description'}</span>
                  <textarea value={draft.hero_description || ''} onChange={(event) => updateDraft('hero_description', event.target.value)} rows={4} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <div className="grid gap-4 md:grid-cols-2">
                  <label className="space-y-2 text-sm">
                    <span className="font-bold text-slate-700">{isAr ? 'نص الزر' : 'CTA label'}</span>
                    <input value={draft.hero_cta_label || ''} onChange={(event) => updateDraft('hero_cta_label', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                  <label className="space-y-2 text-sm">
                    <span className="font-bold text-slate-700">{isAr ? 'رابط الزر' : 'CTA href'}</span>
                    <input value={draft.hero_cta_href || ''} onChange={(event) => updateDraft('hero_cta_href', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                </div>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'المقالات المميزة (slug لكل سطر)' : 'Featured post slugs (one per line)'}</span>
                  <textarea value={listToText(draft.featured_post_slugs)} onChange={(event) => updateDraft('featured_post_slugs', textToList(event.target.value))} rows={4} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'ترتيب الأقسام (one per line)' : 'Section order (one per line)'}</span>
                  <textarea value={listToText(draft.section_order)} onChange={(event) => updateDraft('section_order', textToList(event.target.value))} rows={4} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <div className="grid gap-4 md:grid-cols-2">
                  <label className="space-y-2 text-sm md:col-span-2">
                    <span className="font-bold text-slate-700">{isAr ? 'عنوان البنر' : 'Banner title'}</span>
                    <input value={draft.banner_title || ''} onChange={(event) => updateDraft('banner_title', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                  <label className="space-y-2 text-sm md:col-span-2">
                    <span className="font-bold text-slate-700">{isAr ? 'نص البنر' : 'Banner body'}</span>
                    <textarea value={draft.banner_body || ''} onChange={(event) => updateDraft('banner_body', event.target.value)} rows={3} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                  <label className="space-y-2 text-sm">
                    <span className="font-bold text-slate-700">{isAr ? 'زر البنر' : 'Banner CTA label'}</span>
                    <input value={draft.banner_cta_label || ''} onChange={(event) => updateDraft('banner_cta_label', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                  <label className="space-y-2 text-sm">
                    <span className="font-bold text-slate-700">{isAr ? 'رابط البنر' : 'Banner CTA href'}</span>
                    <input value={draft.banner_cta_href || ''} onChange={(event) => updateDraft('banner_cta_href', event.target.value)} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                  </label>
                </div>
              </div>
            )}

            <div className="mt-6 flex flex-wrap gap-3">
              <button type="button" onClick={() => void handleSave()} disabled={saving || loading} className="rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white disabled:opacity-60">
                {saving ? (isAr ? 'جار الحفظ...' : 'Saving...') : isAr ? 'حفظ' : 'Save'}
              </button>
            </div>

            {notice ? <p role="status" aria-live="polite" className="mt-4 text-sm text-slate-600">{notice}</p> : null}
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
