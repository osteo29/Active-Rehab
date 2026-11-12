import {lazy} from 'react';
import {Navigate, Route, Routes, useLocation, useParams} from 'react-router-dom';
import {getCalculatorPageBySlug, type CalculatorPageSlug} from '../services/calculatorPages';
import {getPreferredLanguage} from '../services/languagePreference';
import {normalizeExerciseUrlSlug} from '../services/seoAliases';
import HomeRoute from '../pages/HomeRoute';
import {navigationPaths} from '../utils/langUrlHelper';

const PrivacyPolicy = lazy(() => import('../pages/PrivacyPolicy'));
const TermsOfService = lazy(() => import('../pages/TermsOfService'));
const CookiePolicy = lazy(() => import('../pages/CookiePolicy'));
const MedicalDisclaimer = lazy(() => import('../pages/MedicalDisclaimer'));
const AboutPage = lazy(() => import('../pages/AboutPage'));
const ContactPage = lazy(() => import('../pages/ContactPage'));
const ArticlePage = lazy(() => import('../pages/ArticlePage'));
const InsightsPage = lazy(() => import('../pages/InsightsPage'));
const InjuryProtocolsPage = lazy(() => import('../pages/InjuryProtocolsPage'));
const InjuryDetailPage = lazy(() => import('../pages/InjuryDetailPage'));
const ArticleStudioPage = lazy(() => import('../pages/ArticleStudioPage'));
const AdminDashboardPage = lazy(() => import('../pages/AdminDashboardPage'));
const AdminContentPage = lazy(() => import('../pages/AdminContentPage'));
const AdminHomepagePage = lazy(() => import('../pages/AdminHomepagePage'));
const AdminExercisesPage = lazy(() => import('../pages/AdminExercisesPage'));
const AdminMediaPage = lazy(() => import('../pages/AdminMediaPage'));
const AdminSeoPage = lazy(() => import('../pages/AdminSeoPage'));
const AdminUsersPage = lazy(() => import('../pages/AdminUsersPage'));
const AssistantPage = lazy(() => import('../pages/AssistantPage'));
const AdminInjuryManager = lazy(() => import('../pages/AdminInjuryManager'));
const DietsRegimensPage = lazy(() => import('../pages/DietsRegimensPage'));
const DietDetailPage = lazy(() => import('../pages/DietDetailPage'));
const ExercisesPage = lazy(() => import('../pages/ExercisesPage'));
const AnatomyPage = lazy(() => import('../pages/AnatomyPage'));
const ExerciseRegionPage = lazy(() => import('../pages/ExerciseRegionPage'));
const ExerciseSystemsPage = lazy(() => import('../pages/ExerciseSystemsPage'));
const ExerciseSystemDetailPage = lazy(() => import('../pages/ExerciseSystemDetailPage'));
const TrackingDashboardPage = lazy(() => import('../pages/TrackingDashboardPage'));
const AuthPage = lazy(() => import('../pages/AuthPage'));
const AuthCallbackPage = lazy(() => import('../pages/AuthCallbackPage'));
const NotFound = lazy(() => import('../pages/NotFound'));

function RootRedirect() {
  const location = useLocation();
  return <Navigate to={`/${getPreferredLanguage()}/${location.search}${location.hash}`} replace />;
}

function LegacyRouteRedirect() {
  const location = useLocation();
  const preferredLang = getPreferredLanguage();
  return <Navigate to={`/${preferredLang}${location.pathname}${location.search}${location.hash}`} replace />;
}

function InjuryProtocolsRedirect() {
  const {lang = 'en'} = useParams<{lang: 'en' | 'ar'}>();
  return <Navigate to={navigationPaths.injuries(lang)} replace />;
}

function AdminArticlesRedirect() {
  const {lang = 'en'} = useParams<{lang: 'en' | 'ar'}>();
  return <Navigate to={navigationPaths.adminArticles(lang)} replace />;
}

function CalculatorRouteRedirect({theme, onToggleTheme}: {theme: 'light' | 'dark'; onToggleTheme: () => void}) {
  const {lang = 'en', calculator} = useParams<{lang: 'en' | 'ar'; calculator: CalculatorPageSlug}>();
  const page = getCalculatorPageBySlug(calculator);
  if (!page) {
    return <Navigate to={navigationPaths.calculators(lang)} replace />;
  }

  return <HomeRoute scrollToId="calculators" calculatorSlug={page.slug} theme={theme} onToggleTheme={onToggleTheme} />;
}

function LegacyExerciseSlugRedirect() {
  const {lang = 'en', muscle = ''} = useParams<{lang: 'en' | 'ar'; muscle: string}>();
  return <Navigate to={`/${lang}/exercises/${normalizeExerciseUrlSlug(muscle)}`} replace />;
}

