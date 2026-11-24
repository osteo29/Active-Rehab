import {readFileSync} from 'node:fs';
import {describe, expect, it} from 'vitest';

/**
 * Vercel ignores public/_headers (a Netlify/Cloudflare convention), and a
 * top-level "headers" key is ignored whenever legacy "routes" are present.
 * Security and noindex headers must therefore live inside "routes" with
 * continue: true, before the filesystem handler. This guards that shape.
 */
type Route = {src?: string; handle?: string; headers?: Record<string, string>; continue?: boolean};

describe('vercel.json header routes', () => {
  const config = JSON.parse(readFileSync('vercel.json', 'utf8')) as {routes: Route[]; headers?: unknown};
  const routes = config.routes ?? [];

  it('does not use the ignored top-level headers key', () => {
    expect(config.headers).toBeUndefined();
  });

  it('sets security headers site-wide via a continue route', () => {
    const siteWide = routes.find((r) => r.src === '/(.*)' && r.continue && r.headers?.['X-Frame-Options']);
    expect(siteWide).toBeTruthy();
    expect(siteWide?.headers?.['X-Content-Type-Options']).toBe('nosniff');
    expect(siteWide?.headers?.['Referrer-Policy']).toBe('strict-origin-when-cross-origin');
    expect(siteWide?.headers?.['Permissions-Policy']).toContain('camera=()');
    expect(siteWide?.headers?.['Permissions-Policy']).toContain('microphone=()');
  });

  it('marks auth, dashboard, assistant, admin and studio as noindex', () => {
    const noindex = routes.filter((r) => r.headers?.['X-Robots-Tag']?.includes('noindex'));
    const srcs = noindex.map((r) => r.src).join(' ');
    for (const area of ['auth', 'dashboard', 'assistant', 'admin', 'studio']) {
      expect(srcs).toContain(area);
    }
    expect(noindex.every((r) => r.continue)).toBe(true);
  });

  it('places header routes before the filesystem handler', () => {
    const fsIndex = routes.findIndex((r) => r.handle === 'filesystem');
    const headerIndexes = routes
      .map((r, i) => ({r, i}))
      .filter(({r}) => r.continue && r.headers)
      .map(({i}) => i);
    expect(fsIndex).toBeGreaterThan(-1);
    expect(Math.max(...headerIndexes)).toBeLessThan(fsIndex);
  });
});
