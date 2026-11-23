// @vitest-environment jsdom
import {render,screen} from '@testing-library/react';import {MemoryRouter} from 'react-router-dom';import {expect,it,vi} from 'vitest';
const mocks=vi.hoisted(()=>({subscribe:vi.fn()}));
vi.mock('../lib/supabase',()=>({isSupabaseConfigured:false,getSupabaseConfigurationMessage:()=> 'Fixture configuration missing',getCurrentSession:vi.fn(),getSupabaseActionErrorMessage:()=>'',onSupabaseAuthChange:mocks.subscribe}));
import AuthCallbackPage from './AuthCallbackPage';
it('shows an actionable configuration error instead of subscribing to a missing client',()=>{render(<MemoryRouter><AuthCallbackPage/></MemoryRouter>);expect(screen.getByText('Fixture configuration missing')).toBeInTheDocument();expect(mocks.subscribe).not.toHaveBeenCalled()});
