import {useEffect, useId, useMemo, useState} from 'react';

import {CalendarRange, Dumbbell, Flame, Search, Share2, SlidersHorizontal, Sparkles, Target, X} from 'lucide-react';
import {Link} from 'react-router-dom';

import Seo from '../../seo/Seo';
import {useExerciseCatalog} from '../../../hooks/useExerciseCatalog';
import {normalizeExerciseUrlSlug} from '../../../services/seoAliases';
import {useDebounce} from '../../../hooks/useDebounce';
import {buildHreflangs, navigationPaths} from '../../../utils/langUrlHelper';
import {ExerciseCard} from './ExerciseCard';
import {
  EQUIPMENT_COLOR_MAP,
  EXERCISE_FINDER_QUICK_GROUPS,
  EXERCISE_FINDER_STATIC_ARABIC_LABELS,
  EXERCISE_FINDER_STATIC_LABELS,
  INITIAL_FILTERS,
  LEVEL_COLOR_MAP,
  MAIN_MUSCLE_TO_STATIC_GROUP,
  MUSCLE_TREE,
  TYPE_COLOR_MAP,
} from './constants';
import {Badge, ChipGroup, FilterField} from './FilterField';
import {
  createStructuredData,
  getRecommendedSystems,
  readFiltersFromUrl,
  getStaticSlugFilters,
  getWeeklyPlans,
  isStaticSlug,
  normalizeValue,
  syncFiltersToUrl,
  toTitle,
} from './filter-utils';
import {getEquipmentOptions, getExerciseTypeOptions, getLevelOptions, getMainMuscleOptions, getSubMuscleOptions} from './options';
import {SEO_INTROS} from './seo-intros';
import {TrainingSystemCard} from './TrainingSystemCard';
import {WeeklyPlanCard} from './WeeklyPlanCard';
import type {Equipment, ExerciseFinderProps, ExerciseType, FilterState, Level, MainMuscle, StaticMuscleSlug, SubMuscle} from './types';


function AnimatedCount({value}: {value: number}) {
  const [display, setDisplay] = useState(value);
  const [animating, setAnimating] = useState(false);

  useEffect(() => {
    setAnimating(true);
    const timer = setTimeout(() => {
      setDisplay(value);
      setAnimating(false);
    }, 150);
    return () => clearTimeout(timer);
  }, [value]);

  return (
    <span
      className={`font-bold text-slate-900 transition-all duration-150 ${animating ? 'scale-110 text-health-green' : 'scale-100'}`}
      style={{display: 'inline-block'}}
    >
      {display}
    </span>
  );
}

