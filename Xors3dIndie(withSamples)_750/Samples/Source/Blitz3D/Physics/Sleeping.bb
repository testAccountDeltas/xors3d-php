Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 25
Const maxCameraDistance# = 75

Type tBox
	Field entity%
End Type

xCreateLog(LOG_HTML, LOG_INFO, "Sleeping.html")

xGraphics3D(1024, 768, 32, False, True)
xHidePointer()

xCreateDSS(1024, 1024)

Global cameraDistance# = 45
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xPositionEntity(camPiv, 0.0, 5.0, 0.0)
xPositionEntity(camera, 0.0, 0.0, -cameraDistance)
xCameraClsColor(camera, 96, 128, 192)
xRotateEntity(camPiv, maxCameraAngle / 2, 45, 0)
xCameraEnableShadows(camera)
xCameraRange(camera, 1.0, 100.0)

lightRed = xcreatelight()
xRotateEntity(lightRed, 60, 15, 0)
xLightColor(lightRed, 255, 128, 128)

lightBlue = xcreatelight()
xRotateEntity(lightBlue, 60, 195, 0)
xLightColor(lightBlue, 128, 128, 255)
xLightEnableShadows(lightBlue, True)
xLightShadowEpsilons(lightBlue, 0.0001, 0.0001)

xSetShadowParams(1, 0.15, 1, 50)
xInitShadows(1024, 0, 0)

Global tex = CreateCheckerTexture()
xScaleTexture(tex, 0.25, 0.25)

Global ground = xCreateCube()
xScaleEntity(ground, 25, 1, 25)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)
xEntitySetFriction(ground, 1.0)

Global stackStable = BuildStack(True)
xPositionEntity(stackStable, 0.0, 0.0, 0.0)

Global stackUntouched = BuildStack(True)
xPositionEntity(stackUntouched, -10.0, 0.0, 10.0)

Global stackUnstable = BuildStack(False)
xPositionEntity(stackUnstable, -10.0, 0.0, -10.0)

Global sleeping = False

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	UpdateBoxes()
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Press <Space> to reset scene")
	xflip()	
Wend
End

Function UpdateCamera(ViewSensivity#)
	xMoveMouse(xGraphicsWidth()/2, xGraphicsHeight()/2)
	mXSp = xMouseXSpeed()
	mYSp = xMouseYSpeed()
	Local CamP# = xEntityPitch(camPiv) + mYSp * ViewSensivity
	If Abs(CamP) > maxCameraAngle
		CamP = maxCameraAngle * Sgn(CamP)
	EndIf
	xTurnEntity camPiv,0,-mXSp*ViewSensivity*(1.05 - Abs(CamP) / maxCameraAngle),0
	xRotateEntity camPiv,CamP,xEntityYaw(camPiv),0
	mZSp = xMouseZSpeed()
	cameraDistance = cameraDistance + mZSp
	If (cameraDistance < maxCameraDistance) And (cameraDistance > minCameraDistance)
		xMoveEntity camera, 0, 0, -mZSp
	Else
		If cameraDistance > maxCameraDistance
			cameraDistance = maxCameraDistance
		EndIf
		If cameraDistance < minCameraDistance
			cameraDistance = minCameraDistance
		EndIf
	EndIf
	
End Function

Function Reset()
	For b.tBox = Each tBox
		xFreeEntity(b\entity)
		Delete b
	Next
	xFreeEntity(stackStable0)
	xFreeEntity(stackStable1)
	xFreeEntity(stackUnstable)
	
	stackStable = BuildStack(True)
	xPositionEntity(stackStable, 0.0, 0.0, 0.0)
	stackUntouched = BuildStack(True)
	xPositionEntity(stackUntouched, -10.0, 0.0, 10.0)
	stackUnstable = BuildStack(False)
	xPositionEntity(stackUnstable, -10.0, 0.0, -10.0)
End Function

Function BuildStack(freezed%, h% = 10)
	If (h > 20)
		h = 20
	EndIf
	If (h < 5)
		h = 5
	EndIf
	Local lPivot% = xCreatePivot()
	Local lSize# = 10.0 / Float(h)
	
	For i = 0 To h - 1
		b.tBox = New tBox
		b\entity = xCreateCube(lPivot)
		xPositionEntity(b\entity, i * lSize * 0.5, (2 * i + 1) * lSize + 1, i * lSize * 0.5) ; thickness of the 'ground' + 1/2 of the cube
		xScaleEntity(b\entity, lSize, lSize, lSize)
		xEntityTexture(b\entity, tex)
		xEntityAddBoxShape(b\entity, 1.0)
		xEntitySetFriction(b\entity, 1.0)
		If freezed
			xEntitySleep(b\entity)
		EndIf
	Next
	
	Return lPivot
End Function

Function UpdateBoxes()
	For b.tBox = Each tBox
		If xEntityIsSleeping(b\entity)
			xEntityColor(b\entity, 32, 128, 255)
		Else
			xEntityColor(b\entity, 255, 128, 32)
		EndIf
	Next
End Function

Function CreateCheckerTexture(size% = 256)
	Local lTex = xCreateTexture(size, size)
	xSetBuffer(xTextureBuffer(lTex))
	xColor(222, 222, 222)
	xRect(0, 0, size, size, 1)
	xColor(255, 255, 255)
	xRect(0, 0, size / 2, size / 2, 1)
	xRect(size / 2, size / 2, size / 2, size / 2, 1)
	xSetBuffer(xBackBuffer())
	Return lTex
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D