import {buildAbsoluteUrl, getSiteUrl} from '../../services/site';

export type SeoConfig = {
  title: string;
  description: string;
  canonicalPath: string; // "/:lang/privacy" or "/privacy"
  ogImage?: string; // absolute URL
  noIndex?: boolean;
  structuredData?: Array<{id: string; json: unknown}>;
  hreflangs?: Array<{lang: string; href: string}>; // [{ lang: 'en', href: '/en/...' }, { lang: 'ar', href: '/ar/...' }]
};

const DEFAULT_SITE_NAME = 'Active Rehab';
const SEO_JSON_LD_SELECTOR = 'script[type="application/ld+json"][data-seo-id]';
const SEO_ALT_SELECTOR = 'link[rel="alternate"][hreflang]';

function upsertMeta(nameOrProp: {name?: string; property?: string}, content: string) {
  const selector = nameOrProp.name
    ? `meta[name="${nameOrProp.name}"]`
    : `meta[property="${nameOrProp.property}"]`;
  let el = document.head.querySelector(selector) as HTMLMetaElement | null;
  if (!el) {
    el = document.createElement('meta');
    if (nameOrProp.name) el.setAttribute('name', nameOrProp.name);
    if (nameOrProp.property) el.setAttribute('property', nameOrProp.property);
    document.head.appendChild(el);
  }
  el.setAttribute('content', content);
}

function upsertLink(rel: string, href: string, hreflangs?: Array<{lang: string; href: string}>) {
  if (rel === 'alternate' && hreflangs?.length) {
    // For hreflang links, remove all existing ones and add new ones
    document.head.querySelectorAll(SEO_ALT_SELECTOR).forEach((el) => el.remove());
    hreflangs.forEach((item) => {
      const el = document.createElement('link');
      el.setAttribute('rel', 'alternate');
      el.setAttribute('hreflang', item.lang);
      el.setAttribute('href', item.href);
      document.head.appendChild(el);
    });
    // Also add x-default
    const xDefault = document.createElement('link');
    xDefault.setAttribute('rel', 'alternate');
    xDefault.setAttribute('hreflang', 'x-default');
    xDefault.setAttribute('href', hreflangs.find(item => item.lang === 'en')?.href || href);
    document.head.appendChild(xDefault);
    return;
  }

  let el = document.head.querySelector(`link[rel="${rel}"]`) as HTMLLinkElement | null;
  if (!el) {
    el = document.createElement('link');
    el.setAttribute('rel', rel);
    document.head.appendChild(el);
  }
  el.setAttribute('href', href);
}

function upsertJsonLd(id: string, json: unknown) {
  let el = document.head.querySelector(
    `script[type="application/ld+json"][data-seo-id="${id}"]`,
  ) as HTMLScriptElement | null;
  if (!el) {
    el = document.createElement('script');
    el.type = 'application/ld+json';
    el.setAttribute('data-seo-id', id);
    document.head.appendChild(el);
  }
  el.text = JSON.stringify(json);
}

function clearManagedAlternates() {
  document.head.querySelectorAll(SEO_ALT_SELECTOR).forEach((el) => el.remove());
}

function syncJsonLd(structuredData: Array<{id: string; json: unknown}> = []) {
  const nextIds = new Set(structuredData.map((item) => item.id));

  document.head.querySelectorAll(SEO_JSON_LD_SELECTOR).forEach((node) => {
    const id = node.getAttribute('data-seo-id');
    if (!id || !nextIds.has(id)) {
      node.remove();
    }
  });

  structuredData.forEach((item) => {
    upsertJsonLd(item.id, item.json);
  });
}

function normalizeCanonicalPath(canonicalPath: string, currentLang?: string) {
  const rawPath = canonicalPath.startsWith('/') ? canonicalPath : `/${canonicalPath}`;

  if (
    rawPath.startsWith('/en/') ||
    rawPath.startsWith('/ar/') ||
    rawPath === '/en' ||
    rawPath === '/ar'
  ) {
    return rawPath;
  }

  if (!currentLang) {
    return rawPath;
  }

  return rawPath === '/' ? `/${currentLang}/` : `/${currentLang}${rawPath}`;
}

