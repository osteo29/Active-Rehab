import PageLayout from './PageLayout';
import usePreferredLang from './usePreferredLang';
import Seo from '../components/seo/Seo';
import {buildHreflangs, navigationPaths} from '../utils/langUrlHelper';
import musclesData from '../../json/muscles_library.json';

type MuscleImageEntry = {
  name?: string;
  name_ar?: string;
  image_url?: string;
  image_author?: string;
  image_license?: string;
  image_license_url?: string;
  image_source?: string;
};

export default function AttributionPage() {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';

  const muscles = (Object.values((musclesData as any).muscles) as MuscleImageEntry[])
    .filter((m) => m.image_source)
    .sort((a, b) => (a.name || '').localeCompare(b.name || ''));

  const relatedLinks = [
    {
      label: isAr ? 'مكتبة العضلات' : 'Muscle library',
      href: navigationPaths.anatomy(lang),
      description: isAr ? 'تصفح الرسوم التشريحية في مكانها الطبيعي.' : 'Browse the anatomical illustrations in context.',
    },
    {
      label: isAr ? 'إخلاء المسؤولية الطبي' : 'Medical disclaimer',
      href: navigationPaths.disclaimer(lang),
      description: isAr ? 'راجع إخلاء المسؤولية الخاص بالمحتوى.' : 'Review the content disclaimer.',
    },
  ];

  return (
    <>
      <Seo
        title={isAr ? 'الحقوق والنسب' : 'Attribution & Media Credits'}
        description={
          isAr
            ? 'مصادر وتراخيص الصور التشريحية والوسائط المستخدمة في Active Rehab.'
            : 'Sources and licenses for the anatomical images and media used in Active Rehab.'
        }
        canonicalPath="/attribution"
        hreflangs={buildHreflangs('/attribution')}
      />
      <PageLayout title={isAr ? 'الحقوق والنسب' : 'Attribution & Media Credits'} relatedLinks={relatedLinks}>
        <div className="space-y-10 text-slate-700 dark:text-slate-200">
          <section>
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'الرسوم التشريحية للعضلات' : 'Muscle anatomy illustrations'}
            </h2>
            <p className="mt-2 text-sm leading-6">
              {isAr
                ? 'جميع الرسوم التشريحية من ويكيميديا كومنز وهي إما في الملك العام أو مرخصة برخص المشاع الإبداعي المذكورة بجانب كل صورة. تُعرض الصور دون تعديل مع ذكر المؤلف والرخصة ورابط المصدر.'
                : 'All anatomical illustrations come from Wikimedia Commons and are either public domain or used under the Creative Commons license listed next to each image. Images are shown unmodified with author, license, and source link.'}
            </p>
            <ul className="mt-4 divide-y divide-slate-200 dark:divide-slate-700">
              {muscles.map((m) => (
                <li key={m.image_source} className="flex flex-wrap items-baseline gap-x-3 gap-y-1 py-2 text-sm">
                  <span className="font-semibold text-slate-900 dark:text-white">
                    {isAr ? m.name_ar || m.name : m.name}
                  </span>
                  <span className="text-slate-500 dark:text-slate-400">{m.image_author}</span>
                  {m.image_license_url ? (
                    <a href={m.image_license_url} target="_blank" rel="noreferrer" className="underline">
                      {m.image_license}
                    </a>
                  ) : (
                    <span>{m.image_license}</span>
                  )}
                  <a href={m.image_source} target="_blank" rel="noreferrer" className="underline text-slate-500 dark:text-slate-400">
                    {isAr ? 'المصدر' : 'Source'}
                  </a>
                </li>
              ))}
            </ul>
          </section>

          <section>
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'مصغرات التمارين' : 'Exercise thumbnails'}
            </h2>
            <p className="mt-2 text-sm leading-6">
              {isAr
                ? 'أيقونات المصغرات رسوم خطية أصلية أُنشئت خصيصًا لهذا المشروع ولا تتضمن محتوى طرف ثالث.'
                : 'The exercise thumbnail icons are original line drawings created for this project and contain no third-party content.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'فيديوهات التمارين' : 'Exercise videos'}
            </h2>
            <p className="mt-2 text-sm leading-6">
              {isAr
                ? 'فيديوهات التمارين تُعرض عبر مشغل يوتيوب الرسمي وتبقى مستضافة ومملوكة لناشريها الأصليين على يوتيوب؛ لا يقوم الموقع بتنزيلها أو إعادة توزيعها، ويظهر رابط يوتيوب الأصلي بجانب كل فيديو.'
                : 'Exercise videos play through the official YouTube player and remain hosted and owned by their original publishers on YouTube; the site does not download or redistribute them, and the original YouTube link is shown with each video.'}
            </p>
          </section>

          <section>
            <h2 className="text-xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'الشعار والهوية' : 'Logo and brand assets'}
            </h2>
            <p className="mt-2 text-sm leading-6">
              {isAr
                ? 'الشعار وصور الهوية البصرية مملوكة لـ Active Rehab.'
                : 'The logo and brand imagery are owned by Active Rehab.'}
            </p>
          </section>
        </div>
      </PageLayout>
    </>
  );
}
