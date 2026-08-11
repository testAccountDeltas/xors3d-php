Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

xCreateLog(LOG_HTML, LOG_INFO, "Sensor.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 65
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
xNameEntity(ground, "ground")

Global sensor = xCreateCube()
xEntityColor(sensor, 255, 32, 32)
xScaleEntity(sensor, 10.0, 4.0, 10.0)
xEntityAddBoxShape(sensor, 0.0)
xPositionEntity(sensor, 0.0, 4.0, 0.0)
xEntityAlpha(sensor, .15)
xEntitySetCollisionGroup(sensor, 1)
xEntitySetContactGroup(sensor, 1)
xNameEntity(sensor, "Sensor")

Global cubeRed = xCreateCube()
xEntityColor(cubeRed, 255, 32, 32)
xScaleEntity(cubeRed, 3.0, 3.0, 3.0)
xEntityAddBoxShape(cubeRed, 1.0)
xPositionEntity(cubeRed, -5.0, 15.0, -5.0)
xEntitySetCollisionGroup(cubeRed, 2)
xEntitySetContactGroup(cubeRed, 2)
xNameEntity(cubeRed, "cubeRed")

Global cubeBlue = xCreateCube()
xEntityColor(cubeBlue, 32, 127, 255)
xScaleEntity(cubeBlue, 3.0, 3.0, 3.0)
xEntityAddBoxShape(cubeBlue, 1.0)
xPositionEntity(cubeBlue, 5.0, 15.0, 5.0)
xEntitySetCollisionGroup(cubeBlue, 2)
xNameEntity(cubeBlue, "cubeBlue")

xPhysicsSetCollisionFilter(1, 2, False) ; Sensor won't collide with the cubes
xPhysicsSetContactFilter(2, 1, False) ; cubeRed won't report about contact with Sensor
;xSetContactFilter(1, 2, False) ; Sensor won't report about contact with cubeRed

xPhysicsDebugRender(PXDD_WIREFRAME + PXDD_CONTACTS)

Global reportContact  = False

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	If xKeyHit(KEY_ENTER)
		reportContact = Not reportContact
		xPhysicsSetContactFilter(2, 1, reportContact) ; switch 'cubeRed-Sensor' contact reporting 
	EndIf
	
	UpdateCamera(0.25)
	Update()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Press <Enter> to switch 'cubeRed-Sensor' contact reporting")
	PrintContacts(sensor, 10, 100)
	PrintContacts(cubeBlue, 300, 100)
	PrintContacts(cubeRed, 600, 100)
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
	xEntityWakeUp(cubeBlue)
	xEntityApplyImpulse(cubeBlue, 0.0, 0.0, 1.0, -3.0, 0.0, 0.0, False, False)
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
;	size# = 0.1 + Abs(Sin(MilliSecs() * 0.01)) * 10.0
;	xScaleEntity(sensor, size, 4.0, size)
End Function

Function PrintContacts(entity%, posx% = 10, posy% = 100)
	Local contactEntity% = 0
	xText(posx, posy, xEntityName(entity) + ":")
	For i = 0 To xEntityCountContacts(entity) - 1
		contactEntity = xEntityGetContact(entity, i)
		xText(posx, posy + (i + 1) * 20, "Contact #" + i + ": " + xEntityName(contactEntity) + " (imp: " + xEntityGetContactImpulse(entity, i) + ")")
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D