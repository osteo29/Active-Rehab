import {describe, expect, it} from 'vitest';

import {translations} from './translations';

type Tree = Record<string, unknown>;

function paths(tree: Tree, prefix = ''): string[] {
  return Object.entries(tree).flatMap(([key, value]) => {
    const path = prefix ? `${prefix}.${key}` : key;
    if (value && typeof value === 'object' && !Array.isArray(value)) {
      return paths(value as Tree, path);
    }
    return [path];
  });
}

function get(tree: Tree, path: string): unknown {
  return path.split('.').reduce<unknown>((node, key) => {
    if (node && typeof node === 'object') return (node as Tree)[key];
    return undefined;
  }, tree);
}

describe('translations', () => {
  const enPaths = paths(translations.en as Tree);
  const arPaths = paths(translations.ar as Tree);

  it('has identical key structure in English and Arabic', () => {
    expect(arPaths.sort()).toEqual(enPaths.sort());
  });

  it('has no empty strings in either language', () => {
    for (const path of enPaths) {
      const en = get(translations.en as Tree, path);
      const ar = get(translations.ar as Tree, path);
      expect(typeof en === 'string' && (en as string).trim(), `en ${path}`).not.toBe('');
      expect(typeof ar === 'string' && (ar as string).trim(), `ar ${path}`).not.toBe('');
    }
  });

  it('keeps Arabic values actually Arabic-script where English is latin', () => {
    // Spot-check a few user-facing keys to catch untranslated fallbacks.
    const samples = ['nav.calculators', 'nav.insights', 'hero.badge'];
    for (const path of samples) {
      const ar = get(translations.ar as Tree, path);
      if (typeof ar === 'string') {
        expect(/[؀-ۿ]/.test(ar), `ar ${path} should contain Arabic script`).toBe(true);
      }
    }
  });
});
