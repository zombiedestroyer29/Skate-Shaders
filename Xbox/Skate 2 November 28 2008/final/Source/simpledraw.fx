
void p_c ( VS_IN_CLR In , out PS_IN Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );
Out.Colour = In.Colour;
}
void p_c_uv ( VS_IN_CLR_UV In , out PS_IN_UV Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );
Out.Colour = In.Colour;
Out.UV = In.UV;
}

void p_n_c ( VS_IN_CLR_NORM In , out PS_IN Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );


float4 N = mul ( In.Norm , i_matWorld );
N = normalize ( N );

float3 LightDirection = normalize ( i_ConstantLightPos.xyz-P.xyz );
float DiffuseLight = saturate ( dot ( N.xyz , normalize ( i_ConstantLightPos.xyz ) ) );

float3 Ambient = float3 ( 0.2f, 0.2f, 0.2f );

Out.Colour = float4 ( saturate ( ( In.Colour.rgb*DiffuseLight )+( In.Colour.rgb*Ambient ) ), In.Colour.a );
}

void p_n_c_uv ( VS_IN_CLR_NORM_UV In , out PS_IN_UV Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );


float4 N = mul ( In.Norm , i_matWorld );
N = normalize ( N );

float3 LightDirection = normalize ( i_ConstantLightPos.xyz-P.xyz );
float DiffuseLight = saturate ( dot ( N.xyz , normalize ( i_ConstantLightPos.xyz ) ) );

float3 Ambient = float3 ( 0.2f, 0.2f, 0.2f );

Out.Colour = float4 ( saturate ( ( In.Colour.rgb*DiffuseLight )+( In.Colour.rgb*Ambient ) ), In.Colour.a );

Out.UV = In.UV;
}
void p_n_sc_uv ( VS_IN_NORM_UV In , out PS_IN_UV Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );


float4 N = mul ( In.Norm , i_matWorld );
N = normalize ( N );

float3 LightDirection = normalize ( i_ConstantLightPos.xyz-P.xyz );
float DiffuseLight = saturate ( dot ( N.xyz , normalize ( i_ConstantLightPos.xyz ) ) );

float3 Ambient = float3 ( 0.2f, 0.2f, 0.2f );

Out.Colour = float4 ( saturate ( ( i_ConstantColour.rgb*DiffuseLight )+( i_ConstantColour.rgb*Ambient ) ), i_ConstantColour.a );

Out.UV = In.UV;
}
void p_n_sc ( VS_IN_NORM In , out PS_IN Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );


float4 N = mul ( In.Norm , i_matWorld );
N = normalize ( N );

float3 LightDirection = normalize ( i_ConstantLightPos.xyz-P.xyz );
float DiffuseLight = saturate ( dot ( N.xyz , normalize ( i_ConstantLightPos.xyz ) ) );

float3 Ambient = float3 ( 0.2f, 0.2f, 0.2f );

Out.Colour = float4 ( saturate ( ( i_ConstantColour.rgb*DiffuseLight )+( i_ConstantColour.rgb*Ambient ) ), i_ConstantColour.a );
}

void p_sc_uv ( VS_IN_UV In , out PS_IN_SC_UV Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );
Out.UV = In.UV;
Out.Colour = i_ConstantColour;
}

void p_sc ( VS_IN In , out PS_IN_SC Out ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out.Pos = mul ( P , g_matVP );
Out.Colour = i_ConstantColour;
}

half4 SimpleDrawUVPS ( PS_IN_UV In ) : COLOR 
{
float4 col = tex2D ( i_textureSampler , In.UV );
col *= In.Colour;
return col;
}
half4 SimpleDrawUVSCPS ( PS_IN_SC_UV In ) : COLOR 
{
float4 col = tex2D ( i_textureSampler , In.UV );
col *= In.Colour;
return col;
}
half4 SimpleDrawPS ( PS_IN In ) : COLOR 
{
return In.Colour;
}
half4 SimpleDrawSCPS ( PS_IN_SC In ) : COLOR 
{
return In.Colour;
}
half4 NullPixelShader ( float4 Pos : POSITION ) : COLOR 
{
return half4 ( 0, 0, 0, 0 );
}
void DepthOnlyVS ( VS_IN In , out float4 Out : POSITION ) 
{
float4 P = mul ( In.Pos , i_matWorld );
Out = mul ( P , g_matVP );
Out.z = i_ConstantDepth.x*Out.w;
}
