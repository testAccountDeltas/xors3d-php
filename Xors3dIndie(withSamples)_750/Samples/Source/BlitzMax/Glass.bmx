'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Glass sample, (c) 2010 Xors3D Team               *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' set graphics mode
xGraphics3D 800, 600, 32, False, True

' create pivot
piv = xCreatePivot()

' create camera
cam = xCreateCamera(piv)
xCameraRange cam, 0.9, 3000
xPositionEntity cam, 0, 0, -120
xRotateEntity cam, 0, 0, 0

' create scene
teapot = xLoadMesh("../../media/meshes/teapot.b3d")
xPositionEntity teapot, 30, -15, 0

sphere = xCreateSphere(30)
xPositionEntity sphere, -30, 0, 0
xScaleEntity sphere, 20, 20, 20

' load cube texture
cubeTex = xLoadTexture("../../media/textures/Snow.dds", 128)

' create posteffect poly
poly = xCreatePostEffectPoly(cam, 1)

' create textures
lowresTex = xCreateTexture(256, 256)
tempTex   = xCreateTexture(256, 256)
BBtex     = xCreateTexture(800, 600) 

' load glass shader
glassFX = xLoadFXFile("../../media/shaders/Glass.fx")

' create sky
sky = xCreateSphere()
xFlipMesh(sky)
xScaleEntity sky, 500, 500, 500
xSetEntityEffect sky, glassFX
xSetEffectTechnique sky, "Sky"
xSetEffectMatrixSemantic sky, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic sky, "MatWorld", WORLD
xSetEffectTexture sky, "tDiffuse", cubeTex

' setup glass shader
xSetEntityEffect teapot, glassFX
xSetEffectTechnique teapot, "Diffuse"
xSetEffectMatrixSemantic teapot, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic teapot, "MatWorld", WORLD
xSetEffectTexture teapot, "tDiffuse", cubeTex

xSetEntityEffect sphere, glassFX
xSetEffectTechnique sphere, "Diffuse"
xSetEffectMatrixSemantic sphere, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic sphere, "MatWorld", WORLD
xSetEffectTexture sphere, "tDiffuse", cubeTex

' params
enable      = 1
r#          = 0
g#          = 0
b#          = 0.2
FallOffPow# = 3

' main loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	' camera controll
	If xKeyDown(xKEY_UP)    Then xTurnEntity Piv,  1.0,  0.0, 0.0, True
	If xKeyDown(xKEY_DOWN)  Then xTurnEntity Piv, -1.0,  0.0, 0.0, True
	If xKeyDown(xKEY_LEFT)  Then xTurnEntity Piv,  0.0,  1.0, 0.0, True
	If xKeyDown(xKEY_RIGHT) Then xTurnEntity Piv,  0.0, -1.0, 0.0, True

	' glass color controll
	cl# = 0.01
	If xKeyDown(xKEY_Q) Then r = r + cl
	If xKeyDown(xKEY_A) Then r = r - cl
	If xKeyDown(xKEY_W) Then g = g + cl
	If xKeyDown(xKEY_S) Then g = g - cl
	If xKeyDown(xKEY_E) Then b = b + cl
	If xKeyDown(xKEY_D) Then b = b - cl
	If (r > 1.0) Then r = 1.0
	If (r < 0.0) Then r = 0.0
	If (g > 1.0) Then g = 1.0
	If (g < 0.0) Then g = 0.0
	If (b > 1.0) Then b = 1.0
	If (b < 0.0) Then b = 0.0
	
	' falloff controll
	cl# = 0.03
	If xKeyDown(xKEY_R) Then FallOffPow = FallOffPow + cl
	If xKeyDown(xKEY_F) Then FallOffPow = FallOffPow - cl
	
	' update shader params
	xSetEffectVector teapot,	"view_position", xEntityX(cam, True), xEntityY(cam, True), xEntityZ(cam, True)
	xSetEffectVector teapot,	"FallOffCol", r, g, b, 1.0
	xSetEffectFloat teapot,	"FallOffPow", FallOffPow
	
	' turn teapot
	xTurnEntity teapot, 0, 1, 0
	
	' render world
	xRenderWorld()
	
	' draw texts
	xText 10, 30, "FPS: " + xGetFPS()
	xText 10, 60, "r (Q\A)  " + r + " g (W\S)  " + g + " b (E\D)  " + b
	xText 10, 80, "FallOffPow (R\F)  " + FallOffPow
	xText 10, 100, "Control: arrows  "
	
	' draw scene
	xFlip
Wend