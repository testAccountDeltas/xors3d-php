;*******************************************************************
;*                                                                 *
;* Xors3D Engine. MRT sample, (c) 2009 Xors3D Team                 *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

; initialize graphics mode
xGraphics3D 800, 600, 32, False, True
; create depth-stencil surface
xCreateDSS 800, 600

; create camera
cam = xCreateCamera()
xCameraClsColor cam, 100, 100, 200
xPositionEntity cam, 0, 3, -8
xRotateEntity cam, 10, 0, 0

; create textures for MRT
tex  = xCreateTexture(800, 600)
tex1 = xCreateTexture(800, 600)
tex2 = xCreateTexture(800, 600) 

; create cubes in scene
cu = xCreateCube()
xPositionEntity cu, 0, 0, 5
xEntityTexture cu, tex
cu1 = xCreateCube()
xPositionEntity cu1, -5, 0, 5
xEntityTexture cu1, tex1
cu2 = xCreateCube()
xPositionEntity cu2, 5, 0, 5
xEntityTexture cu2, tex2

; load FX effect
shad = xLoadFXFile("..\..\..\media\shaders\MRT.fx")

; set effect to cubes
xSetEntityEffect cu, shad
xSetEffectTechnique(cu, "Point")
xSetEffectMatrixSemantic cu, "MatWorldViewProj", WORLDVIEWPROJ

xSetEntityEffect cu1, shad
xSetEffectTechnique(cu1, "Point")
xSetEffectMatrixSemantic cu1, "MatWorldViewProj", WORLDVIEWPROJ

xSetEntityEffect cu2, shad
xSetEffectTechnique(cu2, "Point")
xSetEffectMatrixSemantic cu2, "MatWorldViewProj", WORLDVIEWPROJ

If xGetNumberRT()<1 RuntimeError "MRT dont support"

; main program loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	; turn cube
	xTurnEntity cu, 0, 1, 0

	
	; enable shaders
	xEnableEntityShader(cu,  1)
	xEnableEntityShader(cu1, 1)
	xEnableEntityShader(cu2, 1)
	
	; setup MRT layers
	xSetMRT(tex1, 0, 0)
	xSetMRT(tex2, 0, 1)
	xSetMRT(tex,  0, 2)
	; render scene
	xRenderWorld()
	; deisable MRT
	xUnSetMRT()
	
	; disable shaders
	xEnableEntityShader(cu,  0)
	xEnableEntityShader(cu1, 0)
	xEnableEntityShader(cu2, 0)

	; render scene to back buffer
	xSetBuffer xBackBuffer()
	xRenderWorld()
	
	; draw texts
	xColor 0, 255, 0
	xText 40, 30, "FPS: " + xGetFPS()
	xText 40, 50, "MaxNumberRT: " + xGetNumberRT()
	xText 100, 240, "RT 1 "
	xText 650, 240, "RT 2 "
	xText 380, 240, "RT 3 "
	
	; draw scene
	xFlip
Wend