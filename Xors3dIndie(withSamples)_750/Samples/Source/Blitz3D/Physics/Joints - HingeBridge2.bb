Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 190

Const sectionNum% = 20
Const sectionWidth# = 8.0
Const pilarPos# = 50.0
Const pilarWidth# = 10.0
Const pilarHeight# = 20.0

Const bridgeStrength = 200.0
Const jointThreshold = bridgeStrength / sectionNum

Type TSection
	Field entity%
	Field impAcc#
	Field tAcc#
End Type

Type TJoint
	Field joint%
	Field threshold#
	Field leftSection.TSection, rightSection.TSection
End Type

Type TBall
	Field entity%
End Type

Global leftPillar%, rightPillar%

xCreateLog(LOG_HTML, LOG_INFO, "Joints - HingeBridge2.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global maxDoor#
Global maxSeesaw#

Global cameraDistance# = 150
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

CreateBridge()

xPhysicsDebugRender(PXDD_JOINTS + PXDD_JOINT_LIMITS)

While Not xKeyDown(KEY_ESCAPE)
	
	UpdateCamera(0.25)
	UpdateControl()
	UpdateBridge()
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Press <Space> to drop a ball")
	xText(10, 50, "Press <Enter> to reset the scene")
	;PrintParams()
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
	Local j.TJoint, b.TBall, s.TSection
	Local firstSection.TSection, nextSection.TSection
	Local i% = 1
	
	For b.TBall = Each TBall
		xFreeEntity(b\entity)
		Delete b
	Next
	For j.TJoint = Each TJoint
		xFreeJoint(j\joint)
		Delete j
	Next
	For s.TSection = Each TSection
		xEntityReleaseForces(s\entity)
		s\impAcc = 0.0
		s\tAcc = 0.0
		xRotateEntity(s\entity, 0.0, 0.0, 0.0)
		xPositionEntity(s\entity, -pilarPos * (1.0 - i * 2.0 / (sectionNum + 1)), pilarHeight * 2.0, 0.0)
		i = i + 1
	Next
	
	firstSection.TSection = First TSection
	For i = 0 To sectionNum - 2
		nextSection.TSection = After firstSection
		
		j.TJoint = New TJoint
		j\leftSection = firstSection
		j\rightSection = nextSection
		j\joint = xCreateHingeJoint(j\leftSection\entity, j\rightSection\entity, pilarPos * 2.0 / (sectionNum + 1) * 0.5, 0.0, -sectionWidth, 0.0, 0.0, 1.0)
		j\threshold = jointThreshold
		xJointDisableCollisions(j\joint, True)
		
		j.TJoint = New TJoint
		j\leftSection = firstSection
		j\rightSection = nextSection
		j\joint = xCreateHingeJoint(j\leftSection\entity, j\rightSection\entity, pilarPos * 2.0 / (sectionNum + 1) * 0.5, 0.0, sectionWidth, 0.0, 0.0, 1.0)
		j\threshold = jointThreshold
		xJointDisableCollisions(j\joint, True)
		
		firstSection.TSection = nextSection
	Next
	
	firstSection.TSection = First TSection
	
	j.TJoint = New TJoint
	j\leftSection = firstSection
	j\rightSection = Null
	j\joint = xCreateHingeJoint(j\leftSection\entity, 0, -pilarPos * 2.0 / (sectionNum + 1), 0.0, -sectionWidth, 0.0, 0.0, 1.0)
	j\threshold = jointThreshold
	xJointDisableCollisions(j\joint, True)
	
	j.TJoint = New TJoint
	j\leftSection = firstSection
	j\rightSection = Null
	j\joint = xCreateHingeJoint(j\leftSection\entity, 0, -pilarPos * 2.0 / (sectionNum + 1), 0.0, sectionWidth, 0.0, 0.0, 1.0)
	j\threshold = jointThreshold
	xJointDisableCollisions(j\joint, True)
	
	nextSection.TSection = Last TSection
	j.TJoint = New TJoint
	j\leftSection = nextSection
	j\rightSection = Null
	j\joint = xCreateHingeJoint(j\leftSection\entity, 0, pilarPos * 2.0 / (sectionNum + 1), 0.0, -sectionWidth, 0.0, 0.0, 1.0)
	j\threshold = jointThreshold
	xJointDisableCollisions(j\joint, True)
	
	j.TJoint = New TJoint
	j\leftSection = nextSection
	j\rightSection = Null
	j\joint = xCreateHingeJoint(j\leftSection\entity, 0, pilarPos * 2.0 / (sectionNum + 1), 0.0, sectionWidth, 0.0, 0.0, 1.0)
	j\threshold = jointThreshold
	xJointDisableCollisions(j\joint, True)
	
End Function

Function UpdateControl()
	If xKeyHit(KEY_SPACE)
		CreateBall()
	EndIf
	If xKeyHit(KEY_ENTER)
		Reset()
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

Function CreateBridge()
	Local initSection%
	Local firstSection.TSection, nextSection.TSection
	Local border% = xCreateCube()
	xFlipMesh(border)
	xScaleEntity(border, pilarPos + pilarWidth * 2, 50.0, 100.0)
	xPositionEntity(border, 0.0, 50.0, 0.0)
	xEntityAddTrimeshShape(border)
	xHideEntity(border)
	
	leftPillar% = xCreateCube()
	rightPillar% = xCreateCube()
	xScaleEntity(leftPillar, pilarWidth, pilarHeight, 10.0)
	xScaleEntity(rightPillar, pilarWidth, pilarHeight, 10.0)
	xPositionEntity(leftPillar, -pilarPos - pilarWidth, pilarHeight, 0.0)
	xPositionEntity(rightPillar, pilarPos + pilarWidth, pilarHeight, 0.0)
	xEntityAddBoxShape(leftPillar, 0.0)
	xEntityAddBoxShape(rightPillar, 0.0)
	xEntityColor(leftPillar, 64, 64, 64)
	xEntityColor(rightPillar, 64, 64, 64)
	
	s.TSection = New TSection
	s\entity = xCreateCube()
	initSection = s\entity
	xScaleEntity(s\entity, pilarPos * 2.0 / (sectionNum + 1) * 0.33, 0.4, sectionWidth)
	xEntityAddBoxShape(s\entity, 1.0)
	
	For i = 1 To sectionNum - 1
		s.TSection = New TSection
		s\entity = xCopyEntity(initSection)
		xEntityAddBoxShape(s\entity, 1.0)
	Next
	
	Reset()
	
End Function

Function CreateBall()
	Local pos# = pilarPos - pilarWidth
	b.TBall = New TBall
	b\entity = xCreateSphere()
	xScaleEntity(b\entity, 2.5, 2.5, 2.5)
	xPositionEntity(b\entity, Rnd(-pos, pos), pilarHeight * 2.0 + 2.5 + Rnd(10.0, 30.0), 0.0)
	xEntityAddSphereShape(b\entity, 10.0)
	xEntitySetAngularFactor(b\entity, 0.0, 0.0, 1.0)
	xEntitySetLinearFactor(b\entity, 1.0, 1.0, 0.0)
	xEntityApplyTorqueImpulse(b\entity, 0.0, 0.0, Rnd(-100.0, 100.0))
End Function

Function UpdateBridge()
	Local s.TSection, is.TSection, j.TJoint
	Local imp#
	Local redValue%
	
	For s.TSection = Each TSection
		s\impAcc = s\impAcc * 0.1
		s\tAcc = -0.001
	Next
	
	For j.TJoint = Each TJoint
		imp = Abs(xJointGetImpulse(j\joint))
		is.TSection = j\leftSection
		If (is <> Null)
			is\impAcc = is\impAcc + imp * 0.5
			is\tAcc = is\tAcc + j\threshold * 0.5
		EndIf
		is.TSection = j\rightSection
		If (is <> Null)
			is\impAcc = is\impAcc + imp * 0.5
			is\tAcc = is\tAcc + j\threshold * 0.5
		EndIf
		If imp > j\threshold
			xFreeJoint(j\joint)
			Delete j
		EndIf
	Next
	
	For s.TSection = Each TSection
		redValue = s\impAcc / s\tAcc * 255
		xEntityColor(s\entity, redValue, 255 - redValue, 0)
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D