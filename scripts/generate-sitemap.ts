import {readFileSync, writeFileSync} from 'node:fs';
import {resolve} from 'node:path';
import {EXERCISE_FINDER_STATIC_SLUGS} from '../src/components/common/exercise-finder/constants';
import {TRAINING_SYSTEMS} from '../src/components/common/exercise-finder/data/training-systems';
import {CALCULATOR_PAGE_CONFIGS} from '../src/services/calculatorPages';
import {dietRegimensCatalog} from '../src/services/dietRegimensCatalog';
import {getInjuryPath} from '../src/services/injuryDatabase';
import {INJURY_CANONICAL_PARENT_MAP, normalizeExerciseUrlSlug} from '../src/services/seoAliases';
import {buildAbsoluteUrl, getSiteUrl} from '../src/services/site';
import {getBuildArticles, getBuildInjuries} from './buildContentSource';

const SITE_URL = getSiteUrl();
const LANGUAGES = ['en', 'ar'] as const;
type Language = (typeof LANGUAGES)[number];
const GENERATED_LASTMOD = '2026-11-12';

type RouteEntry = {
  path: string;
  changefreq: string;
  priority: string;
  lastmod?: string;
};

type RouteGroup = RouteEntry & {
  lang: Language;
  groupKey: string;
};

type SitemapFile = {
  filename: string;
  routes: RouteGroup[];
};

const staticRoutes: RouteEntry[] = [
  {path: '/', changefreq: 'weekly', priority: '1.0', lastmod: GENERATED_LASTMOD},
  {path: '/calculators', changefreq: 'weekly', priority: '0.9', lastmod: GENERATED_LASTMOD},
  ...CALCULATOR_PAGE_CONFIGS.map((calculator) => ({
    path: `/calculators/${calculator.slug}`,
    changefreq: 'weekly',
    priority: '0.85',
    lastmod: GENERATED_LASTMOD,
  })),
  {path: '/exercises', changefreq: 'weekly', priority: '0.9', lastmod: GENERATED_LASTMOD},
  {path: '/exercises/systems', changefreq: 'weekly', priority: '0.85', lastmod: GENERATED_LASTMOD},
  ...TRAINING_SYSTEMS.map((system) => ({
    path: `/exercises/systems/${system.id}`,
    changefreq: 'weekly',
    priority: '0.8',
    lastmod: GENERATED_LASTMOD,
  })),
  ...EXERCISE_FINDER_STATIC_SLUGS.map((slug) => ({
    path: `/exercises/${normalizeExerciseUrlSlug(slug)}`,
    changefreq: 'weekly',
    priority:
      slug === 'chest' || slug === 'back' || slug === 'shoulders' || slug === 'legs' ? '0.85' : '0.8',
    lastmod: GENERATED_LASTMOD,
  })),
  {path: '/injuries', changefreq: 'weekly', priority: '0.9', lastmod: GENERATED_LASTMOD},
  {path: '/insights', changefreq: 'weekly', priority: '0.8', lastmod: GENERATED_LASTMOD},
  {path: '/diets', changefreq: 'monthly', priority: '0.85', lastmod: GENERATED_LASTMOD},
  {path: '/privacy', changefreq: 'monthly', priority: '0.6', lastmod: GENERATED_LASTMOD},
  {path: '/about', changefreq: 'monthly', priority: '0.7', lastmod: GENERATED_LASTMOD},
  {path: '/contact', changefreq: 'monthly', priority: '0.7', lastmod: GENERATED_LASTMOD},
  {path: '/terms', changefreq: 'monthly', priority: '0.6', lastmod: GENERATED_LASTMOD},
  {path: '/cookies', changefreq: 'monthly', priority: '0.5', lastmod: GENERATED_LASTMOD},
  {path: '/disclaimer', changefreq: 'monthly', priority: '0.5', lastmod: GENERATED_LASTMOD},
];

function absoluteUrl(path: string) {
  return buildAbsoluteUrl(path);
}

function buildRouteGroup(
  path: string,
  lang: Language,
  changefreq: string,
  priority: string,
  lastmod?: string,
): RouteGroup {
  return {
    path: `/${lang}${path}`,
    lang,
    groupKey: path,
    changefreq,
    priority,
    ...(lastmod ? {lastmod} : {}),
  };
}

