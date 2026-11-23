import {useEffect, useState} from 'react';
import {BarChart3, ClipboardList, FileText, HeartPulse, Users} from 'lucide-react';
import Seo from '../components/seo/Seo';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import usePreferredLang from './usePreferredLang';
import useAdminAccess from '../hooks/useAdminAccess';
import {fetchAdminDashboardMetrics, type AdminDashboardMetrics} from '../services/adminDashboard';
import {buildInjuryContentReport} from '../services/injuryContentReport';

const initialMetrics: AdminDashboardMetrics = {
  injuries: null,
  phases: null,
  articles: null,
  assessments: null,
  leads: null,
};

export default function AdminDashboardPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const [metrics, setMetrics] = useState<AdminDashboardMetrics>(initialMetrics);
  const [contentReport] = useState(() => buildInjuryContentReport());
  const [loading, setLoading] = useState(true);
  const [errorMessage, setErrorMessage] = useState('');
  const [reloadKey, setReloadKey] = useState(0);

  useEffect(() => {
    if (!access.canAccessAdminArea) {
      setLoading(false);
      return;
    }

    let active = true;

    const load = async () => {
      try {
        setLoading(true);
        const nextMetrics = await fetchAdminDashboardMetrics();
        if (!active) return;
        setMetrics(nextMetrics);
        setErrorMessage(Object.values(nextMetrics).some((value) => value === null)
          ? (isAr ? 'بعض المؤشرات غير متاحة. تحقق من الصلاحيات والاتصال ثم أعد المحاولة.' : 'Some metrics are unavailable. Check permissions and connection, then retry.')
          : '');
      } catch (error) {
        if (!active) return;
        setErrorMessage(
          error instanceof Error
            ? error.message
            : isAr
              ? 'تعذر تحميل مؤشرات الإدارة الآن.'
              : 'Could not load admin metrics right now.',
        );
      } finally {
        if (active) setLoading(false);
      }
    };

    void load();

    return () => {
      active = false;
    };
  }, [access.canAccessAdminArea, isAr, reloadKey]);

  const cards = [
    {
      key: 'injuries',
      label: isAr ? 'الإصابات' : 'Injuries',
      value: metrics.injuries,
      icon: HeartPulse,
    },
    {
      key: 'phases',
      label: isAr ? 'المراحل' : 'Phases',
      value: metrics.phases,
      icon: BarChart3,
    },
    {
      key: 'articles',
      label: isAr ? 'المقالات' : 'Articles',
      value: metrics.articles,
      icon: FileText,
    },
    {
      key: 'assessments',
      label: isAr ? 'نتائج المتابعة' : 'Assessments',
      value: metrics.assessments,
      icon: ClipboardList,
    },
    {
      key: 'leads',
      label: isAr ? 'الطلبات الجديدة' : 'Leads',
      value: metrics.leads,
      icon: Users,
    },
  ];

  return (
    <>
      <Seo
        title={isAr ? 'لوحة إدارة النظام' : 'Admin Dashboard'}
        description={
          isAr
            ? 'لوحة إدارة موحدة لمراجعة المحتوى والبيانات داخل Supabase.'
            : 'Unified admin workspace for content and data connected to Supabase.'
        }
        canonicalPath="/admin"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'لوحة إدارة النظام' : 'Admin Dashboard'}
        canonicalPath="/admin"
      >
        <AdminShell
          title={isAr ? 'نظرة عامة على الإدارة' : 'Operational overview'}
          description={
            isAr
              ? 'هذه الصفحة تجمع أهم مؤشرات المحتوى والبيانات في مكان واحد، مع روابط مباشرة لتحرير الإصابات والمقالات.'
              : 'This page brings the main content and data indicators into one organized workspace with direct paths to injuries and articles.'
          }
          currentTab="dashboard"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
        >
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {cards.map((card) => {
              const Icon = card.icon;
              return (
                <div key={card.key} className="rounded-3xl border border-slate-200 bg-white p-5">
                  <div className="flex items-center justify-between gap-3">
                    <div>
                      <div className="text-sm font-bold text-slate-500">{card.label}</div>
                      <div className="mt-2 text-3xl font-black text-slate-900">
                        {loading ? '...' : card.value === null ? (isAr ? 'غير متاح' : 'Unavailable') : card.value}
                      </div>
                    </div>
                    <div className="rounded-2xl bg-emerald-50 p-3 text-health-green">
                      <Icon className="h-5 w-5" />
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          <div className="rounded-3xl border border-slate-200 bg-white p-6">
            <h3 className="text-xl font-black text-slate-900">
              {isAr ? 'حالة الربط' : 'Connection status'}
            </h3>
            <div className="mt-4 space-y-3 text-sm leading-7 text-slate-600">
              <p>
                {isAr
                  ? 'تم توحيد مساحة الإدارة على Supabase session وصلاحيات admin_users مع تمييز منفصل لصلاحيات المقالات.'
                  : 'The admin workspace is now unified around the Supabase session, admin_users permissions, and a separate article-admin capability.'}
              </p>
              <p>
                {isAr
                  ? 'المؤشر غير المتاح لا يعني أن عدد السجلات صفر. قد لا يملك دورك صلاحية قراءة كل الجداول.'
                  : 'An unavailable metric does not mean zero records. Your role may not have read access to every table.'}
              </p>
              {errorMessage ? <p role="alert" className="font-bold text-rose-600">{errorMessage}</p> : null}
              <button type="button" disabled={loading} onClick={() => setReloadKey((value) => value + 1)} className="rounded-xl border border-slate-300 px-4 py-2 font-bold disabled:opacity-50">{isAr ? 'تحديث المؤشرات' : 'Refresh metrics'}</button>
            </div>
          </div>

          <div className="rounded-3xl border border-slate-200 bg-white p-6">
            <div className="flex flex-wrap items-start justify-between gap-4">
              <div>
                <div className="text-xs font-black uppercase tracking-[0.18em] text-health-green">{isAr ? 'تقرير المحتوى' : 'Content report'}</div>
                <h3 className="mt-2 text-xl font-black text-slate-900">{isAr ? 'نواقص مكتبة الإصابات' : 'Injury library gaps'}</h3>
                <p className="mt-2 max-w-3xl text-sm leading-7 text-slate-600">
                  {isAr ? 'تقرير محلي يساعد على مراجعة نواقص المحتوى والتكرار المحتمل وروابط التمارين. هذه مؤشرات للمراجعة، وليست تقييمًا سريريًا لجودة العلاج.' : 'A local report of missing content, possible duplicates and exercise links. These are review prompts, not a clinical assessment of treatment quality.'}
                </p>
              </div>
              <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
                npm run report:injury-content
              </div>
            </div>

            <div className="mt-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
              {[
                [isAr ? 'خطط تغذية مفقودة' : 'Missing nutrition', contentReport.totals.missingNutritionPlans],
                [isAr ? 'بروتوكولات تمارين مفقودة' : 'Missing exercise protocols', contentReport.totals.missingImportedExerciseProtocols],
                [isAr ? 'مجموعات تكرار محتملة' : 'Duplicate groups', contentReport.totals.possibleDuplicateGroups],
                [isAr ? 'مراجع تمارين غير مرتبطة' : 'Unlinked exercise refs', contentReport.totals.unlinkedExercises],
              ].map(([label, value]) => (
                <div key={label} className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                  <div className="text-xs font-bold uppercase tracking-[0.14em] text-slate-400">{label}</div>
                  <div className="mt-2 text-2xl font-black text-slate-900">{value}</div>
                </div>
              ))}
            </div>

            <div className="mt-5 grid gap-4 xl:grid-cols-2">
              <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                <div className="mb-3 text-sm font-black text-slate-900">{isAr ? 'أبرز نواقص المحتوى' : 'Top missing content'}</div>
                <div className="max-h-80 space-y-2 overflow-auto">
                  {contentReport.topMissingContent.slice(0, 10).map((item) => (
                    <div key={item.id} className="rounded-xl bg-white px-3 py-3 text-sm">
                      <div className="font-bold text-slate-900">{item.name}</div>
                      <div className="mt-1 text-xs text-slate-500">{item.id}</div>
                      <div className="mt-2 text-xs leading-5 text-slate-600">{item.reasons.slice(0, 3).join(' | ')}</div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                <div className="mb-3 text-sm font-black text-slate-900">{isAr ? 'بروتوكولات مختصرة' : 'Short protocols'}</div>
                <div className="max-h-80 space-y-2 overflow-auto">
                  {contentReport.shortProtocols.slice(0, 10).map((item) => (
                    <div key={item.id} className="rounded-xl bg-white px-3 py-3 text-sm">
                      <div className="font-bold text-slate-900">{item.name}</div>
                      <div className="mt-1 text-xs text-slate-500">{item.id}</div>
                      <div className="mt-2 text-xs leading-5 text-slate-600">{item.reasons.join(' | ')}</div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
