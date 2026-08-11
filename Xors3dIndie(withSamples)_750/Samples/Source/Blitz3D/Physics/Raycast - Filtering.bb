Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

Const blueGroup% = 1
Const redGroup% = 2

xCreateLog(LOG_HTML, LOG_INFO, "Raycast - Filtering.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 70
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
xScaleTexture(tex, 1.0 / 8.0, 1.0 / 8.0)

Global ground = xCreateCube()
xScaleEntity(ground, 100, 1, 100)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)

Global cube = xCreateCube()
xNameEntity(cube, "Cube")
xEntityReceiveShadows(cube, lightBlue, False)
xEntityTexture(cube, tex)
xScaleEntity(cube, 5.0, 5.0, 5.0)
xPositionEntity(cube, -15.0, 7.0, -15.0)
xEntityAddBoxShape(cube, 1.0)
xEntitySetRaycastGroup(cube, blueGroup)

Global torus = xCreateTorus(16, 1, 0.5)
xNameEntity(torus, "Torus")
xEntityReceiveShadows(torus, lightBlue, False)
xEntityTexture(torus, tex)
xScaleMesh(torus, 4.0, 4.0, 4.0)			; don't use xScaleEntity with a concave body. It's a temporary issue
xTurnEntity(torus, 0.0, -45.0, 0.0)
xPositionEntity(torus, 15.0, 8.0, 15.0)
xEntityAddConcaveShape(torus, 1.0)
xEntitySetRaycastGroup(torus, redGroup)

Global cylinder = xCreateCylinder()
xNameEntity(cylinder, "Cylinder")
xEntityReceiveShadows(cylinder, lightBlue, False)
xEntityTexture(cylinder, tex)
xScaleEntity(cylinder, 5.0, 5.0, 5.0)
xPositionEntity(cylinder, 15.0, 7.0, -15.0)
xEntityAddCylinderShape(cylinder, 1.0)
xEntitySetRaycastGroup(cylinder, blueGroup)

Global sphere = xCreateSphere()
xNameEntity(sphere, "Sphere")
xEntityReceiveShadows(sphere, lightBlue, False)
xEntityTexture(sphere, tex)
xScaleEntity(sphere, 5.0, 5.0, 5.0)
xPositionEntity(sphere, -15.0, 7.0, 15.0)
xEntityAddSphereShape(sphere, 1.0)
xEntitySetRaycastGroup(sphere, redGroup)

Global cone = xCreateCone()
xNameEntity(cone, "Cone")
xEntityReceiveShadows(cone, lightBlue, False)
xEntityTexture(cone, tex)
xScaleEntity(cone, 5.0, 5.0, 5.0)
xPositionEntity(cone, 0.0, 7.0, 0.0)
xEntityAddConeShape(cone, 1.0)

xPhysicsSetRaycastFilter(blueGroup, redGroup, False)
xPhysicsSetRaycastFilter(redGroup, blueGroup, False)

Global pointerBlue = xCreateCone()
xEntityColor(pointerBlue, 32, 32, 255)
xRotateMesh(pointerBlue, 90.0, 0.0, 0.0)
xScaleMesh(pointerBlue, 0.5, 0.5, 0.5)
xPositionEntity(pointerBlue, 25.0, 6.0, 25.0)
Global rayBlue = xCreateLine3D(25.0, 6.0, 25.0, 25.0, 6.0, -45.0, 32, 32, 255, 255, True)
xEntityParent(rayBlue, pointerBlue)

Global pointerRed = xCreateCone()
xEntityColor(pointerRed, 255, 32, 32)
xRotateMesh(pointerRed, 90.0, 0.0, 0.0)
xScaleMesh(pointerRed, 0.5, 0.5, 0.5)
xPositionEntity(pointerRed, -25.0, 6.0, -25.0)
xRotateEntity(pointerRed, 180.0, 0.0, 0.0)
Global rayRed = xCreateLine3D(-25.0, 6.0, -25.0, -25.0, 6.0, 45.0, 255, 32, 32, 255, True)
xEntityParent(rayRed, pointerRed)

