Rem
	mSL (mini Shader Library)
	
		Paint Light
	
	Author: MoKa (Maxim Miheyev)
	Email: mokadwod@gmail.com
	Visit: xors3d.com
End Rem



SuperStrict

'====================================
' Modules
Framework xorsteam.xors3d
Import brl.math
Import brl.random
'====================================


'====================================
' Window
xGraphics3D 800, 600, 32, False, True
xSetTextureFiltering TF_ANISOTROPIC
'====================================


'====================================
' Font
Local Font% = xLoadFont("Tahoma", 10)
xSetFont Font
'====================================


'====================================
' Varriables
Global mXSp%, mYSp%
Global IKdQ%, IKdW%, IKdE%, IKdA%, IKdS%, IKdD%
'====================================


'====================================
' Camera
Global gCamera% = xCreateCamera()
xCameraZoom gCamera, 0.8
xCameraClsColor gCamera, 255, 255, 255
xRotateEntity gCamera, 20, 45, 0
xMoveEntity gCamera, 0, 10, -100
'====================================


'====================================
' LightSphere
Local tLightSpr% = xCreateSphere(8)
xEntityFX tLightSpr, 1
xPositionEntity tLightSpr, 30, 30, 30
'====================================


'====================================
' Shader
Local tShader% = xLoadFXFile("..\..\Materials\Paint Light.fx")
'====================================


'====================================
' Model
Local tModel% = xLoadMesh("..\Media\Teapot.b3d")

Local tTexturePaintDark%   = xLoadTexture("..\Media\Paint_Dark.png")
Local tTexturePaintMedium% = xLoadTexture("..\Media\Paint_Medium.png")
Local tTexturePaintLight%  = xLoadTexture("..\Media\Paint_Light.png")
Local tTexturePaintWhite%  = xLoadTexture("..\Media\Paint_White.png")

xSetEntityEffect tModel, tShader
xSetEffectTechnique tModel, "Directional"
xSetEffectMatrixSemantic tModel, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel, "MatWorld", WORLD
'		Shader Varriables
xSetEffectFloat tModel,		"RngLight", 50
xSetEffectVector tModel,		"CountourClr", 0, 0, 0
xSetEffectFloat tModel,		"CountourWidth", 0.2
xSetEffectTexture tModel,	"tPaintDark", tTexturePaintDark
xSetEffectTexture tModel,	"tPaintMedium", tTexturePaintMedium
xSetEffectTexture tModel,	"tPaintLight", tTexturePaintLight
xSetEffectTexture tModel,	"tPaintWhite", tTexturePaintWhite
'====================================



'====================================
' Main Cycle
xMoveMouse 400, 300
Repeat
	UpdateInput
	
	UpdateCamera gCamera, 0.1, 1
	
	'====================================
	xTurnEntity tModel, 0, 0.1, 0
	
	If xKeyHit(xKEY_1) xSetEffectTechnique tModel, "Directional"
	If xKeyHit(xKEY_2) xSetEffectTechnique tModel, "Point"
	If xKeyHit(xKEY_3) xSetEffectTechnique tModel, "PointDistance"
	
	xPositionEntity tLightSpr, Sin(MilliSecs() * 0.05) * 40, Abs(Sin(MilliSecs() * 0.06) * 40), Sin(MilliSecs() * 0.04) * 40
	If Int(Rnd(0, 2)) = 1 xSetEffectVector tModel, "TexProjRnd", Rnd(0, 1.0), Rnd(0, 1.0), 0
	'====================================
	
	If xKeyHit(xKEY_ESCAPE) End
	
	xSetEffectVector tModel,	"PosLight", xEntityX(tLightSpr), xEntityY(tLightSpr), xEntityZ(tLightSpr)
	xSetEffectVector tModel,	"PosCam", xEntityX(gCamera), xEntityY(gCamera), xEntityZ(gCamera)
	
	xRenderWorld
	
	xColor 0, 0, 0
	xText 10, 10,  "TrisRendered: " + xTrisRendered()
	xText 10, 25,  "FPS: " + xGetFPS()
	xText 10, 580, "Press 1,2,3 to Change Light Type (Directional, Point, Point+Distance)"
	
	xFlip
Forever
'====================================



'====================================
' Functions
Function UpdateInput()
	xMoveMouse 400, 300
	mXSp = xMouseXSpeed()
	mYSp = xMouseYSpeed()
	IKdQ = xKeyDown(xKEY_Q)
	IKdW = xKeyDown(xKEY_W)
	IKdE = xKeyDown(xKEY_E)
	IKdA = xKeyDown(xKEY_A)
	IKdS = xKeyDown(xKEY_S)
	IKdD = xKeyDown(xKEY_D)
End Function

Function UpdateCamera(Camera%, ViewSensivity#, MoveSensivity#)
	Local CamP# = xEntityPitch(gCamera) + mYSp * ViewSensivity
	If Abs(CamP) > 80 CamP = 80 * Sgn(CamP)
	xTurnEntity Camera, 0, -mXSp * ViewSensivity, 0
	xRotateEntity Camera, CamP, xEntityYaw(gCamera), 0
	
	xMoveEntity Camera, (IKdD - IKdA) * MoveSensivity, (IKdE - IKdQ) * MoveSensivity, (IKdW - IKdS) * MoveSensivity
End Function
'====================================