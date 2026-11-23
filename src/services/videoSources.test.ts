import {describe, expect, it} from 'vitest';
import sources from '../../docs/media/video-sources.json';
import videos from '../../json/body_iq_exercises_embed.json';
import muscles from '../../json/muscle_exercises_index.json';
describe('verified YouTube demo mappings', () => {
  it('retains the reviewed tutorial start sections', () => {
    expect(videos.find(v => v.id === 'EX-007')?.embedVideoUrl).toContain('start=180');
    expect(videos.find(v => v.id === 'EX-036')?.embedVideoUrl).toContain('start=208');
  });
  it('wires only verified exact matches and agrees across both catalogs', () => {
    for (const source of sources) {
      const video = videos.find(v => v.libraryId === source.libraryId)!;
      if (source.status !== 'verified') {
        expect(video.youtubeId).toBeNull();
        continue;
      }
      expect(source.playableInEmbed).toBe(true);
      expect(source.centralCheck).toBe(true);
      expect(video.youtubeId).toBe(source.youtubeId);
      expect(video.embedVideoUrl).toContain(`https://www.youtube.com/embed/${source.youtubeId}`);
      for (const groups of Object.values(muscles)) {
        for (const exercise of [...groups.primary, ...groups.stabilizer]) {
          if (exercise.id === source.libraryId) {
            expect(exercise.youtube_id).toBe(source.youtubeId);
            expect(exercise.embed_video_url).toBe(video.embedVideoUrl);
          }
        }
      }
    }
  });
});
