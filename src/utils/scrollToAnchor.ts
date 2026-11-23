export function scrollToAnchorWhenReady(id:string,timeoutMs=6000):()=>void {
 let timer:number|undefined;
 let observer:MutationObserver|undefined;
 let cancelled=false;
 const cleanup=()=>{cancelled=true;if(timer!==undefined)window.clearTimeout(timer);observer?.disconnect()};
 const check=()=>{
  if(cancelled)return;
  const target=document.getElementById(id);
  if(!target)return;
  const reducedMotion=window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
  target.scrollIntoView({behavior:reducedMotion?'auto':'smooth',block:'start'});
  cleanup();
 };
 check();
 if(!cancelled){observer=new MutationObserver(check);observer.observe(document.body,{childList:true,subtree:true});timer=window.setTimeout(cleanup,timeoutMs);window.dispatchEvent(new Event('activerehab:load-anchor-sections'));}
 return cleanup;
}
