Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 190

Const doorScene = 0
Const seesawScene = 1
Const carouselScene = 2

Global activeScene = doorScene
Global sceneDescription$ = ""

xCreateLog(LOG_HTML, LOG_INFO, "Joints - Hinge.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global maxDoor#
Global maxSeesaw#

Global cameraDistance# = 85
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera,0,0, -cameraDistance
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

Global doorOrigin, doorFrame, door, doorJoint
CreateDoorScene()

Global seesawOrigin, seesawBase, seesawPlank, seesawJoint, seesawCube0, seesawCube1, seesawOrder
CreateSeesawScene()

Global carouselOrigin, carouselPivot, carouselBase, carouselJoint
CreateCarouselScene()

UpdateControl(doorScene)

xPhysicsDebugRender(PXDD_JOINTS + PXDD_JOINT_LIMITS)

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateCamera(0.25)
	UpdateControl()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Press <1> to activate the door scene")
	xText(10, 50, "Press <2> to activate the seesaw scene")
	xText(10, 70, "Press <3> to activate the carousel scene")
	xText(10, 100, sceneDescription)
	PrintParams()
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

Function UpdateControl(init% = -1)
	Local CamP# = xEntityPitch(camPiv)
	Local key%
	If init = -1
		key = xGetKey() - Asc("1")
	Else
		key = init
	EndIf
	Select key
		Case 0
			activeScene = doorScene
			xRotateEntity camPiv, CamP, 360.0 / 3.0 * activeScene - 60.0, 0
		Case 1
			activeScene = seesawScene
			xRotateEntity camPiv, CamP, 360.0 / 3.0 * activeScene - 60.0, 0
		Case 2
			activeScene = carouselScene
			xRotateEntity camPiv, CamP, 360.0 / 3.0 * activeScene - 60.0, 0
	End Select
	Select activeScene
		Case doorScene
			UpdateDoor()
		Case seesawScene
			UpdateSeesaw()
		Case carouselScene
			UpdateCarousel()
	End Select
End Function

Function UpdateDoor()
	Local doorImpulse#
	If xJointHingeGetAngle(doorJoint) > 65.0
		doorImpulse = -5.0
		sceneDescription = "Press <Space> to close the door"
	Else
		doorImpulse = 5.0
		sceneDescription = "Press <Space> to open the door"
	EndIf
	If xKeyHit(KEY_SPACE)
		xEntityApplyCentralImpulse(door, 0.0, 0.0, doorImpulse, False)
	EndIf
End Function

Function UpdateSeesaw()
	If seesawOrder < 0
		sceneDescription = "Press <Space> to drop a blue cube"
	Else
		sceneDescription = "Press <Space> to drop a red cube"
	EndIf
	If xKeyHit(KEY_SPACE)
		If seesawOrder < 0
			xEntityReleaseForces(seesawCube0)
			xPositionEntity(seesawCube0, 0.0, 15.0, seesawOrder * 10)
			xRotateEntity(seesawCube0, 0.0, 0.0, 0.0)
			xEntityWakeUp(seesawCube0)
		Else
			xEntityReleaseForces(seesawCube1)
			xPositionEntity(seesawCube1, 0.0, 15.0, seesawOrder * 10)
			xRotateEntity(seesawCube1, 0.0, 0.0, 0.0)
			xEntityWakeUp(seesawCube1)
		EndIf
		seesawOrder = -seesawOrder
	EndIf
End Function

Function UpdateCarousel()
	If xJointIsEnabled(carouselJoint)
		sceneDescription = "Press <Space> to disable a carousel joint"
	Else
		sceneDescription = "Press <Space> to enable a carousel joint"
	EndIf
	If xKeyHit(KEY_SPACE)
		If xJointIsEnabled(carouselJoint)
			xJointEnable(carouselJoint, False)
		Else
			xEntityWakeUp(carouselBase)
			xJointEnable(carouselJoint, True)
		EndIf
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

Function CreateFrame(size# = 8.0)
	Local nx, ny, nz
	Local lMesh = xCreateMesh()
	Local lBlock = xCreateCube()
	Local lSurf
	
	xScaleMesh(lBlock, size * 0.05, size, size * 0.025)
	xPositionMesh(lBlock, -size * 0.6, size * 1.0, 0.0)
	xAddMesh(lBlock, lMesh)
	xPositionMesh(lBlock, size * 1.2, 0, 0)
	xAddMesh(lBlock, lMesh)
	xFreeEntity(lBlock)
	
	lBlock = xCreateCube()
	xScaleMesh(lBlock, size * 0.65, size * 0.05, size * 0.025)
	xPositionMesh(lBlock, 0.0, size * 2.0, 0.0)
	xAddMesh(lBlock, lMesh)
	xFreeEntity(lBlock)
	
	lSurf = xGetSurface(lMesh, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		nx = xVertexNX(lSurf, i)
		ny = xVertexNY(lSurf, i)
		nz = xVertexNZ(lSurf, i)
		If Abs(ny) = 1.0
			xVertexTexCoords(lSurf, i, xVertexX(lSurf, i) / 2, xVertexZ(lSurf, i) / 2, 0.0)
		Else
			If Abs(nz) = 1.0
				xVertexTexCoords(lSurf, i, xVertexX(lSurf, i) / 2, xVertexY(lSurf, i) / 2, 0.0)
			Else
				xVertexTexCoords(lSurf, i, xVertexZ(lSurf, i) / 2, xVertexY(lSurf, i) / 2, 0.0)
			EndIf
		EndIf
	Next
	
	xEntityAddCompoundShape(lMesh, 0.0)
	xEntityCompoundAddBox(lMesh, size * 0.05 * 2, size * 2, size * 0.025 * 2)
	xEntityCompoundAddBox(lMesh, size * 0.05 * 2, size * 2, size * 0.025)
	xEntityCompoundAddBox(lMesh, size * 0.65 * 2, size * 0.05 * 2, size * 0.025 * 2)
	xEntityCompoundChildSetPosition(lMesh, 0, -size * 0.6, size * 1.0, 0.0)
	xEntityCompoundChildSetPosition(lMesh, 1, size * 0.6, size * 1.0, 0.0)
	xEntityCompoundChildSetPosition(lMesh, 2, 0.0, size * 2.0, 0.0)
	
	Return lMesh
End Function

Function CreateDoorScene()
	Local door_size = 8.0
	doorOrigin = xCreatePivot()
	xPositionEntity(doorOrigin, -25.0, 0.0, -10.0)
	
	doorFrame = CreateFrame(door_size)
	xPositionEntity(doorFrame, 0.0, 0.55, 0.0)
	xEntityColor(doorFrame, 64, 32, 16)
	xEntityParent(doorFrame, doorOrigin,False)
	
	door = xCreateCube(doorOrigin)
	xScaleEntity(door, door_size * 0.55, door_size * 0.95, door_size * 0.025)
	xPositionEntity(door, 0.0, door_size + 0.55, 0.0)
	xEntityColor(door, 96, 64, 32)
	xEntityAddBoxShape(door, 1.0)
	xEntityBodyLocalScale(door, 0.96, 0.99, 1.0)
	xEntityBodyLocalPosition(door, 0.2, 0.0, 0.0)
	
	doorJoint = xCreateHingeJoint(door, doorFrame, - door_size * 0.515, 0.0, 0.0, 0.0, 1.0, 0.0)
	xJointHingeSetLimits(doorJoint, 0.0, 135.0)
	xJointDisableCollisions(doorJoint, True)
End Function

Function CreateSeesawScene()
	seesawOrigin = xCreatePivot()
	xPositionEntity(seesawOrigin, 25.0, 0.0, -10.0)
	
	seesawBase = xCreateCylinder(10, True, seesawOrigin)
	xScaleEntity(seesawBase, 2.0, 1.0, 2.0)
	xRotateEntity(seesawBase, 90.0, 90.0, 0.0)
	xPositionEntity(seesawBase, 0.0, 2.0, 0.0)
	xEntityColor(seesawBase, 96, 192, 64)
	
	seesawPlank = xCreateCube(seesawOrigin)
	xScaleEntity(seesawPlank, 1.2, 0.2, 12.0)
	xPositionEntity(seesawPlank, 0.0, 4.0, 0.0)
	xEntityAddBoxShape(seesawPlank, 10.0)
	xEntityColor(seesawPlank, 96, 192, 64)
	
	seesawJoint = xCreateHingeJoint(seesawPlank, 0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0)
	
	seesawCube0 = xCreateCube(seesawOrigin)
	xMoveEntity(seesawCube0, 0.0, 10.0, -10.0)
	xEntityAddBoxShape(seesawCube0, 2.0)
	xEntityColor(seesawCube0, 32, 32, 128)
	seesawCube1 = xCreateCube(seesawOrigin)
	xMoveEntity(seesawCube1, 0.0, 30.0, 10.0)
	xEntityAddBoxShape(seesawCube1, 2.0)
	xEntityColor(seesawCube1, 128, 32, 32)
	
	seesawOrder = -1.0
End Function

Function CreateCarouselScene()
	carouselOrigin = xCreatePivot()
	xPositionEntity(carouselOrigin, 0.0, 0.0, 30.0)
	
	carouselPivot = xCreateCylinder(10, True, carouselOrigin)
	xScaleEntity(carouselPivot, 1.0, 2.0, 1.0)
	xPositionEntity(carouselPivot, 0.0, 3.0, 0.0)
	xEntityColor(carouselPivot, 64, 96, 192)
	
	carouselBase = xCreateMesh()
	carouselTmp = xCreateCube()
	xScaleMesh(carouselTmp, 10.0, 0.2, 1.0)
	xPositionEntity(carouselTmp, 0.0, 0.0, 0.0)
	carouselTmp2 = xCreateCube()
	xScaleMesh(carouselTmp2, 0.2, 0.6, 1.0)
	xPositionMesh(carouselTmp2, -8.0, 0.6, 0.0)
	xAddMesh(carouselTmp2, carouselTmp)
	xPositionMesh(carouselTmp2, 16.0, 0.0, 0.0)
	xAddMesh(carouselTmp2, carouselTmp)
	xFreeEntity(carouselTmp2)
	xAddMesh(carouselTmp, carouselBase)
	xRotateMesh(carouselTmp, 0.0, 120.0, 0.0)
	xAddMesh(carouselTmp, carouselBase)
	xRotateMesh(carouselTmp, 0.0, 120.0, 0.0)
	xAddMesh(carouselTmp, carouselBase)
	xFreeEntity(carouselTmp)
	xEntityParent(carouselBase, carouselOrigin, False)
	xPositionEntity(carouselBase, 0.0, 4.0, 0.0)
	xEntityAddConcaveShape(carouselBase, 10.0)
	xEntityColor(carouselBase, 64, 96, 192)
	
	carouselJoint = xCreateHingeJoint(carouselBase, 0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
	xJointEnableMotor(carouselJoint, True, 1.0, 10.0)
End Function

Function PrintParams()
	If maxDoor < Abs(xJointGetImpulse(doorJoint))
		maxDoor = Abs(xJointGetImpulse(doorJoint))
	EndIf
	If maxSeesaw < Abs(xJointGetImpulse(seesawJoint))
		maxSeesaw = Abs(xJointGetImpulse(seesawJoint))
	EndIf
	
	xCameraProject(camera, xEntityX(door, True) - 2.0, xEntityY(door, True) + 4.0, xEntityZ(door, True))
	xText(xProjectedX(), xProjectedY() - 30, "Angle: " + xJointHingeGetAngle(doorJoint))
	xText(xProjectedX(), xProjectedY() - 15, "Impulse: " + xJointGetImpulse(doorJoint))
	xText(xProjectedX(), xProjectedY(), "Max impulse: " + maxDoor)
	
	xCameraProject(camera, xEntityX(carouselBase, True), xEntityY(carouselBase, True) + 7.0, xEntityZ(carouselBase, True))
	xText(xProjectedX(), xProjectedY() - 15, "Angle: " + xJointHingeGetAngle(carouselJoint))
	If xJointIsEnabled(carouselJoint)
		xText(xProjectedX(), xProjectedY(), "State: enabled")
	Else
		xText(xProjectedX(), xProjectedY(), "State: disabled")
	EndIf
	
	xCameraProject(camera, xEntityX(seesawBase, True), xEntityY(seesawBase, True) + 8.0, xEntityZ(seesawBase, True))
	xText(xProjectedX(), xProjectedY() - 30, "Angle: " + xJointHingeGetAngle(seesawJoint))
	xText(xProjectedX(), xProjectedY() - 15, "Impulse: " + xJointGetImpulse(seesawJoint))
	xText(xProjectedX(), xProjectedY(), "Max impulse: " + maxSeesaw)
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D