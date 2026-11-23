// @vitest-environment jsdom
import {renderHook} from '@testing-library/react';import {expect,it} from 'vitest';
import {useAppDerivedContent} from './useAppDerivedContent';
for(const lang of ['en','ar'] as const) it(`keeps the meal count distinct from protein grams in ${lang}`,()=>{
 const {result}=renderHook(()=>useAppDerivedContent({activeCalculator:'Macros',healthInterpretation:null,lang,result:{protein:100,carbs:200,fats:60,totalCalories:1740}}));
 const items=result.current.practicalGuide!.items;
 expect(items[0]).toContain('4');expect(items[0]).not.toContain('25');expect(items[1]).toContain('25');expect(items[1]).toContain('50');expect(items[1]).toContain('15');
});
