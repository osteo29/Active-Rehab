import {useCallback, useEffect, useState} from 'react';

export interface PhaseGoal {
  id: string;
  text: string;
  completed: boolean;
}

export interface PhaseProgress {
  phaseNumber: number;
  title: string;
  titleAr?: string;
  goals: PhaseGoal[];
  completed: boolean;
  completedAt?: string;
}

export interface PainLogEntry {
  date: string;
  level: number;
}

export interface RecoveryNote {
  id: string;
  date: string;
  text: string;
}

export interface RecoveryJourney {
  id: string;
  injurySlug: string;
  injuryName: string;
  injuryNameAr?: string;
  bodyRegion?: string;
  currentPhase: number;
  totalPhases: number;
  startedAt: string;
  updatedAt: string;
  painLevel: number;
  painHistory: PainLogEntry[];
  notes: RecoveryNote[];
  phases: PhaseProgress[];
  status: 'active' | 'completed' | 'paused';
}

const STORAGE_KEY = 'physionut_my_recovery_v1';

const DEFAULT_PHASE_GOALS_BY_PHASE: Record<number, Array<{en: string; ar: string}>> = {
  1: [
    {en: 'Control acute pain and swelling', ar: 'السيطرة على الألم الحاد والانتفاخ'},
    {en: 'Protect healing tissue & rest', ar: 'حماية الأنسجة في مرحلة الشفاء الأولى'},
    {en: 'Gentle passive range of motion', ar: 'استعادة المدى الحركي الخفيف تدريجيًا'},
  ],
  2: [
    {en: 'Progressive active mobility', ar: 'تفعيل المدى الحركي النشط بدون ألم'},
    {en: 'Isometric & light resistance strengthening', ar: 'تمارين الثبات والمقاومة الخفيفة'},
    {en: 'Restore basic daily functional movement', ar: 'استعادة الحركة الوظيفية للأنشطة اليومية'},
  ],
  3: [
    {en: 'Full functional strength restoration', ar: 'بناء القوة الوظيفية الكاملة'},
    {en: 'Dynamic stability and balance drills', ar: 'تمارين التوازن والثبات الديناميكي'},
    {en: 'Gradual sport or high-demand return', ar: 'التدرج في العودة للرياضة والمجهود العالي'},
  ],
  4: [
    {en: 'Peak conditioning and athletic return', ar: 'الوصول للجاهزية البدنية والرياضية التامة'},
    {en: 'Injury prevention & long-term maintenance', ar: 'خطة الوقاية والحفاظ على المكتسبات'},
  ],
};

function generateDefaultPhases(totalPhases = 3): PhaseProgress[] {
  const count = Math.max(totalPhases, 1);
  const phases: PhaseProgress[] = [];

  for (let i = 1; i <= count; i += 1) {
    const rawGoals = DEFAULT_PHASE_GOALS_BY_PHASE[i] || DEFAULT_PHASE_GOALS_BY_PHASE[3];
    phases.push({
      phaseNumber: i,
      title: `Phase ${i}`,
      titleAr: `المرحلة ${i}`,
      goals: rawGoals.map((g, idx) => ({
        id: `p${i}_g${idx}`,
        text: g.ar,
        completed: false,
      })),
      completed: false,
    });
  }

  return phases;
}

