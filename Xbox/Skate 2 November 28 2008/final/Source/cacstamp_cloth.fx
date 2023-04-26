
void defaultVS ( VS_IN In , out PS_IN Out ) 
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

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , half3 ( g_charattributes[0].x, 0.8117647, 0.3882353 ) );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

half4 clrDecalStamp = half4 ( 0.0, 0.0, 0.0, 0.0 );

 if ( In.UV.z > 0.0 &amp;&amp; In.UV.w > 0.0 ) {


clrDecalStamp = tex2D ( i_decal , In.UV.zw );
cDiffuse = cDiffuse*( 1.0-clrDecalStamp.a )+clrDecalStamp*clrDecalStamp.a;
}

half4 cDirt;

cDirt = tex2D ( i_decal2 , In.UV.xy );

cDiffuse = ( cDiffuse*( 1.0-cDirt.a )+cDirt*cDirt.a )*i_params[0].y+( 1.0-i_params[0].y )*cDiffuse;

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

half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

cDiffuse = half4 ( 0, 0, 0, 1.f );
vDiffuse = CalculateDebugCharacterLighting ( vViewDir , g_vLightDir , wNormal , cDiffuse , m_params[5].xyz , m_params[4].xyz , m_params[5].w , fSpecValue , m_params[2].w , m_params[3].w , fShadowVal , m_params[1].xyz , m_params[6].xyz , m_params[2].xyz , m_params[3].xyz , m_params[1].w , m_params[0].z , 0 , 0 , 0 , 0 , 0 , irradVal );


} else {


vDiffuse = DebugCharacterTexture ( cDiffuse.rgb*0 , vNormal*0 , fSpecValueOriginal*0 );
}

return PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );
}
