import {supabase} from '../lib/supabase';
import type {Database} from '../lib/supabaseDatabase';

export type AdminDashboardMetrics = {
  injuries: number | null;
  phases: number | null;
  articles: number | null;
  assessments: number | null;
  leads: number | null;
};

function ensureSupabase() {
  if (!supabase) {
    throw new Error('Supabase is not configured.');
  }

  return supabase;
}

type DashboardTable = keyof Pick<
  Database['public']['Tables'],
  'injuries' | 'injury_phases' | 'articles' | 'assessments' | 'assessment_leads'
>;

async function fetchCount(table: DashboardTable) {
  const client = ensureSupabase();
  const {count, error} = await client.from(table).select('*', {count: 'exact', head: true});
  if (error) throw error;
  return count || 0;
}

async function fetchCountSafe(table: DashboardTable) {
  try {
    return await fetchCount(table);
  } catch (error) {
    console.warn(`Failed to load admin dashboard metric for ${table}`, error);
    return null;
  }
}

export async function fetchAdminDashboardMetrics(): Promise<AdminDashboardMetrics> {
  const [injuries, phases, articles, assessments, leads] = await Promise.all([
    fetchCountSafe('injuries'),
    fetchCountSafe('injury_phases'),
    fetchCountSafe('articles'),
    fetchCountSafe('assessments'),
    fetchCountSafe('assessment_leads'),
  ]);

  return {
    injuries,
    phases,
    articles,
    assessments,
    leads,
  };
}
