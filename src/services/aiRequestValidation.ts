export type AiRequest = {system?: string; user: string; hiddenContext?: string};
export function validateAiRequest(value: unknown): {data?: AiRequest; error?: string} {
 if (!value || typeof value !== 'object' || Array.isArray(value)) return {error:'Expected a JSON object'};
 const body=value as Record<string,unknown>;
 if (typeof body.user!=='string' || !body.user.trim()) return {error:'Missing user prompt'};
 for (const field of ['system','hiddenContext']) if (body[field]!==undefined && typeof body[field]!=='string') return {error:`Invalid ${field}`};
 if(body.user.length>12000 || (typeof body.system==='string'&&body.system.length>12000) || (typeof body.hiddenContext==='string'&&body.hiddenContext.length>24000)) return {error:'Request text is too long'};
 return {data:{user:body.user,system:body.system as string|undefined,hiddenContext:body.hiddenContext as string|undefined}};
}
