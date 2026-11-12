// @vitest-environment jsdom
import {describe, it, expect, beforeEach} from 'vitest';
import {renderHook, act} from '@testing-library/react';
import {useMyRecovery} from './useMyRecovery';

describe('useMyRecovery hook', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('starts with empty journeys', () => {
    const {result} = renderHook(() => useMyRecovery());
    expect(result.current.journeys).toEqual([]);
    expect(result.current.activeJourney).toBeNull();
  });

  it('allows starting a new recovery journey and tracking it', () => {
    const {result} = renderHook(() => useMyRecovery());

    act(() => {
      result.current.startJourney({
        injurySlug: 'acl-tear',
        injuryName: 'ACL Tear',
        injuryNameAr: 'تمزق الرباط الصليبي',
        bodyRegion: 'Knee',
        totalPhases: 3,
        initialPain: 6,
      });
    });

    expect(result.current.journeys.length).toBe(1);
    expect(result.current.activeJourney).not.toBeNull();
    expect(result.current.activeJourney?.injurySlug).toBe('acl-tear');
    expect(result.current.activeJourney?.currentPhase).toBe(1);
    expect(result.current.activeJourney?.totalPhases).toBe(3);
    expect(result.current.activeJourney?.painLevel).toBe(6);
    expect(result.current.isInjuryTracked('acl-tear')).toBe(true);
  });

  it('allows advancing phases and logging pain', () => {
    const {result} = renderHook(() => useMyRecovery());

    let journeyId = '';
    act(() => {
      const j = result.current.startJourney({
        injurySlug: 'ankle-sprain',
        injuryName: 'Ankle Sprain',
        totalPhases: 3,
        initialPain: 7,
      });
      journeyId = j.id;
    });

    act(() => {
      result.current.advancePhase(journeyId);
    });

    expect(result.current.activeJourney?.currentPhase).toBe(2);

    act(() => {
      result.current.logPain(journeyId, 3);
    });

    expect(result.current.activeJourney?.painLevel).toBe(3);
    expect(result.current.activeJourney?.painHistory.length).toBe(2);
  });

  it('supports adding recovery notes', () => {
    const {result} = renderHook(() => useMyRecovery());

    let journeyId = '';
    act(() => {
      const j = result.current.startJourney({
        injurySlug: 'rotator-cuff',
        injuryName: 'Rotator Cuff',
      });
      journeyId = j.id;
    });

    act(() => {
      result.current.addNote(journeyId, 'Exercised with green resistance band, 0 pain');
    });

    expect(result.current.activeJourney?.notes.length).toBe(1);
    expect(result.current.activeJourney?.notes[0].text).toContain('green resistance band');
  });
});
