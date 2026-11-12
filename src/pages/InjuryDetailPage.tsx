import {lazy, Suspense, useEffect, useState} from 'react';
import {Activity, AlertTriangle, ArrowRight, CheckCircle2, Clock3, LockKeyhole, Pill, ShieldAlert, Sparkles, Stethoscope} from 'lucide-react';
import {Link, Navigate, useParams} from 'react-router-dom';
import Seo from '../components/seo/Seo';
import {getCurrentUser, isSupabaseConfigured, onSupabaseAuthChange, type User} from '../lib/supabase';
import type {InjuryPhase, InjuryProtocol} from '../services/injuryDatabase';
import {getInjuryExerciseLinks} from '../services/injuryExerciseLinks';
import {getNutritionGoalMatches} from '../services/injuryNutritionMatcher';
import {getInjuryRehabLinks} from '../services/injuryRehabLinks';
import {translateActivityContext, translateInjury} from '../services/injuryI18n';
import {
  getCatalogInjuries,
  getInjuryProtocolBySlugWithFallback,
  type InjuryCatalogEntry,
  type InjuryCatalogSource,
} from '../services/injuryService';
import {INJURY_CANONICAL_PARENT_MAP} from '../services/seoAliases';
import {decodeMojibake} from '../services/textEncoding';
import {buildAbsoluteUrl} from '../services/site';
import {
  injuryBadge,
  injuryHeading,
  injuryHeroShell,
  injuryHeroTitle,
  injuryPanel,
  injuryPanelInset,
  injuryPanelMuted,
  injuryStatCard,
  injurySubtle,
  injuryTitle,
} from './injuryPageStyles';
import PageLayout from './PageLayout';
import {navigationPaths} from '../utils/langUrlHelper';
import usePreferredLang from './usePreferredLang';
import {useMyRecovery} from '../hooks/useMyRecovery';

const DrugNutrientChecker = lazy(() => import('../components/ai/DrugNutrientChecker'));

function normalizeCopy(value: string) {
  return decodeMojibake(value);
}

function normalizeStringList(items?: string[] | null) {
  return (items || []).map(normalizeCopy).filter(Boolean);
}

function buildPath(id: string, lang: string) {
  return `/${lang}/injuries/${id.replace(/_/g, '-')}`;
}

function getSourceMeta(source: InjuryCatalogSource, isAr: boolean) {
  if (source === 'supabase') {
    return {
      label: isAr ? 'متصل بقاعدة البيانات' : 'Live Supabase data',
      description: isAr
        ? 'الصفحة معروضة من نفس بيانات الباك إند الحالية.'
        : 'This page is rendering from the current backend protocol record.',
      className:
        'border-emerald-200 bg-emerald-50 text-emerald-800 dark:border-emerald-500/40 dark:bg-emerald-950/50 dark:text-emerald-200',
    };
  }

  if (source === 'generated') {
    return {
      label: isAr ? 'بروتوكول مستورد' : 'Imported generated protocol',
      description: isAr
        ? 'تم استخدام البروتوكول المستورد مع تغذية وربط محليين عند الحاجة.'
        : 'The imported protocol is being used, with local nutrition enrichment when needed.',
      className:
        'border-sky-200 bg-sky-50 text-sky-800 dark:border-sky-500/40 dark:bg-sky-950/50 dark:text-sky-200',
    };
  }

  return {
    label: isAr ? 'وضع احتياطي محلي' : 'Local fallback',
    description: isAr
      ? 'تعذر الوصول للسجل البعيد، لذلك تم استخدام نسخة محلية للحفاظ على تماسك الصفحة.'
      : 'The remote record was unavailable, so the page is using the local fallback to stay consistent.',
    className:
      'border-amber-200 bg-amber-50 text-amber-900 dark:border-amber-500/40 dark:bg-amber-950/50 dark:text-amber-200',
  };
}

function renderBulletList(items: string[], tone: 'neutral' | 'success' | 'warning' | 'accent') {
  const dotClass =
    tone === 'success'
      ? 'text-emerald-500'
      : tone === 'warning'
        ? 'text-amber-500'
        : tone === 'accent'
          ? 'text-health-green'
          : 'text-slate-400';

  return (
    <ul className="space-y-3 text-sm text-slate-700 dark:text-slate-200">
      {items.map((item) => (
        <li key={item} className="flex items-start gap-3">
          <span className={`mt-1 text-base leading-none ${dotClass}`}>•</span>
          <span className="leading-7">{normalizeCopy(item)}</span>
        </li>
      ))}
    </ul>
  );
}

