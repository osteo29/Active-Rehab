import {describe, expect, it} from 'vitest';

import type {InjuryPhase, InjuryProtocol} from './injuryDatabase';
import {getNutritionGoalMatches} from './injuryNutritionMatcher';

function makePhase(overrides: Partial<InjuryPhase> = {}): InjuryPhase {
  return {
    id: 'p1',
    label: 'Acute phase',
    duration: '1 week',
    window: 'days_3_14',
    goals: [],
    nutritionFocus: [],
    recommendedFoods: [],
    avoidFoods: [],
    supplements: [],
    exercises: [],
    prohibitedMovements: [],
    meals: {breakfast: [], lunch: [], dinner: [], snacks: []},
    ...overrides,
  } as InjuryPhase;
}

function makeInjury(overrides: Partial<InjuryProtocol> = {}): InjuryProtocol {
  return {
    id: 'test-injury',
    name: 'Test Injury',
    category: 'Muscle',
    bodyRegion: 'Knee',
    commonIn: [],
    overview: '',
    rehabSummary: '',
    redFlags: [],
    relatedCalculators: [],
    safetyNotes: {medications: [], supplements: []},
    phases: [],
    ...overrides,
  } as InjuryProtocol;
}

describe('getNutritionGoalMatches', () => {
  it('always includes recovery calories', () => {
    const matches = getNutritionGoalMatches(makeInjury(), makePhase());
    expect(matches.some((m) => m.key === 'recovery-calories')).toBe(true);
  });

  it('flags anti-inflammatory support in the first 48 hours', () => {
    const matches = getNutritionGoalMatches(makeInjury(), makePhase({window: 'under_48h'}));
    const antiInflammatory = matches.find((m) => m.key === 'anti-inflammatory');
    expect(antiInflammatory).toBeDefined();
    expect(antiInflammatory?.priority).toBe(95);
  });

  it('flags tendon healing for tendon-category injuries', () => {
    const matches = getNutritionGoalMatches(makeInjury({category: 'Tendon'}), makePhase());
    expect(matches[0].key).toBe('tendon-healing');
    expect(matches[0].priority).toBe(100);
  });

  it('flags tendon healing when the phase prescribes collagen', () => {
    const matches = getNutritionGoalMatches(
      makeInjury(),
      makePhase({collagenPerKg: {min: 0.3, max: 0.5}}),
    );
    expect(matches.some((m) => m.key === 'tendon-healing')).toBe(true);
  });

  it('flags bone repair for bone-category injuries', () => {
    const matches = getNutritionGoalMatches(makeInjury({category: 'Bone'}), makePhase());
    expect(matches[0].key).toBe('bone-repair');
  });

  it('detects keyword matches in phase text', () => {
    const matches = getNutritionGoalMatches(
      makeInjury(),
      makePhase({nutritionFocus: ['Manage swelling and inflammation']}),
    );
    expect(matches.some((m) => m.key === 'anti-inflammatory')).toBe(true);
  });

  it('returns unique keys sorted by descending priority', () => {
    const matches = getNutritionGoalMatches(
      makeInjury({category: 'Bone', overview: 'fracture with swelling'}),
      makePhase({window: 'under_48h'}),
    );
    const keys = matches.map((m) => m.key);
    expect(new Set(keys).size).toBe(keys.length);
    const priorities = matches.map((m) => m.priority);
    expect(priorities).toEqual([...priorities].sort((a, b) => b - a));
  });
});
