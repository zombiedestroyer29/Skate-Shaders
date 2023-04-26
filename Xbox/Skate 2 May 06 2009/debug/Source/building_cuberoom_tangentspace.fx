
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.pos, 1.0 );

Out.vNormal.xy = In.lm_norm.zw;
half2 signs = saturate ( half2 ( 65535, 65535 )*In.lm_norm.xy );
signs = signs*2-1;
float xy_len = min ( 0.999f , dot ( Out.vNormal.xy , Out.vNormal.xy ) );
Out.vNormal.z = signs.y*sqrt ( 1-xy_len );
Out.vTangent = In.tangent;
Out.vBinormal = signs.x*cross ( Out.vNormal , Out.vTangent );
Out.vPos = In.pos.xyz;
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.uv;
Out.UV.zw = abs ( In.lm_norm.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.dataconstants = float4 ( i_macroOverlayUVScale.x, i_detailNormalUVScale.x, i_macroOverlayOpacity.x, 0.0f );
Out.lightmapchannel = i_monoLightmap_Dot;
}


half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cOverlay = GetOverlayTextureValue ( i_macrooverlay , In.UV.xy*In.dataconstants.x , In.dataconstants.z );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
cSpecEccRefMask = ApplyOverlay ( cOverlay , half4 ( cSpecEccRefMask, 1 ) ).xyz;


float3 vViewDir = ( In.vPos-g_vViewPos );
vViewDir = normalize ( vViewDir );


float3 vViewDirXZ = vViewDir.xyz;
vViewDirXZ.y = 0;
float Ez = length ( vViewDirXZ );
vViewDirXZ = normalize ( vViewDirXZ );


float2 UV_Frac = frac ( In.UV.xy*i_floorCount.x );
float2 strip_UV;

float d = ( ( Ez*UV_Frac.y*8.5*0.5 )/vViewDir.y );
strip_UV.xy = In.vPos.xz+( ( vViewDirXZ.xz*d ) );
float4 strip_tex = GetDiffuseTextureValue ( i_diffuse2 , strip_UV*0.3f );


float windowFog = saturate ( 2.0f/d );
windowFog *= 2;
windowFog *= windowFog;


half3 vDetail = GetDetailNormalMapValue ( i_detail , In.UV.xy*In.dataconstants.y );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );


half3 vND = ApplyDetailNormal ( vNormal , vDetail );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vND , matTBN );


half3 vDir = TransformToTangentFromWorld ( vViewDir , matTBN );
vDir = normalize ( vDir );
vDir.yz *= -1;
half2 vUV = ( UV_Frac*2 )-1;

float2 intersect;
intersect.x = 1-( vUV.x*sign ( vDir.x ) );
intersect.y = 1-( vUV.y*sign ( vDir.y ) );

float3 scale;
scale.x = abs ( intersect.x/vDir.x );
scale.y = abs ( intersect.y/vDir.y );
scale.z = 2/vDir.z;

scale.x = min ( min ( scale.x , scale.y ) , scale.z );


vDir *= scale.x;

vDir += float3 ( vUV.x, vUV.y, -1 );
vDir.y *= -1;
float4 CubeTex = texCUBE ( i_environmentInterior , vDir.xyz );
cDiffuse = lerp ( cDiffuse , CubeTex , 1-cDiffuse.a );


half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );
half kd = GetTangentLight ( vND , g_envattributes[3].xyz , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 cDiffuseColour = ApplyOverlay ( cOverlay , cDiffuse.rgb );
half3 diffTerm = GetDiffuseTerm ( cLightMap , kd );

struct tSpecularTerm specTermParts;
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , g_envattributes[5].xyz , g_envattributes[2].w , ( g_envattributes[4].xyz*3 ) , g_envattributes[3].w , g_envattributes[4].w , g_envattributes[5].w , g_envattributes[6].yzw , specTermParts );


half4 outcolor = half4 ( diffTerm*cDiffuseColour+specTerm, 1 );
outcolor = outcolor*0.01f+cDiffuse;

half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, 1 );


outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTermParts.calculated , black3 , specTermParts.reflected , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , black4 , tex2D ( i_detail , In.UV.xy*In.dataconstants.y ) , cDiffuse , half4 ( cSpecEccRefMask.ggg, 1.0 ) , GetDebugReflectClr ( i_environment , wNormal , vViewDir ) , half4 ( cLightMap.aaa, 1.0 ) , half4 ( cOverlay, 1 ) , tex2D ( i_normal , In.UV.xy ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );


outcolor = ChooseBNT ( outcolor , In.vBinormal , wNormal , In.vTangent );

half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = 0;
return returncolour;


}
