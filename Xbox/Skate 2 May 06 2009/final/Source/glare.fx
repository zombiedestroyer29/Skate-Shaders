
void defaultVS ( VS_IN In , out PS_IN Out ) 
{

half4 P = half4 ( In.Pos, 1.0 );
half2 uvscale = In.UV-0.5;
P.xz = In.Pos.xz-uvscale;

half4x4 matVI = transpose ( g_matV );
P.xyz = P.xyz+i_glareScale.x*( uvscale.x*matVI[0].xyz-uvscale.y*matVI[1].xyz );

half4 P1 = P;
P1.xyz = P.xyz+i_glareScale.x/2*matVI[2].xyz;

Out.Pos = mul ( P , g_matVP );
half4 newpos = mul ( P1 , g_matVP );
Out.Pos.z = min ( Out.Pos.z , ( newpos.z/newpos.w )*Out.Pos.w );


Out.UV = In.UV;
}


half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = tex2D ( i_diffuse , In.UV.xy );
return cDiffuse;
}
