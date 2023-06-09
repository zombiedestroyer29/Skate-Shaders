GXSetNumIndStages(1);
GXSetNumTevStages(4);

//
// Shadow Plane
//
GXSetTevKColorSel(GX_TEVSTAGE0, GX_TEV_KCSEL_K2);
GXSetTevOrder(GX_TEVSTAGE0, GX_TEXCOORD2, GX_TEXMAP6, GX_COLOR_NULL);
GXSetTevColorIn(GX_TEVSTAGE0, GX_CC_ZERO, GX_CC_ONE, GX_CC_TEXC, GX_CC_KONST);
GXSetTevColorOp(GX_TEVSTAGE0, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);
GXSetTevAlphaIn(GX_TEVSTAGE0, GX_CA_ZERO, GX_CA_ONE, GX_CA_TEXA, GX_CA_KONST);
GXSetTevAlphaOp(GX_TEVSTAGE0, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);

//
// Shadow Map
//
GXSetTevOrder(GX_TEVSTAGE1, GX_TEXCOORD3, GX_TEXMAP5, GX_COLOR_NULL);
GXSetTevColorIn(GX_TEVSTAGE1, GX_CC_ONE, GX_CC_ZERO, GX_CC_TEXC, GX_CC_CPREV);
GXSetTevColorOp(GX_TEVSTAGE1, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);
GXSetTevAlphaIn(GX_TEVSTAGE1, GX_CA_ONE, GX_CA_ZERO, GX_CA_TEXA, GX_CA_ZERO);
GXSetTevAlphaOp(GX_TEVSTAGE1, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);

//
// LM (with blend between shadowmap and dark color)
//
GXSetTevKColorSel(GX_TEVSTAGE2, GX_TEV_KCSEL_K3);
GXSetIndTexOrder(GX_INDTEXSTAGE0, GX_TEXCOORD1, GX_TEXMAP1);
GXSetIndTexCoordScale(GX_INDTEXSTAGE0, GX_ITS_1, GX_ITS_1); 
GXSetTevOrder(GX_TEVSTAGE2, GX_TEXCOORD_NULL, GX_TEXMAP7, GX_COLOR_NULL);
GXSetTevColorIn(GX_TEVSTAGE2, GX_CC_KONST, GX_CC_TEXC, GX_CC_CPREV, GX_CC_ZERO);
GXSetTevColorOp(GX_TEVSTAGE2, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);
GXSetTevAlphaIn(GX_TEVSTAGE2, GX_CA_ZERO, GX_CA_ZERO, GX_CA_ZERO, GX_CA_ONE);
GXSetTevAlphaOp(GX_TEVSTAGE2, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);

//
// DIFFUSE * LM
//
GXSetTevOrder(GX_TEVSTAGE3, GX_TEXCOORD0, GX_TEXMAP0, GX_COLOR_NULL);
GXSetTevColorIn(GX_TEVSTAGE3, GX_CC_ZERO, GX_CC_CPREV, GX_CC_TEXC, GX_CC_ZERO);
GXSetTevColorOp(GX_TEVSTAGE3, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_2, GX_TRUE, GX_TEVPREV);
GXSetTevAlphaIn(GX_TEVSTAGE3, GX_CA_ZERO, GX_CA_ZERO, GX_CA_ZERO, GX_CA_TEXA);
GXSetTevAlphaOp(GX_TEVSTAGE3, GX_TEV_ADD, GX_TB_ZERO, GX_CS_SCALE_1, GX_TRUE, GX_TEVPREV);









