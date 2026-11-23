import type {ReactNode} from 'react';
import type {User} from '@supabase/supabase-js';
import {
  Activity,
  FileText,
  FolderKanban,
  Home,
  Image,
  Search,
  ShieldCheck,
  Stethoscope,
  UserCog,
} from 'lucide-react';
import {Link, useLocation} from 'react-router-dom';
import PageLayout from '../../pages/PageLayout';
import usePreferredLang from '../../pages/usePreferredLang';
import {navigationPaths} from '../../utils/langUrlHelper';

type AdminTab =
  | 'dashboard'
  | 'content'
  | 'homepage'
  | 'injuries'
  | 'articles'
  | 'exercises'
  | 'media'
  | 'seo'
  | 'users';

function shellCopy(lang: 'en' | 'ar') {
  return {
    workspace: lang === 'ar' ? 'مساحة الإدارة' : 'Admin Workspace',
    dashboard: lang === 'ar' ? 'نظرة عامة' : 'Overview',
    content: lang === 'ar' ? 'المحتوى' : 'Content',
    homepage: lang === 'ar' ? 'الصفحة الرئيسية' : 'Homepage',
    injuries: lang === 'ar' ? 'الإصابات' : 'Injuries',
    articles: lang === 'ar' ? 'المقالات' : 'Articles',
    exercises: lang === 'ar' ? 'التمارين' : 'Exercises',
    seo: lang === 'ar' ? 'SEO' : 'SEO',
    users: lang === 'ar' ? 'المستخدمون' : 'Users',
    account: lang === 'ar' ? 'الحساب الحالي' : 'Current account',
    capabilities: lang === 'ar' ? 'الصلاحيات' : 'Permissions',
    articleAdmin: lang === 'ar' ? 'إدارة المقالات' : 'Article management',
    injuryAdmin: lang === 'ar' ? 'إدارة الإصابات' : 'Injury management',
    homepageAdmin: lang === 'ar' ? 'إدارة الصفحة الرئيسية' : 'Homepage management',
    exercisesAdmin: lang === 'ar' ? 'إدارة التمارين' : 'Exercise management',
    usersAdmin: lang === 'ar' ? 'إدارة المستخدمين' : 'User management',
    connected: lang === 'ar' ? 'متصل بسوبابيز' : 'Connected to Supabase',
    quickLinks: lang === 'ar' ? 'روابط سريعة' : 'Quick links',
    publicSite: lang === 'ar' ? 'الموقع العام' : 'Public site',
    protocols: lang === 'ar' ? 'بروتوكولات الإصابات' : 'Injury protocols',
    insights: lang === 'ar' ? 'صفحة المقالات' : 'Insights page',
    media: lang === 'ar' ? 'الوسائط' : 'Media',
    role: lang === 'ar' ? 'الدور' : 'Role',
  };
}

