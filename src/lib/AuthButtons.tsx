import {useEffect, useState} from 'react';
import {LoaderCircle, LogOut} from 'lucide-react';
import {
  getCurrentUser,
  getSupabaseActionErrorMessage,
  isSupabaseConfigured,
  onSupabaseAuthChange,
  signInWithSocial,
  signOutCurrentUser,
  type User,
} from './supabase';

type AuthButtonsProps = {
  lang?: 'en' | 'ar';
  className?: string;
  variant?: 'card' | 'embedded';
  onAuthenticated?: (user: User) => void;
  onLoggedOut?: () => void;
};

type SocialProvider = 'google' | 'facebook';

const REDIRECT_URL = 'https://activerehab.vercel.app';

export default function AuthButtons({
  lang = 'en',
  className = '',
  variant = 'card',
  onAuthenticated,
  onLoggedOut,
}: AuthButtonsProps) {
  const isAr = lang === 'ar';
  const [user, setUser] = useState<User | null>(null);
  const [loadingProvider, setLoadingProvider] = useState<SocialProvider | null>(null);
  const [loggingOut, setLoggingOut] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!isSupabaseConfigured) return;

    let mounted = true;

    const bootstrap = async () => {
      try {
        const currentUser = await getCurrentUser();
        if (!mounted) return;
        setUser(currentUser);
      } catch {
        if (!mounted) return;
        setUser(null);
      }
    };

    void bootstrap();

    const {data} = onSupabaseAuthChange((_, session) => {
      if (!mounted) return;

      const nextUser = session?.user || null;
      setUser(nextUser);
      setLoadingProvider(null);

      if (nextUser) {
        onAuthenticated?.(nextUser);
      } else {
        onLoggedOut?.();
      }
    });

    return () => {
      mounted = false;
      data.subscription.unsubscribe();
    };
  }, [onAuthenticated, onLoggedOut]);

  const handleLogin = async (provider: SocialProvider) => {
    if (!isSupabaseConfigured || loadingProvider || loggingOut) return;

    setError('');
    setLoadingProvider(provider);

    try {
      await signInWithSocial(provider);
    } catch (authError) {
      setLoadingProvider(null);
      setError(getSupabaseActionErrorMessage(authError, lang, 'auth'));
    }
  };

  const handleLogout = async () => {
    if (loggingOut || loadingProvider) return;

    setError('');
    setLoggingOut(true);

    try {
      await signOutCurrentUser();
      setUser(null);
      onLoggedOut?.();
    } catch (authError) {
      setError(getSupabaseActionErrorMessage(authError, lang, 'auth'));
    } finally {
      setLoggingOut(false);
    }
  };

  const profileName =
    user?.user_metadata?.full_name ||
    user?.user_metadata?.name ||
    user?.email?.split('@')[0] ||
    (isAr ? 'مستخدم' : 'User');
  const avatarUrl =
    typeof user?.user_metadata?.avatar_url === 'string' ? user.user_metadata.avatar_url : '';
  const shellClassName =
    variant === 'card'
      ? `flex min-h-[420px] items-center justify-center px-4 py-6 ${className}`.trim()
      : className;
  const cardClassName =
    variant === 'card'
      ? 'w-full max-w-[400px] rounded-3xl border border-slate-200 bg-white p-6 shadow-sm'
      : 'w-full rounded-3xl border border-slate-200 bg-slate-50/70 p-5';

  if (user) {
    return (
      <div className={shellClassName}>
        <div className={cardClassName}>
          <div className="flex items-center gap-4">
            {avatarUrl ? (
              <img
                src={avatarUrl}
                alt={profileName}
                loading="lazy"
                decoding="async"
                className="h-14 w-14 rounded-full border border-slate-200 object-cover"
              />
            ) : (
              <div className="flex h-14 w-14 items-center justify-center rounded-full bg-slate-100 text-lg font-semibold text-slate-700">
                {profileName.charAt(0).toUpperCase()}
              </div>
            )}

            <div className="min-w-0">
              <p className="text-sm text-slate-500">{isAr ? 'تم تسجيل الدخول' : 'Signed in'}</p>
              <p className="truncate text-base font-semibold text-slate-900">{profileName}</p>
              <p className="truncate text-sm text-slate-500">{user.email || REDIRECT_URL}</p>
            </div>
          </div>

          <button
            type="button"
            onClick={handleLogout}
            disabled={loggingOut}
            aria-label={isAr ? 'تسجيل الخروج' : 'Logout'}
            className="mt-5 inline-flex w-full items-center justify-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-medium text-slate-700 transition duration-200 hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-400 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-70"
          >
            {loggingOut ? <LoaderCircle className="h-4 w-4 animate-spin" /> : <LogOut className="h-4 w-4" />}
            <span>{loggingOut ? 'Loading...' : isAr ? 'تسجيل الخروج' : 'Logout'}</span>
          </button>

          {error ? (
            <p className="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {error}
            </p>
          ) : null}
        </div>
      </div>
    );
  }

  const isBusy = Boolean(loadingProvider || loggingOut);

  return (
    <div className={shellClassName} aria-live="polite">
      <div className={cardClassName}>
        <div className="mb-5 text-center">
          <h2 className="text-xl font-semibold text-slate-900">
            {isAr ? 'تابع باستخدام حسابك' : 'Continue with your account'}
          </h2>
          <p className="mt-2 text-sm text-slate-500">
            {isAr ? 'اختر مزود تسجيل الدخول المناسب لك.' : 'Choose your preferred sign-in provider.'}
          </p>
        </div>

        <div className="space-y-3">
          <SocialButton
            provider="google"
            label="Google"
            isBusy={loadingProvider === 'google'}
            disabled={isBusy}
            onClick={handleLogin}
            ariaLabel={isAr ? 'تسجيل الدخول باستخدام Google' : 'Login with Google'}
          />
          <SocialButton
            provider="facebook"
            label="Facebook"
            isBusy={loadingProvider === 'facebook'}
            disabled={isBusy}
            onClick={handleLogin}
            ariaLabel={isAr ? 'تسجيل الدخول باستخدام Facebook' : 'Login with Facebook'}
          />
        </div>

        {error ? (
          <p className="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {error}
          </p>
        ) : null}
      </div>
    </div>
  );
}

