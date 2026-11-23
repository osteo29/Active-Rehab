// @vitest-environment jsdom
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {MemoryRouter} from 'react-router-dom';
import {afterEach,describe,it,expect,vi} from 'vitest';
import PageLayout from './PageLayout';
vi.mock('./usePreferredLang',()=>({default:()=> 'en'}));
vi.mock('../hooks/useStoredTheme',()=>({useStoredTheme:()=>({theme:'light',toggleTheme:vi.fn()})}));
afterEach(cleanup);
describe('page keyboard navigation',()=>{
 it('moves skip-link focus to the main content and supports Escape on mobile navigation',()=>{render(<MemoryRouter initialEntries={['/en/about']}><PageLayout title="About"><p>Content</p></PageLayout></MemoryRouter>);fireEvent.click(screen.getByRole('link',{name:'Skip to content'}));expect(document.activeElement?.id).toBe('main-content');const opener=screen.getByRole('button',{name:'Open menu'});fireEvent.click(opener);expect(opener.getAttribute('aria-expanded')).toBe('true');fireEvent.keyDown(window,{key:'Escape'});expect(opener.getAttribute('aria-expanded')).toBe('false');expect(document.activeElement).toBe(opener);expect(screen.getAllByRole('link',{name:'About'}).some(el=>el.getAttribute('aria-current')==='page')).toBe(true)});
});
