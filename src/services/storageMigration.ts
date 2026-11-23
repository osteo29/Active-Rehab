/**
 * One-time localStorage key migration.
 *
 * The app was rebranded (PhysioNutrition / PhysioHub -> Active Rehab) but kept
 * writing profile, theme, consent and cache data under the old `physiohub_` /
 * `physionut_` keys. This copies existing values to the new `activerehab_`
 * keys (never overwriting a newer value) and removes the stale keys.
 */

const RENAMED_KEYS: Array<[string, string]> = [
  ['physiohub_lang', 'activerehab_lang'],
  ['physiohub_theme', 'activerehab_theme'],
  ['physiohub_cookie_consent', 'activerehab_cookie_consent'],
  ['physiohub_architect_profile', 'activerehab_architect_profile'],
  ['physiohub_tracking_profile', 'activerehab_tracking_profile'],
  ['physiohub_custom_foods', 'activerehab_custom_foods'],
  ['physio_health_profile', 'activerehab_health_profile'],
  ['physionut_my_recovery_v1', 'activerehab_my_recovery_v1'],
  ['physionut_my_recovery_v1_active', 'activerehab_my_recovery_v1_active'],
  ['physiohub_progression_state_v1', 'activerehab_progression_state_v1'],
  ['physiohub_pending_assessment_v1', 'activerehab_pending_assessment_v1'],
  ['physiohub_progress_events_v1', 'activerehab_progress_events_v1'],
  ['physiohub:pwa-install-dismissed', 'activerehab:pwa-install-dismissed'],
  ['physiohub:pwa-notification-dismissed', 'activerehab:pwa-notification-dismissed'],
  ['physiohub:auto-notification-prompted', 'activerehab:auto-notification-prompted'],
];

const RENAMED_PREFIXES: Array<[string, string]> = [['physiohub_ai_cache_v1:', 'activerehab_ai_cache_v1:']];

export function migrateLegacyStorageKeys(storage: Pick<Storage, 'getItem' | 'setItem' | 'removeItem' | 'key' | 'length'> = window.localStorage) {
  try {
    for (const [oldKey, newKey] of RENAMED_KEYS) {
      const oldValue = storage.getItem(oldKey);
      if (oldValue === null) continue;
      if (storage.getItem(newKey) === null) {
        storage.setItem(newKey, oldValue);
      }
      storage.removeItem(oldKey);
    }

    const prefixMoves: Array<[string, string]> = [];
    for (let index = 0; index < storage.length; index += 1) {
      const key = storage.key(index);
      if (!key) continue;
      for (const [oldPrefix, newPrefix] of RENAMED_PREFIXES) {
        if (key.startsWith(oldPrefix)) {
          prefixMoves.push([key, `${newPrefix}${key.slice(oldPrefix.length)}`]);
        }
      }
    }
    for (const [oldKey, newKey] of prefixMoves) {
      const oldValue = storage.getItem(oldKey);
      if (oldValue === null) continue;
      if (storage.getItem(newKey) === null) {
        storage.setItem(newKey, oldValue);
      }
      storage.removeItem(oldKey);
    }
  } catch {
    // Storage unavailable (private mode etc.): migration is best-effort.
  }
}
