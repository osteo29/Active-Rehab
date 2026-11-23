import {beforeEach, describe, expect, it, vi} from 'vitest';
const mocks=vi.hoisted(()=>({select:vi.fn()}));
vi.mock('../lib/supabase',()=>({supabase:{from:(table:string)=>({select:()=>mocks.select(table)})}}));
import {fetchAdminDashboardMetrics} from './adminDashboard';
describe('admin metrics',()=>{
 beforeEach(()=>{vi.clearAllMocks();});
 it('keeps a real zero distinct from a failed count',async()=>{
   mocks.select.mockImplementation((table:string)=>Promise.resolve(table==='articles'?{error:new Error('denied'),count:null}:{error:null,count:0}));
   const warn=vi.spyOn(console,'warn').mockImplementation(()=>{});
   const metrics=await fetchAdminDashboardMetrics();
   expect(metrics.articles).toBeNull();
   expect(metrics.injuries).toBe(0);
   warn.mockRestore();
 });
 it('preserves successful counts when another table fails',async()=>{
   mocks.select.mockImplementation((table:string)=>table==='assessment_leads'?Promise.reject(new Error('offline')):Promise.resolve({error:null,count:12}));
   const warn=vi.spyOn(console,'warn').mockImplementation(()=>{});
   const metrics=await fetchAdminDashboardMetrics();
   expect(metrics.leads).toBeNull();
   expect(metrics.assessments).toBe(12);
   warn.mockRestore();
 });
});
