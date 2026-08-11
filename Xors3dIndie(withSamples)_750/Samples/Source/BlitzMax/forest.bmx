'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Forest sample, (c) 2009 Xors3D Team              *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' list for particles
Global particles:TList = New TList

' setup maximum supported AntiAlias Type
xSetAntiAliasType 0 'xGetMaxAntiAlias()

' set application window caption
xAppTitle "Forest sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True
xSetEngineSetting("LoadMesh::RelativePaths", "false")
xCreateDSS 1024, 1024

' set texture filtring
xSetTextureFiltering TF_ANISOTROPICX16

' hide mouse pointer
xHidePointer()

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()
xCameraRange camera, 0.1, 1000
cameraDist = 50

'create a terrain
terrain = xLoadTerrain("../../media/textures/height_map.bmp")
xTerrainShading terrain, True
xScaleEntity terrain, 10, 70, 10
' load grass texture
grass = xLoadTexture("../../media/textures/gras_diffuse_1a.jpg")
xScaleTexture grass, 0.01, 0.01
xEntityTexture terrain, grass, 0, 0

' create forest
bereza = xLoadMesh("../../media/meshes/bereza2.b3d")
amount = 300
For i = 0 To amount
	copy = xCopyEntity(bereza)
	x# = Rand(0, 2000)
	z# = Rand(0, 2000)
	y# = xTerrainY(terrain, x#, y#, z#) - 1
	xPositionEntity copy, x, y, z
	xRotateEntity copy, Rnd(0.0, 2.0), Rnd(0.0, 90.0), Rnd(0.0, 2.0)
	xScaleEntity copy, 20, 20, 20
Next

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' create light
light = xCreateLight()
xRotateEntity light, 45, 0, 0

' create skybox
skybox = xLoadMesh("../../media/meshes/skydome.b3d")
xEntityFX skybox, 1
xScaleEntity skybox, 0.5, 0.5, 0.5
xEntityColor skybox, 255, 255, 255
xEntityOrder skybox, 1

' warrior
warrior = xLoadAnimMesh("../../media/meshes/kuznec.b3d")
xEntityColor warrior, 255, 255, 255
x# = 1000
z# = 1000
y# = xTerrainY(terrain, x#, y#, z#)
xPositionEntity warrior, x, y, z
xScaleEntity warrior, 5, 5, 5
xExtractAnimSeq(warrior, 14, 18)
animIdle = 1
xExtractAnimSeq(warrior, 20, 59)
animRun = 2
currAnim = animIdle
lastAnim = 0
xAnimate warrior, 2, 0.1, currAnim

' shadows
xInitShadows(1024, 0, 0)

' set shadows params
enableShadows = 1
xEntityCastShadows terrain, light, False
xLightEnableShadows light, 1
xSetShadowParams 2, 0.6, True, 750
xLightShadowEpsilons light, 0.0005, 0.16
xCameraEnableShadows camera

' fire
koster = xLoadAnimMesh("../../Media/Meshes/koster.b3d")
xEntityColor koster, 255, 255, 255
xScaleEntity koster, 0.07, 0.07, 0.07
x# = 1010
z# = 1000
y# = xTerrainY(terrain, x#, y#, z#)
xPositionEntity koster, x, y, z
flameEmiter = koster 'xFindChild(koster, "flame")
flame = xLoadTexture("../../Media/Textures/fire.jpg", 1 + 2)
xTextureBlend flame, 5

