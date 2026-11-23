/**
 * Consent-gated third-party loader.
 *
 * The cookie banner promises that ad and analytics cookies stay off until the
 * visitor approves them. Previously both GTM and the AdSense script were
 * hard-coded in index.html and loaded before any consent. They are now
 * injected only after consent === 'accepted', and re-checked whenever the
 * consent state changes.
 */

import {getStoredConsent} from '../components/monetization/ConsentBanner';

const GTM_ID = 'GTM-TWQHBKR4';
const ADSENSE_CLIENT_ID = 'ca-pub-4879016113761897';

declare global {
  interface Window {
    dataLayer?: unknown[];
    gtag?: (...args: unknown[]) => void;
  }
}

let gtmLoaded = false;
let adsenseLoaded = false;

function loadGtm() {
  if (gtmLoaded || typeof document === 'undefined') return;
  gtmLoaded = true;

  window.dataLayer = window.dataLayer || [];
  window.gtag =
    window.gtag ||
    function gtag(...args: unknown[]) {
      window.dataLayer?.push(args);
    };
  window.gtag('js', new Date());

  const script = document.createElement('script');
  script.async = true;
  script.src = `https://www.googletagmanager.com/gtm.js?id=${GTM_ID}`;
  document.head.appendChild(script);
}

function loadAdsense() {
  if (adsenseLoaded || typeof document === 'undefined') return;
  adsenseLoaded = true;

  const script = document.createElement('script');
  script.async = true;
  script.crossOrigin = 'anonymous';
  script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${ADSENSE_CLIENT_ID}`;
  document.head.appendChild(script);
}

export function maybeLoadConsentedScripts() {
  if (getStoredConsent() !== 'accepted') return;
  loadGtm();
  loadAdsense();
  // Let any mounted AdSlot know the adsbygoogle script is now available.
  window.dispatchEvent(new Event('physiohub-consent-scripts-loaded'));
}

export function initConsentGatedScripts() {
  if (typeof window === 'undefined') return;
  maybeLoadConsentedScripts();
  window.addEventListener('physiohub-consent-change', maybeLoadConsentedScripts);
}
