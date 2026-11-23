import {useEffect, useState} from 'react';
import type {User} from '@supabase/supabase-js';
import {
  getArticleAdminEmail,
  getCurrentUser,
  getSupabaseConfigurationMessage,
  isArticleAdminUser,
  isSupabaseConfigured,
  onSupabaseAuthChange,
  supabase,
} from '../lib/supabase';
import type {Language} from '../services/translations';
import type {TableRow} from '../lib/supabaseDatabase';

type AdminRecord = TableRow<'admin_users'>;
type AdminRole = 'admin' | 'editor' | 'writer' | 'unknown';

export type AdminAccessState = {
  authChecked: boolean;
  user: User | null;
  adminRecord: AdminRecord | null;
  adminRole: AdminRole;
  isSupabaseConfigured: boolean;
  configMessage: string;
  configuredAdminEmail: string;
  isArticleAdmin: boolean;
  canAccessAdminArea: boolean;
  canManageInjuries: boolean;
  canManageArticles: boolean;
  canManageSeo: boolean;
  canManageHomepage: boolean;
  canManageExercises: boolean;
  canManageMedia: boolean;
  canManageUsers: boolean;
};

async function loadAdminRecord(user: User | null) {
  if (!user?.id || !supabase) return null;

  const {data, error} = await supabase
    .from('admin_users')
    .select('*')
    .eq('user_id', user.id)
    .maybeSingle();

  if (error) {
    return null;
  }

  return data;
}

function buildAccessState(lang: Language, user: User | null, adminRecord: AdminRecord | null): AdminAccessState {
  const normalizedRole = typeof adminRecord?.role === 'string' ? adminRecord.role.trim().toLowerCase() : '';
  const adminRole: AdminRole =
    normalizedRole === 'admin' || normalizedRole === 'editor' || normalizedRole === 'writer'
      ? normalizedRole
      : 'unknown';
  const isArticleAdmin = isArticleAdminUser(user);
  const isRoleBasedAdmin = adminRole === 'admin';
  const isRoleBasedEditor = adminRole === 'editor';
  const isRoleBasedWriter = adminRole === 'writer';
  const canManageInjuries =
    isRoleBasedAdmin || Boolean(adminRecord?.can_edit_injuries) || Boolean(adminRecord?.can_edit_phases);
  const canManageArticles = isArticleAdmin || isRoleBasedAdmin || isRoleBasedEditor || isRoleBasedWriter;
  const canManageSeo = isRoleBasedAdmin || isRoleBasedEditor || canManageInjuries;
  const canManageHomepage = isRoleBasedAdmin || isRoleBasedEditor;
  const canManageExercises = canManageInjuries || isRoleBasedAdmin || isRoleBasedEditor;
  const canManageMedia = canManageArticles || canManageExercises || canManageHomepage || canManageInjuries;
  const canManageUsers = isRoleBasedAdmin;

  return {
    authChecked: true,
    user,
    adminRecord,
    adminRole,
    isSupabaseConfigured,
    configMessage: getSupabaseConfigurationMessage(lang),
    configuredAdminEmail: getArticleAdminEmail(),
    isArticleAdmin,
    canAccessAdminArea:
      canManageInjuries || canManageArticles || canManageSeo || canManageHomepage || canManageExercises || canManageUsers,
    canManageInjuries,
    canManageArticles,
    canManageSeo,
    canManageHomepage,
    canManageExercises,
    canManageMedia,
    canManageUsers,
  };
}

export default function useAdminAccess(lang: Language) {
  const [state, setState] = useState<AdminAccessState>({
    authChecked: false,
    user: null,
    adminRecord: null,
    isSupabaseConfigured,
    configMessage: getSupabaseConfigurationMessage(lang),
    configuredAdminEmail: getArticleAdminEmail(),
    isArticleAdmin: false,
    adminRole: 'unknown',
    canAccessAdminArea: false,
    canManageInjuries: false,
    canManageArticles: false,
    canManageSeo: false,
    canManageHomepage: false,
    canManageExercises: false,
    canManageMedia: false,
    canManageUsers: false,
  });

  useEffect(() => {
    let mounted = true;
    let requestVersion = 0;
    const resolveAccess = async (user: User | null) => {
      const version = ++requestVersion;
      // Revoke old capabilities immediately while a new identity is checked.
      setState({...buildAccessState(lang, null, null), authChecked: false});
      const adminRecord = await loadAdminRecord(user);
      if (!mounted || version !== requestVersion) return;
      setState(buildAccessState(lang, user, adminRecord));
    };

    const bootstrap = async () => {
      if (!isSupabaseConfigured) {
        if (mounted) {
          setState((current) => ({
            ...current,
            authChecked: true,
            configMessage: getSupabaseConfigurationMessage(lang),
          }));
        }
        return;
      }

      const version = requestVersion;
      try {
        const user = await getCurrentUser();
        if (!mounted || version !== requestVersion) return;
        await resolveAccess(user);
      } catch {
        if (!mounted || version !== requestVersion) return;
        setState(buildAccessState(lang, null, null));
      }
    };

    void bootstrap();

    if (!isSupabaseConfigured) {
      return () => {
        mounted = false;
      };
    }

    const {data} = onSupabaseAuthChange(async (_, session) => {
      if (!mounted) return;
      await resolveAccess(session?.user || null);
    });

    return () => {
      mounted = false;
      data.subscription.unsubscribe();
    };
  }, [lang]);

  return state;
}
