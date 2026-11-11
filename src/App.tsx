import {lazy, useEffect, useMemo, useState} from 'react';
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
import AdSlot from './components/monetization/AdSlot';

const WhatsNew = lazy(() => import('./components/home/WhatsNew'));
const AboutSection = lazy(() => import('./components/home/AboutSection'));
const BlogSection = lazy(() => import('./components/home/BlogSection'));
const TrustSection = lazy(() => import('./components/home/TrustSection'));
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
    return (saved as Language) || 'en';
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
        <Hero lang={lang} />

        <FeaturesShowcase lang={lang} quickSections={quickSections} />

        <InjuryProtocolsHighlight lang={lang} />

        <DeferredHomeSection id="architect" className="bg-slate-50 py-20">
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

        <DeferredHomeSection id="calculators" className="bg-white py-20">
          <CalculatorSection
            assessmentSnapshot={assessmentSnapshot}
            controller={calculator}
            lang={lang}
            practicalGuide={practicalGuide}
            t={t}
          />
        </DeferredHomeSection>

        <DeferredHomeSection className="bg-white py-20">
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

        <DeferredHomeSection className="bg-white py-16">
          <WhatsNew lang={lang} />
        </DeferredHomeSection>

        <section className="bg-slate-50 py-8">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <AdSlot
              lang={lang}
              label={lang === 'en' ? 'Sponsored area' : 'مساحة إعلانية'}
              slot={import.meta.env.VITE_ADSENSE_SLOT_INLINE}
              format="horizontal"
            />
          </div>
        </section>

        <DeferredHomeSection className="bg-white py-12">
          <TrustSection lang={lang} />
        </DeferredHomeSection>

        <DeferredHomeSection id="blog" className="bg-slate-50 py-20">
          <BlogSection
            t={t}
            lang={lang}
            articles={articles}
            IconComponent={IconComponent}
          />
        </DeferredHomeSection>

        <DeferredHomeSection id="about" className="bg-white py-16">
          <AboutSection lang={lang} />
        </DeferredHomeSection>
      </main>

      <Footer t={t} lang={lang} />
      <ConsentBanner lang={lang} />
    </div>
  );
}
