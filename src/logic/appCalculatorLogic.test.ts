import {describe,it,expect} from 'vitest';
import {validateCalculatorInputs,calculateCalculatorResult,type CalculatorFormValues} from './appCalculatorLogic';
import {translations} from '../services/translations';
const values:CalculatorFormValues={activeCalculator:'BMI',weight:'75',height:'175',age:'30',gender:'male',activity:'1.4',waist:'80',neck:'38',hip:'95',goal:'maintain',bodyType:'mesomorph',pace:500,unitSystem:'metric',knowBodyFat:false,bodyFatInput:'',hotClimate:false,pregnancy:false,mealItems:[]};
const validate=(patch:Partial<CalculatorFormValues>)=>validateCalculatorInputs({values:{...values,...patch},lang:'en',t:translations.en});
describe('calculator input validation',()=>{
 it.each(['0','-5','NaN','Infinity','abc'])('rejects invalid weight %s',weight=>expect(validate({weight})).toBe(translations.en.errors.weight));
 it('accepts localized positive numeric inputs',()=>expect(validate({weight:'٧٥',height:'١٧٥'})).toBeNull());
 it('does not require weight or neck for a waist-to-height ratio',()=>{expect(validate({activeCalculator:'WHtR',weight:'',neck:''})).toBeNull();const result=calculateCalculatorResult({values:{...values,activeCalculator:'WHtR',weight:'',neck:''},lang:'en',t:translations.en});expect((result.result as {ratio:number}).ratio).toBe(0.46)});
 it('does require neck for the body-fat calculator',()=>expect(validate({activeCalculator:'BodyFat',weight:'',neck:''})).toBe(translations.en.errors.neck));
 it('does not require weight for ideal weight or dimension-based body fat',()=>{expect(validate({activeCalculator:'IdealWeight',weight:''})).toBeNull();expect(validate({activeCalculator:'BodyFat',weight:''})).toBeNull()});
 it('ignores an inactive hidden body-fat field after switching tools',()=>expect(validate({activeCalculator:'BMI',knowBodyFat:true,bodyFatInput:''})).toBeNull());
});
