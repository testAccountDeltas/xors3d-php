Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 25
Const maxCameraDistance# = 75

xCreateLog(LOG_HTML, LOG_INFO, "Friction.html")

xGraphics3D(1024, 768, 32, False, True)
xHidePointer()

xCreateDSS(1024, 1024)

Global cameraDistance# = 65
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xPositionEntity(camera,0,0, -cameraDistance)
xCameraClsColor(camera, 96, 128, 192)
xRotateEntity(camPiv, 0, -30, 0)
xCameraEnableShadows(camera)
xCameraRange(camera, 1.0, 100.0)

lightBlue = xcreatelight()
xRotateEntity(lightBlue, 30, 30, 0)
xLightColor(lightBlue, 128, 128, 255)
xLightEnableShadows(lightBlue, True)
xLightShadowEpsilons(lightBlue, 0.0001, 0.0001)

xSetShadowParams(1, 0.15, 1, 50)
xInitShadows(1024, 0, 0)

Global tex = CreateCheckerTexture()
xScaleTexture(tex, 0.25, 0.25)

Global ground = xCreateCube()
xRotateEntity(ground, -45, 0, 0)
xScaleEntity(ground, 25, 1, 25)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)
xEntitySetFriction(ground, 0.5)

Global cubeRed = xCreateCube()
xRotateEntity(cubeRed, -45, 0, 0)
xPositionEntity(cubeRed, -5, 20, 15)
xEntityColor(cubeRed, 255, 32, 32)
xEntityTexture(cubeRed, tex)
xEntityAddBoxShape(cubeRed, 1)
xEntitySetFriction(cubeRed, 0.5)

Global cubeOrange = xCreateCube()
xRotateEntity(cubeOrange, -45, 0, 0)
xPositionEntity(cubeOrange, 0, 20, 15)
xEntityColor(cubeOrange, 255, 128, 32)
xEntityTexture(cubeOrange, tex)
xEntityAddBoxShape(cubeOrange, 1)
xEntitySetFriction(cubeOrange, 0.75)

Global cubeGreen = xCreateCube()
xRotateEntity(cubeGreen, -45, 0, 0)
xPositionEntity(cubeGreen, 5, 20, 15)
xEntityColor(cubeGreen, 32, 255, 128)
xEntityTexture(cubeGreen, tex)
xEntityAddBoxShape(cubeGreen, 1)
xEntitySetFriction(cubeGreen, 1.0)

Global cubeWhite = xCreateCube()
xRotateEntity(cubeWhite, -45, 0, 0)
xPositionEntity(cubeWhite, 10, 20, 15)
xEntityColor(cubeWhite, 255, 255, 255)
xEntityTexture(cubeWhite, tex)
xEntityAddBoxShape(cubeWhite, 1)
xEntitySetFriction(cubeWhite, 100.0)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Ground: " + xEntityGetFriction(ground))
	xText( 10, 50, "Press <Space> to reset")
	PrintValues()
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
	xEntityReleaseForces( cubeRed)
	xEntityReleaseForces( cubeOrange)
	xEntityReleaseForces( cubeGreen)
	xEntityReleaseForces( cubeWhite)
	xPositionEntity( cubeRed, -5, 20, 15)
	xPositionEntity( cubeOrange, 0, 20, 15)
	xPositionEntity( cubeGreen, 5, 20, 15)
	xPositionEntity( cubeWhite, 10, 20, 15)
	xRotateEntity(cubeRed, -45, 0, 0)
	xRotateEntity(cubeOrange, -45, 0, 0)
	xRotateEntity(cubeGreen, -45, 0, 0)
	xRotateEntity(cubeWhite, -45, 0, 0)
	xEntityWakeUp( cubeRed)
	xEntityWakeUp( cubeOrange)
	xEntityWakeUp( cubeGreen)
	xEntityWakeUp( cubeWhite)
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

Function PrintValues()
	xCameraProject(camera, xEntityX(cubeRed, True), xEntityY(cubeRed, True) + 2.5, xEntityZ(cubeRed, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetFriction(cubeRed))
	xCameraProject(camera, xEntityX(cubeOrange, True), xEntityY(cubeOrange, True) + 2.5, xEntityZ(cubeOrange, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetFriction(cubeOrange))
	xCameraProject(camera, xEntityX(cubeGreen, True), xEntityY(cubeGreen, True) + 2.5, xEntityZ(cubeGreen, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetFriction(cubeGreen))
	xCameraProject(camera, xEntityX(cubeWhite, True), xEntityY(cubeWhite, True) + 2.5, xEntityZ(cubeWhite, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetFriction(cubeWhite))
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D