import {resolveArticleLink} from '../services/articleLinks';
import {ArrowRight, Compass, Sparkles, Stethoscope} from 'lucide-react';
import {Fragment, type ReactNode} from 'react';
import {Link, useParams} from 'react-router-dom';
import ManagedSeo from '../components/seo/ManagedSeo';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import Seo from '../components/seo/Seo';
import {usePublishedArticles} from '../services/articleStudio';
import type {Article} from '../services/articles';
import {buildAbsoluteUrl} from '../services/site';
import type {Language} from '../services/translations';

type ArticleBlock =
  | {type: 'paragraph'; text: string}
  | {type: 'list'; items: string[]}
  | {type: 'heading'; level: 2; text: string; anchor: string};

type ArticleFaqItem = {
  question: string;
  answer: string;
};

type GrowthLink = {
  title: string;
  description: string;
  to: string;
  icon: typeof Compass;
};

function slugifyHeading(text: string, fallbackIndex: number) {
  const normalized = text
    .toLowerCase()
    .trim()
    .replace(/[؟?]/g, '')
    .replace(/[^a-z0-9\u0600-\u06ff]+/g, '-')
    .replace(/^-+|-+$/g, '');

  return normalized || `section-${fallbackIndex + 1}`;
}

function renderInline(text: string, lang: Language): ReactNode[] {
  const parts = text.split(/(\[[^\]]+\]\([^)]+\))/g).filter(Boolean);

  return parts.map((part, index) => {
    const match = part.match(/^\[([^\]]+)\]\(([^)]+)\)$/);
    if (!match) return <Fragment key={`${part}-${index}`}>{part}</Fragment>;

    const [, label, href] = match;
    const resolved = resolveArticleLink(href, lang);
    if (!resolved) return <Fragment key={`${part}-${index}`}>{label}</Fragment>;
    const {internal: isInternal, href: resolvedHref} = resolved;

    return isInternal ? (
      <Link key={`${resolvedHref}-${index}`} to={resolvedHref} className="font-semibold text-health-green hover:underline">
        {label}
      </Link>
    ) : (
      <a
        key={`${resolvedHref}-${index}`}
        href={resolvedHref}
        target="_blank"
        rel="noreferrer"
        className="font-semibold text-health-green hover:underline"
      >
        {label}
      </a>
    );
  });
}

function parseArticleContent(content: string) {
  const lines = content.split('\n');
  const blocks: ArticleBlock[] = [];
  const headings: Array<{text: string; anchor: string}> = [];
  let paragraphBuffer: string[] = [];
  let listBuffer: string[] = [];
  let headingIndex = 0;

  const flushParagraph = () => {
    if (!paragraphBuffer.length) return;
    const text = paragraphBuffer.join(' ').trim();
    if (text) blocks.push({type: 'paragraph', text});
    paragraphBuffer = [];
  };

  const flushList = () => {
    if (!listBuffer.length) return;
    blocks.push({type: 'list', items: listBuffer});
    listBuffer = [];
  };

  for (const rawLine of lines) {
    const line = rawLine.trim();

    if (!line) {
      flushParagraph();
      flushList();
      continue;
    }

    if (line.startsWith('## ')) {
      flushParagraph();
      flushList();
      const text = line.slice(3).trim();
      const anchor = slugifyHeading(text, headingIndex);
      headingIndex += 1;
      headings.push({text, anchor});
      blocks.push({type: 'heading', level: 2, text, anchor});
      continue;
    }

    if (line.startsWith('* ')) {
      flushParagraph();
      listBuffer.push(line.slice(2));
      continue;
    }

    flushList();
    paragraphBuffer.push(line);
  }

  flushParagraph();
  flushList();

  const faqItems: ArticleFaqItem[] = [];

  blocks.forEach((block, index) => {
    if (block.type !== 'heading') return;
    if (!/[؟?]$/.test(block.text)) return;

    const answerParts: string[] = [];

    for (let i = index + 1; i < blocks.length; i += 1) {
      const nextBlock = blocks[i];
      if (nextBlock.type === 'heading') break;
      if (nextBlock.type === 'paragraph') answerParts.push(nextBlock.text);
      if (nextBlock.type === 'list') answerParts.push(nextBlock.items.join(' '));
    }

    const answer = answerParts.join(' ').trim();
    if (answer) {
      faqItems.push({question: block.text, answer});
    }
  });

  return {blocks, headings, faqItems};
}

