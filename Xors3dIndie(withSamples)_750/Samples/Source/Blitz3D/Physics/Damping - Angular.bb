Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 25
Const maxCameraDistance# = 75

xCreateLog(LOG_HTML, LOG_INFO, "Damping - angular.html")

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
xRotateEntity(ground, -25, 0, 0)
xScaleEntity(ground, 25, 1, 25)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)
xEntitySetFriction(ground, 0.5)

Global ballRed = xCreateSphere()
xRotateEntity(ballRed, -45, 0, 0)
xPositionEntity(ballRed, -10, 15, 20)
xEntityColor(ballRed, 255, 32, 32)
xEntityTexture(ballRed, tex)
xEntityAddSphereShape(ballRed, 1)
xEntitySetFriction(ballRed, 0.5)
xEntitySetDamping(ballRed, 0.0, 0.75)

Global ballGreen = xCreateSphere()
xRotateEntity(ballGreen, -45, 0, 0)
xPositionEntity(ballGreen, 10, 15, 20)
xEntityColor(ballGreen, 32, 255, 128)
xEntityTexture(ballGreen, tex)
xEntityAddSphereShape(ballGreen, 1)
xEntitySetFriction(ballGreen, 0.5)
xEntitySetDamping(ballGreen, 0.0, 0.0)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Press <Space> to reset")
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
	xEntityReleaseForces( ballRed)
	xEntityReleaseForces( ballGreen)
	xPositionEntity( ballRed, -10, 15, 20)
	xPositionEntity( ballGreen, 10, 15, 20)
	xRotateEntity(ballRed, -45, 0, 0)
	xRotateEntity(ballGreen, -45, 0, 0)
	xEntityWakeUp( ballRed)
	xEntityWakeUp( ballGreen)
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
	xCameraProject(camera, xEntityX(ballRed, True), xEntityY(ballRed, True) + 2.5, xEntityZ(ballRed, True))
	xText( xProjectedX(), xProjectedY() - 30, "Angular damping: " + xEntityGetAngularDamping(ballRed))
	xText( xProjectedX(), xProjectedY() - 10, "Angular velocity: " + xEntityGetAngularVelocityX(ballRed, False))
	xCameraProject(camera, xEntityX(ballGreen, True), xEntityY(ballGreen, True) + 2.5, xEntityZ(ballGreen, True))
	xText( xProjectedX(), xProjectedY() - 30, "Angular damping: " + xEntityGetAngularDamping(ballGreen))
	xText( xProjectedX(), xProjectedY() - 10, "Angular velocity: " + xEntityGetAngularVelocityX(ballGreen, False))
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D