export default function AdminShell({
  title,
  description,
  currentTab,
  user,
  adminRole,
  canManageInjuries,
  canManageArticles,
  canManageSeo,
  canManageHomepage,
  canManageExercises,
  canManageMedia,
  canManageUsers,
  children,
}: {
  title: string;
  description: string;
  currentTab: AdminTab;
  user: User | null;
  adminRole: string;
  canManageInjuries: boolean;
  canManageArticles: boolean;
  canManageSeo: boolean;
  canManageHomepage: boolean;
  canManageExercises: boolean;
  canManageMedia?: boolean;
  canManageUsers: boolean;
  children: ReactNode;
}) {
  const lang = usePreferredLang();
  const copy = shellCopy(lang);
  const location = useLocation();
  const resolvedCanManageMedia =
    typeof canManageMedia === 'boolean'
      ? canManageMedia
      : canManageArticles || canManageExercises || canManageHomepage || canManageInjuries;

  const items = [
    {
      key: 'dashboard',
      label: copy.dashboard,
      icon: Activity,
      to: navigationPaths.adminHome(lang),
      enabled: true,
    },
    {
      key: 'content',
      label: copy.content,
      icon: FolderKanban,
      to: navigationPaths.adminContent(lang),
      enabled: canManageArticles || canManageInjuries || canManageExercises,
    },
    {
      key: 'homepage',
      label: copy.homepage,
      icon: Home,
      to: navigationPaths.adminHomepage(lang),
      enabled: canManageHomepage,
    },
    {
      key: 'articles',
      label: copy.articles,
      icon: FileText,
      to: navigationPaths.adminArticles(lang),
      enabled: canManageArticles,
    },
    {
      key: 'injuries',
      label: copy.injuries,
      icon: Stethoscope,
      to: navigationPaths.adminInjuries(lang),
      enabled: canManageInjuries,
    },
    {
      key: 'exercises',
      label: copy.exercises,
      icon: Image,
      to: navigationPaths.adminExercises(lang),
      enabled: canManageExercises,
    },
    {
      key: 'media',
      label: copy.media,
      icon: Image,
      to: navigationPaths.adminMedia(lang),
      enabled: resolvedCanManageMedia,
    },
    {
      key: 'seo',
      label: copy.seo,
      icon: Search,
      to: navigationPaths.adminSeo(lang),
      enabled: canManageSeo,
    },
    {
      key: 'users',
      label: copy.users,
      icon: UserCog,
      to: navigationPaths.adminUsers(lang),
      enabled: canManageUsers,
    },
  ] as const;

  return (
    <PageLayout title={copy.workspace}>
      <div className="space-y-6">
        <section className="rounded-3xl border border-slate-200 bg-slate-50 p-6">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div className="space-y-2">
              <div className="text-xs font-black uppercase tracking-[0.24em] text-health-green">{copy.workspace}</div>
              <h2 className="text-2xl font-black text-slate-900">{title}</h2>
              <p className="max-w-3xl text-sm leading-7 text-slate-600">{description}</p>
            </div>
            <div className="rounded-2xl border border-emerald-200 bg-white px-4 py-3 text-sm text-slate-700">
              <div className="font-bold text-slate-900">{copy.account}</div>
              <div className="break-all" dir="ltr">{user?.email || 'unknown'}</div>
              <div className="mt-1 text-xs uppercase tracking-[0.18em] text-slate-400">
                {copy.role}: {adminRole}
              </div>
            </div>
          </div>
        </section>

        <div className="grid gap-6 xl:grid-cols-[280px,minmax(0,1fr)]">
          <aside className="space-y-4 rounded-3xl border border-slate-200 bg-white p-5">
            <div>
              <div className="text-xs font-black uppercase tracking-[0.18em] text-slate-400">{copy.workspace}</div>
              <nav aria-label={lang === 'ar' ? 'أقسام الإدارة' : 'Admin sections'} className="mt-4 grid grid-cols-2 gap-2 sm:grid-cols-3 xl:grid-cols-1">
                {items.map((item) => {
                  const Icon = item.icon;
                  const active = currentTab === item.key || location.pathname === item.to;
                  const classes = active
                    ? 'border-health-green bg-emerald-50 text-health-green'
                    : 'border-slate-200 bg-slate-50 text-slate-700 hover:border-slate-300';

                  if (!item.enabled) {
                    return (
                      <div
                        key={item.key}
                        className="rounded-2xl border border-dashed border-slate-200 px-4 py-3 text-sm text-slate-400"
                      >
                        <Icon className="me-2 inline h-4 w-4" />
                        {item.label}
                      </div>
                    );
                  }

                  return (
                    <Link
                      key={item.key}
                      to={item.to}
                      aria-current={active ? 'page' : undefined}
                      className={`block rounded-2xl border px-4 py-3 text-sm font-bold transition ${classes}`}
                    >
                      <Icon className="me-2 inline h-4 w-4" />
                      {item.label}
                    </Link>
                  );
                })}
              </nav>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-700">
              <div className="mb-3 flex items-center gap-2 font-bold text-slate-900">
                <ShieldCheck className="h-4 w-4 text-health-green" />
                {copy.capabilities}
              </div>
              <div>{copy.connected}</div>
              <div>
                {copy.articleAdmin}: {canManageArticles ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
              <div>
                {copy.injuryAdmin}: {canManageInjuries ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
              <div>
                {copy.homepageAdmin}: {canManageHomepage ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
              <div>
                {copy.exercisesAdmin}: {canManageExercises ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
              <div>
                {copy.media}: {resolvedCanManageMedia ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
              <div>
                {copy.usersAdmin}: {canManageUsers ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')}
              </div>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-700">
              <div className="mb-3 font-bold text-slate-900">{copy.quickLinks}</div>
              <div className="space-y-2">
                <Link to={navigationPaths.home(lang)} className="block hover:text-health-green">
                  {copy.publicSite}
                </Link>
                <Link to={navigationPaths.injuries(lang)} className="block hover:text-health-green">
                  {copy.protocols}
                </Link>
                <Link to={navigationPaths.insights(lang)} className="block hover:text-health-green">
                  {copy.insights}
                </Link>
              </div>
            </div>
          </aside>

          <section className="space-y-6">{children}</section>
        </div>
      </div>
    </PageLayout>
  );
}
