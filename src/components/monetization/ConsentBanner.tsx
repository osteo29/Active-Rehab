import {useEffect, useState} from 'react';
import {Cookie, ShieldCheck} from 'lucide-react';

type ConsentState = 'accepted' | 'rejected' | null;

export function getStoredConsent(): ConsentState {
  if (typeof window === 'undefined') return null;

  try {
    const saved = window.localStorage.getItem('activerehab_cookie_consent');
    // If they previously accepted, return accepted. If rejected or null, return null to show again.
    return saved === 'accepted' ? 'accepted' : null;
  } catch {
    return null;
  }
}

export default function ConsentBanner({lang}: {lang: 'en' | 'ar'}) {
  const [consent, setConsent] = useState<ConsentState>(() => getStoredConsent());
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const storedConsent = getStoredConsent();
    setConsent(storedConsent);

    if (storedConsent) {
      setIsVisible(false);
      return;
    }

    const timer = window.setTimeout(() => setIsVisible(true), 1200);
    return () => window.clearTimeout(timer);
  }, []);

  if (consent) return null;

  const accept = () => {
    try {
      window.localStorage.setItem('activerehab_cookie_consent', 'accepted');
    } catch {
      // Ignore storage errors
    }
    setConsent('accepted');
    setIsVisible(false);
    window.dispatchEvent(new Event('physiohub-consent-change'));
  };

  const reject = () => {
    // According to user request: "يظهروا تاني لو كان رفضهم بس"
    // We only set it in state for the current session, so it appears again next time.
    try {
      window.localStorage.removeItem('activerehab_cookie_consent');
    } catch {}
    setConsent('rejected');
    setIsVisible(false);
    window.dispatchEvent(new Event('physiohub-consent-change'));
  };

  return (
    <div
      className={`fixed bottom-3 left-3 right-3 z-[90] transition-all duration-300 sm:bottom-4 sm:left-4 sm:right-4 ${
        isVisible ? 'translate-y-0 opacity-100' : 'translate-y-4 opacity-0 pointer-events-none'
      }`}
    >
      <div className="mx-auto max-w-3xl rounded-[1.5rem] border border-slate-200 bg-white/94 p-3 shadow-xl backdrop-blur-xl sm:p-4">
        <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
          <div className="flex items-start gap-3">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-soft-blue text-health-green">
              <Cookie className="h-4 w-4" />
            </div>
            <div>
              <div className="mb-1 text-sm font-bold text-slate-900">
                {lang === 'en' ? 'Cookie preferences' : 'تفضيلات الكوكيز'}
              </div>
              <p className="text-xs leading-5 text-slate-600 sm:text-sm">
                {lang === 'en'
                  ? 'We keep essential preferences on, and use ad or analytics cookies only if you approve.'
                  : 'نحفظ التفضيلات الأساسية فقط، ولا نفعّل ملفات الإعلانات أو التحليلات إلا بعد موافقتك.'}
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2 md:justify-end">
            <div className="inline-flex items-center gap-2 rounded-xl bg-slate-50 px-3 py-2 text-[11px] font-semibold text-slate-600">
              <ShieldCheck className="h-3.5 w-3.5 text-health-green" />
              <span>
                {lang === 'en' ? 'Educational site, privacy-first' : 'موقع تعليمي يحترم الخصوصية'}
              </span>
            </div>
            <button
              onClick={reject}
              className="rounded-xl border border-slate-200 px-3 py-2 text-xs font-bold text-slate-600 transition-all hover:border-slate-300 sm:px-4 sm:text-sm"
            >
              {lang === 'en' ? 'Reject optional' : 'رفض الاختياري'}
            </button>
            <button
              onClick={accept}
              className="rounded-xl bg-health-green px-3 py-2 text-xs font-bold text-white transition-all hover:bg-health-green-dark sm:px-4 sm:text-sm"
            >
              {lang === 'en' ? 'Accept' : 'موافقة'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
