
void GetWeightsAndIndices ( float4 packeddata , out half4 weights , out half4 indices ) 
{
half4 lWeights0 = packeddata*1.0f/256.0f;
indices = floor ( lWeights0 );
weights = ( packeddata-( indices*256.0f ) );

}

half4x3 GetSkinMatrix_Single ( float4 boneArray [ 61*3 ] , half index ) 
{
half index3 = index*3;
half3x4 skinMatrix = half3x4 ( boneArray[index3], boneArray[index3+1], boneArray[index3+2] );


return transpose ( skinMatrix );
}


void GetSkinMatrix_4 ( float4 boneArray [ 61*3 ] , half4 weights , half4 indices , half offset , out float4 row0 , out float4 row1 , out float4 row2 ) 

{
float4 indices3 = indices*3;

 if ( offset != 0.0f ) {

weights /= 255.0f;
}
weights.w = 1.0f-dot ( float3 ( 1, 1, 1 ) , weights.xyz );

row0 = weights.x*boneArray[indices3.x];
row1 = weights.x*boneArray[indices3.x+1];
row2 = weights.x*boneArray[indices3.x+2];

row0 += weights.y*boneArray[indices3.y];
row1 += weights.y*boneArray[indices3.y+1];
row2 += weights.y*boneArray[indices3.y+2];

row0 += weights.z*boneArray[indices3.z];
row1 += weights.z*boneArray[indices3.z+1];
row2 += weights.z*boneArray[indices3.z+2];

row0 += weights.w*boneArray[indices3.w];
row1 += weights.w*boneArray[indices3.w+1];
row2 += weights.w*boneArray[indices3.w+2];
}

float3 OffsetPos ( half4 vtx_offset , float3 inPos ) 
{
return ( ( inPos*vtx_offset.w )+vtx_offset.xyz );
}


half GetZBias ( half fScreenPosZ , half zbias ) 
{
half fZ;

fZ = zbias/fScreenPosZ;

return fZ;
}
