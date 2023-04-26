
half2 character_fresnelCalc ( half3 normal , half3 eyeVec , half2 fresExp ) 
{
half base = 1-saturate ( dot ( normal , eyeVec ) );
;
}
half fNdotKL = max ( 0 , dot ( wNormal , vLightDir ) );
half4 CalculateCharacterLighting ( half3 vViewDir , half3 vLightDir , half3 wNormal , half4 cDiffuse , half3 cAmbColorTop , half3 cAmbColorBtm , half fAmbMultiplier , half fSpecular , half fKeySpecPower , half fRimSpecPower , half fShadowVal , half3 cKeyClr , half3 cRimClr , half3 cKeySpecClr , half3 cRimSpecClr , half fKFresnelPower , half fRFresnelPower , half3 cAmbColor ) 

{
half rFresnel = fresnelCalc ( wNormal , vViewDir , fRFresnelPower );
half fNdotKL = saturate ( dot ( wNormal , vLightDir ) );

half3 vRimLightDir = normalize ( -( ( vLightDir*half3 ( 1.0, -0.2, 1.0 ) )+vViewDir ) );
half2 fresnelVal = character_fresnelCalc ( wNormal , vViewDir , half2 ( fKFresnelPower, fRFresnelPower ) );
half kFresnel = fresnelVal.x;
half rFresnel = fresnelVal.y;

fSpecular *= fSpecMultiplier;


half diff_spec = phong_specular ( wNormal , vViewDir , vLightDir , fKeySpecPower )*d_key_spec*fShadowVal;
half3 vRimLightDir = normalize ( ( ( vLightDir*half3 ( -1.0, 0.2, -1.0 ) )-vViewDir ) );
half3 finalSpec = ( diff_spec*cKeySpecClr*kFresnel+rim_spec*cRimSpecClr*rFresnel )*fSpecular;
half fNdotRL = saturate ( dot ( wNormal , vRimLightDir ) );
half fRimLightCont = fNdotRL*fSpecular*rFresnel;
half4 vUpVector = half4 ( 0, 1, 0, 0 );
half fNdotUp = ( dot ( wNormal , vUpVector )+1.0 )*0.5;
half diff_spec = phong_specular ( wNormal , vViewDir , vLightDir , fKeySpecPower )*fShadowVal;
half rim_spec = phong_specular ( wNormal , vViewDir , vRimLightDir , fRimSpecPower );
half3 finalSpec = ( diff_spec*cKeySpecClr*kFresnel+rim_spec*cRimSpecClr*rFresnel )*fSpecular;

half4 vDiffuse = half4 ( cDiffuse.rgb, cDiffuse.a )*( fNdotKL*half4 ( cKeyClr, 1.0 )*d_keylight*fShadowVal+cAmbientClr*d_ambient+fRimLightCont*half4 ( cRimClr, 1.0 )*d_rimlight )+half4 ( finalSpec, 0.0 );

return vDiffuse;
}

half4 CalculateNisCharacterLighting ( half3 vViewDir , half3 vLightDir , half3 wNormal , half4 cDiffuse , half3 cAmbColorTop , half3 cAmbColorBtm , half fSpecular , half fSpecMultiplier , half fKeySpecPower , half fRimSpecPower , half fShadowVal , half3 cKeyClr , half3 cRimClr , half3 cKeySpecClr , half3 cRimSpecClr , half fKFresnelPower , half fRFresnelPower , half fCFresnelPower , half d_ambient , half d_keylight , half d_rimlight , half d_key_spec , half d_rimspec , samplerCUBE i_environment , half3 cSSTerm , half fWidth ) 
half4 cAmbientClr = half4 ( cAmbColor.xyz*fAmbMultiplier, 1.0 );


