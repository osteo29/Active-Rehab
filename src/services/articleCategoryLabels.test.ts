import {expect,it} from 'vitest';
import {articleCategoryLabel} from './articleCategoryLabels';
it('localizes known labels while preserving unknown CMS categories',()=>{expect(articleCategoryLabel('Sports Nutrition','ar')).toBe('التغذية الرياضية');expect(articleCategoryLabel('Sports Nutrition','en')).toBe('Sports Nutrition');expect(articleCategoryLabel('Custom category','ar')).toBe('Custom category')});
