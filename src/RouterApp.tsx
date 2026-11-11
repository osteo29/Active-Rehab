import {Suspense} from 'react';
import {useLocation} from 'react-router-dom';
import {useStoredTheme} from './hooks/useStoredTheme';
import AppRoutes from './router/AppRoutes';
import ErrorBoundary from './components/common/ErrorBoundary';
import {extractLangFromPath, navigationPaths} from './utils/langUrlHelper';

function RouteFallback({isAr}: {isAr: boolean}) {
  return (
    <div className="flex min-h-[40vh] items-center justify-center bg-slate-50 px-4">
      <div className="rounded-2xl border border-slate-200 bg-white px-5 py-4 text-sm font-semibold text-slate-600 shadow-sm">
        {isAr ? 'جارٍ التحميل...' : 'Loading...'}
      </div>
    </div>
  );
}

export default function RouterApp() {
  const {theme, toggleTheme} = useStoredTheme();
  const {pathname} = useLocation();
  const lang = extractLangFromPath(pathname) || 'en';
  const isAr = lang === 'ar';

  return (
    <ErrorBoundary isAr={isAr} homeHref={navigationPaths.home(lang)}>
      <Suspense fallback={<RouteFallback isAr={isAr} />}>
        <AppRoutes theme={theme} onToggleTheme={toggleTheme} />
      </Suspense>
    </ErrorBoundary>
  );
}
