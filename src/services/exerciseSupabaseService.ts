import {supabase, isSupabaseConfigured} from '../lib/supabase';
import type {TableRow} from '../lib/supabaseDatabase';
import {MedicalTextCore} from './textEncoding';

export type ExerciseLibraryRow = TableRow<'exercise_library_entries'>;
const EXERCISE_SUPABASE_TIMEOUT_MS = 4000;

export async function fetchExerciseLibraryEntriesFromSupabase(): Promise<ExerciseLibraryRow[]> {
  if (!isSupabaseConfigured || !supabase) {
    return [];
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), EXERCISE_SUPABASE_TIMEOUT_MS);

  try {
    const {data, error} = await supabase
      .from('exercise_library_entries')
      .select('*')
      .order('region')
      .order('name')
      .abortSignal(controller.signal);

    if (error) {
      throw error;
    }

    return MedicalTextCore.parseDeep(data || []);
  } catch (error) {
    throw error instanceof Error ? error : new Error('Could not load the exercise catalog.');
  } finally {
    clearTimeout(timeout);
  }
}
