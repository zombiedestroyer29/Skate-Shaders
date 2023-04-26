
float GetEccentricityMap ( sampler eccentricity , float2 uv ) 
{
half4 ecc = tex2D ( eccentricity , uv.xy );
return clamp ( MoveToLinearSpace ( ecc ).x , 0.01 , 1 );
}
