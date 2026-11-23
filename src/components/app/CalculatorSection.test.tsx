// @vitest-environment jsdom
import {MemoryRouter} from 'react-router-dom';
import {render,screen,cleanup} from '@testing-library/react';
import {afterEach,describe,it,expect,vi} from 'vitest';
import CalculatorSection from './CalculatorSection';
import {useCalculatorWorkspace} from '../../hooks/useCalculatorWorkspace';
import {translations} from '../../services/translations';
const profile={age:30,weight:75,height:175,gender:'male' as const,activityLevel:1.4,goal:'recovery' as const,injuryType:'acl_tear',recoveryWeek:3,sleepHours:8,waterIntake:2500,proteinCompliance:0.8};
function Form(){const controller=useCalculatorWorkspace({architectProfile:profile,initialArchitectProfile:profile,lang:'ar',setArchitectProfile:vi.fn(),t:translations.ar});return <CalculatorSection {...({controller,lang:'ar',t:translations.ar,assessmentSnapshot:null,practicalGuide:null} as any)}/>}
afterEach(cleanup);
describe('calculator form labels',()=>{it('associates weight and height labels with their inputs in Arabic',()=>{render(<MemoryRouter><Form/></MemoryRouter>);expect(screen.getByLabelText(translations.ar.forms.weight).tagName).toBe('INPUT');expect(screen.getByLabelText(translations.ar.forms.height).tagName).toBe('INPUT');expect(screen.queryByText('Required')).toBeNull();expect(screen.getByText('مطلوب')).not.toBeNull()})});