export default function AppRoutes({theme, onToggleTheme}: {theme: 'light' | 'dark'; onToggleTheme: () => void}) {
  return (
    <Routes>
      <Route path="/" element={<RootRedirect />} />
      <Route path="/:lang" element={<HomeRoute theme={theme} onToggleTheme={onToggleTheme} />} />
      <Route path="/:lang/calculators" element={<HomeRoute scrollToId="calculators" theme={theme} onToggleTheme={onToggleTheme} />} />
      <Route path="/:lang/calculators/:calculator" element={<CalculatorRouteRedirect theme={theme} onToggleTheme={onToggleTheme} />} />

      <Route path="/:lang/privacy" element={<PrivacyPolicy />} />
      <Route path="/:lang/terms" element={<TermsOfService />} />
      <Route path="/:lang/cookies" element={<CookiePolicy />} />
      <Route path="/:lang/disclaimer" element={<MedicalDisclaimer />} />
      <Route path="/:lang/about" element={<AboutPage />} />
      <Route path="/:lang/contact" element={<ContactPage />} />
      <Route path="/:lang/insights" element={<InsightsPage />} />
      <Route path="/:lang/injury-protocols" element={<InjuryProtocolsRedirect />} />
      <Route path="/:lang/injuries" element={<InjuryProtocolsPage />} />
      <Route path="/:lang/injuries/:slug" element={<InjuryDetailPage />} />
      <Route path="/:lang/admin" element={<AdminDashboardPage />} />
      <Route path="/:lang/admin/content" element={<AdminContentPage />} />
      <Route path="/:lang/admin/homepage" element={<AdminHomepagePage />} />
      <Route path="/:lang/admin/injuries" element={<AdminInjuryManager />} />
      <Route path="/:lang/admin/articles" element={<ArticleStudioPage />} />
      <Route path="/:lang/admin/exercises" element={<AdminExercisesPage />} />
      <Route path="/:lang/admin/media" element={<AdminMediaPage />} />
      <Route path="/:lang/admin/seo" element={<AdminSeoPage />} />
      <Route path="/:lang/admin/users" element={<AdminUsersPage />} />
      <Route path="/:lang/diets" element={<DietsRegimensPage />} />
      <Route path="/:lang/diets/:slug" element={<DietDetailPage />} />
      <Route path="/:lang/exercises" element={<ExercisesPage />} />
      <Route path="/:lang/anatomy" element={<AnatomyPage />} />
      <Route path="/:lang/muscles" element={<AnatomyPage />} />
      <Route path="/:lang/exercises/systems" element={<ExerciseSystemsPage />} />
      <Route path="/:lang/exercises/systems/:systemId" element={<ExerciseSystemDetailPage />} />
      <Route path="/:lang/exercises/lower_back" element={<LegacyExerciseSlugRedirect />} />
      <Route path="/:lang/exercises/:muscle" element={<ExerciseRegionPage />} />
      <Route path="/:lang/insights/:slug" element={<ArticlePage />} />
      <Route path="/:lang/studio/articles" element={<AdminArticlesRedirect />} />
      <Route path="/:lang/assistant" element={<AssistantPage theme={theme} onToggleTheme={onToggleTheme} />} />
      <Route path="/:lang/auth" element={<AuthPage theme={theme} onToggleTheme={onToggleTheme} />} />
      <Route path="/:lang/auth/callback" element={<AuthCallbackPage />} />
      <Route path="/:lang/dashboard" element={<TrackingDashboardPage />} />
      <Route path="/auth/callback" element={<AuthCallbackPage />} />

      {[
        '/calculators',
        '/calculators/:calculator',
        '/privacy',
        '/terms',
        '/cookies',
        '/disclaimer',
        '/about',
        '/contact',
        '/insights',
        '/injury-protocols',
        '/injuries',
        '/injuries/:slug',
        '/insights/:slug',
        '/admin',
        '/admin/content',
        '/admin/homepage',
        '/admin/injuries',
        '/admin/articles',
        '/admin/exercises',
        '/admin/media',
        '/admin/seo',
        '/admin/users',
        '/studio/articles',
        '/assistant',
        '/auth',
        '/auth/callback',
        '/dashboard',
        '/diets',
        '/exercises',
        '/anatomy',
        '/muscles',
        '/exercises/systems',
        '/exercises/systems/:systemId',
        '/exercises/lower_back',
        '/exercises/:muscle',
      ].map((path) => (
        <Route key={path} path={path} element={<LegacyRouteRedirect />} />
      ))}

      <Route path="*" element={<NotFound />} />
    </Routes>
  );
}
