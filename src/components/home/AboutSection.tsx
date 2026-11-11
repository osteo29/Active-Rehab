import {memo} from 'react';
import {
  BadgeCheck,
  Brain,
  Calculator,
  HeartPulse,
  Info,
  Sparkles,
  Stethoscope,
} from 'lucide-react';
import type {Language} from '../../services/translations';

const AboutSection = memo(({lang}: {lang: Language}) => {
  const isAr = lang === 'ar';

  return (
    <section className="relative overflow-hidden bg-[linear-gradient(180deg,rgba(255,252,247,0.98),rgba(248,242,232,0.96))] py-24">
      <div className="pointer-events-none absolute left-0 top-0 h-full w-full overflow-hidden">
        <div className="absolute -left-20 top-1/4 h-96 w-96 rounded-full bg-health-green/5 blur-[100px]" />
        <div className="absolute -right-20 bottom-1/4 h-96 w-96 rounded-full bg-medical-blue/5 blur-[100px]" />
      </div>

      <div className="relative z-10 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 items-center gap-16 lg:grid-cols-2">
          <div>
            <div className="mb-8 inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-slate-950 px-4 py-1.5 text-sm font-bold text-health-green">
              <Info className="h-4 w-4" />
              <span>{isAr ? 'عن Active Rehab' : 'About Active Rehab'}</span>
            </div>

            <h2 className="mb-8 text-4xl font-bold leading-tight tracking-tight text-slate-900 md:text-5xl">
              {isAr ? 'ربط العلاج الطبيعي' : 'Bridging'} <br />
              <span className="brand-metal-text mt-2 inline-block">
                {isAr ? 'بالتغذية العلاجية' : 'Physical Therapy and Clinical Nutrition'}
              </span>
            </h2>

            <div className="space-y-6 text-lg leading-relaxed text-slate-600">
              <p>
                {isAr
                  ? 'Active Rehab مبني ليخدم المصابين والتعافي والـ rehab بدل أن يكون موقع تغذية عام. الهدف هو تحويل الحسابات الأساسية إلى قرارات أوضح وأكثر فائدة داخل رحلة المستخدم.'
                  : 'Active Rehab is being shaped for injury recovery, rehab, and physio-related nutrition rather than generic wellness. The goal is to turn core calculations into clearer, more useful decisions for real users.'}
              </p>
              <p>
                {isAr
                  ? 'تم تطويره من منظور علاج طبيعي، مع الاعتماد على معادلات معروفة ومراجع طبية موثوقة، وصياغة النتائج بشكل تحفظي يدعم التوعية ولا يدّعي التشخيص.'
                  : 'It is being developed from a physical therapy perspective, using established formulas, trusted medical references, and conservative educational framing rather than direct diagnosis.'}
              </p>
            </div>

            <div className="mt-12 grid grid-cols-1 gap-6 sm:grid-cols-2">
              <div className="flex items-center gap-4 rounded-[2rem] border border-health-green/12 bg-white/80 p-6 transition-[box-shadow,border-color] hover:bg-white hover:shadow-md">
                <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-950">
                  <Calculator className="h-7 w-7 text-health-green" />
                </div>
                <div>
                  <div className="text-2xl font-bold text-slate-900">10+</div>
                  <div className="text-sm font-medium text-slate-500">
                    {isAr ? 'أدوات سريرية' : 'Clinical tools'}
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-4 rounded-[2rem] border border-health-green/12 bg-white/80 p-6 transition-[box-shadow,border-color] hover:bg-white hover:shadow-md">
                <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#f6edda]">
                  <BadgeCheck className="h-7 w-7 text-medical-blue" />
                </div>
                <div>
                  <div className="text-2xl font-bold text-slate-900">
                    {isAr ? 'أكثر أمانًا' : 'Safer'}
                  </div>
                  <div className="text-sm font-medium text-slate-500">
                    {isAr ? 'نتائج تحفظية' : 'Conservative outputs'}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="relative">
            <div className="relative z-10 flex aspect-square items-center justify-center overflow-hidden rounded-[4rem] border border-health-green/12 bg-gradient-to-br from-[#f7efdf] via-white to-[#efe4cc] p-16 shadow-2xl">
              <div className="absolute inset-0 opacity-10">
                <div
                  className="absolute left-0 top-0 h-full w-full"
                  style={{
                    backgroundImage: 'radial-gradient(#000 1px, transparent 1px)',
                    backgroundSize: '20px 20px',
                  }}
                />
              </div>
              <div className="relative flex h-full w-full items-center justify-center rounded-[3rem] bg-[radial-gradient(circle_at_top,#1b1712,#0f0d0a)] shadow-2xl">
                <HeartPulse className="absolute h-48 w-48 text-health-green opacity-10" />
                <Stethoscope className="relative z-10 h-32 w-32 text-white" />
              </div>
            </div>

            <div className="absolute -bottom-10 -right-10 z-20 max-w-[320px] rounded-[2.5rem] border border-health-green/12 bg-white p-8 shadow-2xl md:right-0">
              <div className="mb-4 flex items-center gap-4">
                <div className="rounded-2xl bg-health-green/10 p-3">
                  <Sparkles className="h-6 w-6 text-health-green" />
                </div>
                <div className="text-sm font-bold leading-tight text-slate-900">
                  {isAr ? 'منهج واضح وشفاف' : 'Transparent approach'}
                </div>
              </div>
              <p className="mb-4 text-xs leading-relaxed text-slate-500">
                {isAr
                  ? 'نوضح أن الأدوات تعليمية، ونربط الثقة بالمصادر والتحفظ في التوصيات بدل الوعود المبالغ فيها.'
                  : 'We aim to build trust through source visibility, conservative recommendations, and clear safety framing instead of overstated medical claims.'}
              </p>
              <div className="flex items-center gap-3 text-xs text-slate-600">
                <div className="flex h-8 w-8 items-center justify-center rounded-xl bg-soft-blue text-health-green">
                  <Brain className="h-4 w-4" />
                </div>
                <span>{isAr ? 'مبني للتعافي وإعادة التأهيل' : 'Built for rehab and recovery'}</span>
              </div>
            </div>

            <div className="absolute -left-10 -top-10 h-32 w-32 rounded-full bg-amber-500/10 blur-2xl" />
            <div className="absolute -right-20 top-1/2 h-48 w-48 rounded-full bg-health-green/10 blur-3xl" />
          </div>
        </div>
      </div>
    </section>
  );
});

AboutSection.displayName = 'AboutSection';

export default AboutSection;
