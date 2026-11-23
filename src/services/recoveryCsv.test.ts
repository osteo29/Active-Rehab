import {describe,it,expect} from 'vitest';
import {buildRecoveryCsv} from './recoveryCsv';
import type {RecoveryJourney} from '../hooks/useMyRecovery';
const journey:RecoveryJourney={id:'1',injurySlug:'test',injuryName:'Example, condition',injuryNameAr:'حالة',currentPhase:1,totalPhases:3,startedAt:'2026-11-23T12:00:00Z',updatedAt:'2026-11-23T12:00:00Z',painLevel:4,painHistory:[{date:'2026-11-23T12:00:00Z',level:4}],notes:[{id:'1',date:'2026-11-23',text:'Line 1\n"quoted", note'}],phases:[],status:'active'};
describe('recovery CSV export',()=>{
 it('includes only the selected journey fields with UTF-8 BOM and escaped cells',()=>{const text=buildRecoveryCsv(journey);expect(text.startsWith('\uFEFF')).toBe(true);expect(text).toContain('"Example, condition"');expect(text).toContain('"Line 1\n""quoted"", note"');expect(text).toContain('Self-reported pain (0-10)');expect(text).not.toContain('injurySlug')});
 it.each(['=HYPERLINK("x")','+cmd','-cmd','@SUM(A1)','  =SUM(1)','\tformula'])('neutralizes spreadsheet formulas %s',note=>{const text=buildRecoveryCsv({...journey,notes:[{id:'1',date:'2026',text:note}]});expect(text).toContain('"\''+note.replaceAll('"','""')+'"')});
 it('supports Arabic headers and preserves personal notes',()=>{const text=buildRecoveryCsv(journey,'ar');expect(text).toContain('سجل شخصي');expect(text).toContain('"حالة"');expect(text).toContain('quoted')});
});
