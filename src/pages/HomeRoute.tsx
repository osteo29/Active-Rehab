import {useEffect} from 'react';

// Sections on the home page render lazily (DeferredHomeSection), so an anchor
// target like #food-db or #calculators may not exist yet when navigation
// happens. Poll briefly until the element mounts, then scroll to it.
function scrollToIdWhenReady(id: string, timeoutMs = 6000) {
  const startedAt = Date.now();
  const tryScroll = () => {
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({behavior: 'smooth', block: 'start'});
      return;
    }
    if (Date.now() - startedAt < timeoutMs) {
      window.setTimeout(tryScroll, 150);
    }
  };
  tryScroll();
}
import {useLocation} from 'react-router-dom';
import App from '../App';
import ManagedSeo from '../components/seo/ManagedSeo';
import {getCalculatorPageBySlug, type CalculatorPageSlug} from '../services/calculatorPages';
import {buildHreflangs} from '../utils/langUrlHelper';
import usePreferredLang from './usePreferredLang';

export default function HomeRoute({
  scrollToId,
  calculatorSlug,
  theme,
  onToggleTheme,
}: {
  scrollToId?: 'calculators' | 'blog' | 'about';
  calculatorSlug?: CalculatorPageSlug;
  theme: 'light' | 'dark';
  onToggleTheme: () => void;
}) {
  const lang = usePreferredLang();
  const location = useLocation();
  const calculatorPage = getCalculatorPageBySlug(calculatorSlug);
  const canonicalPath = calculatorPage
    ? `/calculators/${calculatorPage.slug}`
    : scrollToId
      ? `/${scrollToId === 'calculators' ? 'calculators' : scrollToId}`
      : '/';
  const pageKey = calculatorPage ? 'calculator_detail' : scrollToId === 'calculators' ? 'calculators' : 'home';

  useEffect(() => {
    if (!scrollToId) return;
    scrollToIdWhenReady(scrollToId);
  }, [scrollToId]);

  useEffect(() => {
    const id = location.hash.slice(1);
    if (!id) return;
    scrollToIdWhenReady(id);
  }, [location.hash]);

  return (
    <>
      <ManagedSeo
        pageKey={pageKey}
        lang={lang}
        canonicalPath={canonicalPath}
        hreflangs={buildHreflangs(canonicalPath)}
        templateValues={
          calculatorPage
            ? {
                calculatorTitle: lang === 'ar' ? calculatorPage.titleAr : calculatorPage.titleEn,
                calculatorDescription:
                  lang === 'ar' ? calculatorPage.descriptionAr : calculatorPage.descriptionEn,
              }
            : undefined
        }
      />
      <App
        theme={theme}
        onToggleTheme={onToggleTheme}
        initialCalculatorId={calculatorPage?.calculatorId || null}
        lang={lang}
      />
    </>
  );
}
