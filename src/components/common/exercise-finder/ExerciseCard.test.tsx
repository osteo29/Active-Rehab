// @vitest-environment jsdom
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {afterEach,describe,it,expect} from 'vitest';
import {ExerciseCard} from './ExerciseCard';
import type {Exercise} from './types';
const exercise:Exercise={name:'Test',nameAr:'اختبار',mainMuscle:'chest',muscles:['chest'],level:'beginner',equipment:'bodyweight',exerciseType:'strength',description:'English description',descriptionAr:'وصف عربي',tips:'English cue',tipsAr:'تعليمات عربية',rehabTip:'English rehab',rehabTipAr:'ملاحظة عربية'};
afterEach(cleanup);
describe('exercise card language',()=>{
 it('uses existing Arabic descriptions, cues and notes when available',()=>{render(<ExerciseCard exercise={exercise} isAr/>);expect(screen.getByText('وصف عربي')).not.toBeNull();fireEvent.click(screen.getByRole('button',{name:'عرض التفاصيل'}));expect(screen.getByText('تعليمات عربية')).not.toBeNull();expect(screen.getByText('ملاحظة عربية')).not.toBeNull();expect(screen.queryByText('English cue')).toBeNull()});
 it('retains English in English mode and falls back rather than inventing missing translations',()=>{render(<ExerciseCard exercise={exercise} isAr={false}/>);expect(screen.getByText('English description')).not.toBeNull()});
});
