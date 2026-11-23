import type {Language} from './translations';

export const LANGUAGE_STORAGE_KEY = 'activerehab_lang';
export const LANGUAGE_CHANGE_EVENT = 'physiohub-language-change';

export function getPreferredLanguage(): Language {
  try {
    const saved = localStorage.getItem(LANGUAGE_STORAGE_KEY);
    return saved === 'ar' || saved === 'en' ? saved : 'en';
  } catch {
    return 'en';
  }
}

export function setPreferredLanguage(lang: Language) {
  try {
    localStorage.setItem(LANGUAGE_STORAGE_KEY, lang);
  } catch {
    // ignore
  }

  window.dispatchEvent(new CustomEvent(LANGUAGE_CHANGE_EVENT, {detail: lang}));
}
