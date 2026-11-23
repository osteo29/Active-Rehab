// @vitest-environment jsdom
import {describe, it, expect, beforeEach, vi} from 'vitest';
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


describe('saved recovery data validation', () => {
 beforeEach(() => localStorage.clear());
 it.each(['null','{}','[null, {}, 4]','[1,2,3]'])('ignores invalid stored shape %s', value => {
   localStorage.setItem('physionut_my_recovery_v1', value);
   const {result} = renderHook(() => useMyRecovery());
   expect(result.current.journeys).toEqual([]);
 });
 it('ignores nonfinite pain and phase values', () => {
   const {result} = renderHook(() => useMyRecovery());let id='';
   act(()=>{id=result.current.startJourney({injurySlug:'test',injuryName:'Test',initialPain:4}).id});
   act(()=>{result.current.logPain(id,Number.NaN);result.current.setPhase(id,Number.NaN)});
   expect(result.current.activeJourney?.painLevel).toBe(4);
   expect(result.current.activeJourney?.currentPhase).toBe(1);
 });
 it('retains a valid journey across remount', () => {
   const first=renderHook(()=>useMyRecovery());
   act(()=>{first.result.current.startJourney({injurySlug:'test',injuryName:'Test'})});
   first.unmount();const second=renderHook(()=>useMyRecovery());
   expect(second.result.current.journeys).toHaveLength(1);
 });
describe('personal note management',()=>{
 beforeEach(()=>localStorage.clear());
 it('edits and deletes only the selected note without deleting the journey',()=>{const {result}=renderHook(()=>useMyRecovery());let id='';act(()=>{id=result.current.startJourney({injurySlug:'test',injuryName:'Test'}).id});act(()=>result.current.addNote(id,'Original'));const noteId=result.current.activeJourney!.notes[0].id;act(()=>result.current.editNote(id,noteId,'Updated'));expect(result.current.activeJourney?.notes[0].text).toBe('Updated');act(()=>result.current.editNote(id,noteId,'  '));expect(result.current.activeJourney?.notes[0].text).toBe('Updated');act(()=>result.current.deleteNote(id,noteId));expect(result.current.activeJourney?.notes).toEqual([]);expect(result.current.journeys).toHaveLength(1)});
});

describe('storage persistence warning',()=>{
 it('warns when device storage rejects recovery changes',()=>{
  const spy=vi.spyOn(Storage.prototype,'setItem').mockImplementation(()=>{throw new Error('quota')});
  try {const {result}=renderHook(()=>useMyRecovery());expect(result.current.storageError).toBe(true);}
  finally {spy.mockRestore();}
 });
});

describe('recovery note identifiers',()=>{
 it('keeps rapid notes independently addressable',()=>{
  const now=vi.spyOn(Date,'now').mockReturnValue(123456);
  try {const {result}=renderHook(()=>useMyRecovery());let id='';act(()=>{id=result.current.startJourney({injurySlug:'test',injuryName:'Test'}).id});act(()=>{result.current.addNote(id,'First');result.current.addNote(id,'Second')});const notes=result.current.activeJourney!.notes;expect(notes).toHaveLength(2);expect(new Set(notes.map(note=>note.id)).size).toBe(2);}
  finally {now.mockRestore()}
 });
});
});
