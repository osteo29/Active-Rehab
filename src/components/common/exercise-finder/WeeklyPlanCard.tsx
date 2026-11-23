import {CalendarRange} from 'lucide-react';
import {Link} from 'react-router-dom';

import type {Language} from '../../../services/translations';
import {navigationPaths} from '../../../utils/langUrlHelper';
import {getExerciseRegion} from './content';
import {EXERCISES} from './data/exercises';
import {Badge} from './FilterField';
import {toTitle} from './filter-utils';
import type {WeeklyPlan} from './types';

function WeeklyPlanCard({
  title,
  titleAr,
  plan,
  isAr,
  lang,
}: {
  title: string;
  titleAr: string;
  plan: WeeklyPlan;
  isAr: boolean;
  lang: Language;
}) {
  return (
    <article className="rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
      <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
        <CalendarRange className="h-4 w-4 text-health-green" />
        <span>{isAr ? 'مثال أسبوعي' : 'Weekly example'}</span>
      </div>
      <h3 className="mt-3 text-xl font-bold text-slate-900">{isAr ? titleAr : title}</h3>

      <div className="mt-5 grid gap-3">
        {plan.days.map((item) => (
          <div key={`${plan.systemId}-${item.day}`} className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div className="text-sm font-bold text-slate-900">{isAr ? item.dayAr : item.day}</div>
              <Badge>{isAr ? item.titleAr : item.title}</Badge>
            </div>
            <p className="mt-2 text-sm leading-7 text-slate-600">{isAr ? item.detailsAr : item.details}</p>
            <div className="mt-3 rounded-2xl border border-health-green/15 bg-health-green/5 px-4 py-3">
              <div className="text-xs font-bold uppercase tracking-[0.14em] text-health-green-dark">
                {isAr ? 'هدف الحصة' : 'Session goal'}
              </div>
              <p className="mt-1 text-sm text-slate-700">{isAr ? item.sessionGoalAr : item.sessionGoal}</p>
            </div>

            <div className="mt-3 space-y-3">
              {item.prescriptions.map((prescription) => {
                const linkedExercise = EXERCISES.find((exercise) => exercise.name === prescription.exerciseName);
                const exerciseRegion = linkedExercise ? getExerciseRegion(linkedExercise) : null;

                return (
                  <div key={`${item.day}-${prescription.exerciseName}`} className="rounded-2xl border border-slate-200 bg-white p-4">
                    <div className="flex flex-wrap items-start justify-between gap-2">
                      <div>
                        {exerciseRegion ? (
                          <Link
                            to={navigationPaths.exercisesMuscle(lang, exerciseRegion)}
                            className="text-sm font-bold text-slate-900 transition hover:text-health-green"
                          >
                            {prescription.exerciseName}
                          </Link>
                        ) : (
                          <div className="text-sm font-bold text-slate-900">{prescription.exerciseName}</div>
                        )}
                        {linkedExercise ? (
                          <div className="mt-1 text-xs text-slate-500">
                            {toTitle(linkedExercise.mainMuscle)} • {linkedExercise.equipment} • {linkedExercise.exerciseType}
                          </div>
                        ) : null}
                      </div>
                      <Badge tone="blue">{isAr ? `${prescription.sets} مجموعات` : `${prescription.sets} sets`}</Badge>
                    </div>

                    <div className="mt-3 grid gap-2 text-sm text-slate-700 sm:grid-cols-3">
                      <div className="rounded-xl bg-slate-50 px-3 py-2">
                        <span className="font-semibold">{isAr ? 'التكرارات:' : 'Reps:'}</span>{' '}
                        <bdi className="[unicode-bidi:isolate]">{prescription.reps}</bdi>
                      </div>
                      <div className="rounded-xl bg-slate-50 px-3 py-2">
                        <span className="font-semibold">{isAr ? 'الراحة:' : 'Rest:'}</span>{' '}
                        <bdi className="[unicode-bidi:isolate]">{prescription.rest}</bdi>
                      </div>
                      <div className="rounded-xl bg-slate-50 px-3 py-2">
                        <span className="font-semibold">{isAr ? 'التحميل:' : 'Load:'}</span>{' '}
                        {isAr ? 'اترك 1-2 عدة في الاحتياط' : 'Leave 1-2 reps in reserve'}
                      </div>
                    </div>

                    <p className="mt-3 text-sm leading-7 text-slate-600">{isAr ? prescription.notesAr : prescription.notes}</p>

                    {exerciseRegion ? (
                      <Link
                        to={navigationPaths.exercisesMuscle(lang, exerciseRegion)}
                        className="mt-3 inline-flex items-center gap-2 text-xs font-bold uppercase tracking-[0.14em] text-health-green transition hover:text-health-green-dark"
                      >
                        {isAr ? 'افتح صفحة المنطقة والتمارين' : 'Open region exercise page'}
                      </Link>
                    ) : null}
                  </div>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    </article>
  );
}

export {WeeklyPlanCard};
