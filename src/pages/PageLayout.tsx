import {type ReactNode, useState} from 'react';
import {Menu, Moon, Sun, X} from 'lucide-react';
import {Link, useLocation, useNavigate} from 'react-router-dom';
import BrandLogo from '../components/common/BrandLogo';
import {useStoredTheme} from '../hooks/useStoredTheme';
import {setPreferredLanguage} from '../services/languagePreference';
import {injuryUiStrings} from '../services/injuryI18n/uiStrings';
import {navigationPaths, removeLangPrefix} from '../utils/langUrlHelper';
import usePreferredLang from './usePreferredLang';

export type PageLayoutRelatedLink = {
  label: string;
  href: string;
  description?: string;
};

type NavItem = {key: string; href: string; label: string};

export default function PageLayout({
  title,
  children,
  relatedLinks = [],
  relatedTitle,
  hideTitle = false,
  wide = false,
  flat = false,
}: {
  title: string;
  children: ReactNode;
  relatedLinks?: PageLayoutRelatedLink[];
  relatedTitle?: string;
  hideTitle?: boolean;
  wide?: boolean;
  flat?: boolean;
}) {
  const lang = usePreferredLang();
  const location = useLocation();
  const navigate = useNavigate();
  const isAr = lang === 'ar';
  const {theme, toggleTheme} = useStoredTheme();
  const ui = injuryUiStrings[lang];
  const [mobileOpen, setMobileOpen] = useState(false);

  const maxWidth = wide ? 'max-w-7xl' : 'max-w-5xl';

  const navItems: NavItem[] = [
    {key: 'injuries', href: `/${lang}/injuries`, label: ui.nav.protocols},
    {key: 'exercises', href: `/${lang}/exercises`, label: ui.nav.exercises},
    {key: 'diets', href: `/${lang}/diets`, label: ui.nav.diets},
    {key: 'insights', href: `/${lang}/insights`, label: ui.nav.insights},
    {key: 'about', href: `/${lang}/about`, label: ui.nav.about},
    {key: 'contact', href: `/${lang}/contact`, label: isAr ? 'اتصل بنا' : 'Contact'},
  ];

  const isActive = (href: string) => {
    const path = location.pathname.replace(/\/$/, '');
    const target = href.replace(/\/$/, '');
    return path === target || path.startsWith(`${target}/`);
  };

  const generateLanguageSwitchUrl = (targetLang: 'en' | 'ar'): string => {
    const cleanPath = removeLangPrefix(location.pathname);
    const nextPath = cleanPath === '/' ? navigationPaths.home(targetLang) : `/${targetLang}${cleanPath}`;
    return `${nextPath}${location.search}${location.hash}`;
  };

  const handleLanguageSwitch = (targetLang: 'en' | 'ar') => {
    if (targetLang === lang) return;
    setPreferredLanguage(targetLang);
    navigate(generateLanguageSwitchUrl(targetLang));
    setMobileOpen(false);
  };

  const navLinkClass = (active: boolean) =>
    `rounded-xl px-3 py-2 text-sm font-semibold transition ${
      active
        ? 'bg-health-green/15 text-health-green dark:bg-health-green/20 dark:text-emerald-300'
        : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900 dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
    }`;

  return (
    <div className="min-h-screen bg-soft-blue dark:bg-slate-950" dir={isAr ? 'rtl' : 'ltr'}>
      <header className="sticky top-0 z-50 border-b border-slate-200/80 bg-white/90 shadow-sm backdrop-blur-md dark:border-slate-800 dark:bg-slate-950/90">
        <div className={`mx-auto ${maxWidth} px-4 sm:px-6 lg:px-8`}>
          <div className="flex h-16 items-center justify-between gap-4">
            <Link to={`/${lang}/`} className="shrink-0" onClick={() => setMobileOpen(false)}>
              <BrandLogo title="Active Rehab" subtitle={isAr ? 'تعافي سريري' : 'Clinical Recovery'} />
            </Link>

            <nav className="hidden items-center gap-0.5 lg:flex" aria-label={isAr ? 'التنقل الرئيسي' : 'Main navigation'}>
              {navItems.map((item) => (
                <Link key={item.key} to={item.href} className={navLinkClass(isActive(item.href))}>
                  {item.label}
                </Link>
              ))}
            </nav>

            <div className="flex items-center gap-2">
              <div className="hidden items-center gap-1 rounded-full border border-slate-200 bg-slate-100 p-1 sm:flex dark:border-slate-700 dark:bg-slate-900">
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('en')}
                  className={`rounded-full px-2.5 py-1 text-xs font-bold transition ${
                    lang === 'en'
                      ? 'bg-white text-health-green shadow-sm dark:bg-slate-800 dark:text-emerald-300'
                      : 'text-slate-600 dark:text-slate-300'
                  }`}
                >
                  EN
                </button>
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('ar')}
                  className={`rounded-full px-2.5 py-1 text-xs font-bold transition ${
                    lang === 'ar'
                      ? 'bg-white text-health-green shadow-sm dark:bg-slate-800 dark:text-emerald-300'
                      : 'text-slate-600 dark:text-slate-300'
                  }`}
                >
                  AR
                </button>
              </div>

              <button
                type="button"
                onClick={toggleTheme}
                className="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-700 transition hover:border-health-green/30 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100"
                aria-label={theme === 'dark' ? (isAr ? 'الوضع الفاتح' : 'Light mode') : isAr ? 'الوضع الداكن' : 'Dark mode'}
              >
                {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
              </button>

              <button
                type="button"
                className="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-700 lg:hidden dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100"
                aria-label={mobileOpen ? (isAr ? 'إغلاق القائمة' : 'Close menu') : isAr ? 'فتح القائمة' : 'Open menu'}
                onClick={() => setMobileOpen((open) => !open)}
              >
                {mobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
              </button>
            </div>
          </div>

          {mobileOpen ? (
            <nav
              className="border-t border-slate-200 py-4 lg:hidden dark:border-slate-800"
              aria-label={isAr ? 'قائمة الجوال' : 'Mobile menu'}
            >
              <div className="grid gap-1">
                {navItems.map((item) => (
                  <Link
                    key={item.key}
                    to={item.href}
                    onClick={() => setMobileOpen(false)}
                    className={navLinkClass(isActive(item.href))}
                  >
                    {item.label}
                  </Link>
                ))}
              </div>
              <div className="mt-4 flex gap-2 sm:hidden">
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('en')}
                  className={`flex-1 rounded-xl py-2 text-xs font-bold ${lang === 'en' ? 'bg-health-green text-white' : 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-300'}`}
                >
                  English
                </button>
                <button
                  type="button"
                  onClick={() => handleLanguageSwitch('ar')}
                  className={`flex-1 rounded-xl py-2 text-xs font-bold ${lang === 'ar' ? 'bg-health-green text-white' : 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-300'}`}
                >
                  العربية
                </button>
              </div>
            </nav>
          ) : null}
        </div>
      </header>

      <main className={`mx-auto ${maxWidth} px-4 py-8 sm:px-6 lg:px-10`}>
        {!hideTitle ? (
          <h1 className="mb-6 text-3xl font-black tracking-tight text-slate-900 dark:text-white sm:text-4xl">{title}</h1>
        ) : null}

        <div className="space-y-6">
          {flat ? (
            children
          ) : (
            <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900 sm:p-8">
              {children}
            </div>
          )}

          {relatedLinks.length > 0 ? (
            <section className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900 sm:p-8">
              <div className="mb-4 flex items-center justify-between gap-3">
                <h2 className="text-lg font-black text-slate-900 dark:text-white">
                  {relatedTitle ?? (isAr ? 'صفحات ذات صلة' : 'Related pages')}
                </h2>
                <Link
                  to={`/${lang}/`}
                  className="text-sm font-semibold text-health-green transition hover:text-health-green-dark dark:text-emerald-400"
                >
                  {isAr ? 'الرئيسية' : 'Home'}
                </Link>
              </div>

              <div className="grid gap-3 sm:grid-cols-2">
                {relatedLinks.map((item) => (
                  <Link
                    key={`${item.href}-${item.label}`}
                    to={item.href}
                    className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-4 transition hover:border-health-green/40 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:hover:bg-health-green/10"
                  >
                    <div className="text-sm font-bold text-slate-900 dark:text-white">{item.label}</div>
                    {item.description ? (
                      <div className="mt-1 text-sm leading-6 text-slate-600 dark:text-slate-300">{item.description}</div>
                    ) : null}
                  </Link>
                ))}
              </div>
            </section>
          ) : null}
        </div>
      </main>
    </div>
  );
}
