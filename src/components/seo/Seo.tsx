import {useEffect, useMemo, useState} from 'react';
import {applySeo, type SeoConfig} from './seoCore';
import {
  getCachedSeoOverrides,
  getSeoPageKeyForCanonicalPath,
  inferTemplateValuesFromSeoInput,
  loadSeoOverrides,
  resolveSeoCopy,
  type SeoLanguage,
  type SeoOverrideRow,
  type SeoPageKey,
} from '../../services/managedSeo';

function getCurrentLang(): SeoLanguage {
  if (typeof window === 'undefined') {
    return 'en';
  }

  const match = window.location.pathname.match(/^\/(en|ar)(?:\/|$)/);
  return match?.[1] === 'ar' ? 'ar' : 'en';
}

export default function Seo(props: SeoConfig) {
  const [overrides, setOverrides] = useState<Partial<Record<SeoPageKey, SeoOverrideRow>> | null>(
    () => getCachedSeoOverrides() || null,
  );
  const lang = getCurrentLang();

  useEffect(() => {
    let active = true;

    void loadSeoOverrides()
      .then((data) => {
        if (active) {
          setOverrides(data);
        }
      })
      .catch(() => {
        if (active) {
          setOverrides({});
        }
      });

    return () => {
      active = false;
    };
  }, []);

  const resolvedProps = useMemo(() => {
    const pageKey = getSeoPageKeyForCanonicalPath(props.canonicalPath);
    if (!pageKey) {
      return props;
    }

    const templateValues = inferTemplateValuesFromSeoInput({
      pageKey,
      title: props.title,
      description: props.description,
      lang,
    });

    const resolved = resolveSeoCopy({
      pageKey,
      lang,
      overrides,
      templateValues,
    });

    return {
      ...props,
      title: resolved.title || props.title,
      description: resolved.description || props.description,
    };
  }, [lang, overrides, props]);

  useEffect(() => {
    applySeo(resolvedProps);
  }, [
    resolvedProps.title,
    resolvedProps.description,
    resolvedProps.canonicalPath,
    resolvedProps.ogImage,
    resolvedProps.publishedTime,
    resolvedProps.noIndex,
    resolvedProps.structuredData,
    resolvedProps.hreflangs,
  ]);

  return null;
}
