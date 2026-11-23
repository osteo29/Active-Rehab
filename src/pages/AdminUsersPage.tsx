import {useEffect, useState} from 'react';
import Seo from '../components/seo/Seo';
import AdminAccessBoundary from '../components/admin/AdminAccessBoundary';
import AdminShell from '../components/admin/AdminShell';
import useAdminAccess from '../hooks/useAdminAccess';
import usePreferredLang from './usePreferredLang';
import {listAdminUsers, type AdminUserRow, updateAdminUser} from '../services/adminCms';

export default function AdminUsersPage() {
  const uiLang = usePreferredLang();
  const isAr = uiLang === 'ar';
  const access = useAdminAccess(uiLang);
  const [users, setUsers] = useState<AdminUserRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [savingId, setSavingId] = useState<string | null>(null);
  const [notice, setNotice] = useState('');

  useEffect(() => {
    if (!access.authChecked || !access.canManageUsers) {
      setLoading(false);
      return;
    }
    let active = true;
    const load = async () => {
      try {
        setLoading(true);
        const nextUsers = await listAdminUsers();
        if (!active) return;
        setUsers(nextUsers);
      } catch (error) {
        if (!active) return;
        setNotice(error instanceof Error ? error.message : isAr ? 'تعذر تحميل المستخدمين.' : 'Could not load users.');
      } finally {
        if (active) setLoading(false);
      }
    };

    void load();
    return () => {
      active = false;
    };
  }, [isAr, access.authChecked, access.canManageUsers]);

  const handleFieldChange = async (user: AdminUserRow, field: keyof AdminUserRow, value: string | boolean) => {
    if (!access.canManageUsers || savingId) return;
    try {
      setSavingId(user.id);
      const updated = await updateAdminUser(user.id, {[field]: value});
      setUsers((current) => current.map((item) => (item.id === updated.id ? updated : item)));
      setNotice(isAr ? 'تم تحديث الصلاحيات.' : 'Permissions updated.');
    } catch (error) {
      setNotice(error instanceof Error ? error.message : isAr ? 'تعذر تحديث الصلاحيات.' : 'Could not update permissions.');
    } finally {
      setSavingId(null);
    }
  };

  return (
    <>
      <Seo
        title={isAr ? 'الأدوار والمستخدمون' : 'Users and roles'}
        description={isAr ? 'إدارة أدوار CMS وصلاحيات التشغيل.' : 'Manage CMS roles and operations permissions.'}
        canonicalPath="/admin/users"
        noIndex
      />
      <AdminAccessBoundary
        access={access}
        lang={uiLang}
        title={isAr ? 'الأدوار والمستخدمون' : 'Users and roles'}
        canonicalPath="/admin/users"
        requiredPermission="users"
      >
        <AdminShell
          title={isAr ? 'إدارة الأدوار والصلاحيات' : 'Manage roles and permissions'}
          description={
            isAr
              ? 'حدّد دور كل مستخدم وصلاحياته في إدارة المحتوى.'
              : 'Choose content roles and permissions for each user.'
          }
          currentTab="users"
          user={access.user}
          adminRole={access.adminRole}
          canManageInjuries={access.canManageInjuries}
          canManageArticles={access.canManageArticles}
          canManageSeo={access.canManageSeo}
          canManageHomepage={access.canManageHomepage}
          canManageExercises={access.canManageExercises}
          canManageUsers={access.canManageUsers}
        >
          <div className="rounded-3xl border border-slate-200 bg-white p-6">
            {loading ? (
              <p className="text-sm text-slate-500">{isAr ? 'جار التحميل...' : 'Loading...'}</p>
            ) : (
              <div className="space-y-4">
                {users.length === 0 ? <p>{isAr ? 'لا يوجد مستخدمون لعرضهم.' : 'No users to display.'}</p> : null}
                {users.map((user) => (
                  <div key={user.id} className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                    <div className="grid gap-4 lg:grid-cols-[minmax(0,1.4fr),repeat(4,minmax(0,1fr))]">
                      <div>
                        <div className="font-bold text-slate-900">{user.full_name || user.email}</div>
                        <div className="text-sm text-slate-500">{user.email}</div>
                      </div>
                      <label className="space-y-2 text-sm">
                        <span className="font-bold text-slate-700">{isAr ? 'الدور' : 'Role'}</span>
                        <select
                          value={user.role || 'editor'}
                          onChange={(event) => void handleFieldChange(user, 'role', event.target.value)}
                          disabled={savingId !== null}
                          className="w-full rounded-2xl border border-slate-200 px-3 py-2"
                        >
                          <option value="admin">{isAr ? 'مدير النظام' : 'Admin'}</option>
                          <option value="editor">{isAr ? 'محرر' : 'Editor'}</option>
                          <option value="writer">{isAr ? 'كاتب' : 'Writer'}</option>
                        </select>
                      </label>
                      {[
                        ['can_edit_injuries', isAr ? 'إصابات' : 'Injuries'],
                        ['can_edit_phases', isAr ? 'مراحل' : 'Phases'],
                        ['can_edit_supplements', isAr ? 'مكملات' : 'Supplements'],
                        ['can_delete', isAr ? 'حذف' : 'Delete'],
                      ].map(([field, label]) => (
                        <label key={field} className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-3 py-3 text-sm">
                          <input
                            type="checkbox"
                            checked={Boolean(user[field as keyof AdminUserRow])}
                            onChange={(event) => void handleFieldChange(user, field as keyof AdminUserRow, event.target.checked)}
                            disabled={savingId !== null}
                          />
                          <span className="font-bold text-slate-700">{label}</span>
                        </label>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            )}

            {notice ? <p role="status" aria-live="polite" className="mt-4 text-sm text-slate-600">{notice}</p> : null}
          </div>
        </AdminShell>
      </AdminAccessBoundary>
    </>
  );
}
