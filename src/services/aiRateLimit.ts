/**
 * Per-instance rate limiter for the AI endpoint.
 *
 * Vercel serverless instances do not share memory, so this cannot provide a
 * hard global quota: each warm instance enforces its own per-IP budget. That
 * still stops the common abuse pattern (one client hammering one warm
 * instance) and keeps honest bursts cheap. A hard global cap needs shared
 * storage (e.g. Upstash) and is intentionally left out of this change.
 */

export type RateLimitResult = {
  allowed: boolean;
  retryAfterSeconds: number;
  remaining: number;
};

type Bucket = {
  windowStart: number;
  count: number;
  day: string;
  dayCount: number;
};

const buckets = new Map<string, Bucket>();

const WINDOW_MS = 60_000;
const MAX_PER_WINDOW = 10;
const MAX_PER_DAY = 50;
const MAX_KEYS = 5_000;

function currentDay(now: number) {
  return new Date(now).toISOString().slice(0, 10);
}

export function checkAiRateLimit(key: string, now: number = Date.now()): RateLimitResult {
  // Bound memory: drop the oldest entries once the map grows past the cap.
  if (buckets.size > MAX_KEYS) {
    buckets.clear();
  }

  let bucket = buckets.get(key);
  if (!bucket) {
    bucket = {windowStart: now, count: 0, day: currentDay(now), dayCount: 0};
    buckets.set(key, bucket);
  }

  if (now - bucket.windowStart >= WINDOW_MS) {
    bucket.windowStart = now;
    bucket.count = 0;
  }
  if (bucket.day !== currentDay(now)) {
    bucket.day = currentDay(now);
    bucket.dayCount = 0;
  }

  if (bucket.dayCount >= MAX_PER_DAY) {
    return {allowed: false, retryAfterSeconds: 3600, remaining: 0};
  }
  if (bucket.count >= MAX_PER_WINDOW) {
    const retryAfterSeconds = Math.max(1, Math.ceil((bucket.windowStart + WINDOW_MS - now) / 1000));
    return {allowed: false, retryAfterSeconds, remaining: 0};
  }

  bucket.count += 1;
  bucket.dayCount += 1;
  return {allowed: true, retryAfterSeconds: 0, remaining: MAX_PER_WINDOW - bucket.count};
}

/** Test-only: reset all buckets. */
export function resetAiRateLimits() {
  buckets.clear();
}
