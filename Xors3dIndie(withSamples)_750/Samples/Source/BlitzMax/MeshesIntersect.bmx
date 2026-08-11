'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Meshes intersect sample, (c) 2010 Xors3D Team    *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application window caption
xAppTitle "Mesh intersect sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True

' create camera
cam = xCreateCamera()
xPositionEntity(cam, 0, 2, -20)

' create light
lig = xCreateLight(1)
xRotateEntity(lig, -20, 0, 0)

' create cone
cone=xCreateCone()

' create cube
cube=xCreateCube()
xPositionEntity(cube, -3, 0, 0)
xRotateEntity(cube, 0, 0, 0)


' main program loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	' if meshes inersection return 1
	test = xMeshesIntersect%(cube, cone)
	If test = 1
		xEntityColor (cone, 0, 200,0)
	Else
		xEntityColor (cone, 255, 255,255)
	EndIf

	' Move cube
	If xKeyDown(xKEY_W) Then xMoveEntity cube,  0.0,  0.1, 0.0
	If xKeyDown(xKEY_S) Then xMoveEntity cube,  0.0, -0.1, 0.0
	If xKeyDown(xKEY_A) Then xMoveEntity cube, -0.1,  0.0, 0.0
	If xKeyDown(xKEY_D) Then xMoveEntity cube,  0.1,  0.0, 0.0

	' render scene
	xRenderWorld

	' draw text
	xText 10, 50, "W/A/S/D - Move Cube"
	xText 10, 30, "FPS: " + xGetFPS()

	' switch back buffer
	xFlip
Wend