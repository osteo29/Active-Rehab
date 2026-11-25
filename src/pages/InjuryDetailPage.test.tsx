// @vitest-environment jsdom

import {Suspense, type ReactNode} from 'react';
import {cleanup, fireEvent, render, screen, waitFor} from '@testing-library/react';
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

vi.mock('../services/injuryI18n', () => ({
  translateInjury: (input: {nameEn?: string; overviewEn?: string; category?: string; bodyRegion?: string}) => ({
    name: input.nameEn || 'Test Injury',
    category: input.category || 'Ligament',
    bodyRegion: input.bodyRegion || 'Knee',
    overview: input.overviewEn || 'Overview text',
  }),
  translateActivityContext: (value: string) => value,
}));

vi.mock('../services/injuryExerciseLinks', () => ({
  getInjuryExerciseLinks: () => [
    {
      slug: 'quadriceps',
      label: 'Quadriceps exercises',
      href: '/en/exercises/quadriceps',
      reason: 'Useful for rebuilding knee strength.',
    },
  ],
}));

vi.mock('../services/exerciseBiomechanicsService', () => ({
  getVideoExercisesForMuscles: () => [
    {
      muscleSlug: 'vastus-medialis-oblique-vmo',
      exercise: {id: 'ex-tke', name: 'Terminal knee extension', provenance: 'body_iq_verified', youtube_id: 'abc123'},
    },
  ],
}));

vi.mock('../services/injuryRehabLinks', () => ({
  getInjuryRehabLinks: () => [],
}));

vi.mock('../services/textEncoding', () => ({
  decodeMojibake: (value: string) => value,
}));

vi.mock('../services/seoAliases', () => ({
  INJURY_CANONICAL_PARENT_MAP: {},
}));

vi.mock('../components/ai/DrugNutrientChecker', () => ({
  default: () => <div>checker</div>,
}));

vi.mock('../lib/supabase', () => ({
  getCurrentUser: vi.fn(async () => null),
  isSupabaseConfigured: true,
  onSupabaseAuthChange: vi.fn(() => ({
    data: {
      subscription: {
        unsubscribe: vi.fn(),
      },
    },
  })),
}));

vi.mock('../services/injuryService', () => ({
  getCatalogInjuries: vi.fn(async () => ({injuries: []})),
  getInjuryProtocolBySlugWithFallback: vi.fn(async () => ({
    source: 'supabase',
    remoteIds: [],
    injury: {
      id: 'test_injury',
      name: 'Test Injury',
      category: 'Ligament',
      bodyRegion: 'Knee',
      overview: 'Overview text',
      rehabSummary: 'Rehab summary',
      commonIn: null,
      redFlags: null,
      relatedCalculators: null,
      safetyNotes: null,
      pageContent: null,
      phases: [
        {
          id: 'phase-1',
          label: 'Phase 1',
          duration: '1 week',
          window: 'days_3_14',
          goals: [],
          nutritionFocus: [],
          recommendedFoods: [],
          avoidFoods: [],
          supplements: [],
          exercises: [],
          prohibitedMovements: [],
          meals: {
            breakfast: '',
            lunch: '',
            dinner: '',
            shoppingList: [],
          },
        },
        {
          id: 'phase-2',
          label: 'Phase 2',
          duration: '2 weeks',
          window: 'days_3_14',
          goals: ['Restore motion'],
          nutritionFocus: ['Protein'],
          recommendedFoods: ['Yogurt'],
          avoidFoods: ['Alcohol'],
          supplements: [],
          exercises: [],
          prohibitedMovements: [],
          meals: {
            breakfast: 'Oats',
            lunch: 'Rice',
            dinner: 'Fish',
            shoppingList: [],
          },
        },
        {
          id: 'phase-3',
          label: 'Phase 3',
          duration: '3 weeks',
          window: 'weeks_2_6',
          goals: ['Build strength'],
          nutritionFocus: ['Creatine'],
          recommendedFoods: ['Chicken'],
          avoidFoods: ['Skipping meals'],
          supplements: [],
          exercises: [],
          prohibitedMovements: [],
          meals: {
            breakfast: 'Eggs',
            lunch: 'Potatoes',
            dinner: 'Steak',
            shoppingList: [],
          },
        },
      ],
    },
  })),
}));

import InjuryDetailPage from './InjuryDetailPage';

describe('InjuryDetailPage', () => {
  it('renders instead of crashing when optional injury arrays are missing', async () => {
    render(
      <Suspense fallback={<div>loading</div>}>
        <MemoryRouter initialEntries={['/en/injuries/test-injury']}>
          <Routes>
            <Route path="/:lang/injuries/:slug" element={<InjuryDetailPage />} />
          </Routes>
        </MemoryRouter>
      </Suspense>,
    );

    await waitFor(() => {
      expect(screen.getAllByText(/Test Injury/i).length).toBeGreaterThan(0);
    });

    expect(screen.getByText('Overview text')).toBeInTheDocument();
    expect(screen.queryByText(/loading injury details/i)).not.toBeInTheDocument();
  });

  it('locks phases after the first two for signed-out users', async () => {
    render(
      <Suspense fallback={<div>loading</div>}>
        <MemoryRouter initialEntries={['/en/injuries/test-injury']}>
          <Routes>
            <Route path="/:lang/injuries/:slug" element={<InjuryDetailPage />} />
          </Routes>
        </MemoryRouter>
      </Suspense>,
    );

    await waitFor(() => {
      expect(screen.getAllByText(/Test Injury/i).length).toBeGreaterThan(0);
    });

    fireEvent.click(screen.getAllByRole('button', {name: /phase 3/i})[0]);

    expect(screen.getAllByText('Unlock the rest of this protocol').length).toBeGreaterThan(0);
    expect(screen.getAllByRole('link', {name: /create account/i})[0]).toHaveAttribute('href', '/en/auth?mode=signup');
    expect(screen.getAllByRole('link', {name: /sign in/i})[0]).toHaveAttribute('href', '/en/auth?mode=signin');
  });

  it('shows exercise reasons, expanded muscle links, and guided video exercises', async () => {
    render(
      <Suspense fallback={<div>loading</div>}>
        <MemoryRouter initialEntries={['/en/injuries/test-injury']}>
          <Routes>
            <Route path="/:lang/injuries/:slug" element={<InjuryDetailPage />} />
          </Routes>
        </MemoryRouter>
      </Suspense>,
    );

    await waitFor(() => {
      expect(screen.getAllByText(/Test Injury/i).length).toBeGreaterThan(0);
    });

    expect(screen.getByText('Quadriceps exercises')).toBeInTheDocument();
    expect(screen.getByText('Useful for rebuilding knee strength.')).toBeInTheDocument();

    expect(screen.getByText('Muscles involved (anatomy library)')).toBeInTheDocument();
    expect(screen.getByText(/All \d+ region muscles/)).toBeInTheDocument();

    expect(screen.getByText('Guided video exercises for this region')).toBeInTheDocument();
    expect(screen.getByText('Terminal knee extension')).toBeInTheDocument();
    const videoLink = screen.getByText('Open video on the muscle page').closest('a');
    expect(videoLink?.getAttribute('href')).toBe('/en/anatomy/vastus-medialis-oblique-vmo');
  });
});
