import {useState, useMemo} from 'react';
import {Link} from 'react-router-dom';
import {
  Activity,
  ArrowRight,
  BookOpen,
  CheckCircle2,
  ChevronRight,
  Dumbbell,
  ExternalLink,
  Layers,
  Search,
  ShieldCheck,
  Sparkles,
  X,
  Zap,
} from 'lucide-react';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import {
  getAllMuscles,
  getMuscleTargetedExercises,
  type MuscleDetail,
  type MuscleTargetedExercises,
} from '../services/exerciseBiomechanicsService';
import {navigationPaths} from '../utils/langUrlHelper';

const REGION_CATEGORIES = [
  {id: 'all', en: 'All Muscles', ar: 'جميع العضلات'},
  {id: 'shoulder', en: 'Shoulder', ar: 'الكتف والكفة المدورة'},
  {id: 'chest', en: 'Chest', ar: 'الصدر'},
  {id: 'arm', en: 'Arm & Forearm', ar: 'الذراع والساعد واليد'},
  {id: 'neck', en: 'Neck', ar: 'العنق'},
  {id: 'spine_core', en: 'Spine & Core', ar: 'الظهر والعمود الفقري والجذع'},
  {id: 'hip_pelvis', en: 'Hip & Pelvis', ar: 'الورك والحوض'},
  {id: 'knee_thigh', en: 'Thigh & Knee', ar: 'الفخذ والركبة'},
  {id: 'ankle_foot', en: 'Leg, Ankle & Foot', ar: 'الساق والكاحل والقدم'},
];

