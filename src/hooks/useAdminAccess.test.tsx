// @vitest-environment jsdom
import {act, renderHook, waitFor} from '@testing-library/react';
import {beforeEach, describe, expect, it, vi} from 'vitest';
const mocks = vi.hoisted(() => ({getUser:vi.fn(), record:vi.fn(), change:null as null | ((event:string, session:any)=>Promise<void>), unsubscribe:vi.fn()}));
vi.mock('../lib/supabase',()=>({
  getArticleAdminEmail:()=>'', getCurrentUser:mocks.getUser,
  getSupabaseConfigurationMessage:()=>'', isArticleAdminUser:()=>false,
  isSupabaseConfigured:true,
  onSupabaseAuthChange:(cb:any)=>{mocks.change=cb; return {data:{subscription:{unsubscribe:mocks.unsubscribe}}};},
  supabase:{from:()=>({select:()=>({eq:()=>({maybeSingle:mocks.record})})})},
}));
import useAdminAccess from './useAdminAccess';
const user={id:'test-user'};
describe('admin session permissions',()=>{
  beforeEach(()=>{vi.clearAllMocks();mocks.getUser.mockResolvedValue(user);mocks.record.mockResolvedValue({data:{role:'admin'}});});
  it('revokes permissions immediately on signout',async()=>{
    const {result}=renderHook(()=>useAdminAccess('en'));
    await waitFor(()=>expect(result.current.canManageUsers).toBe(true));
    await act(async()=>{await mocks.change?.('SIGNED_OUT',null);});
    expect(result.current.canAccessAdminArea).toBe(false);
    expect(result.current.user).toBeNull();
  });
  it('ignores a stale pending admin lookup after signout',async()=>{
    let finish!: (value:any)=>void;
    mocks.record.mockImplementation(()=>new Promise(resolve=>{finish=resolve;}));
    const {result}=renderHook(()=>useAdminAccess('en'));
    await waitFor(()=>expect(mocks.record).toHaveBeenCalled());
    await act(async()=>{await mocks.change?.('SIGNED_OUT',null);});
    await act(async()=>{finish({data:{role:'admin'}});});
    expect(result.current.user).toBeNull();
    expect(result.current.canManageUsers).toBe(false);
  });
  it('does not grant an unknown role any capabilities',async()=>{
    mocks.record.mockResolvedValue({data:{role:'unrecognized'}});
    const {result}=renderHook(()=>useAdminAccess('en'));
    await waitFor(()=>expect(result.current.authChecked).toBe(true));
    expect(result.current.canAccessAdminArea).toBe(false);
  });
});
