
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


Out.vPos = P;
Out.Pos = mul ( P , g_matVP );
Out.Pos.z += GetZBias ( Out.Pos.z , 0.0 );


Out.UV = half4 ( In.UV.xy, 0.0f, 0.0f );
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue_Character ( i_diffuse , In.UV );
 if ( cDiffuse.y < 0.001225f ) {

cDiffuse.xyz = cDiffuse.x*i_colorize_red+cDiffuse.z*i_colorize_blue;
}

half4 outcolor = half4 ( 0, 0, 0, 0 );
outcolor = PS_Fog_Bloom_Tone ( cDiffuse*m_params[0].y , In.Fog , g_charattributes[2].z );

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
