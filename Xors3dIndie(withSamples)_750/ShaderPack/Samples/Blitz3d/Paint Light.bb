;====================================
; mSL (mini Shader Library)
;
;	Paint Light
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
;====================================


;====================================
; Camera
Global gCamera%=xCreateCamera()
xCameraZoom gCamera,.8
xCameraClsColor gCamera,255,255,255
xRotateEntity gCamera,20,45,0
xMoveEntity gCamera,0,10,-100
;====================================


;====================================
; LightSphere
Local tLightSpr%=xCreateSphere(8)
xEntityFX tLightSpr,1
xPositionEntity tLightSpr,30,30,30
;====================================


;====================================
; Shader
Local tShader%=xLoadFXFile("..\..\Materials\Paint Light.fx")
;====================================


;====================================
; Model
Local tModel%=xLoadMesh("..\Media\Teapot.b3d")

Local tTexturePaintDark%=xLoadTexture("..\Media\Paint_Dark.png")
Local tTexturePaintMedium%=xLoadTexture("..\Media\Paint_Medium.png")
Local tTexturePaintLight%=xLoadTexture("..\Media\Paint_Light.png")
Local tTexturePaintWhite%=xLoadTexture("..\Media\Paint_White.png")

xSetEntityEffect tModel,tShader
xSetEffectTechnique tModel,"Directional"
xSetEffectMatrixSemantic tModel,"MatWorldViewProj",WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel,"MatWorld",WORLD
;		Shader Varriables
xSetEffectFloat tModel,		"RngLight",50
xSetEffectVector tModel,	"CountourClr",0,0,0
xSetEffectFloat tModel,		"CountourWidth",.2
xSetEffectTexture tModel,	"tPaintDark",tTexturePaintDark
xSetEffectTexture tModel,	"tPaintMedium",tTexturePaintMedium
xSetEffectTexture tModel,	"tPaintLight",tTexturePaintLight
xSetEffectTexture tModel,	"tPaintWhite",tTexturePaintWhite
;====================================



;====================================
; Main Cycle
xMoveMouse 400,300

Repeat
		
		UpdateInput	
		UpdateCamera gCamera,.1,1
		
		;====================================
		xTurnEntity tModel,0,.1,0
		
		If xKeyHit(KEY_1) xSetEffectTechnique tModel,"Directional"
		If xKeyHit(KEY_2) xSetEffectTechnique tModel,"Point"
		If xKeyHit(KEY_3) xSetEffectTechnique tModel,"PointDistance"
		
		xPositionEntity tLightSpr,Sin(MilliSecs()*.05)*40,Abs(Sin(MilliSecs()*.06)*40),Sin(MilliSecs()*.04)*40
		If Int(Rnd(0,2))=1 xSetEffectVector tModel,	"TexProjRnd",Rnd(0,1.0),Rnd(0,1.0),0
		;====================================
		
		If xKeyHit(KEY_ESCAPE) End
	
	xSetEffectVector tModel,	"PosLight",xEntityX(tLightSpr),xEntityY(tLightSpr),xEntityZ(tLightSpr)
	xSetEffectVector tModel,	"PosCam",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera)
	
	xRenderWorld
	
	xColor 0,0,0
	xText 10,10,"TrisRendered: "+xTrisRendered()
	xText 10,25,"FPS: "+xGetFPS()
	xText 10,580,"Press 1,2,3 to Change Light Type (Directional, Point, Point+Distance)"
	
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
End Function

Function UpdateCamera(Camera%,ViewSensivity#,MoveSensivity#)
	Local CamP#=xEntityPitch(gCamera)+mYSp*ViewSensivity
	If Abs(CamP)>80 CamP=80*Sgn(CamP)
	xTurnEntity Camera,0,-mXSp*ViewSensivity,0
	xRotateEntity Camera,CamP,xEntityYaw(gCamera),0
	
	xMoveEntity Camera,(IKdD-IKdA)*MoveSensivity,(IKdE-IKdQ)*MoveSensivity,(IKdW-IKdS)*MoveSensivity
End Function
;====================================