Include "..\xors3d.bb"

Const arenaSize% = 20
Const boxNumber% = 100
Const boxForce# = 10.0
Const maxCameraAngle# = 85.0
Const minCameraDistance# = 15
Const maxCameraDistance# = 75

Global globalMovement = 1

Type tBox
	Field entity%
End Type

xCreateLog(LOG_HTML, LOG_INFO, "Local force.html")

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
xLightColor lightRed, 128, 64, 64

lightBlue = xcreatelight()
xRotateEntity lightBlue, 60, 195, 0
xLightColor lightBlue, 64, 64, 128
xLightEnableShadows lightBlue, True
xLightShadowEpsilons lightBlue, 0.0001, 0.0001

xSetShadowParams(1, 0.15, 1, 50)
xInitShadows(1024, 0, 0)

Global arena = GenerateArena(arenaSize)
xEntityTexture arena, CreateCheckerTexture()
GenerateBoxes(arenaSize, boxNumber)

;xPhysicsDebugRender(PXDD_WIREFRAME)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
		globalMovement = 1 - globalMovement
	EndIf
	
	UpdateBoxes(globalMovement)
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Press <Space> to change force")
	If globalMovement
		xText(10, 50, "Global force")
	Else
		xText(10, 50, "Local force")
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
	For b.tBox = Each tBox
		xFreeEntity(b\entity)
		Delete b
	Next
	GenerateBoxes(arenaSize, boxNumber%)
End Function

Function GenerateArena(size% = 10)
	Local lArena = xCreateMesh()
	Local lBlock = xCreateCube()
	Local lSurf
	
	xScaleMesh(lBlock, size - 1, 2, 1)
	lSurf = xGetSurface(lBlock, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		xVertexTexCoords(lSurf, i, xVertexU(lSurf, i) * (xVertexX(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNX(lSurf, i)), xVertexV(lSurf, i) * (xVertexZ(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNZ(lSurf, i)))
	Next
	xPositionMesh(lBlock, -1, 1, size-1)
	xAddMesh(lBlock, lArena)
	xPositionMesh(lBlock, 2, 0, -(size-1)*2)
	xAddMesh(lBlock, lArena)
	xPositionMesh(lBlock, -1, 0, size-1)
	xRotateMesh(lBlock, 0, 90, 0)
	xPositionMesh(lBlock, size-1, 0, 1)
	xAddMesh(lBlock, lArena)
	xPositionMesh(lBlock, -(size-1)*2, 0, -2)
	xAddMesh(lBlock, lArena)
	xFreeEntity(lBlock)
	
	lBlock = xCreateCube()
	xScaleMesh(lBlock, size, 1, size)
	lSurf = xGetSurface(lBlock, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		xVertexTexCoords(lSurf, i, xVertexU(lSurf, i) * (xVertexX(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNX(lSurf, i)), xVertexV(lSurf, i) * (xVertexZ(lSurf, i) * xVertexNY(lSurf, i) + xVertexY(lSurf, i) * xVertexNZ(lSurf, i)))
	Next
	xPositionMesh(lBlock, 0, -2, 0)
	xAddMesh(lBlock, lArena)
	xFreeEntity(lBlock)
	
	xEntityAddTriMeshShape lArena
	Return lArena
End Function

Function GenerateBoxes(size% = 10, number% = 10)
	For i = 1 To number
		b.tBox = New tBox
		b\entity = xCreateCube()
		xScaleEntity(b\entity, 0.5, 0.25, 0.75)
		xTurnEntity(b\entity, 0.0, Rnd(360.0), 0.0)
		rColor = Rand(64, 192)
		gColor = Rand(64, 192)
		bColor = 256 - rColor
		xEntityColor(b\entity, rColor, gColor, bColor)
		xPositionEntity(b\entity, Rand(-(size-7) / 2, (size-6) / 2) * 2, 3, Rand(-(size-7) / 2, (size-6) / 2) * 2)
		xEntityAddBoxShape(b\entity, 1)
		;supress rotation around X and Z axes
		xEntitySetAngularFactor(b\entity, 0.0, 1.0, 0.0)
		xEntitySetDamping(b\entity, xEntityGetLinearDamping(b\entity), 0.25)
	Next
End Function

Function UpdateBoxes(globalMove% = 0)
	For b.tBox = Each tBox
		xEntityApplyCentralForce(b\entity, 0, 0, boxForce, globalMove)
		; destroy fallen boxes
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