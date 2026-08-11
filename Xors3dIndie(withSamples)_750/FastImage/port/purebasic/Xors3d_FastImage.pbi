;/////////////////////////////////////////////
;// FastImage v1.7x Wrapper for PB / Xors3d //
;////////////////// by chi ///////////////////

;{ Constants

;CreateImageEx Flags
#FI_AUTOFLAGS = -1
#FI_NONE = 0
#FI_MIDHANDLE = 1
#FI_FILTEREDIMAGE = 2
#FI_FILTERED = 2

;SetBlend Flags
#FI_SOLIDBLEND = 0
#FI_ALPHABLEND = 1
#FI_LIGHTBLEND = 2
#FI_SHADEBLEND = 3
#FI_MASKBLEND = 4
#FI_MASKBLEND2 = 5
#FI_INVALPHABLEND = 6

;ImageFonts Flags
#FI_SMOOTHFONT = 1

;DrawImagePart Wrap Flags
#FI_NOWRAP = 0
#FI_WRAPU = 1
#FI_MIRRORU = 2
#FI_WRAPV = 4
#FI_MORRORV = 8
#FI_WRAPUV = 5
#FI_MIRRORUV = 10

;DrawPoly consts
#FI_POINTLIST     = 1  ;Renders the vertices as a collection of isolated points.
#FI_LINELIST      = 2  ;Renders the vertices As a List of isolated straight line segments. Calls using this primitive Structure fail If the count is less than 2 Or is odd.
#FI_LINESTRIP     = 3  ;Renders the vertices As a single polyline. Calls using this primitive Structure fail If the count is less than 2.
#FI_TRIANGLELIST  = 4  ;Renders the specified vertices as a sequence of isolated triangles. Each group of three vertices defines a separate triangle. Calls using this primitive Structure fail If the count is less than 3 or not evenly divisible by 3.
#FI_TRIANGLESTRIP = 5  ;Renders the vertices as a triangle strip. Calls using this primitive Structure fail If the count is less than 3.
#FI_TRIANGLEFAN   = 6  ;Renders the vertices as a triangle fan. Calls using this primitive Structure fail If the count is less than 3.

;Overlay Flags
#FI_COLOROVERLAY = 1

;}

;{ Structures

;{   FI_PropertyType

Structure FI_PropertyType
  Blend.i
  Alpha.f
  Red.i
  Green.i
  Blue.i
  ColorVertex0.i
  ColorVertex1.i
  ColorVertex2.i
  ColorVertex3.i
  Rotation.f
  ScaleX.f
  ScaleY.f
  MatrixXX.f
  MatrixXY.f
  MatrixYX.f
  MatrixYY.f
  HandleX.i
  HandleY.i
  OriginX.i
  OriginY.i
  AutoHandle.i
  AutoFlags.i
  LineWidth.f
  ViewportX.i
  ViewportY.i
  ViewportWidth.i
  ViewportHeight.i
  MipLevel.i
  ProjScaleX.f
  ProjScaleY.f
  ProjRotation.f
  ProjOriginX.i
  ProjOriginY.i
  ProjHandleX.i
  ProjHandleY.i
  Reserved0.i
  Reserved1.i
EndStructure
Global *FI_Property.FI_PropertyType
*FI_Property = AllocateMemory(SizeOf(FI_PropertyType))
InitializeStructure(*FI_Property, FI_PropertyType)

;}

;{   FI_ImagePropertyType

Structure FI_ImagePropertyType
  HandleX.i
  HandleY.i
  Width.i
  Height.i
  Frames.i
  Flags.i
  Texture.i
  Reserved0.i
  Reserved1.i
EndStructure
Global *FI_ImageProperty.FI_ImagePropertyType
*FI_ImageProperty = AllocateMemory(SizeOf(FI_ImagePropertyType))
InitializeStructure(*FI_ImageProperty, FI_ImagePropertyType)

;}

;{   FI_FontPropertyType

Structure FI_FontPropertyType
  Width.i
  Height.i
  FirstChar.i
  Kerning.i
  Image.i
  FrameWidth.i
  FrameHeight.i
  FrameCount.i
  Array Chars.i(255)
EndStructure
Global *FI_FontProperty.FI_FontPropertyType
*FI_FontProperty = AllocateMemory(SizeOf(FI_FontPropertyType))
InitializeStructure(*FI_FontProperty, FI_FontPropertyType)

;}

;{   FI_TestType

Structure FI_TestType
  Result.i
  ProjectedX.i
  ProjectedY.i
  RectX.i
  RectY.i
  RectU.f
  RectV.f
  TextureX.i
  TextureY.i
  Texture.i
  Frame.i
  Reserved1.i
EndStructure
Global *FI_Test.FI_TestType
*FI_Test = AllocateMemory(SizeOf(FI_TestType))
InitializeStructure(*FI_Test, FI_TestType)

;}

;{   FI_SurfacesType

Structure FI_SurfacesType
  Count.i
  Array Arrays.i(255)
  Texture.i
EndStructure
Global *FI_Surfaces.FI_SurfacesType
*FI_Surfaces = AllocateMemory(SizeOf(FI_SurfacesType))
InitializeStructure(*FI_Surfaces, FI_SurfacesType)

;}

;}

