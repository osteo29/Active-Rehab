import type {RecoveryJourney} from '../hooks/useMyRecovery';
function cell(value:unknown):string {
 const raw=String(value??'');
 // CSV can execute spreadsheet formulas even in quoted cells. Treat all content as text.
 const safe=/^[\s]*[=+\-@\t\r]/.test(raw)?`'${raw}`:raw;
 return `"${safe.replaceAll('"','""')}"`;
}
export function buildRecoveryCsv(journey:RecoveryJourney,lang:'en'|'ar'='en'):string {
 const ar=lang==='ar';
 const rows:unknown[][]=[
  ar?['سجل شخصي للتعافي، ليس تقييمًا طبيًا']:['Personal recovery log, not a clinical assessment'],
  ar?['الإصابة','تاريخ البدء','المرحلة المسجلة','عدد المراحل','الحالة']:['Condition','Started at','Recorded phase','Total phases','Status'],
  [ar?(journey.injuryNameAr||journey.injuryName):journey.injuryName,journey.startedAt,journey.currentPhase,journey.totalPhases,journey.status],
  [],ar?['التاريخ','درجة الألم المسجلة (0-10)']:['Date','Self-reported pain (0-10)'],
  ...journey.painHistory.map(entry=>[entry.date,entry.level]),
  [],ar?['تاريخ الملاحظة','الملاحظة']:['Note date','Note'],
  ...journey.notes.map(note=>[note.date,note.text]),
 ];
 return '\uFEFF'+rows.map(row=>row.map(cell).join(',')).join('\r\n');
}
export function downloadRecoveryCsv(journey:RecoveryJourney,lang:'en'|'ar'){
 const url=URL.createObjectURL(new Blob([buildRecoveryCsv(journey,lang)],{type:'text/csv;charset=utf-8'}));
 const anchor=document.createElement('a');anchor.href=url;anchor.download='active-rehab-recovery-log.csv';document.body.appendChild(anchor);anchor.click();anchor.remove();window.setTimeout(()=>URL.revokeObjectURL(url),1000);
}
