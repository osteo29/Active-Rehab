import {describe,expect,it} from 'vitest';
import {validateMediaFile,validateMediaDimensions,MAX_MEDIA_BYTES} from './mediaValidation';
describe('media upload limits',()=>{
 it('accepts supported nonempty images up to the byte cap',()=>{expect(validateMediaFile({type:'image/png',size:MAX_MEDIA_BYTES})).toBeNull()});
 it('rejects empty, oversized and unsupported files',()=>{for(const f of [{type:'image/png',size:0},{type:'image/jpeg',size:MAX_MEDIA_BYTES+1},{type:'image/svg+xml',size:100},{type:'text/html',size:100}])expect(validateMediaFile(f)).not.toBeNull()});
 it('rejects invalid or memory-heavy decoded dimensions',()=>{for(const [w,h] of [[0,20],[NaN,20],[10000,10000],[-1,40]])expect(validateMediaDimensions(w,h)).not.toBeNull();expect(validateMediaDimensions(6000,4000)).toBeNull()});
});
