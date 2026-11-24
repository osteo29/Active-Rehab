import {readFileSync} from 'node:fs';
import {describe, expect, it} from 'vitest';

const SITE = 'https://activerehab.vercel.app';
const SITEMAPS = [
  'public/sitemap-static.xml',
  'public/sitemap-articles.xml',
  'public/sitemap-injuries.xml',
  'public/sitemap-diets.xml',
];

function urls(file: string): string[] {
  return [...readFileSync(file, 'utf8').matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
}

describe('sitemap integrity', () => {
  it('every listed URL is an absolute https URL on the production domain', () => {
    for (const file of SITEMAPS) {
      for (const url of urls(file)) {
        expect(url.startsWith(`${SITE}/`), `${file}: ${url}`).toBe(true);
      }
    }
  });

  it('lists only /en/ and /ar/ language-prefixed content URLs', () => {
    for (const file of SITEMAPS) {
      for (const url of urls(file)) {
        const path = url.replace(SITE, '');
        expect(path === '/' || /^\/(en|ar)(\/|$)/.test(path), `${file}: ${url}`).toBe(true);
      }
    }
  });

  it('has no duplicate URLs within or across sitemaps', () => {
    const seen = new Map<string, string>();
    for (const file of SITEMAPS) {
      for (const url of urls(file)) {
        expect(seen.has(url), `${url} in both ${seen.get(url)} and ${file}`).toBe(false);
        seen.set(url, file);
      }
    }
  });

  it('index and robots point at the sitemap', () => {
    const index = readFileSync('public/sitemap.xml', 'utf8');
    for (const file of SITEMAPS) {
      expect(index).toContain(`/${file.replace('public/', '')}`);
    }
    expect(readFileSync('public/robots.txt', 'utf8')).toContain('Sitemap: https://activerehab.vercel.app/sitemap.xml');
  });
});
