Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 25
Const maxCameraDistance# = 75

xCreateLog(LOG_HTML, LOG_INFO, "Restitution.html")

xGraphics3D(1024, 768, 32, False, True)
xHidePointer()

xCreateDSS(1024, 1024)

Global cameraDistance# = 35
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xPositionEntity(camera,0,0, -cameraDistance)
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
xEntitySetRestitution(ground, 0.5)

Global cubeRed = xCreateCube()
xPositionEntity(cubeRed, -5, 15, -5)
xEntityColor(cubeRed, 255, 32, 32)
xEntityTexture(cubeRed, tex)
xEntityAddBoxShape(cubeRed, 1)
xEntitySetRestitution(cubeRed, 0.5)
xEntitySetAngularFactor(cubeRed, 0.0, 1.0, 0.0)

Global cubeOrange = xCreateCube()
xPositionEntity(cubeOrange, 0, 15, 0)
xEntityColor(cubeOrange, 255, 128, 32)
xEntityTexture(cubeOrange, tex)
xEntityAddBoxShape(cubeOrange, 1)
xEntitySetRestitution(cubeOrange, 0.75)
xEntitySetAngularFactor(cubeOrange, 0.0, 1.0, 0.0)

Global cubeGreen = xCreateCube()
xPositionEntity(cubeGreen, 5, 15, 5)
xEntityColor(cubeGreen, 32, 255, 128)
xEntityTexture(cubeGreen, tex)
xEntityAddBoxShape(cubeGreen, 1)
xEntitySetRestitution(cubeGreen, 1.0)
xEntitySetAngularFactor(cubeGreen, 0.0, 1.0, 0.0)

While Not xKeyHit(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Ground: " + xEntityGetRestitution(ground))
	xText(10, 50, "Press <Space> to reset")
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
	xPositionEntity( cubeRed, -5, 15, -5)
	xPositionEntity( cubeOrange, 0, 15, 0)
	xPositionEntity( cubeGreen, 5, 15, 5)
	xEntityWakeUp( cubeRed)
	xEntityWakeUp( cubeOrange)
	xEntityWakeUp( cubeGreen)
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
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetRestitution(cubeRed))
	xCameraProject(camera, xEntityX(cubeOrange, True), xEntityY(cubeOrange, True) + 2.5, xEntityZ(cubeOrange, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetRestitution(cubeOrange))
	xCameraProject(camera, xEntityX(cubeGreen, True), xEntityY(cubeGreen, True) + 2.5, xEntityZ(cubeGreen, True))
	xText( xProjectedX(), xProjectedY() - 20, xEntityGetRestitution(cubeGreen))
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D