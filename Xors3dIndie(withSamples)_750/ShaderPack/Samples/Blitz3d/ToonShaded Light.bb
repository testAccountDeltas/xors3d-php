;====================================
; mSL (mini Shader Library)
;
;	Toon Shaded Light
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
xCameraClsColor gCamera,50,50,50
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
Local tShader%=xLoadFXFile("..\..\Materials\ToonShaded Light.fx")
;====================================


;====================================
; Model
Local tModel%=xLoadMesh("..\Media\Teapot.b3d")

Local tTextureToonGradient%=xLoadTexture("..\Media\ToonGradient.png")

xSetEntityEffect tModel,tShader
xSetEffectTechnique tModel,"Point"
xSetEffectMatrixSemantic tModel,"MatWorldViewProj",WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel,"MatWorld",WORLD
;		Shader Variables
xSetEffectVector tModel,	"AmbientClr",.2,.1,.3
xSetEffectVector tModel,	"LightClr",.9,.8,1
xSetEffectFloat tModel,		"RngLight",30
xSetEffectVector tModel,	"CountourClr",0,0,0
xSetEffectFloat tModel,		"CountourWidth",.2
xSetEffectTexture tModel,	"tToonGradient",tTextureToonGradient
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
		;====================================
		
		If xKeyHit(KEY_ESCAPE) End
	
	xSetEffectVector tModel,	"PosLight",xEntityX(tLightSpr),xEntityY(tLightSpr),xEntityZ(tLightSpr)
	xSetEffectVector tModel,	"PosCam",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera)
	
	xRenderWorld
	
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