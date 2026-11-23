import {afterEach,describe,expect,it,vi} from 'vitest';
const mocks=vi.hoisted(()=>({response:vi.fn()}));
vi.mock('../lib/supabase',()=>({isSupabaseConfigured:true,supabase:{from:()=>({select:()=>({order:()=>({order:()=>({abortSignal:mocks.response})})})})}}));
import {fetchExerciseLibraryEntriesFromSupabase} from './exerciseSupabaseService';
describe('exercise hydration failures',()=>{
 afterEach(()=>vi.clearAllMocks());
 it('propagates remote errors so the hook can label fallback content',async()=>{mocks.response.mockResolvedValue({data:null,error:new Error('offline')});await expect(fetchExerciseLibraryEntriesFromSupabase()).rejects.toThrow('offline')});
 it('keeps successful empty catalogs distinct from failures',async()=>{mocks.response.mockResolvedValue({data:[],error:null});await expect(fetchExerciseLibraryEntriesFromSupabase()).resolves.toEqual([])});
 it('normalizes non-Error failures',async()=>{mocks.response.mockRejectedValue({message:'network'});await expect(fetchExerciseLibraryEntriesFromSupabase()).rejects.toThrow('Could not load')});
});
