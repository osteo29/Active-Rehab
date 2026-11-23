import {useEffect, useState} from 'react';
import {useLocation} from 'react-router-dom';
import {getPreferredLanguage, setPreferredLanguage, LANGUAGE_CHANGE_EVENT} from '../services/languagePreference';
import type {Language} from '../services/translations';

/**
 * Extract language from URL path (e.g., /en/path, /ar/path)
 * Falls back to stored preference or 'en'
 */
export function extractLanguageFromPath(pathname: string): Language {
  // The URL is the source of truth when it carries a language prefix (including
  // the bare `/en` and `/ar` home paths). The stored preference is only a
  // fallback for paths without any prefix (e.g. `/` before redirect).
  const match = pathname.match(/^\/(en|ar)(?:\/|$)/);
  return (match?.[1] as Language) || getPreferredLanguage();
}

export default function usePreferredLang(): Language {
  const location = useLocation();
  const [lang, setLang] = useState<Language>(() => extractLanguageFromPath(location.pathname));

  useEffect(() => {
    // Update language based on URL path
    const pathLang = extractLanguageFromPath(location.pathname);
    if (pathLang !== lang) {
      setLang(pathLang);
      setPreferredLanguage(pathLang);
      // Update document lang attribute
      document.documentElement.lang = pathLang;
      document.documentElement.dir = pathLang === 'ar' ? 'rtl' : 'ltr';
    }
  }, [location.pathname, lang]);

  useEffect(() => {
    // Sync language across tabs via storage and custom events
    const syncLang = () => {
      const newLang = getPreferredLanguage();
      if (newLang !== lang) {
        setLang(newLang);
      }
    };

    const handleLanguageChange = (event: Event) => {
      const nextLang = (event as CustomEvent<Language>).detail;
      const finalLang = nextLang || getPreferredLanguage();
      if (finalLang !== lang) {
        setLang(finalLang);
      }
    };

    window.addEventListener('storage', syncLang);
    window.addEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);

    return () => {
      window.removeEventListener('storage', syncLang);
      window.removeEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);
    };
  }, [lang]);

  // Keep document attributes in sync
  useEffect(() => {
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
  }, [lang]);

  return lang;
}
