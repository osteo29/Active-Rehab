import {expect,it} from 'vitest';
import {serializeContentReport} from './contentReportExport';
import type {InjuryContentReport} from './injuryContentReport';
it('exports structured editorial evidence with its nonclinical scope',()=>{
 const report={generatedAt:'2026-11-23',totals:{injuries:100},topMissingContent:[{name:'اختبار',reasons:['Missing field']}]} as InjuryContentReport;
 const output=JSON.parse(serializeContentReport(report));
 expect(output.notice).toContain('editorial review');
 expect(output.totals.injuries).toBe(100);
 expect(output.topMissingContent[0].name).toBe('اختبار');
});
