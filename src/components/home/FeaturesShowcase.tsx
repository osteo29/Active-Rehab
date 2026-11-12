import {memo} from 'react';
import type {Language} from '../../services/translations';
import {ArrowRight, HeartPulse, ShieldCheck, Target} from 'lucide-react';

interface QuickSection {
  id: string;
  title: string;
  desc: string;
  icon: React.ElementType;
}

interface FeaturesShowcaseProps {
  lang: Language;
  quickSections: QuickSection[];
}

const FeaturesShowcase = memo(({lang, quickSections}: FeaturesShowcaseProps) => {
  const isAr = lang === 'ar';

  const principles = [
    {
      icon: HeartPulse,
      title: isAr ? 'ابدأ بالمشكلة التي تواجهك' : 'Start With Your Issue',
      desc: isAr
        ? 'اختر إصابتك لتتعرف على التمارين والتغذية المناسبة لمرحلتك الحالية.'
        : 'Find an injury guide first to get stage-specific exercise and nutrition.',
    },
    {
      icon: Target,
      title: isAr ? 'تابع تطورك خطوة بخطوة' : 'Track Your Milestones',
      desc: isAr
        ? 'سجل الألم، التزم بأهداف المرحلة، وتقدم من مرحلة 1 إلى 2 إلى 3.'
        : 'Log daily pain, complete phase goals, and advance smoothly.',
    },
    {
      icon: ShieldCheck,
      title: isAr ? 'تدرّج آمن بدون تهييج' : 'Safe Evidence-Based Loading',
      desc: isAr
        ? 'معايير أمان سريرية واضحة تمنع الانتكاس وتضمن عودة قوية.'
        : 'Clear safety markers to prevent re-injury and ensure lasting recovery.',
    },
  ];

  return (
    <section className="relative overflow-hidden bg-slate-50/70 py-10 dark:bg-slate-950 sm:py-14">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
          <div>
            <div className="text-xs font-bold uppercase tracking-wider text-health-green">
              {isAr ? 'منهجية العمل' : 'Our Approach'}
            </div>
            <h2 className="mt-1 text-2xl font-black text-slate-900 dark:text-white sm:text-3xl">
              {isAr ? 'خطوات عملية واضحة بدلاً من العشوائية' : 'Clear Practical Steps, Zero Confusion'}
            </h2>
          </div>
          <p className="max-w-xl text-xs leading-relaxed text-slate-500 dark:text-slate-400 sm:text-sm">
            {isAr
              ? 'صممنا المنصة لتكون دليلك العملي المباشر: تختار حالتك، تعرف ماذا تفعل اليوم، وتراقب تعافيك بهدوء.'
              : 'Built to give you actionable guidance: choose your condition, know today’s focus, and track progress.'}
          </p>
        </div>

        {/* 3 Principles Cards */}
        <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {principles.map((item) => (
            <div
              key={item.title}
              className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm transition hover:border-health-green/40 dark:border-slate-800 dark:bg-slate-900"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-health-green/10 text-health-green">
                  <item.icon className="h-5 w-5" />
                </div>
                <h3 className="text-sm font-bold text-slate-900 dark:text-white">{item.title}</h3>
              </div>
              <p className="mt-2.5 text-xs leading-relaxed text-slate-600 dark:text-slate-300">
                {item.desc}
              </p>
            </div>
          ))}
        </div>

        {/* Quick jump pills */}
        {quickSections && quickSections.length > 0 && (
          <div className="mt-6 flex flex-wrap items-center gap-2 pt-2">
            <span className="text-xs font-bold uppercase text-slate-400">
              {isAr ? 'انتقال سريع:' : 'Quick Jump:'}
            </span>
            {quickSections.map((sec) => (
              <a
                key={sec.id}
                href={`#${sec.id}`}
                className="inline-flex items-center gap-1.5 rounded-full border border-slate-200 bg-white px-3.5 py-1.5 text-xs font-bold text-slate-700 shadow-xs transition hover:border-health-green/40 hover:text-health-green dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
              >
                <span>{sec.title}</span>
                <ArrowRight className={`h-3 w-3 ${isAr ? 'rotate-180' : ''}`} />
              </a>
            ))}
          </div>
        )}
      </div>
    </section>
  );
});

FeaturesShowcase.displayName = 'FeaturesShowcase';

export default FeaturesShowcase;
