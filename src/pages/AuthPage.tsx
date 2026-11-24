import {type FormEvent, useEffect, useState} from 'react';
import {Link, useLocation, useNavigate, useSearchParams} from 'react-router-dom';
import {LoaderCircle, LockKeyhole, Moon, Sun} from 'lucide-react';
import Seo from '../components/seo/Seo';
import BrandLogo from '../components/common/BrandLogo';
import usePreferredLang from './usePreferredLang';
import AuthButtons from '../lib/AuthButtons';
import {
  getCurrentUser,
  getSupabaseActionErrorMessage,
  getSupabaseConfigurationMessage,
  isSupabaseConfigured,
  onSupabaseAuthChange,
  signInWithEmail,
  signUpWithEmail,
  type User,
} from '../lib/supabase';
import {autoRequestBrowserNotifications} from '../lib/notifications';

export default function AuthPage({
  theme,
  onToggleTheme,
}: {
  theme: 'light' | 'dark';
  onToggleTheme: () => void;
}) {
  const lang = usePreferredLang();
  const isAr = lang === 'ar';
  const navigate = useNavigate();
  const location = useLocation();
  const [searchParams] = useSearchParams();
  const redirectTo = (location.state as {from?: string} | null)?.from || '/dashboard';
  const requestedMode = searchParams.get('mode') === 'signup' ? 'signup' : 'signin';

  const [user, setUser] = useState<User | null>(null);
  const [mode, setMode] = useState<'signin' | 'signup'>(requestedMode);
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [checkingSession, setCheckingSession] = useState(true);
  const [message, setMessage] = useState('');
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [emailExists, setEmailExists] = useState(false);

  useEffect(() => {
    if (!isSupabaseConfigured) {
      setCheckingSession(false);
      return;
    }

    let mounted = true;

    const bootstrap = async () => {
      try {
        const currentUser = await getCurrentUser();
        if (!mounted) return;
        setUser(currentUser);
        if (currentUser) {
          navigate(redirectTo, {replace: true});
        }
      } catch {
        if (mounted) setUser(null);
      } finally {
        if (mounted) setCheckingSession(false);
      }
    };

    void bootstrap();

    const {data} = onSupabaseAuthChange((_, session) => {
      if (!mounted) return;
      setUser(session?.user || null);
      setCheckingSession(false);
      if (session?.user) {
        navigate(redirectTo, {replace: true});
      }
    });

    return () => {
      mounted = false;
      data.subscription.unsubscribe();
    };
  }, [navigate, redirectTo]);

  useEffect(() => {
    setEmailExists(false);
    setMessage('');
    setStatus('idle');
  }, [mode, email]);

  useEffect(() => {
    setMode(requestedMode);
  }, [requestedMode]);

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (loading) return;

    if (!isSupabaseConfigured) {
      setStatus('error');
      setMessage(getSupabaseConfigurationMessage(lang));
      return;
    }

    setLoading(true);
    setStatus('idle');
    setMessage('');
    setEmailExists(false);

    try {
      if (mode === 'signup') {
        const result = await signUpWithEmail(email.trim(), password, {
          fullName: fullName.trim(),
        });

        if (result.user && (result.user.identities?.length ?? 0) === 0) {
          setStatus('error');
          setEmailExists(true);
          setMessage(
            isAr
              ? 'هذا البريد الإلكتروني مسجّل بالفعل. سجّل دخولك بدلاً من إنشاء حساب جديد.'
              : 'This email is already registered. Please sign in instead of creating a new account.',
          );
          return;
        }

        if (result.session) {
          await autoRequestBrowserNotifications(lang);
        }

        if (result.user && !result.session) {
          setStatus('success');
          setMessage(
            isAr
              ? 'تم إنشاء الحساب. تحقق من بريدك الإلكتروني لتأكيد الحساب ثم سجّل الدخول.'
              : 'Account created. Check your email to confirm the account, then sign in.',
          );
        } else {
          setStatus('success');
          setMessage(
            isAr
              ? 'تم إنشاء الحساب وتسجيل الدخول بنجاح.'
              : 'Account created and signed in successfully.',
          );
        }
      } else {
        await signInWithEmail(email.trim(), password);
        await autoRequestBrowserNotifications(lang);
        setStatus('success');
        setMessage(isAr ? 'تم تسجيل الدخول بنجاح.' : 'Signed in successfully.');
      }
    } catch (error) {
      const raw = error instanceof Error ? error.message.toLowerCase() : '';
      const isDuplicate =
        raw.includes('user already registered') ||
        raw.includes('already been registered') ||
        raw.includes('already registered') ||
        raw.includes('email address is already') ||
        raw.includes('duplicate') ||
        (error as {status?: number})?.status === 400;

      if (mode === 'signup' && isDuplicate) {
        setStatus('error');
        setEmailExists(true);
        setMessage(
          isAr
            ? 'هذا البريد الإلكتروني مسجّل بالفعل. سجّل دخولك بدلاً من إنشاء حساب جديد.'
            : 'This email is already registered. Please sign in instead of creating a new account.',
        );
      } else {
        setStatus('error');
        setMessage(getSupabaseActionErrorMessage(error, lang, 'auth'));
      }
    } finally {
      setLoading(false);
    }
  };

  if (checkingSession) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-soft-blue px-4">
        <div className="inline-flex items-center gap-2 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-5 py-4 text-slate-600 dark:text-slate-300 shadow-sm">
          <LoaderCircle className="h-4 w-4 animate-spin" />
          <span>{isAr ? 'جارٍ التحقق من الجلسة' : 'Checking session'}</span>
        </div>
      </div>
    );
  }

  if (user) return null;

  return (
    <div className="min-h-screen bg-soft-blue">
      <Seo
        title={isAr ? 'تسجيل الدخول | Active Rehab' : 'Login | Active Rehab'}
        description={
          isAr
            ? 'أنشئ حسابًا أو سجّل الدخول لحفظ النتائج وربطها بسجل متابعة آمن.'
            : 'Create an account or sign in to save results and review them in a secure tracking dashboard.'
        }
        canonicalPath="/auth"
        noIndex
      />

      <nav className="sticky top-0 z-50 border-b border-slate-100 dark:border-slate-800 bg-white/85 dark:bg-slate-900/85 px-3 backdrop-blur-md sm:px-6 lg:px-8">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between gap-3">
          <Link to="/" className="group">
            <BrandLogo imageClassName="transition-transform group-hover:scale-105" />
          </Link>

          <button
            onClick={onToggleTheme}
            className="flex items-center gap-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 px-3 py-2 text-slate-700 dark:text-slate-200 transition-all hover:border-health-green/30"
            aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
          >
            {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
          </button>
        </div>
      </nav>

      <div className="mx-auto flex min-h-[calc(100vh-4rem)] max-w-6xl items-center px-4 py-10 sm:px-6 lg:px-8">
        <div className="grid w-full grid-cols-1 gap-6 lg:grid-cols-[1fr_0.95fr]">
          <div className="rounded-[2rem] border border-slate-200 dark:border-slate-700 bg-white/80 dark:bg-slate-900/80 p-6 shadow-sm sm:p-8">
            <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-health-green/20 bg-health-green/10 px-4 py-2 text-xs font-bold uppercase tracking-[0.16em] text-health-green">
              <LockKeyhole className="h-4 w-4" />
              <span>{isAr ? 'مساحة آمنة' : 'Secure access'}</span>
            </div>
            <h1 className="text-3xl font-black text-slate-900 dark:text-white sm:text-4xl">
              {isAr ? 'احفظ نتائجك داخل حسابك' : 'Save your results inside your account'}
            </h1>
            <p className="mt-3 max-w-xl text-sm leading-7 text-slate-600 dark:text-slate-300 sm:text-base">
              {isAr
                ? 'أنشئ حسابًا أو سجّل الدخول لحفظ القياسات، مراجعة السجل الزمني، والحفاظ على متابعتك مستمرة على نفس الجهاز وبعد كل تحديث للصفحة.'
                : 'Create an account or sign in to save assessments, review history, and keep your session active after refreshes on the same device.'}
            </p>

            <div className="mt-8 grid grid-cols-1 gap-4 md:grid-cols-3">
              {[
                {
                  title: isAr ? 'حفظ آمن' : 'Secure saves',
                  desc: isAr ? 'كل نتيجة ترتبط بحسابك فقط.' : 'Each result is linked to your account only.',
                },
                {
                  title: isAr ? 'متابعة واضحة' : 'Clear follow-up',
                  desc: isAr ? 'راجع السجل والرسوم من لوحة واحدة.' : 'Review history and charts from one dashboard.',
                },
                {
                  title: isAr ? 'تسجيل مستمر' : 'Persistent login',
                  desc: isAr ? 'يبقى دخولك محفوظًا على نفس الجهاز.' : 'Your login stays active on the same device.',
                },
              ].map((item) => (
                <div key={item.title} className="rounded-[1.5rem] border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-950 p-4">
                  <div className="font-bold text-slate-900 dark:text-white">{item.title}</div>
                  <p className="mt-2 text-sm leading-6 text-slate-600 dark:text-slate-300">{item.desc}</p>
                </div>
              ))}
            </div>
          </div>

          <div className="rounded-[2rem] border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 shadow-xl shadow-slate-200/50 sm:p-8">
            {!isSupabaseConfigured ? (
              <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-600">
                {getSupabaseConfigurationMessage(lang)}
              </div>
            ) : (
              <>
                <div className="mb-6 flex gap-2 rounded-full border border-slate-200 dark:border-slate-700 bg-slate-100 dark:bg-slate-800 p-1">
                  <button
                    onClick={() => setMode('signin')}
                    className={`flex-1 rounded-full px-4 py-2 text-sm font-bold transition-all ${
                      mode === 'signin' ? 'bg-white text-health-green shadow-sm' : 'text-slate-500'
                    }`}
                  >
                    {isAr ? 'تسجيل الدخول' : 'Sign in'}
                  </button>
                  <button
                    onClick={() => setMode('signup')}
                    className={`flex-1 rounded-full px-4 py-2 text-sm font-bold transition-all ${
                      mode === 'signup' ? 'bg-white text-health-green shadow-sm' : 'text-slate-500'
                    }`}
                  >
                    {isAr ? 'إنشاء حساب' : 'Create account'}
                  </button>
                </div>

                <div className="mb-6">
                  <AuthButtons lang={lang} variant="embedded" />
                </div>

                <div className="mb-6 flex items-center gap-3">
                  <div className="h-px flex-1 bg-slate-200" />
                  <span className="text-xs font-semibold uppercase tracking-[0.14em] text-slate-400">
                    {isAr ? 'أو' : 'or'}
                  </span>
                  <div className="h-px flex-1 bg-slate-200" />
                </div>

                <form className="space-y-4" onSubmit={handleSubmit}>
                  {mode === 'signup' ? (
                    <input
                      aria-label={isAr ? 'الاسم الكامل' : 'Full name'}
                      value={fullName}
                      onChange={(e) => setFullName(e.target.value)}
                      placeholder={isAr ? 'الاسم الكامل' : 'Full name'}
                      className="w-full rounded-2xl border border-slate-200 dark:border-slate-700 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green/30"
                    />
                  ) : null}

                  <input
                    type="email"
                    aria-label={isAr ? 'البريد الإلكتروني' : 'Email address'}
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder={isAr ? 'البريد الإلكتروني' : 'Email address'}
                    className="w-full rounded-2xl border border-slate-200 dark:border-slate-700 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green/30"
                    required
                  />

                  <input
                    type="password"
                    aria-label={isAr ? 'كلمة المرور' : 'Password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder={isAr ? 'كلمة المرور' : 'Password'}
                    className="w-full rounded-2xl border border-slate-200 dark:border-slate-700 px-4 py-3 outline-none focus:ring-2 focus:ring-health-green/30"
                    required
                    minLength={6}
                  />

                  <button
                    disabled={loading}
                    className="flex w-full items-center justify-center gap-2 rounded-2xl bg-health-green px-5 py-3 font-bold text-white transition-all hover:bg-health-green-dark disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {loading ? <LoaderCircle className="h-4 w-4 animate-spin" /> : null}
                    <span>
                      {loading
                        ? isAr
                          ? 'جارٍ التنفيذ'
                          : 'Please wait'
                        : mode === 'signup'
                          ? isAr
                            ? 'إنشاء حساب'
                            : 'Create account'
                          : isAr
                            ? 'تسجيل الدخول'
                            : 'Sign in'}
                    </span>
                  </button>
                </form>
              </>
            )}

            {message ? (
              <div
                className={`mt-4 rounded-2xl border px-4 py-3 text-sm ${
                  status === 'success'
                    ? 'border-health-green/20 bg-health-green/10 text-health-green-dark'
                    : 'border-rose-200 bg-rose-50 text-rose-600'
                }`}
              >
                <p>{message}</p>

                {emailExists ? (
                  <button
                    onClick={() => {
                      setMode('signin');
                      setMessage('');
                      setStatus('idle');
                      setEmailExists(false);
                    }}
                    className="mt-3 w-full rounded-xl bg-rose-600 px-4 py-2 font-bold text-white transition-all hover:bg-rose-700"
                  >
                    {isAr ? 'تسجيل الدخول بدلاً من ذلك' : 'Switch to sign in'}
                  </button>
                ) : null}
              </div>
            ) : null}
          </div>
        </div>
      </div>
    </div>
  );
}
