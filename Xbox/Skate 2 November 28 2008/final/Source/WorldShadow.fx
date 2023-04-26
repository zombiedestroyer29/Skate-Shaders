
struct VS_IN
{
float4 Pos : POSITION;
};
struct PS_IN
{
float4 Pos : POSITION;
};

void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.Pos.xyz, 1.0 );
Out.Pos = mul ( P , g_matVP );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}
