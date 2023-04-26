
void defaultVS ( VS_IN_NOLM In , out PS_IN_NOLM Out ) 
{
half4x4 matVI = transpose ( g_matV );


half3 vViewDir = normalize ( mul ( i_matWorld , matVI[2] ) );
half3 xdir = normalize ( half3 ( vViewDir.z, 0, -vViewDir.x ) );
half3 ydir = half3 ( 0, 1, 0 );
half3 zdir = normalize ( half3 ( vViewDir.x, 0, vViewDir.z ) );

half4x4 rotMat = half4x4 ( half4 ( xdir, 0 ), half4 ( ydir, 0 ), half4 ( zdir, 0 ), half4 ( 0, 0, 0, 1 ) );
half4x4 matRW = mul ( rotMat , i_matWorld );

half4 P = mul ( half4 ( In.pos, 1.0 ) , i_matWorld );

Out.Pos = mul ( P , g_matVP );
Out.UV = half4 ( In.uv, 0, 0 );
Out.vPos = P.xyz;
Out.vNormal = mul ( half4 ( In.normal, 0 ) , i_matWorld ).xyz;
}

half4 defaultPS ( PS_IN_NOLM In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );

half4 outcolor = cDiffuse;
float viewangle = abs ( dot ( In.vNormal , normalize ( g_vViewPos-In.vPos ) ) );
half4 returncolour = half4 ( ( viewangle*outcolor ).rgb, 0 );
return returncolour;
}
