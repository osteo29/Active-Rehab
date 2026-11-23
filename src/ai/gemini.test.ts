import {afterEach,expect,it,vi} from 'vitest';
import {askGeminiText} from './gemini';
const params={system:'Fixture',user:'Fixture'};
afterEach(()=>{vi.unstubAllGlobals();vi.useRealTimers()});
it('rejects empty or incorrectly typed successful responses',async()=>{for(const text of ['',{},null]){vi.stubGlobal('fetch',vi.fn(async()=>({ok:true,json:async()=>({text})})));await expect(askGeminiText(params)).rejects.toThrow('empty answer')}});
it('returns a nonempty string response',async()=>{vi.stubGlobal('fetch',vi.fn(async()=>({ok:true,json:async()=>({text:' Fixture '})})));await expect(askGeminiText(params)).resolves.toBe('Fixture')});
it('handles null error payloads without crashing',async()=>{vi.stubGlobal('fetch',vi.fn(async()=>({ok:false,json:async()=>null})));await expect(askGeminiText(params)).rejects.toThrow('unavailable')});
it('ends a stalled request at its timeout',async()=>{vi.useFakeTimers();vi.stubGlobal('fetch',vi.fn((_:unknown,options:RequestInit)=>new Promise((_resolve,reject)=>options.signal?.addEventListener('abort',()=>reject(new Error('aborted'))))));const result=expect(askGeminiText(params)).rejects.toThrow('too long');await vi.advanceTimersByTimeAsync(45_000);await result});
