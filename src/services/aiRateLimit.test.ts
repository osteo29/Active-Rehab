import {beforeEach, describe, expect, it} from 'vitest';

import {checkAiRateLimit, resetAiRateLimits} from './aiRateLimit';

describe('checkAiRateLimit', () => {
  beforeEach(() => resetAiRateLimits());

  it('allows up to 10 requests per minute per key', () => {
    const t0 = 1_000_000;
    for (let i = 0; i < 10; i += 1) {
      expect(checkAiRateLimit('ip1', t0 + i).allowed).toBe(true);
    }
    const blocked = checkAiRateLimit('ip1', t0 + 11);
    expect(blocked.allowed).toBe(false);
    expect(blocked.retryAfterSeconds).toBeGreaterThan(0);
  });

  it('tracks keys independently', () => {
    const t0 = 1_000_000;
    for (let i = 0; i < 10; i += 1) checkAiRateLimit('ip1', t0);
    expect(checkAiRateLimit('ip2', t0).allowed).toBe(true);
  });

  it('opens a fresh window after 60 seconds', () => {
    const t0 = 1_000_000;
    for (let i = 0; i < 10; i += 1) checkAiRateLimit('ip1', t0);
    expect(checkAiRateLimit('ip1', t0 + 61_000).allowed).toBe(true);
  });

  it('caps at 50 requests per day even across windows', () => {
    const t0 = 1_000_000;
    for (let minute = 0; minute < 5; minute += 1) {
      for (let i = 0; i < 10; i += 1) {
        expect(checkAiRateLimit('ip1', t0 + minute * 61_000 + i).allowed).toBe(true);
      }
    }
    const blocked = checkAiRateLimit('ip1', t0 + 6 * 61_000);
    expect(blocked.allowed).toBe(false);
    expect(blocked.retryAfterSeconds).toBe(3600);
  });

  it('resets the daily count on a new day', () => {
    const t0 = Date.UTC(2026, 0, 1, 23, 0);
    for (let minute = 0; minute < 5; minute += 1) {
      for (let i = 0; i < 10; i += 1) checkAiRateLimit('ip1', t0 + minute * 61_000);
    }
    expect(checkAiRateLimit('ip1', t0 + 61 * 60_000).allowed).toBe(true);
  });
});
