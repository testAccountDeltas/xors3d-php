'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Simple sample, (c) 2009 Xors3D Team              *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application window caption
xAppTitle "Simple sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True

' hide mouse pointer
xHidePointer()

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()

' position camera
xPositionEntity camera, 0, 0, -10

' create cube
cube = xCreateCube()

' loading logo from file
logoTexture = xLoadTexture("..\..\media\textures\logo.jpg")

' texture cube
xEntityTexture cube, logoTexture

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main program loop
While Not xKeyDown(xKEY_ESCAPE)

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity camera,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity camera, camya, camxa, 0.0
	
	' tunr cube
	xTurnEntity cube, 0, 1, 0
	
	' render scene
	xRenderWorld()
	
	' switch back buffer
	xFlip()
	
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function