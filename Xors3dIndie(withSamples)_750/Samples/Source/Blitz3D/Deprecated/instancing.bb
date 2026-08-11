;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Instancing sample, (c) 2010 Xors3D Team          *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; Include header file
Include "..\xors3d.bb"

; setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

; set application window caption
xAppTitle "Instancing sample"

; initialize graphics mode
xGraphics3D 800, 600, 32, False, False

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias True

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity camera, 13, 13, -50

; create cube
cube = xCreateCube()

; loading logo from file
logoTexture = xLoadTexture("..\..\..\media\textures\logo.jpg")

; texture cube
xEntityTexture cube, logoTexture

; load instancing shader
shader = 0
instancingType$ = "Software emulation"
If xHWInstancingAvailable()
	shader = xLoadFXFile("..\..\..\media\shaders\hwinstancing.fx")
	instancingType$ = "Hardware"
Else If xShaderInstancingAvailable()
	shader = xLoadFXFile("..\..\..\media\shaders\shaderinstancing.fx")
	instancingType$ = "Shaders emulation"
EndIf
xSetEntityEffect cube, shader
xSetEffectTechnique cube, "Instancing"

; create cube instances
For x = 0 To 9
	For y = 0 To 9
		For z = 0 To 9
			clone = xCreateInstance(cube)
			xPositionEntity clone, x * 3, y * 3, z * 3
		Next
	Next
Next

; hide original entity
xHideEntity cube

; create light source
light = xCreateLight()
xRotateEntity light, 45, 0, 0

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

; main program loop
While Not xKeyDown(KEY_ESCAPE)

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
	
	; render scene
	xRenderWorld()

	; draw info
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	xText 10, 50, "DIP calls: " + xDIPCounter()
	xText 10, 70, "Instncing type: " + instancingType$
	
	; switch back buffer
	xFlip()
	
Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D