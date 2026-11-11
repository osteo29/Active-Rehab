import {type ReactNode, memo, useEffect, useState} from 'react';
import {
  BarChart3,
  BookOpen,
  Brain,
  ClipboardList,
  Dumbbell,
  LogOut,
  Menu,
  Moon,
  Pill,
  Search,
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

    const isActivePath = (path: string) => location.pathname.startsWith(path);
    const homePath = navigationPaths.home(lang);
    const homeSectionHref = (id: string) => (location.pathname === homePath ? `#${id}` : `${homePath}#${id}`);

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
        // Detailed auth feedback lives in dedicated auth views.
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
        className="group"
      >
        <BrandLogo
          imageClassName="transition-transform duration-300 group-hover:rotate-3"
          subtitle="MOVE BETTER • FEEL BETTER"
        />
      </Link>
    );

    const sectionItems = [
      {
        href: navigationPaths.injuries(lang),
        icon: <ClipboardList className="h-5 w-5" />,
        label: isAr ? 'بروتوكولات الإصابات' : 'Injury protocols',
      },
      {
        href: navigationPaths.exercises(lang),
        icon: <Dumbbell className="h-5 w-5" />,
        label: isAr ? 'التمارين' : 'Exercises',
      },
      {
        href: navigationPaths.dashboard(lang),
        icon: <BarChart3 className="h-5 w-5" />,
        label: isAr ? 'لوحة المتابعة' : 'Tracking dashboard',
      },
      {
        href: homeSectionHref('architect'),
        icon: <Brain className="h-5 w-5" />,
        label: t.architect.title,
      },
      {
        href: homeSectionHref('food-db'),
        icon: <Search className="h-5 w-5" />,
        label: isAr ? 'قاعدة الطعام' : 'Food data',
      },
      {
        href: homeSectionHref('drug-nutrient-checker'),
        icon: <Pill className="h-5 w-5" />,
        label: isAr ? 'فحص الدواء والغذاء' : 'Drug-nutrient checker',
      },
      {
        href: navigationPaths.diets(lang),
        icon: <Utensils className="h-5 w-5" />,
        label: isAr ? 'الدايت والريجيم' : 'Diet & regimens',
      },
      {
        href: homeSectionHref('blog'),
        icon: <BookOpen className="h-5 w-5" />,
        label: t.nav.insights,
      },
    ];

    return (
      <>
        {isSidebarOpen ? (
          <>
            <div
              onClick={() => setIsSidebarOpen(false)}
              className="fixed inset-0 z-[60] bg-slate-900/60 backdrop-blur-sm"
            />
            <aside
              id="main-navigation-drawer"
              role="dialog"
              aria-modal="true"
              aria-label={isAr ? 'القائمة الرئيسية' : 'Main menu'}
              className={`fixed top-0 z-[70] flex h-full w-[88vw] max-w-sm flex-col bg-white shadow-2xl ${
                isAr ? 'right-0' : 'left-0'
              }`}
            >
              <div className="flex items-center justify-between border-b border-slate-100 p-5">
                {brand}
                <button
                  onClick={() => setIsSidebarOpen(false)}
                  className="rounded-full p-2 text-slate-500 transition-colors hover:bg-slate-100"
                  aria-label={isAr ? 'إغلاق القائمة' : 'Close menu'}
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              <div className="flex-1 space-y-7 overflow-y-auto p-5">
                <div className="rounded-[1.75rem] border border-slate-200 bg-slate-50 p-4">
                  <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.16em] text-slate-400">
                    {isAr ? 'ابدأ بسرعة' : 'Quick start'}
                  </div>
                  <div className="grid grid-cols-1 gap-2">
                    <button
                      onClick={() => {
                        setIsSidebarOpen(false);
                        scrollToId('calculators');
                      }}
                      className="rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white transition-all hover:bg-health-green-dark"
                    >
                      {isAr ? 'افتح الحاسبات' : 'Open calculators'}
                    </button>
                    <Link
                      to={navigationPaths.injuries(lang)}
                      onClick={() => setIsSidebarOpen(false)}
                      className="flex items-center justify-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-bold text-slate-700 transition-all hover:border-health-green/30"
                    >
                      <ClipboardList className="h-4 w-4 text-health-green" />
                      <span>{isAr ? 'استعرض البروتوكولات' : 'Browse protocols'}</span>
                    </Link>
                  </div>
                </div>

                <div className="rounded-[1.75rem] border border-slate-200 bg-white p-4">
                  <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.16em] text-slate-400">
                    {isAr ? 'الحساب' : 'Account'}
                  </div>
                  {user ? (
                    <div className="space-y-3">
                      <div className="rounded-2xl bg-slate-50 p-3">
                        <div className="text-sm font-bold text-slate-900">{authLabel}</div>
                        <div className="mt-1 text-xs text-slate-500">{user.email}</div>
                      </div>
                      <Link
                        to={navigationPaths.dashboard(lang)}
                        onClick={() => setIsSidebarOpen(false)}
                        className="flex items-center justify-center gap-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-bold text-slate-700 transition-all hover:bg-soft-blue"
                      >
                        <BarChart3 className="h-4 w-4 text-health-green" />
                        <span>{isAr ? 'افتح لوحة المتابعة' : 'Open dashboard'}</span>
                      </Link>
                      <button
                        onClick={handleLogout}
                        className="flex w-full items-center justify-center gap-2 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-600 transition-all hover:bg-rose-100"
                      >
                        <LogOut className="h-4 w-4" />
                        <span>{isAr ? 'تسجيل الخروج' : 'Log out'}</span>
                      </button>
                    </div>
                  ) : (
                    <div className="grid grid-cols-1 gap-2">
                      <Link
                        to={navigationPaths.auth(lang)}
                        onClick={() => setIsSidebarOpen(false)}
                        className="flex items-center justify-center gap-2 rounded-2xl bg-slate-900 px-4 py-3 text-sm font-bold text-white transition-all hover:bg-slate-800"
                      >
                        <UserRound className="h-4 w-4" />
                        <span>{isAr ? 'تسجيل الدخول' : 'Sign in'}</span>
                      </Link>
                    </div>
                  )}
                </div>

                <div>
                  <h3 className="mb-3 px-1 text-[11px] font-bold uppercase tracking-[0.16em] text-slate-400">
                    {t.nav.calculators}
                  </h3>
                  <div className="grid grid-cols-1 gap-2">
                    {calculators.map((calc) => (
                      <button
                        key={calc.id}
                        onClick={() => {
                          setActiveCalculator(calc.id);
                          setIsSidebarOpen(false);
                          scrollToId('calculators');
                        }}
                        className="flex items-center gap-3 rounded-2xl border border-transparent bg-slate-50 p-3 text-left text-slate-700 transition-all hover:border-health-green/20 hover:bg-soft-blue"
                      >
                        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-health-green shadow-sm">
                          {calc.icon}
                        </div>
                        <span className="text-sm font-semibold">{calc.title}</span>
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="mb-3 px-1 text-[11px] font-bold uppercase tracking-[0.16em] text-slate-400">
                    {isAr ? 'الأقسام الرئيسية' : 'Main sections'}
                  </h3>
                  <div className="grid grid-cols-1 gap-2">
                    {sectionItems.map((item) =>
                      item.href.startsWith('/') ? (
                        <Link
                          key={item.href}
                          to={item.href}
                          onClick={() => setIsSidebarOpen(false)}
                          className={`flex items-center gap-3 rounded-2xl p-3 transition-all ${
                            location.pathname.startsWith(item.href)
                              ? 'border border-health-green/20 bg-health-green/10 text-health-green'
                              : 'bg-slate-50 text-slate-700 hover:bg-soft-blue'
                          }`}
                          aria-current={location.pathname.startsWith(item.href) ? 'page' : undefined}
                        >
                          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-health-green shadow-sm">
                            {item.icon}
                          </div>
                          <span className="text-sm font-semibold">{item.label}</span>
                        </Link>
                      ) : (
                        <a
                          key={item.href}
                          href={item.href}
                          onClick={() => setIsSidebarOpen(false)}
                          className="flex items-center gap-3 rounded-2xl bg-slate-50 p-3 text-slate-700 transition-all hover:bg-soft-blue"
                        >
                          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-health-green shadow-sm">
                            {item.icon}
                          </div>
                          <span className="text-sm font-semibold">{item.label}</span>
                        </a>
                      ),
                    )}
                  </div>
                </div>
              </div>

              <div className="border-t border-slate-100 bg-slate-50/60 p-5">
                <div className="mb-3 flex items-center justify-between">
                  <span className="text-sm font-bold text-slate-500">
                    {isAr ? 'اللغة' : 'Language'}
                  </span>
                  <div className="flex items-center gap-1 rounded-full border border-slate-200 bg-white p-1">
                    <button
                      onClick={() => handleLanguageSwitch('en')}
                      className={`rounded-full px-3 py-1 text-[10px] font-black ${
                        lang === 'en' ? 'bg-health-green text-white' : 'text-slate-700'
                      }`}
                    >
                      EN
                    </button>
                    <button
                      onClick={() => handleLanguageSwitch('ar')}
                      className={`rounded-full px-3 py-1 text-[10px] font-black ${
                        lang === 'ar' ? 'bg-health-green text-white' : 'text-slate-700'
                      }`}
                    >
                      AR
                    </button>
                  </div>
                </div>

                <button
                  onClick={onToggleTheme}
                  className="flex w-full items-center justify-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-bold text-slate-700 transition-all hover:border-health-green/30"
                >
                  {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
                  <span>
                    {theme === 'dark'
                      ? isAr
                        ? 'الوضع الفاتح'
                        : 'Switch to light mode'
                      : isAr
                        ? 'الوضع الداكن'
                        : 'Switch to dark mode'}
                  </span>
                </button>
              </div>
            </aside>
          </>
        ) : null}

        <nav className="sticky top-0 z-50 border-b border-amber-200/15 bg-[rgba(15,13,10,0.82)] px-3 backdrop-blur-xl sm:px-5 lg:px-8">
          <div className="mx-auto flex min-h-[4.25rem] max-w-7xl items-center justify-between gap-3 py-2">
            <div className="flex items-center gap-2 sm:gap-2.5">
              <button
                onClick={() => setIsSidebarOpen(true)}
                className="rounded-xl border border-transparent p-2 text-slate-200 transition-colors hover:border-white/10 hover:bg-white/6"
                aria-label={isAr ? 'فتح القائمة الرئيسية' : 'Open main menu'}
                aria-expanded={isSidebarOpen}
                aria-controls="main-navigation-drawer"
              >
                <Menu className="h-5 w-5" />
              </button>
              {brand}
            </div>

            <div className="hidden items-center gap-4 xl:flex">
              <a href={homeSectionHref('calculators')} className="nav-link">
                {t.nav.calculators}
              </a>
              <Link
                to={navigationPaths.injuries(lang)}
                className={`nav-link ${isActivePath(navigationPaths.injuries(lang)) ? 'border-b-2 border-health-green pb-1 text-health-green' : ''}`}
                aria-current={isActivePath(navigationPaths.injuries(lang)) ? 'page' : undefined}
              >
                {isAr ? 'الإصابات' : 'Injuries'}
              </Link>
              <Link
                to={navigationPaths.exercises(lang)}
                className={`nav-link ${isActivePath(navigationPaths.exercises(lang)) ? 'border-b-2 border-health-green pb-1 text-health-green' : ''}`}
                aria-current={isActivePath(navigationPaths.exercises(lang)) ? 'page' : undefined}
              >
                {isAr ? 'التمارين' : 'Exercises'}
              </Link>
              <Link
                to={navigationPaths.dashboard(lang)}
                className={`nav-link ${isActivePath(navigationPaths.dashboard(lang)) ? 'border-b-2 border-health-green pb-1 text-health-green' : ''}`}
                aria-current={isActivePath(navigationPaths.dashboard(lang)) ? 'page' : undefined}
              >
                {isAr ? 'المتابعة' : 'Tracking'}
              </Link>
            </div>

            <div className="flex items-center gap-1.5 sm:gap-2">
              <Link
                to={navigationPaths.assistant(lang)}
                className="hidden items-center gap-2 rounded-full border border-white/10 bg-white/6 px-3 py-2 text-slate-100 transition-all hover:border-health-green/30 hover:bg-white/10 md:flex"
              >
                <Stethoscope className="h-4 w-4 text-health-green" />
                <span className="hidden text-xs font-bold xl:inline">
                  {isAr ? 'المساعد' : 'Assistant'}
                </span>
              </Link>

              {user ? (
                <Link
                  to={navigationPaths.dashboard(lang)}
                  className="hidden items-center gap-2 rounded-full border border-white/10 bg-white/6 px-3 py-2 text-slate-100 transition-all hover:border-health-green/30 hover:bg-white/10 md:flex"
                >
                  <UserRound className="h-4 w-4 text-health-green" />
                  <span className="hidden text-xs font-bold xl:inline">{authLabel}</span>
                </Link>
              ) : (
                <Link
                  to={navigationPaths.auth(lang)}
                  className="hidden items-center gap-2 rounded-full bg-health-green px-3.5 py-2 text-slate-950 shadow-[0_12px_28px_rgba(196,154,66,0.2)] transition-all hover:bg-[#d3aa54] md:inline-flex"
                >
                  <UserRound className="h-4 w-4" />
                  <span className="text-xs font-bold">{isAr ? 'تسجيل الدخول' : 'Sign in'}</span>
                </Link>
              )}

              <div className="hidden items-center gap-1 rounded-full border border-white/10 bg-white/6 p-1 sm:flex">
                <button
                  onClick={() => handleLanguageSwitch('en')}
                  className={`rounded-full px-3 py-1 text-xs font-bold ${
                    lang === 'en' ? 'bg-white text-health-green shadow-sm' : 'text-slate-200'
                  }`}
                  aria-pressed={lang === 'en'}
                >
                  EN
                </button>
                <button
                  onClick={() => handleLanguageSwitch('ar')}
                  className={`rounded-full px-3 py-1 text-xs font-bold ${
                    lang === 'ar' ? 'bg-white text-health-green shadow-sm' : 'text-slate-200'
                  }`}
                  aria-pressed={lang === 'ar'}
                >
                  AR
                </button>
              </div>

              <button
                onClick={onToggleTheme}
                className="hidden rounded-xl border border-white/10 bg-white/6 px-3 py-2 text-slate-100 transition-all hover:border-health-green/30 hover:bg-white/10 sm:flex"
                aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
                aria-pressed={theme === 'dark'}
              >
                {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
              </button>
            </div>
          </div>
        </nav>
      </>
    );
  },
);

Navigation.displayName = 'Navigation';

export default Navigation;
