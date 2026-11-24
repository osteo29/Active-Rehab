import {readFileSync} from 'node:fs';
import {describe, expect, it} from 'vitest';

/**
 * Vercel ignores public/_headers (a Netlify/Cloudflare convention), so the
 * site's security headers must live in vercel.json. This guards against
 * someone trimming the block back out.
 */
describe('vercel.json security headers', () => {
  const config = JSON.parse(readFileSync('vercel.json', 'utf8')) as {
    headers?: {source: string; headers: {key: string; value: string}[]}[];
  };
  const siteWide = config.headers?.find((h) => h.source === '/(.*)')?.headers ?? [];
  const keys = new Map(siteWide.map((h) => [h.key, h.value]));

  it('sets clickjacking, MIME-sniffing, referrer and permissions policies site-wide', () => {
    expect(keys.get('X-Frame-Options')).toBe('SAMEORIGIN');
    expect(keys.get('X-Content-Type-Options')).toBe('nosniff');
    expect(keys.get('Referrer-Policy')).toBe('strict-origin-when-cross-origin');
    expect(keys.get('Permissions-Policy')).toContain('camera=()');
    expect(keys.get('Permissions-Policy')).toContain('microphone=()');
  });
});
