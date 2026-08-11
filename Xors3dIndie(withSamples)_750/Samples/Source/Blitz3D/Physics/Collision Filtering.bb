Include "..\xors3d.bb"

Const chuteLenght% = 10
Const torqueScale# = 120.0
Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110
Const maxBalls% = 10
Const maxBallPos% = 6
Const minBallPos% = 2
Const startBallHeight# = 15.0
Const ballPeriod% = 1000

Global ballsNum% = 0
Global ballPos = -4

Type tBall
	Field entity%
	Field rColor#
	Field gColor#
	Field bColor#
	Field fraction%
	Field dir%
End Type

xCreateLog(LOG_HTML, LOG_INFO, "Collision Filtering.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 75
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
Global chuteNorm1 = GenerateChute()
Global chuteNorm2 = GenerateChute()
Global chuteNorm3 = GenerateChute()
Global chuteRed = GenerateChute()
Global chuteBlue = GenerateChute()
xEntityColor(chuteRed, 255, 64, 64)
xEntityColor(chuteBlue, 64, 64, 255)
xEntityAlpha(chuteRed, 0.75)
xEntityAlpha(chuteBlue, 0.75)
xPositionEntity( chuteNorm1, 0, 0, -2 * chuteLenght * 2)
xPositionEntity( chuteRed, 0, 0, -1 * chuteLenght * 2)
xPositionEntity( chuteNorm2, 0, 0, 0 * chuteLenght * 2)
xPositionEntity( chuteBlue, 0, 0, +1 * chuteLenght * 2)
xPositionEntity( chuteNorm3, 0, 0, +2 * chuteLenght * 2)
xEntityTexture( chuteNorm1, tex)
xEntityTexture( chuteNorm2, tex)
xEntityTexture( chuteNorm3, tex)
xEntityTexture( chuteRed, tex)
xEntityTexture( chuteBlue, tex)
xEntitySetCollisionGroup(chuteRed, 1)
xEntitySetCollisionGroup(chuteBlue, 2)

xPhysicsSetCollisionFilter(1, 3, False)
xPhysicsSetCollisionFilter(2, 4, False)

;xPhysicsDebugRender 1
Global time = xMilliSecs()

While Not xKeyDown(KEY_ESCAPE)

	If (time < xMilliSecs() - ballPeriod)
		time = xMilliSecs()
		GenerateBall()
	EndIf
	UpdateBalls()
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Balls: " + ballsNum)
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

Function GenerateChute(size% = chuteLenght)
	Local lChute = xCreateMesh()
	Local lBlock = xCreateCube()
	Local lSurf
	
	xScaleMesh(lBlock, 1, 1, size)
	lSurf = xGetSurface(lBlock, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		xVertexTexCoords(lSurf, i, xVertexU(lSurf, i) * (xVertexX(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNX(lSurf, i)), xVertexV(lSurf, i) * (xVertexZ(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNZ(lSurf, i)))
	Next
	
	xPositionMesh(lBlock, -9, 2, 0)
	xAddMesh(lBlock, lChute)
	xPositionMesh(lBlock, 18, 0, 0)
	xAddMesh(lBlock, lChute)
	xFreeEntity(lBlock)
	
	lBlock = xCreateCube()
	xScaleMesh(lBlock, 10, 1, size)
	lSurf = xGetSurface(lBlock, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		xVertexTexCoords(lSurf, i, xVertexU(lSurf, i) * (xVertexX(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNX(lSurf, i)), xVertexV(lSurf, i) * (xVertexZ(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNZ(lSurf, i)))
	Next
	;xPositionMesh(lBlock, 0, 0, 0)
	xAddMesh(lBlock, lChute)
	xFreeEntity(lBlock)
	
	xEntityAddTriMeshShape lChute
	Return lChute
End Function

Function GenerateBall()
	If ballsNum <= maxBalls
		b.tBall = New tBall
		b\entity = xCreateSphere()
		If Rand(1, 2) - 1
			xPositionEntity(b\entity, ballPos, startBallHeight, -4.5 * chuteLenght)
			b\dir = 1
		Else
			xPositionEntity(b\entity, -ballPos, startBallHeight, 4.5 * chuteLenght)
			b\dir = -1
		EndIf
		xEntityAddSphereShape(b\entity, 1)
		b\fraction = Rand(0, 2)
		If b\fraction = 2
			b\rColor = 255
			b\gColor = 64
			b\bColor = 64
			xEntitySetCollisionGroup(b\entity, 3)
		ElseIf b\fraction = 1
			b\rColor = 64
			b\gColor = 64
			b\bColor = 255
			xEntitySetCollisionGroup(b\entity, 4)
		Else
			b\rColor = 64
			b\gColor = 64
			b\bColor = 64
		EndIf
		xEntityColor(b\entity, b\rColor, b\gColor, b\bColor)
		xNameEntity(b\entity, Handle(b))
		ballsNum = ballsNum + 1
		ballPos = ballPos + 2
		If ballPos > maxBallPos
			ballPos = minBallPos
		EndIf
	EndIf
End Function

Function UpdateBalls()
	For b.tBall = Each tBall
;		For i = 0 To xEntityCountContacts(b\entity) - 1
;			temp.tBall = Object.tBall(xEntityName(xContactEntity(b\entity, i)))
;			If temp <> Null
;				If temp\fraction <> b\fraction
;					If xEntityContactDistance(b\entity, i) < 0.001
;						b\paleCoeff = 1.0
;					EndIf
;				EndIf
;			EndIf
;		Next
		xEntityApplyTorque(b\entity, torqueScale * b\dir, 0, 0)
		If xEntityY(b\entity) > 1.0
			Local lScale# = 1.0 - (xEntityY(b\entity) - 1.0) / startBallHeight
			xScaleEntity(b\entity, lScale, lScale, lScale)
		EndIf
		; destroy fallen balls
		If xEntityY(b\entity) < -5.0
			xEntityAlpha(b\entity, 1.0 - ((xEntityY(b\entity) + 5.0) / (-40)))
		EndIf
		If xEntityY(b\Entity) < -40
			xFreeEntity(b\entity)
			Delete b
			ballsNum = ballsNum - 1
		EndIf
	Next
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