function SocialButton({
  provider,
  label,
  isBusy,
  disabled,
  onClick,
  ariaLabel,
}: {
  provider: SocialProvider;
  label: string;
  isBusy: boolean;
  disabled: boolean;
  onClick: (provider: SocialProvider) => void;
  ariaLabel: string;
}) {
  const isGoogle = provider === 'google';

  return (
    <button
      type="button"
      onClick={() => onClick(provider)}
      disabled={disabled}
      aria-label={ariaLabel}
      className={[
        'flex w-full items-center justify-center gap-3 rounded-xl px-4 py-3.5 shadow-sm transition duration-200',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
        'disabled:cursor-not-allowed disabled:opacity-70',
        isGoogle
          ? 'border border-slate-200 bg-white text-slate-800 hover:bg-slate-50 focus-visible:ring-slate-400'
          : 'border border-[#1877F2] bg-[#1877F2] text-white hover:bg-[#1669d8] focus-visible:ring-[#1877F2]',
      ].join(' ')}
    >
      <span className="shrink-0" aria-hidden="true">
        {isBusy ? <LoaderCircle className="h-5 w-5 animate-spin" /> : isGoogle ? <GoogleIcon /> : <FacebookIcon />}
      </span>
      <span className="text-sm font-semibold">{isBusy ? 'Loading...' : `Login with ${label}`}</span>
    </button>
  );
}

function GoogleIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-5 w-5" aria-hidden="true">
      <path
        fill="#4285F4"
        d="M21.8 12.23c0-.72-.06-1.25-.2-1.8H12v3.4h5.64c-.11.84-.7 2.1-2 2.95l-.02.11 2.72 2.1.19.02c1.78-1.64 2.8-4.04 2.8-6.78Z"
      />
      <path
        fill="#34A853"
        d="M12 22c2.76 0 5.08-.9 6.77-2.44l-3.23-2.5c-.87.6-2.03 1.03-3.54 1.03-2.7 0-4.98-1.78-5.8-4.25l-.1.01-2.83 2.18-.03.1A10.23 10.23 0 0 0 12 22Z"
      />
      <path
        fill="#FBBC05"
        d="M6.2 13.84A6.13 6.13 0 0 1 5.87 12c0-.64.12-1.26.31-1.84l-.01-.12-2.86-2.22-.1.05A10.06 10.06 0 0 0 2 12c0 1.45.35 2.83.98 4.05l3.22-2.21Z"
      />
      <path
        fill="#EA4335"
        d="M12 5.91c1.9 0 3.18.82 3.92 1.51l2.86-2.8C17.07 3.01 14.76 2 12 2a10.23 10.23 0 0 0-9.15 5.87l3.23 2.5c.83-2.48 3.11-4.46 5.92-4.46Z"
      />
    </svg>
  );
}

function FacebookIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-5 w-5 fill-current" aria-hidden="true">
      <path d="M24 12.07C24 5.4 18.63 0 12 0S0 5.4 0 12.07c0 6.03 4.39 11.02 10.12 11.93v-8.44H7.08v-3.5h3.04V9.4c0-3.02 1.78-4.7 4.52-4.7 1.31 0 2.69.24 2.69.24v2.97h-1.52c-1.5 0-1.96.93-1.96 1.89v2.27h3.34l-.53 3.5h-2.8V24C19.61 23.09 24 18.1 24 12.07Z" />
    </svg>
  );
}
