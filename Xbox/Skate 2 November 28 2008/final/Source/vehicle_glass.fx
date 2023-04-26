
void defaultVS ( VS_IN_glass In , out PS_IN Out ) 
{
half4x3 skinMatrix = GetSkinMatrix_Single ( i_boneArray , In.BoneIndices.w );

half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , skinMatrix ), 1.0 );

Out.vBinormal = mul ( In.vBinormal , skinMatrix );
Out.vTangent = mul ( In.vTangent , skinMatrix );

Out.vNormal = GetNormal ( Out.vTangent , Out.vBinormal );
Out.vPos = P;
Out.Pos = mul ( P , g_matVP );
Out.Pos.z += GetZBias ( Out.Pos.z , 0.0 );


Out.UV = half4 ( In.UV.xy, 0.0, 0.0 );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = 1.0;
half3 ref_vec = reflect ( vViewDir , wNormal );
ref_vec.xy *= -1;
half4 cColorCube = GetCubeTextureValue ( i_environment , ref_vec );

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , half3 ( g_charattributes[0].x, 0.8117647, 0.3882353 ) );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );
half4 vDiffuse = CalculateVehicleLighting ( vViewDir , g_vLightDir , wNormal , half4 ( m_params[4].xyz, 1.0 ) , cColorCube , fSpecValue , m_params[2].w , fShadowVal*fWorldShadowVal , m_params[1].xyz , m_params[2].xyz , m_params[1].w , irradVal , m_params[5].w );

float4 outcolor = PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );
outcolor.a = i_params[0].x*m_params[4].w;
return outcolor;
}

void simpleVS ( VS_IN_glass In , out PS_IN_SIMPLE Out ) 
{
half4x3 skinMatrix = GetSkinMatrix_Single ( i_boneArray , In.BoneIndices.w );

half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , skinMatrix ), 1.0 );
Out.Pos = mul ( P , g_matVP );
}

half4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}


half4 debugPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV.xy );
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cDiffuse.a;
half fSpecValueOriginal = cDiffuse.a;
cDiffuse.a = 1.0;
half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , half3 ( g_charattributes[0].x, 0.8117647, 0.3882353 ) );

half4 vDiffuse = half4 ( 0, 0, 0, 0 );

if ( 0 < 0.5 ) {

cDiffuse = half4 ( 0, 0, 0, 1.f );
vDiffuse = CalculateDebugCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , 0 , 0 , 0 , 0 , 0 , half3 ( 0, 0, 0 ) );


} else {


vDiffuse = DebugCharacterTexture ( cDiffuse.rgb*0 , vNormal*0 , fSpecValueOriginal*0 );
}

return PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );
}
