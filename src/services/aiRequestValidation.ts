export type AiRequest = {system?: string; user: string; hiddenContext?: string};
const MAX_BODY_BYTES = 64 * 1024;
export function validateAiRequest(value: unknown): {data?: AiRequest; error?: string} {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {error: 'Expected a JSON object'};
  const body = value as Record<string, unknown>;
  if (typeof body.user !== 'string' || !body.user.trim()) return {error: 'Missing user prompt'};
  for (const field of ['system', 'hiddenContext']) {
    if (body[field] !== undefined && typeof body[field] !== 'string') return {error: `Invalid ${field}`};
  }
  if (body.user.length > 12000 || (typeof body.system === 'string' && body.system.length > 12000) ||
      (typeof body.hiddenContext === 'string' && body.hiddenContext.length > 24000)) return {error: 'Request text is too long'};
  return {data: {user: body.user, system: body.system as string | undefined, hiddenContext: body.hiddenContext as string | undefined}};
}

export type JsonRequest = {body?: unknown; on?: (event: string, cb: (chunk?: Buffer) => void) => unknown};
export async function readAiJsonBody(req: JsonRequest): Promise<unknown> {
  if (typeof req.body === 'string') {
    if (Buffer.byteLength(req.body) > MAX_BODY_BYTES) throw new Error('Request too large');
    return JSON.parse(req.body || '{}');
  }
  if (req.body !== undefined) return req.body;
  if (!req.on) throw new Error('Missing request body');
  const raw = await new Promise<string>((resolve, reject) => {
    const chunks: Buffer[] = [];
    let size = 0;
    let settled = false;
    const finish = (error?: Error) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      if (error) reject(error);
      else resolve(Buffer.concat(chunks).toString('utf8'));
    };
    const timer = setTimeout(() => finish(new Error('Request body timeout')), 10000);
    req.on!('data', (chunk) => {
      if (settled) return;
      const buffer = Buffer.isBuffer(chunk) ? chunk : Buffer.from(String(chunk ?? ''));
      size += buffer.length;
      if (size > MAX_BODY_BYTES) finish(new Error('Request too large'));
      else chunks.push(buffer);
    });
    req.on!('end', () => finish());
    req.on!('error', () => finish(new Error('Request stream failed')));
    req.on!('aborted', () => finish(new Error('Request aborted')));
  });
  return JSON.parse(raw || '{}');
}