Global pointerSpeed# = -0.1

Global hitBlue = xCreateSphere()
xEntityColor(hitBlue, 32, 32, 128)
xEntityFX(hitBlue, FX_FULLBRIGHT)
xScaleEntity(hitBlue, 0.25, 0.25, 0.25)
xHideEntity(hitBlue)

Global hitRed = xCreateSphere()
xEntityColor(hitRed, 128, 32, 32)
xEntityFX(hitRed, FX_FULLBRIGHT)
xScaleEntity(hitRed, 0.25, 0.25, 0.25)
xHideEntity(hitRed)

xPhysicsDebugRender PXDD_NO 

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateCamera(0.25)
	Update()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
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

Function Update()
	xEntityColor(cube, 32, 32, 64)
	xEntityColor(torus, 64, 32, 32)
	xEntityColor(cylinder, 32, 32, 64)
	xEntityColor(sphere, 64, 32, 32)
	xEntityColor(cone, 64, 64, 64)
	xHideEntity(hitBlue)
	xHideEntity(hitRed)
	
	If pointerSpeed < 0.0
		If xEntityYaw(pointerBlue, True) <= -90.0
			pointerSpeed = -pointerSpeed
		EndIf
	Else
		If xEntityYaw(pointerBlue, True) >= 0.0
			pointerSpeed = -pointerSpeed
		EndIf
	EndIf
	
	xTurnEntity(pointerBlue, 0.0, pointerSpeed, 0.0)
	xTurnEntity(pointerRed, 0.0, -pointerSpeed, 0.0)
	
	Local raySX# = xLine3DOriginX(rayBlue, True)
	Local raySY# = xLine3DOriginY(rayBlue, True)
	Local raySZ# = xLine3DOriginZ(rayBlue, True)
	Local rayDX# = xLine3DNodeX(rayBlue, 0, True)
	Local rayDY# = xLine3DNodeY(rayBlue, 0, True)
	Local rayDZ# = xLine3DNodeZ(rayBlue, 0, True)
	xPhysicsRayCast(raySX, raySY, raySZ, rayDX, rayDY, rayDZ, PXRC_SINGLE, blueGroup)
	Local lHitEntityBlue = xPhysicsGetHitEntity()
	If lHitEntityBlue
		Local hx# = xPhysicsGetHitPointX()
		Local hy# = xPhysicsGetHitPointY()
		Local hz# = xPhysicsGetHitPointZ()
		xShowEntity(hitBlue)
		xPositionEntity(hitBlue, hx, hy, hz, True)
		xEntityColor(lHitEntityBlue, 32, 32, 255)
	EndIf
	
	raySX# = xLine3DOriginX(rayRed, True)
	raySY# = xLine3DOriginY(rayRed, True)
	raySZ# = xLine3DOriginZ(rayRed, True)
	rayDX# = xLine3DNodeX(rayRed, 0, True)
	rayDY# = xLine3DNodeY(rayRed, 0, True)
	rayDZ# = xLine3DNodeZ(rayRed, 0, True)
	xPhysicsRayCast(raySX, raySY, raySZ, rayDX, rayDY, rayDZ, PXRC_SINGLE, redGroup)
	Local lHitEntityRed = xPhysicsGetHitEntity()
	If lHitEntityRed
		hx# = xPhysicsGetHitPointX()
		hy# = xPhysicsGetHitPointY()
		hz# = xPhysicsGetHitPointZ()
		xShowEntity(hitRed)
		xPositionEntity(hitRed, hx, hy, hz, True)
		If lHitEntityBlue = lHitEntityRed
			xEntityColor(lHitEntityRed, 255, 192, 255)
		Else
			xEntityColor(lHitEntityRed, 255, 32, 32)
		EndIf
	EndIf
End Function