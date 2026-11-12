import {type ReactNode, memo, useEffect, useState} from 'react';
import {
  Activity,
  ArrowRight,
  BarChart3,
  BookOpen,
  Brain,
  ChevronDown,
  ChevronRight,
  ClipboardList,
  Compass,
  Dumbbell,
  Layers,
  LogOut,
  Menu,
  Moon,
  Pill,
  Search,
  Sparkles,
  Stethoscope,
  Sun,
  UserRound,
  Utensils,
  X,
} from 'lucide-react';
import {Link, useLocation, useNavigate} from 'react-router-dom';
import {
  getCurrentUser,
  isSupabaseConfigured,
  onSupabaseAuthChange,
  signOutCurrentUser,
  type User,
} from '../../lib/supabase';
import type {Language} from '../../services/translations';
import {navigationPaths, removeLangPrefix} from '../../utils/langUrlHelper';
import BrandLogo from '../common/BrandLogo';

type CalculatorNavItem = {
  id: string;
  title: string;
  icon: ReactNode;
};

function scrollToId(id: string) {
  if (typeof document !== 'undefined') {
    document.getElementById(id)?.scrollIntoView({behavior: 'smooth'});
  }
}

const Navigation = memo(
  ({
    t,
    lang,
    setLang,
    calculators,
    theme,
    onToggleTheme,
    setActiveCalculator,
    isSidebarOpen,
    setIsSidebarOpen,
  }: {
    t: any;
    lang: Language;
    setLang: (lang: Language) => void;
    calculators: CalculatorNavItem[];
    theme: 'light' | 'dark';
    onToggleTheme: () => void;
    setActiveCalculator: (id: string) => void;
    isSidebarOpen: boolean;
    setIsSidebarOpen: (open: boolean) => void;
  }) => {
    const isAr = lang === 'ar';
    const location = useLocation();
    const navigate = useNavigate();
    const [user, setUser] = useState<User | null>(null);
    const [openGroup, setOpenGroup] = useState<'recovery' | 'library' | 'tools' | 'calculators' | null>('recovery');

    const isActivePath = (path: string) => {
      const cleanLocation = location.pathname.replace(/\/$/, '');
      const cleanPath = path.replace(/\/$/, '');
      return cleanLocation === cleanPath || cleanLocation.startsWith(`${cleanPath}/`);
    };

    const homePath = navigationPaths.home(lang);
    const homeSectionHref = (id: string) =>
      location.pathname === homePath || location.pathname === `/${lang}` || location.pathname === '/'
        ? `#${id}`
        : `${homePath}#${id}`;

    const generateLanguageSwitchUrl = (targetLang: Language): string => {
      const cleanPath = removeLangPrefix(location.pathname);
      const nextPath = cleanPath === '/' ? navigationPaths.home(targetLang) : `/${targetLang}${cleanPath}`;
      return `${nextPath}${location.search}${location.hash}`;
    };

    const handleLanguageSwitch = (targetLang: Language) => {
      if (targetLang === lang) return;
      setLang(targetLang);
      setIsSidebarOpen(false);
      navigate(generateLanguageSwitchUrl(targetLang));
    };

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
      if (!isSidebarOpen) return;

      const previousOverflow = document.body.style.overflow;
      const closeOnEscape = (event: KeyboardEvent) => {
        if (event.key === 'Escape') setIsSidebarOpen(false);
      };

      document.body.style.overflow = 'hidden';
      window.addEventListener('keydown', closeOnEscape);

      return () => {
        document.body.style.overflow = previousOverflow;
        window.removeEventListener('keydown', closeOnEscape);
      };
    }, [isSidebarOpen, setIsSidebarOpen]);

    const handleLogout = async () => {
      try {
        await signOutCurrentUser();
      } catch {
        // ignore
      } finally {
        setIsSidebarOpen(false);
      }
    };

    const authLabel = user?.email?.split('@')[0] || (isAr ? 'الحساب' : 'Account');

    const handleBrandClick = () => {
      setIsSidebarOpen(false);
      if (location.pathname === navigationPaths.home(lang)) {
        window.scrollTo({top: 0, behavior: 'smooth'});
      }
    };

    const brand = (
      <Link
        to={navigationPaths.home(lang)}
        onClick={handleBrandClick}
        className="group flex items-center gap-2.5"
      >
        <BrandLogo
          imageClassName="transition-transform duration-300 group-hover:scale-105"
          subtitle="MOVE BETTER • FEEL BETTER"
        />
      </Link>
    );

    return (
      <>
        {/* Modern Drawer Backdrop */}
        {isSidebarOpen ? (
          <>
            <div
              onClick={() => setIsSidebarOpen(false)}
              className="fixed inset-0 z-[60] bg-slate-950/60 backdrop-blur-sm transition-opacity"
            />
            <aside
              id="main-navigation-drawer"
              role="dialog"
              aria-modal="true"
              aria-label={isAr ? 'القائمة الرئيسية' : 'Main menu'}
              className={`fixed top-0 z-[70] flex h-full w-[88vw] max-w-md flex-col bg-white shadow-2xl transition-transform duration-300 dark:bg-slate-900 ${
                isAr ? 'right-0' : 'left-0'
              }`}
            >
              {/* Drawer Header */}
              <div className="flex items-center justify-between border-b border-slate-100 p-4 sm:p-5 dark:border-slate-800">
                {brand}
                <button
                  onClick={() => setIsSidebarOpen(false)}
                  className="rounded-xl p-2 text-slate-500 transition-colors hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
                  aria-label={isAr ? 'إغلاق القائمة' : 'Close menu'}
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              {/* Drawer Body - Organized Groupings */}
              <div className="flex-1 space-y-4 overflow-y-auto p-4 sm:p-5">
                {/* 1. Quick Profile / Journey Highlight */}
                <div className="rounded-2xl border border-amber-200/50 bg-gradient-to-br from-amber-50/70 via-white to-amber-50/30 p-4 shadow-sm dark:border-amber-900/30 dark:from-slate-900 dark:via-slate-900 dark:to-slate-950">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold uppercase tracking-wider text-health-green">
                      {isAr ? 'رحلة التعافي ولوحة المتابعة' : 'Recovery & Dashboard'}
                    </span>
                    <Sparkles className="h-4 w-4 text-health-green" />
                  </div>
                  <div className="mt-2 text-sm font-bold text-slate-900 dark:text-white">
                    {user ? authLabel : isAr ? 'ابدأ متابعة تقدمك الصحي' : 'Track Your Recovery Progress'}
                  </div>
                  <div className="mt-3 grid grid-cols-2 gap-2">
                    <Link
                      to={navigationPaths.dashboard(lang)}
                      onClick={() => setIsSidebarOpen(false)}
                      className="flex items-center justify-center gap-1.5 rounded-xl bg-health-green px-3 py-2.5 text-xs font-bold text-slate-950 shadow-sm transition hover:bg-[#d3aa54]"
                    >
                      <BarChart3 className="h-4 w-4" />
                      <span>{isAr ? 'لوحة المتابعة' : 'My Dashboard'}</span>
                    </Link>
                    <Link
                      to={navigationPaths.injuries(lang)}
                      onClick={() => setIsSidebarOpen(false)}
                      className="flex items-center justify-center gap-1.5 rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-xs font-bold text-slate-700 shadow-sm transition hover:border-health-green/40 dark:border-slate-800 dark:bg-slate-800 dark:text-slate-200"
                    >
                      <ClipboardList className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'اختر إصابتك' : 'Choose Injury'}</span>
                    </Link>
                  </div>
                </div>

                {/* 2. Primary Sections */}
                <div className="space-y-1">
                  <div className="px-2 text-[11px] font-bold uppercase tracking-wider text-slate-400">
                    {isAr ? 'الأقسام الرئيسية' : 'Clinical Sections'}
                  </div>

                  <Link
                    to={navigationPaths.injuries(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className={`flex items-center justify-between rounded-xl px-3.5 py-2.5 text-sm font-semibold transition ${
                      isActivePath(navigationPaths.injuries(lang))
                        ? 'bg-health-green/15 text-health-green dark:bg-health-green/20'
                        : 'text-slate-700 hover:bg-slate-50 dark:text-slate-200 dark:hover:bg-slate-800'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <ClipboardList className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'بروتوكولات الإصابات والتأهيل' : 'Injury Protocols'}</span>
                    </div>
                    <ChevronRight className={`h-4 w-4 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>

                  <Link
                    to={navigationPaths.exercises(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className={`flex items-center justify-between rounded-xl px-3.5 py-2.5 text-sm font-semibold transition ${
                      isActivePath(navigationPaths.exercises(lang))
                        ? 'bg-health-green/15 text-health-green dark:bg-health-green/20'
                        : 'text-slate-700 hover:bg-slate-50 dark:text-slate-200 dark:hover:bg-slate-800'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <Dumbbell className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'دليل التمارين حسب العضلة' : 'Exercise Finder'}</span>
                    </div>
                    <ChevronRight className={`h-4 w-4 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>

                  <Link
                    to={navigationPaths.diets(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className={`flex items-center justify-between rounded-xl px-3.5 py-2.5 text-sm font-semibold transition ${
                      isActivePath(navigationPaths.diets(lang))
                        ? 'bg-health-green/15 text-health-green dark:bg-health-green/20'
                        : 'text-slate-700 hover:bg-slate-50 dark:text-slate-200 dark:hover:bg-slate-800'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <Utensils className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'الأنظمة الغذائية والريجيم' : 'Diets & Regimens'}</span>
                    </div>
                    <ChevronRight className={`h-4 w-4 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>

                  <Link
                    to={navigationPaths.assistant(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className="flex items-center justify-between rounded-xl px-3.5 py-2.5 text-sm font-semibold text-slate-700 transition hover:bg-slate-50 dark:text-slate-200 dark:hover:bg-slate-800"
                  >
                    <div className="flex items-center gap-3">
                      <Stethoscope className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'المساعد السريري الذكي' : 'Clinical AI Assistant'}</span>
                    </div>
                    <span className="rounded-full bg-health-green/15 px-2 py-0.5 text-[10px] font-bold text-health-green">
                      {isAr ? 'ذكي' : 'AI'}
                    </span>
                  </Link>
                </div>

                {/* 3. Interactive Tools & Calculators Accordion */}
                <div className="rounded-2xl border border-slate-100 bg-slate-50/60 p-3 dark:border-slate-800 dark:bg-slate-950/60">
                  <button
                    type="button"
                    onClick={() => setOpenGroup(openGroup === 'tools' ? null : 'tools')}
                    className="flex w-full items-center justify-between text-start text-xs font-bold uppercase tracking-wider text-slate-500"
                  >
                    <div className="flex items-center gap-2">
                      <Compass className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'الأدوات والحاسبات الصحية' : 'Health Tools & Calculators'}</span>
                    </div>
                    <ChevronDown
                      className={`h-4 w-4 transition-transform ${openGroup === 'tools' ? 'rotate-180' : ''}`}
                    />
                  </button>

                  {openGroup === 'tools' && (
                    <div className="mt-3 space-y-1.5 border-t border-slate-200/60 pt-2.5 dark:border-slate-800">
                      <a
                        href={homeSectionHref('architect')}
                        onClick={() => setIsSidebarOpen(false)}
                        className="flex items-center gap-2.5 rounded-xl px-3 py-2 text-xs font-semibold text-slate-700 hover:bg-white hover:text-health-green dark:text-slate-300 dark:hover:bg-slate-900"
                      >
                        <Brain className="h-3.5 w-3.5 text-health-green" />
                        <span>{t.architect.title}</span>
                      </a>
                      <a
                        href={homeSectionHref('drug-nutrient-checker')}
                        onClick={() => setIsSidebarOpen(false)}
                        className="flex items-center gap-2.5 rounded-xl px-3 py-2 text-xs font-semibold text-slate-700 hover:bg-white hover:text-health-green dark:text-slate-300 dark:hover:bg-slate-900"
                      >
                        <Pill className="h-3.5 w-3.5 text-health-green" />
                        <span>{isAr ? 'فحص أمان الدواء والغذاء' : 'Drug-Nutrient Checker'}</span>
                      </a>
                      <a
                        href={homeSectionHref('food-db')}
                        onClick={() => setIsSidebarOpen(false)}
                        className="flex items-center gap-2.5 rounded-xl px-3 py-2 text-xs font-semibold text-slate-700 hover:bg-white hover:text-health-green dark:text-slate-300 dark:hover:bg-slate-900"
                      >
                        <Search className="h-3.5 w-3.5 text-health-green" />
                        <span>{isAr ? 'قاعدة بيانات الأغذية والماكروز' : 'Food & Macro Database'}</span>
                      </a>

                      <div className="pt-2 text-[10px] font-bold uppercase text-slate-400">
                        {isAr ? 'الحاسبات السريرية الفردية:' : 'Quick Calculators:'}
                      </div>
                      <div className="grid grid-cols-2 gap-1.5 pt-1">
                        {calculators.map((calc) => (
                          <button
                            key={calc.id}
                            type="button"
                            onClick={() => {
                              setActiveCalculator(calc.id);
                              setIsSidebarOpen(false);
                              scrollToId('calculators');
                            }}
                            className="flex items-center gap-2 rounded-lg border border-slate-200/60 bg-white p-2 text-start text-xs font-medium text-slate-700 transition hover:border-health-green/40 hover:text-health-green dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300"
                          >
                            <span className="shrink-0 text-health-green">{calc.icon}</span>
                            <span className="truncate">{calc.title}</span>
                          </button>
                        ))}
                      </div>
                    </div>
                  )}
                </div>

                {/* 4. Company & Support Links */}
                <div className="space-y-1">
                  <div className="px-2 text-[11px] font-bold uppercase tracking-wider text-slate-400">
                    {isAr ? 'المعرفة والدعم' : 'Knowledge & Support'}
                  </div>
                  <Link
                    to={navigationPaths.insights(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className="flex items-center justify-between rounded-xl px-3.5 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800"
                  >
                    <div className="flex items-center gap-2.5">
                      <BookOpen className="h-3.5 w-3.5 text-health-green" />
                      <span>{t.nav.insights}</span>
                    </div>
                    <ChevronRight className={`h-3 w-3 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>

                  <Link
                    to={navigationPaths.about(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className="flex items-center justify-between rounded-xl px-3.5 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800"
                  >
                    <span>{isAr ? 'من نحن ورؤيتنا السريرية' : 'About & Clinical Vision'}</span>
                    <ChevronRight className={`h-3 w-3 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>

                  <Link
                    to={navigationPaths.contact(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className="flex items-center justify-between rounded-xl px-3.5 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800"
                  >
                    <span>{isAr ? 'تواصل معنا' : 'Contact Us'}</span>
                    <ChevronRight className={`h-3 w-3 opacity-40 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>
                </div>
              </div>

              {/* Drawer Footer with Account + Lang + Theme */}
              <div className="border-t border-slate-100 bg-slate-50/70 p-4 dark:border-slate-800 dark:bg-slate-950/80">
                {user ? (
                  <div className="mb-3 flex items-center justify-between rounded-xl bg-white p-3 shadow-sm dark:bg-slate-900">
                    <div className="flex items-center gap-2.5">
                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-health-green/15 text-health-green font-bold text-xs">
                        {authLabel.charAt(0).toUpperCase()}
                      </div>
                      <div className="text-xs">
                        <div className="font-bold text-slate-900 dark:text-white">{authLabel}</div>
                        <div className="text-[10px] text-slate-400 truncate max-w-[140px]">{user.email}</div>
                      </div>
                    </div>
                    <button
                      onClick={handleLogout}
                      className="rounded-lg p-1.5 text-rose-500 hover:bg-rose-50 dark:hover:bg-rose-950/40"
                      title={isAr ? 'تسجيل الخروج' : 'Log out'}
                    >
                      <LogOut className="h-4 w-4" />
                    </button>
                  </div>
                ) : (
                  <Link
                    to={navigationPaths.auth(lang)}
                    onClick={() => setIsSidebarOpen(false)}
                    className="mb-3 flex w-full items-center justify-center gap-2 rounded-xl bg-slate-900 py-2.5 text-xs font-bold text-white shadow-sm transition hover:bg-slate-800 dark:bg-health-green dark:text-slate-950"
                  >
                    <UserRound className="h-4 w-4" />
                    <span>{isAr ? 'تسجيل الدخول / إنشاء حساب' : 'Sign in / Register'}</span>
                  </Link>
                )}

                <div className="flex items-center justify-between gap-2">
                  <div className="flex items-center gap-1 rounded-xl border border-slate-200 bg-white p-1 dark:border-slate-800 dark:bg-slate-900">
                    <button
                      onClick={() => handleLanguageSwitch('en')}
                      className={`rounded-lg px-2.5 py-1 text-[11px] font-black transition ${
                        lang === 'en'
                          ? 'bg-health-green text-slate-950 shadow-sm'
                          : 'text-slate-600 dark:text-slate-300'
                      }`}
                    >
                      EN
                    </button>
                    <button
                      onClick={() => handleLanguageSwitch('ar')}
                      className={`rounded-lg px-2.5 py-1 text-[11px] font-black transition ${
                        lang === 'ar'
                          ? 'bg-health-green text-slate-950 shadow-sm'
                          : 'text-slate-600 dark:text-slate-300'
                      }`}
                    >
                      عربي
                    </button>
                  </div>

                  <button
                    onClick={onToggleTheme}
                    className="flex flex-1 items-center justify-center gap-1.5 rounded-xl border border-slate-200 bg-white py-1.5 text-xs font-bold text-slate-700 transition hover:border-health-green/40 dark:border-slate-800 dark:bg-slate-900 dark:text-slate-200"
                  >
                    {theme === 'dark' ? <Sun className="h-3.5 w-3.5" /> : <Moon className="h-3.5 w-3.5" />}
                    <span>{theme === 'dark' ? (isAr ? 'فاتح' : 'Light') : isAr ? 'داكن' : 'Dark'}</span>
                  </button>
                </div>
              </div>
            </aside>
          </>
        ) : null}

        {/* Top Header Bar */}
        <header className="sticky top-0 z-50 border-b border-amber-200/15 bg-[rgba(15,13,10,0.88)] backdrop-blur-xl">
          <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-3 sm:px-6 lg:px-8">
            {/* Left: Hamburger + Logo */}
            <div className="flex items-center gap-3">
              <button
                onClick={() => setIsSidebarOpen(true)}
                className="rounded-xl border border-white/10 bg-white/5 p-2 text-slate-200 transition hover:border-health-green/40 hover:bg-white/10"
                aria-label={isAr ? 'فتح القائمة الرئيسية' : 'Open main menu'}
              >
                <Menu className="h-5 w-5" />
              </button>
              {brand}
            </div>

            {/* Center Desktop Navigation Links */}
            <nav className="hidden items-center gap-1 xl:flex" aria-label="Desktop Nav">
              <Link
                to={navigationPaths.home(lang)}
                className={`rounded-xl px-3 py-1.5 text-xs font-bold transition ${
                  location.pathname === navigationPaths.home(lang)
                    ? 'text-health-green'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                {isAr ? 'الرئيسية' : 'Home'}
              </Link>
              <Link
                to={navigationPaths.injuries(lang)}
                className={`rounded-xl px-3 py-1.5 text-xs font-bold transition ${
                  isActivePath(navigationPaths.injuries(lang))
                    ? 'text-health-green'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                {isAr ? 'بروتوكولات الإصابات' : 'Injuries'}
              </Link>
              <Link
                to={navigationPaths.exercises(lang)}
                className={`rounded-xl px-3 py-1.5 text-xs font-bold transition ${
                  isActivePath(navigationPaths.exercises(lang))
                    ? 'text-health-green'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                {isAr ? 'دليل التمارين' : 'Exercises'}
              </Link>
              <Link
                to={navigationPaths.dashboard(lang)}
                className={`rounded-xl px-3 py-1.5 text-xs font-bold transition ${
                  isActivePath(navigationPaths.dashboard(lang))
                    ? 'text-health-green'
                    : 'text-slate-300 hover:text-white'
                }`}
              >
                {isAr ? 'لوحة المتابعة' : 'Recovery Tracking'}
              </Link>
              <a
                href={homeSectionHref('calculators')}
                className="rounded-xl px-3 py-1.5 text-xs font-bold text-slate-300 transition hover:text-white"
              >
                {isAr ? 'الحاسبات والأدوات' : 'Calculators'}
              </a>
            </nav>

            {/* Right: Quick Assistant, Auth, Language, Theme */}
            <div className="flex items-center gap-2">
              <Link
                to={navigationPaths.assistant(lang)}
                className="hidden items-center gap-1.5 rounded-full border border-white/10 bg-white/5 px-3 py-1.5 text-xs font-bold text-amber-100 transition hover:border-health-green/40 hover:bg-white/10 sm:inline-flex"
              >
                <Stethoscope className="h-3.5 w-3.5 text-health-green" />
                <span>{isAr ? 'المساعد الطبي' : 'AI Assistant'}</span>
              </Link>

              {user ? (
                <Link
                  to={navigationPaths.dashboard(lang)}
                  className="inline-flex items-center gap-1.5 rounded-full border border-white/10 bg-white/5 px-3 py-1.5 text-xs font-bold text-white transition hover:border-health-green/40 hover:bg-white/10"
                >
                  <UserRound className="h-3.5 w-3.5 text-health-green" />
                  <span className="hidden max-w-[100px] truncate md:inline">{authLabel}</span>
                </Link>
              ) : (
                <Link
                  to={navigationPaths.auth(lang)}
                  className="inline-flex items-center gap-1.5 rounded-full bg-health-green px-3.5 py-1.5 text-xs font-bold text-slate-950 shadow-sm transition hover:bg-[#d3aa54]"
                >
                  <UserRound className="h-3.5 w-3.5" />
                  <span>{isAr ? 'دخول' : 'Sign in'}</span>
                </Link>
              )}

              {/* Language toggle pill */}
              <div className="hidden items-center rounded-full border border-white/10 bg-white/5 p-0.5 md:flex">
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('en')}
                  className={`rounded-full px-2.5 py-1 text-[11px] font-black transition ${
                    lang === 'en' ? 'bg-health-green text-slate-950' : 'text-slate-300'
                  }`}
                >
                  EN
                </button>
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('ar')}
                  className={`rounded-full px-2.5 py-1 text-[11px] font-black transition ${
                    lang === 'ar' ? 'bg-health-green text-slate-950' : 'text-slate-300'
                  }`}
                >
                  AR
                </button>
              </div>

              {/* Theme toggle */}
              <button
                type="button"
                onClick={onToggleTheme}
                className="hidden rounded-full border border-white/10 bg-white/5 p-2 text-slate-200 transition hover:border-health-green/40 hover:bg-white/10 sm:inline-flex"
                aria-label={theme === 'dark' ? 'Light mode' : 'Dark mode'}
              >
                {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
              </button>
            </div>
          </div>
        </header>
      </>
    );
  },
);

Navigation.displayName = 'Navigation';

export default Navigation;
