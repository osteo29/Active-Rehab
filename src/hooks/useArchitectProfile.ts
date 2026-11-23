import {useCallback, useEffect, useMemo, useRef, useState} from 'react';
import {HealthProfile, type HealthMetrics, PhysioNutritionLogic} from '../services/physioNutritionLogic';
import {normalizeNumericInput, parseLocalizedNumber} from '../utils/numericInput';

const ARCHITECT_STORAGE_KEY = 'activerehab_architect_profile';

const DEFAULT_ACTIVE_PROFILE: HealthProfile = {
  age: 28,
  weight: 74,
  height: 176,
  gender: 'male',
  activityLevel: 1.55,
  goal: 'recovery',
  waist: 82,
  neck: 38,
  injuryType: 'acl_tear',
  recoveryWeek: 3,
  sleepHours: 8,
  waterIntake: 2800,
  proteinCompliance: 0.85,
};

const parseArchitectNumber = (value: string) => {
  if (!value.trim()) return 0;
  const parsed = parseLocalizedNumber(value);
  return Number.isFinite(parsed) ? parsed : 0;
};

export const architectNumberToInput = (value: number | undefined | null) =>
  value && value > 0 ? String(value) : '';

function isPlaceholderProfile(profile: HealthProfile) {
  return (Object.keys(DEFAULT_ACTIVE_PROFILE) as Array<keyof HealthProfile>).every(
    (key) => profile[key] === DEFAULT_ACTIVE_PROFILE[key],
  );
}

/**
 * The placeholder profile is only there to pre-fill the form. Older versions
 * auto-saved it to localStorage on first visit, which made the AI assistant
 * treat invented values (28yo male with an ACL tear) as the user's real
 * profile. A stored profile that still exactly matches the placeholder is
 * treated as absent and cleared.
 */
const loadStoredArchitectProfile = (): {profile: HealthProfile; isUserProvided: boolean} => {
  const fallback = {profile: DEFAULT_ACTIVE_PROFILE, isUserProvided: false};
  if (typeof window === 'undefined') return fallback;
  const saved = localStorage.getItem(ARCHITECT_STORAGE_KEY);
  if (!saved) return fallback;

  try {
    const saved = localStorage.getItem(ARCHITECT_STORAGE_KEY);
    if (!saved) return DEFAULT_ACTIVE_PROFILE;
    const parsed = JSON.parse(saved) as HealthProfile;
    if (parsed.weight > 0 && parsed.height > 0) {
      const merged = {...DEFAULT_ACTIVE_PROFILE, ...parsed};
      if (isPlaceholderProfile(merged)) {
        localStorage.removeItem(ARCHITECT_STORAGE_KEY);
        return fallback;
      }
      return {profile: merged, isUserProvided: true};
    }
    return fallback;
  } catch {
    return fallback;
  }
};

export type ArchitectDraft = {
  age: string;
  weight: string;
  height: string;
  recoveryWeek: string;
  waist: string;
  neck: string;
  waterIntake: string;
};

const createArchitectDraft = (profile: HealthProfile): ArchitectDraft => ({
  age: architectNumberToInput(profile.age),
  weight: architectNumberToInput(profile.weight),
  height: architectNumberToInput(profile.height),
  recoveryWeek: String(profile.recoveryWeek || 1),
  waist: architectNumberToInput(profile.waist),
  neck: architectNumberToInput(profile.neck),
  waterIntake: architectNumberToInput(profile.waterIntake),
});

export function useArchitectProfile() {
  const initialLoad = useMemo(() => loadStoredArchitectProfile(), []);
  const initialArchitectProfile = initialLoad.profile;
  const [architectProfile, setArchitectProfileState] = useState<HealthProfile>(initialArchitectProfile);
  const [isProfileUserProvided, setIsProfileUserProvided] = useState(initialLoad.isUserProvided);

  // Persisting happens only after the visitor actually provides data, so the
  // placeholder profile never leaks into storage (and into the AI context).
  const setArchitectProfile = useCallback(
    (value: HealthProfile | ((previous: HealthProfile) => HealthProfile)) => {
      setIsProfileUserProvided(true);
      setArchitectProfileState(value);
    },
    [],
  );
  const [architectDraft, setArchitectDraft] = useState<ArchitectDraft>(() =>
    createArchitectDraft(initialArchitectProfile),
  );
  const architectResultsRef = useRef<HTMLDivElement | null>(null);

  // Responsive real-time metric calculation
  const architectMetrics = useMemo<HealthMetrics | null>(() => {
    const effectiveWeight = architectProfile.weight > 0 ? architectProfile.weight : 74;
    const effectiveHeight = architectProfile.height > 0 ? architectProfile.height : 176;
    const effectiveAge = architectProfile.age > 0 ? architectProfile.age : 28;

    const effectiveProfile: HealthProfile = {
      ...architectProfile,
      weight: effectiveWeight,
      height: effectiveHeight,
      age: effectiveAge,
    };

    try {
      return PhysioNutritionLogic.calculateAllMetrics(effectiveProfile);
    } catch {
      return null;
    }
  }, [architectProfile]);

  // Persist valid profile once the visitor has provided real data
  useEffect(() => {
    if (isProfileUserProvided && architectProfile.weight > 0 && architectProfile.height > 0) {
      try {
        localStorage.setItem(ARCHITECT_STORAGE_KEY, JSON.stringify(architectProfile));
      } catch {
        // ignore
      }
    }
  }, [architectProfile, isProfileUserProvided]);

  const updateArchitectDraft = useCallback(
    (
      field: keyof ArchitectDraft,
      value: string,
      sync?: {
        profileKey: keyof HealthProfile;
        min?: number;
      },
    ) => {
      const allowDecimal = field === 'weight';
      const normalizedValue = normalizeNumericInput(value, {allowDecimal});
      setArchitectDraft((prev) => ({...prev, [field]: normalizedValue}));
      setIsProfileUserProvided(true);

      if (!sync) return;

      const parsedValue = parseArchitectNumber(normalizedValue);
      setArchitectProfile((prev) => {
        if (prev[sync.profileKey] === parsedValue) return prev;
        return {...prev, [sync.profileKey]: parsedValue};
      });
    },
    [],
  );

  const calculateArchitectProfile = useCallback(() => {
    const nextProfile: HealthProfile = {
      ...architectProfile,
      age: Math.max(parseArchitectNumber(architectDraft.age), 18),
      weight: Math.max(parseArchitectNumber(architectDraft.weight), 40),
      height: Math.max(parseArchitectNumber(architectDraft.height), 100),
      recoveryWeek: Math.max(parseArchitectNumber(architectDraft.recoveryWeek), 1),
      waist: Math.max(parseArchitectNumber(architectDraft.waist), 0),
      neck: Math.max(parseArchitectNumber(architectDraft.neck), 0),
      waterIntake: Math.max(parseArchitectNumber(architectDraft.waterIntake), 2000),
    };

    setArchitectProfile(nextProfile);
    setArchitectDraft(createArchitectDraft(nextProfile));

    if (architectResultsRef.current) {
      architectResultsRef.current.scrollIntoView({
        behavior: 'smooth',
        block: 'start',
      });
    }
  }, [architectDraft, architectProfile]);

  return {
    architectDraft,
    architectMetrics,
    architectProfile,
    architectResultsRef,
    calculateArchitectProfile,
    initialArchitectProfile,
    setArchitectProfile,
    updateArchitectDraft,
  };
}
