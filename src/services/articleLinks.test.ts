import {expect,it} from 'vitest';import {resolveArticleLink} from './articleLinks';
it('preserves exactly one fragment on localized links',()=>{
 expect(resolveArticleLink('/injuries#knee','ar')).toEqual({href:'/ar/injuries#knee',internal:true});
 expect(resolveArticleLink('/calculators','en')?.href).toBe('/en/#calculators');
 expect(resolveArticleLink('/calculators#bmi','en')?.href).toBe('/en/#bmi');
 expect(resolveArticleLink('/unknown#heading','ar')?.href).toBe('/ar/unknown#heading');
 expect(resolveArticleLink('/en/injuries#knee','ar')?.href).toBe('/en/injuries#knee');
});
it('rejects active URLs, obfuscated schemes and protocol-relative links',()=>{
 for(const link of ['javascript:alert(1)','data:text/html,x','//untrusted.example/path','/\\untrusted.example','java\nscript:alert(1)'])expect(resolveArticleLink(link,'en')).toBeNull();
 expect(resolveArticleLink('https://example.com/a','en')).toEqual({href:'https://example.com/a',internal:false});
 expect(resolveArticleLink('#local','en')).toEqual({href:'#local',internal:true});
});
