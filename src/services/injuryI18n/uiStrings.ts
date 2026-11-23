/** Arabic UI copy for injury pages — proper UTF-8, no runtime decoding */
export const injuryUiStrings = {
  ar: {
    nav: {
      protocols: 'بروتوكولات الإصابات',
      exercises: 'التمارين',
      diets: 'خطط التغذية',
      insights: 'المقالات',
      about: 'من نحن',
      assistant: 'المساعد الذكي',
      dashboard: 'لوحة المتابعة',
      account: 'الحساب',
    },
    library: {
      title: 'مكتبة بروتوكولات الإصابات',
      description:
        'واجهة مرتبة للمئة بروتوكول الأساسية فقط، مع تصفح أسرع حسب المنطقة والفئة والمرحلة العلاجية.',
      curatedSource: 'المكتبة الأساسية المعتمدة',
      heroTitle: 'المئة بروتوكول المرتبة في واجهة أوضح وأسرع',
      openFirst: 'افتح أول بروتوكول',
      askRecovery: 'اسأل عن خطة التعافي',
      protocolCount: 'إجمالي البروتوكولات',
      curatedNote: 'المكتبة المعتمدة فقط',
      topCategories: 'الفئات الرئيسية',
      fastBrowse: 'تقسيم أسرع للتصفح',
      bodyRegions: 'مناطق الجسم',
      regionNav: 'تنقل حسب المنطقة',
      searchFilter: 'بحث وتصفية',
      searchPlaceholder: 'ابحث باسم الإصابة أو البروتوكول',
      resultSnapshot: 'ملخص النتائج الحالية',
      matching: 'نتائج مطابقة',
      visibleCategories: 'فئات متاحة',
      clearFilters: 'مسح الفلاتر',
      allCategories: 'كل الفئات',
      protocolsWord: 'بروتوكول',
      allRegions: 'كل المناطق',
      libraryResults: 'نتائج المكتبة',
      currentView: 'مصدر العرض الحالي',
      loading: 'جاري التحميل',
      curatedLibrary: 'المكتبة المرتبة',
      results: 'نتيجة',
      noResults: 'لا توجد نتائج مطابقة',
      loadingProtocols: 'جاري تحميل البروتوكولات...',
      tryFilters: 'جرّب إزالة بعض الفلاتر أو استخدم اسم أقصر للإصابة.',
      structuredProtocol: 'بروتوكول تعافٍ مرتب',
      open: 'افتح',
      openDetails: 'افتح التفاصيل',
      category: 'الفئة',
      region: 'المنطقة',
      search: 'البحث',
    },
    relatedTitle: 'روابط ذات صلة',
  },
  en: {
    nav: {
      protocols: 'Injury Protocols',
      exercises: 'Exercises',
      diets: 'Diet Plans',
      insights: 'Insights',
      about: 'About',
      assistant: 'AI Assistant',
      dashboard: 'Dashboard',
      account: 'Account',
    },
    library: {} as Record<string, string>,
    relatedTitle: 'Related links',
  },
} as const;

export type InjuryUiLang = keyof typeof injuryUiStrings;

export function injuryUi(lang: InjuryUiLang, key: keyof typeof injuryUiStrings.ar.library) {
  const bucket = injuryUiStrings[lang].library;
  return (bucket as Record<string, string>)[key] || key;
}
