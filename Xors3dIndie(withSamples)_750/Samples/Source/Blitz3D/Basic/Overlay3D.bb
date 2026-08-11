Include "..\xors3d.bb"

xGraphics3d(1024, 768, 32, 0, 1)

xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
Global mousespeed#       = 0.5
Global camerasmoothness# = 4.5
Global camxa# = 0
Global camya# = 0

Global camera = xCreateCamera()
xCameraClsColor(camera, 64, 64, 64)
Local light = xCreateLight()

Global cube = xCreateCube(camera)
xRotateEntity(cube, 30.0, 15.0, 0.0)
xScaleEntity(cube, 0.25, 0.25, 0.25)
xPositionEntity(cube, -2.0, 1.35, 5.0)
xEntityColor(cube, 255, 128, 0)

Garbage()

Global drawOverlay = 1

While Not xKeyHit(KEY_ESCAPE)
	
	If xKeyHit(57)
		drawOverlay = 1 - drawOverlay
	EndIf
	
	xTurnEntity(cube, 0.1, -0.1, 0.1)
	CameraControl()
	
	xRenderWorld()
	
	xColor(128, 0, 255)
	xRect(35, 35, 210, 210, 1)
	
	If drawOverlay
		xCameraClsMode(camera, False, True)
		xShowEntity(cube)
		xRenderEntity(camera, cube)
		xCameraClsMode(camera, True, True)
		xHideEntity(cube)
	EndIf
	
	xColor(255, 255, 255)
	
	xText(10, xGraphicsHeight() - 60, "WASD to move camera")
	xText(10, xGraphicsHeight() - 40, "Mouse to rotate camera")
	xText(950, 740, xTrisRendered())
	
	xFlip()
Wend

End

Function Garbage(num% = 40)
	Local i%
	
	For i = 1 To num
		Local r% = Rand(128, 255)
		Local g% = Rand(128, 255)
		Local b% = 383 - r
		Local obj = xCreateCube()
		xPositionEntity(obj, Rnd(-25.0, 25.0), Rnd(-25.0, 25.0), Rnd(25.0, 45.0))
		xEntityColor(obj, r, g, b)
		xScaleEntity(obj, Rnd(0.75, 1.5), Rnd(0.75, 1.5), Rnd(0.75, 1.5))
	Next
End Function

Function CameraControl()
	If xKeyDown(KEY_W) Then xMoveEntity camera,  0,  0,  1.0
	If xKeyDown(KEY_S) Then xMoveEntity camera,  0,  0, -1.0
	If xKeyDown(KEY_A) Then xMoveEntity camera, -1.0,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity camera,  1.0,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
End Function

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D