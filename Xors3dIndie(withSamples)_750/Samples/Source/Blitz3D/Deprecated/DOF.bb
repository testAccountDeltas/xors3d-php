;*******************************************************************
;*                                                                 *
;* Xors3D Engine. DOF sample, (c) 2009 Xors3D Team                 *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; include header
Include "..\xors3d.bb"

; set graphics mode
xGraphics3D 800, 600, 32, False, True

; create camera
cam = xCreateCamera()
xCameraRange cam, 0.9, 3000
xPositionEntity cam, 30, 100, -480
xRotateEntity cam, 10, 0, 0

; create scene
teapot = xLoadMesh("../../../media/meshes/teapot.b3d")
xPositionEntity teapot, 0, 0, 5
xScaleEntity teapot, 2, 2, 2
t1 = xLoadTexture("../../../media/textures/tex_bloom.jpg")
xEntityTexture teapot, t1

; create light
l = xCreateLight()

; create posteffect quad
poly = xCreatePostEffectPoly(cam, 1)
; low resolution texture
lowresTex = xCreateTexture(256, 256)
tempTex   = xCreateTexture(256, 256)
; screen texture
BBtex = xCreateTexture(800, 600) 

; load DOF shader
DOF_shader = xLoadFXFile("../../../media/shaders/DOF.fx")

; setup shader
xSetEntityEffect teapot, DOF_shader
xSetEffectTechnique teapot, "Diffuse"
xSetEffectMatrixSemantic teapot, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic teapot, "MatView", WORLDVIEWPROJ
xSetEffectTexture teapot, "tDiffuse", t1

; copy teapots
teapot1 = xCopyEntity(teapot)
xPositionEntity teapot1, 0, 0, 300
xScaleEntity teapot1, 2, 2, 2
teapot2 = xCopyEntity(teapot)
xPositionEntity teapot2, 0, 0, -300
xScaleEntity teapot2, 2, 2, 2

; setup post effect poly shader
xSetEntityEffect poly, DOF_shader
xSetEffectTechnique poly, "DownPass"
xSetEffectMatrixSemantic poly, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic poly, "MatView", WORLDVIEWPROJ
xSetEffectTexture poly, "tDiffuse", t1
xSetEffectTexture poly, "tEmissive", lowresTex
xSetEffectTexture teapot, "tBB", BBtex

; sky
sky = CreateSkyBox%("../../../media/textures/skybox1/")
xScaleEntity sky, 1000, 500, 1000
xPositionEntity sky, 0, 200, 0
xSetEntityEffect sky, DOF_shader
xSetEffectTechnique sky, "Diffuse"
xSetEffectMatrixSemantic sky, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectMatrixSemantic sky, "MatView", WORLDVIEWPROJ

; params
enable = 1

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5
;xwireframe 1
; main loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity cam,  0,  0,  5
	If xKeyDown(KEY_S) Then xMoveEntity cam,  0,  0, -5
	If xKeyDown(KEY_A) Then xMoveEntity cam, -5,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity cam,  5,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	; turn teapot
	xTurnEntity teapot,0,1,0
	
	; switch DOF
	If xKeyHit (KEY_SPACE) enable = 1 - enable

	;render to screen texture
	xSetBuffer( xTextureBuffer (BBtex))
	xRenderWorld()
	xSetBuffer( xBackBuffer ())

	;copy screen texture in low resolution
	xStretchRect(BBtex, 0, 0, 800, 600, lowresTex, 0, 0, 256, 256, 0)                                                 

	; DOF
	If enable = 1
		;Down sampler
		xSetEffectTechnique(poly, "DownPass")
		xRenderPostEffect(poly)
		xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0)
		;Gausian blur 1
		xSetEffectTechnique(poly, "Gaus1")
		xRenderPostEffect(poly)
		xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0)
		;Gausian blur 2
		xSetEffectTechnique(poly, "Gaus2")
		xRenderPostEffect(poly)
		xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0)
		;DOF 1
		xSetEffectTechnique(poly, "DOF1")
		xRenderPostEffect(poly)	
	Else
		xRenderWorld()
	EndIf
	
	; draw texts
	xText 10, 30, "FPS: " + xGetFPS()
	xText 10, 50, "Spase - enable\disable DOF "
	
	; draw scene
	xFlip
Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

; Function for sky box creating
Function CreateSkyBox%(skyPath$)
	skybox = xCreateMesh()
	; Left
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
	; Front
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
	; Right
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
	; Back
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
	; Top
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
	; set FX flags
	xEntityFX skybox, 1
	xFlipMesh skybox
	xUpdateNormals skybox
	; return skybox handle
	Return skybox
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D