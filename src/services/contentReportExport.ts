import type {InjuryContentReport} from './injuryContentReport';
export function serializeContentReport(report: InjuryContentReport): string {
  return JSON.stringify({
    notice: 'Local content-structure report for editorial review. Missing fields are not proof of missing clinical care or treatment recommendations.',
    ...report,
  }, null, 2);
}
export function downloadContentReport(report: InjuryContentReport): void {
  const blob = new Blob([serializeContentReport(report)], {type: 'application/json;charset=utf-8'});
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = `active-rehab-content-report-${new Date().toISOString().slice(0,10)}.json`;
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}
