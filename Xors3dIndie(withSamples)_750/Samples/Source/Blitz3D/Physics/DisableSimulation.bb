Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 25
Const maxCameraDistance# = 75

xCreateLog(LOG_HTML, LOG_INFO, "DisableSimulation.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 50
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera,0,0, -cameraDistance
xCameraClsColor camera, 96, 128, 192
xRotateEntity camPiv, maxCameraAngle / 2, 45, 0
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
xEntitySetRestitution(ground, 0.5)

Global redBox = xCreateCube()
xRotateEntity(redBox, 0, -45, 0)
xScaleEntity(redBox, 2, 2, 2)
xPositionEntity(redBox, 0.0, 15.0, 0.0)
xEntityColor(redBox, 255, 128, 32)
xEntityTexture(redBox, tex)
xEntityAddBoxShape(redBox, 1)
xEntitySetRestitution(redBox, 0.25)
xEntityApplyTorqueImpulse(redBox, 0.0, 5.0, 0.0)

Global blueBox = xCreateCube()
xRotateEntity(blueBox, 0, -45, 0)
xScaleEntity(blueBox, 2, 2, 2)
xPositionEntity( blueBox, 0.0, 25, 0.0)
xEntityColor(blueBox, 32, 128, 255)
xEntityTexture(blueBox, tex)
xEntityAddBoxShape(blueBox, 1)
xEntitySetRestitution(blueBox, 0.25)

Global simulationDisabled% = 0

xPhysicsDebugRender(PXDD_WIREFRAME)

While Not xKeyDown(KEY_ESCAPE)
	
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	If xKeyHit(KEY_ENTER)
		simulationDisabled = 1 - simulationDisabled
		xEntityDisableSimulation(redBox, simulationDisabled)
		xEntityWakeUp(redBox)
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "Press <Space> to reset")
	If simulationDisabled
		xText(10, 30, "Press <Enter> to ENABLE simulation of the redBox")
	Else
		xText(10, 30, "Press <Enter> to DISABLE simulation of the redBox")
	EndIf
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
	xEntityReleaseForces(redBox)
	xEntityReleaseForces(blueBox)
	xRotateEntity(redBox, 0.0, -45.0, 0.0)
	xRotateEntity(blueBox, 0.0, -45.0, 0.0)
	xPositionEntity(redBox, 0.0, 15.0, 0.0)
	xPositionEntity( blueBox, 0.0, 25.0, 0.0)
	xEntityWakeUp(redBox)
	xEntityWakeUp(blueBox)
	xEntityApplyTorqueImpulse(redBox, 0.0, 5.0, 0.0)
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