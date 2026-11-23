import {useEffect, useMemo, useState} from 'react';
import {motion} from 'motion/react';
import {AlertOctagon, AlertTriangle, CheckCircle2, Pill, Search} from 'lucide-react';
import {askGeminiText, trackAiQuestion} from '../../ai/gemini';
import {findCommonDrugInteraction} from '../../services/commonDrugInteractions';

type ResultCard = {
  status: 'Danger' | 'Caution' | 'Safe' | 'Unclear';
  summary: string;
  interactions: string[];
  practicalAdvice: string[];
  source?: 'database' | 'ai';
  title?: string;
};

function safeParseJson(text: string): ResultCard | null {
  const trimmed = text.trim();
  const start = trimmed.indexOf('{');
  const end = trimmed.lastIndexOf('}');
  if (start === -1 || end === -1 || end <= start) return null;

  try {
    const parsed = JSON.parse(trimmed.slice(start, end + 1));
    return {
      status: parsed.status || 'Unclear',
      summary: parsed.summary || '',
      interactions: Array.isArray(parsed.interactions) ? parsed.interactions : [],
      practicalAdvice: Array.isArray(parsed.practicalAdvice) ? parsed.practicalAdvice : [],
      source: 'ai',
    };
  } catch {
    return null;
  }
}

const EXAMPLES = {
  en: ['Warfarin and vitamin K', 'Metformin and vitamin B12', 'Grapefruit with statins'],
  ar: ['وارفارين وفيتامين K', 'الميتفورمين وفيتامين B12', 'الجريب فروت مع الستاتين'],
} as const;

