import {useEffect, useMemo, useState} from 'react';
import {Activity, ArrowRight, ChevronRight, Dumbbell, Network} from 'lucide-react';
import {Link, Navigate, useParams} from 'react-router-dom';

import {ExerciseCard} from '../components/common/exercise-finder/ExerciseCard';
import {Badge} from '../components/common/exercise-finder/FilterField';
import {useExerciseCatalog} from '../hooks/useExerciseCatalog';
import {
  REGION_CONTENT,
  getSystemsForRegion,
  getWeeklyPlanForSystem,
} from '../components/common/exercise-finder/content';
import {
  EXERCISE_FINDER_STATIC_ARABIC_LABELS,
  EXERCISE_FINDER_STATIC_LABELS,
  EXERCISE_FINDER_STATIC_SLUGS,
} from '../components/common/exercise-finder/constants';
import {TrainingSystemCard} from '../components/common/exercise-finder/TrainingSystemCard';
import {WeeklyPlanCard} from '../components/common/exercise-finder/WeeklyPlanCard';
import type {StaticMuscleSlug} from '../components/common/exercise-finder/types';

import Seo from '../components/seo/Seo';
import {getLocalCatalogInjuries, getRelatedCatalogInjuriesByIds, type InjuryCatalogEntry} from '../services/injuryService';
import {REHAB_REGION_CONFIG} from '../services/rehabRegionConfig';
import {denormalizeExerciseUrlSlug, normalizeExerciseUrlSlug} from '../services/seoAliases';
import {prepareMedicalText} from '../services/textEncoding';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';

function isStaticMuscleSlug(value: string | undefined): value is StaticMuscleSlug {
  return Boolean(value && EXERCISE_FINDER_STATIC_SLUGS.includes(value as StaticMuscleSlug));
}



