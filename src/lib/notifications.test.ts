// @vitest-environment jsdom
import {afterEach,expect,it,vi} from 'vitest';import {autoRequestBrowserNotifications} from './notifications';
afterEach(()=>{vi.restoreAllMocks();vi.unstubAllGlobals()});
it('does not reject when storage is blocked',async()=>{vi.stubGlobal('Notification',{permission:'default'});vi.spyOn(Storage.prototype,'getItem').mockImplementation(()=>{throw new Error('blocked')});await expect(autoRequestBrowserNotifications('en')).resolves.toBe('default')});
