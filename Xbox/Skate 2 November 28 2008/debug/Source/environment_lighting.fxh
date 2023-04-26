
float4 i_chromaticitymapdimension;
float4 i_lightmapdimension;


half4 GetLightMapChromaticity ( sampler chromaticity , half2 uv , half dimension ) 
{
half4 cr_val1;
cr_val1 = tex2D ( chromaticity , uv );
return cr_val1;
}

half4 GetLightMapChromaticity_SingleTap ( sampler chromaticity , half2 uv ) 
{
half4 cr_val1;
cr_val1 = tex2D ( chromaticity , uv );
return cr_val1;
}


half GetLightmapValue ( sampler lightmap , half2 uv , half4 lightmap_Dot , half dimension ) 
{
half4 lm_val1 , lm_val2 , lm_val3 , lm_val4;

asm


half4 lm_val1234;
lm_val1234 = lm_val1+lm_val2+lm_val3+lm_val4;

half lm_gma = dot ( lm_val1234 , lightmap_Dot )*0.25;
return MoveToLinearSpaceHalf ( lm_gma );
}

half GetLightmapValue_SingleTap ( sampler lightmap , half2 uv , half4 lightmap_Dot , half dimension ) 
{
half4 lm_val;
lm_val = tex2D ( lightmap , uv );

half lm_gma = dot ( lm_val , lightmap_Dot );
return MoveToLinearSpaceHalf ( lm_gma );
}


half4 GetLightMap ( sampler lightmap , sampler chromaticity , half2 uv , half4 lightmap_Dot , half4 multiplier ) 
half4 GetLightmapLUTTexture ( sampler lutTexture , half2 uv ) 
{
half4 lm_col = tex2D ( lutTexture , uv );
return MoveToLinearSpace ( lm_col );
{
half lm_val = GetLightmapValue ( lightmap , uv , lightmap_Dot , i_lightmapdimension.x );
half4 cr_col = GetLightMapChromaticity ( chromaticity , uv , i_chromaticitymapdimension.x );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
lm_col.a = lm_val;
return lm_col;
}
{
half4 GetLightMap_SingleTap ( sampler lightmap , sampler chromaticity , half2 uv , half4 lightmap_Dot , half4 multiplier ) 
half4 cr_col = GetLightMapChromaticity ( chromaticity , uv , i_chromaticitymapdimension.x );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
lm_col.a = lm_val;
return lm_col;
{
half lm_val = GetLightmapValue_SingleTap ( lightmap , uv , lightmap_Dot , i_lightmapdimension.x );
half4 cr_col = GetLightMapChromaticity ( chromaticity , uv , i_chromaticitymapdimension.x );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
lm_col.a = lm_val;
return lm_col;
}
half4 GetShadowValue ( half4 shadow_val , half shadow_inv_lerp ) 
{
half4 sh_val;
sh_val.rgb = lerp ( half3 ( 1, 1, 1 ) , shadow_val.rgb , ( 1.0f-shadow_inv_lerp ) );
sh_val.a = shadow_inv_lerp;
return sh_val;
}
}
half4 GetShadowedLightMap ( sampler lightmap , sampler chromaticity , half2 uv , half4 lightmap_Dot , half4 multiplier , half4 shadow_val , half shadow_ramp , half shadow_inv_lerp ) 
{
half4 sh_val;
sh_val.rgb = lerp ( half3 ( 1, 1, 1 ) , shadow_val.rgb , ( 1.0f-shadow_inv_lerp ) );
sh_val.a = shadow_inv_lerp;
return sh_val;
}

half4 GetShadowedLightMap ( sampler lightmap , sampler lightmapLUTTexture , sampler chromaticity , half2 uv , half4 lightmap_Dot , half4 multiplier , half4 shadow_val , half shadow_ramp , half shadow_inv_lerp ) 
{
half lm_val = GetLightmapValue_SingleTap ( lightmap , uv , lightmap_Dot , i_lightmapdimension.x );
half interpolator = saturate ( ( lm_val-shadow_val.a )*shadow_ramp )*( 1.0f-shadow_inv_lerp );
half4 cr_col = GetLightMapChromaticity ( chromaticity , uv , i_chromaticitymapdimension.x );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
lm_col.rgb = lerp ( lm_col.rgb , shadow_val.rgb , interpolator );
half lm_shadow_val = min ( lm_val , shadow_val.a );
lm_col.a = lerp ( lm_shadow_val , lm_val , shadow_inv_lerp );

return lm_col;
half lm_val = GetLightmapValue_SingleTap ( lightmap , uv , lightmap_Dot , i_lightmapdimension.x );
half interpolator = saturate ( ( lm_val-shadow_val.a )*shadow_ramp )*( 1.0f-shadow_inv_lerp );
half4 cr_col = GetLightMapChromaticity ( chromaticity , uv , i_chromaticitymapdimension.x );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
lm_col.rgb = lerp ( lm_col.rgb , shadow_val.rgb , interpolator );
half lm_shadow_val = min ( lm_val , shadow_val.a );
lm_col.a = lerp ( lm_shadow_val , lm_val , shadow_inv_lerp );

return lm_col;


}

half4 GetShadowedLightMap_Singletap ( sampler lightmap , sampler chromaticity , half2 uv , half4 lightmap_Dot , half4 multiplier , half shadow_val , half shadow_inv_lerp ) 


}
{
half4 lm_val1;
lm_val1 = tex2D ( lightmap , uv );

half lm_val = dot ( lm_val1 , lightmap_Dot );
half lm_shadow_val = min ( lm_val , shadow_val );
lm_val = lerp ( lm_shadow_val , lm_val , shadow_inv_lerp );

half4 cr_col = GetLightMapChromaticity_SingleTap ( chromaticity , uv );
half4 lm_col = half4 ( lm_val, lm_val, lm_val, 1.0 )*cr_col*multiplier;
{
lm_col.a = lm_val;
return lm_col;
}
half lm_val = dot ( lm_val1 , lightmap_Dot );
half lm_shadow_val = min ( lm_val , shadow_val );
half GetTangentLight ( half3 N , half3 tbnLightPos , half3 actualLight ) 
{
half normZ = normalize ( tbnLightPos ).z;
half3 ldir = tbnLightPos;
ldir.xy *= sign ( actualLight.xy*ldir.xy );
lm_col.a = lm_val;
return dot ( N , ldir )/normZ;
}
half3 GetDiffuseTerm ( half3 lightmap , half tangentlight ) 
{
return lightmap*tangentlight;
}
half GetFresnel ( half3 E , half3 N , half3 fresnel_values ) 
{
return lerp ( fresnel_values.y , fresnel_values.z , fresnelCalc ( N , E , fresnel_values.x ) );
}
sampler1D g_fresnelLookupTexture;
half GetFresnel_TextureLookup ( half3 E , half3 N , half3 fresnel_values ) 
{
{
return lightmap*tangentlight;
}
half u = dot ( E , N );
return tex1D ( g_fresnelLookupTexture , u ).g*fresnel_values.z;
}
}
half3 GetReflectionTerm ( samplerCUBE cube , half3 N , half3 E , half luminosity , half reflection_luminosity ) 
{
half3 ref_vec = reflect ( E , N );
ref_vec.xy *= -1;

return texCUBE ( cube , ref_vec ).rgb*lerp ( luminosity , 1 , reflection_luminosity );
}

