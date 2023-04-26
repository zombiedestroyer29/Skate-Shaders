
void defaultVS ( VS_IN_STAMP In , out PS_IN_STAMP Out ) 
{
float4 row0 , row1 , row2;
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , half4 ( 0.0, 0.8, 0.0, 2.0 ).y , row0 , row1 , row2 );

float4 P;
float4 INP1 = float4 ( OffsetPos ( half4 ( 0.0, 0.8, 0.0, 2.0 ) , In.Pos ), 1.0 );
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
Out.Pos.z += GetZBias ( Out.Pos.z , 0.0 );


Out.UV = half4 ( In.UV.xy, 0.0f, 0.0f );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN_STAMP In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = vNormal.g;
cDiffuse.a = 1.0;

 if ( cDiffuse.y < 0.001225f ) {

cDiffuse.xyz = cDiffuse.x*i_colorize_red+cDiffuse.z*i_colorize_blue;
}

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , half3 ( g_charattributes[0].x, 0.8117647, 0.3882353 ) );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );


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
GetSkinMatrix_4 ( i_boneArray , In.BoneWeights , In.BoneIndices , half4 ( 0.0, 0.8, 0.0, 2.0 ).y , row0 , row1 , row2 );

float4 P;
float4 INP1 = float4 ( OffsetPos ( half4 ( 0.0, 0.8, 0.0, 2.0 ) , In.Pos ), 1.0 );
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

half4 crowdPS ( PS_IN_STAMP In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = vNormal.g;
cDiffuse.a = 1.0;

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , half3 ( g_charattributes[0].x, 0.8117647, 0.3882353 ) );
half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

half4 vDiffuse = CalculateCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , irradVal );


half4 outcolor = half4 ( vDiffuse.rgb, 1.0 );
outcolor.a = half ( (int)( cDiffuse.y+( 1.0-0.001225f ) ) );
return outcolor;
}
