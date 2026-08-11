Rem
	mSL (mini Shader Library)
	
		Burn
	
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
xRotateEntity gCamera, 20, 0, 0
xMoveEntity gCamera, 0, 10, -100
'====================================


'====================================
' LightSphere
Local tLightSpr% = xCreateSphere(8)
xEntityFX tLightSpr, 1
'====================================


'====================================
' Shader
Local tShader% = xLoadFXFile("..\..\Materials\Burn.fx")
'====================================


'====================================
' Model
Local tModel% = xLoadMesh("..\Media\Teapot.b3d")

Local tTextureDiffuse% = xLoadTexture("..\Media\Rockwall_Diffuse.jpg")
Local tTextureHeight%  = xLoadTexture("..\Media\Rockwall_Height.png")
Local tTextureFire%    = xLoadTexture("..\Media\Fire.png")

xSetEntityEffect tModel, tShader
xSetEffectTechnique tModel, "Normal"
xSetEffectMatrixSemantic tModel, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic tModel, "MatWorld", WORLD
'		Shader Varriables
xSetEffectFloat tModel,		"SourceRng", 10
xSetEffectFloat tModel,		"BurnHeightInt", 1
xSetEffectVector tModel,		"BurnOClr", 0.9, 0.5, 0
xSetEffectVector tModel,		"BurnBClr", 0.2, 0.2, 0.2
xSetEffectFloat tModel,		"BurnOWidth", 0.2
xSetEffectFloat tModel,		"BurnBWidth", 0.08
xSetEffectFloat tModel,		"BurnRWidth", 0.05
xSetEffectTexture tModel,	"tDiffuse", tTextureDiffuse
xSetEffectTexture tModel,	"tHeight", tTextureHeight
xSetEffectTexture tModel,	"tFire", tTextureFire

Local BurnHeight#, tPointLight%
'====================================



'====================================
' Main Cycle
xMoveMouse 400, 300
Repeat
	UpdateInput
	UpdateCamera gCamera, 0.1, 1
	
	'====================================
	If xKeyHit(xKEY_1)
		BurnHeight  = 0.0
		tPointLight = False
		xSetEffectTechnique tModel, "Normal"
	EndIf
	If xKeyHit(xKEY_2)
		BurnHeight  = 0.0
		tPointLight = True
		xSetEffectTechnique tModel, "PointDistance"
	EndIf
	
	If xKeyHit(xKEY_SPACE)
		xPositionEntity tLightSpr, Rnd(-30.0, 30.0), Rnd(-30.0, 30.0), Rnd(-30.0, 30.0)
		xSetEffectVector tModel, "SourcePos", xEntityX(tLightSpr), xEntityY(tLightSpr), xEntityZ(tLightSpr)
		BurnHeight = 0.0
	EndIf
	
	BurnHeight = BurnHeight + 0.005
	If BurnHeight > 1.0 BurnHeight = 0.0
	
	If tPointLight xSetEffectFloat tModel, "SourceRng", BurnHeight * 250
	xSetEffectFloat tModel, "BurnHeight", BurnHeight
	'====================================
	
	If xKeyHit(xKEY_ESCAPE) End
	
	xRenderWorld
	
	xText 10, 10,  "TrisRendered: " + xTrisRendered()
	xText 10, 25,  "FPS: " + xGetFPS()
	xText 10, 565, "Press 'Space' to Change Point Position"
	xText 10, 580, "Press 1,2 to Change Burn Mode"
	
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