export type InteractionResult = {
  status: 'Danger' | 'Caution' | 'Safe' | 'Unclear';
  summary: string;
  interactions: string[];
  practicalAdvice: string[];
  source?: 'database' | 'ai';
  title?: string;
};
/** Treat model output as untrusted data, never render objects as React children. */
export function parseInteractionResult(text: string): InteractionResult | null {
  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    const data: unknown = JSON.parse(text.slice(start, end + 1));
    if (!data || typeof data !== 'object' || Array.isArray(data)) return null;
    const value = data as Record<string, unknown>;
    if (!['Danger','Caution','Safe','Unclear'].includes(String(value.status)) || typeof value.summary !== 'string' || !value.summary.trim()) return null;
    const isStringList = (input: unknown): input is string[] => Array.isArray(input) && input.every(item => typeof item === 'string');
    if (!isStringList(value.interactions) || !isStringList(value.practicalAdvice)) return null;
    return {status: value.status as InteractionResult['status'],summary:value.summary,interactions:value.interactions,practicalAdvice:value.practicalAdvice,source:'ai'};
  } catch { return null; }
}
