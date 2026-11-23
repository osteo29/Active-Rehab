import {expect,it} from 'vitest';import {validateAiRequest} from './aiRequestValidation';
it('accepts bounded typed requests',()=>{expect(validateAiRequest({user:'Question',hiddenContext:'Context'}).data?.user).toBe('Question')});
it('rejects wrong types and overly long inputs',()=>{for(const body of [null,[],{user:[]},{user:' '},{user:'Test',system:{}},{user:'Test',hiddenContext:1},{user:'x'.repeat(12001)}])expect(validateAiRequest(body).error).toBeTruthy()});
