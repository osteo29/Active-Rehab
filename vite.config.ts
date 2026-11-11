import {GoogleGenAI} from '@google/genai';
import tailwindcss from '@tailwindcss/vite';
import react from '@vitejs/plugin-react';
import path from 'path';
import {defineConfig, loadEnv} from 'vite';

export default defineConfig(({mode}) => {
  const env = loadEnv(mode, '.', '');
  const geminiApiKey = (env.GEMINI_API_KEY || env.VITE_GEMINI_API_KEY || '').trim();

  const devGeminiProxy = {
    name: 'dev-gemini-proxy',
    configureServer(server: import('vite').ViteDevServer) {
      server.middlewares.use('/api/gemini', async (req, res) => {
        if (req.method !== 'POST') {
          res.statusCode = 405;
          res.setHeader('Content-Type', 'application/json');
          res.end(JSON.stringify({error: 'Method not allowed'}));
          return;
        }

        if (!geminiApiKey) {
          res.statusCode = 500;
          res.setHeader('Content-Type', 'application/json');
          res.end(JSON.stringify({error: 'Missing GEMINI_API_KEY on the server'}));
          return;
        }

        try {
          const body = await new Promise<string>((resolve, reject) => {
            let raw = '';
            req.on('data', (chunk) => {
              raw += chunk;
            });
            req.on('end', () => resolve(raw));
            req.on('error', reject);
          });

          const payload = JSON.parse(body || '{}') as {
            system?: string;
            user?: string;
            hiddenContext?: string;
          };

          if (!payload.user?.trim()) {
            res.statusCode = 400;
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify({error: 'Missing user prompt'}));
            return;
          }

          const ai = new GoogleGenAI({apiKey: geminiApiKey});
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

          res.statusCode = 200;
          res.setHeader('Content-Type', 'application/json');
          res.end(JSON.stringify({text: response.text || ''}));
        } catch (error) {
          res.statusCode = 500;
          res.setHeader('Content-Type', 'application/json');
          res.end(JSON.stringify({error: error instanceof Error ? error.message : 'Gemini request failed'}));
        }
      });
    },
  };

  return {
    plugins: [react(), tailwindcss(), devGeminiProxy],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, '.'),
      },
    },
    build: {
      rollupOptions: {
        output: {
          manualChunks(id) {
            if (id.includes('node_modules/react/') || id.includes('node_modules/react-dom/')) {
              return 'react-core';
            }

            if (id.includes('node_modules/react-router') || id.includes('node_modules/@remix-run')) {
              return 'router-vendor';
            }

            if (id.includes('node_modules/motion')) {
              return 'motion-vendor';
            }

            if (id.includes('node_modules/chart.js') || id.includes('node_modules/react-chartjs-2')) {
              return 'chart-vendor';
            }

            if (id.includes('node_modules/lucide-react')) {
              return 'icon-vendor';
            }

            if (id.includes('node_modules/@supabase')) {
              return 'supabase-vendor';
            }

            if (id.includes('node_modules/@google/genai')) {
              return 'ai-vendor';
            }

            if (
              id.includes('/src/services/translations.ts') ||
              id.includes('/src/services/foodData.ts') ||
              id.includes('/src/services/injuryDatabase.ts')
            ) {
              return 'app-data';
            }

            if (
              id.includes('/src/services/physioNutritionLogic.ts') ||
              id.includes('/src/logic/physioNutritionLogic.ts') ||
              id.includes('/src/services/calculators.ts')
            ) {
              return 'health-logic';
            }

            return undefined;
          },
        },
      },
    },
    server: {
      port: 3000,
      host: '0.0.0.0',
      watch: {
        ignored: ['**/.local/**', '**/.replit/**', '**/tmp/**'],
      },
      // HMR configuration for development
      hmr: {
        host: 'localhost',
        port: 3000,
        protocol: 'ws',
      },
    },
  };
});
