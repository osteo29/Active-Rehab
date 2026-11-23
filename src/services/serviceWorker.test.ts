import {readFileSync} from 'node:fs';
import {runInNewContext} from 'node:vm';
import {describe,it,expect,vi} from 'vitest';
function harness(){
 const handlers:Record<string,(event:any)=>void>={};
 const cache={put:vi.fn(async()=>{}),addAll:vi.fn(async()=>{})};
 const caches={match:vi.fn(async(_request:any):Promise<Response|undefined>=>undefined),open:vi.fn(async()=>cache),keys:vi.fn(async()=>['activerehab-v6','physiohub-v6','another-app','activerehab-v7']),delete:vi.fn(async(_key:string)=>true)};
 const fetch=vi.fn(async(_request:any):Promise<Response>=>new Response('network'));
 runInNewContext(readFileSync('public/sw.js','utf8'),{self:{location:{origin:'https://active.test'},addEventListener:(name:string,fn:any)=>{handlers[name]=fn},skipWaiting:vi.fn(),clients:{claim:vi.fn()}},caches,fetch,Response,URL});
 function request(path:string,navigation=false){let response:Promise<Response>|undefined;const waits:Promise<any>[]=[];handlers.fetch({request:{url:new URL(path,'https://active.test').href,method:'GET',mode:navigation?'navigate':'cors',headers:new Headers({accept:navigation?'text/html':'*/*'})},respondWith:(p:Promise<Response>)=>{response=p},waitUntil:(p:Promise<any>)=>waits.push(p)});return {response,waits}}
 return {handlers,caches,cache,fetch,request};
}
describe('offline cache boundaries',()=>{
 it('does not intercept other origins or private/dynamic routes',()=>{const h=harness();for(const path of ['https://third.test/a.js','/api/data.json','/ar/auth/callback','/en/admin','/en/dashboard','/dashboard'])expect(h.request(path).response).toBeUndefined();expect(h.fetch).not.toHaveBeenCalled()});
 it('never serves the home HTML for an offline script',async()=>{const h=harness();h.fetch.mockRejectedValue(new Error('offline'));const response=await h.request('/assets/app.js').response;expect(response?.type).toBe('error');expect(h.caches.match).not.toHaveBeenCalledWith('/')});
 it('retains a home fallback for offline navigations',async()=>{const h=harness();h.fetch.mockRejectedValue(new Error('offline'));h.caches.match.mockImplementation(async key=>key==='/'?new Response('home'):undefined);expect(await (await h.request('/ar/anatomy',true).response)?.text()).toBe('home')});
 it('does not cache errors or private responses',async()=>{const h=harness();for(const response of [new Response('no',{status:404}),new Response('private',{headers:{'Cache-Control':'private'}})]){h.fetch.mockResolvedValue(response);await h.request('/ar/anatomy',true).response;}expect(h.cache.put).not.toHaveBeenCalled()});
 it('removes only this application old caches',async()=>{const h=harness();let pending:Promise<any>|undefined;h.handlers.activate({waitUntil:(p:Promise<any>)=>{pending=p}});await pending;expect(h.caches.delete.mock.calls.map(c=>c[0])).toEqual(['activerehab-v6','physiohub-v6'])});
});
