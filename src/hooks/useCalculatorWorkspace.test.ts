// @vitest-environment jsdom
import {act, renderHook} from '@testing-library/react';
import {beforeEach, afterEach, describe, expect, it, vi} from 'vitest';
import {useCalculatorWorkspace} from './useCalculatorWorkspace';
import {useArchitectProfile} from './useArchitectProfile';
import {translations} from '../services/translations';

const profile = {age:30,weight:75,height:175,gender:'male' as const,activityLevel:1.4,goal:'recovery' as const,injuryType:'acl_tear',recoveryWeek:3,sleepHours:8,waterIntake:2500,proteinCompliance:0.8};
function useWorkspace() {
  return useCalculatorWorkspace({architectProfile:profile,initialArchitectProfile:profile,lang:'en',setArchitectProfile:vi.fn(),t:translations.en});
}
describe('calculator state safety', () => {
 beforeEach(() => localStorage.clear());
 afterEach(() => vi.restoreAllMocks());
 it('removes the previous result when the input is no longer valid', () => {
  const {result}=renderHook(useWorkspace);
  expect(result.current.result).not.toBeNull();
  act(()=>result.current.setHeight('0'));
  expect(result.current.result).toBeNull();
  expect(result.current.healthInterpretation).toBeNull();
 });
 it('clears a meal total after the last calories are removed', () => {
  const {result}=renderHook(useWorkspace);
  act(()=>{result.current.setActiveCalculator('Meal');result.current.setMealItems([{id:'1',name:'food',calories:'200'}]);});
  expect(result.current.result).toBe(200);
  act(()=>result.current.setMealItems([{id:'1',name:'',calories:''}]));
  expect(result.current.result).toBeNull();
 });
 it('ignores malformed saved custom food entries instead of crashing search', () => {
  localStorage.setItem('physiohub_custom_foods',JSON.stringify([null,{}, {name:{en:1,ar:null}}, {id:'bad',name:{en:'bad',ar:'bad'},calories:-1}]));
  const {result}=renderHook(useWorkspace);
  expect(result.current.filteredFoods.length).toBeGreaterThan(0);
 });
 it('opens the profile and calculators when browser storage is blocked', () => {
  vi.spyOn(Storage.prototype,'getItem').mockImplementation(()=>{throw new DOMException('Blocked','SecurityError')});
  expect(()=>renderHook(useArchitectProfile)).not.toThrow();
  expect(()=>renderHook(useWorkspace)).not.toThrow();
 });
});