function PhaseSummaryCard({
  phase,
  index,
  active,
  isAr,
  locked,
  onClick,
}: {
  phase: InjuryPhase;
  index: number;
  active: boolean;
  isAr: boolean;
  locked: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`w-full rounded-[1.5rem] border px-4 py-4 text-start transition ${
        active
          ? 'border-health-green bg-health-green text-white shadow-lg shadow-health-green/20'
          : 'border-slate-200 bg-white text-slate-800 hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:hover:bg-health-green/10'
      }`}
    >
      <div className="flex items-center justify-between gap-3">
        <div className={`text-xs font-bold uppercase tracking-[0.18em] ${active ? 'text-white/80' : 'text-slate-400'}`}>
          {isAr ? `المرحلة ${index + 1}` : `Phase ${index + 1}`}
        </div>
        <div className="flex items-center gap-2">
          {locked ? <LockKeyhole className={`h-3.5 w-3.5 ${active ? 'text-white/80' : 'text-amber-500'}`} /> : null}
          <div className={`text-xs ${active ? 'text-white/80' : 'text-slate-500'}`}>{normalizeCopy(phase.duration)}</div>
        </div>
      </div>
      <div className="mt-2 text-base font-black">{normalizeCopy(phase.label)}</div>
      <div className={`mt-2 text-sm leading-6 ${active ? 'text-white/90' : 'text-slate-600 dark:text-slate-300'}`}>
        {phase.focus ? normalizeCopy(phase.focus) : normalizeCopy(phase.goals[0] || '')}
      </div>
    </button>
  );
}

