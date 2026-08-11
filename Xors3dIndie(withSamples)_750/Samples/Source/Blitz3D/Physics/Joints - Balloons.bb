Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 60
Const maxCameraDistance# = 190

xCreateLog(LOG_HTML, LOG_INFO, "Joints - Balloons.html")

xSetAntiAliasType(xGetMaxAntiAlias())
xGraphics3D 1024, 768, 32, False, True
xAntiAlias(True)

xHidePointer()

xCreateDSS 1024, 1024

Global activeBalloon% = 0
Global forceX# = 0.0, forceY# = 1.0, forceZ# = 0.0
Global forceDX# = 0.0, forceDY# = 0.0, forceDZ# = 0.0
Global timer% = 0

Global cameraDistance# = 150
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera, 0.0, 45.0, -cameraDistance
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

Global inst_shader = 0
If xHWInstancingAvailable()
	inst_shader = xLoadFXFile("Media\Shaders\rope-hwinstancing.fx")
EndIf

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

Dim rope(4)
Dim balloon(4)

rope(0) = CreateRope()
xPositionEntity(rope(0), 25.0, 0.0, 0.0)
balloon(0) = CreateBalloon(rope(0))
xEntityColor(balloon(0), 255, 128, 32)

rope(1) = CreateRope()
xPositionEntity(rope(1), -25.0, 0.0, 0.0)
balloon(1) = CreateBalloon(rope(1))
xEntityColor(balloon(1), 32, 128, 255)

rope(2) = CreateRope()
xPositionEntity(rope(2), 0.0, 0.0, 25.0)
balloon(2) = CreateBalloon(rope(2))
xEntityColor(balloon(2), 32, 255, 128)

rope(3) = CreateRope()
xPositionEntity(rope(3), 0.0, 0.0, -25.0)
balloon(3) = CreateBalloon(rope(3))
xEntityColor(balloon(3), 128, 255, 32)

Global forcePointer = xCreateCone()
xScaleMesh(forcePointer, 1.0, 1.5, 1.0)
xPositionMesh(forcePointer, 0.0, 8.5, 0.0)
xEntityReceiveShadows(forcePointer, lightBlue, 0)
xEntityCastShadows(forcePointer, lightBlue, 0)
xEntityFX(forcePointer, FX_FULLBRIGHT)
xEntityOrder(forcePointer, -1)

;xPhysicsDebugRender 0+8+16
;xSetShadowsBlur(SHADOWS_BLUR_5)

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
	Local lBalloon%
	If xMillisecs() - timer > 5000
		timer = xMillisecs()
		activeBalloon = xMilliSecs() Mod 4
		forceX = Rnd(-5.0, 5.0)
		forceY = Rnd(-5.0, 5.0)
		forceZ = Rnd(-5.0, 5.0)
		forceDX = Rnd(-0.05, 0.05)
		forceDY = Rnd(-0.05, 0.05)
		forceDZ = Rnd(-0.05, 0.05)
	EndIf
	forceX = forceX + forceDX
	forceY = forceY + forceDY
	forceZ = forceZ + forceDZ
	lBalloon = balloon(activeBalloon)
	xEntityApplyCentralForce(lBalloon, forceX, forceY, forceZ)
	xAlignToVector(forcePointer, forceX, forceY, forceZ, AXIS_Y)
	xPositionEntity(forcePointer, xEntityX(lBalloon, 1), xEntityY(lBalloon, 1), xEntityZ(lBalloon, 1), 1)
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

Function CreateRope(segments% = 50, length# = 25.0, radius# = 0.15)
	If segments < 2
		segments = 2
	EndIf
	
	Local lPivot = xCreatePivot()
	Local lSegmentA%, lSegmentB%, lSegmentI%
	Local lJoint%
	Local lSize# = length / segments
	Local lGravity# = 9.81 * 0.1 * segments * 0.9
	
	lSegmentA = xCreateCylinder(3, 1, lPivot)
	xEntityColor(lSegmentA, 32, 32, 32)
	xEntityFX(lSegmentA, FX_FULLBRIGHT)
	xScaleEntity(lSegmentA, radius, lSize, radius)
	xPositionEntity(lSegmentA, 0.0, lSize * 2 * 0.8, 0.0)
	xEntityAddBoxShape(lSegmentA, 0.1)
	lSegmentI = lSegmentA
	xEntitySetCollisionGroup(lSegmentA, 1)
	xSetEntityEffect lSegmentA, inst_shader
	xSetEffectTechnique lSegmentA, "Instancing"
	
	For i = 1 To segments
		lSegmentB = xCreateInstance(lSegmentI, lPivot)
		xPositionEntity(lSegmentB, 0.0, (i+1) * lSize * 2 * 0.8, 0.0)
		xEntityAddBoxShape(lSegmentB, 0.1)
		lJoint = xCreateBallJoint(lSegmentA, lSegmentB, 0.0, lSize * 0.9, 0.0)
		xJointDisableCollisions(lJoint, True)
		xEntitySetCollisionGroup(lSegmentB, 1)
		lSegmentA = lSegmentB
	Next
	
	xPhysicsSetCollisionFilter(1, 1, False)
	
	xNameEntity(lPivot, lSegmentI + "|" + Str(lGravity)) ; some black magic
	
	Return lPivot
End Function

Function CreateBalloon(pivot%, size# = 5.0)
	Local lJoint%
	Local message$ = xEntityName(pivot) ; decoding the black magic
	Local lPos = Instr(message, "|")
	Local lSegment% = Left(message, lPos)
	Local lGravity# = Mid(message, lPos + 1, Len(message) - lPos)
	Local lBalloon = xCreateSphere(16)
	xEntityParent(lBalloon, pivot, 0)
	xEntityParent(lBalloon, 0)
	
	xScaleEntity(lBalloon, size, size, size)
	xMoveEntity(lBalloon, 0.0, size * 0.8, 0.0)
	xEntityAddSphereShape(lBalloon, 1.0)
	xEntitySetGravity(lBalloon, 0.0, lGravity, 0.0)
	xEntitySetDamping(lBalloon, 0.5, 0.5)
	
	lJoint = xCreateBallJoint(lBalloon, lSegment, 0.0, -size * 0.8, 0.0)
	xJointDisableCollisions(lJoint, True)
	
	Return lBalloon
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D