function getPageKeywords(canonicalPath: string, lang: string): string {
  const isAr = lang === 'ar';
  if (canonicalPath.includes('/injuries/') && canonicalPath.split('/').length > 4) {
    return isAr
      ? 'بروتوكول تعافي، علاج طبيعي، إصابة رياضية، تغذية علاجية، تأهيل'
      : 'injury recovery protocol, physical therapy, rehab nutrition, sports injury';
  }
  if (canonicalPath.includes('/injuries')) {
    return isAr
      ? 'مكتبة إصابات، بروتوكولات علاج طبيعي، تعافي من الإصابات، تأهيل'
      : 'injury library, physical therapy protocols, sports rehabilitation';
  }
  if (canonicalPath.includes('/diets')) {
    return isAr
      ? 'أنواع الدايت، تغذية علاجية، نظام غذائي، ريجيم صحي، دايت مضاد للالتهاب'
      : 'diet types, clinical nutrition, anti-inflammatory diet, meal plan';
  }
  if (canonicalPath.includes('/insights')) {
    return isAr
      ? 'مقالات علاج طبيعي، تغذية رياضية، تعافي من الإصابات، صحة'
      : 'physical therapy articles, sports nutrition, recovery, health insights';
  }
  if (canonicalPath.includes('/calculators') || canonicalPath.includes('/#calculators')) {
    return isAr
      ? 'حاسبة BMI، حاسبة سعرات، احتياج البروتين، TDEE، BMR، ماكروز'
      : 'BMI calculator, calorie calculator, protein needs, TDEE, BMR, macros';
  }
  if (canonicalPath.includes('/exercises')) {
    return isAr
      ? 'تمارين الجيم، دليل تمارين، تمارين عضلات، برنامج تدريبي، تمارين صدر، تمارين ظهر، تمارين رجل، تمارين كتف، تمارين ذراع'
      : 'gym exercises, exercise finder, muscle workouts, training program, chest exercises, back exercises, leg exercises, shoulder exercises, arm exercises';
  }
  return isAr
    ? 'Active Rehab، علاج طبيعي، تغذية علاجية، حاسبات صحية، تعافي'
    : 'Active Rehab, physical therapy, clinical nutrition, health calculators, recovery';
}

function getOgType(canonicalPath: string): string {
  if (canonicalPath.includes('/insights/') && canonicalPath.split('/').filter(Boolean).length >= 3) {
    return 'article';
  }
  if (canonicalPath.includes('/injuries/') && canonicalPath.split('/').filter(Boolean).length >= 3) {
    return 'article';
  }
  return 'website';
}

export function applySeo(config: SeoConfig) {
  const siteUrl = getSiteUrl();

  const currentLangMatch =
    typeof window !== 'undefined' ? window.location.pathname.match(/^\/(en|ar)(?:\/|$)/) : null;
  const currentLang = currentLangMatch?.[1];
  const normalizedPath = normalizeCanonicalPath(config.canonicalPath, currentLang);
  const canonicalUrl = buildAbsoluteUrl(normalizedPath);
  const ogImage = config.ogImage || buildAbsoluteUrl('/og-image.jpg');

  if (currentLang) {
    document.documentElement.lang = currentLang;
    document.documentElement.dir = currentLang === 'ar' ? 'rtl' : 'ltr';
  }

  document.title = config.title.includes(DEFAULT_SITE_NAME)
    ? config.title
    : `${config.title} | ${DEFAULT_SITE_NAME}`;

  upsertMeta({name: 'description'}, config.description);
  upsertMeta({name: 'keywords'}, getPageKeywords(normalizedPath, currentLang || 'en'));

  upsertLink('canonical', canonicalUrl);

  upsertMeta({name: 'robots'}, config.noIndex ? 'noindex, nofollow' : 'index, follow');

  upsertMeta({property: 'og:type'}, getOgType(normalizedPath));
  if (getOgType(normalizedPath) === 'article') {
    upsertMeta({property: 'article:author'}, 'Active Rehab');
    upsertMeta({property: 'article:publisher'}, 'https://www.facebook.com/Physionutrition.official/');
  } else {
    document.head.querySelectorAll('meta[property="article:author"], meta[property="article:publisher"]').forEach(node => node.remove());
  }
  upsertMeta({property: 'og:locale'}, currentLang === 'ar' ? 'ar_EG' : 'en_US');
  upsertMeta({property: 'og:site_name'}, DEFAULT_SITE_NAME);
  upsertMeta({property: 'og:url'}, canonicalUrl);
  upsertMeta({property: 'og:title'}, config.title);
  upsertMeta({property: 'og:description'}, config.description);
  upsertMeta({property: 'og:image'}, ogImage);

  upsertMeta({name: 'twitter:card'}, 'summary_large_image');
  upsertMeta({name: 'twitter:title'}, config.title);
  upsertMeta({name: 'twitter:description'}, config.description);
  upsertMeta({name: 'twitter:image'}, ogImage);

  if (config.hreflangs?.length) {
    upsertLink('alternate', canonicalUrl, config.hreflangs);
  } else {
    clearManagedAlternates();
  }

  syncJsonLd([
    {
      id: 'webapp',
      json: {
        '@context': 'https://schema.org',
        '@type': 'WebApplication',
        name: DEFAULT_SITE_NAME,
        url: siteUrl,
        description: config.description,
        applicationCategory: 'HealthApplication',
        operatingSystem: 'All',
      },
    },
    {
      id: 'organization',
      json: {
        '@context': 'https://schema.org',
        '@type': 'Organization',
        name: DEFAULT_SITE_NAME,
        url: siteUrl,
        email: 'physionutritionofficial@gmail.com',
        sameAs: [
          'https://www.facebook.com/Physionutrition.official/',
          'https://www.instagram.com/physionutrition.official/',
        ],
      },
    },
    {
      id: 'website',
      json: {
        '@context': 'https://schema.org',
        '@type': 'WebSite',
        name: DEFAULT_SITE_NAME,
        url: siteUrl,
        inLanguage: currentLang || 'en',
      },
    },
    ...(config.structuredData ?? []),
  ]);
}
