Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 190

xCreateLog(LOG_HTML, LOG_INFO, "Joints - D6.html")

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

Dim cubeBlue(5)
Dim cubeRed(5)
Dim joint(5)

cubeRed(0) = xCreateCube()
xEntityColor(cubeRed(0), 255, 32, 32)
xPositionEntity(cubeRed(0), 5.0, 15.0, 0.0)
xEntityAddBoxShape(cubeRed(0), 0.0)
cubeBlue(0) = xCreateCube()
xEntityColor(cubeBlue(0), 32, 32, 255)
xPositionEntity(cubeBlue(0), -5.0, 15.0, 0.0)
xEntityAddBoxShape(cubeBlue(0), 1.0)
joint(0) = xCreateD6Joint(cubeRed(0), cubeBlue(0), 0.0, 15.0, 0.0, 0.0, 15.0, 0.0, 1, 1)
xJointD6SetLinearLimits(joint(0), -10.0, 0.0, -10.0, 10.0, 0.0, 10.0)
xJointDisableCollisions(joint(0), 1)
xEntityApplyTorqueImpulse(cubeBlue(0), 1.0, 2.0, 3.0)

cubeRed(1) = xCreateCube()
xEntityColor(cubeRed(1), 255, 32, 32)
xPositionEntity(cubeRed(1), 35.0, 15.0, 0.0)
xEntityAddBoxShape(cubeRed(1), 0.0)
cubeBlue(1) = xCreateCube()
xEntityColor(cubeBlue(1), 32, 32, 255)
xPositionEntity(cubeBlue(1), 30.0, 20.0, 0.0)
xEntityAddBoxShape(cubeBlue(1), 1.0)
joint(1) = xCreateD6Joint(cubeRed(1), cubeBlue(1), -5.0, 5.0, 0.0, 5.0, -5.0, 0.0)
xJointD6SetLinearLimits(joint(1), -10.0, -10.0, -10.0, 10.0, 10.0, 10.0)
xJointDisableCollisions(joint(1), 1)
xEntityApplyCentralImpulse(cubeBlue(1), Rnd(-10.0, 10.0), Rnd(-10.0, 10.0), Rnd(-10.0, 10.0))

cubeRed(2) = xCreateCube()
xEntityColor(cubeRed(2), 255, 32, 32)
xPositionEntity(cubeRed(2), 0.0, 15.0, 35.0)
xEntityAddBoxShape(cubeRed(2), 0.0)
cubeBlue(2) = xCreateCube()
xEntityColor(cubeBlue(2), 32, 32, 255)
xPositionEntity(cubeBlue(2), 0.0, 20.0, 30.0)
xEntityAddBoxShape(cubeBlue(2), 1.0)
joint(2) = xCreateD6Joint(cubeRed(2), cubeBlue(2), -5.0, 5.0, 0.0, 0.0, -5.0, 0.0)

cubeRed(3) = xCreateCube()
xEntityColor(cubeRed(3), 255, 32, 32)
xPositionEntity(cubeRed(3), -35.0, 15.0, 0.0)
xEntityAddBoxShape(cubeRed(3), 0.0)
cubeBlue(3) = xCreateCube()
xEntityColor(cubeBlue(3), 32, 32, 255)
xPositionEntity(cubeBlue(3), -30.0, 10.0, 0.0)
xEntityAddBoxShape(cubeBlue(3), 1.0)
joint(3) = xCreateD6Joint(cubeRed(3), cubeBlue(3), -10.0, 0.0, 0.0, 0.0, -5.0, 0.0)
xJointD6SetLinearLimits(joint(3), -10.0, 0.0, 0.0, 10.0, 0.0, 0.0)
xJointD6SetAngularLimits(joint(3), 0.0, 0.0, -180.0, 0.0, 0.0, 180.0)
xJointDisableCollisions(joint(3), 1)

cubeRed(4) = xCreateCube()
xEntityColor(cubeRed(4), 255, 32, 32)
xPositionEntity(cubeRed(4), 0.0, 15.0, -35.0)
xEntityAddBoxShape(cubeRed(4), 0.0)
cubeBlue(4) = xCreateCube()
xEntityColor(cubeBlue(4), 32, 32, 255)
xPositionEntity(cubeBlue(4), 0.0, 20.0, -30.0)
xEntityAddBoxShape(cubeBlue(4), 1.0)
joint(4) = xCreateD6Joint(cubeRed(4), cubeBlue(4), -5.0, 20.0, -30.0, -5.0, 20.0, -30.0, 1, 1)
xJointD6SetLinearLimits(joint(4), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
xJointD6SetAngularLimits(joint(4), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

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