import {migrateLegacyStorageKeys} from './services/storageMigration';
import {StrictMode} from 'react';
import {createRoot} from 'react-dom/client';
import {BrowserRouter} from 'react-router-dom';
import RouterApp from './RouterApp';
import {applyThemePreference, getStoredThemePreference} from './hooks/useStoredTheme';
import './index.css';

migrateLegacyStorageKeys();
applyThemePreference(getStoredThemePreference());

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <RouterApp />
    </BrowserRouter>
  </StrictMode>,
);

window.requestAnimationFrame(() => {
  const splash = document.getElementById('boot-splash');
  splash?.classList.add('is-hidden');
  window.setTimeout(() => splash?.remove(), 450);
});

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {
      // Ignore registration errors in unsupported environments.
    });
  });
}
