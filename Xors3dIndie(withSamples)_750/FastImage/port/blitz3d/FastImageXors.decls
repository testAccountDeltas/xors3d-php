.lib "FastImageXors.dll"

xInitDraw_% (Direct3DDevice9%, reserved%) : "InitDraw_"
xDeinitDraw%() : "DeinitDraw_"
xStartDraw% () : "StartDraw_"
xEndDraw% () : "EndDraw_"
xSetCustomState% (operation%, value%) : "SetCustomState_"
xSetCustomTextureState% (operation%, value%) : "SetCustomTextureState_"
xSetMipLevel% (level%) : "SetMipLevel_"
xSetBlend% (blend%) : "SetBlend_"
xSetAlpha% (alpha#) : "SetAlpha_"
xSetColor% (r%, g%, b%) : "SetColor_"
xSetCustomColor% (colorVertex0%, colorVertex1%, colorVertex2%, colorVertex3%) : "SetCustomColor_"
xSetRotation% (rotation#) : "SetRotation_"
xSetScale% (scaleX#, scaleY#) : "SetScale_"
xSetTransform% (rotation#, scaleX#, scaleY#) : "SetTransform_"
xSetMatrix% (xx#, xy#, yx#, yy#) : "SetMatrix_"
xSetHandle% (x%, y%) : "SetHandle_"
xSetOrigin% (x%, y%) : "SetOrigin_"
xMidHandleImage% (image%) : "MidHandleImage_"
xSetImageHandle% (image%, x%, y%) : "SetImageHandle_"
xAutoMidHandleEx% (state%) : "AutoMidHandleEx_"
xAutoImageFlags% (flags%) : "AutoImageFlags_"
xSetLineWidth% (width#) : "SetLineWidth_"
xSetViewport% (x%, y%, width%, height%) : "SetViewport_"
xCreateImageEx_% (texures*, width%, height%, flags%) : "CreateImageEx_"
xFreeImageEx_% (image%) : "FreeImageEx_"
xDrawImageEx_% (image%, x%, y%, frame%) : "DrawImageEx_"
xDrawImageRectEx_% (image%, x%, y%, width%, height%, frame%) : "DrawImageRectEx_"
xDrawImagePart_% (image%, x%, y%, width%, height%, partX%, partY%, partWidth%, partHeight%, frame%, wrap%) : "DrawImagePart_"
xDrawPoly_% (x%, y%, bank%, image%, frame%, color%) : "DrawPoly_"
xDrawRect_% (x%, y%, width%, height%, fill%) : "DrawRect_"
xDrawRectSimple_% (x%, y%, width%, height%, fill%) : "DrawRectSimple_"
xDrawLine% (x%, y%, x2%, y2%) : "DrawLine_"
xDrawLineSimple% (x%, y%, x2%, y2%) : "DrawLineSimple_"
xDrawPlot% (x%, y%) : "DrawPlot_"
xDrawOval% (x%, y%, width%, height%) : "DrawOval_"
xGetProperty_%(type*) : "GetProperty_"
xGetImageProperty_%(image%, type*) : "GetImageProperty_"
xSetProjScale% (scaleX#, scaleY#) : "SetProjScale_"
xSetProjRotation% (rotation#) : "SetProjRotation_"
xSetProjTransform% (rotation#, scaleX#, scaleY#) : "SetProjTransform_"
xSetProjOrigin% (x%, y%) : "SetProjOrigin_"
xSetProjHandle% (x%, y%) : "SetProjHandle_"
xMidHandleProj% () : "MidHandleProj_"

xCreateImageFont% (type*) : "CreateImageFont_"
xSetImageFont% (font%) : "SetImageFont_"
xFreeImageFont_% (font%) : "FreeImageFont_"
xDrawText_% (text$, x%, y%, centerX%, centerY%, maxWidth%) : "DrawTextEx_"
xDrawTextRect_% (text$, x%, y%, w%, h%, centerX%, centerY%, lineSpacing%) : "DrawTextRect_"
xTextRectCount%() : "TextRectCount_"
xTextRectMaxWidth%() : "TextRectMaxWidth_"
xTextRectWidth%(StringNumber%) : "TextRectWidth_"
xStringWidthEx_%(text$, maxWidth%) : "StringWidthEx_"
xStringHeightEx%(text$) : "StringHeightEx_"
xGetFontProperty_%(font%, type*) : "GetFontProperty_"

xTestRect_% (xPoint%, yPoint%, xRect%, yRect%, WidthRect%, HeightRect%, Local%, Result*, ResultFlag%) : "TestRect_"
xTestOval_% (xPoint%, yPoint%, xOval%, yOval%, WidthOval%, HeightOval%, Local%, Result*, ResultFlag%) : "TestOval_"
xTestImage_% (xPoint%, yPoint%, xImage%, yImage%, Image%, Local%, Result*, ResultFlag%) : "TestImage_"
xTestRendered_% (xPoint%, yPoint%, Local%, Result*, ResultFlag%) : "TestRendered_"

xGetCustomTransform_% (type%, martix*) : "GetCustomTransform_"
xSetCustomTransform_% (type%, matrix*) : "SetCustomTransform_"

.lib " "

xCreateImageEx% (texure%, width%, height%, flags%)
xLoadImageEx% (fileName$, textureFlags%, imageFlags%)
xLoadAnimImageEx% (fileName$, textureFlags%, frameWidth%, frameHeight%, firstFrame%, frameCount%, imageFlags%)
xDrawImageEx% (image%, x%, y%, frame%)
xDrawImageRectEx% (image%, x%, y%, width%, height%, frame%)
xDrawImagePart% (image%, x%, y%, width%, height%, tx%, ty%, twidth%, theight%, frame%)
xDrawRect% (x%, y%, width%, height%, fill%)
xDrawRectSimple% (x%, y%, width%, height%, fill%)
xSetCustomBlend% (src%, dest%)

xInitDraw% ()
xGetProperty% ()
xGetImageProperty% (image%)
xGetFontProperty% (font%)

xLoadImageFont% (filename$, flags%)
xDrawText% (txt$, x%, y%, centerX%, centerY%)
xDrawTextRect% (txt$, x%, y%, w%, h%, centerX%, centerY%, lineSpacing%)

xTestRect% (xPoint%, yPoint%, xRect%, yRect%, WidthRect%, HeightRect%, Local%)
xTestOval% (xPoint%, yPoint%, xOval%, yOval%, WidthOval%, HeightOval%, Local%)
xTestImage% (xPoint%, yPoint%, xImage%, yImage%, Image%, alphaLevel%, Frame%, Local%)
xTestRendered% (xPoint%, yPoint%, alphaLevel%, Local%)
