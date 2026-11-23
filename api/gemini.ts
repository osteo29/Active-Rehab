import {validateAiRequest} from '../src/services/aiRequestValidation';
import {GoogleGenAI} from '@google/genai';

type GeminiRequestBody = {
  system?: string;
  user?: string;
  hiddenContext?: string;
};

async function readJsonBody(req: {body?: unknown; on?: (event: string, cb: (chunk?: Buffer) => void) => void}) {
  if (typeof req.body === 'string') {
    return JSON.parse(req.body || '{}') as GeminiRequestBody;
  }

  if (req.body && typeof req.body === 'object') {
    return req.body as GeminiRequestBody;
  }

  const raw = await new Promise<string>((resolve, reject) => {
    let data = '';
    req.on?.('data', (chunk) => {
      data += chunk?.toString?.() || '';
    });
    req.on?.('end', () => resolve(data));
    req.on?.('error', reject);
  });

  return JSON.parse(raw || '{}') as GeminiRequestBody;
}

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

  const apiKey = (process.env.GEMINI_API_KEY || process.env.VITE_GEMINI_API_KEY || '').trim();
  if (!apiKey) {
    return res.status(500).json({error: 'Missing GEMINI_API_KEY on the server'});
  }

  try {
    let raw: unknown;
    try { raw = await readJsonBody(req); } catch { return res.status(400).json({error:'Invalid JSON body'}); }
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
    });

    res.setHeader('Content-Type', 'application/json');
    return res.status(200).json({text: response.text || ''});
  } catch (error) {
    return res.status(500).json({
      error: 'The assistant is unavailable. Try again later.',
    });
  }
}
