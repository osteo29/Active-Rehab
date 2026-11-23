import {expect,it} from 'vitest';import {validateAiRequest} from './aiRequestValidation';
it('accepts bounded typed requests',()=>{expect(validateAiRequest({user:'Question',hiddenContext:'Context'}).data?.user).toBe('Question')});
it('rejects wrong types and overly long inputs',()=>{for(const body of [null,[],{user:[]},{user:' '},{user:'Test',system:{}},{user:'Test',hiddenContext:1},{user:'x'.repeat(12001)}])expect(validateAiRequest(body).error).toBeTruthy()});
import {readAiJsonBody} from './aiRequestValidation';
import {EventEmitter} from 'node:events';
it('rejects malformed, absent, and oversized bodies without hanging',async()=>{
 for (const req of [{body:'{'},{},{body:'x'.repeat(65537)}]) await expect(readAiJsonBody(req)).rejects.toBeInstanceOf(Error);
});
it('reads split UTF-8 stream chunks correctly',async()=>{
 const emitter=new EventEmitter();const result=readAiJsonBody(emitter);const bytes=Buffer.from('{"user":"مرحبا"}');
 emitter.emit('data',bytes.subarray(0,11));emitter.emit('data',bytes.subarray(11));emitter.emit('end');
 await expect(result).resolves.toEqual({user:'مرحبا'});
});
it('rejects large or aborted streams',async()=>{
 for(const type of ['large','aborted']){const emitter=new EventEmitter();const result=readAiJsonBody(emitter);if(type==='large')emitter.emit('data',Buffer.alloc(65537));else emitter.emit('aborted');await expect(result).rejects.toBeInstanceOf(Error)}
});