export default function AnatomyPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRegion, setSelectedRegion] = useState('all');
  const [activeMuscle, setActiveMuscle] = useState<MuscleDetail | null>(null);

  const allMuscles = useMemo(() => getAllMuscles(), []);

  const filteredMuscles = useMemo(() => {
    return allMuscles.filter((muscle) => {
      // Region filter
      if (selectedRegion !== 'all' && muscle.region !== selectedRegion) {
        return false;
      }
      // Search filter
      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase().trim();
      const matchName = muscle.name.toLowerCase().includes(q);
      const matchNameAr = (muscle.name_ar || '').includes(q);
      const matchAction = (muscle.action || '').toLowerCase().includes(q);
      const matchNerve = (muscle.innervation || '').toLowerCase().includes(q);
      return matchName || matchNameAr || matchAction || matchNerve;
    });
  }, [allMuscles, selectedRegion, searchQuery]);

  const activeMuscleExercises: MuscleTargetedExercises = useMemo(() => {
    if (!activeMuscle) return {primary: [], stabilizer: []};
    return getMuscleTargetedExercises(activeMuscle.slug);
  }, [activeMuscle]);

  const pageTitle = isAr ? 'مكتبة التشريح والميكانيكا الحيوية' : 'Clinical Anatomy & Muscle Knowledge Base';

  return (
    <PageLayout title={pageTitle}>
      <div className="not-prose space-y-8">
        {/* Header Hero Section */}
        <section className="relative overflow-hidden rounded-[2.5rem] border border-slate-200 bg-[radial-gradient(ellipse_at_top_right,rgba(16,185,129,0.14),transparent_50%),linear-gradient(180deg,#ffffff,#f8fafc)] p-6 sm:p-10 shadow-sm dark:border-slate-800 dark:bg-slate-900/90">
          <div className="max-w-3xl space-y-4">
            <div className="inline-flex items-center gap-2 rounded-full border border-health-green/30 bg-health-green/10 px-3.5 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green-dark dark:text-health-green">
              <ShieldCheck className="h-4 w-4" />
              <span>{isAr ? 'مرجع تشريحي سريري معتمد' : 'Verified Clinical Anatomy'}</span>
            </div>
            <h1 className="text-3xl font-black tracking-tight text-slate-900 dark:text-white sm:text-4xl">
              {isAr ? 'مكتبة العضلات والتشريح الوظيفي' : 'Functional Muscle & Movement Engine'}
            </h1>
            <p className="text-base leading-8 text-slate-600 dark:text-slate-300">
              {isAr
                ? 'مرجع تشريحي كامل لـ 107 عضلات مدعومة بالمنشأ والاندغام، العصب المغذي، الحركات المفصلية، ومربوطة بتمارين التأهيل والقوة الوظيفية في المنصة.'
                : 'A comprehensive anatomical index of 107 human muscles with complete origin, insertion, innervation, and joint actions — bidirectionally linked to rehabilitation and strength exercises.'}
            </p>
          </div>

          {/* Quick Metrics Bar */}
          <div className="mt-8 grid grid-cols-2 gap-3 sm:grid-cols-4">
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-slate-900 dark:text-white">{allMuscles.length}</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'عضلة موثقة O/I/A/N/B' : 'Verified Muscles'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-health-green">688</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'تمرين علاجي وقوة' : 'Linked Exercises'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-slate-900 dark:text-white">100%</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'ربط ثنائي تفاعلي' : 'Bidirectional Linking'}</div>
            </div>
            <div className="rounded-2xl border border-slate-200/80 bg-white/80 p-4 shadow-sm dark:border-slate-800 dark:bg-slate-800/80">
              <div className="text-2xl font-black text-amber-500">Tier-1</div>
              <div className="text-xs font-medium text-slate-500 dark:text-slate-400">{isAr ? 'شفافية أدلة بحثية' : 'Evidence Provenance'}</div>
            </div>
          </div>
        </section>

        {/* Filter & Search Bar */}
        <section className="space-y-4">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400 rtl:left-auto rtl:right-4" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder={isAr ? 'ابحث باسم العضلة، العصب، أو الحركة (مثال: Gluteus, Rectus, العضلة الرباعية)...' : 'Search by muscle name, nerve, or action (e.g. Supraspinatus, Femoral nerve, Flexion)...'}
              className="w-full rounded-2xl border border-slate-200 bg-white py-3.5 pl-12 pr-4 text-sm font-medium text-slate-800 shadow-sm placeholder:text-slate-400 focus:border-health-green focus:outline-none focus:ring-2 focus:ring-health-green/20 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-100 rtl:pl-4 rtl:pr-12"
            />
          </div>

          {/* Region Tabs */}
          <div className="flex flex-wrap gap-2">
            {REGION_CATEGORIES.map((cat) => {
              const count = cat.id === 'all' ? allMuscles.length : allMuscles.filter((m) => m.region === cat.id).length;
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

        {/* Muscles Grid */}
        <section className="space-y-4">
          <div className="flex items-center justify-between text-xs font-bold text-slate-500 dark:text-slate-400">
            <span>{isAr ? `عرض ${filteredMuscles.length} عضلة` : `Showing ${filteredMuscles.length} muscles`}</span>
            {searchQuery && (
              <button onClick={() => setSearchQuery('')} className="text-health-green hover:underline">
                {isAr ? 'إعادة ضبط البحث' : 'Clear search'}
              </button>
            )}
          </div>

          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {filteredMuscles.map((muscle) => {
              const exercises = getMuscleTargetedExercises(muscle.slug);
              const totalExercises = exercises.primary.length + exercises.stabilizer.length;

              return (
                <div
                  key={muscle.slug}
                  onClick={() => setActiveMuscle(muscle)}
                  className="group relative flex cursor-pointer flex-col justify-between rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-1 hover:border-health-green/40 hover:shadow-md dark:border-slate-800 dark:bg-slate-900"
                >
                  <div>
                    <div className="flex items-start justify-between gap-2">
                      <div className="inline-block rounded-md bg-slate-100 px-2.5 py-1 text-[11px] font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                        {muscle.region.replace('_', ' ').toUpperCase()}
                      </div>
                      {totalExercises > 0 && (
                        <div className="inline-flex items-center gap-1 rounded-full bg-health-green/10 px-2.5 py-0.5 text-[11px] font-semibold text-health-green-dark dark:text-health-green">
                          <Dumbbell className="h-3 w-3" />
                          <span>{totalExercises}</span>
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
                    <span>{isAr ? 'عرض التفاصيل والتمارين' : 'View anatomy & exercises'}</span>
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

        {/* Modal Detail for Selected Muscle */}
        {activeMuscle && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/70 p-4 backdrop-blur-sm">
            <div className="relative max-h-[90vh] w-full max-w-2xl overflow-y-auto rounded-3xl border border-slate-200 bg-white p-6 shadow-2xl dark:border-slate-800 dark:bg-slate-900 sm:p-8">
              {/* Close Button */}
              <button
                onClick={() => setActiveMuscle(null)}
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
                {activeMuscle.description && (
                  <p className="mt-2 text-xs leading-6 text-slate-600 dark:text-slate-300">{activeMuscle.description}</p>
                )}
              </div>

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
                  <span>{isAr ? 'التمارين المرتبطة بهذه العضلة' : 'Targeted Exercises in Active Rehab'}</span>
                </div>

                {activeMuscleExercises.primary.length > 0 && (
                  <div>
                    <div className="mb-2 text-xs font-bold text-slate-500">{isAr ? 'عضلة محركة أساسية (Primary Target)' : 'Primary Mover'}</div>
                    <div className="flex flex-wrap gap-2">
                      {activeMuscleExercises.primary.map((ex) => (
                        <div
                          key={ex.id}
                          className="inline-flex items-center gap-1.5 rounded-xl border border-slate-200 bg-white px-3 py-1.5 text-xs font-bold text-slate-800 shadow-sm dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
                        >
                          <span>{ex.name}</span>
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
                          className="inline-flex items-center gap-1.5 rounded-xl border border-dashed border-slate-300 bg-slate-50 px-3 py-1.5 text-xs font-medium text-slate-700 dark:border-slate-700 dark:bg-slate-850 dark:text-slate-300"
                        >
                          <span>{ex.name}</span>
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
                    {isAr ? 'لا توجد تمارين محددة مسجلة لهذه العضلة بالاسم حتى الآن.' : 'No direct exercises currently recorded for this muscle.'}
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
