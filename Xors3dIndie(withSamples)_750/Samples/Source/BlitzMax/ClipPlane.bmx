'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Clipplane sample, (c) 2010 Xors3D Team           *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialization
xAppTitle "Clipplane"
xGraphics3D 800, 600, 32, False, True

' enabling antialiasing
xAntiAlias True

' setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPIC

' creating the camera
cam = xCreateCamera()
xPositionEntity cam, 0, 20, 30
xRotateEntity cam,0,180,0
xCameraClsColor cam, 92, 192, 255
xCameraRange cam, 0.1, 1000

' font loading
arial = xLoadFont("Arial", 12)

' light source creating
light1 = xCreateLight(LIGHT_DIRECTION)
xRotateEntity light1, -45, 0, 0

' skyBox = LoadSkyBox("sky")

level = xLoadMesh("../../media/Meshes/level.b3d")

' setting the clipplane
xCameraClipPlane cam, 0, True, 0, 1, 0, 0
pivot = xCreatePivot()

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	' turn clipplane
	xTurnEntity pivot, 0, 0, 0.1
	xTFormPoint 0, 1, 0, pivot, 0
	xCameraClipPlane cam, 0, True, xTFormedX(), xTFormedY(), xTFormedZ(), 30
	 
	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	 
	' updating and rendering the world
	xUpdateWorld
	xRenderWorld
	 
	' fps and triangle counters
	xColor 255, 0, 0
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Polygons: " + xTrisRendered()
	 
	' drawing the scene
	xFlip
 
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function