import type {ReactNode} from 'react';

import type {Option} from './types';

function FilterField({
  id,
  label,
  value,
  onChange,
  options,
}: {
  id: string;
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: Option[];
}) {
  return (
    <div className="space-y-2">
      <label htmlFor={id} className="block text-sm font-semibold text-slate-700 dark:text-slate-200">
        {label}
      </label>
      <select
        id={id}
        value={value}
        onChange={(event) => onChange(event.target.value)}
        className="w-full rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-sm text-slate-900 dark:text-white outline-none transition focus:border-health-green focus:ring-2 focus:ring-health-green/20"
      >
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </div>
  );
}

function Badge({children, tone = 'neutral'}: {children: ReactNode; tone?: 'neutral' | 'green' | 'blue'}) {
  const classes =
    tone === 'green'
      ? 'border-emerald-200 bg-emerald-50 text-emerald-700'
      : tone === 'blue'
        ? 'border-health-green/20 bg-health-green/10 text-health-green-dark'
        : 'border-slate-200 bg-slate-50 text-slate-600';

  return (
    <span className={`inline-flex items-center rounded-full border px-3 py-1 text-xs font-semibold ${classes}`}>
      {children}
    </span>
  );
}

function ChipGroup({
  label,
  value,
  onChange,
  options,
  colorMap,
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: Option[];
  colorMap?: Record<string, string>;
}) {
  return (
    <div className="space-y-2">
      <div className="text-sm font-semibold text-slate-700 dark:text-slate-200">{label}</div>
      <div className="flex flex-wrap gap-2">
        {options.map((option) => {
          const isActive = value === option.value;
          const color = colorMap?.[option.value] || '';
          return (
            <button
              key={option.value}
              type="button"
              onClick={() => onChange(option.value)}
              className={`rounded-2xl border px-3 py-1.5 text-xs font-semibold transition ${
                isActive
                  ? color || 'border-health-green bg-health-green/10 text-health-green'
                  : 'border-slate-200 bg-white text-slate-600 hover:border-slate-300'
              }`}
            >
              {option.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}

export {Badge, ChipGroup, FilterField};
