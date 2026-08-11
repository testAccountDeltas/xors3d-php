;====================================
; mSL (mini Shader Library)
;
;	Stained Glass
;
; Author: MoKa (Maxim Miheyev)
; Email: mokadwod@gmail.com
; Visit: xors3d.com
;====================================



;====================================
Include "Xors3D.bb"
;====================================


;====================================
; Window
xGraphics3D 800,600,32,0,1
xSetTextureFiltering TF_ANISOTROPIC
SeedRnd MilliSecs()
;====================================


;====================================
; Font
Local Font%=xLoadFont("Tahoma",10)
xSetFont Font
;====================================


;====================================
; Varriables
Global mXSp%,mYSp%
Global IKdQ%,IKdW%,IKdE%,IKdA%,IKdS%,IKdD%
Global IKhF1%,IKhF2%

Local EffRefractionFade%=True
Local EffRefractionNM%=True
;====================================


;====================================
; Camera
Global gCamera%=xCreateCamera()
xCameraZoom gCamera,.8
xCameraClsColor gCamera,0,0,0
xRotateEntity gCamera,-20,45,0
xMoveEntity gCamera,0,10,-100
xCameraRange gCamera,1,6000
;====================================


;====================================
; LightSphere
Local tLightSpr%=xCreateSphere(6)
xEntityFX tLightSpr,1
xPositionEntity tLightSpr,30,30,30
xScaleEntity tLightSpr,2,2,2
;====================================


;====================================
; SkyBox
Global SkyBox%=mLoadSkyBox%("..\Media\SkyBox\Sky1")
xPositionMesh SkyBox,0,1,0
xScaleEntity SkyBox,3000,1500,3000
;====================================


;====================================
; Shader
Local tShader%=xLoadFXFile("..\..\Materials\Stained Glass.fx")
;====================================


;====================================
; Model
Local tModel%=xLoadMesh("..\Media\Billboard.b3d")

Local tTextureDiffuse%=xLoadTexture("..\Media\Glass_Diffuse.png")
Local tTextureRefraction%=xLoadTexture("..\Media\Glass_Mask.png")
Local tTextureNormal%=xLoadTexture("..\Media\Glass_Normal.png")
Local tTextureScreen%=xCreateTexture(256,192)

xSetEntityEffect tModel,tShader
xSetEffectTechnique tModel,"RefractionNM"
xSetEffectMatrixSemantic tModel,"MatWorldViewProj",WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel,"MatWorld",WORLD
;		Shader Varriables
xSetEffectTexture tModel,	"tDiffuse",tTextureDiffuse
xSetEffectTexture tModel,	"tRefraction",tTextureRefraction
xSetEffectTexture tModel,	"tNormal",tTextureNormal
xSetEffectTexture tModel,	"tScreen",tTextureScreen
xSetEffectFloat tModel,		"Refract",.3
;====================================





;====================================
; Main Cycle
xMoveMouse 400,300

Repeat
		
		UpdateInput
		UpdateCamera gCamera,.1,1
		
		;====================================
		xPositionEntity tLightSpr,Sin(MilliSecs()*.05)*30,Sin(MilliSecs()*.06)*30,Sin(MilliSecs()*.04)*20-10
		;====================================
		
		If xKeyHit(KEY_ESCAPE) End
	
	;====================================
	; Render Refraction
	xHideEntity tModel
	xCameraViewport gCamera,0,0,256,192
	xSetBuffer xTextureBuffer(tTextureScreen)
	xRenderWorld
	xSetBuffer xBackBuffer()
	xCameraViewport gCamera,0,0,800,600
	xShowEntity tModel
	;====================================
	; Setting Parameters
	xSetEffectVector tModel,	"LightPosition",xEntityX(tLightSpr),xEntityY(tLightSpr),xEntityZ(tLightSpr)
	xSetEffectVector tModel,	"CameraPosition",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera)
	;====================================
	xRenderWorld
	;====================================
	
	
	;====================================
	xText 10,10,"TrisRendered: "+xTrisRendered()
	xText 10,25,"FPS: "+xGetFPS()
	;====================================
	xFlip
