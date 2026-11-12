import {memo} from 'react';
import {Link} from 'react-router-dom';
import {Activity, ArrowRight, BarChart3, Bot, Calculator, ClipboardList, Dumbbell, ShieldCheck, Sparkles} from 'lucide-react';
import type {Language} from '../../services/translations';
import {navigationPaths} from '../../utils/langUrlHelper';

const Hero = memo(({lang}: {lang: Language}) => {
  const isAr = lang === 'ar';

  const quickPillars = [
    {
      title: isAr ? 'بروتوكولات الإصابات' : 'Injury Protocols',
      desc: isAr ? 'دليل سريري لكل مرحلة وتأهيل متدرج' : 'Phased clinical rehabilitation pathways',
      href: navigationPaths.injuries(lang),
      icon: ClipboardList,
      badge: isAr ? 'سريري' : 'Clinical',
    },
    {
      title: isAr ? 'متابعة رحلة التعافي' : 'Recovery Journey',
      desc: isAr ? 'سجل إصابتك وتابع انتقالك من مرحلة 1 إلى 3' : 'Track your active injury and phase milestones',
      href: navigationPaths.dashboard(lang),
      icon: BarChart3,
      badge: isAr ? 'تفاعلي' : 'Interactive',
    },
    {
      title: isAr ? 'دليل التمارين التخصصي' : 'Exercise Finder',
      desc: isAr ? 'تمارين مصنفة حسب العضلة والمستوى والمعدات' : 'Filter by muscle, difficulty & equipment',
      href: navigationPaths.exercises(lang),
      icon: Dumbbell,
      badge: isAr ? 'دليل شامل' : 'Library',
    },
  ];

  return (
    <section className="relative overflow-hidden bg-gradient-to-b from-[#0f0d0a] via-[#16130f] to-[#0f0d0a] pb-12 pt-8 text-white sm:pb-16 sm:pt-12">
      {/* Subtle ambient light */}
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(196,154,66,0.18),transparent_35%),radial-gradient(circle_at_bottom_left,rgba(255,255,255,0.05),transparent_25%)]" />

      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Top Tagline */}
        <div className="mx-auto max-w-3xl text-center">
          <div className="inline-flex items-center gap-2 rounded-full border border-amber-200/20 bg-white/5 px-4 py-1.5 text-xs font-bold uppercase tracking-widest text-amber-200/90 backdrop-blur-md">
            <Sparkles className="h-3.5 w-3.5 text-health-green" />
            <span>{isAr ? 'منصة التأهيل الحركي والتغذية العلاجية' : 'Evidence-Based Rehabilitation & Nutrition'}</span>
          </div>

          <h1 className="mt-5 text-3xl font-black leading-tight tracking-tight text-white sm:text-4xl md:text-5xl lg:text-[3.25rem]">
            {isAr ? 'تعافَ بذكاء وارجع للحركة' : 'Recover Smarter & Return to Movement'}{' '}
            <span className="brand-metal-text">{isAr ? 'بخطوات سريرية واضحة' : 'With Clinical Clarity'}</span>
          </h1>

          <p className="mx-auto mt-4 max-w-2xl text-sm leading-relaxed text-slate-300 sm:text-base">
            {isAr
              ? 'اختر إصابتك، تابع تقدمك عبر مراحل التأهيل (1 إلى 2 إلى 3)، وافحص أمان أدويتك مع التغذية في منصة واحدة مبسطة وسهلة الاستخدام.'
              : 'Select your injury, track recovery through phases 1 to 3, and ensure medication-food safety in one streamlined, intuitive platform.'}
          </p>

          {/* Action CTAs */}
          <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
            <Link
              to={navigationPaths.injuries(lang)}
              className="inline-flex items-center gap-2 rounded-full bg-health-green px-6 py-3.5 text-sm font-bold text-slate-950 shadow-[0_12px_24px_rgba(196,154,66,0.25)] transition hover:bg-[#d3aa54]"
            >
              <ClipboardList className="h-4 w-4" />
              <span>{isAr ? 'استعراض بروتوكولات الإصابات' : 'Find Your Injury Protocol'}</span>
            </Link>

            <Link
              to={navigationPaths.dashboard(lang)}
              className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/8 px-6 py-3.5 text-sm font-bold text-white backdrop-blur transition hover:bg-white/15"
            >
              <Activity className="h-4 w-4 text-health-green" />
              <span>{isAr ? 'لوحة متابعة رحلتي' : 'Open My Recovery'}</span>
            </Link>

            <Link
              to={navigationPaths.assistant(lang)}
              className="inline-flex items-center gap-1.5 rounded-full border border-white/10 px-4 py-3.5 text-xs font-semibold text-amber-200/80 transition hover:bg-white/5 hover:text-white"
            >
              <Bot className="h-3.5 w-3.5 text-health-green" />
              <span>{isAr ? 'استشر المساعد الطبي' : 'Ask AI Assistant'}</span>
            </Link>
          </div>
        </div>

        {/* 3 Quick-access interactive feature cards */}
        <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {quickPillars.map((item) => (
            <Link
              key={item.title}
              to={item.href}
              className="group relative flex flex-col justify-between rounded-2xl border border-white/10 bg-white/[0.04] p-5 backdrop-blur transition hover:-translate-y-1 hover:border-health-green/40 hover:bg-white/[0.08]"
            >
              <div className="flex items-start justify-between">
                <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-white/8 text-health-green transition group-hover:scale-105">
                  <item.icon className="h-5 w-5" />
                </div>
                <span className="rounded-full bg-white/8 px-2.5 py-0.5 text-[10px] font-bold text-amber-200/80">
                  {item.badge}
                </span>
              </div>

              <div className="mt-4">
                <div className="text-base font-bold text-white group-hover:text-amber-200">
                  {item.title}
                </div>
                <p className="mt-1.5 text-xs leading-relaxed text-slate-300">
                  {item.desc}
                </p>
              </div>

              <div className="mt-4 flex items-center gap-1 text-xs font-bold text-health-green">
                <span>{isAr ? 'الدخول للقسم' : 'Explore'}</span>
                <ArrowRight className={`h-3.5 w-3.5 transition group-hover:translate-x-1 ${isAr ? 'rotate-180 group-hover:-translate-x-1' : ''}`} />
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
});

Hero.displayName = 'Hero';

export default Hero;
