import NotFound from './NotFound';
import {Link, useParams} from 'react-router-dom';
import ManagedSeo from '../components/seo/ManagedSeo';
import {dietRegimensCatalog} from '../services/dietRegimensCatalog';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';
import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';

export default function DietDetailPage() {
  const {slug = ''} = useParams();
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const diet = dietRegimensCatalog.find((entry) => entry.id === slug);

  if (!diet) {
    return <NotFound />;
  }

  const title = isAr ? diet.title.ar : diet.title.en;
  const description = isAr ? diet.summary.ar : diet.summary.en;
  const canonicalPath = `/diets/${diet.id}`;

  return (
    <>
      <ManagedSeo
        pageKey="diet_detail"
        lang={lang}
        canonicalPath={canonicalPath}
        hreflangs={buildHreflangs(canonicalPath)}
        templateValues={{
          dietName: title,
          dietSummary: description,
        }}
      />
      <PageLayout title={title}>
        <div className="space-y-6">
          <nav className="text-sm text-slate-500">
            <Link to={navigationPaths.diets(lang)} className="font-semibold text-health-green hover:underline">
              {isAr ? 'الدايت والريجيم' : 'Diet & Regimens'}
            </Link>{' '}
            <span aria-hidden="true">›</span> <span>{title}</span>
          </nav>

          <div className="rounded-[2rem] border border-slate-200 bg-white p-6">
            <p className="text-sm leading-7 text-slate-700">{description}</p>
          </div>

          <div className="grid gap-4 md:grid-cols-2">
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 className="mb-2 text-sm font-bold text-slate-900">{isAr ? 'الأهداف' : 'Goals'}</h2>
              <ul className="space-y-2 text-sm text-slate-700">
                {(isAr ? diet.goals.ar : diet.goals.en).map((item) => (
                  <li key={item} className="rounded-xl bg-white px-3 py-2">
                    {item}
                  </li>
                ))}
              </ul>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 className="mb-2 text-sm font-bold text-slate-900">
                {isAr ? 'المبادئ الأساسية' : 'Key principles'}
              </h2>
              <ul className="space-y-2 text-sm text-slate-700">
                {(isAr ? diet.keyPrinciples.ar : diet.keyPrinciples.en).map((item) => (
                  <li key={item} className="rounded-xl bg-white px-3 py-2">
                    {item}
                  </li>
                ))}
              </ul>
            </div>
          </div>

          <div className="grid gap-4 md:grid-cols-2">
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 className="mb-2 text-sm font-bold text-slate-900">{isAr ? 'طريقة تطبيق عملية' : 'Practical guide'}</h2>
              <ul className="space-y-2 text-sm text-slate-700">
                {(isAr ? diet.practicalGuide.ar : diet.practicalGuide.en).map((item) => (
                  <li key={item} className="rounded-xl bg-white px-3 py-2">
                    {item}
                  </li>
                ))}
              </ul>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 className="mb-2 text-sm font-bold text-slate-900">{isAr ? 'مثال يومي' : 'Example day'}</h2>
              <ul className="space-y-2 text-sm text-slate-700">
                <li className="rounded-xl bg-white px-3 py-2">
                  <span className="font-bold">{isAr ? 'الفطور' : 'Breakfast'}:</span>{' '}
                  {isAr ? diet.exampleDay.breakfast.ar : diet.exampleDay.breakfast.en}
                </li>
                <li className="rounded-xl bg-white px-3 py-2">
                  <span className="font-bold">{isAr ? 'الغداء' : 'Lunch'}:</span>{' '}
                  {isAr ? diet.exampleDay.lunch.ar : diet.exampleDay.lunch.en}
                </li>
                <li className="rounded-xl bg-white px-3 py-2">
                  <span className="font-bold">{isAr ? 'العشاء' : 'Dinner'}:</span>{' '}
                  {isAr ? diet.exampleDay.dinner.ar : diet.exampleDay.dinner.en}
                </li>
                {diet.exampleDay.snack ? (
                  <li className="rounded-xl bg-white px-3 py-2">
                    <span className="font-bold">{isAr ? 'سناك' : 'Snack'}:</span>{' '}
                    {isAr ? diet.exampleDay.snack.ar : diet.exampleDay.snack.en}
                  </li>
                ) : null}
              </ul>
            </div>
          </div>

          <div className="rounded-2xl border border-rose-200 bg-rose-50 p-4">
            <h2 className="mb-2 text-sm font-bold text-rose-800">{isAr ? 'ملاحظات وتحذيرات' : 'Cautions'}</h2>
            <ul className="space-y-2 text-sm text-rose-900/80">
              {(isAr ? diet.cautions.ar : diet.cautions.en).map((item) => (
                <li key={item} className="rounded-xl bg-white px-3 py-2">
                  {item}
                </li>
              ))}
            </ul>
          </div>
        </div>
      </PageLayout>
    </>
  );
}
