;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Butterfly sample, (c) 2009 Xors3D Team           *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

;initialization
xAppTitle "Butterfly"
xGraphics3D 800, 600, 32, False, True

;creating the camera
cam = xCreateCamera()
xPositionEntity cam, 0, 70, -120
xRotateEntity cam, 15, 0, 0
xCameraClsColor cam, 192, 192, 192

;enabling antialiasing
xAntiAlias True

;objects loading
wings = xLoadMesh("../../../media/Meshes/ButterflyWings.b3d")
xRotateEntity wings, 0, 0, -90
body = xLoadMesh("../../../media/Meshes/ButterflyBody.b3d")
xRotateEntity body, 0, 0, -90

;light source creating
light = xCreateLight()
xRotateEntity light, -45, 0, 0

;loading effect from file
butterfly = xLoadFXFile("../../../media/shaders/IridescentButterfly.fx")

;checking if this technique is supported by hardware
If xValidateEffectTechnique(butterfly, "IridescentButterfly") = False
	RuntimeError "Technique is not supported!"
EndIf

;loading textures
tex1 = xLoadTexture("../../../media/textures/gradientMap.bmp")
tex2 = xLoadTexture("../../../media/textures/baseOpacityMap.tga")
tex3 = xLoadTexture("../../../media/textures/bumpGlossMap.tga")

;setting the effect and constants
xSetEntityEffect wings, butterfly
xSetEffectTechnique(wings, "IridescentButterfly")
xSetEffectMatrixSemantic wings, "world_view_proj_matrix", WORLDVIEWPROJ
xSetEffectMatrixSemantic wings, "inv_view_matrix", VIEWINVERSE
xSetEffectTexture wings, "baseOpacityMap_Tex", tex2
xSetEffectTexture wings, "bumpGlossMap_Tex", tex3
xSetEffectTexture wings, "gradientMap_Tex", tex1
xEntityAlpha wings, 0.5

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	;setting the spectator's position
	xSetEffectVector wings, "view_position", xEntityX(cam), xEntityY(cam), xEntityZ(cam)
	
	;rendering the world
	xRenderWorld
	
	;fps output
	xColor 0, 0, 0
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	
	;drawing
	xFlip

Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function