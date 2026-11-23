import {ArrowRightLeft, ChevronRight, Layers3} from 'lucide-react';
import {Link} from 'react-router-dom';

import {TrainingSystemCard} from '../components/common/exercise-finder/TrainingSystemCard';
import {SYSTEM_DETAIL_CONTENT} from '../components/common/exercise-finder/content';
import {TRAINING_SYSTEMS} from '../components/common/exercise-finder/data/training-systems';
import Seo from '../components/seo/Seo';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';

export default function ExerciseSystemsPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const canonicalPath = '/exercises/systems';

  return (
    <PageLayout title={isAr ? 'أنظمة التمارين' : 'Training Systems'}>
      <Seo
        title={isAr ? 'أنظمة التمارين | مقارنة التقسيمات والخطط الأسبوعية' : 'Training systems | Compare workout splits and weekly plans'}
        description={isAr ? 'قارن بين أنظمة التمارين المختلفة، وافتح صفحة كل نظام لمعرفة الشرح الكامل والخطة الأسبوعية والتمارين المرتبطة.' : 'Compare training systems, then open each system page for the full explanation, weekly structure, and linked exercise pages.'}
        canonicalPath={canonicalPath}
        hreflangs={buildHreflangs(canonicalPath)}
      />

      <div className="not-prose space-y-8">
        <nav aria-label="Breadcrumb" className="flex flex-wrap items-center gap-2 text-sm text-slate-500">
          <Link to={`/${lang}/`} className="hover:text-health-green">{isAr ? 'الرئيسية' : 'Home'}</Link>
          <ChevronRight className="h-4 w-4" />
          <Link to={navigationPaths.exercises(lang)} className="hover:text-health-green">{isAr ? 'التمارين' : 'Exercises'}</Link>
          <ChevronRight className="h-4 w-4" />
          <span className="font-semibold text-slate-900 dark:text-white">{isAr ? 'الأنظمة' : 'Systems'}</span>
        </nav>

        <section className="rounded-[2rem] border border-slate-200 dark:border-slate-700 bg-[linear-gradient(140deg,#ffffff,#eefbf7)] p-6 sm:p-8">
          <div className="max-w-3xl space-y-4">
            <div className="inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green-dark">
              <Layers3 className="h-4 w-4" />
              <span>{isAr ? 'مركز الأنظمة' : 'Systems hub'}</span>
            </div>
            <p className="text-base leading-8 text-slate-700 dark:text-slate-200">
              {isAr
                ? 'هنا ستجد كل أنظمة التمارين مفصولة بوضوح: لكل نظام صفحة مستقلة فيها الفكرة العامة، الفرق بينه وبين غيره، الخطة الأسبوعية المقترحة، وروابط مباشرة لصفحات التمارين الخاصة بالمناطق العضلية.'
                : 'This hub separates each workout system into its own page with a full explanation, direct comparisons, linked weekly planning, and connected exercise-region pages.'}
            </p>
          </div>
        </section>

        <section className="grid gap-4 lg:grid-cols-2">
          {TRAINING_SYSTEMS.map((system) => (
            <div key={system.id} className="space-y-4 rounded-[1.8rem] border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-4 shadow-sm sm:p-5">
              <TrainingSystemCard system={system} isAr={isAr} />
              <div className="rounded-2xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 p-4">
                <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                  <ArrowRightLeft className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'الخلاصة السريعة' : 'Quick comparison summary'}</span>
                </div>
                <p className="mt-2 text-sm leading-7 text-slate-700 dark:text-slate-200">
                  {isAr ? SYSTEM_DETAIL_CONTENT[system.id].overviewAr : SYSTEM_DETAIL_CONTENT[system.id].overviewEn}
                </p>
              </div>
              <Link
                to={navigationPaths.exerciseSystemDetail(lang, system.id)}
                className="inline-flex items-center gap-2 text-sm font-semibold text-health-green transition hover:text-health-green-dark"
              >
                <span>{isAr ? 'افتح صفحة النظام الكاملة' : 'Open full system page'}</span>
                <ChevronRight className="h-4 w-4" />
              </Link>
            </div>
          ))}
        </section>
      </div>
    </PageLayout>
  );
}
