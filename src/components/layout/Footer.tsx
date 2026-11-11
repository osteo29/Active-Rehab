import {memo} from 'react';
import {Link} from 'react-router-dom';
import {Facebook, Instagram, Mail, MapPin, ShieldAlert} from 'lucide-react';
import type {Language} from '../../services/translations';
import {navigationPaths} from '../../utils/langUrlHelper';
import BrandLogo from '../common/BrandLogo';

const Footer = memo(({t, lang}: {t: any; lang: Language}) => {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="relative overflow-hidden border-t border-white/5 bg-[#0f0d0a] pb-10 pt-18">
      <div className="pointer-events-none absolute inset-0 opacity-100">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(212,172,86,0.14),transparent_24%),linear-gradient(180deg,rgba(15,13,10,0.98),rgba(24,21,17,0.98))]" />
        <div className="absolute right-0 top-0 h-80 w-80 translate-x-1/2 -translate-y-1/2 rounded-full bg-health-green/20 blur-[120px]" />
        <div className="absolute bottom-0 left-0 h-80 w-80 -translate-x-1/2 translate-y-1/2 rounded-full bg-white/6 blur-[120px]" />
      </div>

      <div className="relative z-10 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1.1fr)_repeat(3,minmax(0,0.7fr))]">
          <div className="space-y-6">
            <BrandLogo
              textTone="light"
              imageClassName="h-12 w-12 border-white/15"
              title="ACTIVE REHAB"
              subtitle="MOVE BETTER • FEEL BETTER"
            />
            <p className="max-w-sm leading-7 text-slate-300">
              {lang === 'en'
                ? 'A recovery-focused platform that combines injury guidance, nutrition thinking, and calmer follow-up tools under one clearer identity.'
                : 'منصة تركّز على التعافي وتجمع بين إرشاد الإصابات والتغذية والمتابعة داخل هوية أوضح وأكثر ثباتًا.'}
            </p>

            <div className="flex flex-wrap gap-3">
              <a
                href="https://www.facebook.com/share/1E1dS4G8Kn/"
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-2 rounded-xl border border-white/10 bg-white/5 px-3 py-2 text-sm font-semibold text-slate-200 transition-colors hover:text-health-green"
              >
                <Facebook className="h-4 w-4" />
                <span>Facebook</span>
              </a>
              <a
                href="https://www.instagram.com/physionutrition.official/"
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-2 rounded-xl border border-white/10 bg-white/5 px-3 py-2 text-sm font-semibold text-slate-200 transition-colors hover:text-health-green"
              >
                <Instagram className="h-4 w-4" />
                <span>Instagram</span>
              </a>
            </div>
          </div>

          <div>
            <h3 className="mb-5 text-lg font-bold text-white">{t.footer.categories.product}</h3>
            <ul className="space-y-3">
              {[
                {label: t.footer.links.calculators, href: '#calculators'},
                {label: t.footer.links.insights, href: '#blog'},
                {label: t.footer.links.architect, href: '#architect'},
              ].map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-slate-300 transition-colors hover:text-health-green">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h3 className="mb-5 text-lg font-bold text-white">{t.footer.categories.company}</h3>
            <ul className="space-y-3">
              {[
                {label: t.footer.links.about, href: navigationPaths.about(lang)},
                {label: t.footer.links.contact, href: navigationPaths.contact(lang)},
                {label: t.footer.links.privacy, href: navigationPaths.privacy(lang)},
                {label: t.footer.links.terms, href: navigationPaths.terms(lang)},
                {
                  label: t.footer.links.disclaimer,
                  href: navigationPaths.disclaimer(lang),
                },
              ].map((link) => (
                <li key={link.href}>
                  <Link to={link.href} className="text-slate-300 transition-colors hover:text-health-green">
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h3 className="mb-5 text-lg font-bold text-white">{t.footer.categories.contact}</h3>
            <ul className="space-y-5">
              <li className="flex items-start gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-xl border border-white/10 bg-white/5 text-health-green">
                  <Mail className="h-5 w-5" />
                </div>
                <div>
                  <div className="mb-1 text-xs uppercase tracking-widest text-slate-400">
                    {lang === 'en' ? 'Email' : 'البريد الإلكتروني'}
                  </div>
                  <a
                    href="mailto:physionutritionofficial@gmail.com"
                    className="text-slate-300 transition-colors hover:text-health-green"
                  >
                    {lang === 'en' ? 'Email us' : 'راسلنا بالبريد'}
                  </a>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-xl border border-white/10 bg-white/5 text-health-green">
                  <MapPin className="h-5 w-5" />
                </div>
                <div>
                  <div className="mb-1 text-xs uppercase tracking-widest text-slate-400">
                    {lang === 'en' ? 'Availability' : 'التواجد'}
                  </div>
                  <span className="text-slate-300">{lang === 'en' ? 'Remote / Online' : 'عن بعد / أونلاين'}</span>
                </div>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-10 rounded-[2rem] border border-white/10 bg-white/5 p-5 sm:p-6">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-start">
            <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-500/10 text-amber-400">
              <ShieldAlert className="h-7 w-7" />
            </div>
            <div>
              <h4 className="font-bold text-white">{t.footer.disclaimerTitle}</h4>
              <p className="mt-2 text-sm leading-6 text-slate-300">{t.footer.disclaimerText}</p>
            </div>
          </div>
        </div>

        <div className="mt-8 flex flex-col gap-4 border-t border-white/10 pt-6 sm:flex-row sm:items-center sm:justify-between">
          <p className="text-sm text-slate-400">
            © {currentYear} Active Rehab. {t.footer.rights}
          </p>
          <div className="flex flex-wrap gap-4">
            <Link to={navigationPaths.privacy(lang)} className="text-sm text-slate-400 transition-colors hover:text-white">
              {t.footer.links.privacy}
            </Link>
            <Link to={navigationPaths.terms(lang)} className="text-sm text-slate-400 transition-colors hover:text-white">
              {t.footer.links.terms}
            </Link>
            <Link to={navigationPaths.cookies(lang)} className="text-sm text-slate-400 transition-colors hover:text-white">
              {t.footer.links.cookies}
            </Link>
            <Link to={navigationPaths.disclaimer(lang)} className="text-sm text-slate-400 transition-colors hover:text-white">
              {t.footer.links.disclaimer}
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
});

Footer.displayName = 'Footer';

export default Footer;
