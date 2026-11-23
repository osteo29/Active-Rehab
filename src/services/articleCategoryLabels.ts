const labels: Record<string,string> = {
 'Exercise Physiology':'فسيولوجيا التمرين',
 'Sports Nutrition':'التغذية الرياضية',
 'Clinical Tracking':'متابعة التعافي',
 'Rehab Nutrition':'التغذية أثناء التأهيل',
 'Recovery Supplements':'مكملات التعافي',
 'Movement & Rehab':'الحركة والتأهيل',
 'Fat Loss Basics':'أساسيات خفض الدهون',
 'Back Pain & Movement':'ألم الظهر والحركة',
 'Diet Myths':'مفاهيم شائعة عن التغذية',
 'Calorie Calculation':'حساب السعرات الحرارية',
 'Training Basics':'أساسيات التدريب',
 'Cardio & Performance':'التمارين الهوائية والأداء',
 'Training Fundamentals':'مبادئ التدريب',
};
export function articleCategoryLabel(category:string,lang:'en'|'ar'):string {
 return lang==='ar' ? labels[category] || category : category;
}
