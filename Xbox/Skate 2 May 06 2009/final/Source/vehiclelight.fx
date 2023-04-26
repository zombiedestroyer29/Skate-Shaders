
void defaultVS ( VS_IN In , out PS_IN Out ) 
{


half4x3 skinMatrix = GetSkinMatrix_Single ( i_boneArray , In.BoneIndices.w );


half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , skinMatrix ), 1.0 );

Out.vBinormal = mul ( In.vBinormal , skinMatrix );
Out.vTangent = mul ( In.vTangent , skinMatrix );

Out.vNormal = GetNormal ( Out.vTangent , Out.vBinormal );

Out.vPos = P;

Out.Pos = mul ( P , g_matVP );


Out.UV = half4 ( In.UV.xy, 0.0f, 0.0f );

Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV );

half4 vDiffuse = half4 ( cDiffuse.rgb*m_params[1].xyz, cDiffuse.a )*m_params[0].x;
return PS_Fog_Bloom_Tone ( vDiffuse , In.Fog , g_charattributes[2].z );
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
