// @vitest-environment jsdom
import {afterEach,beforeEach,describe,expect,it,vi} from 'vitest';
const mocks=vi.hoisted(()=>({upload:vi.fn(),remove:vi.fn(),insert:vi.fn()}));
vi.mock('../lib/supabase',()=>({getCurrentUser:async()=>null,supabase:{storage:{from:()=>({upload:mocks.upload,remove:mocks.remove,getPublicUrl:(path:string)=>({data:{publicUrl:path}})})},from:()=>({insert:()=>({select:()=>({single:mocks.insert})})})}}));
import {uploadMediaAsset} from './mediaAdmin';
describe('incomplete media cleanup',()=>{
 beforeEach(()=>{
  mocks.upload.mockReset();mocks.remove.mockReset();mocks.insert.mockReset();mocks.remove.mockResolvedValue({error:null});
  vi.stubGlobal('Image',class {naturalWidth=100;naturalHeight=100;onload:()=>void=()=>{};set src(_:string){queueMicrotask(()=>this.onload())}});
  vi.spyOn(URL,'createObjectURL').mockReturnValue('blob:fixture');vi.spyOn(URL,'revokeObjectURL').mockImplementation(()=>{});
  vi.spyOn(HTMLCanvasElement.prototype,'getContext').mockReturnValue({drawImage:()=>{}} as any);
  vi.spyOn(HTMLCanvasElement.prototype,'toDataURL').mockReturnValue('data:image/webp;base64,fixture');
  vi.spyOn(HTMLCanvasElement.prototype,'toBlob').mockImplementation(cb=>cb(new Blob(['image'])));
 });
 afterEach(()=>{vi.restoreAllMocks();vi.unstubAllGlobals()});
 const file=()=>new File(['image'],'fixture.png',{type:'image/png'});
 it('removes new objects if thumbnail upload fails',async()=>{mocks.upload.mockResolvedValueOnce({error:null}).mockResolvedValueOnce({error:new Error('thumbnail failed')});await expect(uploadMediaAsset(file(),{folder:'fixture',altText:''})).rejects.toThrow('thumbnail failed');expect(mocks.remove).toHaveBeenCalledWith([expect.stringMatching(/\.webp$/),expect.stringMatching(/-thumb\.webp$/)]);expect(mocks.insert).not.toHaveBeenCalled()});
 it('cleans objects after metadata insert failure',async()=>{mocks.upload.mockResolvedValue({error:null});mocks.insert.mockResolvedValue({error:new Error('insert failed')});await expect(uploadMediaAsset(file(),{folder:'fixture',altText:''})).rejects.toThrow('insert failed');expect(mocks.remove).toHaveBeenCalledOnce()});
 it('does not remove files after a successful upload',async()=>{mocks.upload.mockResolvedValue({error:null});mocks.insert.mockResolvedValue({error:null,data:{id:'fixture'}});await expect(uploadMediaAsset(file(),{folder:'fixture',altText:''})).resolves.toEqual({id:'fixture'});expect(mocks.remove).not.toHaveBeenCalled()});
});
