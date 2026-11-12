import {memo, useState} from 'react';
import {Link} from 'react-router-dom';
import {
  Activity,
  ArrowRight,
  Calendar,
  CheckCircle2,
  ChevronRight,
  Circle,
  Clock,
  HeartPulse,
  MessageSquare,
  Plus,
  ShieldAlert,
  Sparkles,
  Trash2,
  TrendingDown,
  Trophy,
} from 'lucide-react';
import {useMyRecovery} from '../../hooks/useMyRecovery';
import {navigationPaths} from '../../utils/langUrlHelper';

// Popular initial injury quick picks for instant 1-click start
const POPULAR_INJURIES = [
  {slug: 'acl-tear', nameEn: 'ACL Tear / Reconstruction', nameAr: 'تمزق أو ترميم الرباط الصليبي (ACL)', phases: 4, region: 'Knee'},
  {slug: 'rotator-cuff-tendinopathy', nameEn: 'Rotator Cuff Tendinopathy', nameAr: 'اعتلال أوتار الكفة المدورة للكتف', phases: 3, region: 'Shoulder'},
  {slug: 'lumbar-disc-herniation', nameEn: 'Lower Back Disc Herniation', nameAr: 'انزلاق غضروفي أسفل الظهر', phases: 3, region: 'Spine'},
  {slug: 'ankle-sprain', nameEn: 'Lateral Ankle Sprain', nameAr: 'التواء الكاحل الخارجي', phases: 3, region: 'Ankle'},
  {slug: 'patellar-tendinopathy', nameEn: 'Patellar Tendinopathy (Jumper\'s Knee)', nameAr: 'التهاب وتر الرضفة (ركبة القافز)', phases: 3, region: 'Knee'},
  {slug: 'cervical-radiculopathy', nameEn: 'Neck Pain & Cervical Radiculopathy', nameAr: 'ألم الرقبة والانزلاق العنقي', phases: 3, region: 'Neck'},
];

function getPainDescription(level: number, isAr: boolean) {
  if (level === 0) return {text: isAr ? 'لا يوجد ألم (0/10)' : 'No Pain (0/10)', color: 'text-emerald-600', bg: 'bg-emerald-50 border-emerald-200'};
  if (level <= 3) return {text: isAr ? 'ألم خفيف ومحتمل (1-3/10)' : 'Mild Pain (1-3/10)', color: 'text-emerald-700', bg: 'bg-emerald-50 border-emerald-200'};
  if (level <= 6) return {text: isAr ? 'ألم متوسط ملحوظ (4-6/10)' : 'Moderate Pain (4-6/10)', color: 'text-amber-700', bg: 'bg-amber-50 border-amber-200'};
  return {text: isAr ? 'ألم شديد يحتاج راحة (7-10/10)' : 'Severe Pain (7-10/10)', color: 'text-rose-700', bg: 'bg-rose-50 border-rose-200'};
}

function calculateDaysSince(dateStr: string) {
  try {
    const diff = Math.max(0, Date.now() - new Date(dateStr).getTime());
    return Math.floor(diff / (1000 * 60 * 60 * 24)) + 1;
  } catch {
    return 1;
  }
}

