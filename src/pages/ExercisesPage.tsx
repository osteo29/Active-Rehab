import {Activity, ArrowRight, ChevronRight, Layers3, Network} from 'lucide-react';
import {Link} from 'react-router-dom';

import ExerciseFinder, {
  EXERCISE_FINDER_STATIC_LABELS,
  EXERCISE_FINDER_STATIC_SLUGS,
} from '../components/common/ExerciseFinder';
import {EXERCISE_FINDER_STATIC_ARABIC_LABELS} from '../components/common/exercise-finder/constants';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import {navigationPaths} from '../utils/langUrlHelper';
import type {StaticMuscleSlug} from '../components/common/exercise-finder/types';

const HUB_REGIONS: StaticMuscleSlug[] = ['chest', 'back', 'shoulders', 'arms', 'core', 'legs'];
const REHAB_REGIONS: StaticMuscleSlug[] = ['neck', 'hip', 'wrist-rehab', 'full-body-rehab'];

export default function ExercisesPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const title = isAr ? 'دليل التمارين' : 'Exercise Finder';

  return (
    <PageLayout title={title}>
      <div className="not-prose space-y-8">
        <section className="overflow-hidden rounded-[2rem] border border-slate-200 bg-[radial-gradient(circle_at_top_left,rgba(16,185,129,0.12),transparent_42%),linear-gradient(180deg,#ffffff,#f8fafc)] p-6 sm:p-8">
          <div className="grid gap-6 lg:grid-cols-[1.25fr_0.95fr]">
            <div className="space-y-4">
              <div className="inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green-dark">
                <Layers3 className="h-4 w-4" />
                <span>{isAr ? 'مركز التمارين' : 'Exercises hub'}</span>
              </div>
              <p className="text-base leading-8 text-slate-700">
                {isAr
                  ? 'هذه الصفحة أصبحت البوابة الأساسية لمكتبة التمارين: منها تقدر تتصفح كل التمارين، وتدخل صفحات منفصلة لكل منطقة عضلية، وتفتح صفحة مستقلة لكل نظام تدريبي مع مقارناته وخطته الأسبوعية.'
                  : 'This page is now the main hub for the exercise library. Use it to browse all exercises, jump into dedicated region pages, and open full training-system pages with comparisons and weekly plans.'}
              </p>
            </div>

            <div className="grid gap-3 sm:grid-cols-3">
              <Link to={navigationPaths.anatomy(lang)} className="rounded-[1.6rem] border border-health-green/30 bg-health-green/10 p-5 transition hover:-translate-y-0.5 hover:border-health-green/50">
                <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-health-green-dark">
                  <Activity className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'مكتبة العضلات' : 'Anatomy'}</span>
                </div>
                <div className="mt-3 text-lg font-black text-slate-900">{isAr ? 'التشريح والعضلات' : 'Muscle Anatomy Index'}</div>
                <div className="mt-2 text-sm leading-7 text-slate-700">{isAr ? '107 عضلات موثقة ومربوطة بتمارين التأهيل والقوة.' : '107 verified muscles linked directly to exercises.'}</div>
              </Link>

              <Link to={navigationPaths.exerciseSystems(lang)} className="rounded-[1.6rem] border border-slate-200 bg-white/85 p-5 transition hover:-translate-y-0.5 hover:border-health-green/30">
                <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                  <Network className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'أنظمة التمرين' : 'Systems'}</span>
                </div>
                <div className="mt-3 text-lg font-black text-slate-900">{isAr ? 'صفحات الأنظمة والمقارنات' : 'System guides and comparisons'}</div>
                <div className="mt-2 text-sm leading-7 text-slate-600">{isAr ? 'كل نظام له صفحة مستقلة وخطة أسبوعية وروابط تمارين.' : 'Every system has its own page, weekly structure, and exercise links.'}</div>
              </Link>

              <a href="#exercise-finder-hub" className="rounded-[1.6rem] border border-slate-200 bg-white/85 p-5 transition hover:-translate-y-0.5 hover:border-health-green/30">
                <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                  <ChevronRight className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'التصفح المباشر' : 'Browse now'}</span>
                </div>
                <div className="mt-3 text-lg font-black text-slate-900">{isAr ? 'افتح مكتبة التمارين' : 'Open the exercise library'}</div>
                <div className="mt-2 text-sm leading-7 text-slate-600">{isAr ? 'ابحث وفلتر من نفس الصفحة الأساسية.' : 'Search and filter directly from the main hub.'}</div>
              </a>
            </div>
          </div>
        </section>

        <section className="space-y-5">
          <div className="flex items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl font-black text-slate-900">{isAr ? 'صفحات المناطق العضلية' : 'Muscle region pages'}</h2>
              <p className="mt-2 text-sm leading-7 text-slate-600">
                {isAr ? 'كل صفحة منطقة فيها تشريح بسيط، مكتبة التمارين الكاملة، وأنظمة مرتبطة.' : 'Each region page includes simple anatomy, the full exercise library, and related systems.'}
              </p>
            </div>
          </div>

          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {HUB_REGIONS.map((region) => (
              <Link
                key={region}
                to={navigationPaths.exercisesMuscle(lang, region)}
                className="group rounded-[1.6rem] border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:border-health-green/30"
              >
                <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                  {isAr ? 'صفحة منطقة' : 'Region page'}
                </div>
                <div className="mt-3 text-xl font-black text-slate-900">
                  {isAr ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[region] : EXERCISE_FINDER_STATIC_LABELS[region]}
                </div>
                <div className="mt-2 text-sm leading-7 text-slate-600">
                  {isAr ? 'تشريح مبسط + تمارين كاملة + ربط داخلي مع الأنظمة والخطط.' : 'Simple anatomy, full exercises, and internal links to related systems and plans.'}
                </div>
                <div className="mt-4 inline-flex items-center gap-2 text-sm font-semibold text-health-green transition group-hover:text-health-green-dark">
                  <span>{isAr ? 'افتح الصفحة' : 'Open page'}</span>
                  <ArrowRight className="h-4 w-4" />
                </div>
              </Link>
            ))}
          </div>
        </section>

        <section className="space-y-5">
          <div>
            <h2 className="text-2xl font-black text-slate-900">{isAr ? 'صفحات التأهيل الموجّه' : 'Targeted rehab pages'}</h2>
            <p className="mt-2 text-sm leading-7 text-slate-600">
              {isAr ? 'صفحات مركزة لتمارين الرقبة والورك والرسغ مع مسارات أوسع لاكتشاف تمارين العودة للتدريب.' : 'Focused pages for neck, hip, wrist, and broader return-to-training exercise discovery.'}
            </p>
          </div>

          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            {REHAB_REGIONS.map((region) => (
              <Link
                key={region}
                to={navigationPaths.exercisesMuscle(lang, region)}
                className="group rounded-[1.6rem] border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:border-health-green/30"
              >
                <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                  {isAr ? 'صفحة تأهيل' : 'Rehab page'}
                </div>
                <div className="mt-3 text-xl font-black text-slate-900">
                  {isAr ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[region] : EXERCISE_FINDER_STATIC_LABELS[region]}
                </div>
                <div className="mt-2 text-sm leading-7 text-slate-600">
                  {isAr ? 'مجموعات تمارين منتقاة مرتبطة بالتأهيل والعودة التدريجية إلى التدريب.' : 'Curated exercise groups connected to rehab and return-to-training needs.'}
                </div>
                <div className="mt-4 inline-flex items-center gap-2 text-sm font-semibold text-health-green transition group-hover:text-health-green-dark">
                  <span>{isAr ? 'افتح الصفحة' : 'Open page'}</span>
                  <ArrowRight className="h-4 w-4" />
                </div>
              </Link>
            ))}
          </div>
        </section>

        <section id="exercise-finder-hub">
          <ExerciseFinder
            canonicalBasePath="/exercises"
            enableSeo
            lang={lang}
            pathMuscle={null}
            key={`exercises-hub-${lang}-${EXERCISE_FINDER_STATIC_SLUGS.length}`}
          />
        </section>
      </div>
    </PageLayout>
  );
}

export const EXERCISE_ROUTE_LABELS = EXERCISE_FINDER_STATIC_LABELS;