function LockedProtocolGate({
  lang,
  isAr,
}: {
  lang: 'en' | 'ar';
  isAr: boolean;
}) {
  return (
    <div className="absolute inset-0 z-10 flex items-center justify-center rounded-[1.8rem] bg-slate-950/45 p-5 backdrop-blur-[2px]">
      <div className="w-full max-w-xl rounded-[1.8rem] border border-white/20 bg-white/95 p-6 text-center shadow-2xl shadow-slate-900/20">
        <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-amber-100 text-amber-700">
          <LockKeyhole className="h-5 w-5" />
        </div>
        <h3 className="mt-4 text-xl font-black text-slate-950">
          {isAr ? 'افتح باقي البروتوكول بالحساب' : 'Unlock the rest of this protocol'}
        </h3>
        <p className="mt-3 text-sm leading-7 text-slate-600">
          {isAr
            ? 'أول مرحلتين ظاهرين بالكامل. باقي المراحل ومحتوى التغذية متاحين بعد إنشاء حساب أو تسجيل الدخول.'
            : 'The first two phases stay fully visible. The remaining phases and nutrition guidance unlock after signup or sign in.'}
        </p>
        <div className="mt-5 flex flex-wrap items-center justify-center gap-3">
          <Link
            to={`${navigationPaths.auth(lang)}?mode=signup`}
            className="inline-flex items-center justify-center rounded-2xl bg-slate-950 px-4 py-2.5 text-sm font-bold text-white transition hover:bg-slate-800"
          >
            {isAr ? 'إنشاء حساب' : 'Create account'}
          </Link>
          <Link
            to={`${navigationPaths.auth(lang)}?mode=signin`}
            className="inline-flex items-center justify-center rounded-2xl border border-slate-300 bg-white px-4 py-2.5 text-sm font-bold text-slate-700 transition hover:border-health-green/40 hover:text-slate-950"
          >
            {isAr ? 'تسجيل الدخول' : 'Sign in'}
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function InjuryDetailPage() {
  const {slug = ''} = useParams();
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const [injury, setInjury] = useState<InjuryProtocol | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [catalogInjuries, setCatalogInjuries] = useState<InjuryCatalogEntry[]>([]);
  const [protocolSource, setProtocolSource] = useState<InjuryCatalogSource>('local');
  const [activeTab, setActiveTab] = useState<number>(0);
  const {isInjuryTracked, startJourney, getJourneyBySlug} = useMyRecovery();

  useEffect(() => {
    let active = true;

    const load = async () => {
      setLoading(true);
      const [result, catalog] = await Promise.all([
        getInjuryProtocolBySlugWithFallback(slug, lang),
        getCatalogInjuries(lang),
      ]);

      if (!active) return;
      setInjury(result.injury);
      setProtocolSource(result.source);
      setCatalogInjuries(catalog.injuries);
      setLoading(false);
    };

    void load();
    return () => {
      active = false;
    };
  }, [lang, slug]);

  useEffect(() => {
    let mounted = true;

    const loadUser = async () => {
      if (!isSupabaseConfigured) return;
      try {
        const currentUser = await getCurrentUser();
        if (mounted) setUser(currentUser);
      } catch {
        if (mounted) setUser(null);
      }
    };

    void loadUser();

    const subscription = isSupabaseConfigured
      ? onSupabaseAuthChange((_, session) => {
          if (!mounted) return;
          setUser(session?.user || null);
        }).data.subscription
      : null;

    return () => {
      mounted = false;
      subscription?.unsubscribe();
    };
  }, []);

  useEffect(() => {
    const phaseCount = injury?.phases?.length ?? 0;
    if (injury && activeTab > phaseCount) {
      setActiveTab(0);
    }
  }, [injury, activeTab]);

  if (!injury && !loading) {
    return <Navigate to={`/${lang}/injuries`} replace />;
  }

  if (!injury) {
    return (
      <PageLayout title={isAr ? 'جارٍ تحميل البروتوكول' : 'Loading protocol'} hideTitle wide flat>
        <div className={`${injuryPanelMuted} text-sm text-slate-500 dark:text-slate-400`}>
          {isAr ? 'جارٍ تحميل تفاصيل الإصابة...' : 'Loading injury details...'}
        </div>
      </PageLayout>
    );
  }

  const translated = translateInjury(
    {
      slugOrId: injury.id,
      nameEn: injury.name,
      category: injury.category,
      regionEn: injury.bodyRegion,
      overviewEn: injury.overview || '',
    },
    lang,
  );
  const injuryDisplayName = translated.name;
  const categoryDisplay = translated.category;
  const bodyRegionDisplay = translated.bodyRegion;
  const localizedOverview = translated.overview;
  const phases = injury.phases || [];
  const redFlags = normalizeStringList(injury.redFlags);
  const commonIn = (injury.commonIn || [])
    .map((item) => translateActivityContext(normalizeCopy(item), lang))
    .filter(Boolean);
  const medicationNotes = [...normalizeStringList(injury.safetyNotes?.medications), ...normalizeStringList(injury.safetyNotes?.supplements)];
  const symptoms = normalizeStringList(injury.pageContent?.symptoms);
  const rehabNotes = normalizeStringList(injury.pageContent?.rehabNotes);
  const isNutritionTab = activeTab === phases.length;
  const currentPhase = !isNutritionTab ? phases[activeTab] : null;
  const sourceMeta = getSourceMeta(protocolSource, isAr);
  const totalExercisePlans = phases.reduce((count, phase) => count + (phase.exercisePlans?.length || 0), 0);
  const phasesWithNutrition = phases.filter(
    (phase) => phase.nutritionFocus?.length || phase.recommendedFoods?.length || phase.supplements?.length,
  ).length;
  const phasesWithExercises = phases.filter((phase) => (phase.exercisePlans?.length || 0) > 0).length;
  const isLockedPhase = activeTab >= 2 && activeTab < phases.length && !user;
  const isLockedNutritionTab = activeTab === phases.length && phases.length > 2 && !user;
  const showLockedOverlay = isLockedPhase || isLockedNutritionTab;
  const nutritionGoalMatches = currentPhase ? getNutritionGoalMatches(injury, currentPhase).slice(0, 4) : [];

  const isTracked = isInjuryTracked(injury.id);
  const activeJourneyRecord = getJourneyBySlug(injury.id);

  const relatedInjuries = catalogInjuries
    .filter((item) => item.id !== injury.id)
    .filter((item) => item.category === categoryDisplay || item.bodyRegion === bodyRegionDisplay)
    .slice(0, 6);

  const relatedExerciseLinks = getInjuryExerciseLinks({
    injuryId: injury.id,
    bodyRegion: injury.bodyRegion,
    lang,
  });

  const relatedRehabLinks = getInjuryRehabLinks({
    injuryId: injury.id,
    bodyRegion: injury.bodyRegion,
    lang,
  });

  const askPhasePrompt = isAr
    ? `أنا في مرحلة التعافي من ${injuryDisplayName}. اشرح لي ماذا أركز عليه الآن، ما التمارين المناسبة، ومتى أستطيع الانتقال للمرحلة التالية؟`
    : `I am recovering from ${injuryDisplayName}. Explain what I should focus on now, which exercises fit this phase, and when I can move to the next phase.`;
  const askPhaseLink = `/${lang}/assistant?prompt=${encodeURIComponent(askPhasePrompt)}`;

  const faqItems =
    injury.pageContent?.faq?.length
      ? injury.pageContent.faq
      : [
          {
            q: isAr ? 'ما هو الهدف الأساسي من هذا البروتوكول؟' : 'What is the main goal of this protocol?',
            a: isAr
              ? 'التدرج الآمن في التحميل وإعادة الأنسجة لطبيعتها لتجنب الإصابة مرة أخرى.'
              : 'Gradual safe loading and restoring tissue capacity to prevent re-injury.',
          },
          {
            q: isAr ? 'متى أراجع طبيبًا؟' : 'When should I see a doctor?',
            a: isAr
              ? 'إذا زاد الألم بشكل حاد، أو ظهر تورم مفاجئ، أو عدم استقرار ملحوظ في المفصل.'
              : 'If you experience sharp pain, sudden swelling, or noticeable joint instability.',
          },
        ];

  const canonicalParentId = INJURY_CANONICAL_PARENT_MAP[injury.id];
  const canonicalInjuryId =
    canonicalParentId && catalogInjuries.some((item) => item.id === canonicalParentId)
      ? canonicalParentId
      : injury.id;
  const canonicalPath = buildPath(canonicalInjuryId, lang);
  const labels = {
    title: isAr ? `بروتوكول ${injuryDisplayName}` : `${injuryDisplayName} Recovery Protocol`,
    description: isAr
      ? `خطة علاج وتأهيل متدرجة لـ ${injuryDisplayName} تشمل التمارين، التغذية، والمحاذير في كل مرحلة.`
      : `A phased rehab plan for ${injuryDisplayName} including exercises, nutrition support, and safety guidance.`,
  } as const;

  const hreflangs = [
    {lang: 'en', href: buildAbsoluteUrl(buildPath(canonicalInjuryId, 'en'))},
    {lang: 'ar', href: buildAbsoluteUrl(buildPath(canonicalInjuryId, 'ar'))},
  ];
  const canonicalUrl = buildAbsoluteUrl(canonicalPath);
  const structuredData = [
    {
      id: `injury-page-${canonicalInjuryId}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'MedicalWebPage',
        name: labels.title,
        description: labels.description,
        url: canonicalUrl,
        inLanguage: lang,
        about: {
          '@type': 'MedicalCondition',
          name: injuryDisplayName,
          bodyLocation: bodyRegionDisplay,
        },
      },
    },
    {
      id: `injury-breadcrumb-${canonicalInjuryId}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'BreadcrumbList',
        itemListElement: [
          {
            '@type': 'ListItem',
            position: 1,
            name: isAr ? 'الرئيسية' : 'Home',
            item: buildAbsoluteUrl(`/${lang}/`),
          },
          {
            '@type': 'ListItem',
            position: 2,
            name: isAr ? 'الإصابات' : 'Injuries',
            item: buildAbsoluteUrl(navigationPaths.injuries(lang)),
          },
          {
            '@type': 'ListItem',
            position: 3,
            name: injuryDisplayName,
            item: canonicalUrl,
          },
        ],
      },
    },
    {
      id: `injury-faq-${canonicalInjuryId}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'FAQPage',
        mainEntity: faqItems.map((item) => ({
          '@type': 'Question',
          name: normalizeCopy(item.q),
          acceptedAnswer: {
            '@type': 'Answer',
            text: normalizeCopy(item.a),
          },
        })),
      },
    },
  ];

  return (
    <>
      <Seo
        title={labels.title}
        description={labels.description}
        canonicalPath={canonicalPath}
        structuredData={structuredData}
        hreflangs={hreflangs}
      />
      <PageLayout title={labels.title} hideTitle wide flat>
        <div className="space-y-8 not-prose">
          <section className={injuryHeroShell}>
            <div className="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
              <div className="space-y-5">
                <div className={`inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] ${sourceMeta.className}`}>
                  <Stethoscope className="h-3.5 w-3.5" />
                  <span>{sourceMeta.label}</span>
                </div>

                <div>
                  <h1 className={injuryHeroTitle}>{injuryDisplayName}</h1>
                  <p className="mt-3 max-w-3xl text-sm leading-7 text-slate-600 dark:text-slate-300 sm:text-base">
                    {normalizeCopy(localizedOverview)}
                  </p>
                </div>

                <div className="flex flex-wrap gap-2">
                  <span className={injuryBadge}>{categoryDisplay}</span>
                  <span className={injuryBadge}>{bodyRegionDisplay}</span>
                  <span className={injuryBadge}>
                    {phases.length} {isAr ? 'مراحل' : 'phases'}
                  </span>
                </div>

                <div className="flex flex-wrap items-center gap-3 pt-1">
                  {isTracked ? (
                    <Link
                      to={navigationPaths.dashboard(lang)}
                      className="inline-flex items-center gap-2 rounded-2xl bg-emerald-600 px-5 py-3 text-sm font-bold text-white shadow-md transition hover:bg-emerald-700"
                    >
                      <CheckCircle2 className="h-4 w-4" />
                      <span>
                        {isAr
                          ? `الإصابة قيد المتابعة (المرحلة ${activeJourneyRecord?.currentPhase || 1}) - افتح لوحة المتابعة`
                          : `Currently Tracking (Phase ${activeJourneyRecord?.currentPhase || 1}) - Open Dashboard`}
                      </span>
                    </Link>
                  ) : (
                    <button
                      type="button"
                      onClick={() => {
                        startJourney({
                          injurySlug: injury.id,
                          injuryName: injury.name,
                          injuryNameAr: injuryDisplayName,
                          bodyRegion: bodyRegionDisplay,
                          totalPhases: phases.length || 3,
                        });
                      }}
                      className="inline-flex items-center gap-2 rounded-2xl bg-health-green px-5 py-3 text-sm font-bold text-slate-950 shadow-md transition hover:bg-[#d3aa54]"
                    >
                      <Activity className="h-4 w-4" />
                      <span>
                        {isAr ? 'ابدأ خطة التعافي لهذه الإصابة في ملفي' : 'Track this Injury in My Recovery'}
                      </span>
                    </button>
                  )}
                </div>

                <div className="grid gap-3 sm:grid-cols-3">
                  <div className={injuryStatCard}>
                    <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'ملخص الخطة' : 'Plan focus'}</div>
                    <div className="mt-2 text-sm font-semibold leading-6 text-slate-700 dark:text-slate-200">
                      {normalizeCopy(injury.rehabSummary || (currentPhase?.focus || ''))}
                    </div>
                  </div>
                  <div className={injuryStatCard}>
                    <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'المخاطر المهمة' : 'Red flags'}</div>
                    <div className="mt-2 text-2xl font-black text-slate-900 dark:text-white">{redFlags.length}</div>
                  </div>
                  <div className={injuryStatCard}>
                    <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'مصدر الداتا' : 'Data source'}</div>
                    <div className="mt-2 text-sm font-semibold leading-6 text-slate-700 dark:text-slate-200">{sourceMeta.description}</div>
                  </div>
                </div>

                {commonIn.length > 0 ? (
                  <div>
                    <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
                      {isAr ? 'شائعة في' : 'Common in'}
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {commonIn.map((item) => (
                        <span key={item} className="rounded-full border border-health-green/20 bg-health-green/10 px-3 py-1 text-sm font-medium text-health-green-dark">
                          {item}
                        </span>
                      ))}
                    </div>
                  </div>
                ) : null}

                <div className="grid gap-3 sm:grid-cols-3">
                  <div className="rounded-[1.5rem] border border-slate-200 bg-slate-950 p-4 text-white shadow-lg shadow-slate-900/10">
                    <div className="text-xs font-bold uppercase tracking-[0.16em] text-white/50">{isAr ? 'التمارين المسجلة' : 'Logged exercises'}</div>
                    <div className="mt-2 text-3xl font-black">{totalExercisePlans}</div>
                    <div className="mt-2 text-sm text-white/70">
                      {isAr ? 'إجمالي التمارين التفصيلية عبر كل المراحل' : 'Detailed exercise entries across all phases'}
                    </div>
                  </div>
                  <div className={injuryStatCard}>
                    <div className={injurySubtle}>{isAr ? 'مراحل التمارين' : 'Exercise phases'}</div>
                    <div className="mt-2 text-3xl font-black text-slate-900 dark:text-white">{phasesWithExercises}</div>
                    <div className="mt-2 text-sm text-slate-500 dark:text-slate-400">
                      {isAr ? 'مراحل فيها وصف حركي عملي' : 'Phases with actionable exercise plans'}
                    </div>
                  </div>
                  <div className={injuryStatCard}>
                    <div className={injurySubtle}>{isAr ? 'مراحل التغذية' : 'Nutrition phases'}</div>
                    <div className="mt-2 text-3xl font-black text-slate-900 dark:text-white">{phasesWithNutrition}</div>
                    <div className="mt-2 text-sm text-slate-500 dark:text-slate-400">
                      {isAr ? 'مراحل فيها دعم غذائي أو مكملات' : 'Phases with nutrition or supplement guidance'}
                    </div>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <div className="rounded-[1.8rem] border border-slate-200 bg-slate-950 p-6 text-white shadow-xl shadow-slate-900/10">
                  <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-white/60">
                    <Sparkles className="h-4 w-4 text-health-green" />
                    <span>{isAr ? 'المرحلة الحالية' : 'Current focus'}</span>
                  </div>
                  <div className="mt-4 text-2xl font-black">
                    {isNutritionTab
                      ? isAr
                        ? 'التغذية والمكملات'
                        : 'Nutrition and supplements'
                      : currentPhase
                        ? normalizeCopy(currentPhase.label)
                        : ''}
                  </div>
                  <div className="mt-3 text-sm leading-7 text-white/75">
                    {isNutritionTab
                      ? isAr
                        ? 'راجع نقاط التغذية، الوجبات، والمكملات الآمنة خلال التعافي.'
                        : 'Review recovery nutrition, meal examples, and supplement safety.'
                      : normalizeCopy(currentPhase?.focus || currentPhase?.goals[0] || '')}
                  </div>
                  <div className="mt-5 flex flex-wrap gap-3">
                    <Link
                      to={askPhaseLink}
                      className="inline-flex items-center gap-2 rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white transition hover:bg-health-green-dark"
                    >
                      {isAr ? 'اسأل المساعد' : 'Ask the assistant'}
                      <ArrowRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
                    </Link>
                    <button
                      type="button"
                      onClick={() => setActiveTab(phases.length)}
                      className="inline-flex items-center gap-2 rounded-2xl border border-white/15 bg-white/5 px-4 py-3 text-sm font-bold text-white/90 transition hover:bg-white/10"
                    >
                      <Pill className="h-4 w-4" />
                      {isAr ? 'افتح التغذية' : 'Open nutrition'}
                    </button>
                  </div>
                </div>

                {redFlags.length > 0 ? (
                  <div className="rounded-[1.6rem] border border-amber-200 bg-amber-50 p-5 shadow-sm dark:border-amber-500/40 dark:bg-amber-950/50">
                    <div className="mb-3 flex items-center gap-2 text-sm font-black text-amber-900 dark:text-amber-200">
                      <AlertTriangle className="h-4 w-4" />
                      <span>{isAr ? 'علامات تستدعي الانتباه' : 'Watch-outs'}</span>
                    </div>
                    {renderBulletList(redFlags, 'warning')}
                  </div>
                ) : null}
              </div>
            </div>
          </section>

          <section className="grid gap-6 xl:grid-cols-[0.32fr_0.68fr]">
            <aside className="space-y-4 xl:sticky xl:top-24 xl:self-start">
              <div className={`${injuryPanel} p-4`}>
                <div className={`mb-3 ${injuryHeading}`}>{isAr ? 'مراحل التعافي' : 'Recovery phases'}</div>
                <div className="space-y-3">
                  {phases.map((phase, index) => (
                    <PhaseSummaryCard
                      key={phase.id}
                      phase={phase}
                      index={index}
                      active={activeTab === index}
                      isAr={isAr}
                      locked={index >= 2 && !user}
                      onClick={() => setActiveTab(index)}
                    />
                  ))}
                  <button
                    type="button"
                    onClick={() => setActiveTab(phases.length)}
                    className={`w-full rounded-[1.5rem] border px-4 py-4 text-start transition ${
                      isNutritionTab
                        ? 'border-amber-400 bg-amber-500 text-white shadow-lg shadow-amber-500/20'
                        : 'border-slate-200 bg-white text-slate-800 hover:border-amber-300 hover:bg-amber-50 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:hover:bg-amber-950/40'
                    }`}
                  >
                    <div className={`text-xs font-bold uppercase tracking-[0.18em] ${isNutritionTab ? 'text-white/80' : 'text-slate-400'}`}>
                      {isAr ? 'قسم إضافي' : 'Bonus section'}
                    </div>
                    <div className="mt-2 text-base font-black">{isAr ? 'التغذية والمكملات' : 'Nutrition and supplements'}</div>
                  </button>
                </div>
              </div>

              {(symptoms.length > 0 || rehabNotes.length > 0) && (
                <div className={injuryPanel}>
                  <div className={`mb-4 ${injuryHeading}`}>{isAr ? 'لمحة سريعة' : 'Quick context'}</div>
                  {symptoms.length > 0 ? (
                    <div className="mb-5">
                      <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'الأعراض' : 'Symptoms'}</div>
                      {renderBulletList(symptoms.slice(0, 4), 'neutral')}
                    </div>
                  ) : null}
                  {rehabNotes.length > 0 ? (
                    <div>
                      <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'ملاحظات التأهيل' : 'Rehab notes'}</div>
                      {renderBulletList(rehabNotes.slice(0, 3), 'accent')}
                    </div>
                  ) : null}
                </div>
              )}
            </aside>

            <div className="space-y-6">
              {currentPhase ? (
                <>
                  <section className={`${injuryPanel} relative overflow-hidden`}>
                    <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                      <div className="flex flex-wrap items-center justify-between gap-4">
                      <div>
                        <div className="text-xs font-bold uppercase tracking-[0.18em] text-slate-400">
                          {isAr ? `المرحلة ${activeTab + 1}` : `Phase ${activeTab + 1}`}
                        </div>
                        <h2 className="mt-2 text-2xl font-black text-slate-900 dark:text-white">{normalizeCopy(currentPhase.label)}</h2>
                      </div>
                      <div className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-slate-50 px-4 py-2 text-sm font-semibold text-slate-700 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-200">
                        <Clock3 className="h-4 w-4 text-health-green" />
                        <span>{normalizeCopy(currentPhase.duration)}</span>
                      </div>
                    </div>

                    {currentPhase.focus ? (
                      <div className="mt-5 rounded-[1.5rem] border border-health-green/15 bg-health-green/5 p-4 text-sm leading-7 text-slate-700 dark:border-health-green/30 dark:bg-health-green/10 dark:text-slate-200">
                        {normalizeCopy(currentPhase.focus)}
                      </div>
                    ) : null}

                      <div className="mt-6 grid gap-4 md:grid-cols-3">
                      <div className={injuryPanelMuted}>
                        <div className="mb-3 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                          <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                          <span>{isAr ? 'الأهداف' : 'Goals'}</span>
                        </div>
                        {renderBulletList(currentPhase.goals.map(normalizeCopy), 'success')}
                      </div>
                      <div className={injuryPanelMuted}>
                        <div className="mb-3 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                          <AlertTriangle className="h-4 w-4 text-amber-500" />
                          <span>{isAr ? 'المحاذير' : 'Precautions'}</span>
                        </div>
                        {renderBulletList(
                          (currentPhase.cautions?.length ? currentPhase.cautions : [isAr ? 'لا توجد محاذير إضافية.' : 'No extra precautions.']).map(normalizeCopy),
                          'warning',
                        )}
                      </div>
                      <div className={injuryPanelMuted}>
                        <div className="mb-3 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                          <Activity className="h-4 w-4 text-health-green" />
                          <span>{isAr ? 'الانتقال للمرحلة التالية' : 'Progression markers'}</span>
                        </div>
                        {renderBulletList(
                          (currentPhase.progressionMarkers?.length
                            ? currentPhase.progressionMarkers
                            : [isAr ? 'حسب تقييم الأخصائي.' : 'Follow clinician guidance.']).map(normalizeCopy),
                          'accent',
                        )}
                      </div>
                    </div>
                    </div>
                    {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                  </section>

                  <section className={`${injuryPanel} relative overflow-hidden`}>
                    <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                      <Sparkles className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'التمارين العلاجية' : 'Therapeutic exercises'}</span>
                    </div>
                    <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                    {currentPhase.exercisePlans?.length ? (
                      <div className="grid gap-4">
                        {currentPhase.exercisePlans.map((plan, idx) => (
                          <div key={`${plan.label}-${idx}`} className={injuryPanelInset}>
                            <div className="flex flex-wrap items-start justify-between gap-3">
                              <div>
                                <div className="text-lg font-black text-slate-900 dark:text-white">{normalizeCopy(plan.label)}</div>
                                <div className="mt-2 flex flex-wrap gap-2">
                                  {plan.sets ? (
                                    <span className="rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200 dark:bg-slate-900 dark:text-slate-200 dark:ring-slate-700">
                                      {isAr ? 'الجرعة' : 'Dose'}: {normalizeCopy(plan.sets)}
                                    </span>
                                  ) : null}
                                  {plan.reps ? (
                                    <span className="rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200 dark:bg-slate-900 dark:text-slate-200 dark:ring-slate-700">
                                      {isAr ? 'العدّات' : 'Reps'}: {normalizeCopy(plan.reps)}
                                    </span>
                                  ) : null}
                                  {plan.rest ? (
                                    <span className="rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200 dark:bg-slate-900 dark:text-slate-200 dark:ring-slate-700">
                                      {isAr ? 'الراحة' : 'Rest'}: {normalizeCopy(plan.rest)}
                                    </span>
                                  ) : null}
                                  {plan.equipment ? (
                                    <span className="rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200 dark:bg-slate-900 dark:text-slate-200 dark:ring-slate-700">
                                      {isAr ? 'الأداة' : 'Equipment'}: {normalizeCopy(plan.equipment)}
                                    </span>
                                  ) : null}
                                </div>
                              </div>
                            </div>

                            {plan.cues?.length ? (
                              <div className="mt-4">
                                <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
                                  {isAr ? 'ملاحظات التنفيذ' : 'Execution cues'}
                                </div>
                                {renderBulletList(plan.cues.map(normalizeCopy), 'accent')}
                              </div>
                            ) : null}
                          </div>
                        ))}
                      </div>
                    ) : (
                      <div className="rounded-[1.6rem] border border-dashed border-slate-200 bg-slate-50 p-6 text-center text-sm text-slate-500">
                        {isAr ? 'لا توجد تمارين مفصلة مسجلة لهذه المرحلة بعد.' : 'No detailed exercises are recorded for this phase yet.'}
                      </div>
                    )}
                    </div>
                    {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                  </section>

                  <section className="grid gap-6 lg:grid-cols-2">
                    <div className={`${injuryPanel} relative overflow-hidden`}>
                      <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'تغذية هذه المرحلة' : 'Phase nutrition'}</div>
                      <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                      {nutritionGoalMatches.length ? (
                        <div className="mb-5">
                          <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
                            {isAr ? 'أهداف التعافي' : 'Recovery goals'}
                          </div>
                          <div className="grid gap-3">
                            {nutritionGoalMatches.map((goal) => (
                              <div key={goal.key} className={injuryPanelMuted}>
                                <div className="font-bold text-slate-900 dark:text-white">{goal.label}</div>
                                <p className="mt-2 text-sm leading-7 text-slate-700 dark:text-slate-300">{goal.reason}</p>
                              </div>
                            ))}
                          </div>
                        </div>
                      ) : null}
                      {currentPhase.nutritionFocus?.length ? (
                        <div className="mb-5">
                          <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'نقاط التركيز' : 'Focus points'}</div>
                          {renderBulletList(currentPhase.nutritionFocus.map(normalizeCopy), 'accent')}
                        </div>
                      ) : null}
                      {currentPhase.recommendedFoods?.length ? (
                        <div className="mb-5">
                          <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'أطعمة مقترحة' : 'Recommended foods'}</div>
                          {renderBulletList(currentPhase.recommendedFoods.map(normalizeCopy), 'success')}
                        </div>
                      ) : null}
                      {currentPhase.avoidFoods?.length ? (
                        <div>
                          <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'يفضل تقليل' : 'Best to reduce'}</div>
                          {renderBulletList(currentPhase.avoidFoods.map(normalizeCopy), 'warning')}
                        </div>
                      ) : null}
                      </div>
                      {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                    </div>

                    <div className={`${injuryPanel} relative overflow-hidden`}>
                      <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'الوجبات والمكملات' : 'Meals and supplements'}</div>
                      <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                      <div className="grid gap-3">
                        {currentPhase.meals.breakfast ? (
                          <div className={`${injuryPanelMuted} text-sm leading-7 text-slate-700 dark:text-slate-200`}>
                            <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'فطور:' : 'Breakfast:'}</span> {normalizeCopy(currentPhase.meals.breakfast)}
                          </div>
                        ) : null}
                        {currentPhase.meals.lunch ? (
                          <div className={`${injuryPanelMuted} text-sm leading-7 text-slate-700 dark:text-slate-200`}>
                            <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'غداء:' : 'Lunch:'}</span> {normalizeCopy(currentPhase.meals.lunch)}
                          </div>
                        ) : null}
                        {currentPhase.meals.dinner ? (
                          <div className={`${injuryPanelMuted} text-sm leading-7 text-slate-700 dark:text-slate-200`}>
                            <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'عشاء:' : 'Dinner:'}</span> {normalizeCopy(currentPhase.meals.dinner)}
                          </div>
                        ) : null}
                      </div>

                      {currentPhase.supplements?.length ? (
                        <div className="mt-5 border-t border-slate-100 pt-5">
                          <div className="mb-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{isAr ? 'مكملات داعمة' : 'Supportive supplements'}</div>
                          <div className="space-y-3">
                            {currentPhase.supplements.map((item) => (
                              <div key={`${item.name}-${item.dose}`} className={injuryPanelMuted}>
                                <div className="font-bold text-slate-900 dark:text-white">{normalizeCopy(item.name)}</div>
                                <div className="mt-1 text-sm text-slate-600">{normalizeCopy(item.dose)}</div>
                                <div className="mt-2 text-sm leading-7 text-slate-700">{normalizeCopy(item.reason)}</div>
                              </div>
                            ))}
                          </div>
                        </div>
                      ) : null}
                      </div>
                      {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                    </div>
                  </section>
                </>
              ) : (
                <section className="grid gap-6 lg:grid-cols-2">
                  <div className={`${injuryPanel} relative overflow-hidden`}>
                    <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                      <Pill className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'ملاحظات التغذية' : 'Nutrition notes'}</span>
                    </div>
                    <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                    {injury.pageContent?.nutritionNotes?.length ? (
                      renderBulletList(injury.pageContent.nutritionNotes.map(normalizeCopy), 'accent')
                    ) : (
                      <div className={`${injuryPanelMuted} text-sm text-slate-600 dark:text-slate-300`}>
                        {isAr ? 'حافظ على نظام غذائي متوازن وغني بالبروتين لدعم الاستشفاء.' : 'Maintain a balanced, protein-rich diet to support recovery.'}
                      </div>
                    )}
                    </div>
                    {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                  </div>

                  <div className={`${injuryPanel} relative overflow-hidden`}>
                    <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                      <ShieldAlert className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'السلامة الدوائية والمكملات' : 'Supplement safety'}</span>
                    </div>
                    <div className={showLockedOverlay ? 'pointer-events-none select-none blur-[5px]' : ''}>
                    {medicationNotes.length > 0 ? (
                      renderBulletList(medicationNotes, 'warning')
                    ) : (
                      <div className={`${injuryPanelMuted} text-sm text-slate-600 dark:text-slate-300`}>
                        {isAr ? 'لا توجد ملاحظات خاصة مسجلة لهذه الإصابة.' : 'No specific safety notes are recorded for this injury.'}
                      </div>
                    )}
                    <div className="mt-6 border-t border-slate-100 pt-6">
                      <div className="mb-3 text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
                        {isAr ? 'فحص سريع' : 'Quick checker'}
                      </div>
                      <Suspense fallback={<div className="text-sm text-slate-500">Loading...</div>}>
                        <DrugNutrientChecker lang={lang} embedded initialQuery="" />
                      </Suspense>
                    </div>
                    </div>
                    {showLockedOverlay ? <LockedProtocolGate lang={lang} isAr={isAr} /> : null}
                  </div>
                </section>
              )}

              <section className={injuryPanel}>
                <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'أسئلة شائعة' : 'FAQ'}</div>
                <div className="grid gap-3 md:grid-cols-2">
                  {faqItems.map((item) => (
                    <div key={item.q} className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                      <div className="font-bold text-slate-900 dark:text-white">{normalizeCopy(item.q)}</div>
                      <p className="mt-2 text-sm leading-7 text-slate-700 dark:text-slate-300">{normalizeCopy(item.a)}</p>
                    </div>
                  ))}
                </div>
              </section>

              {relatedExerciseLinks.length > 0 && (
                <section className={injuryPanel}>
                  <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'تمارين مرتبطة' : 'Related exercises'}</div>
                  <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                    {relatedExerciseLinks.map((item) => (
                      <Link
                        key={item.slug}
                        to={item.href}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:hover:bg-health-green/10"
                      >
                        <div className="text-lg font-black text-slate-900 dark:text-white">{item.label}</div>
                        <div className="mt-4 inline-flex items-center gap-2 text-sm font-bold text-health-green">
                          {isAr ? 'افتح القسم' : 'Open section'}
                          <ArrowRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
                        </div>
                      </Link>
                    ))}
                  </div>
                </section>
              )}

              {relatedRehabLinks.length > 0 && (
                <section className={injuryPanel}>
                  <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'صفحات تأهيل مرتبطة' : 'Related rehab pages'}</div>
                  <div className="grid gap-4 md:grid-cols-2">
                    {relatedRehabLinks.map((item) => (
                      <Link
                        key={item.slug}
                        to={item.href}
                        className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5 transition hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:hover:bg-health-green/10"
                      >
                        <div className="text-lg font-black text-slate-900 dark:text-white">{item.label}</div>
                        <div className="mt-4 inline-flex items-center gap-2 text-sm font-bold text-health-green">
                          {isAr ? 'افتح الصفحة' : 'Open page'}
                          <ArrowRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
                        </div>
                      </Link>
                    ))}
                  </div>
                </section>
              )}

              {relatedInjuries.length > 0 && (
                <section className={injuryPanel}>
                  <div className="mb-4 text-sm font-black text-slate-900 dark:text-white">{isAr ? 'إصابات مشابهة' : 'Related injury pages'}</div>
                  <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
                    {relatedInjuries.map((item) => (
                      <Link
                        key={item.id}
                        to={buildPath(item.id, lang)}
                        className="flex items-center justify-between rounded-[1.5rem] border border-slate-200 bg-slate-50 px-4 py-4 transition hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:hover:bg-health-green/10"
                      >
                        <div>
                          <div className="font-bold text-slate-900 dark:text-white">{item.name}</div>
                          <div className="mt-1 text-xs text-slate-500 dark:text-slate-400">{item.category} • {item.bodyRegion}</div>
                        </div>
                        <ArrowRight className={`h-4 w-4 text-slate-400 ${isAr ? 'rotate-180' : ''}`} />
                      </Link>
                    ))}
                  </div>
                </section>
              )}
            </div>
          </section>
        </div>
      </PageLayout>
    </>
  );
}
