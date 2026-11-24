import {existsSync} from 'node:fs';
import {join} from 'node:path';

import {describe, expect, it} from 'vitest';

import exercises from '../../json/body_iq_exercises_embed.json';
import musclesLibrary from '../../json/muscles_library.json';

const muscles = Object.values((musclesLibrary as {muscles: Record<string, unknown>}).muscles) as Array<{
  id: string;
  slug: string;
  name: string;
  name_ar: string;
  image_url?: string;
}>;

describe('muscles library integrity', () => {
  it('has unique slugs and ids', () => {
    const slugs = muscles.map((m) => m.slug);
    const ids = muscles.map((m) => m.id);
    expect(new Set(slugs).size).toBe(slugs.length);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('names every muscle in English and Arabic', () => {
    for (const m of muscles) {
      expect(m.name.trim(), `${m.slug} name`).not.toBe('');
      expect(m.name_ar.trim(), `${m.slug} name_ar`).not.toBe('');
    }
  });

  it('resolves every muscle image to an existing public asset', () => {
    for (const m of muscles) {
      if (m.image_url!.startsWith('/anatomy/')) {
        expect(
          existsSync(join(__dirname, '../../public', m.image_url!)),
          `${m.slug} missing file ${m.image_url}`,
        ).toBe(true);
      } else {
        expect(m.image_url, `${m.slug} image_url`).toMatch(/^https:\/\/upload\.wikimedia\.org\//);
      }
    }
  });
});

describe('exercise catalog integrity', () => {
  it('has unique ids and library ids', () => {
    const ids = exercises.map((e) => e.id);
    const libraryIds = exercises.map((e) => e.libraryId);
    expect(new Set(ids).size).toBe(ids.length);
    expect(new Set(libraryIds).size).toBe(libraryIds.length);
  });

  it('names every exercise in English and Arabic', () => {
    for (const e of exercises) {
      expect(e.nameEn.trim(), `${e.id} nameEn`).not.toBe('');
      expect(e.nameAr.trim(), `${e.id} nameAr`).not.toBe('');
    }
  });

  it('keeps youtubeId and embedVideoUrl consistent when present', () => {
    for (const e of exercises) {
      if (e.youtubeId == null && e.embedVideoUrl == null) continue;
      expect(e.youtubeId, `${e.id} youtubeId`).toMatch(/^[\w-]{6,}$/);
      expect(e.embedVideoUrl, `${e.id} embedVideoUrl`).toContain(`https://www.youtube.com/embed/${e.youtubeId}`);
    }
  });

  it('keeps a coaching cue on every exercise', () => {
    for (const e of exercises) {
      expect(e.coachingCue.trim(), `${e.id} coachingCue`).not.toBe('');
    }
  });
});
