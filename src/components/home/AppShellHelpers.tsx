import {Activity, BookOpen, Brain, Calculator, Calendar, ChevronRight, ClipboardList, Droplets, Filter, Flame, Globe, GraduationCap, HeartPulse, HelpCircle, Info, Menu, Percent, Plus, Scale, Search, ShieldAlert, Sparkles, Stethoscope, Tag, Trash2, Utensils, X, Zap} from 'lucide-react';
import {Suspense, useEffect, useRef, useState, type ComponentType, type ReactNode} from 'react';

const ICONS: Record<string, ComponentType<{className?: string}>> = {
  Activity,
  Calculator,
  BookOpen,
  Menu,
  X,
  ChevronRight,
  Stethoscope,
  HeartPulse,
  ClipboardList,
  GraduationCap,
  Info,
  Droplets,
  Scale,
  Percent,
  Flame,
  Utensils,
  Plus,
  Trash2,
  Globe,
  Calendar,
  Tag,
  Search,
  Filter,
  HelpCircle,
  Sparkles,
  Brain,
  Zap,
  ShieldAlert,
};

export function IconComponent({name, className}: {name: string; className?: string}) {
  const Icon = ICONS[name] || HelpCircle;
  return <Icon className={className} />;
}

export function HomeSectionFallback({
  className = 'bg-white py-16',
  lines = 3,
}: {
  className?: string;
  lines?: number;
}) {
  return (
    <section className={className} aria-hidden="true">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="animate-pulse rounded-[2rem] border border-slate-200 bg-slate-50 p-6 sm:p-8">
          <div className="mb-4 h-4 w-32 rounded-full bg-slate-200" />
          <div className="mb-8 h-8 w-56 rounded-full bg-slate-200" />
          <div className="grid gap-4 md:grid-cols-3">
            {Array.from({length: lines}).map((_, index) => (
              <div key={index} className="rounded-3xl border border-slate-200 bg-white p-5">
                <div className="mb-4 h-10 w-10 rounded-2xl bg-slate-200" />
                <div className="mb-3 h-4 w-2/3 rounded-full bg-slate-200" />
                <div className="h-3 w-full rounded-full bg-slate-200" />
                <div className="mt-2 h-3 w-5/6 rounded-full bg-slate-200" />
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

export function DeferredHomeSection({
  children,
  className,
  id,
  lines,
}: {
  children: ReactNode;
  className?: string;
  id?: string;
  lines?: number;
}) {
  const sectionRef = useRef<HTMLDivElement>(null);
  const [shouldRender, setShouldRender] = useState(false);

  useEffect(() => {
    const element = sectionRef.current;
    if (!element || shouldRender) return;

    if (!('IntersectionObserver' in window)) {
      setShouldRender(true);
      return;
    }

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (!entry.isIntersecting) return;
        setShouldRender(true);
        observer.disconnect();
      },
      {rootMargin: '700px 0px'},
    );

    observer.observe(element);
    return () => observer.disconnect();
  }, [shouldRender]);

  return (
    <div ref={sectionRef} id={id} className={id ? 'scroll-mt-20' : undefined}>
      {shouldRender ? (
        <Suspense fallback={<HomeSectionFallback className={className} lines={lines} />}>
          {children}
        </Suspense>
      ) : (
        <HomeSectionFallback className={className} lines={lines} />
      )}
    </div>
  );
}
