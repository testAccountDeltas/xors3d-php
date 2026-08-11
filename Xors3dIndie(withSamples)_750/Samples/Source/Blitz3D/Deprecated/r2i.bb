;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Render to image sample, (c) 2009 Xors3D Team     *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

;initialization
xAppTitle "Render to image"
xGraphics3D 800, 600, 32, False, True

;creating the camera
cam = xCreateCamera()
xPositionEntity cam, 15, 10, -100

;font loading
arial = xLoadFont("Arial", 12)

;light source creating
light1 = xCreateLight(LIGHT_DIRECTION)
xRotateEntity light1, -45, 0, 0

;creating the cube
cube = xCreateCube()
xScaleEntity cube, 10, 10, 10

;creating the image
img = xCreateImage(256, 256)

;creating the sphere and hiding it
sph = xCreateSphere()
xScaleEntity sph, 10, 10, 10
xEntityShininess sph, 1
xEntityColor sph, 255, 0, 0
xHideEntity sph

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

;main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	;setting the image buffer as the render target
	xSetBuffer xImageBuffer(img)
	
	;hiding the cube and unhiding the sphere
	xShowEntity sph
	xHideEntity cube
	
	;buffer clearing
	xCameraClsColor cam, 192, 192, 192
	xCls
	
	;rendering the world
	xRenderWorld
	
	;hiding the sphere and unhiding the cube
	xHideEntity sph
	xShowEntity cube
	
	;setting the backbuffer as a render target
	xSetBuffer xBackBuffer()
	xCameraClsColor cam, 0, 0, 0
	
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
	
	;updating and rendering the world
	xUpdateWorld
	xRenderWorld
	
	;drawing the image
	xDrawImage img, 0, 0
	
	;fps and triangle counter
	xText 650, 30, "FPS: " + xGetFPS()
	xText 650, 50, "Polygons: " + xTrisRendered()
	
	;drawing
	xFlip
	
Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function