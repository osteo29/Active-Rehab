import {afterEach,beforeEach,expect,it,vi} from 'vitest';
const mocks=vi.hoisted(()=>({generate:vi.fn()}));
vi.mock('@google/genai',()=>({GoogleGenAI:class {models={generateContent:mocks.generate}}}));
import handler from '../../api/gemini';
beforeEach(()=>vi.stubEnv('GEMINI_API_KEY','synthetic-test-key-not-a-credential'));
afterEach(()=>{vi.unstubAllEnvs();vi.resetAllMocks()});
function response(){const json=vi.fn();const status=vi.fn(()=>({json}));return {json,status,setHeader:vi.fn()}}
it('rejects wrong methods and malformed request bodies before model calls',async()=>{
 for(const req of [{method:'GET'},{method:'POST',body:'{'},{method:'POST',body:{user:44}},{method:'POST',body:{user:'valid',hiddenContext:[]}}]){
 const res=response();await handler(req,res);expect(res.status).toHaveBeenCalledWith(req.method==='GET'?405:400)
 }expect(mocks.generate).not.toHaveBeenCalled();
});
it('does not expose provider exceptions to API clients',async()=>{mocks.generate.mockRejectedValue(new Error('synthetic private provider diagnostic'));const res=response();await handler({method:'POST',body:{user:'Synthetic test question'}},res);expect(res.status).toHaveBeenCalledWith(500);expect(JSON.stringify(res.json.mock.calls)).not.toContain('private provider diagnostic')});
it('passes a valid request through the mocked model',async()=>{mocks.generate.mockResolvedValue({text:'Synthetic model reply'});const res=response();await handler({method:'POST',body:{user:'Synthetic test question'}},res);expect(res.status).toHaveBeenCalledWith(200);expect(res.json).toHaveBeenCalledWith({text:'Synthetic model reply'})});
