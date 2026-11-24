import {describe, expect, it} from 'vitest';

import type {AssessmentRecord} from '../lib/supabase';
import {
  buildDashboardSnapshot,
  buildMetricGroups,
  buildMetricInsight,
  filterRecordsByRange,
} from './dashboardInsights';

function record(overrides: Partial<AssessmentRecord>): AssessmentRecord {
  return {
    id: Math.random().toString(36).slice(2),
    created_at: new Date().toISOString(),
    user_id: 'u1',
    name: null,
    email: null,
    calculator_type: 'bmi',
    value_label: '22.9',
    value_numeric: 22.9,
    value_unit: 'kg/m2',
    lang: 'en',
    note: null,
    ...overrides,
  };
}

function daysAgo(n: number) {
  return new Date(Date.now() - n * 24 * 60 * 60 * 1000).toISOString();
}

describe('filterRecordsByRange', () => {
  const records = [
    record({created_at: daysAgo(3)}),
    record({created_at: daysAgo(20)}),
    record({created_at: daysAgo(60)}),
  ];

  it('keeps everything for all', () => {
    expect(filterRecordsByRange(records, 'all')).toHaveLength(3);
  });

  it('filters to 14 or 30 days', () => {
    expect(filterRecordsByRange(records, '14d')).toHaveLength(1);
    expect(filterRecordsByRange(records, '30d')).toHaveLength(2);
  });
});

describe('buildMetricGroups', () => {
  it('groups by calculator type and unit, skipping non-numeric values', () => {
    const groups = buildMetricGroups([
      record({value_numeric: 20, created_at: daysAgo(1)}),
      record({value_numeric: 21, created_at: daysAgo(2)}),
      record({calculator_type: 'water', value_unit: 'ml', value_numeric: 2500, created_at: daysAgo(1)}),
      record({value_numeric: null}),
      record({value_numeric: Number.NaN}),
    ]);
    expect(groups).toHaveLength(2);
    const bmi = groups.find((g) => g.key === 'bmi::kg/m2');
    expect(bmi?.records).toHaveLength(2);
    expect(bmi?.label).toBe('bmi (kg/m2)');
  });

  it('treats missing and blank units as no-unit', () => {
    const groups = buildMetricGroups([
      record({value_unit: null}),
      record({value_unit: '  '}),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0].key).toBe('bmi::no-unit');
    expect(groups[0].records).toHaveLength(2);
  });

  it('sorts groups by record count descending', () => {
    const groups = buildMetricGroups([
      record({calculator_type: 'water', value_unit: 'ml'}),
      record({}),
      record({}),
    ]);
    expect(groups[0].key).toBe('bmi::kg/m2');
  });
});

describe('buildDashboardSnapshot', () => {
  it('summarizes tracked metrics and recent activity', () => {
    const records = [record({created_at: daysAgo(2)}), record({created_at: daysAgo(40)})];
    const groups = buildMetricGroups(records);
    const snapshot = buildDashboardSnapshot(records, groups);
    expect(snapshot.trackedMetricCount).toBe(1);
    expect(snapshot.recentRecordCount).toBe(1);
    expect(snapshot.mostTrackedLabel).toBe('bmi (kg/m2)');
    expect(snapshot.mostTrackedCount).toBe(2);
  });

  it('handles empty history', () => {
    const snapshot = buildDashboardSnapshot([], []);
    expect(snapshot).toEqual({
      trackedMetricCount: 0,
      recentRecordCount: 0,
      mostTrackedLabel: null,
      mostTrackedCount: 0,
      latestRecordLabel: null,
    });
  });
});

describe('buildMetricInsight', () => {
  it('returns null without records', () => {
    expect(buildMetricInsight(null, 'en')).toBeNull();
  });

  it('asks for a second reading when only one exists', () => {
    const groups = buildMetricGroups([record({})]);
    const insight = buildMetricInsight(groups[0], 'en');
    expect(insight?.tone).toBe('neutral');
    expect(insight?.title).toMatch(/one more reading/i);
  });

  it('warns on an aggressive calorie deficit', () => {
    const groups = buildMetricGroups([
      record({calculator_type: 'deficit', value_unit: 'kcal', value_numeric: 900, created_at: daysAgo(1)}),
      record({calculator_type: 'deficit', value_unit: 'kcal', value_numeric: 600, created_at: daysAgo(10)}),
    ]);
    const insight = buildMetricInsight(groups[0], 'en');
    expect(insight?.tone).toBe('caution');
    expect(insight?.title).toMatch(/aggressive/i);
  });

  it('warns when a low hydration target is logged', () => {
    const groups = buildMetricGroups([
      record({calculator_type: 'water', value_unit: 'ml', value_numeric: 1500, created_at: daysAgo(1)}),
      record({calculator_type: 'water', value_unit: 'ml', value_numeric: 2100, created_at: daysAgo(5)}),
    ]);
    expect(buildMetricInsight(groups[0], 'en')?.tone).toBe('caution');
  });

  it('warns on fast downward BMI changes within three weeks', () => {
    const groups = buildMetricGroups([
      record({value_numeric: 23.5, created_at: daysAgo(1)}),
      record({value_numeric: 25, created_at: daysAgo(7)}),
    ]);
    expect(buildMetricInsight(groups[0], 'en')?.tone).toBe('caution');
  });

  it('reports a stable trend for unchanged values', () => {
    const groups = buildMetricGroups([
      record({value_numeric: 22.9, created_at: daysAgo(1)}),
      record({value_numeric: 22.9, created_at: daysAgo(7)}),
    ]);
    const insight = buildMetricInsight(groups[0], 'en');
    expect(insight?.tone).toBe('neutral');
    expect(insight?.title).toMatch(/stable/i);
  });
});
