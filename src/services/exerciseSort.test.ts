import {describe,it,expect} from 'vitest';
import {sortExercises} from './exerciseSort';
import type {Exercise} from '../components/common/exercise-finder/types';
const make=(name:string,level:Exercise['level'],nameAr?:string):Exercise=>({name,level,nameAr,mainMuscle:'chest',muscles:[],equipment:'bodyweight',exerciseType:'strength',description:'',tips:''});
describe('exercise result sorting',()=>{
 it('keeps the original catalog untouched and sorts level before name',()=>{const input=[make('Z','advanced'),make('B','beginner'),make('A','beginner')];const sorted=sortExercises(input,'level','en');expect(sorted.map(e=>e.name)).toEqual(['A','B','Z']);expect(input[0].name).toBe('Z');expect(sortExercises(input,'catalog','en')).toBe(input)});
 it('sorts by available Arabic name with a stable fallback',()=>{const input=[make('Z','beginner','ب'),make('A','beginner','ا')];expect(sortExercises(input,'name','ar').map(e=>e.name)).toEqual(['A','Z'])});
});
