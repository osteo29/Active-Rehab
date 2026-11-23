// @vitest-environment jsdom
import {act,renderHook,cleanup} from '@testing-library/react';
import {afterEach,beforeEach,describe,it,expect,vi} from 'vitest';
import {useSavedExercises,exerciseBookmarkKey} from './useSavedExercises';
beforeEach(()=>localStorage.clear());afterEach(()=>{cleanup();vi.restoreAllMocks()});
describe('local exercise bookmarks',()=>{
 it('saves and removes bookmarks across mounted views and reloads',()=>{const a=renderHook(useSavedExercises),b=renderHook(useSavedExercises);const key=exerciseBookmarkKey({mainMuscle:'chest',name:'Press'});act(()=>a.result.current.toggle(key));expect(b.result.current.saved).toEqual([key]);const c=renderHook(useSavedExercises);expect(c.result.current.saved).toEqual([key]);act(()=>b.result.current.toggle(key));expect(a.result.current.saved).toEqual([])});
 it('ignores corrupt and nonstring saved entries',()=>{localStorage.setItem('activerehab_saved_exercises_v1','[null,{},"a","a",5]');const {result}=renderHook(useSavedExercises);expect(result.current.saved).toEqual(['a'])});
 it('keeps in-memory saves usable when storage is blocked',()=>{vi.spyOn(Storage.prototype,'setItem').mockImplementation(()=>{throw new Error('blocked')});const {result}=renderHook(useSavedExercises);act(()=>result.current.toggle('a'));expect(result.current.saved).toEqual(['a']);expect(result.current.storageUnavailable).toBe(true)});
 it('responds to storage changes from another tab',()=>{const {result}=renderHook(useSavedExercises);act(()=>{localStorage.setItem('activerehab_saved_exercises_v1','["b"]');window.dispatchEvent(new StorageEvent('storage',{key:'activerehab_saved_exercises_v1'}))});expect(result.current.saved).toEqual(['b'])});
});
