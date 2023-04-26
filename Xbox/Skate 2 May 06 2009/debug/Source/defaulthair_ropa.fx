
void defaultVS ( VS_IN_ROPA In , out PS_IN Out ) 
{
float4 P;

if ( i_vtx_params.x > 0.0 ) {

float4 row0 , row1 , row2;


GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

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

Out.vNormal.x = dot ( In.vNormal.xyz , row0.xyz );
Out.vNormal.y = dot ( In.vNormal.xyz , row1.xyz );
Out.vNormal.z = dot ( In.vNormal.xyz , row2.xyz );
} else {


P = mul ( half4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 ) , i_matWorld );
Out.vBinormal = mul ( In.vBinormal , (half4x3)i_matWorld );
Out.vTangent = mul ( In.vTangent , (half4x3)i_matWorld );
Out.vNormal = mul ( In.vNormal , (half4x3)i_matWorld );
}


Out.vPos = P;
Out.Pos = mul ( P , g_matVP );


Out.UV = half4 ( In.UV0.xy, In.UV1.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half cSpecMaskValue = cDiffuse.a;
cDiffuse.a = 1.0f;
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cSpecMaskValue;


half fShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

half4 vDiffuse = CalculateCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , irradVal );


vDiffuse.a = tex2D ( i_alpha , In.UV.zw );

half4 outcolor = PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );
outcolor.a = vDiffuse.a*i_params[0].x;
return outcolor;
}

void simpleVS ( VS_IN In , out PS_IN_SIMPLE Out ) 
{
float4 P;

if ( i_vtx_params.x > 0.0 ) {

float4 row0 , row1 , row2;


GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

float4 INP1 = float4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 );
P.x = dot ( INP1 , row0 );
P.y = dot ( INP1 , row1 );
P.z = dot ( INP1 , row2 );
P.w = 1.0f;
} else {


P = mul ( half4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 ) , i_matWorld );
}

Out.Pos = mul ( P , g_matVP );
}

half4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}


half4 debugPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cDiffuse.a;
half fSpecValueOriginal = cDiffuse.a;
cDiffuse.a = 1.0;
half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , g_charattributes[0].xyz );

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );
half4 vDiffuse = half4 ( 0, 0, 0, 0 );

if ( i_debugparams[2].x < 0.5 ) {

cDiffuse = half4 ( i_debugparams[2].y, i_debugparams[2].y, i_debugparams[2].y, 1.f );
vDiffuse = CalculateDebugCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , i_debugparams[0].x , i_debugparams[0].y , i_debugparams[0].z , i_debugparams[0].w , i_debugparams[1].x , irradVal );


} else {


vDiffuse = DebugCharacterTexture ( cDiffuse.rgb*i_debugparams[2].y , vNormal*i_debugparams[2].z , fSpecValueOriginal*i_debugparams[2].w );
}

return half4 ( PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z ).rgb, vDiffuse.a );
}