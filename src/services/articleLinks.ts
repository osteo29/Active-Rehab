import type {Language} from './translations';
const ROUTE_MAP: Record<string, string> = {
  '/calculators': '/#calculators', '/assistant': '/assistant', '/dashboard': '/dashboard',
  '/injuries': '/injuries', '/diets': '/diets', '/insights': '/insights', '/exercises': '/exercises',
};
export function resolveArticleLink(href: string, lang: Language): {href: string; internal: boolean} | null {
  const value = href.trim();
  // Reject active schemes and protocol-relative destinations from editable content.
  if (!value || /[\u0000-\u0020\u007f\\]/.test(value) || value.startsWith('//')) return null;
  if (value.startsWith('#')) return {href: value, internal: true};
  if (value.startsWith('/')) {
    if (/^\/(en|ar)(\/|$)/.test(value)) return {href: value, internal: true};
    const hashIndex = value.indexOf('#');
    const basePath = hashIndex >= 0 ? value.slice(0, hashIndex) : value;
    const hash = hashIndex >= 0 ? value.slice(hashIndex) : '';
    const mapped = ROUTE_MAP[basePath] || basePath;
    const target = hash ? mapped.split('#')[0] + hash : mapped;
    return {href: `/${lang}${target}`, internal: true};
  }
  if (!/^(https?:|mailto:|tel:)/i.test(value)) return null;
  return {href: value, internal: false};
}
