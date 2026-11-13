import {useState, useMemo} from 'react';
import {
  Activity,
  ArrowRight,
  BookOpen,
  CheckCircle2,
  ChevronRight,
  Compass,
  Dumbbell,
  ExternalLink,
  Eye,
  Film,
  Layers,
  Play,
  Search,
  ShieldCheck,
  Sparkles,
  Video,
  X,
  Zap,
} from 'lucide-react';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import {
  getAllMuscles,
  getAllBodyIqExercises,
  getMuscleTargetedExercises,
  type MuscleDetail,
  type MuscleTargetedExercises,
  type BodyIqExerciseEmbed,
} from '../services/exerciseBiomechanicsService';

const REGION_CATEGORIES = [
  {id: 'all', en: 'All Regions', ar: 'جميع المناطق'},
  {id: 'shoulder', en: 'Shoulder', ar: 'الكتف والكفة المدورة'},
  {id: 'chest', en: 'Chest', ar: 'الصدر'},
  {id: 'arm', en: 'Arm & Hand', ar: 'الذراع والساعد واليد'},
  {id: 'neck', en: 'Neck & Head', ar: 'العنق والرأس'},
  {id: 'spine_core', en: 'Spine & Core', ar: 'الظهر والجذع والبطن'},
  {id: 'hip_pelvis', en: 'Hip & Pelvis', ar: 'الورك والحوض'},
  {id: 'knee_thigh', en: 'Thigh & Knee', ar: 'الفخذ والركبة'},
  {id: 'ankle_foot', en: 'Leg, Ankle & Foot', ar: 'الساق والكاحل والقدم'},
];

