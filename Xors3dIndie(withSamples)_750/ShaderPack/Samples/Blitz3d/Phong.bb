;====================================
; mSL (mini Shader Library)
;
;	Phong
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
Local tLightSpr%=xCreateSphere(4)
xEntityFX tLightSpr,1
xPositionEntity tLightSpr,30,30,30
;====================================


;====================================
; Shader
Local tShader%=xLoadFXFile("..\..\Materials\Phong.fx")
;====================================


;====================================
; Model
Local tModel%=xLoadMesh("..\Media\Teapot.b3d")

Local tTextureDiffuse%=xLoadTexture("..\Media\Rockwall_Diffuse.jpg")

xSetEntityEffect tModel,tShader
xSetEffectTechnique tModel,"Directional"
xSetEffectMatrixSemantic tModel,"MatWorldViewProj",WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel,"MatWorld",WORLD
;		Shader Varriables
xSetEffectVector tModel,	"AmbientClr",.25,.3,.35
xSetEffectVector tModel,	"SpecClr",1,.8,.6
xSetEffectFloat tModel,		"SpecInt",1
xSetEffectFloat tModel,		"SpecDot",2
xSetEffectFloat tModel,		"SpecRng",16
xSetEffectFloat tModel,		"RngLight",80
xSetEffectTexture tModel,	"tDiffuse",tTextureDiffuse
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
		
		xPositionEntity tLightSpr,Sin(MilliSecs()*.05)*30,Abs(Sin(MilliSecs()*.06)*25)+5,Sin(MilliSecs()*.04)*30
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