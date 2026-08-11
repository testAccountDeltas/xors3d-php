;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Deltatime sample, (c) 2010 XorsTeam              *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

; initialization
xAppTitle "Deltatime"
xGraphics3D 800, 600, 32, False, False

; create camera
camera = xCreateCamera()
xPositionEntity camera, 0, 0, -20

; create scene
cube = xCreateCube()
xPositionEntity cube, -10, 0, 0
cone = xCreateCone()
xRotateEntity cone, 180, 0, 0
xPositionEntity cone, 10, 2, 0
xEntityColor cone, 255, 0, 0

; cetch first frame time
lastFrame = xMillisecs()

; main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	; move cube with deltatimed value (cube moves 5 points per second)
	xMoveEntity cube, xDeltaValue(5.0, lastFrame), 0, 0
	
	; catch frame time
	lastFrame = xMillisecs()
	
	; render world
	xUpdateWorld
	xRenderWorld
	
	; draw info
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Cube will arive within 4 seconds. Always."
	xText 10, 50, "Time from last frame: " + xDeltaTime(False) + " msec"
	xText 10, 70, "Time from application start: " + xDeltaTime(True) + " msec"
	
	; swap buffers
	xFlip

Wend
;~IDEal Editor Parameters:
;~C#Blitz3D