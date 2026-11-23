// @vitest-environment jsdom
import {beforeEach,afterEach,describe,it,expect,vi} from 'vitest';
import {scrollToAnchorWhenReady} from './scrollToAnchor';
beforeEach(()=>{document.body.innerHTML='';vi.useFakeTimers();});afterEach(()=>{vi.useRealTimers();vi.restoreAllMocks()});
describe('deferred anchor navigation',()=>{
 it('scrolls when a deferred element mounts',async()=>{const scroll=vi.fn();scrollToAnchorWhenReady('late');const target=document.createElement('div');target.id='late';target.scrollIntoView=scroll;document.body.append(target);await Promise.resolve();expect(scroll).toHaveBeenCalledOnce()});
 it('cancels on route cleanup instead of scrolling the next page',async()=>{const scroll=vi.fn();const cancel=scrollToAnchorWhenReady('late');cancel();const target=document.createElement('div');target.id='late';target.scrollIntoView=scroll;document.body.append(target);await Promise.resolve();expect(scroll).not.toHaveBeenCalled()});
 it('stops after its timeout and respects reduced motion',async()=>{const scroll=vi.fn();scrollToAnchorWhenReady('late',100);vi.advanceTimersByTime(101);const target=document.createElement('div');target.id='late';target.scrollIntoView=scroll;document.body.append(target);await Promise.resolve();expect(scroll).not.toHaveBeenCalled();Object.defineProperty(window,'matchMedia',{configurable:true,value:()=>({matches:true})});scrollToAnchorWhenReady('late');expect(scroll).toHaveBeenCalledWith({behavior:'auto',block:'start'})});
});
