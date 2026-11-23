// @vitest-environment jsdom
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {afterEach,beforeEach,describe,it,expect,vi} from 'vitest';
import ErrorBoundary from './ErrorBoundary';
let fail=true;
function Child(){if(fail)throw new Error('Temporary failure');return <p>Recovered content</p>}
beforeEach(()=>{fail=true;vi.spyOn(console,'error').mockImplementation(()=>{})});afterEach(()=>{cleanup();vi.restoreAllMocks()});
describe('error boundary recovery',()=>{
 it('retries content without reloading the entire app',()=>{render(<ErrorBoundary><Child/></ErrorBoundary>);expect(screen.getByText('Something went wrong')).not.toBeNull();fail=false;fireEvent.click(screen.getByRole('button',{name:'Try again'}));expect(screen.getByText('Recovered content')).not.toBeNull()});
 it('resets an old page error when the route key changes',()=>{const view=render(<ErrorBoundary resetKey="/a"><Child/></ErrorBoundary>);fail=false;view.rerender(<ErrorBoundary resetKey="/b"><Child/></ErrorBoundary>);expect(screen.getByText('Recovered content')).not.toBeNull()});
});
