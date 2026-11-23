import {useCallback,useEffect,useState} from 'react';
const KEY='activerehab_saved_exercises_v1';
const EVENT='activerehab-saved-exercises-change';
export function exerciseBookmarkKey(exercise:{name:string;mainMuscle:string}) {return `${exercise.mainMuscle}::${exercise.name}`;}
function readSaved():string[]{try{const value=JSON.parse(localStorage.getItem(KEY)||'[]');return Array.isArray(value)?[...new Set(value.filter((item):item is string=>typeof item==='string'&&item.length>0))].slice(0,2000):[]}catch{return []}}
export function useSavedExercises(){
 const [saved,setSaved]=useState<string[]>(readSaved);
 const [storageUnavailable,setStorageUnavailable]=useState(false);
 useEffect(()=>{const sync=()=>setSaved(readSaved());const onStorage=(e:StorageEvent)=>{if(e.key===KEY||e.key===null)sync()};window.addEventListener('storage',onStorage);window.addEventListener(EVENT,sync);return()=>{window.removeEventListener('storage',onStorage);window.removeEventListener(EVENT,sync)}},[]);
 const toggle=useCallback((key:string)=>{
  const next=saved.includes(key)?saved.filter(item=>item!==key):[...saved,key];
  setSaved(next);
  try{localStorage.setItem(KEY,JSON.stringify(next));setStorageUnavailable(false);window.dispatchEvent(new Event(EVENT))}catch{setStorageUnavailable(true)}
 },[saved]);
 return {saved,toggle,storageUnavailable};
}
