Include "..\xors3d.bb"

Const mazeSize% = 20
Const ballNumber% = 100
Const torqueScale# = 120.0
Const normPaleCoeff# = 0.25
Const maxCameraAngle# = 85.0
Const minCameraDistance# = 15
Const maxCameraDistance# = 75

Type tBall
	Field entity%
	Field torqueX#
	Field torqueY#
	Field torqueZ#
	Field rColor#
	Field gColor#
	Field bColor#
	Field paleCoeff#
	Field fraction%
End Type

xCreateLog(LOG_HTML, LOG_INFO, "Maze trimesh.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 45
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera,0,0, -cameraDistance
xCameraClsColor camera, 96, 128, 192
xRotateEntity camPiv, maxCameraAngle / 2, 45, 0
xCameraEnableShadows camera
xCameraRange( camera, 1.0, 100.0)

lightRed = xcreatelight()
xRotateEntity lightRed, 60, 15, 0
xLightColor lightRed, 255, 128, 128

lightBlue = xcreatelight()
xRotateEntity lightBlue, 60, 195, 0
xLightColor lightBlue, 128, 128, 255
xLightEnableShadows lightBlue, True
xLightShadowEpsilons lightBlue, 0.0001, 0.0001

xSetShadowParams(1, 0.15, 1, 50)
xInitShadows(1024, 0, 0)

Global maze = GenerateStupidMaze(mazeSize)
xEntityTexture maze, CreateCheckerTexture()
GenerateBalls(mazeSize, ballNumber)

;xPhysicsDebugRender(PXDD_WIREFRAME)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	If (time < xMilliSecs() - 1000)
		time = xMilliSecs()
		UpdateBalls(1)
	Else
		UpdateBalls()
	EndIf
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Press <Space> to reset scene")
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
	For b.tBall = Each tBall
		xFreeEntity(b\entity)
		Delete b
	Next
	GenerateBalls(mazeSize, ballNumber%)
End Function

Function GenerateStupidMaze(size% = 10)
	Local nx, ny, nz
	Local lMaze = xCreateMesh()
	Local lBlock = xCreateCube()
	Local lSurf
	
	xScaleMesh(lBlock, size - 1, 2, 1)
	lSurf = xGetSurface(lBlock, 0)
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
	xPositionMesh(lBlock, -1, 1, size-1)
	xAddMesh(lBlock, lMaze)
	xPositionMesh(lBlock, 2, 0, -(size-1)*2)
	xAddMesh(lBlock, lMaze)
	xPositionMesh(lBlock, -1, 0, size-1)
	xRotateMesh(lBlock, 0, 90, 0)
	xPositionMesh(lBlock, size-1, 0, 1)
	xAddMesh(lBlock, lMaze)
	xPositionMesh(lBlock, -(size-1)*2, 0, -2)
	xAddMesh(lBlock, lMaze)
	xFreeEntity(lBlock)
	
	lBlock = xCreateCube()
	xScaleMesh(lBlock, size, 1, size)
	lSurf = xGetSurface(lBlock, 0)
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
	xPositionMesh(lBlock, 0, -2, 0)
	xAddMesh(lBlock, lMaze)
	xFreeEntity(lBlock)
	
	For i = 1 To size ^ 1.5
		lBlock = xCreateCube()
		xPositionMesh(lBlock, Rand(-(size-5) / 2, (size-4) / 2) * 2, 0, Rand(-(size-5) / 2, (size-4) / 2) * 2)
		xAddMesh(lBlock, lMaze)
		xFreeEntity(lBlock)
	Next
	xEntityAddTriMeshShape(lMaze)
	Return lMaze
End Function

Function GenerateBalls(size% = 10, number% = 10)
	For i = 1 To number
		b.tBall = New tBall
		b\torqueX = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\torqueY = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\torqueZ = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\entity = xCreateSphere()
		xScaleEntity(b\entity, 0.75, 0.75, 0.75)
		b\fraction = Rand(0, 1)
		If b\fraction
			b\rColor = 255
			b\gColor = 127
			b\bColor = 0
		Else
			b\rColor = 127
			b\gColor = 0
			b\bColor = 255
		EndIf
		b\paleCoeff = normPaleCoeff
		xEntityColor(b\entity, b\rColor * b\paleCoeff, b\gColor * b\paleCoeff, b\bColor * b\paleCoeff)
		xPositionEntity(b\entity, Rand(-(size-7) / 2, (size-6) / 2) * 2, 5, Rand(-(size-7) / 2, (size-6) / 2) * 2)
		xEntityAddSphereShape(b\entity, 1)
		xNameEntity(b\entity, Handle(b))
	Next
End Function

Function UpdateBalls(chaos% = 0)
	For b.tBall = Each tBall
		If chaos
			b\torqueX = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
			b\torqueY = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
			b\torqueZ = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		EndIf
		For i = 0 To xEntityCountContacts(b\entity) - 1
			temp.tBall = Object.tBall(xEntityName(xEntityGetContact(b\entity, i)))
			If temp <> Null
				If temp\fraction <> b\fraction
					If xEntityGetContactDistance(b\entity, i) < 0.001
						b\paleCoeff = 1.0
					EndIf
				EndIf
			EndIf
		Next
		If b\paleCoeff > normPaleCoeff
			b\paleCoeff = b\paleCoeff - 0.01
			xEntityColor(b\entity, b\rColor * b\paleCoeff, b\gColor * b\paleCoeff, b\bColor * b\paleCoeff)
		Else
			b\paleCoeff = normPaleCoeff
		EndIf
		xEntityApplyTorque(b\entity, b\torqueX, b\torqueY, b\torqueZ)
		; destroy fallen balls
		If xEntityY(b\entity) < -1
			xEntityAlpha(b\entity, 1.0 - (xEntityY(b\entity) / (-40)))
		EndIf
		If xEntityY(b\Entity) < -40
			xFreeEntity(b\entity)
			Delete b
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