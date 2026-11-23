// @vitest-environment jsdom
import {readFileSync} from 'node:fs';
import {describe, expect, it, vi} from 'vitest';
import {migrateLegacyStorageKeys} from './storageMigration';

function createMemoryStorage(initial: Record<string, string>) {
  const map = new Map(Object.entries(initial));
  return {
    get length() {
      return map.size;
    },
    key: (index: number) => Array.from(map.keys())[index] ?? null,
    getItem: (key: string) => (map.has(key) ? map.get(key)! : null),
    setItem: (key: string, value: string) => void map.set(key, value),
    removeItem: (key: string) => void map.delete(key),
    _map: map,
  };
}

describe('migrateLegacyStorageKeys', () => {
  it('moves legacy physiohub/physionut keys to activerehab keys', () => {
    const storage = createMemoryStorage({
      physiohub_lang: 'ar',
      physionut_my_recovery_v1: '{"journey":1}',
      'physiohub_ai_cache_v1:assistant:guest:abc:def': 'cached answer',
    });

    migrateLegacyStorageKeys(storage);

    expect(storage.getItem('activerehab_lang')).toBe('ar');
    expect(storage.getItem('activerehab_my_recovery_v1')).toBe('{"journey":1}');
    expect(storage.getItem('activerehab_ai_cache_v1:assistant:guest:abc:def')).toBe('cached answer');
    expect(storage.getItem('physiohub_lang')).toBeNull();
    expect(storage.getItem('physionut_my_recovery_v1')).toBeNull();
    expect(storage.getItem('physiohub_ai_cache_v1:assistant:guest:abc:def')).toBeNull();
  });

  it('never overwrites an existing new value and still clears the old key', () => {
    const storage = createMemoryStorage({
      physiohub_theme: 'light',
      activerehab_theme: 'dark',
    });

    migrateLegacyStorageKeys(storage);

    expect(storage.getItem('activerehab_theme')).toBe('dark');
    expect(storage.getItem('physiohub_theme')).toBeNull();
  });
});

it('treats a denied localStorage getter as a best-effort migration',()=>{
 const getter=vi.spyOn(window,'localStorage','get').mockImplementation(()=>{throw new Error('denied')});
 try {expect(()=>migrateLegacyStorageKeys()).not.toThrow()} finally {getter.mockRestore()}
});

it('runs migration before theme or UI preference reads at startup',()=>{
 const source=readFileSync('src/main.tsx','utf8');
 expect(source.indexOf('migrateLegacyStorageKeys();')).toBeGreaterThan(0);
 expect(source.indexOf('migrateLegacyStorageKeys();')).toBeLessThan(source.indexOf('applyThemePreference(getStoredThemePreference())'));
});
