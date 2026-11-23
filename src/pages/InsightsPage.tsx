import {articleCategoryLabel} from '../services/articleCategoryLabels';
import {ArrowRight, Search} from 'lucide-react';
import {useMemo, useState} from 'react';
import {Link} from 'react-router-dom';
import ManagedSeo from '../components/seo/ManagedSeo';
import {usePublishedArticles} from '../services/articleStudio';
import {buildHreflangs} from '../utils/langUrlHelper';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';

function getReadingTime(content: string, lang: 'en' | 'ar') {
  const wordsPerMinute = lang === 'ar' ? 180 : 200;
  const wordCount = content.trim().split(/\s+/).length;
  const minutes = Math.max(1, Math.round(wordCount / wordsPerMinute));

  if (lang === 'ar') {
    return minutes === 1 ? 'دقيقة واحدة' : `${minutes} دقائق`;
  }

  return minutes === 1 ? '1 min read' : `${minutes} min read`;
}

export default function InsightsPage() {
  const lang = usePreferredLang();
  const {articles} = usePublishedArticles(lang);
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState('all');

  const categories = useMemo(() => {
    const uniqueCategories = Array.from(new Set(articles.map((article) => article.category)));
    return ['all', ...uniqueCategories];
  }, [articles]);

  const filteredArticles = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    return articles.filter((article) => {
      const matchesCategory = category === 'all' || article.category === category;
      const haystack = `${article.title} ${article.excerpt} ${articleCategoryLabel(article.category, lang)}`.toLowerCase();
      const matchesQuery = !normalizedQuery || haystack.includes(normalizedQuery);
      return matchesCategory && matchesQuery;
    });
  }, [articles, category, query, lang]);

  const featuredArticle = filteredArticles[0];
  const remainingArticles = filteredArticles.slice(1);

  return (
    <>
      <ManagedSeo
        pageKey="insights"
        lang={lang}
        canonicalPath="/insights"
        hreflangs={buildHreflangs('/insights')}
      />
      <PageLayout title={lang === 'en' ? 'Insights' : 'المقالات'}>
        <section className="rounded-[2rem] border border-slate-200 bg-gradient-to-br from-white via-slate-50 to-health-green/10 p-6 shadow-sm sm:p-8">
          <div className="max-w-3xl">
            <div className="mb-3 inline-flex items-center rounded-full border border-health-green/15 bg-white px-3 py-1 text-xs font-bold uppercase tracking-[0.2em] text-health-green-dark">
              {lang === 'en' ? 'Growth content hub' : 'مركز محتوى للنمو'}
            </div>
            <h1 className="text-3xl font-black leading-tight text-slate-900 sm:text-4xl">
              {lang === 'en'
                ? 'Guides that connect rehab, nutrition, and real next steps'
                : 'مقالات تربط التأهيل والتغذية بالخطوات العملية'}
            </h1>
            <p className="mt-4 max-w-2xl text-base leading-8 text-slate-600 sm:text-lg">
              {lang === 'en'
                ? 'Search, filter, and move from reading into practical tools like calculators, rehab pathways, and recovery tracking.'
                : 'ابحث وصف المحتوى ثم انتقل من القراءة إلى أدوات عملية مثل الحاسبات ومسارات التأهيل ومتابعة التعافي.'}
            </p>
          </div>

          <div className="mt-6 grid gap-4 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-center">
            <label className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
              <Search className="h-4 w-4 text-slate-400" />
              <input
                value={query}
                onChange={(event) => setQuery(event.target.value)}
                placeholder={lang === 'en' ? 'Search articles, topics, or categories...' : 'ابحث في المقالات أو التصنيفات...'}
                className="w-full bg-transparent text-sm text-slate-700 outline-none placeholder:text-slate-400"
              />
            </label>

            <div className="text-sm text-slate-500">
              {lang === 'en'
                ? `${filteredArticles.length} articles ready to explore`
                : `${filteredArticles.length} مقالًا جاهزًا للاستكشاف`}
            </div>
          </div>

          <div className="mt-6 flex flex-wrap gap-2">
            {categories.map((entry) => {
              const isActive = category === entry;
              const label = entry === 'all' ? (lang === 'en' ? 'All topics' : 'كل الموضوعات') : articleCategoryLabel(entry, lang);

              return (
                <button
                  key={entry}
                  type="button"
                  onClick={() => setCategory(entry)}
                  className={`rounded-full px-4 py-2 text-sm font-semibold transition ${
                    isActive
                      ? 'bg-health-green text-white shadow-sm'
                      : 'border border-slate-200 bg-white text-slate-600 hover:border-health-green/30 hover:text-health-green-dark'
                  }`}
                >
                  {label}
                </button>
              );
            })}
          </div>
        </section>

        {featuredArticle ? (
          <section className="mt-8 grid gap-6 xl:grid-cols-[minmax(0,1.25fr)_minmax(0,0.75fr)]">
            <Link
              to={`/${lang}/insights/${featuredArticle.slug}`}
              className="group rounded-[2rem] border border-slate-200 bg-slate-900 p-6 text-white shadow-sm transition-all hover:-translate-y-0.5 hover:shadow-lg sm:p-8"
            >
              <div className="mb-3 flex flex-wrap gap-3 text-sm text-white/70">
                <span>{articleCategoryLabel(featuredArticle.category, lang)}</span>
                <span>&bull;</span>
                <span>{featuredArticle.date}</span>
                <span>&bull;</span>
                <span>{getReadingTime(featuredArticle.content, lang)}</span>
              </div>
              <div className="mb-3 inline-flex rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-bold uppercase tracking-[0.16em] text-white/80">
                {lang === 'en' ? 'Featured guide' : 'مقال مميز'}
              </div>
              <h2 className="text-3xl font-black leading-tight sm:text-4xl">{featuredArticle.title}</h2>
              <p className="mt-4 max-w-2xl text-base leading-8 text-white/75">{featuredArticle.excerpt}</p>
              <div className="mt-6 inline-flex items-center gap-2 text-sm font-semibold text-health-sand">
                <span>{lang === 'en' ? 'Read featured guide' : 'اقرأ المقال المميز'}</span>
                <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
              </div>
            </Link>

            <div className="rounded-[2rem] border border-slate-200 bg-white p-6 shadow-sm">
              <h3 className="text-lg font-black text-slate-900">
                {lang === 'en' ? 'Reading paths' : 'مسارات للقراءة'}
              </h3>
              <p className="mt-2 text-sm leading-7 text-slate-600">
                {lang === 'en'
                  ? 'Use the filters to move between rehab, nutrition, and performance topics without losing context.'
                  : 'استخدم الفلاتر للتنقل بين التأهيل والتغذية والأداء بدون فقدان السياق.'}
              </p>
              <div className="mt-5 space-y-3">
                <Link
                  to={`/${lang}/injuries`}
                  className="block rounded-2xl border border-slate-200 bg-slate-50 p-4 transition hover:border-health-green/30 hover:bg-health-green/5"
                >
                  <div className="text-sm font-bold text-slate-900">
                    {lang === 'en' ? 'From article to injury journey' : 'من المقال إلى مسار إصابة'}
                  </div>
                  <p className="mt-1 text-sm leading-6 text-slate-600">
                    {lang === 'en'
                      ? 'Open structured rehab pathways after reading related guides.'
                      : 'افتح مسارات تأهيل منظمة بعد قراءة الأدلة المرتبطة.'}
                  </p>
                </Link>
                <Link
                  to={`/${lang}/calculators`}
                  className="block rounded-2xl border border-slate-200 bg-slate-50 p-4 transition hover:border-health-green/30 hover:bg-health-green/5"
                >
                  <div className="text-sm font-bold text-slate-900">
                    {lang === 'en' ? 'Turn education into targets' : 'حوّل المعرفة إلى أهداف'}
                  </div>
                  <p className="mt-1 text-sm leading-6 text-slate-600">
                    {lang === 'en'
                      ? 'Move into intake and recovery planning with calculators.'
                      : 'انتقل إلى تخطيط الاحتياجات والتعافي عبر الحاسبات.'}
                  </p>
                </Link>
              </div>
            </div>
          </section>
        ) : null}

        {remainingArticles.length > 0 ? (
          <section className="mt-8 grid grid-cols-1 gap-6 lg:grid-cols-2">
            {remainingArticles.map((article) => (
              <Link
                key={article.slug}
                to={`/${lang}/insights/${article.slug}`}
                className="group rounded-[2rem] border border-slate-200 bg-white p-6 shadow-sm transition-all hover:-translate-y-0.5 hover:border-health-green/30 hover:shadow-md"
              >
                <div className="mb-3 flex flex-wrap gap-3 text-sm text-slate-400">
                  <span>{articleCategoryLabel(article.category, lang)}</span>
                  <span>&bull;</span>
                  <span>{article.date}</span>
                  <span>&bull;</span>
                  <span>{getReadingTime(article.content, lang)}</span>
                </div>
                <h2 className="text-2xl font-bold leading-tight text-slate-900">{article.title}</h2>
                <p className="mt-3 text-slate-600">{article.excerpt}</p>
                <div className="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-health-green-dark">
                  <span>{lang === 'en' ? 'Open article' : 'افتح المقال'}</span>
                  <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
                </div>
              </Link>
            ))}
          </section>
        ) : null}

        {!filteredArticles.length ? (
          <section className="mt-8 rounded-[2rem] border border-dashed border-slate-300 bg-slate-50 p-10 text-center">
            <h2 className="text-2xl font-black text-slate-900">
              {lang === 'en' ? 'No matching articles yet' : 'لا توجد مقالات مطابقة الآن'}
            </h2>
            <p className="mt-3 text-sm leading-7 text-slate-600">
              {lang === 'en'
                ? 'Try another keyword or switch the topic filter to discover more guides.'
                : 'جرّب كلمة بحث أخرى أو غيّر الفلتر لاكتشاف مزيد من الأدلة.'}
            </p>
          </section>
        ) : null}
      </PageLayout>
    </>
  );
}
