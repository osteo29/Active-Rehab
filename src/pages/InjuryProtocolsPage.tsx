import {startTransition, useDeferredValue, useEffect, useMemo, useState} from 'react';
import {
  ArrowRight,
  ClipboardList,
  Layers3,
  Search,
  SlidersHorizontal,
  Sparkles,
  Timer,
  X,
} from 'lucide-react';
import {Link} from 'react-router-dom';
import Seo from '../components/seo/Seo';
import {getCatalogInjuries, type InjuryCatalogEntry} from '../services/injuryService';
import {injuryUiStrings} from '../services/injuryI18n/uiStrings';
import {buildAbsoluteUrl} from '../services/site';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';
import {injuryBody, injuryHeroShell, injuryInput, injuryPanel} from './injuryPageStyles';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';

type InsightCard = {
  label: string;
  value: string | number;
  note: string;
};

export default function InjuryProtocolsPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const lib = injuryUiStrings[lang].library;
  const [injuries, setInjuries] = useState<InjuryCatalogEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [category, setCategory] = useState('');
  const [bodyRegion, setBodyRegion] = useState('');
  const [query, setQuery] = useState('');
  const deferredQuery = useDeferredValue(query);

  useEffect(() => {
    let active = true;

    const load = async () => {
      setLoading(true);
      const {injuries: nextInjuries} = await getCatalogInjuries(lang);
      if (!active) return;
      setInjuries(nextInjuries);
      setLoading(false);
    };

    void load();

    return () => {
      active = false;
    };
  }, [lang]);

  const categories = useMemo(() => [...new Set(injuries.map((injury) => injury.category))], [injuries]);
  const bodyRegions = useMemo(() => [...new Set(injuries.map((injury) => injury.bodyRegion))], [injuries]);
  const hasActiveFilters = Boolean(category || bodyRegion || deferredQuery.trim());

  const filtered = useMemo(() => {
    const q = deferredQuery.trim().toLowerCase();
    return injuries.filter((injury) => {
      const byCategory = !category || injury.category === category;
      const byRegion = !bodyRegion || injury.bodyRegion === bodyRegion;
      const byQuery =
        !q ||
        injury.name.toLowerCase().includes(q) ||
        injury.category.toLowerCase().includes(q) ||
        injury.bodyRegion.toLowerCase().includes(q) ||
        injury.overview.toLowerCase().includes(q) ||
        injury.commonIn.some((item) => item.toLowerCase().includes(q));

      return byCategory && byRegion && byQuery;
    });
  }, [bodyRegion, category, deferredQuery, injuries]);

  const featured = filtered.slice(0, 6);
  const spotlight = filtered.slice(0, 2);
  const groupedCategories = categories
    .map((item) => ({
      name: item,
      count: injuries.filter((injury) => injury.category === item).length,
    }))
    .sort((left, right) => right.count - left.count);

  const insights: InsightCard[] = [
    {
      label: isAr ? lib.protocolCount : 'Protocol count',
      value: injuries.length,
      note: isAr ? lib.curatedNote : 'Curated source-of-truth set',
    },
    {
      label: isAr ? lib.topCategories : 'Top categories',
      value: categories.length,
      note: isAr ? lib.fastBrowse : 'Fast entry points for browsing',
    },
    {
      label: isAr ? lib.bodyRegions : 'Body regions',
      value: bodyRegions.length,
      note: isAr ? lib.regionNav : 'Body-region based navigation',
    },
  ];

  const title = isAr ? lib.title : 'Injury Protocol Library';
  const description = isAr
    ? lib.description
    : 'A sharper interface for the curated 100 injury protocols only, with faster browsing by region, category, and rehab focus.';

  const structuredData = [
    {
      id: 'injury-library-page',
      json: {
        '@context': 'https://schema.org',
        '@type': 'CollectionPage',
        name: title,
        description,
        url: buildAbsoluteUrl(navigationPaths.injuries(lang)),
      },
    },
    {
      id: 'injury-library-item-list',
      json: {
        '@context': 'https://schema.org',
        '@type': 'ItemList',
        itemListElement: filtered.slice(0, 18).map((injury, index) => ({
          '@type': 'ListItem',
          position: index + 1,
          name: injury.name,
          url: buildAbsoluteUrl(`/${lang}/injuries/${injury.slug}`),
        })),
      },
    },
  ];

  return (
    <>
      <Seo
        title={title}
        description={description}
        canonicalPath="/injuries"
        hreflangs={buildHreflangs('/injuries')}
        structuredData={structuredData}
      />
      <PageLayout title={title} hideTitle wide flat>
        <div className="space-y-8">
          <section className={injuryHeroShell}>
            <div className="grid gap-8 xl:grid-cols-[1.12fr_0.88fr]">
              <div className="space-y-6">
                <div className="inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-white/80 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green shadow-sm dark:bg-slate-900/80">
                  <ClipboardList className="h-3.5 w-3.5" />
                  <span>{isAr ? lib.curatedSource : 'Curated protocol source'}</span>
                </div>

                <div className="max-w-3xl">
                  <h2 className="text-3xl font-black tracking-tight text-slate-950 dark:text-white sm:text-5xl">
                    {isAr ? lib.heroTitle : 'The ordered 100 protocols in a cleaner, faster clinical library'}
                  </h2>
                  <p className="mt-4 text-sm leading-7 text-slate-600 dark:text-slate-300 sm:text-base">{description}</p>
                </div>

                <div className="flex flex-wrap gap-3">
                  <Link
                    to={featured[0] ? `/${lang}/injuries/${featured[0].slug}` : `/${lang}/injuries`}
                    className="inline-flex items-center gap-2 rounded-2xl bg-slate-950 px-5 py-3 text-sm font-bold text-white transition hover:bg-slate-800 dark:bg-health-green dark:hover:bg-health-green-dark"
                  >
                    {isAr ? lib.openFirst : 'Open first protocol'}
                    <ArrowRight className={`h-4 w-4 ${isAr ? 'rotate-180' : ''}`} />
                  </Link>
                  <Link
                    to={`/${lang}/assistant`}
                    className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-5 py-3 text-sm font-bold text-slate-700 transition hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100"
                  >
                    <Sparkles className="h-4 w-4 text-health-green" />
                    {isAr ? lib.askRecovery : 'Ask about recovery'}
                  </Link>
                </div>

                <div className="grid gap-3 sm:grid-cols-3">
                  {insights.map((item) => (
                    <div key={item.label} className="rounded-[1.45rem] border border-white/70 bg-white/80 p-3.5 shadow-sm backdrop-blur dark:border-slate-700 dark:bg-slate-900/85">
                      <div className="text-[11px] font-bold uppercase tracking-[0.16em] text-slate-500 dark:text-slate-400">{item.label}</div>
                      <div className="mt-1.5 text-2xl font-black text-slate-950 dark:text-white">{item.value}</div>
                      <div className="mt-1.5 text-xs leading-6 text-slate-500 dark:text-slate-300">{item.note}</div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="grid gap-4 xl:grid-cols-1">
                {spotlight.map((injury, index) => (
                  <Link
                    key={injury.id}
                    to={`/${lang}/injuries/${injury.slug}`}
                    className="group rounded-[1.75rem] border border-slate-200 bg-white/90 p-5 text-slate-900 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg dark:border-slate-700 dark:bg-slate-900 dark:text-white"
                  >
                    <div className="text-xs font-bold uppercase tracking-[0.18em] text-health-green">
                      {injury.category}
                    </div>
                    <div className="mt-2 text-xl font-black">{injury.name}</div>
                    <div className="mt-3 inline-flex rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-600 dark:bg-slate-950 dark:text-slate-300">
                      {injury.bodyRegion}
                    </div>
                    <p className="mt-3 line-clamp-3 text-sm leading-7 text-slate-600 dark:text-slate-300">
                      {injury.overview}
                    </p>
                    <div className="mt-5 inline-flex items-center gap-2 text-sm font-bold text-health-green">
                      {isAr ? lib.openDetails : 'Open details'}
                      <ArrowRight className={`h-4 w-4 transition group-hover:translate-x-0.5 ${isAr ? 'rotate-180 group-hover:-translate-x-0.5 group-hover:translate-y-0' : ''}`} />
                    </div>
                  </Link>
                ))}
              </div>
            </div>
          </section>

          <section className="grid gap-6 xl:grid-cols-[0.34fr_0.66fr]">
            <div className="space-y-6 xl:sticky xl:top-24 xl:self-start">
              <section className={injuryPanel}>
                <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                  <Search className="h-4 w-4 text-health-green" />
                  <span>{isAr ? lib.searchFilter : 'Search and filter'}</span>
                </div>

                <div className="space-y-4">
                  <div className="relative">
                    <Search
                      className={`pointer-events-none absolute top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400 dark:text-slate-500 ${isAr ? 'right-4' : 'left-4'}`}
                    />
                    <input
                      aria-label={isAr ? lib.searchPlaceholder : 'Search by injury or protocol name'}
                      value={query}
                      onChange={(e) =>
                        startTransition(() => {
                          setQuery(e.target.value);
                        })
                      }
                      placeholder={isAr ? lib.searchPlaceholder : 'Search by injury or protocol name'}
                      className={`${injuryInput} ${isAr ? 'pr-11 pl-4' : 'pl-11 pr-4'}`}
                    />
                  </div>

                  <div className="rounded-[1.5rem] border border-slate-200 bg-slate-50 p-4 dark:border-slate-700 dark:bg-slate-950">
                    <div className="mb-3 flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-slate-500">
                      <SlidersHorizontal className="h-3.5 w-3.5" />
                      <span>{isAr ? lib.resultSnapshot : 'Current result snapshot'}</span>
                    </div>
                    <div className="grid gap-3 sm:grid-cols-3 xl:grid-cols-1">
                      <div>
                        <div className="text-2xl font-black text-slate-950 dark:text-white">{filtered.length}</div>
                        <div className="text-sm text-slate-500 dark:text-slate-300">{isAr ? lib.matching : 'Matching protocols'}</div>
                      </div>
                      <div>
                        <div className="text-2xl font-black text-slate-950 dark:text-white">{categories.length}</div>
                        <div className="text-sm text-slate-500 dark:text-slate-300">{isAr ? lib.visibleCategories : 'Visible categories'}</div>
                      </div>
                      <div>
                        <div className="text-2xl font-black text-slate-950 dark:text-white">{bodyRegions.length}</div>
                        <div className="text-sm text-slate-500 dark:text-slate-300">{isAr ? lib.bodyRegions : 'Body regions'}</div>
                      </div>
                    </div>
                  </div>

                  {hasActiveFilters ? (
                    <button
                      type="button"
                      onClick={() => {
                        setQuery('');
                        setCategory('');
                        setBodyRegion('');
                      }}
                      className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-bold text-slate-600 transition hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-200"
                    >
                      <X className="h-3.5 w-3.5" />
                      {isAr ? lib.clearFilters : 'Clear filters'}
                    </button>
                  ) : null}
                </div>
              </section>

              <section className={injuryPanel}>
                <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                  <Layers3 className="h-4 w-4 text-health-green" />
                  <span>{isAr ? lib.topCategories : 'Primary categories'}</span>
                </div>
                <div className="grid gap-3">
                  <button
                    type="button"
                    onClick={() => setCategory('')}
                    className={`rounded-[1.4rem] border px-4 py-4 text-left transition ${
                      !category
                        ? 'border-slate-950 bg-slate-950 text-white dark:border-health-green'
                        : 'border-slate-200 bg-slate-50 text-slate-800 hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100'
                    }`}
                  >
                    <div className="font-bold">{isAr ? lib.allCategories : 'All categories'}</div>
                    <div className={`mt-2 text-sm ${!category ? 'text-white/70' : 'text-slate-500 dark:text-slate-300'}`}>
                      {injuries.length} {isAr ? lib.protocolsWord : 'protocols'}
                    </div>
                  </button>

                  {groupedCategories.map((item) => (
                    <button
                      key={item.name}
                      type="button"
                      onClick={() => setCategory((prev) => (prev === item.name ? '' : item.name))}
                      className={`rounded-[1.4rem] border px-4 py-4 text-left transition ${
                        category === item.name
                          ? 'border-health-green bg-health-green text-white shadow-lg shadow-health-green/20'
                          : 'border-slate-200 bg-slate-50 text-slate-800 hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100'
                      }`}
                    >
                      <div className="flex items-center justify-between gap-3">
                        <div className="font-bold">{item.name}</div>
                        <div className={`rounded-full px-2.5 py-1 text-xs font-bold ${category === item.name ? 'bg-white/15 text-white' : 'bg-white text-slate-500 ring-1 ring-slate-200 dark:bg-slate-900 dark:text-slate-300 dark:ring-slate-700'}`}>
                          {item.count}
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              </section>

              <section className={injuryPanel}>
                <div className="mb-4 flex items-center gap-2 text-sm font-black text-slate-900 dark:text-white">
                  <Timer className="h-4 w-4 text-health-green" />
                  <span>{isAr ? lib.bodyRegions : 'Body regions'}</span>
                </div>
                <div className="flex flex-wrap gap-2">
                  <button
                    type="button"
                    onClick={() => setBodyRegion('')}
                    className={`rounded-full border px-4 py-2 text-sm font-semibold transition ${
                      !bodyRegion
                        ? 'border-slate-950 bg-slate-950 text-white dark:border-health-green'
                        : 'border-slate-200 bg-slate-50 text-slate-700 hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100'
                    }`}
                  >
                    {isAr ? lib.allRegions : 'All regions'}
                  </button>
                  {bodyRegions.map((item) => (
                    <button
                      key={item}
                      type="button"
                      onClick={() => setBodyRegion((prev) => (prev === item ? '' : item))}
                      className={`rounded-full border px-4 py-2 text-sm font-semibold transition ${
                        bodyRegion === item
                          ? 'border-health-green bg-health-green text-white'
                          : 'border-slate-200 bg-slate-50 text-slate-700 hover:border-health-green/30 hover:bg-health-green/5 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100'
                      }`}
                    >
                      {item}
                    </button>
                  ))}
                </div>
              </section>
            </div>

            <section className={injuryPanel}>
              <div className="mb-5 flex flex-wrap items-center justify-between gap-4">
                <div>
                  <div className="text-sm font-black text-slate-900 dark:text-white">{isAr ? lib.libraryResults : 'Library results'}</div>
                  <p className="mt-1 text-sm text-slate-500 dark:text-slate-300">
                    {isAr
                      ? `${lib.currentView}: ${loading ? lib.loading : lib.curatedLibrary}`
                      : `Current display source: ${loading ? 'loading' : 'ordered protocol set'}`}
                  </p>
                </div>
                <div className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-slate-50 px-4 py-2 text-sm font-semibold text-slate-700 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100">
                  <ClipboardList className="h-4 w-4 text-health-green" />
                  <span>{filtered.length} {isAr ? lib.results : 'results'}</span>
                </div>
              </div>

              {hasActiveFilters ? (
                <div className="mb-5 flex flex-wrap gap-2">
                  {category ? (
                    <span className="rounded-full border border-health-green/20 bg-health-green/10 px-3 py-1 text-xs font-bold text-health-green">
                      {isAr ? 'الفئة' : 'Category'}: {category}
                    </span>
                  ) : null}
                  {bodyRegion ? (
                    <span className="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-bold text-slate-600 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-200">
                      {isAr ? 'المنطقة' : 'Region'}: {bodyRegion}
                    </span>
                  ) : null}
                  {deferredQuery.trim() ? (
                    <span className="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-bold text-slate-600 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-200">
                      {isAr ? 'البحث' : 'Search'}: {deferredQuery.trim()}
                    </span>
                  ) : null}
                </div>
              ) : null}

              {filtered.length === 0 ? (
                <div className="rounded-[1.75rem] border border-dashed border-slate-200 bg-slate-50 p-10 text-center dark:border-slate-700 dark:bg-slate-950">
                  <div className="text-lg font-black text-slate-900 dark:text-white">{isAr ? lib.noResults : 'No matching protocols'}</div>
                  <p className="mx-auto mt-3 max-w-md text-sm leading-7 text-slate-500 dark:text-slate-300">
                    {loading
                      ? isAr
                        ? lib.loadingProtocols
                        : 'Loading protocols...'
                      : isAr
                        ? lib.tryFilters
                        : 'Try clearing one of the filters or using a shorter search phrase.'}
                  </p>
                </div>
              ) : (
                <div className="grid gap-4">
                  {filtered.map((injury, index) => (
                    <Link
                      key={injury.id}
                      to={`/${lang}/injuries/${injury.slug}`}
                      className="group rounded-[1.7rem] border border-slate-200 bg-[linear-gradient(145deg,#ffffff,#f8fafc)] p-5 text-slate-900 transition hover:-translate-y-0.5 hover:shadow-lg dark:border-slate-700 dark:bg-[linear-gradient(145deg,#0f172a,#111827)] dark:text-white"
                    >
                      <div className="flex flex-wrap items-start justify-between gap-4">
                        <div className="min-w-0 flex-1">
                          <div className="text-xs font-bold uppercase tracking-[0.18em] text-health-green">
                            {injury.category}
                          </div>
                          <div className="mt-3 text-xl font-black">{injury.name}</div>
                        </div>
                        <div className="rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-600 dark:bg-slate-900 dark:text-slate-300">
                          {injury.bodyRegion}
                        </div>
                      </div>
                      <p className="mt-3 line-clamp-4 text-sm leading-7 text-slate-600 dark:text-slate-300">
                        {injury.overview}
                      </p>

                      <div className="mt-5 flex items-center justify-between gap-3">
                        <div className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400 dark:text-slate-500">
                          {isAr ? lib.structuredProtocol : 'Structured rehab protocol'}
                        </div>
                        <div className="inline-flex items-center gap-2 text-sm font-bold text-health-green">
                          {isAr ? lib.open : 'Open'}
                          <ArrowRight className={`h-4 w-4 transition group-hover:translate-x-0.5 ${isAr ? 'rotate-180 group-hover:-translate-x-0.5 group-hover:translate-y-0' : ''}`} />
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              )}
            </section>
          </section>
        </div>
      </PageLayout>
    </>
  );
}
