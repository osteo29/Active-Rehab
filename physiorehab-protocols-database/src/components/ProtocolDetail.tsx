import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ChevronRight, 
  Target, 
  AlertTriangle, 
  StepForward, 
  Activity,
  Clock,
  Download,
  ArrowLeft
} from 'lucide-react';

interface Exercise {
  name: string;
  parameters: string;
  cue: string;
}

interface Phase {
  number: number;
  title: string;
  timeline: string;
  goals: string[];
  precautions: string[];
  criteria: string[];
  exercises: Exercise[];
}

interface Protocol {
  name: string;
  category: string;
  phases: Phase[];
}

const ProtocolDetail: React.FC<{ protocol: Protocol, onBack: () => void }> = ({ protocol, onBack }) => {
  const [activePhase, setActivePhase] = useState(0);
  const phases = Array.isArray(protocol.phases) ? protocol.phases : [];
  const phase = phases[Math.min(activePhase, Math.max(phases.length - 1, 0))];

  if (!phase) {
    return (
      <div className="min-h-screen bg-slate-50 font-sans text-slate-900">
        <nav className="bg-white border-b border-slate-200 sticky top-0 z-20 print:hidden">
          <div className="max-w-5xl mx-auto px-4 h-16 flex items-center">
            <button
              onClick={onBack}
              className="flex items-center text-slate-600 hover:text-blue-600 transition-colors group"
            >
              <ArrowLeft className="w-5 h-5 mr-2 group-hover:-translate-x-1 transition-transform" />
              <span className="font-semibold text-sm uppercase tracking-wider">Medical Dashboard</span>
            </button>
          </div>
        </nav>
        <main className="max-w-5xl mx-auto px-4 py-24 text-center">
          <AlertTriangle className="w-10 h-10 text-amber-500 mx-auto mb-4" />
          <h1 className="text-2xl font-bold text-slate-900 mb-2">{protocol.name}</h1>
          <p className="text-slate-500">لا توجد مراحل علاجية مسجلة لهذا البروتوكول بعد. / No clinical phases are recorded for this protocol yet.</p>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 font-sans text-slate-900 selection:bg-blue-100">
      {/* Top Navigation */}
      <nav className="bg-white border-b border-slate-200 sticky top-0 z-20 print:hidden">
        <div className="max-w-5xl mx-auto px-4 h-16 flex items-center justify-between">
          <button 
            onClick={onBack}
            className="flex items-center text-slate-600 hover:text-blue-600 transition-colors group"
          >
            <ArrowLeft className="w-5 h-5 mr-2 group-hover:-translate-x-1 transition-transform" />
            <span className="font-semibold text-sm uppercase tracking-wider">Medical Dashboard</span>
          </button>
          <div className="flex items-center space-x-3">
            <button 
              onClick={() => window.print()}
              className="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-bold flex items-center hover:bg-blue-700 transition-all shadow-md shadow-blue-100"
            >
              <Download className="w-4 h-4 mr-2" />
              تصدير PDF
            </button>
          </div>
        </div>
      </nav>

      <main className="max-w-5xl mx-auto px-4 py-12 md:py-16">
        {/* Medical Header */}
        <header className="mb-12 border-l-4 border-blue-600 pl-6 md:pl-8 text-right">
          <div className="flex items-center justify-end space-x-2 text-blue-600 mb-2">
            <Activity className="w-5 h-5" />
            <span className="text-xs font-bold uppercase tracking-[0.2em]">{protocol.category}</span>
          </div>
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight text-slate-900 mb-4 leading-tight">
            {protocol.name}
          </h1>
          <div className="h-1 w-24 bg-blue-600 rounded-full mb-6 ml-0 mr-auto md:ml-auto md:mr-0"></div>
          <p className="text-slate-500 max-w-2xl ml-auto text-lg leading-relaxed italic">
            بروتوكول تفصيلي معتمد للممارسين الطبيين، يوضح خطة التأهيل من المرحلة الحادة وحتى العودة للنشاط الرياضي.
          </p>
        </header>

        {/* Phase Navigation - Professional Tabs */}
        <div className="sticky top-[64px] z-10 bg-slate-50/95 backdrop-blur-sm py-4 mb-10 border-b border-slate-200 print:hidden">
          <div className="flex overflow-x-auto pb-2 scrollbar-hide space-x-2 flex-row-reverse">
            {phases.map((p, idx) => (
              <button
                key={idx}
                onClick={() => setActivePhase(idx)}
                className={`flex-shrink-0 px-5 py-2.5 rounded-lg text-sm font-bold transition-all duration-200 ml-2 border ${
                  activePhase === idx 
                  ? 'bg-slate-900 text-white border-slate-900 shadow-lg scale-105' 
                  : 'bg-white text-slate-500 border-slate-200 hover:border-blue-400 hover:text-blue-600'
                }`}
              >
                المرحلة {p.number}: {p.title}
              </button>
            ))}
          </div>
        </div>

        {/* Current Phase Content */}
        <AnimatePresence mode="wait">
          <motion.div
            key={activePhase}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            className="space-y-10"
          >
            {/* Phase Metadata */}
            <div className="flex flex-col md:flex-row items-center justify-between bg-white p-6 rounded-2xl border border-slate-200 shadow-sm gap-4">
              <div className="flex items-center space-x-4 flex-row-reverse space-x-reverse">
                <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center font-black text-xl">
                  {phase.number}
                </div>
                <div className="text-right">
                  <h2 className="text-xl font-bold text-slate-900">{phase.title}</h2>
                  <p className="text-slate-400 text-sm font-medium">Phase Description & Parameters</p>
                </div>
              </div>
              
              <div className="flex items-center bg-amber-50 text-amber-700 px-6 py-3 rounded-full border border-amber-100 shadow-inner">
                <Clock className="w-5 h-5 mr-3 animate-pulse" />
                <span className="font-black tracking-wide text-sm whitespace-nowrap">{phase.timeline}</span>
              </div>
            </div>

            {/* Clinical Requirements Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {/* Goals */}
              <div className="relative group">
                <div className="absolute -inset-1 bg-gradient-to-r from-emerald-400 to-cyan-400 rounded-2xl blur opacity-10 group-hover:opacity-20 transition duration-1000"></div>
                <div className="relative bg-white p-8 rounded-2xl border border-slate-200 h-full">
                  <div className="flex items-center text-emerald-600 mb-6 border-b border-emerald-50 pb-4">
                    <Target className="w-6 h-6 mr-3" />
                    <h3 className="text-lg font-black tracking-tight">الأهداف (Goals)</h3>
                  </div>
                  <ul className="space-y-4">
                    {phase.goals.map((goal, i) => (
                      <li key={i} className="flex items-start text-[15px] leading-relaxed text-slate-700">
                        <div className="w-2 h-2 rounded-full bg-emerald-400 mt-2 mr-4 flex-shrink-0" />
                        <span className="font-medium">{goal}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              {/* Precautions */}
              <div className="relative group">
                <div className="absolute -inset-1 bg-gradient-to-r from-rose-400 to-orange-400 rounded-2xl blur opacity-10 group-hover:opacity-20 transition duration-1000"></div>
                <div className="relative bg-white p-8 rounded-2xl border border-slate-200 h-full">
                  <div className="flex items-center text-rose-600 mb-6 border-b border-rose-50 pb-4">
                    <AlertTriangle className="w-6 h-6 mr-3" />
                    <h3 className="text-lg font-black tracking-tight">احتياطات (Precautions)</h3>
                  </div>
                  <ul className="space-y-4">
                    {phase.precautions.map((pre, i) => (
                      <li key={i} className="flex items-start text-[15px] leading-relaxed text-slate-700">
                        <div className="w-2 h-2 rounded-full bg-rose-400 mt-2 mr-4 flex-shrink-0" />
                        <span className="font-bold text-rose-900">{pre}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              {/* Criteria */}
              <div className="relative group">
                <div className="absolute -inset-1 bg-gradient-to-r from-blue-400 to-indigo-400 rounded-2xl blur opacity-10 group-hover:opacity-20 transition duration-1000"></div>
                <div className="relative bg-white p-8 rounded-2xl border border-slate-200 h-full">
                  <div className="flex items-center text-blue-600 mb-6 border-b border-blue-50 pb-4">
                    <StepForward className="w-6 h-6 mr-3" />
                    <h3 className="text-lg font-black tracking-tight uppercase">معايير الانتقال</h3>
                  </div>
                  <ul className="space-y-4">
                    {phase.criteria.map((cri, i) => (
                      <li key={i} className="flex items-start text-[15px] leading-relaxed text-slate-700">
                        <div className="w-2 h-2 rounded-full bg-blue-400 mt-2 mr-4 flex-shrink-0" />
                        <span className="font-medium italic">{cri}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>

            {/* Exercise Prescription Table */}
            <div className="bg-white rounded-3xl border border-slate-200 shadow-xl shadow-slate-100/50 overflow-hidden">
              <div className="px-8 py-6 bg-slate-900 flex flex-col md:flex-row items-center justify-between gap-4">
                <div className="flex items-center text-white">
                  <Activity className="w-6 h-6 mr-3 text-blue-400" />
                  <h3 className="text-xl font-bold">وصف التمارين العلاجية</h3>
                </div>
                <div className="px-3 py-1 bg-blue-500/20 text-blue-300 text-[10px] font-black uppercase tracking-[0.2em] rounded border border-blue-500/30">
                  Evidence-Based Regimen
                </div>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-right border-collapse">
                  <thead className="bg-slate-50/50 text-slate-400 text-[11px] font-black uppercase tracking-widest border-b border-slate-100">
                    <tr>
                      <th className="px-8 py-5 text-right">Exercise Protocol</th>
                      <th className="px-8 py-5 text-right w-1/4">Prescription</th>
                      <th className="px-8 py-5 text-right w-1/3">Clinical Rationale</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-50">
                    {phase.exercises.map((ex, i) => (
                      <tr key={i} className="group hover:bg-blue-50/30 transition-all duration-300">
                        <td className="px-8 py-6">
                           <div className="font-bold text-slate-800 text-[16px] group-hover:text-blue-700 transition-colors">{ex.name}</div>
                        </td>
                        <td className="px-8 py-6 text-[13px] font-mono font-bold text-blue-600 bg-blue-50/20">
                          {ex.parameters}
                        </td>
                        <td className="px-8 py-6">
                          <div className="text-[14px] leading-relaxed text-slate-500 italic font-medium border-r-2 border-slate-100 pr-4">
                            {ex.cue}
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </motion.div>
        </AnimatePresence>

        {/* Footer Disclaimer */}
        <section className="mt-20 p-8 bg-slate-900 rounded-3xl text-white text-center">
          <AlertTriangle className="w-8 h-8 text-amber-500 mx-auto mb-4" />
          <h4 className="text-lg font-bold mb-2">إخلاء مسؤولية طبي</h4>
          <p className="text-slate-400 text-sm max-w-2xl mx-auto leading-relaxed">
            هذا البروتوكول مخصص للأغراض التعليمية والإرشادية فقط. يجب استشارة طبيب متخصص أو أخصائي علاج طبيعي قبل البدء في أي برنامج تمارين. النتائج الفردية قد تختلف بناءً على شدة الإصابة والحالة الصحية العامة.
          </p>
          <div className="mt-8 pt-8 border-t border-slate-800 flex flex-col md:flex-row justify-between items-center text-[10px] uppercase tracking-widest text-slate-500 gap-4">
            <span>© {new Date().getFullYear()} ActiveRehab Medical Systems</span>
            <div className="flex space-x-6">
              <span className="hover:text-white cursor-pointer transition-colors">Privacy Policy</span>
              <span className="hover:text-white cursor-pointer transition-colors">Clinical Standards</span>
              <span className="hover:text-white cursor-pointer transition-colors">Contact Support</span>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
};

export default ProtocolDetail;
