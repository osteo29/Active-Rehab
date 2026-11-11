import {FileText, Home, Image, Search, Stethoscope, UploadCloud, Users} from 'lucide-react';
import {Link} from 'react-router-dom';
import Seo from '../components/seo/Seo';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import useAdminAccess from '../hooks/useAdminAccess';
import usePreferredLang from './usePreferredLang';
import {navigationPaths} from '../utils/langUrlHelper';

export default function AdminContentPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);

  const modules = [
    {
      key: 'articles',
      title: isAr ? 'المقالات' : 'Articles',
      description: isAr ? 'إدارة المحتوى التحريري وربط الترجمات وعمليات النشر.' : 'Manage editorial content, translations, and publishing.',
      icon: FileText,
      to: navigationPaths.adminArticles(uiLang),
      enabled: access.canManageArticles,
      status: isAr ? 'جاهز الآن' : 'Available now',
    },
    {
      key: 'injuries',
      title: isAr ? 'الإصابات' : 'Injuries',
      description: isAr ? 'تحرير بروتوكولات الإصابات والمراحل والمحتوى الطبي.' : 'Edit injury protocols, phases, and medical content.',
      icon: Stethoscope,
      to: navigationPaths.adminInjuries(uiLang),
      enabled: access.canManageInjuries,
      status: isAr ? 'جاهز الآن' : 'Available now',
    },
    {
      key: 'exercises',
      title: isAr ? 'التمارين' : 'Exercises',
      description: isAr ? 'إدارة مكتبة التمارين والصور وروابط الفيديو.' : 'Manage exercise library items, media paths, and video links.',
      icon: Image,
      to: navigationPaths.adminExercises(uiLang),
      enabled: access.canManageExercises,
      status: isAr ? 'جديد' : 'New',
    },
    {
      key: 'homepage',
      title: isAr ? 'الصفحة الرئيسية' : 'Homepage',
      description: isAr ? 'تحكم محدود في الـ hero والعناصر المميزة والبنرات.' : 'Limited control over hero copy, featured items, and banners.',
      icon: Home,
      to: navigationPaths.adminHomepage(uiLang),
      enabled: access.canManageHomepage,
      status: isAr ? 'جديد' : 'New',
    },
    {
      key: 'media',
      title: isAr ? 'الوسائط' : 'Media',
      description: isAr ? 'رفع الصور، تنظيمها، ومتابعة مواضع استخدامها في المحتوى.' : 'Upload images, organize them, and track where they are used in content.',
      icon: UploadCloud,
      to: navigationPaths.adminMedia(uiLang),
      enabled: access.canManageMedia,
      status: isAr ? 'جديد' : 'New',
    },
    {
      key: 'seo',
      title: isAr ? 'SEO' : 'SEO',
      description: isAr ? 'تحرير البيانات الوصفية المركزية وربط صفحات السيو.' : 'Edit central metadata and SEO page overrides.',
      icon: Search,
      to: navigationPaths.adminSeo(uiLang),
      enabled: access.canManageSeo,
      status: isAr ? 'جاهز الآن' : 'Available now',
    },
    {
      key: 'users',
      title: isAr ? 'الأدوار والمستخدمون' : 'Roles and users',
      description: isAr ? 'إدارة أدوار Admin / Editor / Writer وصلاحيات التشغيل.' : 'Manage Admin / Editor / Writer roles and operations permissions.',
      icon: Users,
      to: navigationPaths.adminUsers(uiLang),
      enabled: access.canManageUsers,
      status: isAr ? 'جديد' : 'New',
    },
  ];

  return (
    <>
      <Seo
        title={isAr ? 'إدارة المحتوى' : 'Content CMS'}
        description={isAr ? 'بوابة إدارة المحتوى والتشغيل داخل لوحة الأدمن.' : 'Content and operations CMS inside the admin workspace.'}
        canonicalPath="/admin/content"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'إدارة المحتوى' : 'Content CMS'}
        canonicalPath="/admin/content"
      >
        <AdminShell
          title={isAr ? 'محتوى وتشغيل بدون UI builder' : 'Content and operations without a UI builder'}
          description={
            isAr
              ? 'هذه المساحة تحافظ على التصميم ثابتًا، وتفتح فقط إدارة المحتوى والتشغيل: المقالات، الإصابات، التمارين، SEO، والصفحة الرئيسية.'
              : 'This workspace keeps the design system fixed and opens only content and operations management: articles, injuries, exercises, SEO, and homepage controls.'
          }
          currentTab="content"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageMedia={access.canManageMedia}
          canManageUsers={access.canManageUsers}
        >
          <div className="grid gap-4 lg:grid-cols-2">
            {modules.map((module) => {
              const Icon = module.icon;
              return (
                <div key={module.key} className="rounded-3xl border border-slate-200 bg-white p-5">
                  <div className="flex items-start justify-between gap-3">
                    <div className="space-y-2">
                      <div className="inline-flex items-center gap-2 rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-health-green">
                        <Icon className="h-4 w-4" />
                        <span>{module.status}</span>
                      </div>
                      <h3 className="text-xl font-black text-slate-900">{module.title}</h3>
                      <p className="text-sm leading-7 text-slate-600">{module.description}</p>
                    </div>
                  </div>
                  <div className="mt-4">
                    {module.enabled ? (
                      <Link
                        to={module.to}
                        className="inline-flex rounded-2xl border border-slate-200 bg-slate-50 px-4 py-2 text-sm font-bold text-slate-900 transition hover:border-health-green hover:text-health-green"
                      >
                        {isAr ? 'فتح الوحدة' : 'Open module'}
                      </Link>
                    ) : (
                      <div className="text-sm font-medium text-slate-400">{isAr ? 'غير متاح لهذا الدور' : 'Not available for this role'}</div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
