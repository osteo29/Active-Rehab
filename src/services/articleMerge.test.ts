import {describe, expect, it} from 'vitest';
import {mergeCloudWithFallback} from './articleStudio';
import type {Article} from './articles';

function article(slug: string, date: string, title = slug): Article {
  return {id: 1, slug, title, excerpt: '', content: '', category: '', date, icon: ''};
}

describe('mergeCloudWithFallback', () => {
  it('restores fallback topics missing from the cloud set', () => {
    const cloud = [article('a', '2026-03-19')];
    const fallback = [article('a', '2026-03-19'), article('b', '2026-03-18'), article('c', '2026-03-17')];
    const merged = mergeCloudWithFallback(cloud, fallback);
    expect(merged.map((item) => item.slug)).toEqual(['a', 'b', 'c']);
  });

  it('lets the cloud version win on slug conflicts', () => {
    const cloud = [article('a', '2026-03-19', 'Cloud title')];
    const fallback = [article('a', '2026-03-19', 'Fallback title')];
    expect(mergeCloudWithFallback(cloud, fallback)[0].title).toBe('Cloud title');
  });

  it('returns fallback when the cloud is empty and sorts by date descending', () => {
    const fallback = [article('old', '2026-01-01'), article('new', '2026-05-29')];
    expect(mergeCloudWithFallback([], fallback).map((item) => item.slug)).toEqual(['new', 'old']);
  });
});
