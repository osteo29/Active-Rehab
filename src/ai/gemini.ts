export type GeminiAskParams = {
  system: string;
  user: string;
  hiddenContext?: string;
  cacheKey?: string;
};

type GeminiResponse = {
  text?: string;
  error?: string;
};

const AI_CACHE_PREFIX = 'activerehab_ai_cache_v1';

function normalizeForCache(value: string) {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

function hashString(value: string) {
  let hash = 0;

  for (let index = 0; index < value.length; index += 1) {
    hash = (hash * 31 + value.charCodeAt(index)) >>> 0;
  }

  return hash.toString(36);
}

export function getStoredAiIdentity() {
  if (typeof window === 'undefined') return 'guest';

  try {
    const trackingRaw = localStorage.getItem('activerehab_tracking_profile');
    const architectRaw = localStorage.getItem('activerehab_architect_profile');
    const tracking = trackingRaw ? JSON.parse(trackingRaw) : {};
    const architect = architectRaw ? JSON.parse(architectRaw) : {};

    const email =
      typeof tracking?.email === 'string' && tracking.email.trim()
        ? tracking.email.trim().toLowerCase()
        : '';
    if (email) return email;

    const name =
      typeof tracking?.name === 'string' && tracking.name.trim()
        ? tracking.name.trim().toLowerCase()
        : '';

    const fallbackProfile = [
      name,
      architect?.age,
      architect?.weight,
      architect?.height,
      architect?.gender,
      architect?.injuryType,
    ]
      .filter(Boolean)
      .join('|');

    return fallbackProfile ? `anon_${hashString(fallbackProfile)}` : 'guest';
  } catch {
    return 'guest';
  }
}

export function getStoredAiContext(lang: 'en' | 'ar' = 'en') {
  if (typeof window === 'undefined') return '';

  try {
    const trackingRaw = localStorage.getItem('activerehab_tracking_profile');
    const architectRaw = localStorage.getItem('activerehab_architect_profile');
    const tracking = trackingRaw ? JSON.parse(trackingRaw) : {};
    const architect = architectRaw ? JSON.parse(architectRaw) : {};

    const lines: string[] = [];

    if (tracking?.name) {
      lines.push(lang === 'ar' ? `اسم المستخدم: ${tracking.name}` : `User name: ${tracking.name}`);
    }

    if (tracking?.email) {
      lines.push(lang === 'ar' ? `معرّف المتابعة: ${tracking.email}` : `Tracking identity: ${tracking.email}`);
    }

    if (architect?.age) {
      lines.push(lang === 'ar' ? `العمر: ${architect.age}` : `Age: ${architect.age}`);
    }

    if (architect?.weight) {
      lines.push(lang === 'ar' ? `الوزن: ${architect.weight} كجم` : `Weight: ${architect.weight} kg`);
    }

    if (architect?.height) {
      lines.push(lang === 'ar' ? `الطول: ${architect.height} سم` : `Height: ${architect.height} cm`);
    }

    if (architect?.gender) {
      lines.push(lang === 'ar' ? `النوع: ${architect.gender}` : `Gender: ${architect.gender}`);
    }

    if (architect?.goal) {
      lines.push(lang === 'ar' ? `الهدف: ${architect.goal}` : `Goal: ${architect.goal}`);
    }

    if (architect?.injuryType) {
      lines.push(lang === 'ar' ? `الإصابة الحالية: ${architect.injuryType}` : `Current injury: ${architect.injuryType}`);
    }

    if (architect?.recoveryWeek) {
      lines.push(lang === 'ar' ? `أسبوع التعافي: ${architect.recoveryWeek}` : `Recovery week: ${architect.recoveryWeek}`);
    }

    return lines.join('\n');
  } catch {
    return '';
  }
}

export function buildPersonalizedAiCacheKey({
  scope,
  question,
  hiddenContext,
  identity,
}: {
  scope: string;
  question: string;
  hiddenContext?: string;
  identity?: string;
}) {
  const userKey = identity || getStoredAiIdentity();
  const contextHash = hashString(normalizeForCache(hiddenContext || ''));
  const questionHash = hashString(normalizeForCache(question));
  return `${AI_CACHE_PREFIX}:${scope}:${userKey}:${questionHash}:${contextHash}`;
}

function getCachedAiResponse(cacheKey?: string) {
  if (!cacheKey || typeof window === 'undefined') return null;

  try {
    return localStorage.getItem(cacheKey);
  } catch {
    return null;
  }
}

function setCachedAiResponse(cacheKey: string | undefined, value: string) {
  if (!cacheKey || typeof window === 'undefined') return;

  try {
    localStorage.setItem(cacheKey, value);
  } catch {
    // Ignore quota/storage failures.
  }
}

export async function askGeminiText(params: GeminiAskParams): Promise<string> {
  const cached = getCachedAiResponse(params.cacheKey);
  if (cached) return cached;

  const response = await fetch('/api/gemini', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      system: params.system,
      user: params.user,
      hiddenContext: params.hiddenContext,
    }),
  });

  const payload = (await response.json().catch(() => ({}))) as GeminiResponse;
  if (!response.ok) {
    throw new Error(payload.error || 'AI request failed');
  }

  const answer = String(payload.text || '').trim();
  setCachedAiResponse(params.cacheKey, answer);
  return answer;
}

export function trackAiQuestion(_question: string, meta?: Record<string, unknown>) {
  const analyticsWindow = window as Window & {
    gtag?: (eventName: string, action: string, params?: Record<string, unknown>) => void;
  };

  if (typeof analyticsWindow.gtag === 'function') {
    analyticsWindow.gtag('event', 'user_ai_question', {
      ...(meta || {}),
    });
  }
}