export default function AnatomyPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';

  const [activeTab, setActiveTab] = useState<'muscles' | 'videos'>('muscles');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRegion, setSelectedRegion] = useState('all');
  const [activeMuscle, setActiveMuscle] = useState<MuscleDetail | null>(null);
  const [playingVideoId, setPlayingVideoId] = useState<string | null>(null);
  const [modalPlayingVideo, setModalPlayingVideo] = useState<string | null>(null);

  const allMuscles = useMemo(() => getAllMuscles(), []);
  const allVideoExercises = useMemo(() => getAllBodyIqExercises(), []);

  // Filtered Muscles
  const filteredMuscles = useMemo(() => {
    return allMuscles.filter((muscle) => {
      if (selectedRegion !== 'all' && muscle.region !== selectedRegion) {
        return false;
      }
      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase().trim();
      const matchName = muscle.name.toLowerCase().includes(q);
      const matchNameAr = (muscle.name_ar || '').includes(q);
      const matchAction = (muscle.action || '').toLowerCase().includes(q);
      const matchNerve = (muscle.innervation || '').toLowerCase().includes(q);
      const matchOrigin = (muscle.origin || '').toLowerCase().includes(q);
      const matchInsertion = (muscle.insertion || '').toLowerCase().includes(q);
      return matchName || matchNameAr || matchAction || matchNerve || matchOrigin || matchInsertion;
    });
  }, [allMuscles, selectedRegion, searchQuery]);

  // Filtered Video Exercises
  const filteredVideos = useMemo(() => {
    return allVideoExercises.filter((ex) => {
      if (selectedRegion !== 'all') {
        const r = ex.region.toLowerCase();
        if (selectedRegion === 'shoulder' && !r.includes('shoulder')) return false;
        if (selectedRegion === 'chest' && !r.includes('chest')) return false;
        if (selectedRegion === 'arm' && !r.includes('arm') && !r.includes('forearm') && !r.includes('grip')) return false;
        if (selectedRegion === 'neck' && !r.includes('neck') && !r.includes('head')) return false;
        if (selectedRegion === 'spine_core' && !r.includes('core') && !r.includes('spine') && !r.includes('back')) return false;
        if (selectedRegion === 'hip_pelvis' && !r.includes('hip') && !r.includes('pelvis')) return false;
        if (selectedRegion === 'knee_thigh' && !r.includes('knee')) return false;
        if (selectedRegion === 'ankle_foot' && !r.includes('ankle') && !r.includes('foot')) return false;
      }
      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase().trim();
      const matchName = ex.nameEn.toLowerCase().includes(q);
      const matchNameAr = (ex.nameAr || '').includes(q);
      const matchJoint = (ex.targetJoint || '').toLowerCase().includes(q);
      const matchPattern = (ex.movementPattern || '').toLowerCase().includes(q);
      const matchPrimary = (ex.primaryMuscle || '').toLowerCase().includes(q);
      const matchSecondary = (ex.secondaryMuscles || '').toLowerCase().includes(q);
      const matchCue = (ex.coachingCue || '').includes(q);
      return matchName || matchNameAr || matchJoint || matchPattern || matchPrimary || matchSecondary || matchCue;
    });
  }, [allVideoExercises, selectedRegion, searchQuery]);

  const activeMuscleExercises: MuscleTargetedExercises = useMemo(() => {
    if (!activeMuscle) return {primary: [], stabilizer: []};
    return getMuscleTargetedExercises(activeMuscle.slug);
  }, [activeMuscle]);

  const pageTitle = isAr ? 'مكتبة التشريح والتمارين المصورة' : 'Clinical Anatomy & Video Rehabilitation Engine';

  return (
    <PageLayout title={pageTitle}>
      <div className="not-prose space-y-8">
        {/* Header Hero Section */}
        <section className="relative overflow-hidden rounded-[2.5rem] border border-slate-200 bg-[radial-gradient(ellipse_at_top_right,rgba(16,185,129,0.15),transparent_55%),linear-gradient(180deg,#ffffff,#f8fafc)] p-6 sm:p-10 shadow-sm dark:border-slate-800 dark:bg-slate-900/90">
          <div className="max-w-3xl space-y-4">
            <div className="inline-flex items-center gap-2 rounded-full border border-health-green/30 bg-health-green/10 px-3.5 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green-dark dark:text-health-green">
              <ShieldCheck className="h-4 w-4" />
              <span>{isAr ? 'مرجع تشريحي وتأهيلي معتمد' : 'Verified Clinical Biomechanics Engine'}</span>
            </div>
            <h1 className="text-3xl font-black tracking-tight text-slate-900 dark:text-white sm:text-4xl">
              {isAr ? 'مكتبة التشريح الوظيفي وتمارين التأهيل' : 'Functional Anatomy & Video Rehabilitation Library'}
            </h1>
            <p className="text-base leading-8 text-slate-600 dark:text-slate-300">
              {isAr
                ? 'مرجع تشريحي تفاعلي لـ 107 عضلات بالصور الطبية المباشرة وتفاصيل المنشأ والاندغام والتعصيب، مع 117 تمرين تأهيلي موثق بمشغل فيديو مباشر وتوجيهات الأداء السريري.'
                : 'Interactive clinical anatomy index of 107 human muscles with verified Wikimedia illustrations, full O/I/A/N/B specs, plus 117 rehabilitation exercises featuring inline video player & clinical coaching cues.'}
            </p>
          </div>

          {/* Quick Metrics Bar */}
          <div className="mt-8 grid grid-cols-2 gap-3 sm:grid-cols-4">
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-slate-900 dark:text-white">{allMuscles.length}</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'عضلة موثقة بالصور O/I/A/N/B' : 'Muscles with Diagrams'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-health-green">{allVideoExercises.length}</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'تمرين بالفيديو المباشر' : 'Video Rehab Exercises'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-slate-900 dark:text-white">756</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'إجمالي تمارين المنصة' : 'Total Exercise Catalog'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-amber-500">100%</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'تضمين مباشر بلا إعلانات' : 'Direct Zero-Latency Embeds'}</div>
            </div>
          </div>
        </section>

        {/* View Switcher Tabs */}
        <section className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4 border-b border-slate-200 pb-4 dark:border-slate-800">
          <div className="inline-flex rounded-2xl bg-slate-100 p-1.5 dark:bg-slate-800">
            <button
              onClick={() => setActiveTab('muscles')}
              className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-bold transition ${
                activeTab === 'muscles'
                  ? 'bg-white text-slate-900 shadow-sm dark:bg-slate-900 dark:text-white'
                  : 'text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
              }`}
            >
              <Activity className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'مكتبة العضلات والتشريح (107)' : 'Anatomy & Muscles (107)'}</span>
            </button>
            <button
              onClick={() => setActiveTab('videos')}
              className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-bold transition ${
                activeTab === 'videos'
                  ? 'bg-white text-slate-900 shadow-sm dark:bg-slate-900 dark:text-white'
                  : 'text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
              }`}
            >
              <Film className="h-4 w-4 text-rose-500" />
              <span>{isAr ? 'تمارين التأهيل بالفيديو (117)' : 'Video Rehab Library (117)'}</span>
            </button>
          </div>

          <div className="text-xs font-semibold text-slate-500 dark:text-slate-400">
            {activeTab === 'muscles'
              ? isAr ? `${filteredMuscles.length} عضلة مطابقة` : `${filteredMuscles.length} muscles found`
              : isAr ? `${filteredVideos.length} تمرين فيديو مطابق` : `${filteredVideos.length} video exercises found`}
          </div>
        </section>

        {/* Search & Region Filter Bar */}
        <section className="space-y-4">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400 rtl:left-auto rtl:right-4" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder={
                activeTab === 'muscles'
                  ? isAr
                    ? 'ابحث باسم العضلة، العصب، الحركة أو المنشأ (مثال: Gluteus, القترية, Femoral nerve, Flexion)...'
                    : 'Search by muscle name, nerve, action or origin (e.g. Supraspinatus, VMO, Femoral nerve)...'
                  : isAr
                    ? 'ابحث باسم التمرين، المفصل المستهدف، نمط الحركة، أو العضلة (مثال: Bird-Dog, ركبة, Lumbar, Glute)...'
                    : 'Search by exercise name, target joint, pattern, or muscle (e.g. Bird-Dog, Lumbar, Abduction)...'
              }
              className="w-full rounded-2xl border border-slate-200 bg-white py-3.5 pl-12 pr-4 text-sm font-medium text-slate-800 shadow-sm placeholder:text-slate-400 focus:border-health-green focus:outline-none focus:ring-2 focus:ring-health-green/20 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-100 rtl:pl-4 rtl:pr-12"
            />
          </div>

          {/* Region Tabs */}
          <div className="flex flex-wrap gap-2">
            {REGION_CATEGORIES.map((cat) => {
              const count =
                activeTab === 'muscles'
                  ? cat.id === 'all'
                    ? allMuscles.length
                    : allMuscles.filter((m) => m.region === cat.id).length
                  : cat.id === 'all'
                    ? allVideoExercises.length
                    : allVideoExercises.filter((ex) => {
                        const r = ex.region.toLowerCase();
                        if (cat.id === 'shoulder') return r.includes('shoulder');
                        if (cat.id === 'chest') return r.includes('chest');
                        if (cat.id === 'arm') return r.includes('arm') || r.includes('forearm') || r.includes('grip');
                        if (cat.id === 'neck') return r.includes('neck') || r.includes('head');
                        if (cat.id === 'spine_core') return r.includes('core') || r.includes('spine') || r.includes('back');
                        if (cat.id === 'hip_pelvis') return r.includes('hip') || r.includes('pelvis');
                        if (cat.id === 'knee_thigh') return r.includes('knee');
                        if (cat.id === 'ankle_foot') return r.includes('ankle') || r.includes('foot');
                        return false;
                      }).length;

              const isActive = selectedRegion === cat.id;
              return (
                <button
                  key={cat.id}
                  onClick={() => setSelectedRegion(cat.id)}
                  className={`inline-flex items-center gap-2 rounded-xl px-3.5 py-2 text-xs font-bold transition ${
                    isActive
                      ? 'bg-slate-900 text-white shadow dark:bg-health-green dark:text-slate-950'
                      : 'border border-slate-200 bg-white text-slate-700 hover:border-slate-300 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300 dark:hover:bg-slate-800'
                  }`}
                >
                  <span>{isAr ? cat.ar : cat.en}</span>
                  <span
                    className={`rounded-full px-2 py-0.5 text-[10px] ${
                      isActive
                        ? 'bg-white/20 text-white dark:bg-slate-950/20 dark:text-slate-950'
                        : 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400'
                    }`}
                  >
                    {count}
                  </span>
                </button>
              );
            })}
          </div>
        </section>

        {/* ----------------- TAB 1: MUSCLES DIRECT CARDS ----------------- */}
        {activeTab === 'muscles' && (
          <section className="space-y-4">
            <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {filteredMuscles.map((muscle) => {
                const exercises = getMuscleTargetedExercises(muscle.slug);
                const totalExercises = exercises.primary.length + exercises.stabilizer.length;

                return (
                  <div
                    key={muscle.slug}
                    onClick={() => {
                      setActiveMuscle(muscle);
                      setModalPlayingVideo(null);
                    }}
                    className="group relative flex cursor-pointer flex-col justify-between overflow-hidden rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-1 hover:border-health-green/40 hover:shadow-lg dark:border-slate-800 dark:bg-slate-900"
                  >
                    <div>
                      {/* Direct Medical Image Preview */}
                      {muscle.image_url ? (
                        <div className="relative mb-4 h-48 w-full overflow-hidden rounded-xl border border-slate-100 bg-slate-50 p-2 dark:border-slate-800/60 dark:bg-slate-800/50 flex items-center justify-center">
                          <img
                            src={muscle.image_url}
                            alt={muscle.name}
                            loading="lazy"
                            className="h-full w-full object-contain transition-transform duration-300 group-hover:scale-105"
                          />
                          <div className="absolute top-2 left-2 rtl:left-auto rtl:right-2 rounded-md bg-black/60 px-2 py-0.5 text-[10px] font-bold text-white backdrop-blur-sm">
                            {muscle.id || 'ANATOMY'}
                          </div>
                        </div>
                      ) : (
                        <div className="mb-4 flex h-36 w-full items-center justify-center rounded-xl bg-slate-100 text-slate-400 dark:bg-slate-800">
                          <Activity className="h-10 w-10 opacity-40" />
                        </div>
                      )}

                      <div className="flex items-start justify-between gap-2">
                        <span className="inline-block rounded-md bg-slate-100 px-2.5 py-1 text-[11px] font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                          {muscle.region.replace('_', ' ').toUpperCase()}
                        </span>
                        {totalExercises > 0 && (
                          <div className="inline-flex items-center gap-1 rounded-full bg-health-green/10 px-2.5 py-0.5 text-[11px] font-semibold text-health-green-dark dark:text-health-green">
                            <Dumbbell className="h-3 w-3" />
                            <span>{totalExercises} {isAr ? 'تمرين' : 'ex'}</span>
                          </div>
                        )}
                      </div>

                      <div className="mt-3">
                        <h3 className="text-base font-black text-slate-900 group-hover:text-health-green dark:text-white">
                          {muscle.name}
                        </h3>
                        {muscle.name_ar && muscle.name_ar !== muscle.name && (
                          <div className="text-xs font-bold text-slate-500 dark:text-slate-400">{muscle.name_ar}</div>
                        )}
                      </div>

                      {muscle.action && (
                        <p className="mt-3 line-clamp-2 text-xs leading-5 text-slate-600 dark:text-slate-400">
                          <span className="font-bold text-slate-700 dark:text-slate-300">{isAr ? 'الحركة: ' : 'Action: '}</span>
                          {muscle.action}
                        </p>
                      )}

                      {muscle.innervation && (
                        <div className="mt-2 text-[11px] text-slate-500 dark:text-slate-400">
                          <span className="font-semibold text-slate-600 dark:text-slate-300">{isAr ? 'العصب: ' : 'Nerve: '}</span>
                          {muscle.innervation}
                        </div>
                      )}
                    </div>

                    <div className="mt-4 flex items-center justify-between border-t border-slate-100 pt-3 text-xs font-bold text-health-green dark:border-slate-800">
                      <span>{isAr ? 'عرض التفاصيل والتشريح الكامل' : 'View anatomy & exercises'}</span>
                      <ChevronRight className="h-4 w-4 transition group-hover:translate-x-1 rtl:rotate-180 rtl:group-hover:-translate-x-1" />
                    </div>
                  </div>
                );
              })}
            </div>

            {filteredMuscles.length === 0 && (
              <div className="rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-12 text-center text-slate-500 dark:border-slate-800 dark:bg-slate-900/50">
                <BookOpen className="mx-auto h-8 w-8 text-slate-400" />
                <div className="mt-3 text-sm font-bold">{isAr ? 'لم يتم العثور على عضلات مطابقة للبحث' : 'No muscles match your search criteria'}</div>
              </div>
            )}
          </section>
        )}

        {/* ----------------- TAB 2: 117 REHAB VIDEOS CARDS ----------------- */}
        {activeTab === 'videos' && (
          <section className="space-y-4">
            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {filteredVideos.map((ex) => {
                const isPlaying = playingVideoId === ex.id;

                return (
                  <div
                    key={ex.id}
                    className="flex flex-col justify-between overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition hover:border-health-green/40 hover:shadow-lg dark:border-slate-800 dark:bg-slate-900"
                  >
                    {/* Video Player Header */}
                    <div className="relative aspect-video w-full bg-slate-950">
                      {isPlaying ? (
                        <iframe
                          src={`${ex.embedVideoUrl}?autoplay=1&rel=0&modestbranding=1`}
                          title={ex.nameEn}
                          className="h-full w-full border-0"
                          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                          allowFullScreen
                        />
                      ) : (
                        <div
                          onClick={() => setPlayingVideoId(ex.id)}
                          className="group/thumb relative h-full w-full cursor-pointer overflow-hidden bg-slate-900 flex items-center justify-center"
                        >
                          <img
                            src={`https://img.youtube.com/vi/${ex.youtubeId}/hqdefault.jpg`}
                            alt={ex.nameEn}
                            className="h-full w-full object-cover opacity-80 transition duration-300 group-hover/thumb:scale-105 group-hover/thumb:opacity-95"
                            loading="lazy"
                          />
                          <div className="absolute inset-0 bg-black/30 backdrop-blur-[1px] transition group-hover/thumb:bg-black/10" />
                          <div className="relative flex h-14 w-14 items-center justify-center rounded-full bg-health-green text-slate-950 shadow-xl transition-transform duration-300 group-hover/thumb:scale-110">
                            <Play className="h-6 w-6 fill-current pl-0.5" />
                          </div>
                          <div className="absolute bottom-2 right-2 rounded bg-black/70 px-2 py-0.5 text-[10px] font-bold text-white">
                            {ex.id}
                          </div>
                        </div>
                      )}
                    </div>

                    {/* Card Content */}
                    <div className="p-5 flex-1 flex flex-col justify-between space-y-4">
                      <div>
                        {/* Badges */}
                        <div className="flex flex-wrap gap-1.5">
                          <span className="rounded-md bg-health-green/10 px-2 py-0.5 text-[10px] font-bold text-health-green-dark dark:text-health-green">
                            {ex.region}
                          </span>
                          <span className="rounded-md bg-blue-500/10 px-2 py-0.5 text-[10px] font-bold text-blue-600 dark:text-blue-400">
                            {ex.targetJoint}
                          </span>
                          <span className="rounded-md bg-purple-500/10 px-2 py-0.5 text-[10px] font-bold text-purple-600 dark:text-purple-400">
                            {ex.movementPattern}
                          </span>
                        </div>

                        {/* Titles */}
                        <div className="mt-3">
                          <h3 className="text-base font-black text-slate-900 dark:text-white">
                            {isAr ? ex.nameAr : ex.nameEn}
                          </h3>
                          <div className="text-xs font-semibold text-slate-500 dark:text-slate-400">
                            {isAr ? ex.nameEn : ex.nameAr}
                          </div>
                        </div>

                        {/* Muscles Target */}
                        <div className="mt-3 space-y-1 text-xs">
                          <div>
                            <span className="font-bold text-slate-700 dark:text-slate-300">{isAr ? 'العضلة الأساسية: ' : 'Primary Muscle: '}</span>
                            <span className="font-semibold text-health-green-dark dark:text-health-green">{ex.primaryMuscle}</span>
                          </div>
                          {ex.secondaryMuscles && (
                            <div className="text-[11px] text-slate-500 dark:text-slate-400">
                              <span className="font-medium text-slate-600 dark:text-slate-300">{isAr ? 'عضلات مساعدة: ' : 'Stabilizers: '}</span>
                              <span>{ex.secondaryMuscles}</span>
                            </div>
                          )}
                        </div>

                        {/* Arabic Coaching Cue */}
                        {ex.coachingCue && (
                          <div className="mt-3 rounded-xl border border-emerald-500/20 bg-emerald-50/70 p-3 text-xs leading-5 text-emerald-950 dark:border-emerald-900/30 dark:bg-emerald-950/20 dark:text-emerald-200">
                            <span className="font-bold text-emerald-800 dark:text-emerald-400">{isAr ? 'توجيه الأداء السريري: ' : 'Clinical Cue: '}</span>
                            {ex.coachingCue}
                          </div>
                        )}
                      </div>

                      {/* Footer Actions */}
                      <div className="flex items-center justify-between border-t border-slate-100 pt-3 text-xs font-bold text-slate-600 dark:border-slate-800 dark:text-slate-400">
                        <button
                          type="button"
                          onClick={() => setPlayingVideoId(isPlaying ? null : ex.id)}
                          className="inline-flex items-center gap-1.5 text-health-green hover:underline"
                        >
                          <Video className="h-3.5 w-3.5" />
                          <span>{isPlaying ? (isAr ? 'إيقاف الفيديو' : 'Stop') : (isAr ? 'تشغيل مباشر' : 'Play Video')}</span>
                        </button>

                        <a
                          href={`https://www.youtube.com/watch?v=${ex.youtubeId}`}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-1 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200"
                        >
                          <span>YouTube</span>
                          <ExternalLink className="h-3 w-3" />
                        </a>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>

            {filteredVideos.length === 0 && (
              <div className="rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-12 text-center text-slate-500 dark:border-slate-800 dark:bg-slate-900/50">
                <Film className="mx-auto h-8 w-8 text-slate-400" />
                <div className="mt-3 text-sm font-bold">{isAr ? 'لم يتم العثور على تمارين فيديو مطابقة للبحث' : 'No video exercises match your search criteria'}</div>
              </div>
            )}
          </section>
        )}

        {/* ----------------- MODAL DETAIL FOR SELECTED MUSCLE ----------------- */}
        {activeMuscle && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/70 p-4 backdrop-blur-sm">
            <div className="relative max-h-[92vh] w-full max-w-2xl overflow-y-auto rounded-3xl border border-slate-200 bg-white p-6 shadow-2xl dark:border-slate-800 dark:bg-slate-900 sm:p-8">
              {/* Close Button */}
              <button
                onClick={() => {
                  setActiveMuscle(null);
                  setModalPlayingVideo(null);
                }}
                className="absolute right-5 top-5 rounded-full p-2 text-slate-400 hover:bg-slate-100 hover:text-slate-700 dark:hover:bg-slate-800 dark:hover:text-white rtl:left-5 rtl:right-auto"
              >
                <X className="h-5 w-5" />
              </button>

              {/* Modal Header */}
              <div className="pr-10 rtl:pl-10 rtl:pr-0">
                <div className="inline-block rounded-md bg-health-green/10 px-2.5 py-1 text-xs font-bold uppercase tracking-wider text-health-green">
                  {activeMuscle.region.replace('_', ' ')}
                </div>
                <h2 className="mt-2 text-2xl font-black text-slate-900 dark:text-white">{activeMuscle.name}</h2>
                {activeMuscle.name_ar && (
                  <div className="text-base font-bold text-slate-500 dark:text-slate-400">{activeMuscle.name_ar}</div>
                )}
              </div>

              {/* High-Res Anatomical Diagram Preview */}
              {activeMuscle.image_url && (
                <div className="mt-5 overflow-hidden rounded-2xl border border-slate-200 bg-slate-50 p-4 text-center dark:border-slate-800 dark:bg-slate-800/50">
                  <img
                    src={activeMuscle.image_url}
                    alt={activeMuscle.name}
                    className="mx-auto max-h-72 w-full object-contain"
                  />
                  <div className="mt-2 text-[11px] text-slate-400">
                    {isAr ? 'رسم توضيحي تشريحي معتمد طبياً (Wikimedia Commons)' : 'Clinical anatomical diagram (Wikimedia Commons)'}
                  </div>
                </div>
              )}

              {/* Active Playing Video inside Modal if selected */}
              {modalPlayingVideo && (
                <div className="mt-5 overflow-hidden rounded-2xl border border-slate-800 bg-black">
                  <div className="relative aspect-video w-full">
                    <iframe
                      src={`https://www.youtube.com/embed/${modalPlayingVideo}?autoplay=1&rel=0&modestbranding=1`}
                      title="Rehab Exercise"
                      className="h-full w-full border-0"
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                      allowFullScreen
                    />
                  </div>
                  <div className="flex items-center justify-between p-3 text-xs text-white">
                    <span>{isAr ? 'مشغل الفيديو التأهيلي المباشر' : 'Rehab Video Demonstration'}</span>
                    <button
                      onClick={() => setModalPlayingVideo(null)}
                      className="text-slate-400 hover:text-white"
                    >
                      {isAr ? 'إغلاق الفيديو' : 'Close Video'}
                    </button>
                  </div>
                </div>
              )}

              {/* Anatomy Details Specs */}
              <div className="mt-6 space-y-3 rounded-2xl bg-slate-50 p-4 text-xs leading-6 dark:bg-slate-800/60">
                {activeMuscle.action && (
                  <div>
                    <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'الوظيفة الحركية (Action): ' : 'Action: '}</span>
                    <span className="text-slate-700 dark:text-slate-300">{activeMuscle.action}</span>
                  </div>
                )}
                {activeMuscle.origin && (
                  <div>
                    <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'المنشأ (Origin): ' : 'Origin: '}</span>
                    <span className="text-slate-700 dark:text-slate-300">{activeMuscle.origin}</span>
                  </div>
                )}
                {activeMuscle.insertion && (
                  <div>
                    <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'الاندغام (Insertion): ' : 'Insertion: '}</span>
                    <span className="text-slate-700 dark:text-slate-300">{activeMuscle.insertion}</span>
                  </div>
                )}
                {activeMuscle.innervation && (
                  <div>
                    <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'العصب المغذي (Innervation): ' : 'Innervation: '}</span>
                    <span className="text-slate-700 dark:text-slate-300">{activeMuscle.innervation}</span>
                  </div>
                )}
                {activeMuscle.blood_supply && (
                  <div>
                    <span className="font-bold text-slate-900 dark:text-white">{isAr ? 'التروية الدموية (Blood Supply): ' : 'Blood Supply: '}</span>
                    <span className="text-slate-700 dark:text-slate-300">{activeMuscle.blood_supply}</span>
                  </div>
                )}
              </div>

              {/* Linked Exercises Section */}
              <div className="mt-6 space-y-4">
                <div className="flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                  <Dumbbell className="h-4 w-4 text-health-green" />
                  <span>{isAr ? 'التمارين المرتبطة بهذه العضلة في المنصة' : 'Targeted Exercises in Active Rehab'}</span>
                </div>

                {activeMuscleExercises.primary.length > 0 && (
                  <div>
                    <div className="mb-2 text-xs font-bold text-slate-500">{isAr ? 'عضلة محركة أساسية (Primary Target)' : 'Primary Mover'}</div>
                    <div className="flex flex-wrap gap-2">
                      {activeMuscleExercises.primary.map((ex) => (
                        <div
                          key={ex.id}
                          className="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-1.5 text-xs font-bold text-slate-800 shadow-sm dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
                        >
                          <span>{isAr ? ex.name_ar || ex.name : ex.name}</span>
                          {ex.youtube_id && (
                            <button
                              type="button"
                              onClick={() => setModalPlayingVideo(ex.youtube_id || null)}
                              className="inline-flex items-center gap-1 rounded bg-rose-500/10 px-1.5 py-0.5 text-[10px] font-bold text-rose-600 hover:bg-rose-500/20 dark:text-rose-400"
                            >
                              <Play className="h-2.5 w-2.5 fill-current" />
                              <span>{isAr ? 'فيديو' : 'Video'}</span>
                            </button>
                          )}
                          {ex.provenance === 'body_iq_verified' && (
                            <span className="rounded bg-emerald-100 px-1 py-0.2 text-[9px] font-bold text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300">
                              ✓ Verified
                            </span>
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {activeMuscleExercises.stabilizer.length > 0 && (
                  <div>
                    <div className="mb-2 text-xs font-bold text-slate-500">{isAr ? 'عضلة مثبتة أو مساعدة (Stabilizer / Synergist)' : 'Stabilizer / Synergist'}</div>
                    <div className="flex flex-wrap gap-2">
                      {activeMuscleExercises.stabilizer.map((ex) => (
                        <div
                          key={ex.id}
                          className="inline-flex items-center gap-2 rounded-xl border border-dashed border-slate-300 bg-slate-50 px-3 py-1.5 text-xs font-medium text-slate-700 dark:border-slate-700 dark:bg-slate-850 dark:text-slate-300"
                        >
                          <span>{isAr ? ex.name_ar || ex.name : ex.name}</span>
                          {ex.youtube_id && (
                            <button
                              type="button"
                              onClick={() => setModalPlayingVideo(ex.youtube_id || null)}
                              className="inline-flex items-center gap-1 rounded bg-rose-500/10 px-1.5 py-0.5 text-[10px] font-bold text-rose-600 hover:bg-rose-500/20 dark:text-rose-400"
                            >
                              <Play className="h-2.5 w-2.5 fill-current" />
                              <span>{isAr ? 'فيديو' : 'Video'}</span>
                            </button>
                          )}
                          {ex.provenance === 'body_iq_verified' && (
                            <span className="rounded bg-emerald-100 px-1 py-0.2 text-[9px] font-bold text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300">
                              ✓ Verified
                            </span>
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {activeMuscleExercises.primary.length === 0 && activeMuscleExercises.stabilizer.length === 0 && (
                  <div className="rounded-xl border border-dashed border-slate-200 p-4 text-center text-xs text-slate-500">
                    {isAr ? 'لا توجد تمارين مسجلة محددة لهذه العضلة بالاسم حتى الآن.' : 'No direct exercises currently recorded for this muscle.'}
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </PageLayout>
  );
}
