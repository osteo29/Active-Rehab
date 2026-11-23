import type {AssessmentInsert} from '../lib/supabase';

export type ProgressionStep = 'discover' | 'assess' | 'understand' | 'save' | 'follow_up';
export type RecoveryStage = 'early' | 'rebuild' | 'return';

export type ProgressionProfile = {
  age?: number;
  weight?: number;
  height?: number;
  goal?: string;
  injuryType?: string | null;
  recoveryWeek?: number;
  preferredMetric?: string | null;
};

export type ProgressionState = {
  onboardingCompleted: boolean;
  preferredMetric: string | null;
  selectedInjuryId: string | null;
  selectedInjuryName: string | null;
  selectedRecoveryStage: RecoveryStage | null;
  lastCompletedCalculator: string | null;
  lastRecommendedCalculator: string | null;
  lastStep: ProgressionStep;
  profile: ProgressionProfile;
  updatedAt: string | null;
};

export type PendingAssessment = AssessmentInsert & {
  redirectTo: string;
  calculatorName: string;
  source: string;
};

export type ProgressEventName =
  | 'homepage_cta_click'
  | 'calculator_opened'
  | 'calculator_completed'
  | 'save_click'
  | 'auth_start'
  | 'auth_success'
  | 'first_saved_result'
  | 'dashboard_visit'
  | 'injury_protocol_adopted'
  | 'assistant_entry_after_result';

const PROGRESSION_STORAGE_KEY = 'activerehab_progression_state_v1';
const PENDING_ASSESSMENT_KEY = 'activerehab_pending_assessment_v1';
const PROGRESS_EVENTS_KEY = 'activerehab_progress_events_v1';

const defaultState: ProgressionState = {
  onboardingCompleted: false,
  preferredMetric: null,
  selectedInjuryId: null,
  selectedInjuryName: null,
  selectedRecoveryStage: null,
  lastCompletedCalculator: null,
  lastRecommendedCalculator: null,
  lastStep: 'discover',
  profile: {},
  updatedAt: null,
};

function safeRead<T>(key: string): T | null {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T) : null;
  } catch {
    return null;
  }
}

function safeWrite(key: string, value: unknown) {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch {
    // ignore storage failures
  }
}

export function getProgressionState(): ProgressionState {
  const stored = safeRead<Partial<ProgressionState>>(PROGRESSION_STORAGE_KEY);
  return {
    ...defaultState,
    ...stored,
    profile: {
      ...defaultState.profile,
      ...(stored?.profile || {}),
    },
  };
}

export function updateProgressionState(
  updater: Partial<ProgressionState> | ((current: ProgressionState) => ProgressionState),
) {
  const current = getProgressionState();
  const next =
    typeof updater === 'function'
      ? updater(current)
      : {
          ...current,
          ...updater,
          profile: {
            ...current.profile,
            ...(updater.profile || {}),
          },
        };

  const finalized = {
    ...current,
    ...next,
    profile: {
      ...current.profile,
      ...(next.profile || {}),
    },
    updatedAt: new Date().toISOString(),
  };

  safeWrite(PROGRESSION_STORAGE_KEY, finalized);
  return finalized;
}

export function getRecommendedNextCalculator(calculator: string | null) {
  if (!calculator) return 'BMI';

  const sequence: Record<string, string> = {
    BMI: 'BMR',
    BodyFat: 'BMR',
    WHtR: 'BMR',
    BMR: 'TDEE',
    TDEE: 'Macros',
    Macros: 'Protein',
    Protein: 'Water',
    Water: 'Deficit',
  };

  return sequence[calculator] || null;
}

export function inferRecoveryStage(recoveryWeek?: number | null): RecoveryStage | null {
  if (!recoveryWeek || recoveryWeek <= 0) return null;
  if (recoveryWeek <= 2) return 'early';
  if (recoveryWeek <= 6) return 'rebuild';
  return 'return';
}

export function setPendingAssessment(pending: PendingAssessment) {
  try {
    sessionStorage.setItem(PENDING_ASSESSMENT_KEY, JSON.stringify(pending));
  } catch {
    // ignore
  }
}

export function getPendingAssessment() {
  try {
    const raw = sessionStorage.getItem(PENDING_ASSESSMENT_KEY);
    return raw ? (JSON.parse(raw) as PendingAssessment) : null;
  } catch {
    return null;
  }
}

export function clearPendingAssessment() {
  try {
    sessionStorage.removeItem(PENDING_ASSESSMENT_KEY);
  } catch {
    // ignore
  }
}

export function trackProgressEvent(name: ProgressEventName, payload: Record<string, unknown> = {}) {
  const event = {
    name,
    payload,
    createdAt: new Date().toISOString(),
  };

  try {
    const existing = safeRead<Array<typeof event>>(PROGRESS_EVENTS_KEY) || [];
    const next = [...existing.slice(-99), event];
    localStorage.setItem(PROGRESS_EVENTS_KEY, JSON.stringify(next));
  } catch {
    // ignore
  }

  if (typeof window !== 'undefined') {
    window.dispatchEvent(new CustomEvent('physiohub-progress-event', {detail: event}));
  }
}
