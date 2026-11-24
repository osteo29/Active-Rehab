import {describe, expect, it} from 'vitest';
import {readFileSync, existsSync} from 'node:fs';
import {join} from 'node:path';

describe('IndexNow configuration', () => {
  const root = join(__dirname, '..', '..', '..');

  it('serves a key file at the site root matching indexnow.key', () => {
    const key = readFileSync(join(root, 'indexnow.key'), 'utf8').trim();
    expect(key).toMatch(/^[a-zA-Z0-9]{8,128}$/);
    const keyFile = join(root, 'public', `${key}.txt`);
    expect(existsSync(keyFile)).toBe(true);
    expect(readFileSync(keyFile, 'utf8').trim()).toBe(key);
  });
});