export function useMyRecovery() {
  const [journeys, setJourneys] = useState<RecoveryJourney[]>(() => {
    if (typeof window === 'undefined') return [];
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  const [activeJourneyId, setActiveJourneyId] = useState<string | null>(() => {
    if (typeof window === 'undefined') return null;
    try {
      const saved = localStorage.getItem(`${STORAGE_KEY}_active`);
      return saved || null;
    } catch {
      return null;
    }
  });

  // Save journeys to localStorage
  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(journeys));
    } catch (e) {
      console.warn('Failed to save recovery journeys to localStorage', e);
    }
  }, [journeys]);

  // Save active journey id
  useEffect(() => {
    try {
      if (activeJourneyId) {
        localStorage.setItem(`${STORAGE_KEY}_active`, activeJourneyId);
      } else {
        localStorage.removeItem(`${STORAGE_KEY}_active`);
      }
    } catch {
      // ignore
    }
  }, [activeJourneyId]);

  const activeJourney = journeys.find((j) => j.id === activeJourneyId) || journeys[0] || null;

  const startJourney = useCallback(
    ({
      injurySlug,
      injuryName,
      injuryNameAr,
      bodyRegion,
      totalPhases = 3,
      initialPain = 5,
    }: {
      injurySlug: string;
      injuryName: string;
      injuryNameAr?: string;
      bodyRegion?: string;
      totalPhases?: number;
      initialPain?: number;
    }) => {
      const now = new Date().toISOString();
      const existing = journeys.find((j) => j.injurySlug === injurySlug);

      if (existing) {
        setActiveJourneyId(existing.id);
        return existing;
      }

      const id = `journey_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
      const newJourney: RecoveryJourney = {
        id,
        injurySlug,
        injuryName,
        injuryNameAr: injuryNameAr || injuryName,
        bodyRegion,
        currentPhase: 1,
        totalPhases: Math.max(totalPhases, 1),
        startedAt: now,
        updatedAt: now,
        painLevel: initialPain,
        painHistory: [{date: now, level: initialPain}],
        notes: [],
        phases: generateDefaultPhases(totalPhases),
        status: 'active',
      };

      setJourneys((prev) => [newJourney, ...prev]);
      setActiveJourneyId(id);
      return newJourney;
    },
    [journeys],
  );

  const setPhase = useCallback((journeyId: string, phaseNumber: number) => {
    const now = new Date().toISOString();
    setJourneys((prev) =>
      prev.map((j) => {
        if (j.id !== journeyId) return j;
        const clampedPhase = Math.max(1, Math.min(phaseNumber, j.totalPhases));
        const updatedPhases = j.phases.map((p) => {
          if (p.phaseNumber < clampedPhase) {
            return {...p, completed: true, completedAt: p.completedAt || now};
          }
          if (p.phaseNumber === clampedPhase) {
            return {...p, completed: false};
          }
          return {...p, completed: false};
        });

        return {
          ...j,
          currentPhase: clampedPhase,
          phases: updatedPhases,
          updatedAt: now,
        };
      }),
    );
  }, []);

  const advancePhase = useCallback((journeyId: string) => {
    setJourneys((prev) =>
      prev.map((j) => {
        if (j.id !== journeyId) return j;
        if (j.currentPhase >= j.totalPhases) {
          return {...j, status: 'completed', updatedAt: new Date().toISOString()};
        }
        const nextPhase = j.currentPhase + 1;
        const now = new Date().toISOString();
        const updatedPhases = j.phases.map((p) => {
          if (p.phaseNumber < nextPhase) {
            return {...p, completed: true, completedAt: p.completedAt || now};
          }
          return p;
        });

        return {
          ...j,
          currentPhase: nextPhase,
          phases: updatedPhases,
          updatedAt: now,
        };
      }),
    );
  }, []);

  const toggleGoal = useCallback((journeyId: string, phaseNumber: number, goalId: string) => {
    setJourneys((prev) =>
      prev.map((j) => {
        if (j.id !== journeyId) return j;
        const updatedPhases = j.phases.map((p) => {
          if (p.phaseNumber !== phaseNumber) return p;
          const updatedGoals = p.goals.map((g) =>
            g.id === goalId ? {...g, completed: !g.completed} : g,
          );
          const allCompleted = updatedGoals.length > 0 && updatedGoals.every((g) => g.completed);
          return {
            ...p,
            goals: updatedGoals,
            completed: allCompleted,
          };
        });

        return {
          ...j,
          phases: updatedPhases,
          updatedAt: new Date().toISOString(),
        };
      }),
    );
  }, []);

  const logPain = useCallback((journeyId: string, level: number) => {
    const now = new Date().toISOString();
    const clampedLevel = Math.max(0, Math.min(10, Math.round(level)));

    setJourneys((prev) =>
      prev.map((j) => {
        if (j.id !== journeyId) return j;
        return {
          ...j,
          painLevel: clampedLevel,
          painHistory: [...j.painHistory, {date: now, level: clampedLevel}].slice(-30),
          updatedAt: now,
        };
      }),
    );
  }, []);

  const addNote = useCallback((journeyId: string, text: string) => {
    if (!text.trim()) return;
    const now = new Date().toISOString();
    const newNote: RecoveryNote = {
      id: `note_${Date.now()}`,
      date: now,
      text: text.trim(),
    };

    setJourneys((prev) =>
      prev.map((j) => {
        if (j.id !== journeyId) return j;
        return {
          ...j,
          notes: [newNote, ...j.notes].slice(0, 50),
          updatedAt: now,
        };
      }),
    );
  }, []);

  const deleteJourney = useCallback((journeyId: string) => {
    setJourneys((prev) => prev.filter((j) => j.id !== journeyId));
    setActiveJourneyId((prev) => (prev === journeyId ? null : prev));
  }, []);

  const isInjuryTracked = useCallback(
    (injurySlug: string) => journeys.some((j) => j.injurySlug === injurySlug),
    [journeys],
  );

  const getJourneyBySlug = useCallback(
    (injurySlug: string) => journeys.find((j) => j.injurySlug === injurySlug) || null,
    [journeys],
  );

  return {
    journeys,
    activeJourney,
    activeJourneyId,
    setActiveJourneyId,
    startJourney,
    setPhase,
    advancePhase,
    toggleGoal,
    logPain,
    addNote,
    deleteJourney,
    isInjuryTracked,
    getJourneyBySlug,
  };
}
