// @vitest-environment jsdom
import {fireEvent,render,screen,waitFor,cleanup} from '@testing-library/react';
import {MemoryRouter} from 'react-router-dom';
import {useState} from 'react';
import {afterEach,beforeEach,describe,expect,it,vi} from 'vitest';
import Navigation from './Navigation';
import {translations} from '../../services/translations';
vi.mock('../../lib/supabase',()=>({isSupabaseConfigured:false,getCurrentUser:vi.fn(),onSupabaseAuthChange:vi.fn(),signOutCurrentUser:vi.fn()}));
function Harness(){const [open,setOpen]=useState(false);return <MemoryRouter><Navigation t={translations.en} lang="en" setLang={vi.fn()} calculators={[]} theme="light" onToggleTheme={vi.fn()} setActiveCalculator={vi.fn()} isSidebarOpen={open} setIsSidebarOpen={setOpen}/></MemoryRouter>}
describe('navigation accessibility',()=>{
 beforeEach(()=>{vi.spyOn(HTMLElement.prototype,'getClientRects').mockReturnValue([{width:10,height:10}] as unknown as DOMRectList)});
 afterEach(()=>{cleanup();vi.restoreAllMocks()});
 it('keeps keyboard focus inside the drawer and restores the opener',async()=>{
  render(<Harness/>);const opener=screen.getByRole('button',{name:'Open main menu'});opener.focus();fireEvent.click(opener);
  const drawer=screen.getByRole('dialog');expect(drawer.contains(document.activeElement)).toBe(true);expect(opener.getAttribute('aria-expanded')).toBe('true');
  const items=drawer.querySelectorAll<HTMLElement>('a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex="0"]');
  const first=items[0],last=items[items.length-1];last.focus();fireEvent.keyDown(window,{key:'Tab'});expect(document.activeElement).toBe(first);
  first.focus();fireEvent.keyDown(window,{key:'Tab',shiftKey:true});expect(document.activeElement).toBe(last);
  fireEvent.keyDown(window,{key:'Escape'});await waitFor(()=>expect(screen.queryByRole('dialog')).toBeNull());expect(document.activeElement).toBe(opener);expect(document.body.style.overflow).not.toBe('hidden');
 });
 it('uses the light logo text on the dark header',()=>{const {container}=render(<Harness/>);expect(container.querySelector('header .brand-metal-text')).not.toBeNull()});
});
