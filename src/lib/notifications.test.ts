// @vitest-environment jsdom
import {afterEach,expect,it,vi} from 'vitest';import {autoRequestBrowserNotifications, requestBrowserNotifications} from './notifications';
afterEach(()=>{vi.restoreAllMocks();vi.unstubAllGlobals()});
it('does not reject when storage is blocked',async()=>{vi.stubGlobal('Notification',{permission:'default'});vi.spyOn(Storage.prototype,'getItem').mockImplementation(()=>{throw new Error('blocked')});await expect(autoRequestBrowserNotifications('en')).resolves.toBe('default')});

it('does not wait for a nonexistent active service worker',async()=>{
 vi.stubGlobal('Notification',{permission:'granted'});
 const getRegistration=vi.fn().mockResolvedValue(undefined);
 Object.defineProperty(navigator,'serviceWorker',{configurable:true,value:{getRegistration,ready:new Promise(()=>{})}});
 await expect(requestBrowserNotifications('en')).resolves.toBe('granted');
 expect(getRegistration).toHaveBeenCalled();
});
