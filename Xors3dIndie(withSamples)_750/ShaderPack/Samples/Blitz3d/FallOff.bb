;====================================
; mSL (mini Shader Library)
;
;	FallOff
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
; Shader
Local tShader%=xLoadFXFile("..\..\Materials\FallOff.fx")
;====================================


;====================================
; Model
Local tModel%=xLoadMesh("..\Media\Teapot.b3d")

Local tTextureDiffuse%=xLoadTexture("..\Media\Rockwall_Diffuse.jpg")

xSetEntityEffect tModel,tShader
xSetEffectTechnique tModel,"Normal"
xSetEffectMatrixSemantic tModel,"MatWorldViewProj",WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel,"MatWorld",WORLD
;		Shader Varriables
xSetEffectVector tModel,	"FallOffClr",1,.5,.0
xSetEffectFloat tModel,		"FallOffInt",1
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
		;====================================
		
		If xKeyHit(KEY_ESCAPE) End
	
	xSetEffectVector tModel,	"PosCam",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera)
	xSetEffectFloat tModel,		"FallOffSoft",(Sin(MilliSecs()*.3)+1.2)*3
	
	xRenderWorld
	
	xText 10,10,"TrisRendered: "+xTrisRendered()
	xText 10,25,"FPS: "+xGetFPS()
	
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