import {decodeMojibake} from '../services/textEncoding';

type AppLanguage = 'en' | 'ar';

const AUTO_NOTIFICATION_PROMPT_KEY = 'physiohub:auto-notification-prompted';

function getNotificationTitle(lang: AppLanguage) {
  return lang === 'ar'
    ? decodeMojibake('إشعارات Active Rehab جاهزة')
    : 'Active Rehab notifications are ready';
}

function getNotificationBody(lang: AppLanguage) {
  return lang === 'ar'
    ? decodeMojibake('سنستخدمها لاحقًا للتذكير بالمتابعة والنتائج المهمة.')
    : 'We can now use them later for follow-up reminders and important result updates.';
}

export function getBrowserNotificationPermission(): NotificationPermission | 'unsupported' {
  if (typeof window === 'undefined' || !('Notification' in window)) {
    return 'unsupported';
  }

  return Notification.permission;
}

export async function requestBrowserNotifications(lang: AppLanguage) {
  const currentPermission = getBrowserNotificationPermission();
  if (currentPermission === 'unsupported') {
    return currentPermission;
  }

  const permission =
    currentPermission === 'default'
      ? await Notification.requestPermission()
      : currentPermission;

  if (permission !== 'granted') {
    return permission;
  }

  try {
    const registration = await navigator.serviceWorker?.getRegistration();
    if (registration) {
      await registration.showNotification(getNotificationTitle(lang), {
        body: getNotificationBody(lang),
        icon: '/icon-192.png',
        badge: '/icon-192.png',
      });
    }
  } catch {
    // Best effort only.
  }

  return permission;
}

export async function autoRequestBrowserNotifications(_lang: AppLanguage) {
  if (typeof window === 'undefined') {
    return 'unsupported' as const;
  }

  const currentPermission = getBrowserNotificationPermission();
  if (currentPermission !== 'default') {
    return currentPermission;
  }

  try {
    if (window.localStorage.getItem(AUTO_NOTIFICATION_PROMPT_KEY) === 'true') return currentPermission;
    window.localStorage.setItem(AUTO_NOTIFICATION_PROMPT_KEY, 'true');
  } catch { /* Notification availability does not require local storage. */ }
  return currentPermission;
}
