'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Editor sample, (c) 2010 Xors3D Team              *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application's title
xAppTitle "Editor sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()
xCameraClsColor camera, 192, 192, 192
xPositionEntity camera, 10, 10, 10

' create light
light = xCreateLight()

' create cube
cube = xCreateCube()
xPointEntity camera, cube

' loading logo from file
logoTexture = xLoadTexture("..\..\media\textures\logo.jpg")

' texture cube
xEntityTexture cube, logoTexture

' gizmos' data
controlType   = 0 ' 0 - move, 1 - rotate, 2 - scale 
selectMask    = 0
deltaX#       = 1.0
deltaY#       = 1.0
deltaZ#       = 1.0
scaleXInit#   = 1.0
scaleYInit#   = 1.0
scaleZInit#   = 1.0
Global controllPosX# = 0.0
Global controllPosY# = 0.0
Global controllPosZ# = 0.0
Global mouseSpeedX   = 0
Global mouseSpeedY   = 0
Global used_controller$ = ""

' main program loop
While Not xKeyDown(xKEY_ESCAPE)
	xColor 100, 0, 0
	mouseSpeedX = xMouseXSpeed()
	mouseSpeedY = xMouseYSpeed()
	
	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity camera,  1,  0,  0
	If xKeyHit(xKEY_1)  Then controlType = 0
	If xKeyHit(xKEY_2)  Then controlType = 1
	If xKeyHit(xKEY_3)  Then controlType = 2

	' render scene
	xRenderWorld()
	
	' draw grid
	xDrawGrid(0, 0, 5, 100);
	
	' draw gizmos
	x# = xEntityX(cube)
	y# = xEntityY(cube)
	z# = xEntityZ(cube)
	Select controlType
	Case 0
		mask = xCheckMovementGizmo(x#, y#, z#, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1)
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
		EndIf
		xDrawMovementGizmo(x#, y#, z#, selectMask)
		used_controller$ = "Used move controler"
	Case 1
		mask = xCheckRotationGizmo(x#, y#, z#, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1) 
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
			deltaX#      = 0.0
			deltaY#      = 0.0
			deltaZ#      = 0.0
		EndIf
		xDrawRotationGizmo(x#, y#, z#, selectMask, deltaX, deltaY, deltaZ)
		used_controller$ = "Used rotate controler"
	Case 2
		mask = xCheckScaleGizmo(x#, y#, z#, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1) 
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
			deltaX       = 1.0
			deltaY       = 1.0
			deltaZ       = 1.0
			scaleXInit   = xEntityScaleX(cube)
			scaleYInit   = xEntityScaleY(cube)
			scaleZInit   = xEntityScaleZ(cube)
		EndIf
		xDrawScaleGizmo(x#, y#, z#, selectMask, deltaX, deltaY, deltaZ)
		used_controller$ = "Used scale controler"
	Default
		used_controller$ = ""
	End Select

	' object control
	If xMouseDown(1) And selectMask <> 0
		useX     = selectMask & 1
		useY     = selectMask & 2
		useZ     = selectMask & 4
		useG     = selectMask & 8
		factorX# = 0.7 / Float(xGraphicsWidth())
		factorY# = 0.7 / Float(xGraphicsHeight())
		Select controlType
		' if movement gizmo is used
		Case 0
			' move controlled entity
			dx#   = controllPosX - xEntityX(camera, true)
			dy#   = controllPosY - xEntityY(camera, true)
			dz#   = controllPosZ - xEntityZ(camera, true)
			dist# = Sqr(dx * dx + dy * dy + dz * dz)
			' x-axis
			if useX
				move# = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				xTranslateEntity cube, move, 0.0, 0.0, false
			EndIf
			' y-axis
			if useY
				move# = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				xTranslateEntity cube, 0.0, move, 0.0, false
			EndIf
			' z-axis
			if useZ
				move# = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				xTranslateEntity cube, 0.0, 0.0, move, false
			EndIf
		' if scaling gizmo is used
		Case 2
			' scale controlled entity
			dx#   = controllPosX - xEntityX(camera, true)
			dy#   = controllPosY - xEntityY(camera, true)
			dz#   = controllPosZ - xEntityZ(camera, true)
			dist# = Sqr(dx * dx + dy * dy + dz * dz)
			' x-axis
			If useX
				move#      = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				deltaX     = deltaX     + move
				scaleXInit = scaleXInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
			' y-axis
			if useY
				move#      = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				deltaY     = deltaY     + move
				scaleYInit = scaleYInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
			' z-axis
			if useZ
				move#      = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				deltaZ     = deltaZ     + move
				scaleZInit = scaleZInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
		' if rotation gizmo is used
		Case 1
			' rotate controlled entity
			' x-axis
			if useX
				move#  = ComputeMove(camera, 0.0, -10.0, 0.0)
				deltaX = deltaX + move
				xTurnEntity cube, move, 0.0, 0.0, true
			EndIf
			' y-axis
			if useY
				move#  = ComputeMove(camera, -10.0, -10.0, 0.0);
				deltaY = deltaY + move
				xTurnEntity cube, 0.0, move, 0.0, true
			EndIf
			' z-axis
			if useZ
				move#  = ComputeMove(camera, -10.0, 0.0, 0.0);
				deltaZ = deltaZ + move
				xTurnEntity cube, 0.0, 0.0, move, true
			EndIf
		End Select
	EndIf
	
	' draw info
	xText 10, 10, "Use WSAD to move camera around scene"
	xText 10, 30, "Use 1, 2, 3 to change object controler"
	xText 10, 50, used_controller$
	
	' switch back buffer
	xFlip()
	
Wend

Function ComputeMove#(camera%, x#, y#, z#)
	If mouseSpeedX = 0 And mouseSpeedY = 0 Then Return 0.0
	' project axis on the screen
	xCameraProject(camera, controllPosX, controllPosY, controllPosZ)
	x1 = xProjectedX()
	y1 = xProjectedY()
	xCameraProject(camera, controllPosX + x, controllPosY + y, controllPosZ + z)
	x2 = xProjectedX()
	y2 = xProjectedY()
	' compute angle between our vectors
	dx1    = x2 - x1
	dy1    = y2 - y1
	dx2    = mouseSpeedX
	dy2    = mouseSpeedY
	len1#  = Sqr(dx1 * dx1 + dy1 * dy1)
	len2#  = Sqr(dx2 * dx2 + dy2 * dy2)
	angle# = ACos(Float(dx1 * dx2 + dy1 * dy2) / (len1 * len2))
	' compute distance
	radii# = Sqr(dx2 * dx2 + dy2 * dy2)
	' compute a new vector's x-component
	return radii * Cos(angle)
End Function