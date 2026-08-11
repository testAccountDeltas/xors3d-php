;*******************************************************************
;*                                                           			 *
;* Xors3D Engine. Stretch Back buffer sample, (c) 2009 Xors3D Team *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                         				 *
;*******************************************************************
Include "..\xors3d.bb"

;initialization
xAppTitle "Stretch Back buffer"
xGraphics3D 800, 600, 32, False, True 

; create light
lit = xCreateLight()
xRotateEntity lit, -40,40,40

; set texture filtering 
xSetTextureFiltering TF_ANISOTROPIC

; create camera
cam = xCreateCamera()
xCameraClsColor cam, 192, 192, 192
xPositionEntity cam, 0, 10, -80


; loading textures
load_tex   = xLoadTexture("..\..\..\media\textures\bricks.jpg")
;create texture to copying back buffer
BB_tex = xCreateTexture(800,600)

; create cubes
cube1 = xCreateCube()
xScaleEntity cube1, 10, 10, 10
xPositionEntity cube1, 20, 0, 0
xEntityTexture cube1, BB_tex
cube2 = xCreateCube()
xScaleEntity cube2, 10, 10, 10
xPositionEntity cube2, -20, 0, 0
xEntityTexture cube2, load_tex
cu3 =  xCreateCube()
xScaleEntity cu3, 10, 10, 10
xPositionEntity cu3, 0, 30, 0
xEntityTexture cu3, load_tex

; loading font
arial = xLoadFont("Arial", 12)

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

;main loop
While Not xKeyDown(1)

	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	;turn cube
	xTurnEntity cube1, 0, -1, 0

	; render scene
	xCameraClsColor cam, 0, 0, 0
	xRenderWorld
	
	; copy BB to texture "BB_tex"
	xStretchBackBuffer(BB_tex, 0, 0, 800, 600, 0)
	xCameraClsColor cam, 192, 192, 192
	
	;render and update world
	xUpdateWorld
	xRenderWorld

	;draw text
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Polygons: " + xTrisRendered()

	; draw scene
	xFlip
Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function