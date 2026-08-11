Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

xCreateLog(LOG_HTML, LOG_INFO, "Concave proxy body.html")

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

Global proxy = xCreateTorus(4, 1, 0.5)
xScaleMesh(proxy, 4.0, 4.0, 4.0)			; don't use xScaleEntity with a concave body. It's a temporary issue

Global concave = xCreateTorus(16, 1, 0.5)
;xScaleEntity(concave, 4.0, 4.0, 4.0)
xScaleMesh(concave, 4.0, 4.0, 4.0)			; don't use xScaleEntity with a concave body. It's a temporary issue
xEntityAddConcaveShapeProxy(concave, proxy, 100.0)
xEntityColor(concave, 255, 128, 32)
xEntityTexture(concave, tex)
xFreeEntity(proxy)
Reset()

Global column = xCreateCylinder()
xScaleEntity(column, 1.0, 5.0, 1.0)
xEntityColor(column, 32, 128, 255)
xPositionEntity(column, 0.0, 5.0, 0.0)
xEntityAddCylinderShape(column, 0.0)
xEntityTexture(column, tex)

xPhysicsDebugRender(PXDD_WIREFRAME)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Press <Space> to reset scene")
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
	xEntityReleaseForces(concave)
	xPositionEntity(concave, 0.0, 20.0, 0.0)
	xRotateEntity(concave, -35.0, 0.0, 0.0)
	xEntityWakeUp(concave)
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