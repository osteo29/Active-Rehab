import {lazy, Suspense, useEffect, useMemo, useState} from 'react';
import {buildQuickSections} from './features/tools/app/config';
import type {CalculatorType} from './features/tools/app/types';
import {useAIDietPlan} from './hooks/useAIDietPlan';
import {useAppDerivedContent} from './hooks/useAppDerivedContent';
import {useArchitectProfile} from './hooks/useArchitectProfile';
import {useCalculatorWorkspace} from './hooks/useCalculatorWorkspace';
import {setPreferredLanguage} from './services/languagePreference';
import {translations, type Language} from './services/translations';
import {usePublishedArticles} from './services/articleStudio';
import {DeferredHomeSection, IconComponent} from './components/home/AppShellHelpers';
import Hero from './components/home/Hero';
import FeaturesShowcase from './components/home/FeaturesShowcase';
import InjuryProtocolsHighlight from './components/home/InjuryProtocolsHighlight';
import Footer from './components/layout/Footer';
import Navigation from './components/layout/Navigation';
import ConsentBanner from './components/monetization/ConsentBanner';

const MyRecoveryJourney = lazy(() => import('./components/dashboard/MyRecoveryJourney'));
const AboutSection = lazy(() => import('./components/home/AboutSection'));
const BlogSection = lazy(() => import('./components/home/BlogSection'));
const SupportToolsSection = lazy(() => import('./components/home/SupportToolsSection'));
const HealthProfileSection = lazy(() => import('./components/architect/HealthProfileSection'));
const CalculatorSection = lazy(() => import('./components/app/CalculatorSection'));

export default function App({
  theme,
  onToggleTheme,
  initialCalculatorId = null,
}: {
  theme: 'light' | 'dark';
  onToggleTheme: () => void;
  initialCalculatorId?: CalculatorType;
}) {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [lang, setLang] = useState<Language>(() => {
    const saved = localStorage.getItem('physiohub_lang');
    return (saved as Language) || 'ar';
  });

  const t = translations[lang];
  const {
    architectDraft,
    architectMetrics,
    architectProfile,
    architectResultsRef,
    calculateArchitectProfile,
    initialArchitectProfile,
    setArchitectProfile,
    updateArchitectDraft,
  } = useArchitectProfile();

  const {
    aiDietPlan,
    generateAIDietPlan,
    isGeneratingPlan,
  } = useAIDietPlan({
    architectMetrics,
    architectProfile,
    lang,
  });

  const calculator = useCalculatorWorkspace({
    architectProfile,
    initialArchitectProfile,
    initialCalculatorId,
    lang,
    setArchitectProfile,
    t,
  });

  const quickSections = useMemo(() => buildQuickSections(lang, t), [lang, t]);
  const {articles} = usePublishedArticles(lang);
  const {assessmentSnapshot, practicalGuide} = useAppDerivedContent({
    activeCalculator: calculator.activeCalculator,
    healthInterpretation: calculator.healthInterpretation,
    lang,
    result: calculator.result,
  });

  useEffect(() => {
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    document.documentElement.lang = lang;
    setPreferredLanguage(lang);
  }, [lang]);

  return (
    <div className="flex min-h-screen flex-col font-sans">
      <Navigation
        t={t}
        lang={lang}
        setLang={setLang}
        calculators={calculator.calculators}
        theme={theme}
        onToggleTheme={onToggleTheme}
        setActiveCalculator={(id) => calculator.setActiveCalculator(id as CalculatorType)}
        isSidebarOpen={isSidebarOpen}
        setIsSidebarOpen={setIsSidebarOpen}
      />

      <main id="main-content" className="flex-1">
        {/* Compact, action-focused Hero */}
        <Hero lang={lang} />

        {/* Methodology & quick jump */}
        <FeaturesShowcase lang={lang} quickSections={quickSections} />

        {/* Interactive My Recovery Journey Card */}
        <section id="my-recovery" className="bg-white py-10 dark:bg-slate-900 sm:py-14">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <Suspense
              fallback={
                <div className="h-44 animate-pulse rounded-[2rem] bg-slate-100 dark:bg-slate-800" />
              }
            >
              <MyRecoveryJourney lang={lang} />
            </Suspense>
          </div>
        </section>

        {/* Clinical Injury Protocols spotlight */}
        <InjuryProtocolsHighlight lang={lang} />

        {/* Health Profile & Architect Section */}
        <DeferredHomeSection id="architect" className="bg-slate-50 py-16 dark:bg-slate-950 sm:py-20">
          <HealthProfileSection
            aiDietPlan={aiDietPlan}
            architectDraft={architectDraft}
            architectMetrics={architectMetrics}
            architectProfile={architectProfile}
            architectResultsRef={architectResultsRef}
            calculateArchitectProfile={calculateArchitectProfile}
            generateAIDietPlan={generateAIDietPlan}
            isGeneratingPlan={isGeneratingPlan}
            lang={lang}
            setArchitectProfile={setArchitectProfile}
            t={t}
            updateArchitectDraft={updateArchitectDraft}
          />
        </DeferredHomeSection>

        {/* Calculators Suite */}
        <DeferredHomeSection id="calculators" className="bg-white py-16 dark:bg-slate-900 sm:py-20">
          <CalculatorSection
            assessmentSnapshot={assessmentSnapshot}
            controller={calculator}
            lang={lang}
            practicalGuide={practicalGuide}
            t={t}
          />
        </DeferredHomeSection>

        {/* Practical Support Tools (Food DB & Drug Checker) */}
        <DeferredHomeSection className="bg-slate-50 py-16 dark:bg-slate-950 sm:py-20">
          <SupportToolsSection
            lang={lang}
            t={t}
            foodCategory={calculator.foodCategory}
            setFoodCategory={calculator.setFoodCategory}
            showFoodTable={calculator.showFoodTable}
            setShowFoodTable={calculator.setShowFoodTable}
            foodSearch={calculator.foodSearch}
            setFoodSearch={calculator.setFoodSearch}
            filteredFoods={calculator.filteredFoods}
            addFoodToMeal={calculator.addFoodToMeal}
            setIsCustomModalOpen={calculator.setIsCustomModalOpen}
          />
        </DeferredHomeSection>

        {/* Insights & Articles */}
        <DeferredHomeSection id="blog" className="bg-white py-16 dark:bg-slate-900 sm:py-20">
          <BlogSection
            t={t}
            lang={lang}
            articles={articles}
            IconComponent={IconComponent}
          />
        </DeferredHomeSection>

        {/* About Section */}
        <DeferredHomeSection id="about" className="bg-slate-50 py-12 dark:bg-slate-950 sm:py-16">
          <AboutSection lang={lang} />
        </DeferredHomeSection>
      </main>

      <Footer t={t} lang={lang} />
      <ConsentBanner lang={lang} />
    </div>
  );
}
