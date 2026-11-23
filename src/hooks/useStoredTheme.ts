import {useEffect, useLayoutEffect, useState} from 'react';

const STORAGE_KEY = 'activerehab_theme';

export type ThemePreference = 'light' | 'dark';

export function getStoredThemePreference(): ThemePreference {
  if (typeof window === 'undefined') return 'light';

  try {
    const saved = window.localStorage.getItem(STORAGE_KEY);
    if (saved === 'light' || saved === 'dark') return saved;
  } catch {
    // Ignore storage access issues and fall back to system preference.
  }

  return window.matchMedia?.('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

export function applyThemePreference(theme: ThemePreference) {
  if (typeof document === 'undefined') return;

  document.documentElement.classList.toggle('dark', theme === 'dark');
  document.documentElement.style.colorScheme = theme;
}

export function useStoredTheme() {
  const [theme, setTheme] = useState<ThemePreference>(() => getStoredThemePreference());

  useLayoutEffect(() => {
    applyThemePreference(theme);
  }, [theme]);

  useEffect(() => {
    try {
      window.localStorage.setItem(STORAGE_KEY, theme);
    } catch {
      // Ignore storage write issues in restricted environments.
    }
  }, [theme]);

  useEffect(() => {
    const handleStorage = (event: StorageEvent) => {
      if (event.key !== STORAGE_KEY) return;
      if (event.newValue !== 'light' && event.newValue !== 'dark') return;
      setTheme(event.newValue);
    };

    window.addEventListener('storage', handleStorage);
    return () => window.removeEventListener('storage', handleStorage);
  }, []);

  const toggleTheme = () => {
    setTheme((previous) => (previous === 'dark' ? 'light' : 'dark'));
  };

  return {
    theme,
    toggleTheme,
  };
}