export const MyRecoveryJourney = memo(function MyRecoveryJourney({
  lang = 'ar',
}: {
  lang?: 'en' | 'ar';
}) {
  const isAr = lang === 'ar';
  const {
    journeys,
    activeJourney,
    setActiveJourneyId,
    startJourney,
    setPhase,
    advancePhase,
    toggleGoal,
    logPain,
    addNote,
    deleteJourney,
  } = useMyRecovery();

  const [newNoteText, setNewNoteText] = useState('');
  const [sliderPain, setSliderPain] = useState<number>(activeJourney?.painLevel ?? 4);
  const [isLoggingPain, setIsLoggingPain] = useState(false);

  // If no active journey is tracked yet, show an engaging selector
  if (!activeJourney || journeys.length === 0) {
    return (
      <div className="rounded-[2rem] border border-amber-200/40 bg-gradient-to-br from-amber-50/60 via-white to-amber-50/30 p-6 shadow-sm dark:border-amber-900/30 dark:from-slate-900 dark:via-slate-900/90 dark:to-slate-950 sm:p-8">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <div className="inline-flex items-center gap-2 rounded-full bg-health-green/10 px-3.5 py-1 text-xs font-bold uppercase tracking-wider text-health-green">
              <Sparkles className="h-3.5 w-3.5" />
              <span>{isAr ? 'رحلة التعافي الشخصية' : 'Personal Recovery Journey'}</span>
            </div>
            <h3 className="mt-3 text-2xl font-black text-slate-900 dark:text-white sm:text-3xl">
              {isAr ? 'اختر إصابتك وتابع تقدمك خطوة بخطوة' : 'Track Your Injury & Progress Through Phases'}
            </h3>
            <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-600 dark:text-slate-300">
              {isAr
                ? 'حدد حالتك الحالية لتبدأ متابعة مراحل التعافي (المرحلة 1 إلى 2 إلى 3)، وتسجيل درجة الألم وملاحظات التحسن أولاً بأول.'
                : 'Select your injury to track milestones, log daily pain levels, and advance through rehabilitation phases (Phase 1 → 2 → 3).'}
            </p>
          </div>

          <Link
            to={navigationPaths.injuries(lang)}
            className="inline-flex shrink-0 items-center justify-center gap-2 rounded-2xl bg-health-green px-5 py-3 text-sm font-bold text-slate-950 shadow-md transition-all hover:bg-[#d3aa54]"
          >
            <span>{isAr ? 'استعراض كل الإصابات' : 'Browse All Protocols'}</span>
            <ArrowRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
          </Link>
        </div>

        <div className="mt-6 border-t border-slate-200/60 pt-6 dark:border-slate-800">
          <div className="mb-3 text-xs font-bold uppercase tracking-wider text-slate-400">
            {isAr ? 'أو ابدأ مباشرة باختيار إحدى الإصابات الشائعة:' : 'Or quickly start tracking one of these common conditions:'}
          </div>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {POPULAR_INJURIES.map((item) => (
              <button
                key={item.slug}
                type="button"
                onClick={() =>
                  startJourney({
                    injurySlug: item.slug,
                    injuryName: item.nameEn,
                    injuryNameAr: item.nameAr,
                    bodyRegion: item.region,
                    totalPhases: item.phases,
                  })
                }
                className="group flex flex-col justify-between rounded-2xl border border-slate-200 bg-white p-4 text-start transition-all hover:-translate-y-0.5 hover:border-health-green/40 hover:shadow-md dark:border-slate-800 dark:bg-slate-900 dark:hover:border-health-green/50"
              >
                <div className="flex items-start justify-between gap-2">
                  <span className="rounded-lg bg-amber-50 px-2.5 py-1 text-[11px] font-bold text-health-green dark:bg-slate-800">
                    {item.region}
                  </span>
                  <span className="text-xs font-semibold text-slate-400">
                    {isAr ? `${item.phases} مراحل` : `${item.phases} Phases`}
                  </span>
                </div>
                <div className="mt-2.5 font-bold text-slate-900 group-hover:text-health-green dark:text-white">
                  {isAr ? item.nameAr : item.nameEn}
                </div>
                <div className="mt-3 flex items-center gap-1.5 text-xs font-bold text-health-green">
                  <span>{isAr ? 'ابدأ المتابعة الآن' : 'Start Journey'}</span>
                  <ChevronRight className={`h-3.5 w-3.5 ${isAr ? 'rotate-180' : ''}`} />
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>
    );
  }

  const daysInRecovery = calculateDaysSince(activeJourney.startedAt);
  const currentPhaseProgress = activeJourney.phases.find((p) => p.phaseNumber === activeJourney.currentPhase);
  const painInfo = getPainDescription(activeJourney.painLevel, isAr);
  const totalCompletedGoals = activeJourney.phases.reduce(
    (acc, p) => acc + p.goals.filter((g) => g.completed).length,
    0,
  );
  const totalGoals = activeJourney.phases.reduce((acc, p) => acc + p.goals.length, 0);
  const overallPercentage = totalGoals > 0 ? Math.round((totalCompletedGoals / totalGoals) * 100) : 0;

  const handleSavePain = () => {
    logPain(activeJourney.id, sliderPain);
    setIsLoggingPain(false);
  };

  const handleAddNote = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newNoteText.trim()) return;
    addNote(activeJourney.id, newNoteText);
    setNewNoteText('');
  };

  return (
    <div className="rounded-[2.25rem] border border-slate-200/90 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900 sm:p-7">
      {/* Multi-journey tab selector if user has more than 1 */}
      {journeys.length > 1 && (
        <div className="mb-5 flex items-center gap-2 overflow-x-auto pb-2">
          <span className="text-xs font-bold uppercase text-slate-400">
            {isAr ? 'إصاباتك المتابعة:' : 'Your Injuries:'}
          </span>
          {journeys.map((j) => (
            <button
              key={j.id}
              type="button"
              onClick={() => setActiveJourneyId(j.id)}
              className={`rounded-full px-3.5 py-1 text-xs font-bold transition-all ${
                j.id === activeJourney.id
                  ? 'bg-slate-900 text-white dark:bg-health-green dark:text-slate-950'
                  : 'border border-slate-200 bg-slate-50 text-slate-600 hover:bg-slate-100 dark:border-slate-800 dark:bg-slate-800 dark:text-slate-300'
              }`}
            >
              {isAr ? j.injuryNameAr || j.injuryName : j.injuryName}
            </button>
          ))}
        </div>
      )}

      {/* Header bar */}
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <div className="flex flex-wrap items-center gap-2">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-emerald-700 dark:bg-emerald-950/60 dark:text-emerald-300">
              <Activity className="h-3.5 w-3.5" />
              <span>{isAr ? 'الخطة النشطة' : 'Active Recovery Plan'}</span>
            </span>
            <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600 dark:bg-slate-800 dark:text-slate-300">
              <Calendar className="h-3 w-3" />
              <span>{isAr ? `اليوم ${daysInRecovery} في التعافي` : `Day ${daysInRecovery} in recovery`}</span>
            </span>
          </div>

          <h2 className="mt-2 text-2xl font-black text-slate-900 dark:text-white sm:text-3xl">
            {isAr ? activeJourney.injuryNameAr || activeJourney.injuryName : activeJourney.injuryName}
          </h2>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <Link
            to={navigationPaths.injuryDetail(lang, activeJourney.injurySlug)}
            className="inline-flex items-center gap-1.5 rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-bold text-slate-700 transition hover:border-health-green/40 dark:border-slate-800 dark:bg-slate-800 dark:text-slate-200"
          >
            <span>{isAr ? 'عرض البروتوكول السريري الكامل' : 'View Full Protocol'}</span>
            <ArrowRight className={`h-3.5 w-3.5 ${isAr ? 'rotate-180' : ''}`} />
          </Link>

          <button
            type="button"
            onClick={() => {
              if (window.confirm(isAr ? 'هل تريد إيقاف متابعة هذه الإصابة؟' : 'Remove this tracked injury?')) {
                deleteJourney(activeJourney.id);
              }
            }}
            className="inline-flex items-center gap-1 rounded-xl border border-transparent p-2 text-xs font-bold text-rose-500 hover:bg-rose-50 dark:hover:bg-rose-950/40"
            title={isAr ? 'حذف من المتابعة' : 'Remove journey'}
          >
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </div>

      {/* Phase progress visual stepper */}
      <div className="mt-6 rounded-2xl border border-slate-100 bg-slate-50/80 p-4 dark:border-slate-800/80 dark:bg-slate-950/60 sm:p-6">
        <div className="mb-4 flex items-center justify-between">
          <div className="text-xs font-bold uppercase tracking-wider text-slate-400">
            {isAr ? 'مراحل خطة التعافي' : 'Rehabilitation Phase Pathway'}
          </div>
          <div className="text-xs font-bold text-health-green">
            {isAr ? `إنجاز الأهداف: ${overallPercentage}%` : `Overall Goals: ${overallPercentage}%`}
          </div>
        </div>

        {/* Phase pills */}
        <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 lg:grid-cols-4">
          {activeJourney.phases.map((p) => {
            const isCurrent = p.phaseNumber === activeJourney.currentPhase;
            const isDone = p.phaseNumber < activeJourney.currentPhase || p.completed;

            return (
              <button
                key={p.phaseNumber}
                type="button"
                onClick={() => setPhase(activeJourney.id, p.phaseNumber)}
                className={`relative flex flex-col rounded-xl p-3 text-start transition-all ${
                  isCurrent
                    ? 'border-2 border-health-green bg-white shadow-sm dark:bg-slate-900'
                    : isDone
                      ? 'border border-emerald-200 bg-emerald-50/70 dark:border-emerald-900/40 dark:bg-emerald-950/30'
                      : 'border border-slate-200 bg-white/70 opacity-60 hover:opacity-100 dark:border-slate-800 dark:bg-slate-900/60'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span
                    className={`text-[11px] font-black uppercase ${
                      isCurrent
                        ? 'text-health-green'
                        : isDone
                          ? 'text-emerald-700 dark:text-emerald-300'
                          : 'text-slate-400'
                    }`}
                  >
                    {isAr ? `المرحلة ${p.phaseNumber}` : `Phase ${p.phaseNumber}`}
                  </span>
                  {isDone ? (
                    <CheckCircle2 className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
                  ) : isCurrent ? (
                    <span className="flex h-2.5 w-2.5 rounded-full bg-health-green animate-pulse" />
                  ) : (
                    <Circle className="h-3.5 w-3.5 text-slate-300 dark:text-slate-600" />
                  )}
                </div>
                <div className="mt-1.5 text-xs font-bold text-slate-900 dark:text-white">
                  {p.phaseNumber === 1
                    ? isAr
                      ? 'التهدئة والحماية'
                      : 'Acute Protection'
                    : p.phaseNumber === 2
                      ? isAr
                        ? 'استعادة المدى والقوة'
                        : 'Mobility & Loading'
                      : p.phaseNumber === 3
                        ? isAr
                          ? 'الثبات والتأهيل المتقدم'
                          : 'Functional Strength'
                        : isAr
                          ? 'العودة للنشاط الكامل'
                          : 'Return to Activity'}
                </div>
              </button>
            );
          })}
        </div>

        {/* Advance Phase Button */}
        <div className="mt-4 flex flex-col items-center justify-between gap-3 border-t border-slate-200/60 pt-4 sm:flex-row dark:border-slate-800">
          <div className="text-xs text-slate-600 dark:text-slate-300">
            {isAr
              ? `أنت الآن في المرحلة ${activeJourney.currentPhase} من أصل ${activeJourney.totalPhases}. أكمل أهداف المرحلة للانتقال للتالية.`
              : `You are currently in Phase ${activeJourney.currentPhase} of ${activeJourney.totalPhases}. Complete phase goals to advance.`}
          </div>

          {activeJourney.currentPhase < activeJourney.totalPhases ? (
            <button
              type="button"
              onClick={() => advancePhase(activeJourney.id)}
              className="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2 text-xs font-bold text-white shadow-sm transition hover:bg-slate-800 dark:bg-health-green dark:text-slate-950 dark:hover:bg-[#d3aa54]"
            >
              <span>{isAr ? 'الانتقال إلى المرحلة التالية' : 'Advance to Next Phase'}</span>
              <ChevronRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
            </button>
          ) : (
            <div className="inline-flex items-center gap-1.5 text-xs font-bold text-emerald-600 dark:text-emerald-400">
              <Trophy className="h-4 w-4" />
              <span>{isAr ? 'وصلت إلى المرحلة المتقدمة النهائية!' : 'You reached the final phase!'}</span>
            </div>
          )}
        </div>
      </div>

      {/* Main interactive grid: Phase Goals + Pain Tracker */}
      <div className="mt-6 grid gap-6 lg:grid-cols-12">
        {/* Left / Primary: Current Phase Goals checklist */}
        <div className="space-y-4 lg:col-span-7">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold uppercase tracking-wider text-slate-900 dark:text-white">
              {isAr ? `أهداف ومعايير المرحلة ${activeJourney.currentPhase}` : `Phase ${activeJourney.currentPhase} Milestones`}
            </h4>
            <span className="text-xs text-slate-500">
              {isAr ? 'اضغط لتحديد المكتمل' : 'Check to mark done'}
            </span>
          </div>

          <div className="space-y-2.5">
            {currentPhaseProgress?.goals.map((goal) => (
              <button
                key={goal.id}
                type="button"
                onClick={() => toggleGoal(activeJourney.id, activeJourney.currentPhase, goal.id)}
                className={`flex w-full items-start gap-3 rounded-xl border p-3.5 text-start transition-all ${
                  goal.completed
                    ? 'border-emerald-200 bg-emerald-50/60 text-slate-900 dark:border-emerald-900/40 dark:bg-emerald-950/30 dark:text-white'
                    : 'border-slate-200 bg-white hover:border-slate-300 dark:border-slate-800 dark:bg-slate-950 dark:hover:border-slate-700'
                }`}
              >
                <div className="mt-0.5 shrink-0">
                  {goal.completed ? (
                    <CheckCircle2 className="h-5 w-5 text-emerald-600 dark:text-emerald-400" />
                  ) : (
                    <Circle className="h-5 w-5 text-slate-300 dark:text-slate-600" />
                  )}
                </div>
                <div className="flex-1 text-sm font-medium leading-relaxed">
                  <span className={goal.completed ? 'line-through opacity-75' : ''}>{goal.text}</span>
                </div>
              </button>
            ))}
          </div>

          {/* Quick Note Add */}
          <form onSubmit={handleAddNote} className="mt-4 flex gap-2">
            <input
              type="text"
              value={newNoteText}
              onChange={(e) => setNewNoteText(e.target.value)}
              placeholder={isAr ? 'أضف ملاحظة (مثال: ألم أقل عند النزول على السلالم)...' : 'Add recovery note (e.g., less pain during squats)...'}
              className="flex-1 rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2.5 text-xs text-slate-900 outline-none transition focus:border-health-green focus:bg-white dark:border-slate-800 dark:bg-slate-950 dark:text-white"
            />
            <button
              type="submit"
              disabled={!newNoteText.trim()}
              className="inline-flex shrink-0 items-center gap-1 rounded-xl bg-health-green px-4 py-2.5 text-xs font-bold text-slate-950 transition hover:bg-[#d3aa54] disabled:opacity-50"
            >
              <Plus className="h-3.5 w-3.5" />
              <span>{isAr ? 'إضافة' : 'Add'}</span>
            </button>
          </form>

          {/* Recent Notes */}
          {activeJourney.notes.length > 0 && (
            <div className="mt-3 space-y-1.5">
              <div className="text-[11px] font-bold uppercase text-slate-400">
                {isAr ? 'آخر الملاحظات المسجلة:' : 'Recent Notes:'}
              </div>
              <div className="max-h-36 space-y-1.5 overflow-y-auto pr-1">
                {activeJourney.notes.slice(0, 3).map((note) => (
                  <div
                    key={note.id}
                    className="flex items-start gap-2 rounded-lg border border-slate-100 bg-slate-50/70 p-2 text-xs text-slate-600 dark:border-slate-800 dark:bg-slate-950 dark:text-slate-300"
                  >
                    <MessageSquare className="mt-0.5 h-3 w-3 shrink-0 text-health-green" />
                    <span className="flex-1">{note.text}</span>
                    <span className="text-[10px] text-slate-400">
                      {new Date(note.date).toLocaleDateString(isAr ? 'ar-EG' : 'en-US')}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Right: Pain Level Tracker & Guidance */}
        <div className="space-y-4 lg:col-span-5">
          <div className="rounded-2xl border border-slate-200 bg-slate-50/60 p-4 dark:border-slate-800 dark:bg-slate-950/60 sm:p-5">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <HeartPulse className="h-4 w-4 text-health-green" />
                <h4 className="text-xs font-bold uppercase tracking-wider text-slate-900 dark:text-white">
                  {isAr ? 'مقياس الألم الحالي' : 'Pain Level Assessment'}
                </h4>
              </div>
              <span className={`rounded-full border px-2.5 py-0.5 text-xs font-bold ${painInfo.bg} ${painInfo.color}`}>
                {painInfo.text}
              </span>
            </div>

            {/* Visual Pain Slider */}
            <div className="mt-4">
              <input
                type="range"
                min="0"
                max="10"
                step="1"
                value={sliderPain}
                onChange={(e) => {
                  setSliderPain(Number(e.target.value));
                  setIsLoggingPain(true);
                }}
                className="w-full accent-health-green"
              />
              <div className="mt-1 flex justify-between text-[11px] font-bold text-slate-400">
                <span>0 {isAr ? '(بدون ألم)' : '(None)'}</span>
                <span>5 {isAr ? '(متوسط)' : '(Mod)'}</span>
                <span>10 {isAr ? '(حاد)' : '(Severe)'}</span>
              </div>
            </div>

            {isLoggingPain && (
              <button
                type="button"
                onClick={handleSavePain}
                className="mt-3 w-full rounded-xl bg-health-green py-2 text-center text-xs font-bold text-slate-950 transition hover:bg-[#d3aa54]"
              >
                {isAr ? `تأكيد تسجيل الألم (${sliderPain}/10)` : `Save Pain Reading (${sliderPain}/10)`}
              </button>
            )}

            {/* Safe loading clinical advice */}
            <div className="mt-4 rounded-xl border border-amber-200/70 bg-amber-50/80 p-3 text-xs leading-relaxed text-amber-900 dark:border-amber-900/40 dark:bg-amber-950/40 dark:text-amber-200">
              <div className="flex items-start gap-2">
                <ShieldAlert className="mt-0.5 h-3.5 w-3.5 shrink-0 text-amber-600" />
                <div>
                  <div className="font-bold">
                    {isAr ? 'قاعدة الـ 24 ساعة السريرية:' : '24-Hour Clinical Rule:'}
                  </div>
                  <p className="mt-1 text-[11px]">
                    {isAr
                      ? 'الألم الخفيف (حتى 3/10) أثناء التمرين مقبول، شرط أن يهدأ بعد ساعة، ولا يزيد الألم أو الانتفاخ في صباح اليوم التالي.'
                      : 'Mild pain (up to 3/10) during exercise is acceptable if it settles within 1 hour and symptoms do not flare up the next morning.'}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
});

export default MyRecoveryJourney;
