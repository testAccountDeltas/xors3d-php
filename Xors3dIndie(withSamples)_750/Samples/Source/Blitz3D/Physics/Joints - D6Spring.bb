Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 190

xCreateLog(LOG_HTML, LOG_INFO, "Joints - D6Spring.html")

xGraphics3D 1024, 768, 32, False, True

xHidePointer()

xCreateDSS 1024, 1024

Global activeBalloon% = 0
Global forceX# = 0.0, forceY# = 1.0, forceZ# = 0.0
Global forceDX# = 0.0, forceDY# = 0.0, forceDZ# = 0.0
Global timer% = 0

Global cameraDistance# = 80
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera, 0.0, 5.0, -cameraDistance
xCameraClsColor camera, 96, 128, 192
xRotateEntity camPiv, maxCameraAngle / 3, 45, 0
xCameraEnableShadows camera

lightRed = xcreatelight()
xRotateEntity lightRed, 60, 15, 0
xLightColor lightRed, 255, 128, 128

lightBlue = xcreatelight()
xRotateEntity lightBlue, 60, 195, 0
xLightColor lightBlue, 128, 128, 255
xLightEnableShadows lightBlue, True
xLightShadowEpsilons lightBlue, 0.0001, 0.0001

xSetShadowParams(2, 0.75)
xInitShadows(1024, 0, 0)

tex = CreateCheckerTexture()
xScaleTexture(tex, 0.1, 0.1)

Global ground = xCreateCube()
xScaleEntity(ground, 100, 1, 100)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)

Global border = xCreateCube()
xHideEntity(border)
xFlipMesh(border)
xScaleEntity(border, 100.0, 50.0, 100.0)
xPositionEntity(border, 0.0, xEntityScaleY(border), 0.0)
xEntityAddTrimeshShape(border)

Global cubeRed = xCreateCube()
xEntityColor(cubeRed, 255, 32, 32)
xPositionEntity(cubeRed, 5.0, 15.0, 0.0)
xEntityAddBoxShape(cubeRed, 0.0)

Global cubeBlue = xCreateCube()
xEntityColor(cubeBlue, 32, 32, 255)
xPositionEntity(cubeBlue, -5.0, 15.0, -5.0)
xEntityAddBoxShape(cubeBlue, 1.0)

Global joint = xCreateD6SpringJoint(cubeRed, cubeBlue, 0.0, 25.0, 0.0, 0.0, 25.0, 0.0, 1, 1)
xJointD6SetLinearLimits(joint, -10.0, -10.0, -10.0, 10.0, 10.0, 10.0)
xJointD6SpringSetParam(joint, 0, 1, 0.50, 5.0)
xJointD6SpringSetParam(joint, 1, 1, 0.50, 5.0)
xJointD6SpringSetParam(joint, 2, 1, 0.50, 5.0)
xEntityApplyCentralImpulse(cubeBlue, 10.0, 0.0, 0.0)

xPhysicsDebugRender(PXDD_JOINTS + PXDD_JOINT_LIMITS)

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateCamera(0.25)
	UpdateControl()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xFlip()	
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
End Function

Function UpdateControl()
	If xKeyHit(KEY_SPACE)
		xEntityApplyTorqueImpulse(cubeBlue, 1.0, 2.0, 3.0)
	EndIf
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