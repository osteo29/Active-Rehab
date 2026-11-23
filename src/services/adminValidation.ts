/** Allow ordinary HTTP(S) URLs and site-local paths, never executable schemes. */
export function isSafeContentLink(value: string): boolean {
  const clean = value.trim();
  if (!clean) return true;
  if (/[\u0000-\u0020\u007f\\]/.test(clean)) return false;
  if (clean.startsWith('/') && !clean.startsWith('//')) return true;
  try {
    const url = new URL(clean);
    return (url.protocol === 'https:' || url.protocol === 'http:') && !url.username && !url.password;
  } catch { return false; }
}
export function isValidContentSlug(value: string): boolean {
  return /^[a-z0-9]+(?:[-_][a-z0-9]+)*$/.test(value.trim());
}

export function isSafeMediaPath(value: string): boolean {
  if (isSafeContentLink(value)) return true;
  // Existing media entries may store bucket-relative paths, not full URLs.
  return /^(?!.*(?:^|\/)\.\.(?:\/|$))[a-zA-Z0-9_.-]+(?:\/[a-zA-Z0-9_.-]+)*$/.test(value.trim());
}
