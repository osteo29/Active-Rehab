import {lazy, Suspense, useEffect, useMemo, useRef, useState} from 'react';
import {Link, Navigate} from 'react-router-dom';
import {
  ArrowLeft,
  BarChart3,
  Calendar,
  ClipboardList,
  Dumbbell,
  Download,
  LineChart,
  LoaderCircle,
  LogOut,
  ShieldAlert,
} from 'lucide-react';
import Seo from '../components/seo/Seo';
import type {DashboardPdfData} from '../services/pdfReports';
import usePreferredLang from './usePreferredLang';
import {navigationPaths} from '../utils/langUrlHelper';
import {
  buildDashboardSnapshot,
  buildMetricGroups,
  buildMetricInsight,
  filterRecordsByRange,
  type TimeRangeKey,
} from '../services/dashboardInsights';
import {
  deleteAssessment,
  getCurrentUser,
  getSupabaseActionErrorMessage,
  getSupabaseConfigurationMessage,
  isSupabaseConfigured,
  listAssessmentsForCurrentUser,
  onSupabaseAuthChange,
  signOutCurrentUser,
  type AssessmentRecord,
  type User,
} from '../lib/supabase';

const TrendChart = lazy(() => import('../components/dashboard/TrendChart'));
const TimelineLog = lazy(() => import('../components/dashboard/TimelineLog'));
const LazyPdfReportSheet = lazy(() => import('../components/dashboard/LazyPdfReportSheet'));
const MyRecoveryJourney = lazy(() => import('../components/dashboard/MyRecoveryJourney'));

function waitForCondition(check: () => boolean, timeoutMs = 4000) {
  return new Promise<void>((resolve, reject) => {
    const startedAt = Date.now();

    const tick = () => {
      if (check()) {
        resolve();
        return;
      }

      if (Date.now() - startedAt >= timeoutMs) {
        reject(new Error('Timed out while waiting for deferred dashboard content.'));
        return;
      }

      window.setTimeout(tick, 40);
    };

    tick();
  });
}

function formatNumericValue(value: number) {
  if (!Number.isFinite(value)) return '-';
  if (Math.abs(value) >= 100 || Number.isInteger(value)) {
    return value.toLocaleString('en-US', {maximumFractionDigits: 0});
  }

  if (Math.abs(value) >= 10) {
    return value.toLocaleString('en-US', {minimumFractionDigits: 1, maximumFractionDigits: 1});
  }

  return value.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
}

const TIME_RANGE_OPTIONS: Array<{key: TimeRangeKey; label: {en: string; ar: string}}> = [
  {key: '14d', label: {en: 'Last 14 days', ar: 'آخر 14 يومًا'}},
  {key: '30d', label: {en: 'Last 30 days', ar: 'آخر 30 يومًا'}},
  {key: 'all', label: {en: 'All time', ar: 'كل السجلات'}},
];

const insightToneClasses = {
  positive: 'border-emerald-200 bg-emerald-50 text-emerald-900',
  neutral: 'border-slate-200 bg-slate-50 text-slate-900',
  caution: 'border-amber-200 bg-amber-50 text-amber-900',
} as const;

