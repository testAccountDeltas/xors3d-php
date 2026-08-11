Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

Global hitName$ = "None"
Global hitDistance# = -1
Global hitMarkerX#, hitMarkerY#

xCreateLog(LOG_HTML, LOG_INFO, "Raycast - Single.html")

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
xEntityColor(cube, 32, 32, 255)
xEntityTexture(cube, tex)
xScaleEntity(cube, 5.0, 5.0, 5.0)
xPositionEntity(cube, -15.0, 7.0, -15.0)
xEntityAddBoxShape(cube, 1.0)

Global torus = xCreateTorus(16, 1, 0.5)
xNameEntity(torus, "Torus")
xEntityReceiveShadows(torus, lightBlue, False)
xEntityColor(torus, 255, 32, 255)
xEntityTexture(torus, tex)
xScaleMesh(torus, 4.0, 4.0, 4.0)			; don't use xScaleEntity with a concave body. It's a temporary issue
xTurnEntity(torus, 0.0, -45.0, 0.0)
xPositionEntity(torus, 15.0, 8.0, 15.0)
xEntityAddConcaveShape(torus, 1.0)

Global cylinder = xCreateCylinder()
xNameEntity(cylinder, "Cylinder")
xEntityReceiveShadows(cylinder, lightBlue, False)
xEntityColor(cylinder, 255, 32, 32)
xEntityTexture(cylinder, tex)
xScaleEntity(cylinder, 5.0, 5.0, 5.0)
xPositionEntity(cylinder, 15.0, 7.0, -15.0)
xEntityAddCylinderShape(cylinder, 1.0)

Global sphere = xCreateSphere()
xNameEntity(sphere, "Sphere")
xEntityReceiveShadows(sphere, lightBlue, False)
xEntityColor(sphere, 255, 255, 32)
xEntityTexture(sphere, tex)
xScaleEntity(sphere, 5.0, 5.0, 5.0)
xPositionEntity(sphere, -15.0, 7.0, 15.0)
xEntityAddSphereShape(sphere, 1.0)

Global cone = xCreateCone()
xNameEntity(cone, "Cone")
xEntityReceiveShadows(cone, lightBlue, False)
xEntityColor(cone, 255, 255, 255)
xEntityTexture(cone, tex)
xScaleEntity(cone, 5.0, 5.0, 5.0)
xPositionEntity(cone, 0.0, 7.0, 0.0)
xEntityAddConeShape(cone, 1.0)

Global pointer = xCreateCone()
xEntityColor(pointer, 32, 255, 32)
xRotateMesh(pointer, 90.0, 0.0, 0.0)
xScaleMesh(pointer, 0.5, 0.5, 0.5)
xPositionEntity(pointer, 25.0, 6.0, 25.0)
Global ray = xCreateLine3D(25.0, 6.0, 25.0, 25.0, 6.0, -45.0, 32, 255, 32, 255, True)
xEntityParent(ray, pointer)
Global pointerSpeed# = -0.1

Global hitPos = xCreateSphere()
xEntityColor(hitPos, 32, 32, 32)
xEntityFX(hitPos, FX_FULLBRIGHT)
xScaleEntity(hitPos, 0.25, 0.25, 0.25)
xHideEntity(hitPos)

xPhysicsDebugRender PXDD_NO 

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateCamera(0.25)
	Update()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Hit entity: " + hitName)
	If (hitDistance > 0.0)
		xText(hitMarkerX, hitMarkerY, hitDistance)
	EndIf
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
	xEntityColor(cube, 32, 32, 255)
	xEntityColor(torus, 255, 32, 255)
	xEntityColor(cylinder, 255, 32, 32)
	xEntityColor(sphere, 255, 255, 32)
	xEntityColor(cone, 255, 255, 255)
	xHideEntity(hitPos)
	
	hitName = "None"
	hitDistance = -1
	
	If pointerSpeed < 0.0
		If xEntityYaw(pointer, True) <= -90.0
			pointerSpeed = -pointerSpeed
		EndIf
	Else
		If xEntityYaw(pointer, True) >= 0.0
			pointerSpeed = -pointerSpeed
		EndIf
	EndIf
	
	xTurnEntity(pointer, 0.0, pointerSpeed, 0.0)
	
	Local raySX# = xLine3DOriginX(ray, True)
	Local raySY# = xLine3DOriginY(ray, True)
	Local raySZ# = xLine3DOriginZ(ray, True)
	Local rayDX# = xLine3DNodeX(ray, 0, True)
	Local rayDY# = xLine3DNodeY(ray, 0, True)
	Local rayDZ# = xLine3DNodeZ(ray, 0, True)
	xPhysicsRayCast(raySX, raySY, raySZ, rayDX, rayDY, rayDZ)
	Local lHitEntity = xPhysicsGetHitEntity()
	If lHitEntity
		Local hx# = xPhysicsGetHitPointX()
		Local hy# = xPhysicsGetHitPointY()
		Local hz# = xPhysicsGetHitPointZ()
		xShowEntity(hitPos)
		xPositionEntity(hitPos, hx, hy, hz, True)
		xEntityColor(lHitEntity, 32, 255, 32)
		hitName = xEntityName(lHitEntity)
		hitDistance = xPhysicsGetHitDistance()
		xCameraProject(camera, hx, hy + 2.0, hz)
		hitMarkerX = xProjectedX()
		hitMarkerY = xProjectedY()
	EndIf
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D