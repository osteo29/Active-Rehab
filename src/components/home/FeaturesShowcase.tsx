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
  const isEn = lang === 'en';

  const principles = [
    {
      icon: HeartPulse,
      title: isEn ? 'Start with the issue' : 'ابدأ بالمشكلة التي تواجهك',
      desc: isEn
        ? 'Find an injury guide first, then move to the exercises and advice that make sense for that stage.'
        : 'ابدأ بدليل الإصابة، ثم انتقل للتمارين والنصائح التي تناسب مرحلتك الحالية.',
    },
    {
      icon: Target,
      title: isEn ? 'Use the tools you need' : 'استخدم الأداة التي تحتاجها',
      desc: isEn
        ? 'Use calculators for a quick check, then save the numbers you want to follow over time.'
        : 'استخدم الحاسبات لتقييم سريع، ثم سجّل الأرقام التي تريد متابعتها مع الوقت.',
    },
    {
      icon: ShieldCheck,
      title: isEn ? 'Keep it safe and realistic' : 'تدرّج بشكل آمن وواقعي',
      desc: isEn
        ? 'Use the cautions and progression notes to make decisions without pushing through warning signs.'
        : 'راجع التنبيهات ومعايير التدرّج حتى لا تضغط على نفسك رغم إشارات الألم أو التهيّج.',
    },
  ];

  return (
    <section className="section-surface home-band relative overflow-hidden bg-transparent py-16 sm:py-20">
      <div className="absolute right-0 top-0 h-80 w-80 translate-x-1/4 -translate-y-1/4 rounded-full bg-health-green/8 blur-[110px]" />

      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-10 max-w-3xl">
          <div className="text-xs font-bold uppercase tracking-[0.18em] text-health-green">
            {isEn ? 'Start here' : 'ابدأ من هنا'}
          </div>
          <h2 className="mt-3 text-3xl font-black tracking-tight text-slate-900 sm:text-4xl">
            {isEn ? 'Choose the next useful step, not another long list' : 'اختر خطوتك التالية بدل ما تتوه بين خيارات كثيرة'}
          </h2>
          <p className="mt-4 text-base leading-7 text-slate-600 sm:text-lg">
            {isEn
              ? 'Whether you are returning after pain, rebuilding your routine, or checking a health number, each section has a clear purpose.'
              : 'سواء كنت راجع بعد ألم، أو تبني روتينك من جديد، أو تراجع رقمًا صحيًا، كل قسم هنا له وظيفة واضحة.'}
          </p>
        </div>

        <div className="grid gap-5 lg:grid-cols-[minmax(0,1.2fr)_minmax(320px,0.8fr)]">
          <div className="grid gap-4 md:grid-cols-3">
            {quickSections.map((section, index) => (
              <a
                key={section.id}
                href={`#${section.id}`}
                className="panel-soft group rounded-[2rem] p-6 transition-[transform,box-shadow,border-color] hover:-translate-y-1 hover:border-health-green/30 hover:shadow-lg"
              >
                <div className="mb-5 flex items-center justify-between gap-3">
                  <div className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-950 text-health-green shadow-sm">
                    <section.icon className="h-5 w-5" />
                  </div>
                  <div className="text-xs font-black tracking-[0.18em] text-slate-400">
                    {String(index + 1).padStart(2, '0')}
                  </div>
                </div>
                <h3 className="text-lg font-bold text-slate-900">{section.title}</h3>
                <p className="mt-3 text-sm leading-6 text-slate-600">{section.desc}</p>
                <div className="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-health-green">
                  <span>{isEn ? 'Go to this section' : 'اذهب إلى القسم'}</span>
                  <ArrowRight className={`h-4 w-4 ${lang === 'ar' ? 'rotate-180' : ''}`} />
                </div>
              </a>
            ))}
          </div>

          <div className="panel-strong rounded-[2rem] p-6 text-white">
            <div className="text-xs font-bold uppercase tracking-[0.18em] text-amber-100/80">
              {isEn ? 'What you can do here' : 'ماذا يمكنك أن تفعل هنا'}
            </div>
            <div className="mt-5 space-y-4">
              {principles.map((item) => (
                <div key={item.title} className="rounded-[1.5rem] border border-white/10 bg-white/6 p-4">
                  <div className="flex items-start gap-3">
                    <div className="mt-0.5 inline-flex h-10 w-10 items-center justify-center rounded-2xl bg-white/8 text-health-green">
                      <item.icon className="h-5 w-5" />
                    </div>
                    <div>
                      <h3 className="text-base font-bold text-white">{item.title}</h3>
                      <p className="mt-2 text-sm leading-6 text-slate-300">{item.desc}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
});

FeaturesShowcase.displayName = 'FeaturesShowcase';

export default FeaturesShowcase;
