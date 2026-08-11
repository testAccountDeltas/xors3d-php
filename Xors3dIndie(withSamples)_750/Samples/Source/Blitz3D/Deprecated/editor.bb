;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Editor sample, (c) 2010 XorsTeam                 *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; Include header file
Include "..\xors3d.bb"

; setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

; set application's title
xAppTitle "Editor sample"

; initialize graphics mode
xGraphics3D 800, 600, 32, False, True

; enable antialiasing
xAntiAlias True

; create camera
camera = xCreateCamera()
xCameraClsColor camera, 192, 192, 192
xPositionEntity camera, 10, 10, 10

; create light
light = xCreateLight()

; create cube
cube = xCreateCube()
xPointEntity camera, cube

; loading logo from file
logoTexture = xLoadTexture("..\..\..\media\textures\logo.jpg")

; texture cube
xEntityTexture cube, logoTexture

; gizmos' data
controlType   = 0 ;/ 0 - move, 1 - rotate, 2 - scale 
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

Global mousespeed#       = 0.5
Global camerasmoothness# = 4.5
Global camxa# = 0
Global camya# = 0

; main program loop
While Not xKeyDown(KEY_ESCAPE)
	xColor 100, 0, 0
	mouseSpeedX = xMouseXSpeed()
	mouseSpeedY = xMouseYSpeed()
	
	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity camera,  1,  0,  0
	
	If xMouseDown(2)
		mxs# = CurveValue(mouseSpeedX * mousespeed, mxs, camerasmoothness)
		mys# = CurveValue(mouseSpeedY * mousespeed, mys, camerasmoothness)
		camxa# = camxa - mxs Mod 360
		camya# = camya + mys
		If camya < -89 Then camya = -89
		If camya >  89 Then camya =  89
		xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
		xRotateEntity camera, camya, camxa, 0.0
	EndIf
	
	If xKeyHit(KEY_1)  Then controlType = 0
	If xKeyHit(KEY_2)  Then controlType = 1
	If xKeyHit(KEY_3)  Then controlType = 2

	; render scene
	xRenderWorld()
	
	; draw grid
	xDrawGrid(0, 0, 5, 100);
	
	; draw gizmos
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
	
	; object control
	If xMouseDown(1) And selectMask <> 0
		useX     = (selectMask Shr 0) And 1
		useY     = (selectMask Shr 1) And 1
		useZ     = (selectMask Shr 2) And 1
		useG     = (selectMask Shr 3) And 1
		factorX# = 0.7 / Float(xGraphicsWidth())
		factorY# = 0.7 / Float(xGraphicsHeight())
		Select controlType
		; if movement gizmo is used
		Case 0
			; move controlled entity
			dx#   = controllPosX - xEntityX(camera, True)
			dy#   = controllPosY - xEntityY(camera, True)
			dz#   = controllPosZ - xEntityZ(camera, True)
			dist# = Sqr(dx * dx + dy * dy + dz * dz)
			; x-axis
			If useX
				move# = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				xTranslateEntity cube, move, 0.0, 0.0, False
			EndIf
			; y-axis
			If useY
				move# = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				xTranslateEntity cube, 0.0, move, 0.0, False
			EndIf
			; z-axis
			If useZ
				move# = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				xTranslateEntity cube, 0.0, 0.0, move, False
			EndIf
		; if scaling gizmo is used
		Case 2
			; scale controlled entity
			dx#   = controllPosX - xEntityX(camera, True)
			dy#   = controllPosY - xEntityY(camera, True)
			dz#   = controllPosZ - xEntityZ(camera, True)
			dist# = Sqr(dx * dx + dy * dy + dz * dz)
			; x-axis
			If useX
				move#      = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				deltaX     = deltaX     + move
				scaleXInit = scaleXInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
			; y-axis
			If useY
				move#      = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				deltaY     = deltaY     + move
				scaleYInit = scaleYInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
			; z-axis
			If useZ
				move#      = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				deltaZ     = deltaZ     + move
				scaleZInit = scaleZInit + move
				xScaleEntity cube, scaleXInit, scaleYInit, scaleZInit
			EndIf
		; if rotation gizmo is used
		Case 1
			; rotate controlled entity
			; x-axis
			If useX
				move#  = ComputeMove(camera, 0.0, -10.0, 0.0)
				deltaX = deltaX + move
				xTurnEntity cube, move, 0.0, 0.0, True
			EndIf
			; y-axis
			If useY
				move#  = ComputeMove(camera, -10.0, -10.0, 0.0);
				deltaY = deltaY + move
				xTurnEntity cube, 0.0, move, 0.0, True
			EndIf
			; z-axis
			If useZ
				move#  = ComputeMove(camera, -10.0, 0.0, 0.0);
				deltaZ = deltaZ + move
				xTurnEntity cube, 0.0, 0.0, move, True
			EndIf
		End Select
	EndIf
	
	; draw info
	xText 10, 10, "Use WSAD to move camera around scene"
	xText 10, 30, "Use 1, 2, 3 to change object controler"
	xText 10, 50, used_controller$
	
	; switch back buffer
	xFlip()
	
Wend

Function ComputeMove#(camera%, x#, y#, z#)
	If mouseSpeedX = 0 And mouseSpeedY = 0 Then Return 0.0
	; project axis on the screen
	xCameraProject(camera, controllPosX, controllPosY, controllPosZ)
	x1 = xProjectedX()
	y1 = xProjectedY()
	xCameraProject(camera, controllPosX + x, controllPosY + y, controllPosZ + z)
	x2 = xProjectedX()
	y2 = xProjectedY()
	; compute angle between our vectors
	dx1    = x2 - x1
	dy1    = y2 - y1
	dx2    = mouseSpeedX
	dy2    = mouseSpeedY
	len1#  = Sqr(dx1 * dx1 + dy1 * dy1)
	len2#  = Sqr(dx2 * dx2 + dy2 * dy2)
	angle# = ACos(Float(dx1 * dx2 + dy1 * dy2) / (len1 * len2))
	; compute distance
	radii# = Sqr(dx2 * dx2 + dy2 * dy2)
	; compute a new vector's x-component
	Return radii * Cos(angle)
End Function

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D