export default function TrackingDashboardPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const [user, setUser] = useState<User | null>(null);
  const [records, setRecords] = useState<AssessmentRecord[]>([]);
  const [status, setStatus] = useState<'checking' | 'loading' | 'ready' | 'error'>('checking');
  const [message, setMessage] = useState('');
  const [pdfReport, setPdfReport] = useState<DashboardPdfData | null>(null);
  const [isGeneratingPdf, setIsGeneratingPdf] = useState(false);
  const [shouldRenderPdfSheet, setShouldRenderPdfSheet] = useState(false);
  const [selectedMetricKey, setSelectedMetricKey] = useState('');
  const [timeRange, setTimeRange] = useState<TimeRangeKey>('30d');
  const chartRef = useRef<any>(null);
  const pdfRef = useRef<HTMLDivElement | null>(null);
  const isPdfSheetReadyRef = useRef(false);

  useEffect(() => {
    let mounted = true;

    const bootstrap = async () => {
      if (!isSupabaseConfigured) {
        if (!mounted) return;
        setStatus('error');
        setMessage(getSupabaseConfigurationMessage(lang));
        return;
      }

      try {
        const currentUser = await getCurrentUser();
        if (!mounted) return;
        setUser(currentUser);

        if (currentUser) {
          setStatus('loading');
          const data = await listAssessmentsForCurrentUser();
          if (!mounted) return;
          setRecords(data);
          setStatus('ready');
          if (data.length === 0) {
            setMessage(
              isAr
                ? 'لا توجد نتائج محفوظة في حسابك حتى الآن.'
                : 'No saved assessments were found in your account yet.',
            );
          }
        } else {
          setStatus('ready');
        }
      } catch (error) {
        if (!mounted) return;
        setStatus('error');
        setMessage(getSupabaseActionErrorMessage(error, lang, 'load'));
      }
    };

    void bootstrap();

    const subscription = isSupabaseConfigured
      ? onSupabaseAuthChange(async (_, session) => {
          if (!mounted) return;
          setUser(session?.user || null);

          if (session?.user) {
            setStatus('loading');
            try {
              const data = await listAssessmentsForCurrentUser();
              if (!mounted) return;
              setRecords(data);
              setStatus('ready');
            } catch (error) {
              if (!mounted) return;
              setStatus('error');
              setMessage(getSupabaseActionErrorMessage(error, lang, 'load'));
            }
          } else {
            setRecords([]);
            setStatus('ready');
          }
        }).data.subscription
      : null;

    return () => {
      mounted = false;
      subscription?.unsubscribe();
    };
  }, [isAr, lang]);

  const handleDelete = async (id: string) => {
    try {
      await deleteAssessment(id);
      setRecords((prev) => prev.filter((item) => item.id !== id));
    } catch (error) {
      setMessage(getSupabaseActionErrorMessage(error, lang, 'delete'));
    }
  };

  const handleLogout = async () => {
    try {
      await signOutCurrentUser();
    } catch (error) {
      setMessage(getSupabaseActionErrorMessage(error, lang, 'auth'));
    }
  };

  const filteredRecords = useMemo(() => filterRecordsByRange(records, timeRange), [records, timeRange]);
  const metricGroups = useMemo(() => buildMetricGroups(filteredRecords), [filteredRecords]);

  useEffect(() => {
    if (!metricGroups.length) {
      if (selectedMetricKey) setSelectedMetricKey('');
      return;
    }

    if (!selectedMetricKey || !metricGroups.some((item) => item.key === selectedMetricKey)) {
      setSelectedMetricKey(metricGroups[0].key);
    }
  }, [metricGroups, selectedMetricKey]);

  const selectedMetric = useMemo(
    () => metricGroups.find((item) => item.key === selectedMetricKey) || metricGroups[0] || null,
    [metricGroups, selectedMetricKey],
  );

  const selectedMetricSummary = useMemo(() => {
    if (!selectedMetric) return null;

    const values = selectedMetric.records.map((item) => item.numericValue);
    const latest = values[values.length - 1];
    const previous = values.length > 1 ? values[values.length - 2] : null;
    const delta = previous === null ? null : latest - previous;

    return {
      latest,
      delta,
      min: Math.min(...values),
      max: Math.max(...values),
    };
  }, [selectedMetric]);

  const lineData = useMemo(() => {
    const activeRecords = selectedMetric?.records || [];

    return {
      labels: activeRecords.map((item) =>
        new Date(item.created_at).toLocaleDateString(isAr ? 'ar-EG' : 'en-US'),
      ),
      datasets: [
        {
          label: selectedMetric?.label || (isAr ? 'تطور القياسات' : 'Measurement trend'),
          data: activeRecords.map((item) => item.numericValue),
          borderColor: '#315f4a',
          backgroundColor: 'rgba(49,95,74,0.18)',
          tension: 0.28,
          fill: true,
        },
      ],
    };
  }, [isAr, selectedMetric]);

  const dashboardSnapshot = useMemo(
    () => buildDashboardSnapshot(filteredRecords, metricGroups),
    [filteredRecords, metricGroups],
  );

  const selectedMetricInsight = useMemo(
    () => buildMetricInsight(selectedMetric, lang),
    [lang, selectedMetric],
  );

  const handleDownloadPdf = async () => {
    if (!user || isGeneratingPdf) return;

    setIsGeneratingPdf(true);
    setMessage('');
    isPdfSheetReadyRef.current = false;

    try {
      const {buildDashboardPdfData, generatePdfReport} = await import('../services/pdfReports');
      const chartImageDataUrl =
        selectedMetric && chartRef.current?.toBase64Image ? chartRef.current.toBase64Image() : undefined;

      const report = await buildDashboardPdfData({
        lang,
        user,
        records,
        chartImageDataUrl,
      });

      setPdfReport(report);
      setShouldRenderPdfSheet(true);

      await waitForCondition(
        () =>
          isPdfSheetReadyRef.current &&
          Boolean(pdfRef.current?.querySelector('[data-pdf-report-sheet="true"]')),
      );

      if (!pdfRef.current) {
        throw new Error('PDF report view is not ready.');
      }

      const safeName = (user.email?.split('@')[0] || 'dashboard').replace(/[^a-z0-9-_]/gi, '-');
      await generatePdfReport({
        element: pdfRef.current,
        fileName: `${safeName}-active-rehab-dashboard-report.pdf`,
      });
    } catch (error) {
      setMessage(
        isAr
          ? 'تعذر إنشاء التقرير الآن. حاول مرة أخرى بعد ثوانٍ.'
          : 'Could not generate the PDF report right now. Please try again in a moment.',
      );
    } finally {
      setIsGeneratingPdf(false);
    }
  };

  if (!isSupabaseConfigured) {
    return (
      <div className="min-h-screen bg-slate-50 px-4 py-20 text-center text-slate-600">
        {message || getSupabaseConfigurationMessage(lang)}
      </div>
    );
  }

  if (status === 'checking') {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-50">
        <div className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-5 py-4 text-slate-600 shadow-sm">
          <LoaderCircle className="h-4 w-4 animate-spin" />
          <span>{isAr ? 'جارٍ التحقق من الجلسة' : 'Checking session'}</span>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to={navigationPaths.auth(lang)} replace state={{from: navigationPaths.dashboard(lang)}} />;
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <Seo
        title={isAr ? 'لوحة المتابعة' : 'Tracking Dashboard'}
        description={
          isAr
            ? 'راجع سجل القياسات والنتائج المحفوظة داخل حسابك في Active Rehab.'
            : 'Review saved assessments and result history inside your Active Rehab account.'
        }
        canonicalPath="/dashboard"
        noIndex
      />

      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
          <div>
            <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
              {isAr ? 'لوحة المتابعة الآمنة' : 'Secure tracking dashboard'}
            </div>
            <h1 className="text-2xl font-bold text-slate-900 sm:text-[1.9rem]">
              {isAr ? 'سجل القياسات المرتبط بحسابك' : 'Assessment history linked to your account'}
            </h1>
            <p className="mt-1.5 text-sm text-slate-500">{user.email}</p>
          </div>

          <div className="flex flex-wrap gap-2.5">
            <button
              type="button"
              onClick={handleDownloadPdf}
              disabled={isGeneratingPdf}
              className="inline-flex items-center gap-2 rounded-2xl bg-health-green px-4 py-2.5 text-sm font-bold text-white transition-all hover:bg-health-green-dark disabled:cursor-not-allowed disabled:opacity-60"
            >
              {isGeneratingPdf ? (
                <LoaderCircle className="h-4 w-4 animate-spin" />
              ) : (
                <Download className="h-4 w-4" />
              )}
              <span>{isAr ? 'تحميل تقرير PDF' : 'Download PDF report'}</span>
            </button>
            <Link
              to={navigationPaths.home(lang)}
              className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-bold text-slate-700"
            >
              <ArrowLeft className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
              <span>{isAr ? 'العودة للرئيسية' : 'Back home'}</span>
            </Link>

            <button
              type="button"
              onClick={handleLogout}
              className="inline-flex items-center gap-2 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-2.5 text-sm font-bold text-rose-600 transition-all hover:bg-rose-100"
            >
              <LogOut className="h-4 w-4" />
              <span>{isAr ? 'تسجيل الخروج' : 'Log out'}</span>
            </button>
          </div>
        </div>

        {message ? (
          <div className="mb-6 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-600 shadow-sm">
            {message}
          </div>
        ) : null}

        <div className="mb-8">
          <Suspense
            fallback={
              <div className="flex h-48 items-center justify-center rounded-[2rem] border border-slate-200 bg-white p-6 shadow-sm">
                <LoaderCircle className="h-6 w-6 animate-spin text-health-green" />
              </div>
            }
          >
            <MyRecoveryJourney lang={lang} />
          </Suspense>
        </div>

        <div className="mb-5 rounded-[1.75rem] border border-slate-200 bg-white p-4 shadow-sm sm:p-5">
          <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div>
              <div className="text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
                {isAr ? 'عدسة المتابعة' : 'Recovery lens'}
              </div>
              <p className="mt-1.5 max-w-2xl text-sm leading-6 text-slate-600">
                {isAr
                  ? 'اعرض بياناتك حسب الفترة الزمنية التي تريد مراجعتها، ثم راقب المؤشر نفسه بصورة متسقة حتى تكون المقارنة مفيدة سريريًا.'
                  : 'Review one time window at a time, then keep tracking the same metric consistently so the comparisons stay clinically useful.'}
              </p>
            </div>

            <div className="flex flex-wrap gap-1.5">
              {TIME_RANGE_OPTIONS.map((option) => {
                const isActive = option.key === timeRange;
                return (
                  <button
                    key={option.key}
                    type="button"
                    onClick={() => setTimeRange(option.key)}
                    className={`rounded-full px-3.5 py-2 text-sm font-semibold transition-all ${
                      isActive
                        ? 'bg-slate-900 text-white'
                        : 'border border-slate-200 bg-white text-slate-600 hover:border-health-green/30 hover:text-slate-900'
                    }`}
                  >
                    {isAr ? option.label.ar : option.label.en}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="mt-4 grid grid-cols-1 gap-3 md:grid-cols-3">
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5">
              <div className="mb-2 text-xs text-slate-500">{isAr ? 'السجلات في آخر 14 يومًا' : 'Records in the last 14 days'}</div>
              <div className="text-2xl font-bold text-slate-900">{dashboardSnapshot.recentRecordCount}</div>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5">
              <div className="mb-2 text-xs text-slate-500">{isAr ? 'أكثر مؤشر تمت متابعته' : 'Most tracked metric'}</div>
              <div className="text-lg font-bold text-slate-900">
                {dashboardSnapshot.mostTrackedLabel || (isAr ? 'لا يوجد بعد' : 'Not available yet')}
              </div>
              {dashboardSnapshot.mostTrackedCount > 0 ? (
                <div className="mt-1 text-xs text-slate-500">
                  {isAr
                    ? `${dashboardSnapshot.mostTrackedCount} قراءة ضمن الفترة الحالية`
                    : `${dashboardSnapshot.mostTrackedCount} readings in this window`}
                </div>
              ) : null}
            </div>
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5">
              <div className="mb-2 text-xs text-slate-500">{isAr ? 'أحدث نتيجة في هذه الفترة' : 'Latest result in this window'}</div>
              <div className="text-lg font-bold text-slate-900">
                {dashboardSnapshot.latestRecordLabel || (isAr ? 'لا توجد نتائج' : 'No results')}
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-6 lg:grid-cols-[1.24fr_0.76fr]">
          <div className="rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
            <div className="mb-4 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
              <LineChart className="h-3.5 w-3.5" />
              <span>{isAr ? 'الرسم البياني' : 'Trend chart'}</span>
            </div>

            {metricGroups.length > 1 ? (
              <div className="mb-4">
                <label className="mb-2 block text-xs font-semibold text-slate-500">
                  {isAr ? 'اختر المؤشر الذي تريد متابعته' : 'Choose the metric to analyze'}
                </label>
                <select
                  value={selectedMetricKey}
                  onChange={(event) => setSelectedMetricKey(event.target.value)}
                  className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-health-green focus:ring-2 focus:ring-health-green/20"
                >
                  {metricGroups.map((item) => (
                    <option key={item.key} value={item.key}>
                      {item.label}
                    </option>
                  ))}
                </select>
              </div>
            ) : null}

            {selectedMetricSummary ? (
              <div className="mb-5 grid grid-cols-1 gap-3 sm:grid-cols-3">
                <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                  <div className="text-xs text-slate-500">{isAr ? 'أحدث قيمة' : 'Latest value'}</div>
                  <div className="mt-2 text-2xl font-black text-slate-900">
                    {formatNumericValue(selectedMetricSummary.latest)}
                  </div>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                  <div className="text-xs text-slate-500">{isAr ? 'التغيّر الأخير' : 'Latest change'}</div>
                  <div className="mt-2 text-2xl font-black text-slate-900">
                    {selectedMetricSummary.delta === null
                      ? '...'
                      : `${selectedMetricSummary.delta > 0 ? '+' : ''}${formatNumericValue(selectedMetricSummary.delta)}`}
                  </div>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                  <div className="text-xs text-slate-500">{isAr ? 'المدى المسجل' : 'Recorded range'}</div>
                  <div className="mt-2 text-lg font-black text-slate-900">
                    {formatNumericValue(selectedMetricSummary.min)} - {formatNumericValue(selectedMetricSummary.max)}
                  </div>
                </div>
              </div>
            ) : null}

            {status === 'loading' ? (
              <div className="flex h-[320px] items-center justify-center">
                <LoaderCircle className="h-5 w-5 animate-spin text-health-green" />
              </div>
            ) : selectedMetric ? (
              <Suspense
                fallback={
                  <div className="flex h-[320px] items-center justify-center rounded-[1.5rem] border border-slate-200 bg-slate-50">
                    <LoaderCircle className="h-5 w-5 animate-spin text-health-green" />
                  </div>
                }
              >
                <TrendChart
                  chartRef={chartRef}
                  lineData={lineData}
                  isAr={isAr}
                  metricLabel={selectedMetric.label}
                />
              </Suspense>
            ) : (
              <div className="flex h-[320px] items-center justify-center rounded-[1.5rem] border border-dashed border-slate-200 bg-slate-50 px-8 text-center text-slate-500">
                {records.length === 0
                  ? isAr
                    ? 'احفظ قياسات تحتوي على قيمة رقمية لتظهر هنا في الرسم البياني.'
                    : 'Save assessments with numeric values to see them plotted here.'
                  : isAr
                    ? 'لا توجد قراءات رقمية ضمن الفترة الزمنية المختارة. غيّر الفترة أو سجّل قراءة جديدة.'
                    : 'There are no numeric readings inside this time range yet. Try another range or log a new reading.'}
              </div>
            )}
          </div>

          <div className="rounded-[1.75rem] border border-slate-200 bg-white p-4 shadow-sm sm:p-5">
            <div className="mb-4 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
              <BarChart3 className="h-3.5 w-3.5" />
              <span>{isAr ? 'ملخص سريع' : 'Quick summary'}</span>
            </div>

            <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
              <div className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5">
                <div className="mb-2 text-xs text-slate-500">{isAr ? 'السجلات في العرض الحالي' : 'Records in current view'}</div>
                <div className="text-2xl font-bold text-slate-900">
                  {filteredRecords.length}
                  <span className="ml-2 text-sm font-medium text-slate-500">/ {records.length}</span>
                </div>
              </div>
              <div className="rounded-2xl border border-slate-200 bg-slate-50 p-3.5">
                <div className="mb-2 text-xs text-slate-500">{isAr ? 'المؤشرات الرقمية المتاحة' : 'Tracked numeric metrics'}</div>
                <div className="text-2xl font-bold text-slate-900">{dashboardSnapshot.trackedMetricCount}</div>
              </div>
            </div>

            {selectedMetric ? (
              <div className="mt-3 rounded-[1.35rem] border border-slate-200 bg-slate-50 p-3.5">
                <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">
                  {isAr ? 'المؤشر النشط' : 'Active metric'}
                </div>
                <div className="mt-2 text-lg font-black text-slate-900">{selectedMetric.label}</div>
                <p className="mt-1.5 text-sm leading-6 text-slate-600">
                  {isAr
                    ? `يظهر الرسم لهذا المؤشر فقط عبر ${selectedMetric.records.length} قراءة في الفترة الحالية، حتى لا تختلط المقاييس المختلفة في منحنى واحد.`
                    : `The chart focuses on this metric only across ${selectedMetric.records.length} readings in the current window, so different measurements do not get mixed together.`}
                </p>
              </div>
            ) : null}

            {selectedMetricInsight ? (
              <div className={`mt-3 rounded-[1.35rem] border p-3.5 ${insightToneClasses[selectedMetricInsight.tone]}`}>
                <div className="flex items-start gap-3">
                  <ShieldAlert className="mt-0.5 h-4 w-4 shrink-0" />
                  <div>
                    <div className="font-bold">{selectedMetricInsight.title}</div>
                    <p className="mt-2 text-sm leading-6">{selectedMetricInsight.summary}</p>
                    <p className="mt-2 text-sm font-semibold">{selectedMetricInsight.action}</p>
                  </div>
                </div>
              </div>
            ) : null}

            <Link
              to={navigationPaths.injuries(lang)}
              className="mt-3 flex items-center justify-between gap-3 rounded-[1.35rem] border border-health-green/20 bg-health-green/5 px-4 py-3.5 transition-all hover:border-health-green/40 hover:bg-health-green/10"
            >
              <div>
                <div className="flex items-center gap-2 text-sm font-bold text-health-green-dark">
                  <ClipboardList className="h-4 w-4" />
                  <span>{isAr ? 'بروتوكولات الإصابات' : 'Injury protocols'}</span>
                </div>
                <p className="mt-1.5 text-sm leading-6 text-slate-600">
                  {isAr
                    ? 'افتح مكتبة التعافي وخطط التغذية العلاجية مباشرة من لوحة المتابعة.'
                    : 'Open the rehab library and recovery nutrition plans directly from your dashboard.'}
                </p>
              </div>
              <ArrowLeft className={`h-4 w-4 shrink-0 text-health-green ${isAr ? '' : 'rotate-180'}`} />
            </Link>

            <Link
              to={navigationPaths.exercises(lang)}
              className="mt-3 flex items-center justify-between gap-3 rounded-[1.35rem] border border-slate-200 bg-slate-50 px-4 py-3.5 transition-all hover:border-health-green/30 hover:bg-soft-blue"
            >
              <div>
                <div className="flex items-center gap-2 text-sm font-bold text-slate-900">
                  <Dumbbell className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'دليل التمارين' : 'Exercise finder'}</span>
                </div>
                <p className="mt-1.5 text-sm leading-6 text-slate-600">
                  {isAr
                    ? 'ارجع إلى صفحة التمارين لاختيار تمارين مناسبة ثم تابع تأثيرها هنا في السجل.'
                    : 'Go back to the exercise page to choose movements, then track how they affect your log here.'}
                </p>
              </div>
              <ArrowLeft className={`h-4 w-4 shrink-0 text-health-green ${isAr ? '' : 'rotate-180'}`} />
            </Link>
          </div>
        </div>

        <div className="mt-6 rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
          <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div className="flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.18em] text-health-green">
              <Calendar className="h-3.5 w-3.5" />
              <span>{isAr ? 'السجل الزمني' : 'Timeline log'}</span>
            </div>

            <div className="text-sm text-slate-500">
              {isAr
                ? `يعرض ${filteredRecords.length} سجل${filteredRecords.length === 1 ? '' : 'ات'} ضمن ${isAr ? TIME_RANGE_OPTIONS.find((option) => option.key === timeRange)?.label.ar : ''}`
                : `Showing ${filteredRecords.length} record${filteredRecords.length === 1 ? '' : 's'} in ${TIME_RANGE_OPTIONS.find((option) => option.key === timeRange)?.label.en}`}
            </div>
          </div>

          <Suspense
            fallback={
              <div className="flex min-h-[180px] items-center justify-center rounded-2xl border border-slate-200 bg-slate-50">
                <LoaderCircle className="h-5 w-5 animate-spin text-health-green" />
              </div>
            }
          >
            <TimelineLog
              isAr={isAr}
              records={filteredRecords}
              onDelete={handleDelete}
              emptyMessage={
                timeRange === 'all'
                  ? undefined
                  : isAr
                    ? 'لا توجد سجلات ضمن الفترة الزمنية المختارة.'
                    : 'No saved records fall inside the selected time range.'
              }
            />
          </Suspense>
        </div>
      </div>

      <div
        style={{
          position: 'fixed',
          top: 0,
          left: 0,
          zIndex: -9999,
          pointerEvents: 'none',
          opacity: 0.01,
          width: 794,
        }}
      >
        {shouldRenderPdfSheet && pdfReport ? (
          <div ref={pdfRef}>
            <Suspense fallback={null}>
              <LazyPdfReportSheet
                report={pdfReport}
                onReady={() => {
                  isPdfSheetReadyRef.current = true;
                }}
              />
            </Suspense>
          </div>
        ) : null}
      </div>
    </div>
  );
}
