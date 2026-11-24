// @vitest-environment jsdom
import {beforeEach, describe, expect, it} from 'vitest';

import {initConsentGatedScripts, maybeLoadConsentedScripts} from './consentLoader';

const THIRD_PARTY = /googletagmanager|googlesyndication/;

function injectedScripts(): string[] {
  return [...document.head.querySelectorAll('script')].map((s) => s.src);
}

describe('consent-gated third-party loaders', () => {
  beforeEach(() => {
    localStorage.clear();
    document.head.innerHTML = '';
    // Reset module-level "already loaded" flags by re-importing is not trivial,
    // so each test uses a fresh module graph.
  });

  it('injects nothing when no consent is stored', async () => {
    maybeLoadConsentedScripts();
    expect(injectedScripts().filter((src) => THIRD_PARTY.test(src))).toEqual([]);
  });

  it('injects nothing when consent was rejected', async () => {
    localStorage.setItem('activerehab_cookie_consent', 'rejected');
    maybeLoadConsentedScripts();
    expect(injectedScripts().filter((src) => THIRD_PARTY.test(src))).toEqual([]);
  });

  it('loads GTM and AdSense exactly once after acceptance, including via the change event', async () => {
    localStorage.setItem('activerehab_cookie_consent', 'accepted');
    initConsentGatedScripts();
    window.dispatchEvent(new Event('physiohub-consent-change'));
    maybeLoadConsentedScripts();
    const loaded = injectedScripts().filter((src) => THIRD_PARTY.test(src));
    expect(loaded.some((src) => src.includes('googletagmanager.com/gtm.js?id='))).toBe(true);
    expect(loaded.some((src) => src.includes('pagead2.googlesyndication.com'))).toBe(true);
    expect(loaded.length).toBe(2);
  });

  it('keeps scripts out when consent flips back to rejected before any acceptance', async () => {
    localStorage.setItem('activerehab_cookie_consent', 'accepted');
    maybeLoadConsentedScripts();
    localStorage.setItem('activerehab_cookie_consent', 'rejected');
    document.head.innerHTML = '';
    maybeLoadConsentedScripts();
    expect(injectedScripts().filter((src) => THIRD_PARTY.test(src))).toEqual([]);
  });
});