function renderUrlSet(routes: RouteGroup[]) {
  const alternatesByGroup = new Map<string, RouteGroup[]>();

  routes.forEach((route) => {
    const current = alternatesByGroup.get(route.groupKey);
    if (current) {
      current.push(route);
    } else {
      alternatesByGroup.set(route.groupKey, [route]);
    }
  });

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
${routes
  .map((route) => {
    const alternates = (alternatesByGroup.get(route.groupKey) || [route]).sort((a, b) => a.lang.localeCompare(b.lang));
    const xDefault = alternates.find((item) => item.lang === 'en')?.path || route.path;

    return `  <url>
    <loc>${absoluteUrl(route.path)}</loc>
${alternates
  .map(
    (alternate) =>
      `    <xhtml:link rel="alternate" hreflang="${alternate.lang}" href="${absoluteUrl(alternate.path)}" />`,
  )
  .join('\n')}
    <xhtml:link rel="alternate" hreflang="x-default" href="${absoluteUrl(xDefault)}" />
    <lastmod>${route.lastmod || GENERATED_LASTMOD}</lastmod>
    <changefreq>${route.changefreq}</changefreq>
    <priority>${route.priority}</priority>
  </url>`;
  })
  .join('\n')}
</urlset>
`;
}

function renderSitemapIndex(files: SitemapFile[]) {
  return `<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${files
  .map(
    (file) => `  <sitemap>
    <loc>${SITE_URL}/${file.filename}</loc>
    <lastmod>${GENERATED_LASTMOD}</lastmod>
  </sitemap>`,
  )
  .join('\n')}
</sitemapindex>
`;
}

const langStaticRoutes: RouteGroup[] = staticRoutes.flatMap((route) =>
  LANGUAGES.map((lang) => buildRouteGroup(route.path, lang, route.changefreq, route.priority, route.lastmod)),
);

const buildArticlesByLang = Object.fromEntries(
  await Promise.all(LANGUAGES.map(async (lang) => [lang, await getBuildArticles(lang)])),
) as Record<Language, Awaited<ReturnType<typeof getBuildArticles>>>;

const buildInjuries = await getBuildInjuries();

const articleRoutes: RouteGroup[] = LANGUAGES.flatMap((lang) =>
  buildArticlesByLang[lang].map((article) => ({
    path: `/${lang}/insights/${article.slug}`,
    lang,
    groupKey: `/insights/${article.slug}`,
    changefreq: 'monthly',
    priority: '0.8',
    lastmod: article.date || GENERATED_LASTMOD,
  })),
);
const canonicalInjuries = buildInjuries.filter((injury) => !INJURY_CANONICAL_PARENT_MAP[injury.id]);

const injuryRoutes: RouteGroup[] = canonicalInjuries.flatMap((injury) =>
  LANGUAGES.map((lang) => ({
    path: getInjuryPath(injury, lang),
    lang,
    groupKey: getInjuryPath(injury, 'en').replace(/^\/en/, ''),
    changefreq: 'weekly',
    priority: '0.8',
    lastmod: GENERATED_LASTMOD,
  })),
);

const dietRoutes: RouteGroup[] = dietRegimensCatalog.flatMap((diet) =>
  LANGUAGES.map((lang) => ({
    path: `/${lang}/diets/${diet.id}`,
    lang,
    groupKey: `/diets/${diet.id}`,
    changefreq: 'monthly',
    priority: '0.8',
    lastmod: GENERATED_LASTMOD,
  })),
);

const sitemapFiles: SitemapFile[] = [
  {filename: 'sitemap-static.xml', routes: langStaticRoutes},
  {filename: 'sitemap-articles.xml', routes: articleRoutes},
  {filename: 'sitemap-injuries.xml', routes: injuryRoutes},
  {filename: 'sitemap-diets.xml', routes: dietRoutes},
];

const publicDir = resolve(process.cwd(), 'public');

sitemapFiles.forEach((file) => {
  writeFileSync(resolve(publicDir, file.filename), renderUrlSet(file.routes), 'utf8');
});

const sitemapIndexXml = renderSitemapIndex(sitemapFiles);
writeFileSync(resolve(publicDir, 'sitemap.xml'), sitemapIndexXml, 'utf8');
writeFileSync(resolve(publicDir, 'sitemap-index.xml'), sitemapIndexXml, 'utf8');

const robotsPath = resolve(publicDir, 'robots.txt');
const robotsBody = readFileSync(robotsPath, 'utf8')
  .replace(/^Sitemap:.*$/gm, '')
  .trimEnd();
const nextRobots = `${robotsBody}\n\nSitemap: ${SITE_URL}/sitemap.xml\n`;
writeFileSync(robotsPath, nextRobots, 'utf8');

const totalRoutes = sitemapFiles.reduce((sum, file) => sum + file.routes.length, 0);
console.log(`Generated ${sitemapFiles.length} sitemap files with ${totalRoutes} URLs and refreshed sitemap index.`);