Forever
;====================================






;====================================
; Functions
Function UpdateInput()
	xMoveMouse 400,300
	mXSp=xMouseXSpeed() mYSp=xMouseYSpeed()
	IKdQ=xKeyDown(KEY_Q) IKdW=xKeyDown(KEY_W)
	IKdE=xKeyDown(KEY_E) IKdA=xKeyDown(KEY_A)
	IKdS=xKeyDown(KEY_S) IKdD=xKeyDown(KEY_D)
	IKhF1=xKeyHit(KEY_F1)
	IKhF2=xKeyHit(KEY_F2)
End Function

Function UpdateCamera(Camera%,ViewSensivity#,MoveSensivity#)
	Local CamP#=xEntityPitch(gCamera)+mYSp*ViewSensivity
	If Abs(CamP)>80 CamP=80*Sgn(CamP)
	xTurnEntity Camera,0,-mXSp*ViewSensivity,0
	xRotateEntity Camera,CamP,xEntityYaw(gCamera),0
	
	xMoveEntity Camera,(IKdD-IKdA)*MoveSensivity,(IKdE-IKdQ)*MoveSensivity,(IKdW-IKdS)*MoveSensivity
End Function

Function mLoadSkyBox%(Dir$,Typ$="jpg")
	Local Mesh%=xCreateMesh()
	Local Brush%,Texture%,Surf%,v0%,v1%,v2%,v3%
	
	; Left
	If FileType(Dir+"\"+"left."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"left."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1,-1,0,0)
		v1=xAddVertex(Surf,-1, 1, 1,1,0)
		v2=xAddVertex(Surf,-1,-1,-1,0,1)
		v3=xAddVertex(Surf,-1,-1, 1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	; Front
	If FileType(Dir+"\"+"front."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"front."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1,1,0,0)
		v1=xAddVertex(Surf, 1, 1,1,1,0)
		v2=xAddVertex(Surf,-1,-1,1,0,1)
		v3=xAddVertex(Surf, 1,-1,1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	; Right
	If FileType(Dir+"\"+"right."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"right."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,1, 1, 1,0,0)
		v1=xAddVertex(Surf,1, 1,-1,1,0)
		v2=xAddVertex(Surf,1,-1, 1,0,1)
		v3=xAddVertex(Surf,1,-1,-1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	; Back
	If FileType(Dir+"\"+"back."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"back."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf, 1, 1,-1,0,0)
		v1=xAddVertex(Surf,-1, 1,-1,1,0)
		v2=xAddVertex(Surf, 1,-1,-1,0,1)
		v3=xAddVertex(Surf,-1,-1,-1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	; Bottom
	If FileType(Dir+"\"+"bottom."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"bottom."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1,-1, 1,0,0)
		v1=xAddVertex(Surf, 1,-1, 1,1,0)
		v2=xAddVertex(Surf,-1,-1,-1,0,1)
		v3=xAddVertex(Surf, 1,-1,-1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	; Top
	If FileType(Dir+"\"+"top."+Typ)<>0
		Texture=xLoadTexture(Dir+"\"+"top."+Typ,49)
		Brush=xCreateBrush()
		xBrushTexture Brush,Texture
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1, 1,0,0)
		v1=xAddVertex(Surf,-1, 1,-1,1,0)
		v2=xAddVertex(Surf, 1, 1, 1,0,1)
		v3=xAddVertex(Surf, 1, 1,-1,1,1)
		xAddTriangle Surf,v2,v1,v0
		xAddTriangle Surf,v1,v2,v3
	EndIf
	
	xEntityFX Mesh,1+8
	xFlipMesh Mesh
	xUpdateNormals Mesh
	
	Return Mesh
End Function
;====================================