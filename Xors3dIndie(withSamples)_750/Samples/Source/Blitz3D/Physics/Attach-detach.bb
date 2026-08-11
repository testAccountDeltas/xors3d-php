Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

xCreateLog(LOG_HTML, LOG_INFO, "Attach-detach.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 55
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

Global box = xCreateCube()
xRotateEntity(box, 0, -45, 0)
xScaleEntity(box, 2, 2, 2)
xPositionEntity( box, 4, 15, 4)
xEntityColor(box, 255, 128, 32)
xEntityTexture(box, tex)
xEntityAddBoxShape(box, 1)

Global ball = xCreateSphere()
xRotateEntity(ball, 0, -45, 0)
xScaleEntity(ball, 2, 2, 2)
xPositionEntity( ball, -4, 15, -4)
xEntityColor(ball, 32, 128, 255)
xEntityTexture(ball, tex)
xEntityAddSphereShape(ball, 1)

Global follower = xCreateCube()
xEntityColor(follower, 0, 255, 0)
xPositionEntity( follower, -4, 18, -4)
xEntityParent follower, ball

Global follower2 = xCreateCube()
xEntityColor(follower2, 255, 255, 0)
xPositionEntity( follower2, -4, 20, -4)
xEntityParent follower2, follower

xPhysicsDebugRender(PXDD_WIREFRAME)
Global boxBody  = 0
Global ballBody = 0

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyDown(KEY_SPACE)
		xEntityApplyImpulse(box, 0, 1, 0, 0, 0.5, -2, 0, 0)
		xEntityApplyImpulse(ball, 0, -1, 0, 0, 0.5, -2, 0, 0)
	EndIf
	
	If xKeyHit(KEY_ENTER)
		boxBody = xEntityDetachBody(box)
		ballBody = xEntityDetachBody(ball)
		xEntityAttachBody(box, ballBody)
		xEntityAttachBody(ball, boxBody)
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "Press <Space> to add impulse")
	xText(10, 30, "Press <Enter> to switch entities' bodies")
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