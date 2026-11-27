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

import AnatomyPage from './AnatomyPage';

function renderAt(path: string) {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <Routes>
        <Route path="/:lang/anatomy/:muscle" element={<AnatomyPage />} />
        <Route path="/:lang/anatomy" element={<AnatomyPage />} />
      </Routes>
    </MemoryRouter>,
  );
}

describe('AnatomyPage muscle detail integration links', () => {
  it('shows a train-this-region link and region protocols for a shoulder muscle', async () => {
    renderAt('/en/anatomy/supraspinatus');
    expect(await screen.findByText('Train Shoulders in the exercise library')).toBeTruthy();
    const trainLink = screen.getByText('Train Shoulders in the exercise library').closest('a');
    expect(trainLink?.getAttribute('href')).toBe('/en/exercises/shoulders');
    expect(screen.getByText('Injuries and protocols for this region')).toBeTruthy();
    const protocolLinks = screen
      .getAllByRole('link')
      .filter((a) => (a.getAttribute('href') || '').startsWith('/en/injuries/'));
    expect(protocolLinks.length).toBeGreaterThan(0);
    const viewAll = screen.getByText(/All \d+ region protocols/);
    expect(viewAll.closest('a')?.getAttribute('href')).toBe('/en/injuries');
  });

  it('shows the neck train link but no protocols section for a neck muscle', async () => {
    renderAt('/en/anatomy/sternocleidomastoid');
    expect(await screen.findByText('Train Neck rehab in the exercise library')).toBeTruthy();
    expect(screen.queryByText('Injuries and protocols for this region')).toBeNull();
  });
});