;{ OpenLibrary
lib = OpenLibrary(#PB_Any, "FastImageXors.dll")
If lib
  
  Prototype.i _xInitDraw(Direct3DDevice9.i, reserved.i)
  Prototype.i _xDeinitDraw()
  Prototype.i _xStartDraw()
  Prototype.i _xEndDraw()
  Prototype.i _xSetCustomState(operation.i, value.i)
  Prototype.i _xSetCustomTextureState(operation.i, value.i)
  Prototype.i _xSetMipLevel(level.i)
  Prototype.i _xSetBlend(blend.i)
  Prototype.i _xSetAlpha(alpha.f)
  Prototype.i _xSetColor(r.i, g.i, b.i)
  Prototype.i _xSetCustomColor(colorVertex0.i, colorVertex1.i, colorVertex2.i, colorVertex3.i)
  Prototype.i _xSetRotation(rotation.f)
  Prototype.i _xSetScale(scaleX.f, scaleY.f)
  Prototype.i _xSetTransform(rotation.f, scaleX.f, scaleY.f)
  Prototype.i _xSetMatrix(xx.f, xy.f, yx.f, yy.f)
  Prototype.i _xSetHandle(x.i, y.i)
  Prototype.i _xSetOrigin(x.i, y.i)
  Prototype.i _xMidHandleImage(image.i)
  Prototype.i _xSetImageHandle(image.i, x.i, y.i)
  Prototype.i _xAutoMidHandleEx(state.i)
  Prototype.i _xAutoImageFlags(flags.i)
  Prototype.i _xSetLineWidth(width.f)
  Prototype.i _xSetViewport(x.i, y.i, width.i, height.i)
  Prototype.i _xCreateImageEx(*texures, width.i, height.i, flags.i)
  Prototype   _xFreeImageEx(image.i)
  Prototype.i _xDrawImageEx(image.i, x.i, y.i, frame.i)
  Prototype.i _xDrawImageRectEx(image.i, x.i, y.i, width.i, height.i, frame.i)
  Prototype.i _xDrawImagePart(image.i, x.i, y.i, width.i, height.i, partX.i, partY.i, partWidth.i, partHeight.i, frame.i, wrap.i)
  Prototype.i _xDrawPoly(x.i, y.i, bank.i, image.i, frame.i, color.i)
  Prototype.i _xDrawRect(x.i, y.i, width.i, height.i, fill.i)
  Prototype.i _xDrawRectSimple(x.i, y.i, width.i, height.i, fill.i)
  Prototype.i _xDrawLine(x.i, y.i, x2.i, y2.i)
  Prototype.i _xDrawLineSimple(x.i, y.i, x2.i, y2.i)
  Prototype.i _xDrawPlot(x.i, y.i)
  Prototype.i _xDrawOval(x.i, y.i, width.i, height.i)
  Prototype.i _xGetProperty(*type)
  Prototype.i _xGetImageProperty(image.i, *type)
  Prototype.i _xSetProjScale(scaleX.f, scaleY.f)
  Prototype.i _xSetProjRotation(rotation.f)
  Prototype.i _xSetProjTransform(rotation.f, scaleX.f, scaleY.f)
  Prototype.i _xSetProjOrigin(x.i, y.i)
  Prototype.i _xSetProjHandle(x.i, y.i)
  Prototype.i _xMidHandleProj()
  Prototype.i _xCreateImageFont(*type)
  Prototype.i _xSetImageFont(font.i)
  Prototype   _xFreeImageFont(font.i)
  Prototype.i _xDrawText(text.s, x.i, y.i, centerX.i, centerY.i, maxWidth.i)
  Prototype.i _xDrawTextRect(text.s, x.i, y.i, w.i, h.i, centerX.i, centerY.i, lineSpacing.i)
  Prototype.i _xTextRectCount()
  Prototype.i _xTextRectMaxWidth()
  Prototype.i _xTextRectWidth(StringNumber.i)
  Prototype.i _xStringWidthEx(text.s, maxWidth.i)
  Prototype.i _xStringHeightEx(text.s)
  Prototype.i _xGetFontProperty(font.i, *type)
  Prototype.i _xTestRect(xPoint.i, yPoint.i, xRect.i, yRect.i, WidthRect.i, HeightRect.i, Local.i, *Result, ResultFlag.i)
  Prototype.i _xTestOval(xPoint.i, yPoint.i, xOval.i, yOval.i, WidthOval.i, HeightOval.i, Local.i, *Result, ResultFlag.i)
  Prototype.i _xTestImage(xPoint.i, yPoint.i, xImage.i, yImage.i, Image.i, Local.i, *Result, ResultFlag.i)
  Prototype.i _xTestRendered(xPoint.i, yPoint.i, Local.i, *Result, ResultFlag.i)
  Prototype.i _xGetCustomTransform(type.i, *martix)
  Prototype.i _xSetCustomTransform(type.i, *matrix)
  
  Global xInitDraw_._xInitDraw                            = GetFunction( lib, "InitDraw_")
  Global xDeinitDraw._xDeinitDraw                         = GetFunction( lib, "DeinitDraw_")
  Global xStartDraw._xStartDraw                           = GetFunction( lib, "StartDraw_")
  Global xEndDraw._xEndDraw                               = GetFunction( lib, "EndDraw_")
  Global xSetCustomState._xSetCustomState                 = GetFunction( lib, "SetCustomState_")
  Global xSetCustomTextureState._xSetCustomTextureState   = GetFunction( lib, "SetCustomTextureState_")
  Global xSetMipLevel._xSetMipLevel                       = GetFunction( lib, "SetMipLevel_")
  Global xSetBlend._xSetBlend                             = GetFunction( lib, "SetBlend_")
  Global xSetAlpha._xSetAlpha                             = GetFunction( lib, "SetAlpha_")
  Global xSetColor._xSetColor                             = GetFunction( lib, "SetColor_")
  Global xSetCustomColor._xSetCustomColor                 = GetFunction( lib, "SetCustomColor_")
  Global xSetRotation._xSetRotation                       = GetFunction( lib, "SetRotation_")
  Global xSetScale._xSetScale                             = GetFunction( lib, "SetScale_")
  Global xSetTransform._xSetTransform                     = GetFunction( lib, "SetTransform_")
  Global xSetMatrix._xSetMatrix                           = GetFunction( lib, "SetMatrix_")
  Global xSetHandle._xSetHandle                           = GetFunction( lib, "SetHandle_")
  Global xSetOrigin._xSetOrigin                           = GetFunction( lib, "SetOrigin_")
  Global xMidHandleImage._xMidHandleImage                 = GetFunction( lib, "MidHandleImage_")
  Global xSetImageHandle._xSetImageHandle                 = GetFunction( lib, "SetImageHandle_")
  Global xAutoMidHandleEx._xAutoMidHandleEx               = GetFunction( lib, "AutoMidHandleEx_")
  Global xAutoImageFlags._xAutoImageFlags                 = GetFunction( lib, "AutoImageFlags_")
  Global xSetLineWidth._xSetLineWidth                     = GetFunction( lib, "SetLineWidth_")
  Global xSetViewport._xSetViewport                       = GetFunction( lib, "SetViewport_")
  Global xCreateImageEx_._xCreateImageEx                  = GetFunction( lib, "CreateImageEx_")
  Global xFreeImageEx_._xFreeImageEx                      = GetFunction( lib, "FreeImageEx_")
  Global xDrawImageEx_._xDrawImageEx                      = GetFunction( lib, "DrawImageEx_")
  Global xDrawImageRectEx_._xDrawImageRectEx              = GetFunction( lib, "DrawImageRectEx_")
  Global xDrawImagePart_._xDrawImagePart                  = GetFunction( lib, "DrawImagePart_")
  Global xDrawPoly_._xDrawPoly                            = GetFunction( lib, "DrawPoly_")
  Global xDrawRect_._xDrawRect                            = GetFunction( lib, "DrawRect_")
  Global xDrawRectSimple_._xDrawRectSimple                = GetFunction( lib, "DrawRectSimple_")
  Global xDrawLine._xDrawLine                             = GetFunction( lib, "DrawLine_")
  Global xDrawLineSimple._xDrawLineSimple                 = GetFunction( lib, "DrawLineSimple_")
  Global xDrawPlot._xDrawPlot                             = GetFunction( lib, "DrawPlot_")
  Global xDrawOval._xDrawOval                             = GetFunction( lib, "DrawOval_")
  Global xGetProperty_._xGetProperty                      = GetFunction( lib, "GetProperty_")
  Global xGetImageProperty_._xGetImageProperty            = GetFunction( lib, "GetImageProperty_")
  Global xSetProjScale._xSetProjScale                     = GetFunction( lib, "SetProjScale_")
  Global xSetProjRotation._xSetProjRotation               = GetFunction( lib, "SetProjRotation_")
  Global xSetProjTransform._xSetProjTransform             = GetFunction( lib, "SetProjTransform_")
  Global xSetProjOrigin._xSetProjOrigin                   = GetFunction( lib, "SetProjOrigin_")
  Global xSetProjHandle._xSetProjHandle                   = GetFunction( lib, "SetProjHandle_")
  Global xMidHandleProj._xMidHandleProj                   = GetFunction( lib, "MidHandleProj_")
  Global xCreateImageFont._xCreateImageFont               = GetFunction( lib, "CreateImageFont_")
  Global xSetImageFont._xSetImageFont                     = GetFunction( lib, "SetImageFont_")
  Global xFreeImageFont_._xFreeImageFont                  = GetFunction( lib, "FreeImageFont_")
  Global xDrawText_._xDrawText                            = GetFunction( lib, "DrawTextEx_")
  Global xDrawTextRect_._xDrawTextRect                    = GetFunction( lib, "DrawTextRect_")
  Global xTextRectCount._xTextRectCount                   = GetFunction( lib, "TextRectCount_")
  Global xTextRectMaxWidth._xTextRectMaxWidth             = GetFunction( lib, "TextRectMaxWidth_")
  Global xTextRectWidth._xTextRectWidth                   = GetFunction( lib, "TextRectWidth_")
  Global xStringWidthEx_._xStringWidthEx                  = GetFunction( lib, "StringWidthEx_")
  Global xStringHeightEx._xStringHeightEx                 = GetFunction( lib, "StringHeightEx_")
  Global xGetFontProperty_._xGetFontProperty              = GetFunction( lib, "GetFontProperty_")
  Global xTestRect_._xTestRect                            = GetFunction( lib, "TestRect_")
  Global xTestOval_._xTestOval                            = GetFunction( lib, "TestOval_")
  Global xTestImage_._xTestImage                          = GetFunction( lib, "TestImage_")
  Global xTestRendered_._xTestRendered                    = GetFunction( lib, "TestRendered_")
  Global xGetCustomTransform_._xGetCustomTransform        = GetFunction( lib, "GetCustomTransform_")
  Global xSetCustomTransform_._xSetCustomTransform        = GetFunction( lib, "SetCustomTransform_")
  
EndIf
;}

;{ Procedures

Procedure   xSetCustomBlend( src.i, dest.i )
  xSetCustomState(15, 0)        ;DX7  SetRenderState ( D3DRENDERSTATE_AlphaTestEnable, False )
  xSetCustomState(27, 1)        ;DX7  SetRenderState ( D3DRENDERSTATE_AlphaBlendEnable, True )
  xSetCustomState(19, src)      ;DX7  SetRenderState ( D3DRENDERSTATE_SrcBlend, src )
  xSetCustomState(20, dest)     ;DX7  SetRenderState ( D3DRENDERSTATE_DestBlend, dest )
EndProcedure

Procedure.i xCreateImageEx( texture.i, width.i, height.i, imageFlags.i=#FI_AUTOFLAGS )
  Protected i.i
  If texture<>0
    *FI_Surfaces\Texture = texture
    *FI_Surfaces\Count = xGetTextureFrames(texture)
    If *FI_Surfaces\Count>0
      If *FI_Surfaces\Count>256 : *FI_Surfaces\Count=256 : EndIf
      For i=0 To *FI_Surfaces\Count-1
        *FI_Surfaces\Arrays(i) = xGetTextureSurface(texture, i)
      Next
      ProcedureReturn xCreateImageEx_(*FI_Surfaces, width, height, imageFlags)
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i xLoadImageEx( fileName.s, textureFlags.i=0, imageFlags.i=#FI_AUTOFLAGS )
  Protected Image.i, Image_Width.i, Image_Height.i
  Image = xLoadTexture(fileName, textureFlags)
  If Image
    Image_Width  = xTextureWidth(Image)
    Image_Height = xTextureHeight(Image)
    ProcedureReturn xCreateImageEx(Image, Image_Width, Image_Height, imageFlags)
  Else
    MessageBeep_(16)
    xDestroyRenderWindow()
    MessageRequester(" xLoadImageEx ","Loading Image [ " +fileName +" ] failed!")
    End
  EndIf
EndProcedure

Procedure.i xLoadAnimImageEx( fileName.s, textureFlags.i, frameWidth.i, frameHeight.i, firstFrame.i, frameCount.i, imageFlags.i=#FI_AUTOFLAGS )
  textureFlags = (textureFlags And $3F) Or $9
  ProcedureReturn xCreateImageEx_(xLoadAnimTexture(fileName, textureFlags, frameWidth, frameHeight, firstFrame, frameCount), frameWidth, frameHeight, imageFlags)
EndProcedure

Procedure.i xDrawImageEx( image.i, x.i, y.i, frame.i=0 )
  ProcedureReturn xDrawImageEx_(image, x, y, frame)
EndProcedure

Procedure.i xDrawImageRectEx( image.i, x.i, y.i, width.i, height.i, frame.i=0 )
  ProcedureReturn xDrawImageRectEx_(image, x, y, width, height, frame)
EndProcedure

Procedure.i xDrawImagePart( image.i, x.i, y.i, width.i, height.i, partX.i=0, partY.i=0, partWidth.i=0, partHeight.i=0, frame.i=0, wrap.i=#FI_NOWRAP )
  ProcedureReturn xDrawImagePart_(image, x, y, width, height, partX, partY, partWidth, partHeight, frame, wrap)
EndProcedure

Procedure.i xDrawPoly( x.i, y.i, bank.i, image.i=0, frame.i=0, color.i=#FI_NONE )
  ProcedureReturn xDrawPoly_(x, y, bank, image, frame, color)
EndProcedure

Procedure.i xDrawRect( x.i, y.i, width.i, height.i, fill.i=1 )
  ProcedureReturn xDrawRect_(x, y, width, height, fill)
EndProcedure

Procedure.i xDrawRectSimple( x.i, y.i, width.i, height.i, fill.i=1 )
  ProcedureReturn xDrawRectSimple_(x, y, width, height, fill)
EndProcedure

Procedure.i xLoadImageFont( filename.s, flags.i=#FI_SMOOTHFONT )
  Protected f.i, i.i, l.s, r.s, AnimTexture.s, AnimTextureFlags.i, Texture.i
  
  filename=ReplaceString( filename, "/", "\" )
  f = ReadFile(#PB_Any, filename )
  If f=0 : ProcedureReturn : EndIf
  
  *FI_FontProperty\Width=0
  *FI_FontProperty\Height=0
  *FI_FontProperty\FirstChar=0
  *FI_FontProperty\Kerning=0
  *FI_FontProperty\Image=0
  *FI_FontProperty\FrameWidth=0
  *FI_FontProperty\FrameHeight=0
  *FI_FontProperty\FrameCount=0
  For i=0 To 255
    *FI_FontProperty\Chars(i)=0
  Next
  AnimTextureFlags=4
  
  While Not Eof(f)
    l=Trim(ReadString(f))
    i=FindString(l,"=",1)
    If Len(l)>0 And Left(l,1)<>";" And i>0
      r=Trim(Right(l,Len(l)-i))
      l=UCase(Trim(Left(l,i-1)))
      Select l
        Case "ANIMTEXTURE"
          AnimTexture=r
        Case "ANIMTEXTUREFLAGS"
          AnimTextureFlags=Val(r)
        Case "FRAMEWIDTH"
          *FI_FontProperty\FrameWidth=Val(r)
        Case "FRAMEHEIGHT"
          *FI_FontProperty\FrameHeight=Val(r)
        Case "FRAMECOUNT"
          *FI_FontProperty\FrameCount=Val(r)
        Case "WIDTH"
          *FI_FontProperty\Width=Val(r)
        Case "HEIGHT"
          *FI_FontProperty\Height=Val(r)
        Case "FIRSTCHAR"
          *FI_FontProperty\FirstChar=Val(r)
        Case "KERNING"
          *FI_FontProperty\Kerning=Val(r)
        Default
          If Val(l)>=0 And Val(l)<=255
            *FI_FontProperty\Chars(Val(l))=Val(r)
          EndIf
      EndSelect
    EndIf
  Wend
  CloseFile(f)
  
  If Len(AnimTexture)>0 And *FI_FontProperty\FrameWidth>0 And *FI_FontProperty\FrameHeight>0 And *FI_FontProperty\FrameCount>0
    f=1
    Repeat
      i=FindString(filename,"\",f)
      If i<>0
        f=i+1
      EndIf
    Until i=0
    If flags=#FI_SMOOTHFONT
      flags=#FI_FILTEREDIMAGE
    Else
      flags=#FI_NONE
    EndIf
    *FI_FontProperty\Image = xLoadImageEx(Left(filename,f-1)+AnimTexture, (AnimTextureFlags And $6) Or $39, flags)
    ProcedureReturn xCreateImageFont(*FI_FontProperty)
  EndIf
  
  ProcedureReturn 0
EndProcedure

Procedure.i xStringWidthEx( txt.s, maxWidth.i=10000 )
  ProcedureReturn xStringWidthEx_(txt, maxWidth)
EndProcedure

Procedure.i xDrawText( txt.s, x.i, y.i, centerX.i=0, centerY.i=0, maxWidth.i=10000 )
  ProcedureReturn xDrawText_(txt, x, y, centerX, centerY, maxWidth)
EndProcedure

Procedure.i xDrawTextRect( txt.s, x.i, y.i, w.i, h.i, centerX.i=0, centerY.i=0, lineSpacing.i=0 )
  ProcedureReturn xDrawTextRect_(txt, x, y, w, h, centerX, centerY, lineSpacing)
EndProcedure

Procedure.i xInitDraw( def=0 )
  ProcedureReturn xInitDraw_(xGetDevice(), 0)
EndProcedure

Procedure.i xGetProperty()
  ProcedureReturn xGetProperty_(*FI_Property)
EndProcedure

Procedure.i xGetImageProperty( image.i )
  ProcedureReturn xGetImageProperty_(image, *FI_ImageProperty)
EndProcedure

Procedure.i xGetFontProperty( font.i )
  ProcedureReturn xGetFontProperty_(font, *FI_FontProperty)
EndProcedure

Procedure.i xTestRect( xPoint.i, yPoint.i, xRect.i, yRect.i, WidthRect.i, HeightRect.i, Loc.i=0 )
  ProcedureReturn xTestRect_(xPoint, yPoint, xRect, yRect, WidthRect, HeightRect, Loc, *FI_Test, 1)
EndProcedure

Procedure.i xTestOval( xPoint.i, yPoint.i, xOval.i, yOval.i, WidthOval.i, HeightOval.i, Loc.i=0 )
  ProcedureReturn xTestOval_(xPoint, yPoint, xOval, yOval, WidthOval, HeightOval, Loc, *FI_Test, 1)
EndProcedure

Procedure.i xTestImage( xPoint.i, yPoint.i, xImage.i, yImage.i, Image.i, alphaLevel.i=0, Frame.i=0, Loc.i=0 )
  If xTestImage_(xPoint, yPoint, xImage, yImage, Image, Loc, *FI_Test, 1) And alphaLevel>0 And *FI_Test\Texture<>0
    If (xReadPixel(*FI_Test\TextureX, *FI_Test\TextureY, xTextureBuffer(*FI_Test\Texture, Frame)) >> 24) < alphaLevel : *FI_Test\Result = 0 : EndIf
  EndIf
  ProcedureReturn *FI_Test\Result
EndProcedure

Procedure.i xTestRendered( xPoint.i, yPoint.i, alphaLevel.i=0, Loc.i=0 )
  If xTestRendered_(xPoint, yPoint, Loc, *FI_Test, 1) And alphaLevel>0 And *FI_Test\Texture<>0
    If (xReadPixel(*FI_Test\TextureX, *FI_Test\TextureY, xTextureBuffer(*FI_Test\Texture, *FI_Test\Frame)) >> 24) < alphaLevel : *FI_Test\Result = 0 : EndIf
  EndIf
  ProcedureReturn *FI_Test\Result
EndProcedure

Procedure   xFreeImageEx( image.i, freeTexture.i=0 )
  If freeTexture<>0 And xGetImageProperty(image)<>0 And *FI_ImageProperty\Texture<>0 : xFreeTexture(*FI_ImageProperty\Texture) : EndIf
  xFreeImageEx_(image)
EndProcedure

Procedure   xFreeImageFont( font.i )
  If xGetFontProperty(font)<>0 And *FI_FontProperty\Image<>0
    If xGetImageProperty(*FI_FontProperty\Image)<>0 And *FI_ImageProperty\Texture<>0 : xFreeTexture(*FI_ImageProperty\Texture) : EndIf
  EndIf
  xFreeImageFont_(font)
EndProcedure

;}

