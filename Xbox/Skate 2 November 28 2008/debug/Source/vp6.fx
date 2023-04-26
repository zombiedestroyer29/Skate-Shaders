
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4 pos = mul ( In.Pos , i_matWorld );

Out.Pos = mul ( pos , g_matVP );
Out.UV = In.UV;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half3x3 yuvToRgbMatrix = { 1.164383, 0, +1.596027, 1.164383, -0.391762, -0.812968, 1.164383, +2.017232, 0 , };


half3 yuv;
yuv.r = tex2D ( i_textureSampler , In.UV ).g-( 16./256 );
yuv.g = tex2D ( i_textureSampler1 , In.UV ).g-0.5;
yuv.b = tex2D ( i_textureSampler2 , In.UV ).g-0.5;

half3 result = mul ( yuvToRgbMatrix , yuv );

return half4 ( result, 1 );
}
