;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Skinning sample, (c) 2009 Xors3D Team            *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; Include header file
Include "..\xors3d.bb"

; setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

; set application window caption
xAppTitle "Skinning sample"

; initialize graphics mode
xGraphics3D 800, 600, 32, False, True
xSetEngineSetting("LoadMesh::RelativePaths", "false")

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias True

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity camera, 0, 2, -5

; set this to true for using software skinning
Const forceSoftware = False

; if shaders are supported (their version is greater than or equal to 1.1)
; then use them for hardware skinning, else use software skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	xSetSkinningMethod SKIN_HARDWAREVS
Else
	xSetSkinningMethod SKIN_SOFTWARE
EndIf

; loading skinned mesh
hazar = xLoadAnimMesh("../../../media/meshes/hazar.b3d")
xRotateEntity hazar, 0, 180, 0

; if we use hardware skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	; load shader
	shader = xLoadFXFile("..\..\..\media\shaders\skinning.fx")
	; assign it to mesh
	xSetEntityEffect hazar, shader
	; setup constant name for bones matrices
	xSetBonesArrayName hazar, "bonesMatrixArray"
	; setup technique
	xSetEffectTechnique hazar, "Skinned"
EndIf

; we may load animation sequensec only for skinned mesh
skinnedHazar = xFindChild(hazar, "Box01")

; extract animation sequences
xExtractAnimSeq(hazar, 2, 4)
animIndle = 1 ; in fact xExtractAnimSeq() return sequence number, but
							; in model 2 animated meshes(man and sword), and we must
							; extract sequences for each of them for real number,
							; but sequences number always increments for next sequence ;)
xExtractAnimSeq(hazar, 20, 59)
animRun = 2
xExtractAnimSeq(hazar, 99, 129)
animAttack = 3
xExtractAnimSeq(hazar, 70, 87)
animDeath = 4

; play idle animation
xAnimate hazar, 2, 0.1, animIndle
curAnimation = animIndle

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
	
	; animation switch
	If xKeyHit(KEY_1) Then xAnimate hazar, 2, 0.1, animIndle : curAnimation = animIndle
	If xKeyHit(KEY_2) Then xAnimate hazar, 1, 1.0, animRun : curAnimation = animRun
	If xKeyHit(KEY_3) Then xAnimate hazar, 1, 1.0, animAttack : curAnimation = animAttack
	If xKeyHit(KEY_4) Then xAnimate hazar, 3, 1.0, animDeath : curAnimation = animDeath
	
	; update animations
	xUpdateWorld()
	
	; render scene
	xRenderWorld()
	
	; draw hints
	xText 10, 10, "Key 1 - Idle animation"
	xText 10, 30, "Key 2 - Run animation"
	xText 10, 50, "Key 3 - Attack animation"
	xText 10, 70, "Key 4 - Death animation"
	Select curAnimation
	Case animIndle
		xText 10, 90, "Now played - Idle animation"
	Case animRun
		xText 10, 90, "Now played - Run animation"
	Case animAttack
		xText 10, 90, "Now played - Attack animation"
	Case animDeath
		xText 10, 90, "Now played - Death animation"
	End Select
	
	; switch back buffer
	xFlip()
	
Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function