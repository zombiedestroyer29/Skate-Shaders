
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 row0 , row1 , row2;
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

float4 P;

if ( i_doGPUSkin.x < 1.0 ) {

P = mul ( half4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 ) , i_matWorld );
Out.vBinormal = mul ( In.vBinormal , (half4x3)i_matWorld );
Out.vTangent = mul ( In.vTangent , (half4x3)i_matWorld );
Out.vNormal = mul ( In.vNormal , (half4x3)i_matWorld );
} else {


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
}

Out.vPos = P;
Out.Pos = mul ( P , g_matVP );
Out.Pos.z += GetZBias ( Out.Pos.z , g_charattributes[2].w );


Out.UV = half4 ( In.UV.xy, 0.0f, 0.0f );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

float4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV );
half3 cSpecMaskValue = GetSpecularMaskValue ( i_specular , In.UV );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cSpecMaskValue.r;
half fShadowVal = CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_charattributes[0].w );

half4 vDiffuse = CalculateCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , fSpecValue , m_params[5].w , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[7].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , m_params[6].x , m_params[6].y , m_params[6].z , m_params[6].w , m_params[7].w );


return PS_Fog_Bloom_Tone ( vDiffuse , In.Fog , g_charattributes[2].z*m_params[0].y );
}

void simpleVS ( VS_IN In , out PS_IN_SIMPLE Out ) 
{
float4 row0 , row1 , row2;
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , g_charattributes[1].xyzw.y , row0 , row1 , row2 );

float4 P;
if ( i_doGPUSkin.x < 1.0 ) {

P = mul ( half4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 ) , i_matWorld );
} else {


float4 INP1 = float4 ( OffsetPos ( g_charattributes[1].xyzw , In.Pos ), 1.0 );
P.x = dot ( INP1 , row0 );
P.y = dot ( INP1 , row1 );
P.z = dot ( INP1 , row2 );
P.w = 1.0f;
}

Out.Pos = mul ( P , g_matVP );
}

float4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return float4 ( 0, 0, 0, 1 );
}
