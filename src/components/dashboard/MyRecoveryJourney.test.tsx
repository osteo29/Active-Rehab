// @vitest-environment jsdom
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {MemoryRouter} from 'react-router-dom';
import {afterEach,describe,it,expect,vi} from 'vitest';
import {MyRecoveryJourney} from './MyRecoveryJourney';
const state=vi.hoisted(()=>({id:'a',pain:2}));
vi.mock('../../hooks/useMyRecovery',()=>({useMyRecovery:()=>{const journey=(id:string,pain:number)=>({id,injurySlug:id,injuryName:id,startedAt:'2026-11-23',currentPhase:1,totalPhases:1,painLevel:pain,phases:[{phaseNumber:1,goals:[]}],notes:[],painHistory:[]});return {journeys:[journey('a',2),journey('b',8)],activeJourney:journey(state.id,state.pain),setActiveJourneyId:vi.fn(),startJourney:vi.fn(),setPhase:vi.fn(),advancePhase:vi.fn(),toggleGoal:vi.fn(),logPain:vi.fn(),addNote:vi.fn(),deleteJourney:vi.fn()}}}));
afterEach(cleanup);
describe('pain editor belongs to selected journey',()=>{it('discards the prior unsaved reading when changing journeys',()=>{state.id='a';state.pain=2;const view=render(<MemoryRouter><MyRecoveryJourney lang="en"/></MemoryRouter>);expect((screen.getByRole('slider') as HTMLInputElement).value).toBe('2');fireEvent.change(screen.getByRole('slider'),{target:{value:'5'}});expect(screen.getByRole('button',{name:'Save Pain Reading (5/10)'})).not.toBeNull();state.id='b';state.pain=8;view.rerender(<MemoryRouter><MyRecoveryJourney lang="en"/></MemoryRouter>);expect((screen.getByRole('slider') as HTMLInputElement).value).toBe('8');expect(screen.queryByRole('button',{name:/Save Pain Reading/})).toBeNull()})});
