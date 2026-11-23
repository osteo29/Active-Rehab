// @vitest-environment jsdom
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {MemoryRouter} from 'react-router-dom';
import {afterEach,describe,it,expect,vi} from 'vitest';
import {ExerciseFinder} from './ExerciseFinder';
vi.mock('../../seo/Seo',()=>({default:()=>null}));
vi.mock('../../../hooks/useExerciseCatalog',()=>({useExerciseCatalog:()=>({loading:false,error:null,exercises:Array.from({length:30},(_,i)=>({name:`Exercise ${i}`,mainMuscle:'chest',muscles:['chest'],level:'beginner',equipment:'bodyweight',exerciseType:'strength',description:'Description',tips:'Cue'}))})}));
afterEach(cleanup);
describe('exercise result batching',()=>{it('renders a small initial batch and expands without hiding results from filtering',()=>{const {container}=render(<MemoryRouter><ExerciseFinder enableSeo={false}/></MemoryRouter>);expect(container.querySelectorAll('article').length).toBe(12);fireEvent.click(screen.getByRole('button',{name:'Show 12 more exercises'}));expect(container.querySelectorAll('article').length).toBe(24);fireEvent.click(screen.getByRole('button',{name:'Show 12 more exercises'}));expect(container.querySelectorAll('article').length).toBe(30);expect(screen.queryByRole('button',{name:'Show 12 more exercises'})).toBeNull()})});