function renderBlocks(blocks: ArticleBlock[], lang: Language): ReactNode[] {
  return blocks.map((block, index) => {
    if (block.type === 'paragraph') {
      return <p key={`p-${index}`}>{renderInline(block.text, lang)}</p>;
    }

    if (block.type === 'list') {
      return (
        <ul key={`ul-${index}`} className="list-disc space-y-2 pl-6">
          {block.items.map((item, itemIndex) => (
            <li key={`li-${index}-${itemIndex}`}>{renderInline(item, lang)}</li>
          ))}
        </ul>
      );
    }

    return (
      <h2 id={block.anchor} key={`h2-${index}`} className="scroll-mt-24 pt-2 text-2xl font-bold text-slate-900">
        <a href={`#${block.anchor}`} className="transition hover:text-health-green-dark">
          {block.text}
        </a>
      </h2>
    );
  });
}

function getRelatedArticles(
  articles: Article[],
  currentArticle: Pick<Article, 'slug' | 'category'>,
) {
  const others = articles.filter((entry) => entry.slug !== currentArticle.slug);

  const sameCategory = others.filter((entry) => entry.category === currentArticle.category);

  const recentOthers = others
    .filter((entry) => entry.category !== currentArticle.category)
    .sort((a, b) => b.date.localeCompare(a.date));

  const result = [...sameCategory, ...recentOthers].slice(0, 3);
  return result;
}

function hasKeyword(article: Pick<Article, 'title' | 'excerpt' | 'content' | 'category'>, pattern: RegExp) {
  return pattern.test(`${article.title} ${article.excerpt} ${article.category} ${article.content}`);
}

function getGrowthLinks(article: Article, lang: Language): GrowthLink[] {
  const links: GrowthLink[] = [];

  if (hasKeyword(article, /(injury|pain|rehab|recovery|knee|shoulder|acl|hamstring|tendon)/i)) {
    links.push({
      title: lang === 'en' ? 'Explore rehab pathways' : 'استكشف مسارات التأهيل',
      description:
        lang === 'en'
          ? 'Move from reading into guided injury and rehab journeys.'
          : 'انتقل من القراءة إلى مسارات إصابات وتأهيل عملية.',
      to: `/${lang}/injuries`,
      icon: Stethoscope,
    });
  }

  if (hasKeyword(article, /(nutrition|protein|calorie|diet|supplement|meal|creatine|hydration)/i)) {
    links.push({
      title: lang === 'en' ? 'Use smart calculators' : 'استخدم الحاسبات الذكية',
      description:
        lang === 'en'
          ? 'Turn the advice into calorie, protein, and intake targets.'
          : 'حوّل النصائح إلى أهداف عملية للسعرات والبروتين والاحتياج اليومي.',
      to: `/${lang}/calculators`,
      icon: Sparkles,
    });
  }

  if (hasKeyword(article, /(assessment|tracking|progress|measure|dashboard|baseline|monitor)/i)) {
    links.push({
      title: lang === 'en' ? 'Track recovery progress' : 'تابع تقدم التعافي',
      description:
        lang === 'en'
          ? 'Log assessments and keep the article connected to measurable change.'
          : 'سجل التقييمات واجعل المقال مرتبطًا بتغير يمكن قياسه.',
      to: `/${lang}/dashboard`,
      icon: Compass,
    });
  }

  links.push({
    title: lang === 'en' ? 'Browse more guides' : 'تصفح المزيد من الأدلة',
    description:
      lang === 'en'
        ? 'Discover related content built around rehab, nutrition, and performance.'
        : 'اكتشف محتوى مرتبطًا بالتأهيل والتغذية والأداء.',
    to: `/${lang}/insights`,
    icon: Compass,
  });

  return links.slice(0, 3);
}

function getReadingTime(content: string, lang: Language): string {
  const wordsPerMinute = lang === 'ar' ? 180 : 200;
  const wordCount = content.trim().split(/\s+/).length;
  const minutes = Math.max(1, Math.round(wordCount / wordsPerMinute));

  if (lang === 'ar') {
    return minutes === 1 ? 'دقيقة واحدة' : `${minutes} دقائق`;
  }
  return minutes === 1 ? '1 min read' : `${minutes} min read`;
}

