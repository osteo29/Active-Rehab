import {Layers3} from 'lucide-react';

import {Badge} from './FilterField';
import type {TrainingSystem} from './types';

function TrainingSystemCard({
  system,
  isAr,
}: {
  system: TrainingSystem;
  isAr: boolean;
}) {
  return (
    <article className={`overflow-hidden rounded-[1.75rem] border p-5 sm:p-6 ${system.accent}`}>
      <div className="flex h-full flex-col gap-4">
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div>
            <div className="inline-flex items-center gap-2 rounded-full border border-white/70 bg-white/70 dark:bg-slate-900/70 px-3 py-1 text-[11px] font-bold uppercase tracking-[0.18em] text-slate-700 dark:text-slate-200">
              <Layers3 className="h-3.5 w-3.5" />
              <span>{isAr ? 'نظام تدريبي' : 'Training system'}</span>
            </div>
            <h3 className="mt-3 text-xl font-bold text-slate-900 dark:text-white">{isAr ? system.titleAr : system.title}</h3>
          </div>
          <Badge tone="blue">{isAr ? system.frequencyAr : system.frequency}</Badge>
        </div>

        <p className="text-sm leading-7 text-slate-700 dark:text-slate-200">{isAr ? system.summaryAr : system.summary}</p>

        <div className="grid gap-3 sm:grid-cols-2">
          <div className="rounded-2xl border border-white/70 bg-white/70 dark:bg-slate-900/70 p-4">
            <div className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
              {isAr ? 'التقسيم' : 'Split'}
            </div>
            <div className="mt-2 text-sm font-semibold text-slate-900 dark:text-white">{isAr ? system.splitAr : system.split}</div>
          </div>
          <div className="rounded-2xl border border-white/70 bg-white/70 dark:bg-slate-900/70 p-4">
            <div className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
              {isAr ? 'الاستشفاء' : 'Recovery'}
            </div>
            <div className="mt-2 text-sm font-semibold text-slate-900 dark:text-white">
              {isAr ? system.recoveryAr : system.recovery}
            </div>
          </div>
        </div>

        <div className="rounded-2xl border border-white/70 bg-white/65 p-4">
          <div className="text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
            {isAr ? 'مناسب لـ' : 'Ideal for'}
          </div>
          <p className="mt-2 text-sm text-slate-700 dark:text-slate-200">{isAr ? system.idealForAr : system.idealFor}</p>
        </div>
      </div>
    </article>
  );
}

export {TrainingSystemCard};
