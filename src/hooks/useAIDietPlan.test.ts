// @vitest-environment jsdom
import {act,renderHook} from '@testing-library/react';
import {afterEach,expect,it,vi} from 'vitest';
import {useAIDietPlan} from './useAIDietPlan';
import type {HealthMetrics,HealthProfile} from '../logic/physioNutritionEngine';
const mocks=vi.hoisted(()=>({ask:vi.fn()}));
vi.mock('../ai/gemini',()=>({askGeminiText:mocks.ask}));
afterEach(()=>vi.resetAllMocks());
function setup(lang:'en'|'ar'='en') {return renderHook(()=>useAIDietPlan({architectMetrics:{bmi:22,macros:{protein:100,carbs:200,fats:60,totalCalories:2000}} as HealthMetrics,architectProfile:{} as HealthProfile,lang}))}
it('does not invent a plan when generation fails',async()=>{mocks.ask.mockRejectedValue(new Error('unavailable'));const {result}=setup();await act(async()=>result.current.generateAIDietPlan());expect(result.current.aiDietPlan).toContain('No personalized plan');expect(result.current.aiDietPlan).not.toMatch(/4000|Collagen|Vitamin D|3\/10/);expect(result.current.isGeneratingPlan).toBe(false)});
it('rejects short unusable replies in Arabic',async()=>{mocks.ask.mockResolvedValue('');const {result}=setup('ar');await act(async()=>result.current.generateAIDietPlan());expect(result.current.aiDietPlan).toContain('لم يتم إنشاء خطة شخصية')});
it('preserves a successful response',async()=>{const answer='A synthetic successful response for this test only. '.repeat(2);mocks.ask.mockResolvedValue(answer);const {result}=setup();await act(async()=>result.current.generateAIDietPlan());expect(result.current.aiDietPlan).toBe(answer)});
