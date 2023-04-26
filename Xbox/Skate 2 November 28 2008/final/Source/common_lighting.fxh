
half phong_specular ( half3 normal , half3 viewdir , half3 lightdir , half power ) 
{
half3 reflectdir = -reflect ( lightdir , normal );
return pow ( saturate ( dot ( reflectdir , viewdir ) ) , power );
return pow ( saturate ( dot ( reflectdir , viewdir ) ) , power );
}
half blinn_specular ( half3 normal , half3 viewdir , half3 lightdir , half power ) 
half blinn_specular ( half3 normal , half3 viewdir , half3 lightdir , half power ) 
{
half3 H = normalize ( lightdir+viewdir );
return pow ( saturate ( dot ( normal , H ) ) , power );
}
half fresnelCalc ( half3 normal , half3 eyeVec , half fresExp ) 
half fresnelCalc ( half3 normal , half3 eyeVec , half fresExp ) 
{
return pow ( 1-saturate ( dot ( normal , eyeVec ) ) , fresExp );
}
