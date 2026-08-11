;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Pick sample, (c) 2009 Xors3D Team                *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

; initialize graphics mode
xGraphics3D 800, 600, 32, False, True
xSetBuffer xBackBuffer() 

; create camera
camera=xCreateCamera() 
xPositionEntity camera, 0, 2, -10

; create light
light = xCreateLight() 
xRotateEntity light, 45, 45, 45

; create cube
cube = xCreateCube() 
xEntityPickMode cube, 2 ; Make the cube entity 'pickable'. Use pick_geometry mode no.2 for polygon collision. 
xPositionEntity cube, 0, 0, 0 
xRotateEntity cube, 0, 45, 0

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

; main loop
While Not xKeyhit( 1 ) 

; camera control
	If xKeyDown(KEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity camera,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity camera, camya, camxa, 0.0
	
	; If left mouse button is hitted then use CameraPick with mouse coordinates 
	; only three things can be picked in this example: the plane, the cube or nothing 
	If xMouseHit(1) Then xCameraPick(camera, xMouseX(), xMouseY()) 
	
	; render scene
	xRenderWorld
	
	; draw picking info
	xText 0, 20, "Use cursor keys to move" 
	xText 0, 40, "Press left mouse button to use CameraPick with mouse coordinates" 
	xText 0, 60, "PickedX: " + xPickedX#() 
	xText 0, 80, "PickedY: " + xPickedY#() 
	xText 0, 100, "PickedZ: " + xPickedZ#() 
	xText 0, 120, "PickedNX: " + xPickedNX#() 
	xText 0, 140, "PickedNY: " + xPickedNY#() 
	xText 0, 160, "PickedNZ: " + xPickedNZ#() 
	xText 0, 180, "PickedTime: " + xPickedTime() 
	xText 0, 200, "PickedEntity: " + xPickedEntity() 
	xText 0, 220, "PickedSurface: " + xPickedSurface() 
	xText 0, 240, "PickedTriangle: " + xPickedTriangle()
	xText 0, 280, "xMouseX(): " + xMouseX()
	xText 0, 300, "xMouseY(): " + xMouseY()
	
	; draw scene
	xFlip 
Wend 

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function