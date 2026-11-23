import {useEffect, useMemo, useState} from 'react';
import {ImagePlus, RefreshCw, Trash2, UploadCloud} from 'lucide-react';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import Seo from '../components/seo/Seo';
import useAdminAccess from '../hooks/useAdminAccess';
import {
  deleteMediaAsset,
  listMediaAssets,
  listMediaAssetUsages,
  refreshMediaAssetUsages,
  updateMediaAsset,
  uploadMediaAsset,
  type MediaAssetRow,
  type MediaAssetUsageRow,
} from '../services/mediaAdmin';
import usePreferredLang from './usePreferredLang';

export default function AdminMediaPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const [assets, setAssets] = useState<MediaAssetRow[]>([]);
  const [usages, setUsages] = useState<MediaAssetUsageRow[]>([]);
  const [selectedId, setSelectedId] = useState<string>('');
  const [search, setSearch] = useState('');
  const [folder, setFolder] = useState('articles');
  const [altText, setAltText] = useState('');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [message, setMessage] = useState('');
  const [showUnusedOnly, setShowUnusedOnly] = useState(false);

  useEffect(() => {
    if (!access.canManageMedia) {
      setLoading(false);
      return;
    }

    let active = true;

    const load = async () => {
      try {
        setLoading(true);
        const [nextAssets, nextUsages] = await Promise.all([listMediaAssets(), listMediaAssetUsages()]);
        if (!active) return;
        setAssets(nextAssets);
        setUsages(nextUsages);
        setSelectedId((current) => current || nextAssets[0]?.id || '');
      } catch (error) {
        if (!active) return;
        setMessage(error instanceof Error ? error.message : isAr ? 'تعذر تحميل الوسائط.' : 'Could not load media assets.');
      } finally {
        if (active) setLoading(false);
      }
    };

    void load();
    return () => {
      active = false;
    };
  }, [access.canManageMedia, isAr]);

  const usageMap = useMemo(() => {
    const map = new Map<string, MediaAssetUsageRow[]>();
    for (const usage of usages) {
      map.set(usage.asset_id, [...(map.get(usage.asset_id) || []), usage]);
    }
    return map;
  }, [usages]);

  const filteredAssets = useMemo(() => {
    const query = search.trim().toLowerCase();
    return assets.filter((asset) => {
      const matchesSearch =
        !query ||
        [asset.file_name, asset.folder || '', asset.alt_text || '', asset.storage_path]
          .join(' ')
          .toLowerCase()
          .includes(query);
      const usageCount = usageMap.get(asset.id)?.length || 0;
      const matchesUsage = !showUnusedOnly || usageCount === 0;
      return matchesSearch && matchesUsage;
    });
  }, [assets, search, showUnusedOnly, usageMap]);

  const selectedAsset = filteredAssets.find((asset) => asset.id === selectedId) ?? filteredAssets[0] ?? null;
  const selectedUsages = selectedAsset ? usageMap.get(selectedAsset.id) || [] : [];

  const handleUpload = async () => {
    if (!selectedFile) {
      setMessage(isAr ? 'اختر صورة أولًا.' : 'Choose an image first.');
      return;
    }

    try {
      setUploading(true);
      const uploaded = await uploadMediaAsset(selectedFile, {folder, altText});
      setAssets((current) => [uploaded, ...current]);
      setSelectedId(uploaded.id);
      setSelectedFile(null);
      setAltText('');
      setMessage(isAr ? 'تم رفع الصورة وحفظ بياناتها.' : 'Image uploaded and indexed successfully.');
    } catch (error) {
      setMessage(error instanceof Error ? error.message : isAr ? 'فشل رفع الصورة.' : 'Image upload failed.');
    } finally {
      setUploading(false);
    }
  };

  const handleSyncUsages = async () => {
    try {
      setSyncing(true);
      const nextUsages = await refreshMediaAssetUsages();
      setUsages(nextUsages);
      setMessage(isAr ? 'تم تحديث مراجع المحتوى للوسائط.' : 'Content references were refreshed.');
    } catch (error) {
      setMessage(error instanceof Error ? error.message : isAr ? 'تعذر تحديث المراجع.' : 'Could not refresh asset references.');
    } finally {
      setSyncing(false);
    }
  };

  const handleSaveMetadata = async () => {
    if (!selectedAsset) return;

    try {
      const updated = await updateMediaAsset(selectedAsset.id, {
        alt_text: selectedAsset.alt_text,
        folder: selectedAsset.folder,
      });
      setAssets((current) => current.map((asset) => (asset.id === updated.id ? updated : asset)));
      setMessage(isAr ? 'تم حفظ بيانات الصورة.' : 'Asset metadata saved.');
    } catch (error) {
      setMessage(error instanceof Error ? error.message : isAr ? 'تعذر حفظ البيانات.' : 'Could not save asset metadata.');
    }
  };

  const handleDelete = async () => {
    if (!selectedAsset) return;

    const confirmed = window.confirm(
      isAr ? `حذف الملف ${selectedAsset.file_name}؟` : `Delete asset ${selectedAsset.file_name}?`,
    );
    if (!confirmed) return;

    try {
      await deleteMediaAsset(selectedAsset.id);
      const nextAssets = assets.filter((asset) => asset.id !== selectedAsset.id);
      setAssets(nextAssets);
      setSelectedId(nextAssets[0]?.id || '');
      setMessage(isAr ? 'تم حذف الملف.' : 'Asset deleted.');
    } catch (error) {
      setMessage(error instanceof Error ? error.message : isAr ? 'تعذر حذف الملف.' : 'Could not delete the asset.');
    }
  };

  return (
    <>
      <Seo
        title={isAr ? 'إدارة الوسائط' : 'Media Library'}
        description={isAr ? 'رفع الصور، تنظيمها، وتتبع استخدامها داخل المحتوى.' : 'Upload, organize, and track images used across content.'}
        canonicalPath="/admin/media"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'إدارة الوسائط' : 'Media Library'}
        canonicalPath="/admin/media"
        requiredPermission="media"
      >
        <AdminShell
          title={isAr ? 'وسائط المحتوى والتشغيل' : 'Content and operations media'}
          description={
            isAr
              ? 'ارفع صور المقالات والتمارين، نظّمها داخل folders ثابتة، وراجع أين تُستخدم قبل الحذف.'
              : 'Upload article and exercise images, keep them in stable folders, and review usage references before deletion.'
          }
          currentTab="media"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
          canManageMedia={access.canManageMedia}
        >
          <div className="space-y-6">
            <div className="grid min-w-0 gap-6 xl:grid-cols-[360px,minmax(0,1fr)]">
              <section className="rounded-3xl border border-slate-200 bg-white p-5">
                <div className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
                  <UploadCloud className="h-5 w-5 text-health-green" />
                  {isAr ? 'رفع أصل جديد' : 'Upload new asset'}
                </div>
                <div className="space-y-4">
                  <label className="block space-y-2 text-sm font-bold text-slate-700">
                    <span>{isAr ? 'الصورة' : 'Image file'}</span>
                    <input type="file" accept="image/*" onChange={(event) => setSelectedFile(event.target.files?.[0] || null)} className="min-w-0 w-full rounded-2xl border border-slate-300 px-2 py-3 text-xs" />
                  </label>
                  <label className="block space-y-2 text-sm font-bold text-slate-700">
                    <span>{isAr ? 'المجلد' : 'Folder'}</span>
                    <input value={folder} onChange={(event) => setFolder(event.target.value)} placeholder="articles/hero" className="w-full rounded-2xl border border-slate-300 px-4 py-3 outline-none focus:border-health-green" />
                  </label>
                  <label className="block space-y-2 text-sm font-bold text-slate-700">
                    <span>{isAr ? 'النص البديل' : 'Alt text'}</span>
                    <textarea value={altText} onChange={(event) => setAltText(event.target.value)} rows={3} className="w-full rounded-2xl border border-slate-300 px-4 py-3 outline-none focus:border-health-green" />
                  </label>
                  <button type="button" onClick={() => void handleUpload()} disabled={uploading} className="w-full rounded-2xl bg-health-green px-5 py-3 font-bold text-white disabled:opacity-60">
                    <ImagePlus className="mr-2 inline h-4 w-4" />
                    {uploading ? (isAr ? 'جار الرفع...' : 'Uploading...') : isAr ? 'رفع وحفظ الأصل' : 'Upload and index asset'}
                  </button>
                  <p className="text-xs leading-6 text-slate-500">
                    {isAr
                      ? 'الرفع يطبّق ضغطًا خفيفًا، ينشئ thumbnail، ويحفظ blur placeholder من المتصفح قبل التخزين.'
                      : 'Uploads apply light compression, generate a thumbnail, and save a blur placeholder in-browser before storage.'}
                  </p>
                </div>
              </section>

              <section className="min-w-0 space-y-4 rounded-3xl border border-slate-200 bg-white p-5">
                <div className="flex flex-wrap items-center gap-3">
                  <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder={isAr ? 'ابحث بالاسم أو المجلد...' : 'Search by file or folder...'} className="min-w-0 w-full flex-1 rounded-2xl border border-slate-300 px-4 py-3 outline-none focus:border-health-green" />
                  <label className="inline-flex items-center gap-2 rounded-2xl border border-slate-300 px-4 py-3 text-sm font-bold text-slate-700">
                    <input type="checkbox" checked={showUnusedOnly} onChange={(event) => setShowUnusedOnly(event.target.checked)} />
                    <span>{isAr ? 'غير المستخدم فقط' : 'Unused only'}</span>
                  </label>
                  <button type="button" onClick={() => void handleSyncUsages()} disabled={syncing} className="rounded-2xl border border-slate-300 px-4 py-3 text-sm font-bold text-slate-700 disabled:opacity-60">
                    <RefreshCw className={`mr-2 inline h-4 w-4 ${syncing ? 'animate-spin' : ''}`} />
                    {isAr ? 'تحديث المراجع' : 'Refresh references'}
                  </button>
                </div>

                {message ? <div className="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-700">{message}</div> : null}

                <div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_320px]">
                  <div className="min-w-0 space-y-3">
                    {loading ? (
                      <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-500">{isAr ? 'جار تحميل المكتبة...' : 'Loading media library...'}</div>
                    ) : filteredAssets.length ? (
                      filteredAssets.map((asset) => {
                        const usageCount = usageMap.get(asset.id)?.length || 0;
                        return (
                          <button key={asset.id} type="button" onClick={() => setSelectedId(asset.id)} className={`grid w-full gap-4 rounded-3xl border p-4 text-start md:grid-cols-[120px,minmax(0,1fr)] ${selectedAsset?.id === asset.id ? 'border-health-green bg-emerald-50/40' : 'border-slate-200 bg-slate-50/60'}`}>
                            <img src={asset.public_url} alt={asset.alt_text || asset.file_name} className="h-28 w-full rounded-2xl object-cover" />
                            <div className="space-y-2">
                              <div className="flex flex-wrap items-center justify-between gap-2">
                                <div className="break-all font-bold text-slate-900">{asset.file_name}</div>
                                <div className="rounded-full bg-slate-100 px-2 py-1 text-[11px] font-bold uppercase tracking-wide text-slate-600">{asset.processing_status}</div>
                              </div>
                              <div className="break-all text-xs text-slate-500">{asset.folder || 'uploads'}</div>
                              <div className="text-sm text-slate-600">{asset.alt_text || (isAr ? 'بدون Alt Text' : 'No alt text yet')}</div>
                              <div className="text-xs text-slate-400">
                                {asset.width || '-'} x {asset.height || '-'} • {Math.round(asset.file_size / 1024)} KB • {usageCount} {isAr ? 'استخدام' : 'usages'}
                              </div>
                            </div>
                          </button>
                        );
                      })
                    ) : (
                      <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-500">{isAr ? 'لا توجد ملفات مطابقة.' : 'No matching assets found.'}</div>
                    )}
                  </div>

                  <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                    {selectedAsset ? (
                      <div className="space-y-4">
                        <img src={selectedAsset.public_url} alt={selectedAsset.alt_text || selectedAsset.file_name} className="h-48 w-full rounded-2xl object-cover" />
                        <label className="block space-y-2 text-sm font-bold text-slate-700">
                          <span>{isAr ? 'المجلد' : 'Folder'}</span>
                          <input value={selectedAsset.folder || ''} onChange={(event) => setAssets((current) => current.map((asset) => (asset.id === selectedAsset.id ? {...asset, folder: event.target.value} : asset)))} className="w-full rounded-2xl border border-slate-300 px-4 py-3 outline-none focus:border-health-green" />
                        </label>
                        <label className="block space-y-2 text-sm font-bold text-slate-700">
                          <span>{isAr ? 'النص البديل' : 'Alt text'}</span>
                          <textarea value={selectedAsset.alt_text || ''} onChange={(event) => setAssets((current) => current.map((asset) => (asset.id === selectedAsset.id ? {...asset, alt_text: event.target.value} : asset)))} rows={3} className="w-full rounded-2xl border border-slate-300 px-4 py-3 outline-none focus:border-health-green" />
                        </label>
                        <div className="grid gap-2 text-xs text-slate-500">
                          <div>{selectedAsset.public_url}</div>
                          <div>{selectedAsset.storage_path}</div>
                        </div>
                        <div className="flex flex-wrap gap-2">
                          <button type="button" onClick={() => void handleSaveMetadata()} className="rounded-2xl bg-slate-900 px-4 py-3 text-sm font-bold text-white">
                            {isAr ? 'حفظ البيانات' : 'Save metadata'}
                          </button>
                          <button type="button" onClick={() => void handleDelete()} className="rounded-2xl border border-rose-200 px-4 py-3 text-sm font-bold text-rose-600">
                            <Trash2 className="mr-2 inline h-4 w-4" />
                            {isAr ? 'حذف' : 'Delete'}
                          </button>
                        </div>

                        <div className="rounded-2xl border border-slate-200 bg-white p-4">
                          <div className="mb-2 font-bold text-slate-900">{isAr ? 'أماكن الاستخدام' : 'Usage references'}</div>
                          {selectedUsages.length ? (
                            <div className="space-y-2">
                              {selectedUsages.map((usage) => (
                                <div key={usage.id} className="rounded-2xl border border-slate-200 p-3 text-sm text-slate-600">
                                  <div className="font-bold text-slate-900">{usage.content_type}</div>
                                  <div>{usage.content_key}</div>
                                  <div className="text-xs text-slate-400">{usage.field_name}</div>
                                </div>
                              ))}
                            </div>
                          ) : (
                            <div className="text-sm text-slate-500">{isAr ? 'غير مستخدم حاليًا.' : 'Currently unused.'}</div>
                          )}
                        </div>
                      </div>
                    ) : (
                      <div className="text-sm text-slate-500">{isAr ? 'اختر ملفًا لعرض تفاصيله.' : 'Select an asset to view details.'}</div>
                    )}
                  </div>
                </div>
              </section>
            </div>
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
