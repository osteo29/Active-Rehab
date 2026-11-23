import {useEffect, useState} from 'react';
import {LoaderCircle} from 'lucide-react';
import {Link, useNavigate} from 'react-router-dom';
import usePreferredLang from './usePreferredLang';
import {getCurrentSession, getSupabaseActionErrorMessage, onSupabaseAuthChange} from '../lib/supabase';

export default function AuthCallbackPage() {
  const navigate = useNavigate();
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;
    const lang = uiLang;
    const target = `/${lang}/`;

    const finishLogin = async () => {
      try {
        const session = await getCurrentSession();
        if (!mounted) return;

        if (session?.user) {
          navigate(target, {replace: true});
        }
      } catch (authError) {
        if (!mounted) return;
        setError(getSupabaseActionErrorMessage(authError, lang, 'auth'));
      }
    };

    void finishLogin();

    const {data} = onSupabaseAuthChange((event, session) => {
      if (!mounted) return;

      if (event === 'SIGNED_IN' && session?.user) {
        navigate(target, {replace: true});
      }
    });

    const timeoutId = window.setTimeout(() => {
      if (!mounted) return;
      setError((current) =>
        current || (lang === 'ar' ? 'تعذر إكمال تسجيل الدخول الاجتماعي.' : 'Could not complete social login.'),
      );
    }, 8000);

    return () => {
      mounted = false;
      window.clearTimeout(timeoutId);
      data.subscription.unsubscribe();
    };
  }, [navigate, uiLang]);

  return (
    <div dir={isAr ? 'rtl' : 'ltr'} className="flex min-h-screen items-center justify-center bg-soft-blue px-4">
      <div className="w-full max-w-md rounded-3xl border border-slate-200 bg-white p-6 text-center shadow-sm">
        {error ? (
          <>
            <h1 className="text-lg font-semibold text-slate-900">{isAr ? 'تعذر تسجيل الدخول' : 'Could not sign in'}</h1>
            <p role="alert" className="mt-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {error}
            </p>
            <Link className="mt-4 inline-block rounded-xl border border-slate-300 px-4 py-2 font-bold text-slate-700" to={`/${uiLang}/auth`}>{isAr ? 'العودة لتسجيل الدخول' : 'Back to sign in'}</Link>
          </>
        ) : (
          <>
            <LoaderCircle className="mx-auto h-6 w-6 animate-spin text-health-green" />
            <h1 className="mt-4 text-lg font-semibold text-slate-900">{isAr ? 'جار إكمال تسجيل الدخول' : 'Completing sign in'}</h1>
            <p className="mt-2 text-sm text-slate-500">
              {isAr ? 'يرجى الانتظار أثناء إكمال جلسة الدخول.' : 'Please wait while we finish signing you in.'}
            </p>
          </>
        )}
      </div>
    </div>
  );
}