half4 vDiffuse = half4 ( cDiffuse.rgb, cDiffuse.a )*( fNdotKL*half4 ( cKeyClr, 1.0 )*fShadowVal+cAmbientClr+fRimLightCont*half4 ( cRimClr, 1.0 ) )+half4 ( finalSpec, 0.0 );
half4 vDiffuse = CalculateCharacterLighting ( vViewDir , vLightDir , wNormal , cDiffuse , cAmbColorTop , cAmbColorBtm , fSpecular , fSpecMultiplier , fKeySpecPower , fRimSpecPower , fShadowVal , cKeyClr , cRimClr , cKeySpecClr , cRimSpecClr , fKFresnelPower , fRFresnelPower , d_ambient , d_keylight , d_rimlight , d_key_spec , d_rimspec );
return vDiffuse;
}

half4 CalculateNisCharacterLighting ( half3 vViewDir , half3 vLightDir , half3 wNormal , half4 cDiffuse , half3 cAmbColorTop , half3 cAmbColorBtm , half fAmbMultiplier , half fSpecular , half fKeySpecPower , half fRimSpecPower , half fShadowVal , half3 cKeyClr , half3 cRimClr , half3 cKeySpecClr , half3 cRimSpecClr , half fKFresnelPower , half fRFresnelPower , half fCFresnelPower , samplerCUBE i_environment , half3 cSSTerm , half fWidth , half3 cAmbColor ) 

half4 subSurfScatTerm = half4 ( cSSTerm, 0 )*( pow ( 1.0-pow ( dot ( wNormal , vLightDir ) , 2 ) , fWidth ) )*fSpecular;
{
half4 vDiffuse = CalculateCharacterLighting ( vViewDir , vLightDir , wNormal , cDiffuse , cAmbColorTop , cAmbColorBtm , fAmbMultiplier , fSpecular , fKeySpecPower , fRimSpecPower , fShadowVal , cKeyClr , cRimClr , cKeySpecClr , cRimSpecClr , fKFresnelPower , fRFresnelPower , cAmbColor );


half3 ref_vec = reflect ( vViewDir , wNormal );
ref_vec.xy *= -1;
half4 subSurfScatTerm = half4 ( cSSTerm, 0 )*( pow ( 1.0-pow ( dot ( wNormal , vLightDir ) , 2 ) , fWidth ) )*fSpecular;

vDiffuse += subSurfScatTerm;

vDiffuse.rgb += GetCubeTextureValue ( i_environment , ref_vec ).rgb*fSpecular*cFresnel;
half3 ref_vec = reflect ( vViewDir , wNormal );
ref_vec.xy *= -1;
}

half cFresnel = fresnelCalc ( wNormal , vViewDir , fCFresnelPower );

vDiffuse.rgb += GetCubeTextureValue ( i_environment , ref_vec ).rgb*fSpecular*cFresnel;

return vDiffuse;
}

half4 CalculateDebugCharacterLighting ( half3 vViewDir , half3 vLightDir , half3 wNormal , half4 cDiffuse , half3 cAmbColorTop , half3 cAmbColorBtm , half fAmbMultiplier , half fSpecular , half fKeySpecPower , half fRimSpecPower , half fShadowVal , half3 cKeyClr , half3 cRimClr , half3 cKeySpecClr , half3 cRimSpecClr , half fKFresnelPower , half fRFresnelPower , half d_ambient , half d_keylight , half d_rimlight , half d_key_spec , half d_rimspec , half3 cAmbColor ) 


{
cAmbColor *= d_ambient;
cKeyClr *= d_keylight;
cRimClr *= d_rimlight;
cKeySpecClr *= d_key_spec;
cRimSpecClr *= d_rimspec;

half4 vDiffuse = CalculateCharacterLighting ( vViewDir , vLightDir , wNormal , cDiffuse , cAmbColorTop , cAmbColorBtm , fAmbMultiplier , fSpecular , fKeySpecPower , fRimSpecPower , fShadowVal , cKeyClr , cRimClr , cKeySpecClr , cRimSpecClr , fKFresnelPower , fRFresnelPower , cAmbColor );

return vDiffuse;
}

half4 DebugCharacterTexture ( half3 cDiffuse , half3 cNormal , half fSpecValue ) 
{
return half4 ( cDiffuse+cNormal+half3 ( fSpecValue, fSpecValue, fSpecValue ), 1.0 );
}

