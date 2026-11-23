import {describe, expect, it} from 'vitest';
import {isSafeContentLink,isValidContentSlug} from './adminValidation';
describe('admin content validation',()=>{
 it('allows local paths and HTTP(S) only',()=>{
  for(const url of ['', '/en/injuries', 'https://example.com/watch?v=1', 'http://example.com']) expect(isSafeContentLink(url)).toBe(true);
 });
 it('rejects executable schemes, protocol-relative links and disguised hosts',()=>{
  for(const url of ['javascript:alert(1)','data:text/html,x','//example.com','/\\example.com','https://user:pass@example.com','java\nscript:alert(1)']) expect(isSafeContentLink(url)).toBe(false);
 });
 it('accepts stable URL slugs, not paths or blanks',()=>{
  for(const slug of ['shoulder-raise','lower_back','ex123']) expect(isValidContentSlug(slug)).toBe(true);
  for(const slug of ['','two words','../x','/exercise','trailing-']) expect(isValidContentSlug(slug)).toBe(false);
 });
});
