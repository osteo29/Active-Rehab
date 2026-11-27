import {describe, expect, it} from 'vitest';
import protocols from '../../json/protocols_v3.json';
import library from '../../json/library_v3.json';
import sourceMap from '../../docs/clinical/source-map.json';

describe('source-mapped clinical drafts', () => {
  it('keeps every change tied to a source and clinician-review warning', () => {
    const ids = new Set(library.map(e => e.id));
    for (const entry of sourceMap) {
      const protocol = protocols.find(p => p.id === entry.protocol_id)!;
      const phase = protocol.phases.find(p => p.phase_number === entry.phase)!;
      expect(protocol.metadata.reviewed_by).toContain('Pending clinician review');
      expect(phase.precautions.join(' ')).toContain(entry.source);
      expect(phase.precautions.join(' ')).toContain('clinician review');
      phase.exercises.forEach(e => expect(ids.has(e.exercise_ref)).toBe(true));
    }
  });
  it('does not imply that replacement joints are cleared for running', () => {
    const tka = protocols.find(p => p.id === 7)!.phases[3];
    expect(tka.precautions.join(' ')).toContain('generally discouraged');
    expect(tka.exercises).toHaveLength(2);
  });
  it('does not fill unrelated conditions by analogy', () => {
    for (const id of [48,49,87,95,96]) expect((protocols.find(p => p.id === id)!.phases[3]?.exercises ?? [])).toHaveLength(0);
  });
});
