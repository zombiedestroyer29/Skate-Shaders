
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 row0 , row1 , row2;
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

float4 P;
float4 INP1 = float4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 );
P.x = dot ( INP1 , row0 );
P.y = dot ( INP1 , row1 );
P.z = dot ( INP1 , row2 );
P.w = 1.0f;

Out.vBinormal.x = dot ( In.vBinormal.xyz , row0.xyz );
Out.vBinormal.y = dot ( In.vBinormal.xyz , row1.xyz );
Out.vBinormal.z = dot ( In.vBinormal.xyz , row2.xyz );

Out.vTangent.x = dot ( In.vTangent.xyz , row0.xyz );
Out.vTangent.y = dot ( In.vTangent.xyz , row1.xyz );
Out.vTangent.z = dot ( In.vTangent.xyz , row2.xyz );

Out.vNormal = GetNormal ( Out.vTangent , Out.vBinormal );


Out.vPos = P;
Out.Pos = mul ( P , g_matVP );
Out.Pos.z += GetZBias ( Out.Pos.z , g_charattributes[2].w );


Out.UV = half4 ( In.UV0.xy, In.UV1.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV.xy );
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cDiffuse.a;
cDiffuse.a = 1.0;


cDiffuse *= i_modulateColor1;

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , g_charattributes[0].xyz );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

half4 clrDecal1Stamp = half4 ( 0.0, 0.0, 0.0, 0.0 );
half4 clrDecal2Stamp = half4 ( 0.0, 0.0, 0.0, 0.0 );
float4 bruiseEnabled = half4 ( 0.0, 0.0, 0.0, 0.0 );
half4 tattooPart = half4 ( 0.0, 0.0, 0.0, 0.0 );
half4 bruisePart = half4 ( 0.0, 0.0, 0.0, 0.0 );
half alphaValue = 0.0;
half bruiseOpacity = 0.0f;

half4 finalBruiseCoords = half4 ( 0.25, 0.75, 0.25, 0.25 );
half4 finalTattooCoords = half4 ( 0.25, 0.50, 0.25, 0.5 );
half pixelTattooCoords = 0.0f;

 if ( In.UV.z > 0.0 &amp;&amp; In.UV.w > 0.0 ) {

half4 clrAlpha = tex2D ( i_alpha , In.UV.xy ).rgba;


if ( clrAlpha.r != 0.0 ) {


tattooPart = i_decal1UV[0];
bruisePart = i_decal2UV[0];
bruiseEnabled = i_enableDecal2[0];

alphaValue = clrAlpha.r;
} else {


tattooPart = i_decal1UV[1];
bruisePart = i_decal2UV[1];
bruiseEnabled = i_enableDecal2[1];

alphaValue = clrAlpha.g;
}

if ( alphaValue > 0.8 ) {

finalBruiseCoords.z *= bruisePart.w;
bruiseOpacity = bruiseEnabled.w;

pixelTattooCoords = tattooPart.w;
} else 
if ( alphaValue > 0.6 ) {

finalBruiseCoords.z *= bruisePart.z;
bruiseOpacity = bruiseEnabled.z;

pixelTattooCoords = tattooPart.z;
} else 
if ( alphaValue > 0.4 ) {

finalBruiseCoords.z *= bruisePart.y;
bruiseOpacity = bruiseEnabled.y;

pixelTattooCoords = tattooPart.y;
} else 
 if ( alphaValue > 0.2 ) {

finalBruiseCoords.z *= bruisePart.x;
bruiseOpacity = bruiseEnabled.x;

pixelTattooCoords = tattooPart.x;
}

finalTattooCoords.z = 0.25*( int ( floor ( pixelTattooCoords ) )%4 );
finalTattooCoords.w = pixelTattooCoords > 3 ? 0.5 : 0.0;
finalTattooCoords.xy *= pixelTattooCoords > 7 ? 0.0 : 1.0;

clrDecal1Stamp = tex2D ( i_decal , In.UV.zw*finalTattooCoords.xy+finalTattooCoords.zw );
clrDecal2Stamp = tex2D ( i_decal2 , In.UV.zw*finalBruiseCoords.xy+finalBruiseCoords.zw );

clrDecal2Stamp.a *= bruiseOpacity;


cDiffuse *= clrDecal1Stamp;


cDiffuse = cDiffuse*( 1.0-clrDecal2Stamp.a )+clrDecal2Stamp*clrDecal2Stamp.a;
}

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

half4 vDiffuse = CalculateCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal*fWorldShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , irradVal );


half4 outcolor = half4 ( 0, 0, 0, 0 );

outcolor = PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );

outcolor.a = i_params[0].x;

return outcolor;
}

void simpleVS ( VS_IN In , out PS_IN_SIMPLE Out ) 
{
float4 row0 , row1 , row2;
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

float4 P;
float4 INP1 = float4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 );
P.x = dot ( INP1 , row0 );
P.y = dot ( INP1 , row1 );
P.z = dot ( INP1 , row2 );
P.w = 1.0f;
Out.Pos = mul ( P , g_matVP );
}

half4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}

float4 debugPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV.xy );
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cDiffuse.a;
half fSpecValueOriginal = cDiffuse.a;
cDiffuse.a = 1.0;
half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , g_charattributes[0].xyz );

half4 vDiffuse = half4 ( 0, 0, 0, 0 );

if ( i_debugparams[2].x < 0.5 ) {

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

cDiffuse = half4 ( i_debugparams[2].y, i_debugparams[2].y, i_debugparams[2].y, 1.f );
vDiffuse = CalculateDebugCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , i_debugparams[0].x , i_debugparams[0].y , i_debugparams[0].z , i_debugparams[0].w , i_debugparams[1].x , irradVal );


} else {


vDiffuse = DebugCharacterTexture ( cDiffuse.rgb*i_debugparams[2].y , vNormal*i_debugparams[2].z , fSpecValueOriginal*i_debugparams[2].w );
}

return PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );
}
