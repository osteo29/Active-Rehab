// @vitest-environment jsdom

import type {ReactNode} from 'react';
import {cleanup, render, screen} from '@testing-library/react';
import {MemoryRouter, Route, Routes} from 'react-router-dom';
import {afterEach, describe, expect, it, vi} from 'vitest';

afterEach(cleanup);

vi.mock('../components/seo/Seo', () => ({
  default: () => null,
}));

vi.mock('./PageLayout', () => ({
  default: ({title, children}: {title: string; children: ReactNode}) => (
    <div>
      <h1>{title}</h1>
      {children}
    </div>
  ),
}));

vi.mock('./usePreferredLang', () => ({
  default: () => 'en',
}));

vi.mock('../hooks/useExerciseCatalog', async () => {
  const {getStaticExercises} = await import('../services/exerciseService');
  return {
    useExerciseCatalog: () => ({exercises: getStaticExercises(), loading: false, error: null}),
  };
});

import ExerciseRegionPage from './ExerciseRegionPage';

function renderAt(path: string) {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <Routes>
        <Route path="/:lang/exercises/:muscle" element={<ExerciseRegionPage />} />
      </Routes>
    </MemoryRouter>,
  );
}

describe('ExerciseRegionPage region hub', () => {
  it('links the region to real anatomy-library muscles and protocols', () => {
    renderAt('/en/exercises/shoulders');
    expect(screen.getByText('Region muscles in the anatomy library')).toBeTruthy();
    const muscleLinks = screen
      .getAllByRole('link')
      .filter((a) => /^\/en\/anatomy\/[a-z0-9-]+$/.test(a.getAttribute('href') || ''));
    expect(muscleLinks.length).toBeGreaterThan(0);
    expect(screen.getByText('Open the full anatomy library').closest('a')?.getAttribute('href')).toBe('/en/anatomy');
    expect(screen.getByText('Rehab protocols using these exercises')).toBeTruthy();
    const protocolLinks = screen
      .getAllByRole('link')
      .filter((a) => (a.getAttribute('href') || '').startsWith('/en/injuries/'));
    expect(protocolLinks.length).toBeGreaterThan(0);
  });
});
