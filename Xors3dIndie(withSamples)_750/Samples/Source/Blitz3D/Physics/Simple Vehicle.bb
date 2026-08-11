Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 290

xCreateLog(LOG_HTML, LOG_INFO, "Simple Vehicle.html")

xGraphics3D 1024, 768, 32, False, True

xHidePointer()

xCreateDSS 1024, 1024

Global cameraMode% = 0
Global forceX# = 0.0, forceY# = 1.0, forceZ# = 0.0
Global forceDX# = 0.0, forceDY# = 0.0, forceDZ# = 0.0
Global timer% = 0

Global cameraDistance# = 180
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera, 0.0, 25.0, -cameraDistance
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
xScaleEntity(ground, 250, 1, 250)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)

Global border = xCreateCube()
xHideEntity(border)
xFlipMesh(border)
xScaleEntity(border, xEntityScaleX(ground) - 2.0, 50.0, xEntityScaleZ(ground) - 2.0)
xPositionEntity(border, 0.0, xEntityScaleY(border), 0.0)
xEntityAddTrimeshShape(border)

Const steerStep# = 1.7
Const steerClamp# = 32.2
Const maxBrake# = 100.0
Const maxEngine# = 2500.0
Const engineStep# = 25.0

Global steering# = 0.0
Global engineForce# = 0.0
Global brakeForce# = 0.0


Global chassis = xCreateCube()
xScaleEntity(chassis, 4.0, 1.0, 7.0)
xPositionEntity(chassis, 0.0, 4.0, 0.0)
xEntityColor(chassis, 32, 64, 255)
xEntityAddBoxShape(chassis, 800.0)
xEntityCreateVehicle(chassis)
xEntityDisableSleeping(chassis)

Dim wheel(4)
wheel(0) = xCreateCylinder()
xRotateMesh(wheel(0), 0.0, 0.0, 90.0)
xEntityColor(wheel(0), 255, 32, 64)

wheel(1) = xCopyEntity(wheel(0))
wheel(2) = xCopyEntity(wheel(0))
wheel(3) = xCopyEntity(wheel(0))

Global flWheel = xEntityAddWheel(chassis, wheel(0))
Global frWheel = xEntityAddWheel(chassis, wheel(1))
Global blWheel = xEntityAddWheel(chassis, wheel(2))
Global brWheel = xEntityAddWheel(chassis, wheel(3))

xEntityWheelSetAxle(chassis, 0, -1.0, 0.0, 0.0)
xEntityWheelSetAxle(chassis, 1, -1.0, 0.0, 0.0)
xEntityWheelSetAxle(chassis, 2, -1.0, 0.0, 0.0)
xEntityWheelSetAxle(chassis, 3, -1.0, 0.0, 0.0)

xEntityWheelSetConnectionPoint(chassis, 0, -4.0, -1.2, 6.0)
xEntityWheelSetConnectionPoint(chassis, 1, 4.0, -1.2, 6.0)
xEntityWheelSetConnectionPoint(chassis, 2, -4.0, -1.2, -6.0)
xEntityWheelSetConnectionPoint(chassis, 3, 4.0, -1.2, -6.0)

For i = 0 To xEntityCountWheels(chassis) - 1
	xEntityWheelSetRadius(chassis, i, 1.0)
	xEntityWheelSetMaxSuspensionForce(chassis, i, 6000.0)
	xEntityWheelSetSuspensionLength(chassis, i, 1.5)
	xEntityWheelSetSuspensionStiffness(chassis, i, 3.8)
	xEntityWheelSetSuspensionDamping(chassis, i, 0.22)
	xEntityWheelSetSuspensionCompression(chassis, i, 0.3)
	xEntityWheelSetFriction(chassis, i, 1000)
	xEntityWheelSetRollInfluence(chassis, i, 0.18)
Next

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateControl()
	xUpdateWorld()
	UpdateCamera(0.25)
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Arrows: steer, forward / reverse acceleration")
	xText(10, 50, "Space: handbrake")
	xText(10, 70, "Enter: switch camera mode")
	xText(10, 90, engineForce)
	xFlip()	
Wend
End

Function UpdateCamera(ViewSensivity#)
	If cameraMode = 0
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
	Else
		xTFormPoint(0.0, 15.0, -7.0, chassis, 0)
		xPositionEntity(camPiv, xTFormedX(), xTFormedY(), xTFormedZ())
		xPointEntity(camPiv, chassis)
	EndIf
End Function

Function Reset()
End Function

Function UpdateControl()
	
	If xKeyHit(KEY_ENTER)
		cameraMode = 1 - cameraMode
	EndIf
	
	brakeForce = 0.0
	If xKeyDown(KEY_UP)
		If engineForce < 0
			brakeForce = maxBrake *  0.25
			engineForce = engineForce * 0.25
		Else
			engineForce = engineForce + engineStep
		EndIf
		If engineForce > maxEngine
			engineForce = maxEngine
		EndIf
	ElseIf xKeyDown(KEY_DOWN)
		If engineForce > 0
			brakeForce = maxBrake *  0.25
			engineForce = engineForce * 0.25
		Else
			engineForce = engineForce - engineStep
		EndIf
		
		If engineForce < -maxEngine
			engineForce = -maxEngine
		EndIf
	Else
		engineForce = engineForce * 0.65
		If Abs(engineForce) < 1
			engineForce = 0
		EndIf
	EndIf
	
	If xKeyDown(KEY_LEFT)
		steering = steering - steerStep
		If steering < -steerClamp
			steering = -steerClamp
		EndIf
	ElseIf xKeyDown(KEY_RIGHT)
		steering = steering + steerStep
		If steering > steerClamp
			steering = steerClamp
		EndIf
	Else
		steering = steering *  0.65
		If Abs(steering) < 1.0
			steering = 0.0
		EndIf
	EndIf
	
	If xKeyDown(KEY_SPACE)
		brakeForce = maxBrake
		engineForce = 0.0
	EndIf
	
	xEntityWheelSetEngineForce(chassis, flWheel, engineForce)
	xEntityWheelSetEngineForce(chassis, frWheel, engineForce)
	xEntityWheelSetEngineForce(chassis, blWheel, engineForce)
	xEntityWheelSetEngineForce(chassis, brWheel, engineForce)
	
	xEntityWheelSetBrake(chassis, flWheel, brakeForce * 0.5)
	xEntityWheelSetBrake(chassis, frWheel, brakeForce * 0.5)
	xEntityWheelSetBrake(chassis, blWheel, brakeForce)
	xEntityWheelSetBrake(chassis, brWheel, brakeForce)
	
	xEntityWheelSetSteering(chassis, flWheel, steering)
	xEntityWheelSetSteering(chassis, frWheel, steering)
	
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