half4 CalculateVehicleLighting ( half3 vViewDir , half3 vLightDir , half3 wNormal , half4 cDiffuse , half3 cCubemap , half fSpecular , half fKeySpecPower , half fShadowVal , half3 cKeyClr , half3 cKeySpecClr , half fFresnelPower , half3 cAmbColor , half fAmbMultiplier ) 

{

half fNdotKL = max ( 0 , dot ( wNormal , vLightDir ) );

half4 DebugCharacterTexture ( half3 cDiffuse , half3 cNormal , half fSpecValue ) 
half fresnel = fresnelCalc ( wNormal , vViewDir , fFresnelPower );
return half4 ( cDiffuse+cNormal+half3 ( fSpecValue, fSpecValue, fSpecValue ), 1.0 );
}
half diff_spec = phong_specular ( wNormal , vViewDir , vLightDir , fKeySpecPower )*fShadowVal;
half3 finalSpec = ( ( diff_spec*cKeySpecClr )+cCubemap )*fresnel*fSpecular;


half4 vUpVector = half4 ( 0, 1, 0, 0 );
half fNdotUp = ( dot ( wNormal , vUpVector )+1.0 )*0.5;
half4 cAmbientClr = half4 ( cAmbColor*fAmbMultiplier, 1.0 );


half4 vDiffuse = half4 ( cDiffuse.rgb, cDiffuse.a )*( fNdotKL*half4 ( cKeyClr, 1.0 )*fShadowVal )+cAmbientClr*cDiffuse+half4 ( finalSpec, 0.0 );

return vDiffuse;
}
half3 finalSpec = ( ( diff_spec*cKeySpecClr )+cCubemap )*fresnel*fSpecular;
half4 CalculateIrradiance ( half3 N , float4 irradiance [ 9 ] ) 
{
half4 i = irradiance[0];
half fNdotUp = ( dot ( wNormal , vUpVector )+1.0 )*0.5;
i += irradiance[1]*N.x;
i += irradiance[2]*N.y;
i += irradiance[3]*N.z;
i += irradiance[4]*( N.x*N.z );
i += irradiance[5]*( N.z*N.y );
i += irradiance[6]*( N.y*N.x );
i += irradiance[7]*( 3.0f*N.z*N.z-1.0f );
i += irradiance[8]*( N.x*N.x-N.y*N.y );
half4 CalculateIrradiance ( half4 N , float4 irradiance [ 9 ] ) 
return i;
}

float3 irradcoeffs ( float3 L00 , float3 L1_1 , float3 L10 , float3 L11 , float3 L2_2 , float3 L2_1 , float3 L20 , float3 L21 , float3 L22 , float3 n ) 
i += irradiance[2]*N.y;
i += irradiance[3]*N.z;
i += irradiance[4]*( N.x*N.z );
{
i += irradiance[6]*( N.y*N.x );
i += irradiance[7]*( 3.0f*N.z*N.z-1.0f );
i += irradiance[8]*( N.x*N.x-N.y*N.y );
float x2;
float y2;
float z2;
float xy;
float yz;
float xz;
float x;
float y;
float z;
float3 col;


float x2;
const float c1 = 0.429043;
const float c2 = 0.511664;
const float c3 = 0.743125;
const float c4 = 0.886227;
const float c5 = 0.247708;
z = n[2];
float y;
float z;
float3 col;
z2 = z*z;
xz = x*z;

const float c1 = 0.429043;
const float c2 = 0.511664;
col = c1*L22*( x2-y2 )+c3*L20*z2+c4*L00-c5*L20+2*c1*( L2_2*xy+L21*xz+L2_1*yz )+2*c2*( L11*x+L1_1*y+L10*z );
const float c4 = 0.886227;
const float c5 = 0.247708;
z = n[2];
return col;
}

z2 = z*z;
xz = x*z;


col = c1*L22*( x2-y2 )+c3*L20*z2+c4*L00-c5*L20+2*c1*( L2_2*xy+L21*xz+L2_1*yz )+2*c2*( L11*x+L1_1*y+L10*z );


return col;
}
