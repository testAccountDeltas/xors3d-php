;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Instancing sample, (c) 2010 XorsTeam             *
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
;xHidePointer()

; enable antialiasing
xAntiAlias True

; create camera
camera = xCreateCamera()
xCameraClsColor camera, 192, 168, 132

; position camera
xPositionEntity camera, -90, 90, -40
camxa# = -60
camya# = 25

; create object
;obj = xCreateCube()
obj = xCreateCylinder(32)
xEntityColor obj, 0, 0, 0

; loading logo from file
tex0 = xLoadTexture("..\..\..\media\Textures\tex0.png")
tex1 = xLoadTexture("..\..\..\media\Textures\tex1.png")

; texture object
xEntityTexture obj, tex0

; load instancing shader
shader = 0
instancingType$ = "Software emulation"
If xHWInstancingAvailable()
	shader = xLoadFXFile("..\..\..\media\Shaders\hwinstancing2.fx")
	instancingType$ = "Hardware"
Else If xShaderInstancingAvailable()
	shader = xLoadFXFile("..\..\..\media\Shaders\shaderinstancing.fx")
	instancingType$ = "Shaders emulation"
EndIf
xSetEntityEffect obj, shader
xSetEffectTechnique obj, "Instancing"

Global max_x% = 20
Global max_y% = 20
Global max_z% = 20
Global tick%  = 0

Dim clone(max_x, max_y, max_z)

; create instances
For x = 0 To max_x - 1
	For y = 0 To max_y - 1
		For z = 0 To max_z - 1
			clone(x, y, z) = xCreateInstance(obj)
			xPositionEntity clone(x, y, z), x * 3, y * 3, z * 3
			xRotateEntity clone(x, y, z), 90 / max_x * x, 90 / max_y * y, 90 / max_z * z
			xEntityColor clone(x, y, z), 255 / max_x * x, 255 / max_y * y, 255 / max_z * z
		Next
	Next
Next

; hide original entity
xHideEntity obj

; create light source
light = xCreateLight()
xRotateEntity light, 45, 0, 0

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

waving% = 1
; main program loop
While Not xKeyDown(KEY_ESCAPE)
	
	If waving
		Wave()
	EndIf
	If xKeyhit(KEY_SPACE)
		waving = 1 - waving
	EndIf
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
	xText 10, 70, "Entities: " + (max_x * max_y * max_z)
	xText 10, 90, "Instancing type: " + instancingType$
	
	; switch back buffer
	xFlip()
	
Wend

End

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

Function Wave()
	time# = MilliSecs()
	For x = 0 To max_x - 1
		For y = 0 To max_y - 1
			For z = 0 To max_z - 1
				shift# = Float(x + y + z)/(max_x + max_y + max_z)*360
				scale# = 1 + (Sin(time#/10 + shift#)^4)/2
				xScaleEntity clone(x, y, z), scale#, scale#, scale#
			Next
		Next
	Next
End Function