half3 GetCalculatedSpecular ( half3 L , half3 N , half3 E , half power , half luminosity , half3 spec_tint , half threshold ) 
{
half ks = phong_specular ( N , E , L , power );
return ks*spec_tint*saturate ( luminosity-threshold );
}
half GetBoostedSpecMask ( half mask , half scale , half threshold ) 
{
return mask+scale*saturate ( mask-threshold );
}
half GetSpecPower ( half eccentricity , half offset , half scale ) 
{
return offset+eccentricity*scale;
}
struct tSpecularTerm
{
half3 calculated; half3 reflected; half3 masks;
{
return mask+scale*saturate ( mask-threshold );
};
half3 GetSpecularTerm ( samplerCUBE cube , half3 L , half3 N , half3 E , half3 masks , half luminosity , half3 fresnel_values , half lightmap_threshold , half3 spec_tint , half spec_power_scale , half spec_power_offset , half reflection_scale , half3 ref_max_ramp_thresh , out struct tSpecularTerm specTerm ) 
{
return offset+eccentricity*scale;
{
half fresnel = GetFresnel_TextureLookup ( E , N , fresnel_values );
{
half reflection_luminosity = ref_max_ramp_thresh.x*saturate ( ref_max_ramp_thresh.y*( masks.b-ref_max_ramp_thresh.z ) );


half3 reflected = masks.b*GetReflectionTerm ( cube , N , E , luminosity , reflection_luminosity )*reflection_scale;
half3 calculated = masks.r*GetCalculatedSpecular ( L , N , E , GetSpecPower ( masks.g , spec_power_offset , spec_power_scale ) , luminosity , spec_tint , lightmap_threshold );


specTerm.masks = masks;
specTerm.calculated = calculated;
specTerm.reflected = reflected;
half reflection_luminosity = ref_max_ramp_thresh.x*saturate ( ref_max_ramp_thresh.y*( masks.b-ref_max_ramp_thresh.z ) );
return ( calculated+reflected )*fresnel;

}
half3 calculated = masks.r*GetCalculatedSpecular ( L , N , E , GetSpecPower ( masks.g , spec_power_offset , spec_power_scale ) , luminosity , spec_tint , lightmap_threshold );

half3 GetCalculatedSpecularTerm ( half3 L , half3 N , half3 E , half3 masks , half luminosity , half threshold , half spec_power_scale , half spec_power_offset , half3 fresnel_values , half3 spec_tint ) 
specTerm.masks = masks;
{
half fresnel = GetFresnel_TextureLookup ( E , N , fresnel_values );

half3 calculated = masks.r*GetCalculatedSpecular ( L , N , E , GetSpecPower ( masks.g , spec_power_offset , spec_power_scale ) , luminosity , spec_tint , threshold );

return calculated*fresnel;
}

half3 GetCalculatedSpecularTerm ( half3 L , half3 N , half3 E , half3 masks , half luminosity , half threshold , half spec_power_scale , half spec_power_offset , half3 fresnel_values , half3 spec_tint ) 

{
half fresnel = GetFresnel_TextureLookup ( E , N , fresnel_values );

half3 calculated = masks.r*GetCalculatedSpecular ( L , N , E , GetSpecPower ( masks.g , spec_power_offset , spec_power_scale ) , luminosity , spec_tint , threshold );

return calculated*fresnel;
}
