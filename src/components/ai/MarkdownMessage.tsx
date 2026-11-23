import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

/**
 * Renders assistant answers (which arrive as markdown) with the app's visual
 * language instead of showing raw `**` and `-` characters to the visitor.
 */
export default function MarkdownMessage({text}: {text: string}) {
  return (
    <div className="space-y-2 text-sm leading-7">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          p: ({children}) => <p className="leading-7">{children}</p>,
          strong: ({children}) => <strong className="font-bold">{children}</strong>,
          em: ({children}) => <em className="italic">{children}</em>,
          ul: ({children}) => <ul className="list-disc space-y-1 ps-5">{children}</ul>,
          ol: ({children}) => <ol className="list-decimal space-y-1 ps-5">{children}</ol>,
          li: ({children}) => <li className="leading-6">{children}</li>,
          h1: ({children}) => <h3 className="pt-1 text-base font-black">{children}</h3>,
          h2: ({children}) => <h3 className="pt-1 text-base font-black">{children}</h3>,
          h3: ({children}) => <h4 className="pt-1 text-sm font-black">{children}</h4>,
          h4: ({children}) => <h5 className="pt-1 text-sm font-bold">{children}</h5>,
          a: ({children, href}) => (
            <a
              href={href}
              target="_blank"
              rel="noreferrer"
              className="font-semibold text-health-green underline underline-offset-2"
            >
              {children}
            </a>
          ),
          code: ({children, className}) =>
            className ? (
              <code className="block overflow-x-auto rounded-xl bg-slate-900 p-3 text-xs text-slate-100">
                {children}
              </code>
            ) : (
              <code className="rounded-md bg-slate-200/70 px-1 py-0.5 text-[0.85em] dark:bg-slate-700">
                {children}
              </code>
            ),
          blockquote: ({children}) => (
            <blockquote className="border-s-2 border-health-green/50 ps-3 text-slate-600 dark:text-slate-300">
              {children}
            </blockquote>
          ),
          table: ({children}) => (
            <div className="overflow-x-auto">
              <table className="w-full border-collapse text-xs">{children}</table>
            </div>
          ),
          th: ({children}) => <th className="border border-slate-300 px-2 py-1 text-start font-bold dark:border-slate-600">{children}</th>,
          td: ({children}) => <td className="border border-slate-300 px-2 py-1 dark:border-slate-600">{children}</td>,
          hr: () => <hr className="border-slate-200 dark:border-slate-700" />,
        }}
      >
        {text}
      </ReactMarkdown>
    </div>
  );
}
