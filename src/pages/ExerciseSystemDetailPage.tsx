import {ArrowRight, CalendarRange, ChevronRight, GitCompareArrows, Link2} from 'lucide-react';
import {Link, Navigate, useParams} from 'react-router-dom';

import {WeeklyPlanCard} from '../components/common/exercise-finder/WeeklyPlanCard';
import {
  SYSTEM_DETAIL_CONTENT,
  getRegionsForSystem,
  getSystemById,
  getWeeklyPlanForSystem,
} from '../components/common/exercise-finder/content';
import {Badge} from '../components/common/exercise-finder/FilterField';
import Seo from '../components/seo/Seo';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';

export default function ExerciseSystemDetailPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const {systemId} = useParams<{systemId: string}>();

  if (!systemId) {
    return <Navigate to={navigationPaths.exerciseSystems(lang)} replace />;
  }

  const system = getSystemById(systemId);
  if (!system) {
    return <Navigate to={navigationPaths.exerciseSystems(lang)} replace />;
  }

  const content = SYSTEM_DETAIL_CONTENT[system.id];
  const plan = getWeeklyPlanForSystem(system.id);
  const regions = getRegionsForSystem(system.id);
  const canonicalPath = `/exercises/systems/${system.id}`;

  return (
    <PageLayout title={isAr ? system.titleAr : system.title}>
      <Seo
        title={isAr ? `${system.titleAr} | شرح النظام والخطة الأسبوعية` : `${system.title} | Training system guide and weekly plan`}
        description={isAr ? content.seoSummaryAr : content.seoSummaryEn}
        canonicalPath={canonicalPath}
        hreflangs={buildHreflangs(canonicalPath)}
      />

      <div className="not-prose space-y-8">
        <nav aria-label="Breadcrumb" className="flex flex-wrap items-center gap-2 text-sm text-slate-500">
          <Link to={`/${lang}/`} className="hover:text-health-green">{isAr ? 'الرئيسية' : 'Home'}</Link>
          <ChevronRight className="h-4 w-4" />
          <Link to={navigationPaths.exercises(lang)} className="hover:text-health-green">{isAr ? 'التمارين' : 'Exercises'}</Link>
          <ChevronRight className="h-4 w-4" />
          <Link to={navigationPaths.exerciseSystems(lang)} className="hover:text-health-green">{isAr ? 'الأنظمة' : 'Systems'}</Link>
          <ChevronRight className="h-4 w-4" />
          <span className="font-semibold text-slate-900 dark:text-white">{isAr ? system.titleAr : system.title}</span>
        </nav>

        <section className={`overflow-hidden rounded-[2rem] border p-6 sm:p-8 ${system.accent}`}>
          <div className="grid gap-6 lg:grid-cols-[1.3fr_0.95fr]">
            <div className="space-y-4">
              <div className="inline-flex items-center gap-2 rounded-full border border-white/70 bg-white/70 dark:bg-slate-900/70 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-slate-700 dark:text-slate-200">
                <CalendarRange className="h-4 w-4" />
                <span>{isAr ? 'صفحة نظام' : 'System page'}</span>
              </div>
              <p className="text-base leading-8 text-slate-700 dark:text-slate-200">{isAr ? content.overviewAr : content.overviewEn}</p>
              <div className="flex flex-wrap gap-2">
                <Badge tone="blue">{isAr ? system.frequencyAr : system.frequency}</Badge>
                <Badge>{isAr ? system.splitAr : system.split}</Badge>
                <Badge tone="green">{isAr ? system.idealForAr : system.idealFor}</Badge>
              </div>
            </div>
            <div className="rounded-[1.6rem] border border-white/70 bg-white/75 p-5">
              <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">{isAr ? 'لماذا هذا النظام مفيد؟' : 'Why this system works'}</div>
              <div className="mt-4 space-y-3">
                {(isAr ? content.strengthsAr : content.strengthsEn).map((item) => (
                  <div key={item} className="rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-sm leading-7 text-slate-700 dark:text-slate-200">
                    {item}
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        <section className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
          <article className="rounded-[1.75rem] border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 shadow-sm sm:p-8">
            <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
              <GitCompareArrows className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'المقارنات الأساسية' : 'Key comparisons'}</span>
            </div>
            <div className="mt-4 space-y-3">
              {(isAr ? content.comparisonsAr : content.comparisonsEn).map((item) => (
                <div key={item.label} className="rounded-2xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 p-4">
                  <div className="text-sm font-bold text-slate-900 dark:text-white">{item.label}</div>
                  <p className="mt-2 text-sm leading-7 text-slate-700 dark:text-slate-200">{item.value}</p>
                </div>
              ))}
            </div>
          </article>

          <article className="rounded-[1.75rem] border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 shadow-sm sm:p-8">
            <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
              <Link2 className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'صفحات التمارين المرتبطة' : 'Linked exercise pages'}</span>
            </div>
            <p className="mt-3 text-sm leading-7 text-slate-600 dark:text-slate-300">
              {isAr ? 'كل منطقة هنا لها صفحة منفصلة فيها التشريح المبسط والمكتبة الكاملة للتمارين.' : 'Each region below opens a dedicated page with anatomy notes and the full exercise library.'}
            </p>
            <div className="mt-4 flex flex-wrap gap-3">
              {regions.map((region) => (
                <Link
                  key={region.slug}
                  to={navigationPaths.exercisesMuscle(lang, region.slug)}
                  className="rounded-2xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 px-4 py-2 text-sm font-semibold text-slate-700 dark:text-slate-200 transition hover:border-health-green/30 hover:text-health-green"
                >
                  {isAr ? `تمارين ${region.labelAr}` : `${region.labelEn} exercises`}
                </Link>
              ))}
            </div>
          </article>
        </section>

        {plan ? (
          <section className="space-y-5">
            <div>
              <h2 className="text-2xl font-black text-slate-900 dark:text-white">{isAr ? 'الخطة الأسبوعية المقترحة' : 'Suggested weekly plan'}</h2>
              <p className="mt-2 text-sm leading-7 text-slate-600 dark:text-slate-300">
                {isAr ? 'الخطة هنا مرتبطة مباشرة بتمارين حقيقية داخل مكتبة التمارين، وليس مجرد أسماء عامة.' : 'This weekly plan is tied to real exercises from the exercise library rather than placeholder names.'}
              </p>
            </div>
            <WeeklyPlanCard title={system.title} titleAr={system.titleAr} plan={plan} isAr={isAr} lang={lang} />
          </section>
        ) : null}

        <section className="rounded-[1.75rem] border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 p-6 sm:p-8">
          <div className="flex flex-wrap items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl font-black text-slate-900 dark:text-white">{isAr ? 'التنقل بين الأنظمة والمناطق' : 'Move between systems and regions'}</h2>
              <p className="mt-2 text-sm leading-7 text-slate-600 dark:text-slate-300">
                {isAr ? 'من هنا تقدر ترجع إلى فهرس الأنظمة أو تفتح صفحة التمارين الأساسية لاستكشاف كل المناطق.' : 'Use these links to return to the systems hub or the main exercises hub for broader browsing.'}
              </p>
            </div>
            <div className="flex flex-wrap gap-3">
              <Link to={navigationPaths.exerciseSystems(lang)} className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-2 text-sm font-semibold text-slate-700 dark:text-slate-200 transition hover:border-health-green/30 hover:text-health-green">
                <span>{isAr ? 'كل الأنظمة' : 'All systems'}</span>
                <ArrowRight className="h-4 w-4" />
              </Link>
              <Link to={navigationPaths.exercises(lang)} className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-2 text-sm font-semibold text-slate-700 dark:text-slate-200 transition hover:border-health-green/30 hover:text-health-green">
                <span>{isAr ? 'الصفحة الأساسية للتمارين' : 'Main exercises hub'}</span>
                <ArrowRight className="h-4 w-4" />
              </Link>
            </div>
          </div>
        </section>
      </div>
    </PageLayout>
  );
}