export function ExerciseFinder({
  canonicalBasePath = '/exercises',
  enableSeo = true,
  lang = 'en',
  pathMuscle = null,
}: ExerciseFinderProps) {


  const isAr = lang === 'ar';
  const searchId = useId();
  const muscleId = useId();
  const subMuscleId = useId();
  const levelId = useId();
  const equipmentId = useId();
  const typeId = useId();
  const workspaceHeadingId = useId();
  const [filters, setFilters] = useState<FilterState>(() => readFiltersFromUrl(pathMuscle));
  const [searchInput, setSearchInput] = useState(filters.search);
  const [filtersOpen, setFiltersOpen] = useState(false);
  const [workspaceView, setWorkspaceView] = useState<'browse' | 'systems' | 'schedule'>('browse');
  const debouncedSearch = useDebounce(searchInput, 300);

  useEffect(() => {
    setFilters(readFiltersFromUrl(pathMuscle));
  }, [pathMuscle]);

  useEffect(() => {
    setFilters((current) => ({...current, search: debouncedSearch}));
  }, [debouncedSearch]);

  useEffect(() => {
    setSearchInput(filters.search);
  }, [filters.search]);

  useEffect(() => {
    syncFiltersToUrl(filters, pathMuscle);
  }, [filters, pathMuscle]);

  useEffect(() => {
    const handlePopState = () => setFilters(readFiltersFromUrl(pathMuscle));
    window.addEventListener('popstate', handlePopState);
    return () => window.removeEventListener('popstate', handlePopState);
  }, [pathMuscle]);

  useEffect(() => {
    if (!filtersOpen) return;

    const previousOverflow = document.body.style.overflow;
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        setFiltersOpen(false);
      }
    };

    document.body.style.overflow = 'hidden';
    window.addEventListener('keydown', onKeyDown);

    return () => {
      document.body.style.overflow = previousOverflow;
      window.removeEventListener('keydown', onKeyDown);
    };
  }, [filtersOpen]);

  const staticContext = useMemo(() => getStaticSlugFilters(pathMuscle), [pathMuscle]);
  const subMuscleOptions = useMemo(() => getSubMuscleOptions(filters.muscle, isAr), [filters.muscle, isAr]);
  const {exercises: exerciseRecords, loading: catalogLoading} = useExerciseCatalog();

  const filteredExercises = useMemo(() => {
    const scopedExercises =
      staticContext?.staticMuscles?.length
        ? exerciseRecords.filter((exercise) => staticContext.staticMuscles.includes(exercise.mainMuscle))
        : exerciseRecords;

    const search = normalizeValue(filters.search);

    return scopedExercises.filter((exercise) => {
      const matchesSearch =
        search.length === 0 ||
        normalizeValue(exercise.name).includes(search) ||
        normalizeValue(exercise.description).includes(search) ||
        normalizeValue(exercise.mainMuscle).includes(search) ||
        normalizeValue(exercise.equipment).includes(search) ||
        normalizeValue(exercise.level).includes(search) ||
        exercise.muscles.some((muscle) => normalizeValue(muscle).replace(/_/g, ' ').includes(search));
      const matchesMainMuscle = filters.muscle === 'all' || exercise.mainMuscle === filters.muscle;
      const matchesSubMuscle = filters.subMuscle === 'all' || exercise.muscles.includes(filters.subMuscle);
      const matchesLevel = filters.level === 'all' || exercise.level === filters.level;
      const matchesEquipment = filters.equipment === 'all' || exercise.equipment === filters.equipment;
      const matchesType = filters.exerciseType === 'all' || exercise.exerciseType === filters.exerciseType;

      return matchesSearch && matchesMainMuscle && matchesSubMuscle && matchesLevel && matchesEquipment && matchesType;
    });
  }, [exerciseRecords, filters, staticContext]);

  const selectedMainMuscle = filters.muscle !== 'all' ? filters.muscle : staticContext?.staticMuscles?.[0] || null;
  const anatomyList = selectedMainMuscle ? MUSCLE_TREE[selectedMainMuscle] : [];
  const popularExercises = selectedMainMuscle
    ? filteredExercises.slice(0, 3)
    : filteredExercises.slice(0, 3);
  const selectedStaticGroup = selectedMainMuscle ? MAIN_MUSCLE_TO_STATIC_GROUP[selectedMainMuscle] : pathMuscle || null;
  const recommendedSystems = useMemo(
    () => getRecommendedSystems({filters, selectedStaticGroup}),
    [filters, selectedStaticGroup],
  );
  const weeklyPlans = useMemo(() => getWeeklyPlans(recommendedSystems), [recommendedSystems]);
  const totalBeginnerExercises = filteredExercises.filter((exercise) => exercise.level === 'beginner').length;
  const totalStrengthExercises = filteredExercises.filter((exercise) => exercise.exerciseType === 'strength').length;
  const totalEquipmentOptions = new Set(filteredExercises.map((exercise) => exercise.equipment)).size;
  const totalExercises = exerciseRecords.length;
  const percentage = totalExercises ? Math.round((filteredExercises.length / totalExercises) * 100) : 0;
  const resetFilters = () => {
    setSearchInput('');
    setFilters({
      ...INITIAL_FILTERS,
      muscle: staticContext?.muscle || 'all',
    });
  };

  const headingLabel = selectedMainMuscle
    ? isAr
      ? `تمارين ${EXERCISE_FINDER_STATIC_ARABIC_LABELS[selectedMainMuscle]}`
      : `${EXERCISE_FINDER_STATIC_LABELS[selectedMainMuscle]} exercises`
    : pathMuscle && isStaticSlug(pathMuscle)
      ? isAr
        ? `تمارين ${EXERCISE_FINDER_STATIC_ARABIC_LABELS[pathMuscle]}`
        : `${EXERCISE_FINDER_STATIC_LABELS[pathMuscle]} exercises`
      : isAr
        ? 'دليل التمارين'
        : 'Exercise Finder';

  const seoIntroKey = (pathMuscle || selectedStaticGroup || 'general') as StaticMuscleSlug | 'general';
  const seoIntro = SEO_INTROS[seoIntroKey] || SEO_INTROS.general;
  const seoIntroTitle = isAr ? seoIntro.titleAr : seoIntro.titleEn;
  const seoIntroBody = isAr ? seoIntro.bodyAr : seoIntro.bodyEn;
  const seoKeywordLead = selectedMainMuscle
    ? isAr
      ? `تمارين ${EXERCISE_FINDER_STATIC_ARABIC_LABELS[selectedStaticGroup || selectedMainMuscle]}`
      : `${EXERCISE_FINDER_STATIC_LABELS[selectedStaticGroup || selectedMainMuscle]} exercises`
    : isAr
      ? 'تمارين الجيم'
      : 'Gym exercises';

  const canonicalPath =
    pathMuscle && isStaticSlug(pathMuscle) ? `${canonicalBasePath}/${normalizeExerciseUrlSlug(pathMuscle)}` : canonicalBasePath;
  const pageTitle = isAr
    ? `${seoKeywordLead} | دليل تمارين الجيم وبرامج التدريب`
    : `${seoKeywordLead} | Gym Exercise Finder, Workouts, and Training Plans`;
  const pageDescription = selectedMainMuscle
    ? isAr
      ? `${seoIntroBody} استعرض تمارين ${EXERCISE_FINDER_STATIC_ARABIC_LABELS[selectedMainMuscle]} مع فلاتر للمعدات والمستوى وهدف التمرين وخطط أسبوعية جاهزة.`
      : `${seoIntroBody} Browse ${EXERCISE_FINDER_STATIC_LABELS[selectedMainMuscle].toLowerCase()} exercises with filters for equipment, level, training goal, and weekly workout planning.`
    : isAr
      ? `${seoIntroBody} ابحث عن تمارين الجيم حسب العضلة والعضلات الفرعية والمستوى والمعدات وهدف التمرين داخل دليل مرتب وسهل الاستخدام.`
      : `${seoIntroBody} Find gym exercises by muscle, sub-muscle, level, equipment, and training goal in a structured exercise finder.`;

  const activeFilterCount = [
    filters.muscle !== 'all',
    filters.subMuscle !== 'all',
    filters.level !== 'all',
    filters.equipment !== 'all',
    filters.exerciseType !== 'all',
    filters.search.trim().length > 0,
  ].filter(Boolean).length;

  const quickGroups = EXERCISE_FINDER_QUICK_GROUPS;

  const workspaceViews = [
    {
      id: 'browse' as const,
      icon: Search,
      title: isAr ? 'استعرض التمارين' : 'Browse exercises',
      description: isAr
        ? 'فلترة وبحث سريع ثم مراجعة التمارين المناسبة.'
        : 'Filter fast and review matching exercises.',
      countLabel: isAr ? `${filteredExercises.length} نتيجة` : `${filteredExercises.length} results`,
    },
    {
      id: 'systems' as const,
      icon: Dumbbell,
      title: isAr ? 'أنظمة جاهزة' : 'Training systems',
      description: isAr
        ? 'برامج مرتبة حسب الهدف والمستوى والمعدات.'
        : 'Structured programs by goal, level, and equipment.',
      countLabel: isAr ? `${recommendedSystems.length} نظام` : `${recommendedSystems.length} systems`,
    },
    {
      id: 'schedule' as const,
      icon: CalendarRange,
      title: isAr ? 'خطة أسبوعية' : 'Weekly plan',
      description: isAr
        ? 'جدول تنفيذ أسبوعي مبني على التمارين الحالية.'
        : 'A weekly schedule built from the current exercise mix.',
      countLabel: isAr ? `${weeklyPlans.length} خطة` : `${weeklyPlans.length} plans`,
    },
  ];
  const sectionIds = {
    filters: 'exercise-filters',
    results: 'exercise-results',
    systems: 'exercise-systems',
    schedule: 'exercise-schedule',
  };
  const breadcrumbItems = [
    {label: isAr ? 'الرئيسية' : 'Home', href: navigationPaths.home(lang)},
    {label: isAr ? 'التمارين' : 'Exercises', href: navigationPaths.exercises(lang)},
    selectedStaticGroup
      ? {
          label: isAr
            ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[selectedStaticGroup]
            : EXERCISE_FINDER_STATIC_LABELS[selectedStaticGroup],
          href: navigationPaths.exercisesMuscle(lang, selectedStaticGroup),
        }
      : null,
  ].filter(Boolean) as Array<{label: string; href: string}>;

  return (
    <>
      {enableSeo ? (
        <Seo
          title={pageTitle}
          description={pageDescription}
          canonicalPath={canonicalPath}
          hreflangs={buildHreflangs(canonicalPath)}
          structuredData={createStructuredData(pageTitle, pageDescription, canonicalPath, filteredExercises)}
        />
      ) : null}

      <section aria-labelledby="exercise-finder-title" className="py-2 sm:py-4">
        <div className="mx-auto max-w-7xl">
          <div className="overflow-hidden rounded-[2rem] border border-slate-200 bg-white shadow-sm">
            <div className="border-b border-slate-200 bg-[linear-gradient(135deg,rgba(244,239,231,0.9),rgba(255,255,255,0.96))] px-5 py-8 sm:px-8">
              <div className="flex flex-col gap-6 lg:flex-row lg:items-end lg:justify-between">
                <div className="max-w-4xl">
                  <nav aria-label={isAr ? 'مسار التنقل' : 'Breadcrumb'} className="mb-4">
                    <ol className="flex flex-wrap items-center gap-2 text-sm text-slate-500">
                      {breadcrumbItems.map((item, index) => (
                        <li key={`${item.href}-${index}`} className="inline-flex items-center gap-2">
                          {index > 0 ? <span>/</span> : null}
                          {index === breadcrumbItems.length - 1 ? (
                            <span className="font-semibold text-slate-700">{item.label}</span>
                          ) : (
                            <Link to={item.href} className="transition hover:text-health-green">
                              {item.label}
                            </Link>
                          )}
                        </li>
                      ))}
                    </ol>
                  </nav>

                  <div className="inline-flex items-center gap-2 rounded-full bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green">
                    <SlidersHorizontal className="h-3.5 w-3.5" />
                    <span>{isAr ? 'دليل تمارين الجيم' : 'Gym Exercise Finder'}</span>
                  </div>
                  <h1 id="exercise-finder-title" className="mt-4 text-3xl font-bold text-slate-900 sm:text-4xl">
                    {headingLabel}
                  </h1>
                  <p className="mt-3 max-w-3xl text-sm leading-7 text-slate-600 sm:text-base">
                    {isAr
                      ? 'استعرض التمارين حسب العضلة الرئيسية أو الفرعية، ثم فلتر النتائج حسب المستوى والمعدات وهدف التمرين. الصفحة منظمة لتخدم الجيم بشكل واضح مع ملاحظات عملية تساعدك على الاختيار.'
                      : 'Explore gym exercises by muscle and sub-muscle, then narrow the list by level, equipment, and training goal. This finder stays fitness-focused while still using coaching cues that are sensible for physically active users.'}
                  </p>
                </div>

                <div className="rounded-2xl border border-white/60 bg-white/70 px-4 py-3 text-sm text-slate-600" aria-live="polite">
                  <div className="font-semibold text-slate-900">
                    {isAr ? (
                      <>
                        <AnimatedCount value={filteredExercises.length} /> تمرين ظاهر الآن
                      </>
                    ) : (
                      <>
                        <AnimatedCount value={filteredExercises.length} /> exercises shown
                      </>
                    )}
                  </div>
                  <div className="mt-1">
                    {activeFilterCount > 0
                      ? isAr
                        ? `${activeFilterCount} فلتر مفعل`
                        : `${activeFilterCount} active filters`
                      : isAr
                        ? 'يمكن مشاركة الرابط الحالي بنفس الفلاتر'
                        : 'Shareable and query-param ready'}
                  </div>
                  <div className="mt-1 text-xs text-slate-500">
                    {isAr ? `من أصل ${totalExercises} تمرين` : `of ${totalExercises} total`}
                  </div>
                  <div className="mt-2 h-1 w-full overflow-hidden rounded-full bg-slate-200">
                    <div
                      className="h-full rounded-full bg-health-green transition-all duration-300"
                      style={{width: `${percentage}%`}}
                      role="progressbar"
                      aria-valuenow={filteredExercises.length}
                      aria-valuemin={0}
                      aria-valuemax={totalExercises}
                      aria-label={`${filteredExercises.length} of ${totalExercises} exercises`}
                    />
                  </div>
                </div>
              </div>

              <div className="mt-6 grid gap-4 lg:grid-cols-[1.6fr_1fr]">
                <div className="rounded-[1.5rem] border border-white/70 bg-white/80 p-5">
                  <h2 className="text-lg font-bold text-slate-900">{seoIntroTitle}</h2>
                  <p className="mt-3 text-sm leading-7 text-slate-600">{seoIntroBody}</p>
                  <div className="mt-4 flex flex-wrap gap-2">
                    {quickGroups.map((item) => (
                      <Link
                        key={`seo-${item.slug}`}
                        to={navigationPaths.exercisesMuscle(lang, item.slug)}
                        className="rounded-full border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                      >
                        {isAr ? `تمارين ${EXERCISE_FINDER_STATIC_ARABIC_LABELS[item.slug]}` : `${EXERCISE_FINDER_STATIC_LABELS[item.slug]} exercises`}
                      </Link>
                    ))}
                  </div>
                </div>

                <div className="rounded-[1.5rem] border border-white/70 bg-white/80 p-5">
                  <div className="text-xs font-bold uppercase tracking-[0.16em] text-health-green">
                    {isAr ? 'كلمات بحث مستهدفة' : 'Search intent'}
                  </div>
                  <div className="mt-3 space-y-2 text-sm text-slate-600">
                    <p>{isAr ? 'تمارين حسب العضلة' : 'Exercises by muscle group'}</p>
                    <p>{isAr ? 'خطط تدريب أسبوعية' : 'Weekly workout plans'}</p>
                    <p>{isAr ? 'تمارين حسب المعدات والمستوى' : 'Workouts by equipment and level'}</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="grid gap-8 p-5 sm:p-8 xl:grid-cols-[0.95fr_2.05fr]">
              <div className="sticky top-0 z-10 -mx-5 -mt-5 mb-4 flex items-center justify-between border-b border-slate-200 bg-white/95 px-5 py-3 backdrop-blur-sm xl:hidden">
                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => setFiltersOpen((open) => !open)}
                    className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30"
                  >
                    <SlidersHorizontal className="h-4 w-4" />
                    {isAr ? 'الفلاتر' : 'Filters'}
                    {activeFilterCount > 0 && (
                      <span className="inline-flex h-5 w-5 items-center justify-center rounded-full bg-health-green text-[10px] font-bold text-white">
                        {activeFilterCount}
                      </span>
                    )}
                  </button>
                  <a
                    href={`#${sectionIds.results}`}
                    className="inline-flex items-center rounded-2xl border border-slate-200 bg-white px-3 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                  >
                    {isAr ? 'النتائج' : 'Results'}
                  </a>
                </div>
                  <div className="text-sm text-slate-600" aria-live="polite">
                    <span className="font-semibold text-slate-900">{filteredExercises.length}</span>
                    {isAr ? ' تمرين' : ' exercises'}
                    {catalogLoading ? <span className="ml-2 text-slate-400">{isAr ? 'يتم التحديث...' : 'updating...'}</span> : null}
                  </div>
                </div>

              {filtersOpen ? (
                <button
                  type="button"
                  aria-label={isAr ? 'إغلاق الفلاتر' : 'Close filters'}
                  onClick={() => setFiltersOpen(false)}
                  className="fixed inset-0 z-30 bg-slate-900/45 backdrop-blur-[2px] xl:hidden"
                />
              ) : null}

              <aside
                id={sectionIds.filters}
                className={`space-y-6 ${
                  filtersOpen
                    ? 'fixed inset-x-3 bottom-3 z-40 max-h-[85vh] overflow-y-auto rounded-[1.75rem] border border-slate-200 bg-white p-4 shadow-2xl xl:static xl:max-h-none xl:overflow-visible xl:rounded-none xl:border-0 xl:bg-transparent xl:p-0 xl:shadow-none'
                    : 'hidden'
                } xl:block`}
              >
                <div className="sticky top-0 z-10 -mx-4 -mt-4 mb-4 flex items-center justify-between border-b border-slate-200 bg-white px-4 py-3 xl:hidden">
                  <div>
                    <div className="text-sm font-bold text-slate-900">{isAr ? 'فلترة التمارين' : 'Filter exercises'}</div>
                    <div className="text-xs text-slate-500">
                      {isAr ? 'اختر العضلة والمستوى والمعدات بسرعة' : 'Choose muscle, level, and equipment quickly'}
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setFiltersOpen(false)}
                    className="rounded-full border border-slate-200 p-2 text-slate-600"
                  >
                    <X className="h-4 w-4" />
                  </button>
                </div>

                <div className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                  <div className="text-sm font-bold text-slate-900">
                    {isAr ? 'ابدأ من أقسام سريعة' : 'Start from quick groups'}
                  </div>
                  <div className="mt-3 grid grid-cols-2 gap-2">
                    {quickGroups.map((item) => (
                      <Link
                        key={item.slug}
                        to={navigationPaths.exercisesMuscle(lang, item.slug)}
                        className={`rounded-2xl border px-4 py-3 text-sm font-semibold transition hover:scale-[1.01] ${item.accent}`}
                      >
                        {isAr ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[item.slug] : EXERCISE_FINDER_STATIC_LABELS[item.slug]}
                      </Link>
                    ))}
                  </div>
                </div>

                {activeFilterCount > 0 && (
                  <div className="space-y-3">
                    <div className="flex items-center justify-between rounded-2xl border border-health-green/20 bg-health-green/5 px-4 py-2.5">
                      <span className="text-sm font-semibold text-health-green">
                        {isAr ? `${activeFilterCount} فلتر مفعل` : `${activeFilterCount} active filter${activeFilterCount !== 1 ? 's' : ''}`}
                      </span>
                      <button
                        type="button"
                        onClick={resetFilters}
                        className="rounded-xl border border-health-green/30 bg-white px-3 py-1 text-xs font-semibold text-health-green transition hover:bg-health-green/10"
                      >
                        {isAr ? 'مسح الكل' : 'Clear all'}
                      </button>
                    </div>

                    <div className="flex flex-wrap gap-1.5">
                      {filters.muscle !== 'all' && (
                        <span className="inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700">
                          {isAr ? EXERCISE_FINDER_STATIC_ARABIC_LABELS[filters.muscle as StaticMuscleSlug] || filters.muscle : filters.muscle}
                          <button
                            type="button"
                            aria-label={`Remove ${filters.muscle} filter`}
                            onClick={() => setFilters((current) => ({...current, muscle: 'all', subMuscle: 'all'}))}
                            className="ml-0.5 rounded-full hover:text-red-500"
                          >
                            ×
                          </button>
                        </span>
                      )}
                      {filters.level !== 'all' && (
                        <span className="inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700">
                          {filters.level}
                          <button
                            type="button"
                            onClick={() => setFilters((current) => ({...current, level: 'all'}))}
                            className="ml-0.5 hover:text-red-500"
                          >
                            ×
                          </button>
                        </span>
                      )}
                      {filters.equipment !== 'all' && (
                        <span className="inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700">
                          {filters.equipment}
                          <button
                            type="button"
                            onClick={() => setFilters((current) => ({...current, equipment: 'all'}))}
                            className="ml-0.5 hover:text-red-500"
                          >
                            ×
                          </button>
                        </span>
                      )}
                      {filters.exerciseType !== 'all' && (
                        <span className="inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700">
                          {filters.exerciseType}
                          <button
                            type="button"
                            onClick={() => setFilters((current) => ({...current, exerciseType: 'all'}))}
                            className="ml-0.5 hover:text-red-500"
                          >
                            ×
                          </button>
                        </span>
                      )}
                      {filters.search.trim() && (
                        <span className="inline-flex items-center gap-1 rounded-full border border-slate-200 bg-white px-2.5 py-1 text-xs font-semibold text-slate-700">
                          "{filters.search}"
                          <button
                            type="button"
                            onClick={() => {
                              setSearchInput('');
                              setFilters((current) => ({...current, search: ''}));
                            }}
                            className="ml-0.5 hover:text-red-500"
                          >
                            ×
                          </button>
                        </span>
                      )}
                    </div>
                  </div>
                )}

                <form className="grid gap-4" onSubmit={(event) => event.preventDefault()}>
                  <div className="space-y-2">
                    <label htmlFor={searchId} className="block text-sm font-semibold text-slate-700">
                      {isAr ? 'ابحث عن تمرين' : 'Search exercise'}
                    </label>
                    <div className="relative">
                      <Search className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                      <input
                        id={searchId}
                        type="search"
                        value={searchInput}
                        onChange={(event) => setSearchInput(event.target.value)}
                        placeholder={isAr ? 'ابحث باسم التمرين' : 'Search by exercise name'}
                        className="w-full rounded-2xl border border-slate-200 bg-white py-3 pl-11 pr-4 text-sm text-slate-900 outline-none transition focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                      />
                    </div>
                  </div>

                  <FilterField
                    id={muscleId}
                    label={isAr ? 'العضلة الرئيسية' : 'Main muscle'}
                    value={filters.muscle}
                    onChange={(value) =>
                      setFilters((current) => ({
                        ...current,
                        muscle: value as MainMuscle | 'all',
                        subMuscle: 'all',
                      }))
                    }
                    options={getMainMuscleOptions(isAr)}
                  />

                  <FilterField
                    id={subMuscleId}
                    label={isAr ? 'العضلة الفرعية' : 'Sub-muscle'}
                    value={filters.subMuscle}
                    onChange={(value) => setFilters((current) => ({...current, subMuscle: value as SubMuscle | 'all'}))}
                    options={subMuscleOptions}
                  />

                  <ChipGroup
                    label={isAr ? 'المستوى' : 'Level'}
                    value={filters.level}
                    onChange={(value) => setFilters((current) => ({...current, level: value as Level | 'all'}))}
                    options={getLevelOptions(isAr)}
                    colorMap={LEVEL_COLOR_MAP}
                  />

                  <ChipGroup
                    label={isAr ? 'المعدات' : 'Equipment'}
                    value={filters.equipment}
                    onChange={(value) => setFilters((current) => ({...current, equipment: value as Equipment | 'all'}))}
                    options={getEquipmentOptions(isAr)}
                    colorMap={EQUIPMENT_COLOR_MAP}
                  />

                  <ChipGroup
                    label={isAr ? 'نوع التمرين' : 'Exercise type'}
                    value={filters.exerciseType}
                    onChange={(value) =>
                      setFilters((current) => ({...current, exerciseType: value as ExerciseType | 'all'}))
                    }
                    options={getExerciseTypeOptions(isAr)}
                    colorMap={TYPE_COLOR_MAP}
                  />
                </form>

                <div className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                  <div className="flex items-center gap-2 text-sm font-bold text-slate-900">
                    <Target className="h-4 w-4 text-health-green" />
                    <span>{isAr ? 'التركيز العضلي' : 'Target anatomy'}</span>
                  </div>
                  <div className="mt-3 flex flex-wrap gap-2">
                    {anatomyList.length > 0 ? (
                      anatomyList.map((muscle) => <Badge key={muscle}>{toTitle(muscle)}</Badge>)
                    ) : (
                      <span className="text-sm text-slate-600">
                        {isAr ? 'اختر مجموعة عضلية لتظهر لك العضلات الفرعية المرتبطة بها.' : 'Select a muscle group to focus the anatomy view.'}
                      </span>
                    )}
                  </div>
                </div>

                <div className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                  <div className="flex items-center gap-2 text-sm font-bold text-slate-900">
                    <Dumbbell className="h-4 w-4 text-health-green" />
                    <span>{isAr ? 'تمارين شائعة' : 'Popular exercises'}</span>
                  </div>
                  <div className="mt-3 space-y-3">
                    {popularExercises.map((exercise) => (
                      <div key={exercise.name} className="rounded-2xl border border-slate-200 bg-white px-4 py-3">
                        <div className="font-semibold text-slate-900">{exercise.name}</div>
                        <div className="mt-1 text-sm text-slate-600">{exercise.description}</div>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 text-sm text-slate-600">
                  <div className="flex items-center gap-2 font-bold text-slate-900">
                    <Share2 className="h-4 w-4 text-health-green" />
                    <span>{isAr ? 'الروابط والمشاركة' : 'Sharing and SEO'}</span>
                  </div>
                  <p className="mt-2 leading-7">
                    {isAr
                      ? 'يمكنك مشاركة الرابط الحالي للاحتفاظ بنفس العضلة والفلاتر المختارة. كما أن المسارات الثابتة مثل '
                      : 'Share the current URL to preserve the selected muscle and active filters. Static page contexts like '}
                    <span className="font-semibold text-slate-900">/exercises/chest</span>
                    {isAr ? ' أو ' : ' or '}
                    <span className="font-semibold text-slate-900">/exercises/legs</span>
                    {isAr
                      ? ' تسهّل الوصول المباشر إلى قسم عضلي محدد.'
                      : ' can use the `pathMuscle` prop in this same component.'}
                    </p>
                  </div>

                <button
                  type="button"
                  onClick={() => setFiltersOpen(false)}
                  className="sticky bottom-0 w-full rounded-2xl border border-health-green bg-health-green/10 py-3 text-sm font-semibold text-health-green xl:hidden"
                >
                  {isAr ? `عرض ${filteredExercises.length} تمرين` : `Show ${filteredExercises.length} exercises`}
                </button>
              </aside>

              <div className="space-y-6">
                <section className="rounded-[1.5rem] border border-slate-200 bg-[linear-gradient(180deg,rgba(244,239,231,0.65),rgba(255,255,255,0.96))] p-5">
                  <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
                    <div className="max-w-2xl">
                      <div className="text-xs font-bold uppercase tracking-[0.16em] text-health-green">
                        {isAr ? 'تنقل أسرع داخل الصفحة' : 'Faster page flow'}
                      </div>
                      <h2 id={workspaceHeadingId} className="mt-2 text-xl font-bold text-slate-900 sm:text-2xl">
                        {isAr ? 'اختر الجزء الذي تريد التركيز عليه الآن' : 'Pick the part you want to focus on'}
                      </h2>
                      <p className="mt-2 text-sm leading-7 text-slate-600">
                        {isAr
                          ? 'قسمنا الصفحة إلى 3 مسارات واضحة حتى لا تضطر للمرور على كل المحتوى في مرة واحدة. الفلاتر ثابتة، لكن العرض الرئيسي يتغير حسب المهمة التي تريدها.'
                          : 'The page is now split into 3 clear work modes, so you do not have to scan everything at once. Filters stay available while the main workspace changes with your goal.'}
                      </p>
                    </div>

                    <div className="rounded-2xl border border-white/70 bg-white/80 px-4 py-3 text-sm text-slate-600">
                      <div className="font-semibold text-slate-900">
                        {workspaceViews.find((view) => view.id === workspaceView)?.title}
                      </div>
                      <div className="mt-1">
                        {workspaceViews.find((view) => view.id === workspaceView)?.countLabel}
                      </div>
                    </div>
                  </div>

                  <div className="mt-5 grid gap-3 lg:grid-cols-3">
                    {workspaceViews.map((view) => {
                      const Icon = view.icon;
                      const isActive = workspaceView === view.id;
                      return (
                        <button
                          key={view.id}
                          type="button"
                          onClick={() => setWorkspaceView(view.id)}
                          aria-pressed={isActive}
                          aria-describedby={workspaceHeadingId}
                          className={`rounded-[1.5rem] border p-4 text-left transition ${
                            isActive
                              ? 'border-health-green bg-health-green/10 shadow-sm'
                              : 'border-slate-200 bg-white hover:border-health-green/30'
                          }`}
                        >
                          <div className="flex items-start justify-between gap-3">
                            <div className={`rounded-2xl p-2.5 ${isActive ? 'bg-health-green text-white' : 'bg-slate-100 text-slate-700'}`}>
                              <Icon className="h-4 w-4" />
                            </div>
                            <span className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
                              {view.countLabel}
                            </span>
                          </div>
                          <div className="mt-4 text-base font-bold text-slate-900">{view.title}</div>
                          <p className="mt-1 text-sm leading-6 text-slate-600">{view.description}</p>
                        </button>
                      );
                    })}
                  </div>

                  <div className="mt-5 flex flex-wrap gap-2">
                    <a
                      href={`#${sectionIds.filters}`}
                      className="rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                    >
                      {isAr ? 'الفلاتر' : 'Filters'}
                    </a>
                    <a
                      href={`#${sectionIds.results}`}
                      className="rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                    >
                      {isAr ? 'النتائج' : 'Results'}
                    </a>
                    <a
                      href={`#${sectionIds.systems}`}
                      className="rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                    >
                      {isAr ? 'الأنظمة' : 'Systems'}
                    </a>
                    <a
                      href={`#${sectionIds.schedule}`}
                      className="rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                    >
                      {isAr ? 'الخطة الأسبوعية' : 'Weekly plan'}
                    </a>
                  </div>
                </section>

                {workspaceView === 'browse' && (
                  <>
                    <section id={sectionIds.results} className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                      <h2 className="text-xl font-bold text-slate-900">
                        {isAr ? 'نتائج التمارين المفلترة' : 'Filtered exercise results'}
                      </h2>
                      <p className="mt-2 text-sm leading-7 text-slate-600">
                        {isAr
                          ? 'ابدأ بالعضلة المستهدفة أولًا، ثم ضيّق النتائج حسب الهدف والمعدات حتى تبقى القائمة مناسبة وسهلة المراجعة.'
                          : 'Filter by anatomy first, then refine by training goal and equipment so the list stays relevant for both general gym use and movement-aware coaching.'}
                      </p>

                      <div className="mt-5 grid gap-3 sm:grid-cols-3">
                        <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                          <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
                            <Sparkles className="h-4 w-4 text-health-green" />
                            <span>{isAr ? 'مناسب للمبتدئين' : 'Beginner ready'}</span>
                          </div>
                          <div className="mt-3 text-2xl font-bold text-slate-900">{totalBeginnerExercises}</div>
                          <p className="mt-1 text-sm text-slate-600">
                            {isAr ? 'خيارات سهلة للبدء أو للعودة التدريجية.' : 'Lower-complexity options for starting or returning.'}
                          </p>
                        </div>

                        <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                          <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
                            <Flame className="h-4 w-4 text-health-green" />
                            <span>{isAr ? 'تمارين قوة' : 'Strength focus'}</span>
                          </div>
                          <div className="mt-3 text-2xl font-bold text-slate-900">{totalStrengthExercises}</div>
                          <p className="mt-1 text-sm text-slate-600">
                            {isAr ? 'تمارين مركبة ومباشرة لتطوير الأداء والقوة.' : 'Compound and direct options for performance-driven blocks.'}
                          </p>
                        </div>

                        <div className="rounded-2xl border border-white/70 bg-white/80 p-4">
                          <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
                            <CalendarRange className="h-4 w-4 text-health-green" />
                            <span>{isAr ? 'معدات متاحة' : 'Equipment range'}</span>
                          </div>
                          <div className="mt-3 text-2xl font-bold text-slate-900">{totalEquipmentOptions}</div>
                          <p className="mt-1 text-sm text-slate-600">
                            {isAr ? 'عدد أنواع المعدات المتوافقة مع الفلاتر الحالية.' : 'Distinct equipment types available under the current filters.'}
                          </p>
                        </div>
                      </div>
                    </section>

                    <section className="grid gap-4 md:grid-cols-3">
                      <Link
                        to={navigationPaths.dashboard(lang)}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'تابع تقدمك' : 'Track your progress'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'اربط تمارينك بالنتائج والقياسات داخل لوحة المتابعة.' : 'Connect your exercise choices to your saved results in the dashboard.'}
                        </p>
                      </Link>
                      <Link
                        to={navigationPaths.injuries(lang)}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'راجع الإصابات' : 'Review injury protocols'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'إذا كان عندك ألم أو مرحلة تأهيل، افتح بروتوكولات الإصابات قبل اختيار التمرين.' : 'If you are managing pain or rehab, open the injury library before choosing exercises.'}
                        </p>
                      </Link>
                      <Link
                        to={navigationPaths.diets(lang)}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'ادعم التمرين بالتغذية' : 'Support training with nutrition'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'اختيار النظام الغذائي المناسب يساعدك على الاستشفاء والأداء.' : 'Pair your training with the right diet strategy for recovery and performance.'}
                        </p>
                      </Link>
                    </section>

                    {filteredExercises.length === 0 ? (
                      <div className="rounded-[2rem] border border-dashed border-slate-200 bg-slate-50 px-6 py-14 text-center">
                        <h2 className="text-2xl font-bold text-slate-900">
                          {isAr ? 'لا توجد تمارين مطابقة' : 'No exercises found'}
                        </h2>
                        <p className="mt-3 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'جرّب توسيع الفلاتر قليلًا مثل العضلة أو المستوى أو المعدات. أحيانًا الدمج الضيق جدًا يقلل النتائج بشكل مقصود.'
                            : 'Try broadening the muscle, sub-muscle, level, or equipment filters. Very narrow combinations are useful, but they can intentionally reduce the list.'}
                        </p>
                      </div>
                    ) : (
                      <div className="grid gap-5 md:grid-cols-2">
                        {filteredExercises.map((exercise) => (
                          <ExerciseCard
                            key={`${exercise.mainMuscle}-${exercise.name}`}
                            exercise={exercise}
                            isAr={isAr}
                            searchQuery={filters.search}
                          />
                        ))}
                      </div>
                    )}
                  </>
                )}

                {workspaceView === 'systems' && (
                  <section id={sectionIds.systems} className="rounded-[1.5rem] border border-slate-200 bg-[linear-gradient(180deg,rgba(248,250,252,0.98),rgba(255,255,255,0.98))] p-5">
                    <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                      <div>
                        <h2 className="text-xl font-bold text-slate-900">
                          {isAr ? 'أنظمة تمرين جاهزة' : 'Ready training systems'}
                        </h2>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'هذه أنظمة متنوعة مرتبطة بالهدف والمعدات والمستوى الحالي، ومبنية على تمارين موجودة فعليًا داخل الدليل مع مجموعات وتكرارات وراحة واضحة.'
                            : 'These systems are tied to real exercises already listed in the finder, with actual sets, reps, rest, and weekly structure.'}
                        </p>
                      </div>

                      <button
                        type="button"
                        onClick={resetFilters}
                        className="inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-health-green/30 hover:text-health-green"
                      >
                        {isAr ? 'إعادة ضبط الفلاتر' : 'Reset filters'}
                      </button>
                    </div>

                    <div className="mt-5 grid gap-4 xl:grid-cols-2">
                      {recommendedSystems.map((system) => (
                        <TrainingSystemCard key={system.id} system={system} isAr={isAr} />
                      ))}
                    </div>
                  </section>
                )}

                {workspaceView === 'schedule' && (
                  <>
                    <section id={sectionIds.schedule} className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                      <div className="max-w-3xl">
                        <h2 className="text-xl font-bold text-slate-900">
                          {isAr ? 'جدول أسبوعي مقترح' : 'Suggested weekly schedule'}
                        </h2>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'هذه جداول تنفيذية حقيقية داخل الصفحة، وكل يوم مرتبط بتمارين محددة موجودة في قاعدة التمارين وليس مجرد عرض شكلي أو Demo.'
                            : 'These are executable weekly plans, and each day is tied to named exercises that already exist in the exercise library rather than placeholder demo content.'}
                        </p>
                      </div>

                      <div className="mt-5 grid gap-4 xl:grid-cols-2">
                        {weeklyPlans.map(({system, plan}) => (
                          <WeeklyPlanCard
                            key={`${system.id}-weekly-plan`}
                            title={system.title}
                            titleAr={system.titleAr}
                            plan={plan}
                            isAr={isAr}
                            lang={lang}
                          />
                        ))}
                      </div>
                    </section>

                    <section className="grid gap-4 md:grid-cols-3">
                      <Link
                        to={navigationPaths.dashboard(lang)}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'تابع تقدمك' : 'Track your progress'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'اربط الجدول الأسبوعي بلوحة المتابعة لتراقب الالتزام والتحسن.' : 'Connect your schedule to the dashboard so you can track adherence and progress.'}
                        </p>
                      </Link>
                      <button
                        type="button"
                        onClick={() => setWorkspaceView('systems')}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 text-left transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'ارجع للأنظمة' : 'Back to systems'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'قارن بين أكثر من نظام قبل اعتماد الجدول النهائي.' : 'Compare system structures again before locking in a weekly schedule.'}
                        </p>
                      </button>
                      <button
                        type="button"
                        onClick={() => setWorkspaceView('browse')}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 text-left transition hover:border-health-green/30 hover:bg-health-green/5"
                      >
                        <div className="text-sm font-bold text-slate-900">{isAr ? 'راجع التمارين' : 'Review exercises'}</div>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr ? 'افتح قائمة التمارين لو أردت تبديل الحركات أو التأكد من تفاصيل التنفيذ.' : 'Open the exercise list if you want to swap movements or confirm exercise details.'}
                        </p>
                      </button>
                    </section>
                  </>
                )}

                <section className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                  <div className="max-w-3xl">
                    <h2 className="text-xl font-bold text-slate-900">
                      {isAr ? 'أسئلة شائعة عن اختيار التمارين' : 'Exercise finder FAQ'}
                    </h2>
                    <div className="mt-4 space-y-4">
                      <div className="rounded-2xl border border-slate-200 bg-white p-4">
                        <h3 className="font-semibold text-slate-900">
                          {isAr ? 'كيف أختار التمرين المناسب لكل عضلة؟' : 'How do I choose the right exercise for each muscle group?'}
                        </h3>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'ابدأ باختيار العضلة الأساسية، ثم ضيق النتائج بالمعدات والمستوى وهدف التمرين. بعد ذلك راجع كروت التمارين أو تبويب الأنظمة الجاهزة لبناء جلسة كاملة.'
                            : 'Start with the main muscle, then narrow by equipment, level, and training goal. After that, review the exercise cards or the ready systems tab to build a full session.'}
                        </p>
                      </div>
                      <div className="rounded-2xl border border-slate-200 bg-white p-4">
                        <h3 className="font-semibold text-slate-900">
                          {isAr ? 'هل أقدر أستخدم الصفحة لو عندي معدات محدودة؟' : 'Can I use this page with limited equipment?'}
                        </h3>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'نعم، استخدم فلتر المعدات لاختيار وزن الجسم أو الدمبل أو الباند أو الأجهزة، وستظهر لك التمارين والأنظمة المناسبة لما هو متاح فعليًا.'
                            : 'Yes. Use the equipment filter to switch between bodyweight, dumbbell, band, machine, or barbell options and the list will adapt to what you actually have.'}
                        </p>
                      </div>
                      <div className="rounded-2xl border border-slate-200 bg-white p-4">
                        <h3 className="font-semibold text-slate-900">
                          {isAr ? 'هل الصفحة مناسبة للبحث عن تمارين صدر أو ظهر أو رجل؟' : 'Is this page good for finding chest, back, or leg exercises?'}
                        </h3>
                        <p className="mt-2 text-sm leading-7 text-slate-600">
                          {isAr
                            ? 'نعم، يوجد مسارات ثابتة وصفحات فرعية مثل الصدر والظهر والرجل والكتف والذراع والجذع، وده يسهل الوصول للمحتوى المناسب للمستخدم ولمحركات البحث.'
                            : 'Yes. The page supports fixed subpaths like chest, back, legs, shoulders, arms, and core, which makes it easier for users and search engines to reach focused content.'}
                        </p>
                      </div>
                    </div>
                  </div>
                </section>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}

export default ExerciseFinder;


