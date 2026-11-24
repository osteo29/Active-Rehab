/**
 * Post-prerender verification. Fails the build when a prerendered page loses
 * its basic SEO/a11y skeleton: exactly one <h1>, a <title>, a meta
 * description, a canonical link and matching hreflang alternates.
 */
import {readFileSync} from 'node:fs';
import {readdirSync, statSync} from 'node:fs';
import {join} from 'node:path';

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (entry === 'assets' || entry === 'node_modules') continue;
    if (statSync(full).isDirectory()) yield* walk(full);
    else if (entry === 'index.html') yield full;
  }
}

const failures = [];
let checked = 0;
for (const file of walk('dist')) {
  const html = readFileSync(file, 'utf8');
  const withoutScripts = html.replace(/<script[\s\S]*?<\/script>/g, '');
  checked += 1;
  const h1Count = (withoutScripts.match(/<h1[\s>]/g) || []).length;
  if (h1Count !== 1) failures.push(`${file}: expected exactly one <h1>, found ${h1Count}`);
  if (!/<title>[^<]+<\/title>/.test(html)) failures.push(`${file}: missing <title>`);
  if (!/<meta name="description" content="[^"]+/.test(html)) failures.push(`${file}: missing meta description`);
  if (!/<link rel="canonical" href="https:\/\/activerehab\.vercel\.app\//.test(html)) failures.push(`${file}: missing canonical`);
  const hreflangs = [...html.matchAll(/<link rel="alternate" hreflang="([^"]+)"/g)].map((m) => m[1]);
  for (const required of ['en', 'ar', 'x-default']) {
    if (!hreflangs.includes(required)) failures.push(`${file}: missing hreflang ${required}`);
  }
}

if (failures.length > 0) {
  console.error(`Prerender verification failed (${failures.length} problems over ${checked} pages):`);
  for (const failure of failures.slice(0, 20)) console.error(`  - ${failure}`);
  process.exit(1);
}
console.log(`Prerender verification passed: ${checked} pages have h1, title, description, canonical and hreflang.`);
