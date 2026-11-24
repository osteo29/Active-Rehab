import {memo} from 'react';
import {motion} from 'motion/react';
import {ArrowUpRight, Mail, ShieldAlert, X} from 'lucide-react';
import type {Language} from '../../services/translations';

const NewsletterSection = memo(({lang}: {lang: Language}) => {
  return (
    <section className="py-32 bg-slate-900 relative overflow-hidden">
      <div className="absolute top-0 left-0 w-full h-full opacity-20 pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-[500px] h-[500px] bg-health-green rounded-full blur-[150px] animate-pulse" />
        <div className="absolute bottom-1/4 right-1/4 w-[500px] h-[500px] bg-medical-blue rounded-full blur-[150px] animate-pulse" />
      </div>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="bg-white/5 backdrop-blur-xl rounded-[3rem] p-8 md:p-16 border border-white/10 text-center">
          <motion.div
            initial={{opacity: 0, scale: 0.9}}
            whileInView={{opacity: 1, scale: 1}}
            viewport={{once: true}}
          >
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/5 text-slate-300 text-xs font-bold mb-8 uppercase tracking-widest border border-white/10">
              <Mail className="w-4 h-4" />
              <span>{lang === 'en' ? 'Newsletter' : 'النشرة البريدية'}</span>
            </div>
            <h2 className="text-3xl md:text-5xl font-bold text-white mb-8 leading-tight">
              {lang === 'en' ? 'Stay Updated with' : 'ابق على اطلاع بـ'} <br />
              <span className="text-health-green">
                {lang === 'en' ? 'Clinical Insights' : 'الرؤى السريرية'}
              </span>
            </h2>
            <p className="text-slate-400 mb-12 text-lg max-w-2xl mx-auto leading-relaxed">
              {lang === 'en'
                ? 'Join our community of clinicians and health enthusiasts. Get the latest protocols and tools delivered to your inbox.'
                : 'انضم إلى مجتمعنا من الممارسين والمهتمين بالصحة. احصل على أحدث البروتوكولات والأدوات مباشرة في بريدك الوارد.'}
            </p>

            <form
              className="flex flex-col md:flex-row gap-4 max-w-2xl mx-auto"
              onSubmit={(e) => e.preventDefault()}
            >
              <div className="flex-1 relative group">
                <Mail className="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-health-green transition-colors" />
                <input
                  type="email"
                  aria-label={lang === 'en' ? 'Enter your email' : 'أدخل بريدك الإلكتروني'}
                  placeholder={lang === 'en' ? 'Enter your email' : 'أدخل بريدك الإلكتروني'}
                  className={`w-full ${
                    lang === 'ar' ? 'pr-14 pl-6' : 'pl-14 pr-6'
                  } py-5 rounded-2xl bg-white/5 border border-white/10 text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-health-green/50 focus:bg-white/10 transition-all duration-300`}
                />
              </div>
              <button className="px-10 py-5 bg-health-green text-white font-bold rounded-2xl hover:bg-health-green-dark transition-all shadow-xl shadow-health-green/20 flex items-center justify-center gap-2 group">
                {lang === 'en' ? 'Subscribe Now' : 'اشترك الآن'}
                <ArrowUpRight className="w-5 h-5 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform" />
              </button>
            </form>

            <div className="flex flex-wrap justify-center gap-8 mt-12 text-slate-500 text-sm">
              <div className="flex items-center gap-2">
                <ShieldAlert className="w-4 h-4" />
                <span>{lang === 'en' ? 'No Spam' : 'بدون رسائل مزعجة'}</span>
              </div>
              <div className="flex items-center gap-2">
                <X className="w-4 h-4" />
                <span>
                  {lang === 'en' ? 'Unsubscribe anytime' : 'إلغاء الاشتراك في أي وقت'}
                </span>
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
});

NewsletterSection.displayName = 'NewsletterSection';

export default NewsletterSection;

