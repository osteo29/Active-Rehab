import {useEffect, useState} from 'react';
import {LoaderCircle} from 'lucide-react';
import {useNavigate} from 'react-router-dom';
import {getCurrentSession, getSupabaseActionErrorMessage, onSupabaseAuthChange, isSupabaseConfigured, getSupabaseConfigurationMessage} from '../lib/supabase';
import {getPreferredLanguage} from '../services/languagePreference';

export default function AuthCallbackPage() {
  const navigate = useNavigate();
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;
    const lang = getPreferredLanguage();
    const target = `/${lang}/`;
    if (!isSupabaseConfigured) {
      setError(getSupabaseConfigurationMessage(lang));
      return () => { mounted = false; };
    }

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
  }, [navigate]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-soft-blue px-4">
      <div className="w-full max-w-md rounded-3xl border border-slate-200 bg-white p-6 text-center shadow-sm">
        {error ? (
          <>
            <h1 className="text-lg font-semibold text-slate-900">Authentication error</h1>
            <p className="mt-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {error}
            </p>
          </>
        ) : (
          <>
            <LoaderCircle className="mx-auto h-6 w-6 animate-spin text-health-green" />
            <h1 className="mt-4 text-lg font-semibold text-slate-900">Completing sign in</h1>
            <p className="mt-2 text-sm text-slate-500">
              Please wait while we finish your secure session.
            </p>
          </>
        )}
      </div>
    </div>
  );
}
