Rem
	mSL (mini Shader Library)
	
		Bump Light
	
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
xCameraClsColor gCamera, 50, 50, 50
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
Local tShader% = xLoadFXFile("..\..\Materials\Bump Light.fx")
'====================================


'====================================
' Model
Local tModel% = xLoadMesh("..\Media\Teapot.b3d")

Local tTextureDiffuse% = xLoadTexture("..\Media\Rockwall_Diffuse.jpg")
Local tTextureNormal% = xLoadTexture("..\Media\Rockwall_Normal.png")

xSetEntityEffect tModel, tShader
xSetEffectTechnique tModel, "Directional"
xSetEffectMatrixSemantic tModel, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel, "MatWorld", WORLD
'		Shader Varriables
xSetEffectVector tModel,		"AmbientClr", 0.25, 0.3, 0.35
xSetEffectVector tModel,		"LightClr", 1, 0.8, 0.6
xSetEffectFloat tModel,		"LightInt", 2
xSetEffectFloat tModel,		"RngLight", 40
xSetEffectTexture tModel,	"tDiffuse", tTextureDiffuse
xSetEffectTexture tModel,	"tNormal", tTextureNormal
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
	
	xPositionEntity tLightSpr, Sin(MilliSecs() * 0.05) * 30, Abs(Sin(MilliSecs() * 0.06) * 25) + 5, Sin(MilliSecs() * 0.04) * 30
	'====================================
	
	If xKeyHit(xKEY_ESCAPE) End
	
	xSetEffectVector tModel, "PosLight", xEntityX(tLightSpr), xEntityY(tLightSpr), xEntityZ(tLightSpr)
	xSetEffectFloat tModel,  "DotLight", Sin(MilliSecs() * 0.4) * 0.5 + 1.2
	
	xRenderWorld
	
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