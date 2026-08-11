'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Army sample, (c) 2009 Xors3D Team                *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application window caption
xAppTitle "Army sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, False
xSetEngineSetting("LoadMesh::RelativePaths", "false")
SeedRnd MilliSecs()

' hide mouse pointer
xHidePointer()

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()

' position camera
xPositionEntity camera, 0, 2, -5

' set this to true to use software skinning
Const forceSoftware = False

' if shaders are supported (their version is greater than or equal to 1.1)
' then use them for hardware skinning, else use software skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	xSetSkinningMethod SKIN_HARDWAREVS
Else
	xSetSkinningMethod SKIN_SOFTWARE
EndIf

' if we use hardware skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	' load shader
	shader = xLoadFXFile("..\..\media\shaders\skinning.fx")
EndIf

' create units
Global units[300]
unitCnt% = 0
lastx = 0
lasty = 0
For x = 0 To 9
	For y = 0 To 0
		If y * 10 + x = 0
			' loading skinned mesh
			units[0] = xLoadAnimMesh("../../media/meshes/hazar.b3d")
			' extract animation sequences
			xExtractAnimSeq(units[0], 2, 4)
			animIndle = 1
			xExtractAnimSeq(units[0], 20, 59)
			animRun = 2
			xExtractAnimSeq(units[0], 99, 129)
			animAttack = 3
		Else If y * 10 + x = 1
			' loading skinned mesh
			units[1] = xLoadAnimMesh("../../media/meshes/kuznec.b3d")
			' extract animation sequences
			xExtractAnimSeq(units[1], 2, 4)
			animIndle = 1
			xExtractAnimSeq(units[1], 20, 59)
			animRun = 2
			xExtractAnimSeq(units[1], 99, 129)
			animAttack = 3
		Else
			units[y * 10 + x] = xCopyEntity(units[Rnd(0, 2)])
		EndIf
		xRotateEntity units[y * 10 + x], 0, 180, 0
		xPositionEntity units[y * 10 + x], x * 2 - 9, 0, y * 2
		speed# = 1.0
		seq%   = Rnd(1, 4)
		If seq = 1 Then speed = 0.1
		xAnimate units[y * 10 + x], 1, speed#, seq
		' if we use hardware skinning
		If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
			' assign it to mesh
			xSetEntityEffect units[y * 10 + x], shader
			' setup constant name for bones matrices
			xSetBonesArrayName units[y * 10 + x], "bonesMatrixArray"
			' setup technique
			xSetEffectTechnique units[y * 10 + x], "Skinned"
		EndIf
		unitCnt = unitCnt + 1
		lastx = x
		lasty = y
	Next
Next

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
	
	' add a new unit
	If xKeyHit(xKEY_SPACE) Then
		unitCnt = unitCnt + 1
		lastx = lastx + 1
		If lastx > 9 Then lastx = 0 ; lasty = lasty + 1
		units[lasty * 10 + lastx] = xCopyEntity(units[Rnd(0, 2)])
		xRotateEntity units[lasty * 10 + lastx], 0, 180, 0
		xPositionEntity units[lasty * 10 + lastx], lastx * 2 - 9, 0, lasty * 2
		speed# = 1.0
		seq%   = Rnd(1, 4)
		If seq = 1 Then speed = 0.1
		xAnimate units[lasty * 10 + lastx], 1, speed#, seq
		' if we use hardware skinning
		If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
			' assign it to mesh
			xSetEntityEffect units[lasty * 10 + lastx], shader
			' setup constant name for bones matrices
			xSetBonesArrayName units[lasty * 10 + lastx], "bonesMatrixArray"
			' setup technique
			xSetEffectTechnique units[lasty * 10 + lastx], "Skinned"
		EndIf
	EndIf
	
	' update animations
	xUpdateWorld()
	
	' render scene
	xRenderWorld()
	
	' draw text
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	xText 10, 50, "Units: " + unitCnt
	xText 10, 70, "SPACE - Add new unit"
	
	' switch back buffer
	xFlip()
	
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function