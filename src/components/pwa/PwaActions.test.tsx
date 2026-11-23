// @vitest-environment jsdom
import {act,fireEvent,render,screen} from '@testing-library/react';
import {afterEach,expect,it,vi} from 'vitest';
import PwaActions from './PwaActions';
afterEach(()=>{vi.restoreAllMocks();vi.useRealTimers();vi.unstubAllGlobals()});
it('renders and dismisses install prompt when storage methods throw',()=>{
 vi.useFakeTimers();vi.stubGlobal('matchMedia',vi.fn(()=>({matches:false})));
 vi.spyOn(Storage.prototype,'getItem').mockImplementation(()=>{throw new Error('blocked')});
 vi.spyOn(Storage.prototype,'setItem').mockImplementation(()=>{throw new Error('blocked')});
 render(<PwaActions lang="en"/>);act(()=>vi.advanceTimersByTime(5000));
 expect(screen.getByText('Install the app')).toBeInTheDocument();
 fireEvent.click(screen.getByRole('button',{name:'Dismiss install prompt'}));
 expect(screen.queryByText('Install the app')).not.toBeInTheDocument();
});
it('renders when access to the localStorage property itself throws',()=>{
 vi.stubGlobal('matchMedia',vi.fn(()=>({matches:false})));
 vi.spyOn(window,'localStorage','get').mockImplementation(()=>{throw new Error('denied')});
 expect(()=>render(<PwaActions lang="en"/>)).not.toThrow();
});
