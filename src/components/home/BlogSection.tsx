import {memo, type ComponentType} from 'react';
import {Link} from 'react-router-dom';
import {ArrowUpRight, Calendar, Tag} from 'lucide-react';
import type {Language} from '../../services/translations';
import type {Article} from '../../services/articles';
import {navigationPaths} from '../../utils/langUrlHelper';

type IconComponentType = ComponentType<{name: string; className?: string}>;

const BlogSection = memo(
  ({
    t,
    lang,
    articles,
    IconComponent,
  }: {
    t: any;
    lang: Language;
    articles: Article[];
    IconComponent: IconComponentType;
  }) => {
    const isAr = lang === 'ar';

    return (
      <section className="section-surface bg-slate-50 py-24">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mb-10 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h2 className="mb-3 text-3xl font-bold text-slate-900">{t.blog.sectionTitle}</h2>
              <p className="text-slate-600">
                {isAr
                  ? `يوجد حاليًا ${articles.length} مقالات منشورة، وكل مقال يفتح في صفحة مستقلة.`
                  : `${articles.length} published articles, each with its own page.`}
              </p>
            </div>
            <Link
              to={navigationPaths.insights(lang)}
              className="inline-flex items-center gap-2 self-start rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-bold text-slate-900 transition-all hover:border-health-green"
            >
              {isAr ? 'عرض كل المقالات' : 'View all articles'}
              <ArrowUpRight className="h-4 w-4 text-health-green" />
            </Link>
          </div>

          <div className="grid grid-cols-1 gap-8 md:grid-cols-2 xl:grid-cols-3">
            {articles.map((article) => (
              <Link
                key={article.slug}
                to={navigationPaths.insightsDetail(lang, article.slug)}
                className="group flex h-full flex-col overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-sm transition-all duration-300 hover:-translate-y-1 hover:border-health-green/20 hover:shadow-xl"
              >
                <div className="relative flex aspect-video items-center justify-center overflow-hidden bg-soft-blue">
                  <div className="rounded-2xl bg-white p-6 shadow-sm transition-transform duration-500 group-hover:scale-110">
                    <IconComponent name={article.icon} className="h-12 w-12 text-health-green" />
                  </div>
                  <div className="absolute left-4 top-4 rtl:left-auto rtl:right-4">
                    <span className="flex items-center gap-1 rounded-full bg-white/90 px-3 py-1 text-xs font-bold text-health-green shadow-sm backdrop-blur-sm">
                      <Tag className="h-3 w-3" /> {article.category}
                    </span>
                  </div>
                </div>

                <div className="flex flex-1 flex-col p-8">
                  <div className="mb-3 flex items-center gap-2 text-xs text-slate-400">
                    <Calendar className="h-3 w-3" /> {article.date}
                  </div>
                  <h3 className="mb-3 text-xl font-bold text-slate-900 transition-colors group-hover:text-health-green">
                    {article.title}
                  </h3>
                  <p className="mb-6 flex-1 text-sm leading-7 text-slate-600">{article.excerpt}</p>
                  <div className="inline-flex items-center gap-2 font-bold text-health-green">
                    {isAr ? 'افتح المقال كاملًا' : 'Open full article'}
                    <ArrowUpRight className="h-4 w-4" />
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>
    );
  },
);

BlogSection.displayName = 'BlogSection';

export default BlogSection;
