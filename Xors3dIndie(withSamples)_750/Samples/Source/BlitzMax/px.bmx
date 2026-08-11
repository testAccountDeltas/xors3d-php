'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Physics sample, (c) 2010 Xors3D Team             *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

Const impulse# = 50

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application window caption
xAppTitle "Physics sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, False
SeedRnd MilliSecs()

' hide mouse pointer
xHidePointer()

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()

' position camera
xPositionEntity camera, 0, 20, -100

' create ground
ground = xCreateCube()
xPointEntity camera, ground
xScaleEntity ground, 100, 1, 100
xEntityAddBoxShape(ground, 0.0)

' loading logo from file
logoTexture = xLoadTexture("..\..\media\textures\logo.jpg")

' texture cube
xEntityTexture ground, logoTexture

' create wall
Const wallSize = 5
Global wallBlocks[wallSize + 1, wallSize + 1, wallSize + 1]
For x = 0 To wallSize
	For y = 0 To wallSize
		For z = 0 To wallSize
			wallBlocks[x, y, z] = xCreateCube()
			xPositionEntity(wallBlocks[x, y, z], (x - wallSize / 2) * 2.0, 2 + y * 2.0, (z - wallSize / 2) * 2.0)
			xEntityAddBoxShape(wallBlocks[x, y, z], 1.0)
			xEntityTexture(wallBlocks[x, y, z], logoTexture)
		Next
	Next
Next

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' create light
light = xCreateLight()
xRotateEntity light, 45, 0, 0

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
	
	' shoot sphere
	If xMouseHit(1) Then ShootSphere(camera%)
	If xMouseHit(2) Then xEntityApplyTorqueImpulse(wallBlocks[Rnd(0, wallSize), Rnd(0, wallSize), Rnd(0, wallSize)], 0.0, Rnd(0.0, 100.0), 0.0)
	
	' reset wall
	If xKeyHit(xKEY_SPACE) Then ResetWall()
	
	' render scene
	xUpdateWorld()
	xRenderWorld()
	
	' FPS & rendered triangles counters
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	xText 10, 50, "Left mouse button to shoot, right mouse button to add torque for random cube, space to reset wall"
	
	' switch back buffer
	xFlip()
	
Wend

' function to reset cubes positions
Function ResetWall()
	For x = 0 To wallSize
		For y = 0 To wallSize
			For z = 0 To wallSize
				xPositionEntity(wallBlocks[x, y, z], (x - wallSize / 2) * 2.0, 2 + y * 2.0, (z - wallSize / 2) * 2.0)
				xRotateEntity(wallBlocks[x, y, z], 0.0, 0.0, 0.0)
				xEntityReleaseForces(wallBlocks[x, y, z])
			Next
		Next
	Next
End Function

' function to shoot sphere
Function ShootSphere(camera%)
	sphere = xCreateSphere()
	xPositionEntity(sphere, xEntityX(camera, True), xEntityY(camera, True), xEntityZ(camera, True))
	xEntityColor(sphere, 255, 0, 0)
	xEntityAddSphereShape(sphere, 1.0, 1.0)
	xTFormNormal 0.0, 0.0, 1.0, camera, 0
	xEntityApplyCentralImpulse(sphere, xTFormedX() * impulse, xTFormedY() * impulse, xTFormedZ() * impulse)
End Function

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

end