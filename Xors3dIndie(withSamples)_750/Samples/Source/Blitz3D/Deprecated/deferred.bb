;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Deferred render sample, (c) 2009 Xors3D Team     *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; include header
Include "..\xors3d.bb"

; initialize graphics
xGraphics3D 800, 600, 32, False, False
; create depth-stencil surface
xCreateDSS 1024, 1024

; create camera
camera = xCreateCamera()
xPositionEntity camera, 0, 3, -20
xCameraRange camera, 0.1, 1000

; check MRT support
If xGetNumberRT() < 1 RuntimeError "MRT dont support"

; initilize deferred render
xSetDeferredShaders("../../../media/shaders/DeferredMRT.fx", "../../../media/shaders/DeferredFinal.fx")
xInitDeferred()

; initalize shadows system
xSetShadowShader("../../../media/shaders/DeferredShadows.fx")
xInitShadows(0, 0, 0)

; load scene
scene = xLoadMesh("../../../media/meshes/model2.b3d")
xPositionEntity scene, 0, -2, 0
xEntityShininess scene, 1

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2 
mousespeed# = 0.5 
camerasmoothness# = 4.5

; setup ambient light
xAmbientLight 5, 5, 5

; light number
Const amount = 11

; array for lights, and it's data
Dim light%(amount + 1)
Dim pos_x#(amount + 1), pos_y#(amount + 1), pos_z#(amount + 1)
Dim rot#(amount + 1), speed#(amount + 1)

; create lights
SeedRnd MilliSecs()
For i = 0 To amount
	light(i) = xCreateLight(2)
	xLightRange light(i), 12
	xLightColor light(i), Rnd(0, 255), Rnd(0, 255), Rnd(0, 255)
Next

; create cube
cube = xCreateCube()
; load texture for it
tex = xLoadTexture("../../../media/textures/rockwall_diffuse.jpg")
; texture cube
xEntityTexture cube, tex
; set cube material
xPositionEntity cube, 0, 3, 0
xEntityColor cube, 255, 0, 0
xEntityFX cube, 1 + 8 + 16

; main loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	; camera controll
	If xKeyDown(KEY_W)    Then xMoveEntity camera,  0.0,  0.0,  0.1
	If xKeyDown(KEY_S)    Then xMoveEntity camera,  0.0,  0.0, -0.1
	If xKeyDown(KEY_A)    Then xMoveEntity camera, -0.1,  0.0,  0.0
	If xKeyDown(KEY_D)    Then xMoveEntity camera,  0.1,  0.0,  0.0
	If xKeyDown(KEY_UP)   Then xMoveEntity camera,  0.0,  0.1,  0.0
	If xKeyDown(KEY_DOWN) Then xMoveEntity camera,  0.0, -0.1,  0.0
	If xKeyHit(KEY_SPACE) Then blend = 1 - blend : xEntityBlend cube, 1 + blend
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness) 
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness) 
	camxa# = camxa - mxs Mod 360 
	camya# = camya + mys 
	If camya < -89 Then camya = -89 
	If camya >  89 Then camya =  89 
	xMoveMouse 800 / 2, 600 / 2
	xRotateEntity camera, camya, camxa, 0

	; update lights
	xPositionEntity light(0),  7  * Sin( MilliSecs() / 20),       0,  7  * Cos( MilliSecs() / 20)
	xPositionEntity light(1),  7  * Sin( MilliSecs() / 20 + 90),  0,  7  * Cos( MilliSecs() / 20 + 90)
	xPositionEntity light(2),  7  * Sin( MilliSecs() / 20 + 180), 0,  7  * Cos( MilliSecs() / 20 + 180)
	xPositionEntity light(3),  7  * Sin( MilliSecs() / 20 + 270), 0,  7  * Cos( MilliSecs() / 20 + 270)
	xPositionEntity light(4),  16 * Sin(-MilliSecs() / 20),       0,  16 * Cos(-MilliSecs() / 20)
	xPositionEntity light(5),  16 * Sin(-MilliSecs() / 20 + 90),  0,  16 * Cos(-MilliSecs() / 20 + 90)
	xPositionEntity light(6),  16 * Sin(-MilliSecs() / 20 + 180), 0,  16 * Cos(-MilliSecs() / 20 + 180)
	xPositionEntity light(7),  16 * Sin(-MilliSecs() / 20 + 270), 0,  16 * Cos(-MilliSecs() / 20 + 270)
	xPositionEntity light(8),  14 * Sin( MilliSecs() / 20),       15, 14 * Cos( MilliSecs() / 20)
	xPositionEntity light(9),  14 * Sin( MilliSecs() / 20 + 90),  15, 14 * Cos( MilliSecs() / 20 + 90)
	xPositionEntity light(10), 14 * Sin( MilliSecs() / 20 + 180), 15, 14 * Cos( MilliSecs() / 20 + 180)
	xPositionEntity light(11), 14 * Sin( MilliSecs() / 20 + 270), 15, 14 * Cos( MilliSecs() / 20 + 270)
	
	; render world
	xRenderWorldDeferred()

	; draw texts
	xColor 0, 255, 0
	xText 40, 30, "FPS: " + xGetFPS()
	xText 40, 50, "MaxNumberRT: " + xGetNumberRT()
	xText 40, 70, "TrisRendered: " + xTrisRendered()
	xText 40, 90, "DIP calls: " + xDIPCounter()
	
	; draw scene
	xFlip
Wend

; for camera
Function CurveValue#(newvalue#, oldvalue#, increments)
    If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
    If increments <= 1 Then oldvalue# = newvalue#
    Return oldvalue# 
End Function