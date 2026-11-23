import {describe, expect, it} from 'vitest';
import {existsSync} from 'node:fs';
import {getAllMuscles} from './exerciseBiomechanicsService';
const added = ['internal-oblique', 'transverse-abdominis', 'quadratus-lumborum', 'multifidus', 'coccygeus', 'gemellus-inferior', 'iliacus', 'adductor-longus', 'adductor-brevis', 'adductor-magnus', 'gracilis', 'vastus-intermedius'];
describe('previously missing anatomy images', () => {
  it('ships exact local assets with credits and license links', () => {
    for (const slug of added) {
      const m = getAllMuscles().find(m => m.slug === slug)!;
      expect(m.image_url).toMatch(/^\/anatomy\//);
      expect(existsSync(`public${m.image_url}`)).toBe(true);
      expect(m.image_author).toBeTruthy();
      expect(m.image_source).toMatch(/^https:\/\/commons.wikimedia.org\/wiki\/File:/);
      if (m.image_license?.includes('CC BY-SA')) expect(m.image_license_url).toContain('creativecommons.org/licenses/');
    }
  });
  it('labels the coccygeus overview honestly', () => {
    expect(getAllMuscles().find(m => m.slug === 'coccygeus')?.image_caption).toContain('not an isolated');
  });
});
