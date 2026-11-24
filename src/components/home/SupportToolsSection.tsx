import {Pill, Plus, Search, Sparkles} from 'lucide-react';
import {Link} from 'react-router-dom';
import type {FoodItem} from '../../services/foodData';
import {navigationPaths} from '../../utils/langUrlHelper';
import DrugNutrientChecker from '../ai/DrugNutrientChecker';

type Props = {
  lang: 'en' | 'ar';
  t: any;
  foodCategory: string;
  setFoodCategory: (category: string) => void;
  showFoodTable: boolean;
  setShowFoodTable: (value: boolean) => void;
  foodSearch: string;
  setFoodSearch: (value: string) => void;
  filteredFoods: FoodItem[];
  addFoodToMeal: (food: FoodItem) => void;
  setIsCustomModalOpen: (value: boolean) => void;
};

const categories = ['all', 'protein', 'fruit', 'grain', 'cooked', 'dairy', 'vegetable', 'fat'] as const;

export default function SupportToolsSection({
  lang,
  t,
  foodCategory,
  setFoodCategory,
  showFoodTable,
  setShowFoodTable,
  foodSearch,
  setFoodSearch,
  filteredFoods,
  addFoodToMeal,
  setIsCustomModalOpen,
}: Props) {
  const isAr = lang === 'ar';

  return (
    <section id="nutrition-tools" className="section-surface home-band bg-white py-24">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-12 flex flex-col gap-6">
          <div className="inline-flex w-fit items-center gap-2 rounded-full bg-health-green/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-health-green">
            <Sparkles className="h-3.5 w-3.5" />
            <span>{isAr ? 'أدوات عملية إضافية' : 'Practical support tools'}</span>
          </div>
          <div className="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <h2 className="mb-3 text-3xl font-bold text-slate-900 sm:text-4xl">
                {isAr ? 'الأغذية والدواء في مكان أوضح وأسهل' : 'Food guidance and medication safety in one clear place'}
              </h2>
              <p className="max-w-3xl text-slate-600">
                {isAr
                  ? 'القسم ده يجمع مكتبة الأغذية، فحص أمان الدواء والمكملات، وبروتوكولات الإصابات في مكان واحد، بحيث المستخدم يعرف بسرعة كل أداة بتعمل إيه ومتى يحتاجها.'
                  : 'This area brings together the food library, medication and supplement safety checks, and injury protocols so users can quickly understand what each tool does and when to use it.'}
              </p>
            </div>
          </div>
        </div>

        <div className="mb-10 grid gap-5 lg:grid-cols-2">
          <div className="panel-soft rounded-[2rem] p-6 transition-[box-shadow,border-color] duration-200 hover:shadow-lg">
            <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-white text-health-green shadow-sm">
              <Search className="h-5 w-5" />
            </div>
            <h3 className="mb-2 text-xl font-bold text-slate-900">
              {isAr ? 'مكتبة الأغذية والماكروز' : 'Food and macro library'}
            </h3>
            <p className="mb-5 text-sm leading-7 text-slate-600">
              {isAr
                ? 'ابحث عن الطعام بسرعة، راجع السعرات والماكروز، وأضفه مباشرة إلى حاسبة الوجبة بدل التخمين.'
                : 'Search foods quickly, review calories and macros, and push them straight into the meal calculator instead of guessing.'}
            </p>
            <a
              href="#food-db"
              className="inline-flex items-center gap-2 rounded-2xl bg-health-green px-4 py-3 text-sm font-bold text-white"
            >
              {isAr ? 'افتح مكتبة الأغذية' : 'Open food library'}
            </a>
          </div>

          <div className="panel-soft rounded-[2rem] p-6 transition-[box-shadow,border-color] duration-200 hover:shadow-lg">
            <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-white text-medical-blue shadow-sm">
              <Pill className="h-5 w-5" />
            </div>
            <h3 className="mb-2 text-xl font-bold text-slate-900">
              {isAr ? 'فحص أمان الدواء مع الغذاء والمكملات' : 'Medication, food, and supplement safety check'}
            </h3>
            <p className="mb-5 text-sm leading-7 text-slate-600">
              {isAr
                ? 'أداة مهمة قبل اقتراح مكمل أو تعديل الروتين الغذائي، خصوصًا لو المستخدم عنده دواء ثابت أو حالة مزمنة.'
                : 'A high-value check before suggesting supplements or changing a routine, especially when a user takes regular medication or has chronic disease.'}
            </p>
            <div className="mb-5 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm leading-7 text-slate-700">
              {isAr
                ? 'لو عندك مرض مزمن أو بتاخد دواء بشكل يومي، استخدم الأداة دي قبل ما تغيّر أكلك أو تبدأ أي مكمل.'
                : 'If you live with a chronic condition or take daily medication, use this tool before changing your diet or starting any supplement.'}
            </div>
            <a
              href="#drug-nutrient-checker"
              className="inline-flex items-center gap-2 rounded-2xl border border-medical-blue px-4 py-3 text-sm font-bold text-medical-blue"
            >
              {isAr ? 'افتح فحص الأمان' : 'Open safety check'}
            </a>
          </div>
        </div>

        <div className="panel-soft mb-10 rounded-[2rem] p-6 transition-[box-shadow,border-color] duration-200 hover:shadow-lg">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div>
              <h3 className="text-xl font-bold text-slate-900">
                {isAr ? 'دليل التمارين حسب العضلة' : 'Exercise finder by muscle'}
              </h3>
              <p className="mt-2 max-w-3xl text-sm leading-7 text-slate-600">
                {isAr
                  ? 'ابحث عن التمارين حسب العضلة الرئيسية أو العضلات الفرعية، ثم فلتر بالمستوى والمعدات ونوع التمرين. الصفحة مناسبة للجيم وتبقى منفصلة عن بروتوكولات الإصابات.'
                  : 'Browse exercises by main muscle or sub-muscle, then refine by level, equipment, and training goal. This page stays gym-focused and separate from injury protocol content.'}
              </p>
            </div>
            <Link
              to={navigationPaths.exercises(lang)}
              className="inline-flex items-center justify-center rounded-2xl bg-white px-5 py-3 text-sm font-bold text-health-green shadow-sm"
            >
              {isAr ? 'افتح دليل التمارين' : 'Open exercise finder'}
            </Link>
          </div>
        </div>

        <div className="panel-soft mb-10 rounded-[2rem] p-6">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div>
              <h3 className="text-xl font-bold text-slate-900">
                {isAr ? 'بروتوكولات الإصابات والتغذية العلاجية' : 'Injury recovery nutrition protocols'}
              </h3>
              <p className="mt-2 max-w-3xl text-sm leading-7 text-slate-600">
                {isAr
                  ? 'لو عندك إصابة شائعة أو بتجهز محتوى علاجي، افتح صفحة البروتوكولات لترى مراحل التعافي، العناصر الغذائية المهمة، الأطعمة المقترحة، والتنبيهات المرتبطة بكل إصابة.'
                  : 'Open the protocol library for recovery stages, key nutrients, suggested foods, and cautions linked to common injuries.'}
              </p>
            </div>
            <Link
              to={navigationPaths.injuries(lang)}
              className="inline-flex items-center justify-center rounded-2xl bg-white px-5 py-3 text-sm font-bold text-health-green shadow-sm"
            >
              {isAr ? 'افتح بروتوكولات الإصابات' : 'Open injury protocols'}
            </Link>
          </div>
        </div>

        <div id="food-db" className="panel-soft rounded-[2.25rem] p-6 sm:p-8">
          <div className="mb-8 flex flex-col gap-6">
            <div className="flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between">
              <div>
                <div className="mb-2 text-[11px] font-bold uppercase tracking-[0.18em] text-slate-400">
                  {isAr ? 'مكتبة عملية' : 'Practical library'}
                </div>
                <h3 className="text-2xl font-bold text-slate-900">{t.foodDb.title}</h3>
                <p className="mt-2 max-w-3xl text-sm leading-7 text-slate-600">
                  {isAr
                    ? 'استخدمها لبناء وجبة بشكل أسرع أو لفهم محتوى الطعام قبل إضافته إلى حاسبة الوجبة.'
                    : 'Use it to build meals faster or to understand food composition before adding it to the meal calculator.'}
                </p>
              </div>

              <div className="flex flex-col gap-3 sm:flex-row">
                <button
                  type="button"
                  onClick={() => setShowFoodTable(!showFoodTable)}
                  className={`rounded-2xl border-2 px-6 py-3 text-sm font-bold transition-all ${
                    showFoodTable
                      ? 'border-medical-blue bg-medical-blue text-white shadow-lg shadow-medical-blue/20'
                      : 'border-medical-blue text-medical-blue hover:bg-medical-blue/5'
                  }`}
                >
                  {showFoodTable
                    ? isAr
                      ? 'إخفاء المكتبة'
                      : 'Hide library'
                    : isAr
                      ? 'عرض المكتبة'
                      : 'Show library'}
                </button>
                <button
                  type="button"
                  onClick={() => setIsCustomModalOpen(true)}
                  className="flex items-center justify-center gap-2 rounded-2xl bg-white px-6 py-3 text-sm font-bold text-health-green shadow-sm"
                >
                  <Plus className="h-4 w-4" />
                  {isAr ? 'أضف طعامك بنفسك' : 'Add your own food'}
                </button>
              </div>
            </div>

            <div className="flex flex-col gap-4">
              <div className="flex flex-wrap items-center gap-2">
                {categories.map((cat) => (
                  <button
                    key={cat}
                    onClick={() => setFoodCategory(cat)}
                    className={`rounded-full px-4 py-2 text-sm font-bold transition-all ${
                      foodCategory === cat
                        ? 'bg-health-green text-white shadow-lg shadow-health-green/20'
                        : 'bg-white text-slate-600 hover:bg-slate-100'
                    }`}
                  >
                    {cat === 'all'
                      ? t.foodDb.categoryAll
                      : cat === 'protein'
                        ? t.foodDb.categoryProtein
                        : cat === 'fruit'
                          ? t.foodDb.categoryFruit
                          : cat === 'grain'
                            ? t.foodDb.categoryGrain
                            : cat === 'cooked'
                              ? t.foodDb.categoryCooked
                              : cat === 'dairy'
                                ? t.foodDb.categoryDairy
                                : cat === 'vegetable'
                                  ? t.foodDb.categoryVegetable
                                  : t.foodDb.categoryFat}
                  </button>
                ))}
              </div>

              <div className="relative w-full max-w-xl">
                <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400 rtl:left-auto rtl:right-4" />
                <input
                  type="text"
                  aria-label={t.foodDb.searchPlaceholder}
                  placeholder={t.foodDb.searchPlaceholder}
                  value={foodSearch}
                  onChange={(event) => {
                    setFoodSearch(event.target.value);
                    if (event.target.value.length > 0) setShowFoodTable(true);
                  }}
                  className="w-full rounded-2xl border border-slate-200 py-4 pl-12 pr-4 outline-none focus:ring-2 focus:ring-health-green rtl:pl-4 rtl:pr-12"
                />
              </div>
            </div>
          </div>

          {showFoodTable ? (
            <div className="rounded-3xl border border-slate-200 bg-white shadow-sm">
              <div className="flex items-center justify-between border-b border-slate-100 px-6 py-4">
                <div>
                  <div className="font-bold text-slate-900">
                    {isAr ? 'نتائج مكتبة الأغذية' : 'Food library results'}
                  </div>
                  <div className="text-xs text-slate-500">
                    {isAr
                      ? `${filteredFoods.length} عنصرًا متاحًا الآن`
                      : `${filteredFoods.length} items currently available`}
                  </div>
                </div>
              </div>
              <div className="-mx-4 overflow-x-auto px-4 sm:mx-0 sm:px-0">
                <table className="w-full min-w-[720px] text-left rtl:text-right">
                  <thead className="border-b border-slate-200 bg-slate-50">
                    <tr>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900">{t.foodDb.colName}</th>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900">{t.foodDb.colCals}</th>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900">{t.foodDb.colProtein}</th>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900">{t.foodDb.colCarbs}</th>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900">{t.foodDb.colFats}</th>
                      <th className="px-6 py-4 text-sm font-bold text-slate-900"></th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {filteredFoods.map((food) => (
                      <tr key={food.id} className="transition-colors hover:bg-slate-50">
                        <td className="px-6 py-4">
                          <div className="font-bold text-slate-900">{food.name[lang]}</div>
                          <div className="text-xs capitalize text-slate-400">{food.category}</div>
                        </td>
                        <td className="px-6 py-4 font-medium text-slate-600">{food.calories}</td>
                        <td className="px-6 py-4 font-bold text-health-green">{food.protein}g</td>
                        <td className="px-6 py-4 font-bold text-medical-blue">{food.carbs}g</td>
                        <td className="px-6 py-4 font-bold text-orange-500">{food.fats}g</td>
                        <td className="px-6 py-4 text-right rtl:text-left">
                          <button
                            onClick={() => addFoodToMeal(food)}
                            className="flex items-center gap-2 rounded-xl bg-soft-blue p-2 text-xs font-bold text-health-green transition-all hover:bg-health-green hover:text-white"
                          >
                            <Plus className="h-4 w-4" />
                            {t.foodDb.addAction}
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ) : (
            <div className="rounded-3xl border border-dashed border-slate-200 bg-white px-6 py-10 text-center text-slate-500">
              {isAr
                ? 'افتح المكتبة أو ابدأ بالبحث لتظهر نتائج الأطعمة هنا.'
                : 'Open the library or start searching to display foods here.'}
            </div>
          )}
        </div>

        <div className="mt-10">
          <DrugNutrientChecker lang={lang} embedded />
        </div>
      </div>
    </section>
  );
}
