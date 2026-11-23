import {isSafeContentLink, isValidContentSlug} from '../services/adminValidation';
import {useEffect, useMemo, useState} from 'react';
import Seo from '../components/seo/Seo';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import useAdminAccess from '../hooks/useAdminAccess';
import usePreferredLang from './usePreferredLang';
import {
  createExerciseLibraryEntry,
  deleteExerciseLibraryEntry,
  listExerciseLibraryEntriesAdmin,
  type ExerciseLibraryEntryInsert,
  type ExerciseLibraryEntryRow,
  updateExerciseLibraryEntry,
} from '../services/adminCms';

const blankDraft: ExerciseLibraryEntryInsert = {
  slug: '',
  name: '',
  region: '',
  description: '',
  difficulty: '',
  video_url: '',
  thumbnail_path: '',
  source: 'supabase',
};

export default function AdminExercisesPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const [items, setItems] = useState<ExerciseLibraryEntryRow[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [draft, setDraft] = useState<ExerciseLibraryEntryInsert>(blankDraft);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [notice, setNotice] = useState('');
  const [search, setSearch] = useState('');

  useEffect(() => {
    let active = true;
    const load = async () => {
      try {
        setLoading(true);
        const nextItems = await listExerciseLibraryEntriesAdmin();
        if (!active) return;
        setItems(nextItems);
        const first = nextItems[0] || null;
        setSelectedId(first?.id ?? null);
        setDraft(
          first
            ? {
                slug: first.slug,
                name: first.name,
                region: first.region,
                description: first.description || '',
                difficulty: first.difficulty || '',
                video_url: first.video_url || '',
                thumbnail_path: first.thumbnail_path || '',
                source: first.source || 'supabase',
              }
            : blankDraft,
        );
      } catch (error) {
        if (!active) return;
        setNotice(error instanceof Error ? error.message : isAr ? 'تعذر تحميل مكتبة التمارين.' : 'Could not load exercise library.');
      } finally {
        if (active) setLoading(false);
      }
    };

    void load();
    return () => {
      active = false;
    };
  }, [isAr]);

  const filteredItems = useMemo(() => {
    const query = search.trim().toLowerCase();
    if (!query) return items;
    return items.filter((item) => `${item.name} ${item.slug} ${item.region}`.toLowerCase().includes(query));
  }, [items, search]);

  const selectedItem = useMemo(() => items.find((item) => item.id === selectedId) || null, [items, selectedId]);

  const loadDraft = (item: ExerciseLibraryEntryRow | null) => {
    setDraft(
      item
        ? {
            slug: item.slug,
            name: item.name,
            region: item.region,
            description: item.description || '',
            difficulty: item.difficulty || '',
            video_url: item.video_url || '',
            thumbnail_path: item.thumbnail_path || '',
            source: item.source || 'supabase',
          }
        : blankDraft,
    );
  };

  const handleSelect = (item: ExerciseLibraryEntryRow) => {
    setSelectedId(item.id);
    loadDraft(item);
  };

  const handleCreate = () => {
    setSelectedId(null);
    setDraft(blankDraft);
    setNotice(isAr ? 'أدخل بيانات التمرين الجديد ثم احفظ.' : 'Enter the new exercise details, then save.');
  };

  const handleSave = async () => {
    if (!draft.slug.trim() || !draft.name.trim() || !draft.region.trim()) {
      setNotice(isAr ? 'الاسم والـ slug والمنطقة مطلوبة.' : 'Name, slug, and region are required.');
      return;
    }

    if (!isValidContentSlug(draft.slug)) {
      setNotice(isAr ? 'استخدم حروفًا إنجليزية صغيرة وأرقامًا وشرطات فقط في المعرّف.' : 'Use lowercase letters, numbers, hyphens or underscores in the slug.');
      return;
    }
    if (![draft.video_url || '', draft.thumbnail_path || ''].every(isSafeContentLink)) {
      setNotice(isAr ? 'استخدم روابط HTTP أو HTTPS أو مسارات محلية صالحة.' : 'Use valid HTTP or HTTPS links or local paths.');
      return;
    }

    try {
      setSaving(true);
      if (selectedItem) {
        const updated = await updateExerciseLibraryEntry(selectedItem.id, draft);
        setItems((current) => current.map((item) => (item.id === updated.id ? updated : item)));
        setNotice(isAr ? 'تم تحديث التمرين.' : 'Exercise updated.');
      } else {
        const created = await createExerciseLibraryEntry(draft);
        setItems((current) => [created, ...current]);
        setSelectedId(created.id);
        setNotice(isAr ? 'تم إنشاء التمرين.' : 'Exercise created.');
      }
    } catch (error) {
      setNotice(error instanceof Error ? error.message : isAr ? 'تعذر حفظ التمرين.' : 'Could not save exercise.');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!selectedItem) return;
    const confirmed = window.confirm(isAr ? 'حذف هذا التمرين؟' : 'Delete this exercise?');
    if (!confirmed) return;

    try {
      setSaving(true);
      await deleteExerciseLibraryEntry(selectedItem.id);
      const nextItems = items.filter((item) => item.id !== selectedItem.id);
      setItems(nextItems);
      const nextSelected = nextItems[0] || null;
      setSelectedId(nextSelected?.id ?? null);
      loadDraft(nextSelected);
      setNotice(isAr ? 'تم حذف التمرين.' : 'Exercise deleted.');
    } catch (error) {
      setNotice(error instanceof Error ? error.message : isAr ? 'تعذر حذف التمرين.' : 'Could not delete exercise.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <Seo
        title={isAr ? 'إدارة التمارين' : 'Exercise CMS'}
        description={isAr ? 'إدارة مكتبة التمارين والمرفقات الإعلامية.' : 'Manage exercise library content and media-ready fields.'}
        canonicalPath="/admin/exercises"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'إدارة التمارين' : 'Exercise CMS'}
        canonicalPath="/admin/exercises"
        requiredPermission="exercises"
      >
        <AdminShell
          title={isAr ? 'مكتبة التمارين' : 'Exercise library'}
          description={
            isAr
              ? 'إدارة الـ slug والوسائط والوصف وروابط الفيديو للتمارين ضمن هيكل CMS ثابت.'
              : 'Manage slugs, media fields, descriptions, and video links for exercises inside a fixed CMS structure.'
          }
          currentTab="exercises"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
        >
          <div className="grid gap-6 xl:grid-cols-[320px,minmax(0,1fr)]">
            <div className="rounded-3xl border border-slate-200 bg-white p-5">
              <div className="flex items-center justify-between gap-3">
                <h3 className="text-lg font-black text-slate-900">{isAr ? 'التمارين' : 'Exercises'}</h3>
                <button type="button" onClick={handleCreate} className="rounded-2xl bg-health-green px-3 py-2 text-sm font-bold text-white">
                  {isAr ? 'جديد' : 'New'}
                </button>
              </div>
              <input
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder={isAr ? 'ابحث...' : 'Search...'}
                className="mt-4 w-full rounded-2xl border border-slate-200 px-4 py-3 text-sm"
              />
              <div className="mt-4 space-y-2">
                {loading ? (
                  <p className="text-sm text-slate-500">{isAr ? 'جار التحميل...' : 'Loading...'}</p>
                ) : (
                  filteredItems.map((item) => (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => handleSelect(item)}
                      className={`block w-full rounded-2xl border px-4 py-3 text-left text-sm ${selectedId === item.id ? 'border-health-green bg-emerald-50' : 'border-slate-200 bg-slate-50'}`}
                    >
                      <div className="font-bold text-slate-900">{item.name}</div>
                      <div className="text-slate-500">{item.slug}</div>
                    </button>
                  ))
                )}
              </div>
            </div>

            <div className="rounded-3xl border border-slate-200 bg-white p-6">
              <div className="grid gap-4 md:grid-cols-2">
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">Slug</span>
                  <input value={draft.slug || ''} onChange={(event) => setDraft((current) => ({...current, slug: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'الاسم' : 'Name'}</span>
                  <input value={draft.name || ''} onChange={(event) => setDraft((current) => ({...current, name: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'المنطقة' : 'Region'}</span>
                  <input value={draft.region || ''} onChange={(event) => setDraft((current) => ({...current, region: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm">
                  <span className="font-bold text-slate-700">{isAr ? 'الصعوبة' : 'Difficulty'}</span>
                  <input value={draft.difficulty || ''} onChange={(event) => setDraft((current) => ({...current, difficulty: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm md:col-span-2">
                  <span className="font-bold text-slate-700">{isAr ? 'الوصف' : 'Description'}</span>
                  <textarea value={draft.description || ''} onChange={(event) => setDraft((current) => ({...current, description: event.target.value}))} rows={4} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm md:col-span-2">
                  <span className="font-bold text-slate-700">{isAr ? 'رابط الفيديو' : 'Video URL'}</span>
                  <input value={draft.video_url || ''} onChange={(event) => setDraft((current) => ({...current, video_url: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
                <label className="space-y-2 text-sm md:col-span-2">
                  <span className="font-bold text-slate-700">{isAr ? 'مسار الصورة' : 'Thumbnail path'}</span>
                  <input value={draft.thumbnail_path || ''} onChange={(event) => setDraft((current) => ({...current, thumbnail_path: event.target.value}))} className="w-full rounded-2xl border border-slate-200 px-4 py-3" />
                </label>
              </div>

              <div className="mt-6 flex flex-wrap gap-3">
                <button type="button" onClick={() => void handleSave()} disabled={saving} className="rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white disabled:opacity-60">
                  {saving ? (isAr ? 'جار الحفظ...' : 'Saving...') : isAr ? 'حفظ' : 'Save'}
                </button>
                {selectedItem ? (
                  <button type="button" onClick={() => void handleDelete()} disabled={saving} className="rounded-2xl border border-rose-200 px-4 py-3 text-sm font-bold text-rose-600 disabled:opacity-60">
                    {isAr ? 'حذف' : 'Delete'}
                  </button>
                ) : null}
              </div>

              {notice ? <p role="status" aria-live="polite" className="mt-4 text-sm text-slate-600">{notice}</p> : null}
            </div>
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
