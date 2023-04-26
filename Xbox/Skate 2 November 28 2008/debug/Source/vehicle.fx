
void defaultVS ( VS_IN In , out PS_IN Out ) 
{

half4x3 skinMatrix = GetSkinMatrix_Single ( i_boneArray , In.BoneIndices.w );

half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , skinMatrix ), 1.0 );

Out.vBinormal = mul ( In.vBinormal , skinMatrix );
Out.vTangent = mul ( In.vTangent , skinMatrix );
Out.vNormal = GetNormal ( Out.vTangent , Out.vBinormal );
Out.vPos = P;

Out.Pos = mul ( P , g_matVP );
Out.Pos.z += GetZBias ( Out.Pos.z , g_charattributes[2].w );

float2 correctUV1 = float2 ( 0.5, 0.5 );


correctUV1.x = In.UV1.x+2.0;
correctUV1.y = In.UV1.y;


Out.UV = half4 ( In.UV0.x+( correctUV1.y )*saturate ( dot ( i_isLightOn , f_lightSelector[round ( correctUV1.x )] ) ), In.UV0.y, 0.0, 0.0 );

Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV );
half3 vNormal = GetDXNNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half fSpecValue = cDiffuse.a;
cDiffuse.a = 1.0f;
half3 ref_vec = reflect ( vViewDir , wNormal );
ref_vec.xy *= -1;
half4 cColorCube = GetCubeTextureValue ( i_environment , ref_vec );


 if ( cDiffuse.y < 0.001225f ) {

cDiffuse.xyz = cDiffuse.x*i_colorize_red+cDiffuse.z*i_colorize_blue;
}


half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , g_charattributes[0].xyz );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );
half4 vDiffuse = CalculateVehicleLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , cColorCube , fSpecValue , m_params[2].w , fShadowVal*fWorldShadowVal , m_params[1].xyz , m_params[2].xyz , m_params[1].w , irradVal , m_params[5].w );

vDiffuse.a = 1.0f;

half4 outcolor = half4 ( 0, 0, 0, 0 );
outcolor = PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );

outcolor.a = i_params[0].x;
return outcolor;
}

void simpleVS ( VS_IN In , out PS_IN_SIMPLE Out ) 
{

half4x3 skinMatrix = GetSkinMatrix_Single ( i_boneArray , In.BoneIndices.w );

half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , skinMatrix ), 1.0 );
Out.Pos = mul ( P , g_matVP );
}

half4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}
