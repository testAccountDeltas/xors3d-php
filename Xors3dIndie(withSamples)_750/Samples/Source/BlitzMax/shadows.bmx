'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Shadows sample, (c) 2010 Xors3D Team             *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' disable AntiAlias
xSetAntiAliasType 0

' set application window caption
xAppTitle "Shadows sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True
xCreateDSS 1024, 1024

' set texture filtring
xSetTextureFiltering TF_ANISOTROPICX16

' hide mouse pointer
xHidePointer()

' create camera
camera = xCreateCamera()
xCameraRange camera, 0.1, 1000
xPositionEntity camera, -50, 10, -50
xCameraEnableShadows camera
camxa# = -45
camya# = 5

' create a terrain
terrain = xCreateCube()
xScaleEntity terrain, 200, 0.1, 200
' load grass texture
grass = xLoadTexture("../../media/textures/gras_diffuse_1a.jpg")
xScaleTexture grass, 0.1, 0.1
xEntityTexture terrain, grass, 0, 0

' create forest
bereza = xLoadMesh("../../media/meshes/bereza.b3d")
xScaleEntity bereza, 7, 7, 7

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' create light
light = xCreateLight()
xRotateEntity light, 45, 0, 0
xLightColor light, 25, 25, 25

' create skybox
skybox = xLoadMesh("../../media/meshes/skydome.b3d")
xEntityFX skybox, 1
xScaleEntity skybox, 0.5, 0.5, 0.5
xEntityColor skybox, 15, 15, 15
xEntityOrder skybox, 1

' warrior
warrior = xLoadAnimMesh("../../media/meshes/kuznec.b3d")
xEntityColor warrior, 255, 255, 255
xPositionEntity warrior, 10, 0, -5
xScaleEntity warrior, 5, 5, 5
xExtractAnimSeq(warrior, 20, 59)
xAnimate warrior, 1, 1.2, 1

' assing point light to fire
light2 = xCreateLight(2)
xLightRange light2, 50
xLightColor light2, 255, 0, 0
fire = xLoadMesh("../../media/meshes/koster.b3d")
xPositionEntity fire, -10, 0, -10
xPositionEntity light2, -10, 10, -10
xScaleEntity fire, 0.07, 0.07, 0.07
flame = xLoadTexture("../../media/Textures/fire.jpg", 1 + 2)
xTextureBlend flame, 5

' shadows
xInitShadows(1024, 0, 512)

' set shadows params
xLightEnableShadows light, 1
xSetShadowParams 4, 0.85, True, 300
xLightShadowEpsilons light, 0.0001, 0.16
xLightEnableShadows light2, 1
xLightShadowEpsilons light2, 0.01, 0.0

' list for particles
Global particles:TList = New TList

' main program loop
While Not xKeyDown(xKEY_ESCAPE)

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity camera,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity camera, camya, camxa, 0.0
	
	' update flame
	If MilliSecs() > lastCreated
		px# = xEntityX(fire, True) + Rnd(-0.1, 0.1)
		py# = xEntityY(fire, True)
		pz# = xEntityZ(fire, True) + Rnd(-0.1, 0.1)
		CreateParticle(px, py, pz, flame)
		lastCreated = MilliSecs() + 25
	EndIf
	UpdateParticles()
	
	' move warrior
	xMoveEntity warrior, 0, 0, 0.3
	xTurnEntity warrior, 0, 1, 0
	
	' position skybox
	xPositionEntity skybox, xEntityX(camera), xEntityY(camera) - 1, xEntityZ(camera)
	
	' update animations
	xUpdateWorld()
	
	' render scene
	xRenderWorld(1.0, True)
	
	' draw text
	xText 10, 10, "TrisRendered: " + xTrisRendered()
	xText 10, 30, "FPS: " + xGetFPS()
	xText 10, 50, "DIP calls: " + xDIPCounter()
	
	' switch back buffer
	xFlip()
	
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

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