import { useState } from 'react';
import { X, ChevronLeft, ChevronRight } from 'lucide-react';
import {
  createInjury,
  createPhase,
  createSupplement,
  createMeal,
} from '../../services/injurySupabaseService';

interface AddInjuryWizardProps {
  onClose: () => void;
  onSuccess: () => void;
}

export function AddInjuryWizard({ onClose, onSuccess }: AddInjuryWizardProps) {
  const [step, setStep] = useState(1);
  const [isLoading, setIsLoading] = useState(false);

  // Step 1: Basic Info
  const [basicInfo, setBasicInfo] = useState({
    injury_id_slug: '',
    name_en: '',
    name_ar: '',
    category: 'Muscle',
    body_region_en: '',
    body_region_ar: '',
    overview_en: '',
    overview_ar: '',
    rehab_summary_en: '',
    rehab_summary_ar: '',
  });

  // Steps 2-6: Phases (1-5)
  const [phases, setPhases] = useState(
    Array(5).fill(null).map((_, i) => ({
      phase_number: i + 1,
      label_en: '',
      label_ar: '',
      duration_en: '',
      duration_ar: '',
      recovery_window: 'weeks_2_6',
      goals_en: [] as string[],
      goals_ar: [] as string[],
      nutrition_focus_en: [] as string[],
      nutrition_focus_ar: [] as string[],
      recommended_foods_en: [] as string[],
      recommended_foods_ar: [] as string[],
      avoid_foods_en: [] as string[],
      avoid_foods_ar: [] as string[],
      exercises_en: [] as string[],
      exercises_ar: [] as string[],
      prohibited_movements_en: [] as string[],
      prohibited_movements_ar: [] as string[],
      protein_min_per_kg: null as number | null,
      protein_max_per_kg: null as number | null,
      hydration_ml_per_kg: null as number | null,
      omega3_grams: null as number | null,
      creatine_grams: null as number | null,
      collagen_min_per_kg: null as number | null,
      collagen_max_per_kg: null as number | null,
      vitamin_c_mg: null as number | null,
      calcium_mg: null as number | null,
      // Supplements
      supplements: [] as Array<{
        name: string;
        dose_en: string;
        dose_ar: string;
        reason_en: string;
        reason_ar: string;
        timing_en: string;
        timing_ar: string;
        caution_en: string;
        caution_ar: string;
      }>,
      // Meals
      meals: {
        omnivore: {
          breakfast_en: '',
          breakfast_ar: '',
          lunch_en: '',
          lunch_ar: '',
          dinner_en: '',
          dinner_ar: '',
          snack_en: '',
          snack_ar: '',
          shopping_list_en: [] as string[],
          shopping_list_ar: [] as string[],
        },
        vegetarian: {
          breakfast_en: '',
          breakfast_ar: '',
          lunch_en: '',
          lunch_ar: '',
          dinner_en: '',
          dinner_ar: '',
          snack_en: '',
          snack_ar: '',
          shopping_list_en: [] as string[],
          shopping_list_ar: [] as string[],
        },
      },
    }))
  );

  const currentPhase = step > 1 ? phases[step - 2] : null;

  const handleUpdatePhase = (phaseIndex: number, updates: any) => {
    const newPhases = [...phases];
    newPhases[phaseIndex] = { ...newPhases[phaseIndex], ...updates };
    setPhases(newPhases);
  };

  const handleArrayInput = (value: string, isAdd = true) => {
    if (!currentPhase) return;
    return value.split(',').map(v => v.trim()).filter(v => v);
  };

  const handleSave = async () => {
    setIsLoading(true);
    try {
      // 1. Create injury
      const injuryData = await createInjury({
        injury_id_slug: basicInfo.injury_id_slug,
        name_en: basicInfo.name_en,
        name_ar: basicInfo.name_ar,
        category: basicInfo.category,
        body_region_en: basicInfo.body_region_en,
        body_region_ar: basicInfo.body_region_ar,
        overview_en: basicInfo.overview_en,
        overview_ar: basicInfo.overview_ar,
        rehab_summary_en: basicInfo.rehab_summary_en,
        rehab_summary_ar: basicInfo.rehab_summary_ar,
        common_in: [],
        red_flags: [],
        related_calculators: [],
      });
      const injuryId = injuryData.id;

      // 2. Create phases with supplements and meals
      for (const phase of phases) {
        const phaseData = await createPhase({
          injury_id: injuryId,
          phase_number: phase.phase_number,
          label_en: phase.label_en,
          label_ar: phase.label_ar,
          duration_en: phase.duration_en,
          duration_ar: phase.duration_ar,
          recovery_window: phase.recovery_window,
          goals_en: phase.goals_en,
          goals_ar: phase.goals_ar,
          nutrition_focus_en: phase.nutrition_focus_en,
          nutrition_focus_ar: phase.nutrition_focus_ar,
          recommended_foods_en: phase.recommended_foods_en,
          recommended_foods_ar: phase.recommended_foods_ar,
          avoid_foods_en: phase.avoid_foods_en,
          avoid_foods_ar: phase.avoid_foods_ar,
          exercises_en: phase.exercises_en,
          exercises_ar: phase.exercises_ar,
          prohibited_movements_en: phase.prohibited_movements_en,
          prohibited_movements_ar: phase.prohibited_movements_ar,
          protein_min_per_kg: phase.protein_min_per_kg,
          protein_max_per_kg: phase.protein_max_per_kg,
          hydration_ml_per_kg: phase.hydration_ml_per_kg,
          omega3_grams: phase.omega3_grams,
          creatine_grams: phase.creatine_grams,
          collagen_min_per_kg: phase.collagen_min_per_kg,
          collagen_max_per_kg: phase.collagen_max_per_kg,
          vitamin_c_mg: phase.vitamin_c_mg,
          calcium_mg: phase.calcium_mg,
        });

        // Add supplements
        for (let i = 0; i < phase.supplements.length; i++) {
          const supplement = phase.supplements[i];
          await createSupplement({
            phase_id: phaseData.id,
            name: supplement.name,
            dose_en: supplement.dose_en,
            dose_ar: supplement.dose_ar,
            reason_en: supplement.reason_en,
            reason_ar: supplement.reason_ar,
            timing_en: supplement.timing_en,
            timing_ar: supplement.timing_ar,
            caution_en: supplement.caution_en,
            caution_ar: supplement.caution_ar,
            order_index: i,
          });
        }

        // Add meals
        for (const [dietStyle, mealData] of Object.entries(phase.meals)) {
          await createMeal({
            phase_id: phaseData.id,
            diet_style: dietStyle,
            breakfast_en: mealData.breakfast_en,
            breakfast_ar: mealData.breakfast_ar,
            lunch_en: mealData.lunch_en,
            lunch_ar: mealData.lunch_ar,
            dinner_en: mealData.dinner_en,
            dinner_ar: mealData.dinner_ar,
            snack_en: mealData.snack_en || '',
            snack_ar: mealData.snack_ar || '',
            shopping_list_en: mealData.shopping_list_en,
            shopping_list_ar: mealData.shopping_list_ar,
          });
        }
      }

      alert('✅ تمت إضافة الإصابة الكاملة بنجاح!');
      onSuccess();
      onClose();
    } catch (error) {
      console.error('Error:', error);
      alert(`❌ خطأ: ${error instanceof Error ? error.message : 'خطأ غير معروف'}`);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 p-4">
      <div className="bg-gray-900 rounded-lg w-full max-w-4xl max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-gray-800 border-b border-gray-700 px-6 py-4 flex justify-between items-center">
          <h2 className="text-2xl font-bold text-white">
            {step === 1 ? 'معلومات الإصابة' : `المرحلة ${step - 1} من التعافي`}
          </h2>
          <button onClick={onClose} aria-label="إغلاق" className="text-gray-400 hover:text-white">
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6">
          {step === 1 ? (
            // Step 1: Basic Information
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <input
                  type="text"
                  placeholder="ID (acl_injury)"
                  value={basicInfo.injury_id_slug}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, injury_id_slug: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                />
                <select
                  value={basicInfo.category}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, category: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                >
                  <option>Ligament</option>
                  <option>Tendon</option>
                  <option>Muscle</option>
                  <option>Bone</option>
                  <option>Joint</option>
                  <option>Spine</option>
                </select>
                <input
                  type="text"
                  placeholder="الاسم بالعربية"
                  value={basicInfo.name_ar}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, name_ar: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                />
                <input
                  type="text"
                  placeholder="Name (English)"
                  value={basicInfo.name_en}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, name_en: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                />
                <input
                  type="text"
                  placeholder="المنطقة الجسمية (عربي)"
                  value={basicInfo.body_region_ar}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, body_region_ar: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                />
                <input
                  type="text"
                  placeholder="Body Region (English)"
                  value={basicInfo.body_region_en}
                  onChange={(e) =>
                    setBasicInfo({ ...basicInfo, body_region_en: e.target.value })
                  }
                  className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                />
              </div>
              <textarea
                placeholder="نظرة عامة (عربي)"
                value={basicInfo.overview_ar}
                onChange={(e) =>
                  setBasicInfo({ ...basicInfo, overview_ar: e.target.value })
                }
                className="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                rows={2}
              />
              <textarea
                placeholder="Overview (English)"
                value={basicInfo.overview_en}
                onChange={(e) =>
                  setBasicInfo({ ...basicInfo, overview_en: e.target.value })
                }
                className="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                rows={2}
              />
              <textarea
                placeholder="ملخص التأهيل (عربي)"
                value={basicInfo.rehab_summary_ar}
                onChange={(e) =>
                  setBasicInfo({ ...basicInfo, rehab_summary_ar: e.target.value })
                }
                className="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                rows={2}
              />
              <textarea
                placeholder="Rehab Summary (English)"
                value={basicInfo.rehab_summary_en}
                onChange={(e) =>
                  setBasicInfo({ ...basicInfo, rehab_summary_en: e.target.value })
                }
                className="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                rows={2}
              />
            </div>
          ) : (
            // Steps 2-6: Phases
            currentPhase && (
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <input
                    type="text"
                    placeholder="المرحلة (عربي)"
                    value={currentPhase.label_ar}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, { label_ar: e.target.value })
                    }
                    className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                  />
                  <input
                    type="text"
                    placeholder="Phase (English)"
                    value={currentPhase.label_en}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, { label_en: e.target.value })
                    }
                    className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                  />
                  <input
                    type="text"
                    placeholder="المدة (عربي)"
                    value={currentPhase.duration_ar}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, { duration_ar: e.target.value })
                    }
                    className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                  />
                  <input
                    type="text"
                    placeholder="Duration (English)"
                    value={currentPhase.duration_en}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, { duration_en: e.target.value })
                    }
                    className="px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                  />
                </div>

                {/* Recovery Window */}
                <select
                  value={currentPhase.recovery_window}
                  onChange={(e) =>
                    handleUpdatePhase(step - 2, { recovery_window: e.target.value })
                  }
                  className="w-full px-3 py-2 bg-gray-800 border border-gray-700 rounded text-white"
                >
                  <option value="under_48h">أقل من 48 ساعة</option>
                  <option value="days_3_14">3-14 أيام</option>
                  <option value="weeks_2_6">أسابيع 2-6</option>
                  <option value="over_6_weeks">أكثر من 6 أسابيع</option>
                </select>

                {/* Nutrition Values */}
                <div className="grid grid-cols-2 gap-2 p-3 bg-gray-800 rounded border border-gray-700">
                  <h4 className="col-span-2 text-sm font-semibold text-yellow-400">التغذية</h4>
                  <input
                    type="number"
                    placeholder="البروتين min"
                    step="0.1"
                    value={currentPhase.protein_min_per_kg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        protein_min_per_kg: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="البروتين max"
                    step="0.1"
                    value={currentPhase.protein_max_per_kg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        protein_max_per_kg: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="الترطيب (ml/kg)"
                    value={currentPhase.hydration_ml_per_kg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        hydration_ml_per_kg: e.target.value ? parseInt(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Omega3 (g)"
                    step="0.1"
                    value={currentPhase.omega3_grams || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        omega3_grams: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Creatine (g)"
                    step="0.1"
                    value={currentPhase.creatine_grams || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        creatine_grams: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Collagen min"
                    step="0.1"
                    value={currentPhase.collagen_min_per_kg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        collagen_min_per_kg: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Collagen max"
                    step="0.1"
                    value={currentPhase.collagen_max_per_kg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        collagen_max_per_kg: e.target.value ? parseFloat(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Vitamin C (mg)"
                    value={currentPhase.vitamin_c_mg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        vitamin_c_mg: e.target.value ? parseInt(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                  <input
                    type="number"
                    placeholder="Calcium (mg)"
                    value={currentPhase.calcium_mg || ''}
                    onChange={(e) =>
                      handleUpdatePhase(step - 2, {
                        calcium_mg: e.target.value ? parseInt(e.target.value) : null,
                      })
                    }
                    className="px-2 py-1 bg-gray-700 border border-gray-600 rounded text-white text-sm"
                  />
                </div>

                <div className="text-xs text-gray-400 p-2 bg-gray-800 rounded">
                  💡 ملاحظة: يمكن ترك هذه الخطوة وتعديل التفاصيل بعد الحفظ من لوحة التحكم
                </div>
              </div>
            )
          )}
        </div>

        {/* Navigation */}
        <div className="sticky bottom-0 bg-gray-800 border-t border-gray-700 px-6 py-4 flex justify-between items-center">
          <button
            onClick={() => setStep(Math.max(1, step - 1))}
            disabled={step === 1}
            className="flex items-center gap-2 px-4 py-2 bg-gray-700 disabled:bg-gray-800 disabled:opacity-50 text-white rounded-lg"
          >
            <ChevronLeft className="w-4 h-4" />
            السابق
          </button>

          <div className="text-gray-400 text-sm">
            {step} من 6
          </div>

          {step === 6 ? (
            <button
              onClick={handleSave}
              disabled={isLoading}
              className="px-6 py-2 bg-emerald-600 hover:bg-emerald-700 disabled:bg-gray-600 text-white rounded-lg font-semibold"
            >
              {isLoading ? '⏳ جاري الحفظ...' : '✅ حفظ الإصابة'}
            </button>
          ) : (
            <button
              onClick={() => setStep(Math.min(6, step + 1))}
              className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg"
            >
              التالي
              <ChevronRight className="w-4 h-4" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