' main program loop
While Not xKeyDown(xKEY_ESCAPE)

	' warrior control
	lastAnim = currAnim
	currAnim = animIdle
	lastMoveZ = movez
	movez = 0
	If xKeyDown(xKEY_W) Then
		xMoveEntity warrior,  0,  0,  1
		currAnim = animRun
		movez =  1
	EndIf
	If xKeyDown(xKEY_S) Then
		If lastMoveZ = 0 Or lastMoveZ = 1
			move = -1
		Else If lastMoveZ = -1
			move = 1
		EndIf
		xMoveEntity warrior,  0,  0,  1
		currAnim = animRun
		movez = -1
	EndIf
	
	' camera look
	If xMouseDown(2) Then
		cameraDist = cameraDist + (xMouseYSpeed() * mousespeed)
		If cameraDist < 10 Then cameraDist = 10
		If cameraDist > 100 Then cameraDist = 100
		xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	Else
		mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
		mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
		camxa# = camxa - mxs Mod 360
		camya# = camya + mys
		If camya < 0  Then camya = 0
		If camya > 45 Then camya = 45
		cameraDist = cameraDist + (xMouseZSpeed() * 3)
		xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
		xRotateEntity camera, camya, camxa, 0.0
		If cameraDist < 10 Then cameraDist = 10
		If cameraDist > 100 Then cameraDist = 100
	EndIf
	
	'setting the warrior above the terrain
	x# = xEntityX(warrior)
	y# = xEntityY(warrior)
	z# = xEntityZ(warrior)
	terra_y# = xTerrainY(terrain, x#, y#, z#)
	xPositionEntity warrior, x#, terra_y#, z#
	xPositionEntity camera, xEntityX(warrior), xEntityY(warrior) + 10, xEntityZ(warrior)
	If movez <> 0 Or movex <> 0
		If movez = -1 Then 
			xRotateEntity warrior, 0, xEntityYaw(camera) + 180, 0
		Else
			xRotateEntity warrior, 0, xEntityYaw(camera), 0
		EndIf
	EndIf
	xMoveEntity camera, 0, 0, -cameraDist
	
	' position skybox
	xPositionEntity skybox, xEntityX(camera), xEntityY(camera), xEntityZ(camera)
	
	' switch animation
	If currAnim <> LastAnim
		If currAnim = animRun
			xAnimate warrior, 1, 1.7, currAnim
		Else If currAnim = animIdle
			xAnimate warrior, 2, 0.1, currAnim
		EndIf
	EndIf
	
	' update flame
	If MilliSecs() > lastCreated
		px# = xEntityX(flameEmiter, True) + Rnd(-0.1, 0.1)
		py# = xEntityY(flameEmiter, True)
		pz# = xEntityZ(flameEmiter, True) + Rnd(-0.1, 0.1)
		CreateParticle(px, py, pz, flame)
		lastCreated = MilliSecs() + 25
	EndIf
	UpdateParticles()
	
	' switch shadows on/off
	If xKeyHit(xKEY_Q) Then enableShadows = 1 - enableShadows
	
	' update animations
	xUpdateWorld()
	
	' render scene
	xRenderWorld(1.0, enableShadows)
	
	' draw text
	xText 10, 10, "TrisRendered: " + xTrisRendered()
	xText 10, 30, "FPS: " + xGetFPS()
	xText 10, 50, "DIP calls: " + xDIPCounter()
	shadowsState$ = "enabled"
	If enableShadows = 0 Then shadowsState$ = "disabled"
	xText 10, 70, "Q - enable\disable shadows (" + shadowsState$ + " now)"
	
	' switch back buffer
	xFlip()
	
Wend

' for particles
Type TParticle
	Field entity%
	Field speed#
	Field alpha#
End Type

Function UpdateParticles()
	For particle:TParticle = EachIn particles
		If particle.entity
			xTranslateEntity particle.entity, 0.0, particle.speed, 0.0
			particle.alpha# = particle.alpha# - 0.05
			xEntityAlpha particle.entity, particle.alpha#
			If particle.alpha# < 0.001
				xFreeEntity particle.entity
				particles.Remove particle
				'Release particle
			EndIf
		EndIf
	Next
End Function

Function CreateParticle(x#, y#, z#, texture)
	newParticle:TParticle = New TParticle
  newParticle.entity = xCreateSprite(0)
	xEntityTexture newParticle.entity, texture
	xEntityFX newParticle.entity, 1
	xEntityBlend newParticle.entity, 3
	xPositionEntity newParticle.entity, x#, y#, z#
	xScaleSprite newParticle.entity, Rnd(2.0, 5.0), Rnd(2.0, 5.0)
	newParticle.speed# = Rnd(0.2, 0.5)
	newParticle.alpha# = 1.0
	particles.AddLast newParticle
End Function

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

' Function for sky box creating
Function CreateSkyBox%(skyPath$)
	skybox = xCreateMesh()
	' Left
	texture = xLoadTexture(skyPath + "sky_left.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0,  1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0,  1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Front
	texture = xLoadTexture(skyPath + "sky_front.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, 1.0, 0.0, 0.0)
	v1 = xAddVertex(surface,  1.0,  1.0, 1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, 1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, -1.0, 1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Right
	texture = xLoadTexture(skyPath + "sky_right.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, 1.0,  1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, 1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, 1.0, -1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, 1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Back
	texture = xLoadTexture(skyPath + "sky_back.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface,  1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Bottom
	texture = xLoadTexture(skyPath + "sky_down.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0, -1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface,  1.0, -1.0,  1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' Top
	texture = xLoadTexture(skyPath + "sky_up.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture brush, texture
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0, 1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0, 1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, 1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, 1.0, -1.0, 1.0, 1.0)
	xAddTriangle surface, v2, v1, v0
	xAddTriangle surface, v1, v2, v3
	' set FX flags
	xEntityFX skybox, 1
	xFlipMesh skybox
	xUpdateNormals skybox
	' return skybox handle
	Return skybox
End Function