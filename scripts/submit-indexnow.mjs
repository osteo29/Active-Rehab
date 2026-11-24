#!/usr/bin/env node
/**
 * Submit all sitemap URLs to IndexNow (Bing, Yandex, Naver, Seznam).
 *
 * Usage:
 *   node scripts/submit-indexnow.mjs            # submit every sitemap URL
 *   node scripts/submit-indexnow.mjs <url>...   # submit specific URLs only
 *
 * The key file public/<INDEXNOW_KEY>.txt must be live at the site root
 * before submitting, or the API rejects the key.
 */
import {readFileSync, readdirSync} from 'node:fs';
import {join, dirname} from 'node:path';
import {fileURLToPath} from 'node:url';

const SITE = 'https://activerehab.vercel.app';
const HOST = 'activerehab.vercel.app';
const INDEXNOW_ENDPOINT = 'https://api.indexnow.org/indexnow';
const MAX_URLS_PER_REQUEST = 10000;

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const key = readFileSync(join(root, 'indexnow.key'), 'utf8').trim();
if (!/^[a-zA-Z0-9]{8,128}$/.test(key)) {
  console.error('indexnow.key is missing or malformed');
  process.exit(1);
}
const keyLocation = `${SITE}/${key}.txt`;

function urlsFromSitemaps() {
  const urls = [];
  for (const file of readdirSync(join(root, 'public'))) {
    if (!/^sitemap-.*\.xml$/.test(file)) continue;
    const xml = readFileSync(join(root, 'public', file), 'utf8');
    for (const match of xml.matchAll(/<loc>([^<]+)<\/loc>/g)) {
      urls.push(match[1]);
    }
  }
  return [...new Set(urls)];
}

const requested = process.argv.slice(2);
const urlList = requested.length > 0 ? requested : urlsFromSitemaps();
if (urlList.length === 0) {
  console.error('No URLs to submit. Run `npm run generate:sitemap` first.');
  process.exit(1);
}

console.log(`Submitting ${urlList.length} URL(s) to IndexNow...`);
for (let i = 0; i < urlList.length; i += MAX_URLS_PER_REQUEST) {
  const batch = urlList.slice(i, i + MAX_URLS_PER_REQUEST);
  const res = await fetch(INDEXNOW_ENDPOINT, {
    method: 'POST',
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: JSON.stringify({host: HOST, key, keyLocation, urlList: batch}),
  });
  console.log(`Batch ${i / MAX_URLS_PER_REQUEST + 1}: HTTP ${res.status}`);
  if (!res.ok) {
    console.error('IndexNow submission failed:', await res.text());
    process.exit(1);
  }
}
console.log('Done. Key location:', keyLocation);
