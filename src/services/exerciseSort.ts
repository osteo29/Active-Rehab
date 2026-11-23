import type {Exercise} from '../components/common/exercise-finder/types';
export type ExerciseSort='catalog'|'name'|'level';
export function sortExercises<T extends Exercise>(exercises:T[],sort:ExerciseSort,lang:'en'|'ar'):T[]{
 if(sort==='catalog')return exercises;
 const rank={beginner:0,intermediate:1,advanced:2};
 return [...exercises].sort((a,b)=>{
  if(sort==='level'&&rank[a.level]!==rank[b.level])return rank[a.level]-rank[b.level];
  const an=lang==='ar'?(a.nameAr||a.name):a.name;const bn=lang==='ar'?(b.nameAr||b.name):b.name;
  return an.localeCompare(bn,lang,{numeric:true,sensitivity:'base'});
 });
}