export default function ArticlePage() {
  const lang = usePreferredLang();
  const {slug = ''} = useParams();
  const {articles, loading} = usePublishedArticles(lang);
  const article = articles.find((entry) => entry.slug === slug);

  if (loading) {
    return (
      <>
        <Seo
          title={lang === 'en' ? 'Loading article' : 'جار تحميل المقال'}
          description={lang === 'en' ? 'Loading article content.' : 'جار تحميل محتوى المقال.'}
          canonicalPath={`/insights/${slug}`}
        />
        <PageLayout title={lang === 'en' ? 'Loading article' : 'جار تحميل المقال'}>
          <p>{lang === 'en' ? 'Please wait a moment.' : 'انتظر لحظة من فضلك.'}</p>
        </PageLayout>
      </>
    );
  }

  if (!article) {
    return (
      <>
        <Seo
          title={lang === 'en' ? 'Article Not Found' : 'المقال غير موجود'}
          description={
            lang === 'en'
              ? 'The requested Active Rehab article could not be found.'
              : 'تعذر العثور على المقال المطلوب.'
          }
          canonicalPath={`/insights/${slug}`}
          noIndex
        />
        <PageLayout title={lang === 'en' ? 'Article not found' : 'المقال غير موجود'}>
          <p>{lang === 'en' ? 'This article is not available.' : 'هذا المقال غير متاح.'}</p>
          <p>
            <Link to={`/${lang}/insights`} className="font-semibold text-health-green hover:underline">
              {lang === 'en' ? 'Back to insights' : 'العودة إلى المقالات'}
            </Link>
          </p>
        </PageLayout>
      </>
    );
  }

  const {blocks, headings, faqItems} = parseArticleContent(article.content);
  const relatedArticles = getRelatedArticles(articles, article);
  const growthLinks = getGrowthLinks(article, lang);
  const canonicalPath = `/${lang}/insights/${article.slug}`;
  const canonicalUrl = buildAbsoluteUrl(canonicalPath);
  const hreflangs = [
    {lang: 'en', href: buildAbsoluteUrl(`/en/insights/${article.slug}`)},
    {lang: 'ar', href: buildAbsoluteUrl(`/ar/insights/${article.slug}`)},
  ];

  const structuredData: Array<{id: string; json: unknown}> = [
    {
      id: `article-${article.slug}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'BlogPosting',
        headline: article.title,
        description: article.excerpt,
        articleSection: article.category,
        datePublished: article.date,
        dateModified: article.date,
        timeRequired: `PT${Math.max(1, Math.round(article.content.split(/\s+/).length / (lang === 'ar' ? 180 : 200)))}M`,
        inLanguage: lang,
        mainEntityOfPage: canonicalUrl,
        url: canonicalUrl,
        author: {
          '@type': 'Organization',
          name: 'Active Rehab',
        },
        publisher: {
          '@type': 'Organization',
          name: 'Active Rehab',
        },
        hasPart: headings.map((heading) => ({
          '@type': 'WebPageElement',
          '@id': `${canonicalUrl}#${heading.anchor}`,
          name: heading.text,
        })),
      },
    },
    {
      id: `article-breadcrumb-${article.slug}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'BreadcrumbList',
        itemListElement: [
          {
            '@type': 'ListItem',
            position: 1,
            name: lang === 'en' ? 'Home' : 'الرئيسية',
            item: buildAbsoluteUrl(`/${lang}/`),
          },
          {
            '@type': 'ListItem',
            position: 2,
            name: lang === 'en' ? 'Insights' : 'المقالات',
            item: buildAbsoluteUrl(`/${lang}/insights`),
          },
          {
            '@type': 'ListItem',
            position: 3,
            name: article.title,
            item: canonicalUrl,
          },
        ],
      },
    },
  ];

  if (faqItems.length) {
    structuredData.push({
      id: `article-faq-${article.slug}`,
      json: {
        '@context': 'https://schema.org',
        '@type': 'FAQPage',
        mainEntity: faqItems.map((item) => ({
          '@type': 'Question',
          name: item.question,
          acceptedAnswer: {
            '@type': 'Answer',
            text: item.answer,
          },
        })),
      },
    });
  }

  return (
    <>
      <ManagedSeo
        pageKey="article_detail"
        lang={lang}
        canonicalPath={canonicalPath}
        structuredData={structuredData}
        hreflangs={hreflangs}
        publishedTime={article.date && !Number.isNaN(Date.parse(article.date)) ? article.date : undefined}
        templateValues={{
          articleTitle: article.title,
          articleExcerpt: article.excerpt,
        }}
      />
      <PageLayout title={article.title}>
        <article className="not-prose">
          <header className="rounded-[2rem] border border-slate-200 bg-slate-50 p-6 sm:p-8">
            <div className="mb-4 flex flex-wrap gap-3 text-sm text-slate-500">
              <span>{article.category}</span>
              <span>&bull;</span>
              <span>{article.date}</span>
              <span>&bull;</span>
              <span>{getReadingTime(article.content, lang)}</span>
            </div>

            <h1 className="text-3xl font-black leading-tight text-slate-900 sm:text-4xl">{article.title}</h1>
            <p className="mt-4 text-lg leading-8 text-slate-700">{article.excerpt}</p>
          </header>

          {headings.length >= 3 ? (
            <nav
              aria-label={lang === 'en' ? 'Article sections' : 'أقسام المقال'}
              className="mt-6 rounded-[2rem] border border-slate-200 bg-white p-5 shadow-sm"
            >
              <div className="mb-3 text-sm font-bold uppercase tracking-[0.16em] text-slate-400">
                {lang === 'en' ? 'Jump To Section' : 'انتقل إلى القسم'}
              </div>
              <div className="flex flex-wrap gap-2">
                {headings.map((heading) => (
                  <a
                    key={heading.anchor}
                    href={`#${heading.anchor}`}
                    className="rounded-full border border-slate-200 bg-slate-50 px-3 py-1.5 text-sm font-semibold text-slate-600 transition hover:border-health-green/40 hover:bg-health-green/5 hover:text-health-green-dark"
                  >
                    {heading.text}
                  </a>
                ))}
              </div>
            </nav>
          ) : null}

          <div className="mt-8 space-y-5 leading-8 text-slate-700">{renderBlocks(blocks, lang)}</div>

          {growthLinks.length > 0 ? (
            <section className="mt-10 rounded-[2rem] border border-health-green/15 bg-gradient-to-br from-health-green/5 via-white to-sky-50 p-6 sm:p-8">
              <div className="mb-5">
                <h2 className="text-2xl font-black text-slate-900">
                  {lang === 'en' ? 'What to do next' : 'ما الخطوة التالية؟'}
                </h2>
                <p className="mt-2 text-sm leading-7 text-slate-600">
                  {lang === 'en'
                    ? 'Keep the momentum going by turning this article into an action, tool, or deeper rehab path.'
                    : 'حافظ على الزخم وحول هذا المقال إلى خطوة عملية أو أداة أو مسار تأهيل أعمق.'}
                </p>
              </div>

              <div className="grid gap-4 md:grid-cols-3">
                {growthLinks.map((link) => {
                  const Icon = link.icon;

                  return (
                    <Link
                      key={link.to}
                      to={link.to}
                      className="group rounded-3xl border border-white/80 bg-white/90 p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:border-health-green/30 hover:shadow-md"
                    >
                      <div className="mb-4 flex h-11 w-11 items-center justify-center rounded-2xl bg-health-green/10 text-health-green-dark">
                        <Icon className="h-5 w-5" />
                      </div>
                      <h3 className="text-lg font-bold text-slate-900">{link.title}</h3>
                      <p className="mt-2 text-sm leading-7 text-slate-600">{link.description}</p>
                      <div className="mt-4 inline-flex items-center gap-2 text-sm font-semibold text-health-green-dark">
                        <span>{lang === 'en' ? 'Open next step' : 'افتح الخطوة التالية'}</span>
                        <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5 rtl:group-hover:-translate-x-0.5 rtl:-scale-x-100" />
                      </div>
                    </Link>
                  );
                })}
              </div>
            </section>
          ) : null}

          {relatedArticles.length > 0 ? (
            <section className="mt-10 rounded-[2rem] border border-slate-200 bg-slate-50 p-6 sm:p-8">
              <div className="mb-5">
                <h2 className="text-2xl font-black text-slate-900">
                  {lang === 'en' ? 'Keep reading' : 'استمر في القراءة'}
                </h2>
                <p className="mt-2 text-sm leading-7 text-slate-600">
                  {lang === 'en'
                    ? 'Continue with nearby topics to connect the article with practical tools and performance context.'
                    : 'كمّل القراءة في موضوعات قريبة حتى تربط الفكرة بالأدوات العملية والسياق التدريبي.'}
                </p>
              </div>

              <div className="grid gap-4">
                {relatedArticles.map((entry) => (
                  <Link
                    key={entry.slug}
                    to={`/${lang}/insights/${entry.slug}`}
                    className="rounded-3xl border border-slate-200 bg-white p-5 transition-all hover:border-health-green/30 hover:shadow-sm"
                  >
                    <div className="mb-2 text-sm text-slate-400">
                      {entry.category} • {entry.date}
                    </div>
                    <h3 className="mb-2 text-xl font-bold text-slate-900">{entry.title}</h3>
                    <p className="text-slate-600">{entry.excerpt}</p>
                  </Link>
                ))}
              </div>
            </section>
          ) : null}
        </article>
      </PageLayout>
    </>
  );
}
