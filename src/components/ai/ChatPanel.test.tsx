// @vitest-environment jsdom
import {fireEvent,render,screen,waitFor} from '@testing-library/react';
import {afterEach,expect,it,vi} from 'vitest';
const mocks=vi.hoisted(()=>({ask:vi.fn(async()=> 'Fixture answer')}));
vi.mock('../../ai/gemini',()=>({askGeminiText:mocks.ask,buildPersonalizedAiCacheKey:()=> 'fixture',getStoredAiContext:()=>'',getStoredAiIdentity:()=> 'guest',trackAiQuestion:()=>{}}));
import ChatPanel from './ChatPanel';
afterEach(()=>{vi.restoreAllMocks();mocks.ask.mockClear()});
it('sends when browser storage is blocked',async()=>{
 vi.spyOn(Storage.prototype,'getItem').mockImplementation(()=>{throw new Error('blocked')});
 render(<ChatPanel title="Fixture" systemPrompt="Fixture" disclaimer="Educational" lang="en"/>);
 fireEvent.change(screen.getByRole('textbox'),{target:{value:'Fixture question'}});
 fireEvent.click(screen.getByRole('button',{name:'Send'}));
 await waitFor(()=>expect(mocks.ask).toHaveBeenCalledOnce());
 expect(await screen.findByText('Fixture answer')).toBeInTheDocument();
});
it('does not submit Enter while composing input',()=>{
 render(<ChatPanel title="Fixture" systemPrompt="Fixture" disclaimer="Educational" lang="en"/>);
 const input=screen.getAllByRole('textbox').at(-1)!;
 fireEvent.change(input,{target:{value:'Composing'}});
 fireEvent.keyDown(input,{key:'Enter',isComposing:true});
 expect(mocks.ask).not.toHaveBeenCalled();
});
