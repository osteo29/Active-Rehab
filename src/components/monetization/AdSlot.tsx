import {useEffect, useMemo, useState} from 'react';
import {Megaphone} from 'lucide-react';
import {getStoredConsent} from './ConsentBanner';

declare global {
  interface Window {
    adsbygoogle?: unknown[];
  }
}

export default function AdSlot({
  slot,
  label,
  lang,
  format = 'auto',
}: {
  slot?: string;
  label: string;
  lang: 'en' | 'ar';
  format?: 'auto' | 'rectangle' | 'horizontal';
}) {
  const [consent, setConsent] = useState<'accepted' | 'rejected' | null>(null);
  const client = import.meta.env.VITE_ADSENSE_CLIENT_ID;

  useEffect(() => {
    const syncConsent = () => setConsent(getStoredConsent());
    syncConsent();
    window.addEventListener('physiohub-consent-change', syncConsent);
    return () => window.removeEventListener('physiohub-consent-change', syncConsent);
  }, []);

  const canRenderAds = Boolean(client && slot && consent === 'accepted');

  useEffect(() => {
    if (!canRenderAds) return;
    try {
      window.adsbygoogle = window.adsbygoogle || [];
      window.adsbygoogle.push({});
    } catch {
      // keep silent and leave fallback message visible until AdSense is configured
    }
  }, [canRenderAds]);

  const formatClass = useMemo(() => {
    if (format === 'horizontal') return 'min-h-[120px]';
    if (format === 'rectangle') return 'min-h-[280px]';
    return 'min-h-[160px]';
  }, [format]);

  return (
    <div className={`rounded-[2rem] border border-dashed border-slate-300 bg-slate-50 p-5 ${formatClass}`}>
      <div className="mb-3 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.18em] text-slate-600 dark:text-slate-300">
        <Megaphone className="w-3.5 h-3.5" />
        <span>{label}</span>
      </div>

      {canRenderAds ? (
        <ins
          className="adsbygoogle block w-full"
          style={{display: 'block'}}
          data-ad-client={client}
          data-ad-slot={slot}
          data-ad-format={format === 'auto' ? 'auto' : undefined}
          data-full-width-responsive={format === 'auto' ? 'true' : undefined}
        />
      ) : (
        <div className="h-full flex items-center justify-center rounded-[1.5rem] border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center px-6">
          <p className="max-w-xl text-sm leading-6 text-slate-700 dark:text-slate-200">
            {consent === 'rejected'
              ? lang === 'en'
                ? 'Ads are hidden because non-essential consent was rejected.'
                : 'الإعلانات مخفية لأن الموافقة على العناصر غير الضرورية تم رفضها.'
              : lang === 'en'
                ? 'Ad space is prepared and will activate after adding your AdSense client/slot and getting user consent.'
                : 'مكان الإعلان جاهز وسيتفعّل بعد إضافة بيانات AdSense والحصول على موافقة المستخدم.'}
          </p>
        </div>
      )}
    </div>
  );
}
