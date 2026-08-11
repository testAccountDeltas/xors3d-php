Include "..\xors3d.bb"

Const ballNumber% = 250
Const ballSize# = 0.75
Const torqueScale# = 120.0
Const normPaleCoeff# = 0.25

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

xCreateLog(LOG_HTML, LOG_INFO, "Terrain.html")
xAppTitle("Terrain")
xGraphics3D(1024, 768, 32, False, True)
xCreateDSS 1024, 1024

; creating the cameta
Global cam = xCreateCamera()
xRotateEntity(cam, 0, 135, 0)
xCameraClsColor(cam, 192, 192, 192)
xCameraRange(cam, 0.5, 300)
xCameraFogMode(cam, 1)
xCameraFogColor(cam, 192, 192, 192)
xCameraFogRange(cam, 225, 300)

; light source creating
Global light = xCreateLight(LIGHT_DIRECTION)
xRotateEntity(light, 45, 0, 0)

Global checkerTex = CreateCheckerTexture()
; creating the terrain
Global terr = MakeTerrain()
GenerateBalls(xTerrainSize(terr), ballNumber)

xPositionEntity(cam, xTerrainSize(terr) / 2, xTerrainSize(terr) / 16, xTerrainSize(terr) / 2)

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5
camerasmoothness# = 4.5

;xPhysicsDebugRender(PXDD_WIREFRAME)

; main loop
camxa# = xEntityYaw(cam, True)
Global time = xMilliSecs()
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
	
	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	; setting the camera above the terrain
	x# = xEntityX(cam)
	y# = xEntityY(cam)
	z# = xEntityZ(cam)
	;terra_y# = xTerrainY(terr, x#, y#, z#) + 5
	terra_y# = y
	xPositionEntity cam, x#, terra_y#, z#
	
	; updating and rendering the world
	xUpdateWorld
	xRenderWorld
	
	; fps and triangle counter
	xText(10, 10, "FPS: " + xGetFPS())
	xText(10, 30, "Polygons on terrain: " + xTerrainSize(terr) * xTerrainSize(terr) * 2)
	xText(10, 50, "Polygons rendered: " + xTrisRendered())
	xText(10, 70, "Press <Space> to reset scene")
	
	; drawing the scene
	xFlip
Wend
End

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

Function Reset()
	For b.tBall = Each tBall
		xFreeEntity(b\entity)
		Delete b
	Next
	GenerateBalls(xTerrainSize(terr), ballNumber%)
End Function

Function MakeTerrain()
	Local lTerr% = xLoadTerrain("media/terrain128.png")
	Local lSize# = xTerrainSize(lTerr) / 2
	Local lTerrTex% = xLoadTexture("media/IceTerrain.jpg")
	xEntityAddTerrainShape(lTerr)
	xScaleEntity(lTerr, 1, lSize / 8, 1)
	xEntityTexture(lTerr, lTerrTex, 0, 0)
	xEntityFX(lTerr, 1)
	
	Local lWall% = xCreateMesh()
	Local lBlock% = xCreateCube()
	Local lSurf%
	xScaleMesh(lBlock, lSize + 1, 16, 1)
	lSurf = xGetSurface(lBlock, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		If Abs(Int(xVertexNY(lSurf, i))) = 1
			xVertexTexCoords(lSurf, i, xVertexX(lSurf, i) / 2, xVertexZ(lSurf, i) / 2, 0.0)
		Else
			If Abs(Int(xVertexNZ(lSurf, i))) = 1
				xVertexTexCoords(lSurf, i, xVertexX(lSurf, i) / 2, xVertexY(lSurf, i) / 2, 0.0)
			Else
				xVertexTexCoords(lSurf, i, xVertexZ(lSurf, i) / 2, xVertexY(lSurf, i) / 2, 0.0)
			EndIf
		EndIf
	Next
	xPositionMesh(lBlock, 1, 1, lSize + 1)
	xAddMesh(lBlock, lWall)
	xPositionMesh(lBlock, -2, 0, -(lSize + 1)*2)
	xAddMesh(lBlock, lWall)
	xPositionMesh(lBlock, 1, 0, lSize + 1)
	xRotateMesh(lBlock, 0, 90, 0)
	xPositionMesh(lBlock, lSize + 1, 0, -1)
	xAddMesh(lBlock, lWall)
	xPositionMesh(lBlock, -(lSize+1)*2, 0, 2)
	xAddMesh(lBlock, lWall)
	xFreeEntity(lBlock)
	xEntityTexture(lWall, checkerTex)
	xEntityColor(lWall, 128, 128, 142)
	xPositionEntity(lWall, lSize, 0, lSize)
	xEntityAddTriMeshShape(lWall)
	
	Return lTerr
End Function

Function GenerateBalls(size%, number% = 10)
	For i = 1 To number
		b.tBall = New tBall
		b\torqueX = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\torqueY = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\torqueZ = Sgn(Rand(0, 1) * 2 - 1) * torqueScale
		b\entity = xCreateSphere()
		xScaleEntity(b\entity, ballSize, ballSize, ballSize)
		b\fraction = Rand(0, 1)
		If b\fraction
			b\rColor = 255
			b\gColor = 0;127
			b\bColor = 0
		Else
			b\rColor = 0;127
			b\gColor = 127;0
			b\bColor = 255
		EndIf
		b\paleCoeff = normPaleCoeff
		xEntityColor(b\entity, b\rColor * b\paleCoeff, b\gColor * b\paleCoeff, b\bColor * b\paleCoeff)
		xPositionEntity(b\entity, size / 2 + Rand(-size /4 + 1, size /4 - 1), size / 4, size / 2 + Rand(-size /4 + 1, size /4 - 1))
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
			If Rand(10) = 5
				xEntityApplyCentralForce(b\entity, 0.0, 400.0, 0.0, True)
			EndIf
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