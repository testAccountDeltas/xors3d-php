'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Bloom sample, (c) 2010 Xors3D Team               *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' set graphics mode
xGraphics3D 800, 600, 32, False, True

' create camera
cam = xCreateCamera()
xCameraRange cam, 0.9, 3000
xPositionEntity cam, 10, 0, -20
xRotateEntity cam, -10, 20, 0

' create scene
cu = xLoadMesh("../../media/meshes/teapot.b3d")
xPositionEntity cu, 0, 0, 5
xScaleMesh cu, 0.3, 0.3, 0.3
t1 = xLoadTexture("../../media/textures/tex_bloom.jpg")
xEntityTexture cu, t1

' create light
l = xCreateLight()

' create posteffect poly
poly = xCreatePostEffectPoly(cam, 1)

' create posteffect textures
tex  = xCreateTexture(256, 256)
tex2 = xCreateTexture(800, 600) 

' load posteffect shader
shader = xLoadFXFile("../../media/shaders/Bloom.fx")

xSetEntityEffect poly, shader
xSetEffectTechnique poly, "Diffuse"
xSetEffectMatrixSemantic poly, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectTexture poly, "tDiffuse", tex
xSetEffectTexture poly, "tEmissive", tex2

' create skybox
sky = CreateSkyBox%("../../media/textures/skybox/")
xScaleEntity sky, 1000, 500, 1000
xPositionEntity sky, 0, 200, 0

' create cube
cu1 = xCreateCube()
xPositionEntity cu1, 0, 0, 30
xScaleEntity cu1, 5, 5, 5

' params
enable = 1

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity cam,  0,  0,  5
	If xKeyDown(xKEY_S) Then xMoveEntity cam,  0,  0, -5
	If xKeyDown(xKEY_A) Then xMoveEntity cam, -5,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity cam,  5,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	' turn teapot
	xTurnEntity cu,0,1,0

	' switch bloom
	If xKeyHit(xKEY_SPACE) enable = 1 - enable
	
	' render scene
	xRenderWorld()
	
	' bloom
	If enable = 1
		xStretchBackBuffer(tex, 0, 0, 256, 256, 0)
		xStretchBackBuffer(tex2, 0, 0, 800, 600, 0)
		xSetEffectTechnique(poly, "Diffuse")
		xRenderPostEffect(poly)
		xStretchBackBuffer(tex, 0, 0, 256, 256, 0)
		xSetEffectTechnique(poly, "DiffuseH")
		xRenderPostEffect(poly)
		xStretchBackBuffer(tex, 0, 0, 256, 256, 0)
		xSetEffectTechnique(poly, "DiffuseV")
		xRenderPostEffect(poly)
	EndIf

	' draw texts
	xText 40, 30, "FPS: " + xGetFPS()
	xText 40, 50, "Space - enable\disable bloom"
	
	' draw scene
	xFlip
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

' Function for sky box creating
Function CreateSkyBox%(skyPath$)
	skybox = xCreateMesh()
	' Left
	texture = xLoadTexture(skyPath + "left.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0,  1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0,  1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Front
	texture = xLoadTexture(skyPath + "front.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, 1.0, 0.0, 0.0)
	v1 = xAddVertex(surface,  1.0,  1.0, 1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, 1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, -1.0, 1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Right
	texture = xLoadTexture(skyPath + "right.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, 1.0,  1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, 1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, 1.0, -1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, 1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Back
	texture = xLoadTexture(skyPath + "back.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface,  1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Top
	texture = xLoadTexture(skyPath + "top.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0, 1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0, 1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, 1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, 1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' set FX flags
	xEntityFX skybox, 1
	xFlipMesh skybox
	xUpdateNormals skybox
	' return skybox handle
	Return skybox
End Function