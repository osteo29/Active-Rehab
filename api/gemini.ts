import {validateAiRequest, readAiJsonBody} from '../src/services/aiRequestValidation';
import {checkAiRateLimit} from '../src/services/aiRateLimit';
import {GoogleGenAI} from '@google/genai';

export default async function handler(
  req: {method?: string; body?: unknown; on?: (event: string, cb: (chunk?: Buffer) => void) => void},
  res: {
    status: (code: number) => {json: (payload: unknown) => void};
    setHeader: (name: string, value: string) => void;
  },
) {
  if (req.method !== 'POST') {
    return res.status(405).json({error: 'Method not allowed'});
  }

  const apiKey = (process.env.GEMINI_API_KEY || '').trim();
  if (!apiKey) {
    return res.status(500).json({error: 'Missing GEMINI_API_KEY on the server'});
  }

  const forwardedFor = (req as {headers?: Record<string, string | string[] | undefined>}).headers?.['x-forwarded-for'];
  const clientKey = (Array.isArray(forwardedFor) ? forwardedFor[0] : forwardedFor)?.split(',')[0]?.trim() || 'unknown';
  const rate = checkAiRateLimit(clientKey);
  if (!rate.allowed) {
    res.setHeader('Retry-After', String(rate.retryAfterSeconds));
    return res.status(429).json({error: 'Too many requests. Please wait a moment and try again.'});
  }

  try {
    let raw: unknown;
    try { raw = await readAiJsonBody(req); } catch { return res.status(400).json({error:'Invalid JSON body'}); }
    const checked = validateAiRequest(raw);
    if (!checked.data) return res.status(400).json({error:checked.error});
    const payload = checked.data;

    const ai = new GoogleGenAI({apiKey});
    const contents = [
      {
        role: 'user' as const,
        parts: [
          {
            text: [
              payload.system ? `SYSTEM ROLE:\n${payload.system}` : '',
              payload.hiddenContext ? `\n\nHIDDEN CLINICAL CONTEXT:\n${payload.hiddenContext}` : '',
              `\n\nUSER QUESTION:\n${payload.user}`,
              `\n\nRESPONSE RULES:\n- Be concise, clinically grounded, and practical.\n- Do not diagnose.\n- Tie the answer to the user's weight, age, goal, and injury context when available.\n- If unclear or unsafe, recommend consulting a licensed clinician.\n- End with a short educational disclaimer.\n- Use bullet points when helpful.`,
            ]
              .filter(Boolean)
              .join(''),
          },
        ],
      },
    ];

    const response = await ai.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents,
      config: {abortSignal: AbortSignal.timeout(25_000)},
    });

    res.setHeader('Content-Type', 'application/json');
    return res.status(200).json({text: response.text || ''});
  } catch (error) {
    return res.status(500).json({
      error: 'The assistant is unavailable. Try again later.',
    });
  }
}
