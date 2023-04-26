
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4 P = half4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );
Out.vPos = In.Pos.xyz;


Out.UV.xy = In.UV;
Out.UV.zw = In.LM;
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.dataconstants = float4 ( i_macroOverlayUVScale.x, 0.0f, 0.0f, 0.0f );
Out.lightmapchannel = i_monoLightmap_Dot;
}


half ward_anisotropic ( half3 normal , half3 viewdir , half3 lightdir , half spreadu , half spreadv , half rough ) 
{


half3 udir = normalize ( half3 ( -normal.z, 0, normal.x ) );
half3 vdir = cross ( normal , udir );

half dotNE = dot ( normal , viewdir );
half dotNL = dot ( normal , lightdir );
half ax = rough/spreadu;
half ay = rough/spreadv;
half3 H = normalize ( lightdir+viewdir );
half dotHN = dot ( H , normal );
half expu = dot ( H , udir )/ax;
half expv = dot ( H , vdir )/ay;
expu = expu*expu;
expv = expv*expv;

return exp ( -2*( expu+expv )/( 1+dotHN ) )/( sqrt ( dotNL*dotNE )*12.566370614359172953850573533118*ax*ay );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half3 normalIn = half3 ( 0, 1, 0 );
half2 uv = In.UV.xy*m_params[1].w;
half3 cOverlay = GetOverlayTextureValue ( i_macrooverlay , In.UV.xy*In.dataconstants.x , 2 );

half3 pcaNormal = GetPCANormal ( i_normal , i_normal2 , uv , m_params[1].z*2*cOverlay.x );
pcaNormal = normalize ( max ( abs ( pcaNormal ) , half3 ( 0.001, 0.001, 0.001 ) ) );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );

half3 ref_vec = reflect ( vViewDir , pcaNormal );
ref_vec.y *= -1;
ref_vec.x *= -1;


half4 cLightMap = GetLightMap_SingleTap ( i_lightmap , i_chromaticity , In.UV.zw+0.01*pcaNormal.xz , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) );
half4 reflection = texCUBE ( i_environment , ref_vec );
reflection = reflection*cLightMap;


float NV = abs ( dot ( pcaNormal , vViewDir ) );
float F = 0.25+( 0.75*pow ( 1-NV , 5 ) );

half spec = ward_anisotropic ( pcaNormal , vViewDir , g_vLightDir.xyz , m_params[2].x , m_params[2].y , m_params[2].z )*cLightMap.a;
half3 calculatedSpec = spec*m_params[0].xyzw;
half3 reflectedSpec = reflection.xyz*F;
half3 diffTerm = half3 ( 0, 0, 0 );

half4 outcol = half4 ( diffTerm, 1 );
outcol.rgb += reflectedSpec;
outcol.rgb += calculatedSpec;

half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, 1 );

outcol = ChooseDebugLighting ( outcol , diffTerm , cLightMap.rgb , calculatedSpec , black3 , reflectedSpec , black3 , diffTerm+reflectedSpec+calculatedSpec );

outcol = ChooseDebugTexture ( outcol , tex2D ( i_chromaticity , In.UV.zw ) , black4 , tex2D ( i_normal2 , In.UV.xy ) , half4 ( diffTerm, 1 ) , black4 , GetDebugReflectClr ( i_environment , pcaNormal , vViewDir ) , half4 ( cLightMap.aaa, 1.0 ) , black4 , tex2D ( i_normal , In.UV.xy ) , black4 , black4 );


half4 returncolour = PS_Fog_Bloom_Tone ( outcol*m_params[1].y , In.Fog , g_envattributes[2].x );
returncolour.a = 0;
return returncolour;
}
