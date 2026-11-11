import {Component, type ErrorInfo, type ReactNode} from 'react';

interface ErrorBoundaryProps {
  children: ReactNode;
  isAr?: boolean;
  homeHref?: string;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = {hasError: false, error: null};
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return {hasError: true, error};
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    console.error('[ErrorBoundary]', error, errorInfo);
  }

  render(): ReactNode {
    if (!this.state.hasError) {
      return this.props.children;
    }

    const isAr = this.props.isAr ?? false;

    return (
      <div className="flex min-h-[60vh] items-center justify-center px-4">
        <div className="w-full max-w-lg rounded-[1.75rem] border border-slate-200 bg-white p-8 text-center shadow-sm">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-red-50 text-red-500">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-8 w-8"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={2}
              aria-hidden="true"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.999L13.732 4.001c-.77-1.333-2.694-1.333-3.464 0L3.34 16.001C2.57 17.334 3.532 19 5.072 19z"
              />
            </svg>
          </div>

          <h2 className="mt-5 text-xl font-black text-slate-900">
            {isAr ? 'حدث خطأ غير متوقع' : 'Something went wrong'}
          </h2>

          <p className="mt-3 text-sm leading-7 text-slate-600">
            {isAr
              ? 'حصل خطأ أثناء تحميل الصفحة. جرب تحدث الصفحة أو ارجع للصفحة الرئيسية.'
              : 'An unexpected error occurred while loading this page. Try refreshing or go back to the home page.'}
          </p>

          {this.state.error ? (
            <div className="mt-4 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-left">
              <div className="text-xs font-bold uppercase tracking-[0.14em] text-slate-400">
                {isAr ? 'تفاصيل الخطأ' : 'Error details'}
              </div>
              <p className="mt-1 truncate text-xs text-slate-500">{this.state.error.message}</p>
            </div>
          ) : null}

          <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
            <button
              type="button"
              onClick={() => window.location.reload()}
              className="rounded-2xl bg-health-green px-6 py-2.5 text-sm font-bold text-white shadow-sm transition hover:bg-health-green-dark"
            >
              {isAr ? 'تحديث الصفحة' : 'Refresh page'}
            </button>

            <a
              href={this.props.homeHref || '/'}
              className="rounded-2xl border border-slate-200 bg-white px-6 py-2.5 text-sm font-bold text-slate-700 shadow-sm transition hover:border-health-green/30 hover:text-health-green"
            >
              {isAr ? 'الصفحة الرئيسية' : 'Go home'}
            </a>
          </div>
        </div>
      </div>
    );
  }
}

export {ErrorBoundary};
export default ErrorBoundary;