export default function ExerciseRegionPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const safeText = prepareMedicalText;
  const {muscle} = useParams<{muscle: string}>();
  const normalizedMuscle = denormalizeExerciseUrlSlug(muscle || '');
  const region = isStaticMuscleSlug(normalizedMuscle) ? normalizedMuscle : null;
  const rehabConfig = region ? REHAB_REGION_CONFIG[region] : undefined;
  const {exercises: catalogExercises, loading: catalogLoading} = useExerciseCatalog();
  const [relatedInjuries, setRelatedInjuries] = useState<InjuryCatalogEntry[]>([]);
  const fallbackRelatedInjuries = useMemo(
    () => (rehabConfig ? getLocalCatalogInjuries(lang).filter((injury) => rehabConfig.relatedInjuryIds.includes(injury.id)) : []),
    [lang, rehabConfig],
  );

  useEffect(() => {
    let active = true;

    const loadRelatedInjuries = async () => {
      if (!rehabConfig) {
        setRelatedInjuries([]);
        return;
      }

      const items = await getRelatedCatalogInjuriesByIds(rehabConfig.relatedInjuryIds, lang);
      if (!active) return;
      setRelatedInjuries(items);
    };

    void loadRelatedInjuries();

    return () => {
      active = false;
    };
  }, [lang, rehabConfig]);

  if (muscle && normalizeExerciseUrlSlug(normalizedMuscle) !== muscle) {
    return <Navigate to={`/${lang}/exercises/${normalizeExerciseUrlSlug(normalizedMuscle)}`} replace />;
  }

  if (!region) {
    return <Navigate to={navigationPaths.exercises(lang)} replace />;
  }

  const label = isAr ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[region] : EXERCISE_FINDER_STATIC_LABELS[region];
  const content = REGION_CONTENT[region];
  const exercises = catalogExercises.filter((exercise) => exercise.region === region);
  const systems = getSystemsForRegion(region).slice(0, 3);
  const visibleRelatedInjuries = relatedInjuries.length ? relatedInjuries : fallbackRelatedInjuries;
  const canonicalPath = `/exercises/${normalizeExerciseUrlSlug(region)}`;

  const seoTitle = isAr
    ? safeText(`تمارين ${label} | تشريح مبسط وخطة تمارين كاملة`)
    : safeText(`${label} Exercises | Anatomy, exercise library, and workout systems`);
  const seoDescription = isAr
    ? safeText(`${content.introAr} ستجد أيضًا صفحات الأنظمة المناسبة وروابط الخطة الأسبوعية وتمارين ${label} الكاملة.`)
    : safeText(
        `${content.introEn} Explore full ${EXERCISE_FINDER_STATIC_LABELS[region].toLowerCase()} exercises, simple anatomy notes, linked workout systems, and weekly plan guidance.`,
      );

  return (
    <PageLayout title={safeText(isAr ? `دليل تمارين ${label}` : `${label} Exercise Guide`)}>
      <Seo
        title={seoTitle}
        description={seoDescription}
        canonicalPath={canonicalPath}
        hreflangs={buildHreflangs(canonicalPath)}
      />

      <div className="not-prose space-y-8">
        <nav aria-label="Breadcrumb" className="flex flex-wrap items-center gap-2 text-sm text-slate-500">
          <Link to={`/${lang}/`} className="hover:text-health-green">{isAr ? 'الرئيسية' : 'Home'}</Link>
          <ChevronRight className="h-4 w-4" />
          <Link to={navigationPaths.exercises(lang)} className="hover:text-health-green">{isAr ? 'التمارين' : 'Exercises'}</Link>
          <ChevronRight className="h-4 w-4" />
          <span className="font-semibold text-slate-900">{label}</span>
        </nav>

        <section className="overflow-hidden rounded-[2rem] border border-slate-200 bg-[radial-gradient(circle_at_top_left,rgba(16,185,129,0.12),transparent_42%),linear-gradient(180deg,#ffffff,#f8fafc)] p-6 sm:p-8">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div className="max-w-3xl space-y-4">
              <div className="inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green-dark">
                <Activity className="h-4 w-4" />
                <span>{rehabConfig ? (isAr ? 'دليل تأهيل' : 'Rehab guide') : isAr ? 'منطقة عضلية' : 'Region page'}</span>
              </div>
              <p className="mixed-text text-base leading-8 text-slate-700">{safeText(isAr ? content.introAr : content.introEn)}</p>
              {rehabConfig ? (
                <div className="mixed-text rounded-[1.5rem] border border-health-green/15 bg-white/75 p-4 text-sm leading-7 text-slate-700">
                  {safeText(isAr ? rehabConfig.summaryAr : rehabConfig.summaryEn)}
                </div>
              ) : null}
            </div>
            <div className="grid gap-3 sm:min-w-[220px]">
              <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">{isAr ? 'عدد التمارين' : 'Exercises'}</div>
                <div className="mt-2 text-2xl font-black text-slate-900">{exercises.length}</div>
                {catalogLoading ? <div className="mt-1 text-xs text-slate-400">{isAr ? 'تحديث الكتالوج...' : 'Catalog updating...'}</div> : null}
              </div>
              <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">{isAr ? 'أنظمة مرتبطة' : 'Related systems'}</div>
                <div className="mt-2 text-2xl font-black text-slate-900">{systems.length}</div>
              </div>
              {rehabConfig ? (
                <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                  <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">{isAr ? 'إصابات مرتبطة' : 'Related injuries'}</div>
                  <div className="mt-2 text-2xl font-black text-slate-900">{visibleRelatedInjuries.length}</div>
                </div>
              ) : null}
            </div>
          </div>

          <div className="mt-6 flex flex-wrap gap-3">
            <a href="#region-anatomy" className="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
              {isAr ? 'ملخص المنطقة' : 'Region overview'}
            </a>
            {rehabConfig ? (
              <a href="#rehab-guidance" className="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
                {isAr ? 'التوجيه العلاجي' : 'Rehab guidance'}
              </a>
            ) : null}
            {rehabConfig ? (
              <a href="#related-injuries" className="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
                {isAr ? 'الإصابات المرتبطة' : 'Related injuries'}
              </a>
            ) : null}
            <a href="#region-exercises" className="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
              {isAr ? 'التمارين الكاملة' : 'Exercise library'}
            </a>
            <Link to={navigationPaths.exerciseSystems(lang)} className="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
              {isAr ? 'صفحات الأنظمة' : 'Training systems'}
            </Link>
          </div>
        </section>

        {rehabConfig ? (
          <section id="rehab-guidance" className="grid gap-6 xl:grid-cols-[1.05fr_0.95fr]">
            <article className="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
              <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
                <Activity className="h-4 w-4 text-health-green" />
                <span>{isAr ? 'توجيه علاجي مختصر' : 'Rehab focus'}</span>
              </div>
              <div className="mt-4 space-y-3">
                {(isAr ? rehabConfig.medicalNotesAr : rehabConfig.medicalNotesEn).map((item) => (
                  <div key={item} className="mixed-text rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm leading-7 text-slate-700">
                    {safeText(item)}
                  </div>
                ))}
              </div>
            </article>

            <article className="rounded-[1.75rem] border border-amber-200 bg-amber-50/70 p-6 shadow-sm sm:p-8">
              <div className="text-xs font-bold uppercase tracking-[0.18em] text-amber-700">
                {isAr ? 'متى تخفف الحمل أو تطلب تقييمًا' : 'When to scale back'}
              </div>
              <div className="mt-4 space-y-3">
                {(isAr ? rehabConfig.redFlagNotesAr : rehabConfig.redFlagNotesEn).map((item) => (
                  <div key={item} className="mixed-text rounded-2xl border border-amber-200 bg-white/80 px-4 py-3 text-sm leading-7 text-slate-700">
                    {safeText(item)}
                  </div>
                ))}
              </div>
            </article>
          </section>
        ) : null}

        <section id="region-anatomy" className="grid gap-6 lg:grid-cols-[1.35fr_0.95fr]">
          <article className="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
            <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
              <Network className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'عرض محايد للمنطقة' : 'Neutral region visual'}</span>
            </div>

            <div className="mt-4 space-y-3">
              {(isAr ? content.anatomyAr : content.anatomyEn).map((item) => (
                <div key={item} className="mixed-text rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm leading-7 text-slate-700">
                  {safeText(item)}
                </div>
              ))}
            </div>
          </article>

          <article className="rounded-[1.75rem] border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
            <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
              <Dumbbell className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'نقاط التركيز' : 'Coaching focus'}</span>
            </div>
            <div className="mt-4 space-y-3">
              {(isAr ? content.cuesAr : content.cuesEn).map((item) => (
                <div key={item} className="mixed-text rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm leading-7 text-slate-700">
                  {safeText(item)}
                </div>
              ))}
            </div>
            <div className="mt-6 rounded-2xl border border-health-green/15 bg-health-green/5 p-4">
              <div className="text-xs font-bold uppercase tracking-[0.16em] text-health-green-dark">
                {isAr ? 'كلمات مفتاحية مستهدفة' : 'Target search intent'}
              </div>
              <div className="mt-3 flex flex-wrap gap-2">
                {(isAr ? content.keywordsAr : content.keywordsEn).map((keyword) => (
                  <Badge key={keyword}>{safeText(keyword)}</Badge>
                ))}
              </div>
            </div>
          </article>
        </section>

        {rehabConfig && visibleRelatedInjuries.length > 0 ? (
          <section id="related-injuries" className="space-y-5">
            <div>
              <h2 className="text-2xl font-black text-slate-900">{isAr ? 'إصابات مرتبطة بهذا التأهيل' : 'Related injury pages'}</h2>
              <p className="mixed-text mt-2 text-sm leading-7 text-slate-600">
                {isAr
                  ? 'هذه الروابط تجمع بين صفحة التأهيل العامة وصفحات الإصابات الأقرب لها، حتى يقرأ المستخدم التمرين داخل سياق إصابة أو مرحلة تعافٍ أكثر دقة.'
                  : 'These links connect the general rehab page with the injury guides most likely to need this exercise focus, giving users more condition-specific context.'}
              </p>
            </div>

            <div className="grid gap-4 lg:grid-cols-2 xl:grid-cols-3">
              {visibleRelatedInjuries.map((injury) => (
                <Link
                  key={injury.id}
                  to={`/${lang}/injuries/${injury.slug}`}
                  className="group rounded-[1.6rem] border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:border-health-green/30"
                >
                  <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                    {isAr ? 'صفحة إصابة' : 'Injury guide'}
                  </div>
                  <div className="mixed-text mt-3 text-lg font-black leading-8 text-slate-900">
                    {safeText(injury.name)}
                  </div>
                  <div className="mixed-text mt-2 text-sm leading-7 text-slate-600">
                    {safeText(`${injury.category} • ${injury.bodyRegion}`)}
                  </div>
                  <div className="mt-4 inline-flex items-center gap-2 text-sm font-semibold text-health-green transition group-hover:text-health-green-dark">
                    <span>{isAr ? 'افتح دليل الإصابة' : 'Open injury guide'}</span>
                    <ArrowRight className="h-4 w-4" />
                  </div>
                </Link>
              ))}
            </div>
          </section>
        ) : null}

        <section className="space-y-5">
          <div className="flex items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl font-black text-slate-900">{isAr ? 'أنظمة مناسبة لهذه المنطقة' : 'Related training systems'}</h2>
              <p className="mixed-text mt-2 text-sm leading-7 text-slate-600">
                {isAr ? 'كل نظام من دول له صفحة مفصلة وخطة أسبوعية وروابط مباشرة للتمارين.' : 'Each system below has its own detail page, weekly template, and direct exercise links.'}
              </p>
            </div>
            <Link to={navigationPaths.exerciseSystems(lang)} className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green">
              <span>{isAr ? 'كل الأنظمة' : 'All systems'}</span>
              <ArrowRight className="h-4 w-4" />
            </Link>
          </div>

          <div className="grid gap-4 lg:grid-cols-3">
            {systems.map((system) => (
              <div key={system.id} className="space-y-3">
                <TrainingSystemCard system={system} isAr={isAr} />
                <Link to={navigationPaths.exerciseSystemDetail(lang, system.id)} className="inline-flex items-center gap-2 text-sm font-semibold text-health-green transition hover:text-health-green-dark">
                  <span>{isAr ? 'افتح صفحة النظام' : 'Open system page'}</span>
                  <ArrowRight className="h-4 w-4" />
                </Link>
              </div>
            ))}
          </div>
        </section>

        <section id="region-exercises" className="space-y-5">
          <div>
            <h2 className="text-2xl font-black text-slate-900">{isAr ? `كل تمارين ${label}` : `All ${EXERCISE_FINDER_STATIC_LABELS[region]} exercises`}</h2>
            <p className="mixed-text mt-2 text-sm leading-7 text-slate-600">
              {isAr
                ? 'القائمة هنا مخصصة بالكامل لهذه المنطقة، مع ملاحظات تقنية وتفاصيل إضافية عند الفتح.'
                : 'This page collects the full exercise library for the region, with technique notes and expandable details.'}
            </p>
          </div>
          <div className="grid gap-4 xl:grid-cols-2">
            {exercises.map((exercise) => (
              <ExerciseCard key={exercise.name} exercise={exercise} isAr={isAr} />
            ))}
          </div>
        </section>

        {systems.length > 0 ? (
          <section className="space-y-5">
            <div>
              <h2 className="text-2xl font-black text-slate-900">{isAr ? 'مثال ربط مع الخطة الأسبوعية' : 'Linked weekly plan example'}</h2>
              <p className="mixed-text mt-2 text-sm leading-7 text-slate-600">
                {isAr
                  ? 'الجزء ده يوضح كيف ترتبط تمارين هذه المنطقة مباشرة بأسبوع تدريبي حقيقي.'
                  : 'This section shows how the region connects to a real weekly training structure.'}
              </p>
            </div>
            {systems.slice(0, 1).map((system) => {
              const plan = getWeeklyPlanForSystem(system.id);
              if (!plan) return null;
              return <WeeklyPlanCard key={system.id} title={system.title} titleAr={system.titleAr} plan={plan} isAr={isAr} lang={lang} />;
            })}
          </section>
        ) : null}
      </div>
    </PageLayout>
  );
}