export default function DrugNutrientChecker({
  lang,
  embedded = false,
  initialQuery = '',
}: {
  lang: 'en' | 'ar';
  embedded?: boolean;
  initialQuery?: string;
}) {
  const [query, setQuery] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [result, setResult] = useState<ResultCard | null>(null);
  const [error, setError] = useState<string | null>(null);
  const isAr = lang === 'ar';

  useEffect(() => {
    if (!initialQuery.trim()) return;
    setQuery(initialQuery);
    setResult(null);
    setError(null);
  }, [initialQuery]);

  const canSearch = useMemo(() => query.trim().length >= 3 && !isLoading, [query, isLoading]);

  const run = async () => {
    const q = query.trim();
    if (!q || isLoading) return;

    setIsLoading(true);
    setError(null);
    setResult(null);

    try {
      const matched = findCommonDrugInteraction(q);
      if (matched) {
        setResult({
          status: matched.status,
          title: matched.title[isAr ? 'ar' : 'en'],
          summary: matched.summary[isAr ? 'ar' : 'en'],
          interactions: matched.interactions[isAr ? 'ar' : 'en'],
          practicalAdvice: matched.practicalAdvice[isAr ? 'ar' : 'en'],
          source: 'database',
        });
        return;
      }

      trackAiQuestion(q, {source: 'drug_nutrient_checker'});

      const text = await askGeminiText({
        system:
          'You are a clinical pharmacist and clinical nutritionist. Identify clinically relevant drug-food, drug-supplement, and drug-nutrient interactions. Be cautious, do not diagnose, and recommend consulting a pharmacist or doctor before acting.',
        user: `Medication and food safety check for: ${q}\nReturn STRICT JSON with keys: status ("Danger"|"Caution"|"Safe"|"Unclear"), summary (string), interactions (string[]), practicalAdvice (string[]).`,
        hiddenContext: `Language: ${lang}`,
      });

      const parsed = safeParseJson(text);
      if (!parsed) {
        setResult({
          status: 'Unclear',
          summary: isAr
            ? 'تعذر استخراج نتيجة منظمة. جرّب كتابة اسم الدواء أو المكمل بشكل أوضح.'
            : 'Could not parse a structured answer. Try writing the medication or supplement name more clearly.',
          interactions: [],
          practicalAdvice: [],
          source: 'ai',
        });
      } else {
        setResult(parsed);
      }
    } catch (e: any) {
      setError(e?.message || 'AI error');
    } finally {
      setIsLoading(false);
    }
  };

  const cardTone =
    result?.status === 'Danger'
      ? {bg: 'bg-rose-50', border: 'border-rose-200', text: 'text-rose-800', icon: AlertOctagon}
      : result?.status === 'Caution'
        ? {bg: 'bg-amber-50', border: 'border-amber-200', text: 'text-amber-800', icon: AlertTriangle}
        : result?.status === 'Safe'
          ? {bg: 'bg-emerald-50', border: 'border-emerald-200', text: 'text-emerald-800', icon: CheckCircle2}
          : {bg: 'bg-slate-50', border: 'border-slate-200', text: 'text-slate-700', icon: AlertTriangle};

  const Icon = cardTone.icon;
  const Wrapper = embedded ? 'div' : 'section';

  return (
    <Wrapper id="drug-nutrient-checker" className={embedded ? '' : 'bg-slate-50 py-24'}>
      <div className={embedded ? '' : 'mx-auto max-w-7xl px-4 sm:px-6 lg:px-8'}>
        <div className="mb-8 flex items-end justify-between gap-6">
          <div>
            <div className="mb-3 inline-flex items-center gap-2 rounded-full bg-medical-blue/10 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-medical-blue">
              <Pill className="h-3.5 w-3.5" />
              <span>{isAr ? 'أداة أمان مهمة' : 'High-value safety tool'}</span>
            </div>
            <h2 className="text-3xl font-black text-slate-900 dark:text-white">
              {isAr ? 'فحص أمان الدواء مع الغذاء والمكملات' : 'Medication, food, and supplement safety check'}
            </h2>
            <p className="mt-2 max-w-2xl text-slate-600 dark:text-slate-300">
              {isAr
                ? 'الأداة تبحث أولًا في قاعدة بيانات ثابتة للتداخلات الشائعة، ولو مفيش تطابق واضح تستخدم الذكاء الاصطناعي كمساعد إضافي بحذر.'
                : 'The tool checks a fixed database of common interactions first, then uses AI carefully when there is no clear direct match.'}
            </p>
          </div>
        </div>

        <div className="rounded-3xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 shadow-sm md:p-8">
          <div className="mb-6 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-4 text-sm leading-7 text-slate-700 dark:text-slate-200">
            <strong className="block text-slate-900 dark:text-white">
              {isAr ? 'مهم للمستخدم العادي أيضًا' : 'Important for everyday users too'}
            </strong>
            <span>
              {isAr
                ? 'لو عندك مرض مزمن، أو بتاخد دواء ثابت، أو ناوي تبدأ مكمل جديد، افحص هنا الأول هل فيه غذاء أو مكمل قد لا يكون مناسبًا مع حالتك أو مع الدواء.'
                : 'If you have a chronic condition, take regular medication, or plan to start a new supplement, check here first to see whether any food or supplement may not fit your condition or medication.'}
            </span>
          </div>

          <div className="mb-5 flex flex-wrap gap-2">
            {EXAMPLES[isAr ? 'ar' : 'en'].map((example) => (
              <button
                key={example}
                type="button"
                onClick={() => setQuery(example)}
                className="rounded-full border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 px-3 py-2 text-xs font-bold text-slate-600 dark:text-slate-300 hover:border-medical-blue hover:text-medical-blue"
              >
                {example}
              </button>
            ))}
          </div>

          <div className="flex flex-col gap-4 sm:flex-row">
            <div className="relative flex-1">
              <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400 rtl:left-auto rtl:right-4" />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder={
                  isAr
                    ? 'مثال: وارفارين وفيتامين K أو الميتفورمين وفيتامين B12'
                    : 'Example: Warfarin and vitamin K, or metformin and B12'
                }
                className="w-full rounded-2xl border border-slate-200 dark:border-slate-700 py-4 pl-12 pr-4 outline-none focus:ring-2 focus:ring-medical-blue/30 rtl:pl-4 rtl:pr-12"
              />
            </div>
            <button
              onClick={run}
              disabled={!canSearch}
              className={`rounded-2xl px-6 py-4 font-black transition-all ${
                canSearch ? 'bg-medical-blue text-white hover:bg-medical-blue/90' : 'bg-slate-100 text-slate-400'
              }`}
            >
              {isLoading ? (isAr ? 'جار الفحص...' : 'Checking...') : isAr ? 'افحص الآن' : 'Run check'}
            </button>
          </div>

          <div className="mt-4 text-[11px] text-slate-500">
            {isAr
              ? 'هذه الأداة للتوعية السريعة فقط، وليست بديلًا عن مراجعة الصيدلي أو الطبيب.'
              : 'This tool is for quick educational screening only and does not replace a pharmacist or physician review.'}
          </div>

          {error ? <div className="mt-6 text-sm font-semibold text-rose-600">{error}</div> : null}

          {isLoading ? (
            <div className="mt-8 animate-pulse">
              <div className="mb-4 h-5 w-48 rounded bg-slate-200" />
              <div className="mb-2 h-4 w-full rounded bg-slate-200" />
              <div className="mb-2 h-4 w-5/6 rounded bg-slate-200" />
              <div className="h-4 w-2/3 rounded bg-slate-200" />
            </div>
          ) : null}

          {result ? (
            <motion.div
              initial={{opacity: 0, y: 10, scale: 0.98}}
              animate={{opacity: 1, y: 0, scale: 1}}
              transition={{type: 'spring', stiffness: 240, damping: 22}}
              className={`mt-8 rounded-3xl border ${cardTone.border} ${cardTone.bg} p-6`}
            >
              <div className={`flex items-start gap-3 ${cardTone.text}`}>
                <Icon className="mt-0.5 h-6 w-6 shrink-0" />
                <div className="flex-1">
                  {result.title ? <div className="mb-1 text-base font-black text-slate-900 dark:text-white">{result.title}</div> : null}
                  <div className="text-sm font-black uppercase tracking-widest">
                    {result.status === 'Danger'
                      ? isAr
                        ? 'خطر'
                        : 'Danger'
                      : result.status === 'Caution'
                        ? isAr
                          ? 'تحذير'
                          : 'Caution'
                        : result.status === 'Safe'
                          ? isAr
                            ? 'آمن'
                            : 'Safe'
                          : isAr
                            ? 'غير واضح'
                            : 'Unclear'}
                  </div>
                  <div className="mt-2 inline-flex rounded-full bg-white/70 dark:bg-slate-900/70 px-3 py-1 text-[11px] font-bold uppercase tracking-[0.16em] text-slate-500">
                    {result.source === 'database'
                      ? isAr
                        ? 'قاعدة بيانات ثابتة'
                        : 'Verified database'
                      : isAr
                        ? 'مساعدة بالذكاء الاصطناعي'
                        : 'AI-assisted'}
                  </div>
                  <div className="mt-2 text-sm text-slate-800 dark:text-slate-100">{result.summary}</div>
                </div>
              </div>

              {result.interactions.length > 0 ? (
                <div className="mt-5">
                  <div className="mb-2 text-xs font-black uppercase tracking-widest text-slate-500">
                    {isAr ? 'التداخلات المحتملة' : 'Potential interactions'}
                  </div>
                  <ul className="list-disc space-y-1 pl-5 text-sm text-slate-700 dark:text-slate-200">
                    {result.interactions.map((item, index) => (
                      <li key={index}>{item}</li>
                    ))}
                  </ul>
                </div>
              ) : null}

              {result.practicalAdvice.length > 0 ? (
                <div className="mt-5">
                  <div className="mb-2 text-xs font-black uppercase tracking-widest text-slate-500">
                    {isAr ? 'نصائح عملية' : 'Practical advice'}
                  </div>
                  <ul className="list-disc space-y-1 pl-5 text-sm text-slate-700 dark:text-slate-200">
                    {result.practicalAdvice.map((item, index) => (
                      <li key={index}>{item}</li>
                    ))}
                  </ul>
                </div>
              ) : null}
            </motion.div>
          ) : null}
        </div>
      </div>
    </Wrapper>
  );
}
