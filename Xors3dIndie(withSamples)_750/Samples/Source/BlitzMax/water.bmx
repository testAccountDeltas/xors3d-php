'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Water sample, (c) 2010 Xors Team                 *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialization
xAppTitle "Water"
xGraphics3D 800, 600, 32, False, True
xCreateDSS(1024, 1024)
Global frame = 0

' camera creating
cam = xCreateCamera()
xPositionEntity cam, 0, 10, -50
xRotateEntity cam, 0, 180, 0
xCameraClsColor cam, 192, 192, 192
cube_cam = xCreateCamera()
xHideEntity cube_cam
xCameraClsMode cube_cam, False, True
xCameraZoom cube_cam, 0

' enabling antialiasing
xAntiAlias True

' objects loading
water = xLoadMesh("../../media/meshes/water.b3d")
xPositionEntity water, 0, -5, -200
scene = xLoadMesh("../../media/meshes/level.b3d")

' creating the light source
light = xCreateLight()
xRotateEntity light, -45, 0, 0

' loading the effect from file
waterFX = xLoadFXFile("../../media/shaders/water.fx")

' checking if this technique is supported by hardware
If xValidateEffectTechnique(waterFX, "Water") = False
	RuntimeError "Technique does not supported!"
EndIf

' loading the textures
texEnv = xCreateTexture(512, 512, 128 + 48)
noise  = xLoadTexture("../../media/textures/noise.dds", 1 + 512)

' setting the effect and constants
xSetEntityEffect water, waterFX
xSetEffectTechnique(water, "Water")
xSetEffectMatrixSemantic water, "world_matrix", WORLD
xSetEffectMatrixSemantic water, "view_proj_matrix", VIEWPROJ
xSetEffectTexture water, "Noise_Tex", noise
xSetEffectTexture water, "envBox_Tex", texEnv

startTime = MilliSecs()
xAmbientLight 150, 150, 150
xEntityAlpha water, 0.9

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

While Not xKeyDown(1)

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	' if we can't see teapot then we won't update its texture
	If xEntityInView(water, cam)
		' updating the texture
		UpdateCubemap(texEnv, cube_cam, water, cam)
	EndIf

	' setting the constants
	time_0_X# = Float(MilliSecs() - startTime) / 10000.0
	xSetEffectFloat water, "time_0_X", time_0_X#
	xSetEffectFloat water, "freq", Float(MilliSecs()) / 1000.0
	xSetEffectVector water, "view_position", xEntityX(cam, True), 2, xEntityZ(cam, True)
	
	' rendering the world
	xRenderWorld
	
	' fps output
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	
	' drawing the scene
	xFlip

Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function

' function of texture updating
Function UpdateCubemap(tex, camera, entity, view_cam)
	
	' turning the main camera off
	xHideEntity view_cam
	
	' getting size of the texture
	tex_sz = xTextureWidth(tex)

	' turning the camera on
	xShowEntity camera
	
	' hiding the object so it won't be rendered to the texture
	xHideEntity entity
	
	' moving camera to the position of the object
	xPositionEntity camera, xEntityX(view_cam, True), xEntityY(entity, True) + 2, xEntityZ(view_cam, True)
	frame = 1 - frame
	
	' rendering to the texture
	If frame
		' left plane
		xSetCubeFace tex, 0
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, 0, 90, 0
		xRenderWorld
	
		' front plane
		xSetCubeFace tex, 1
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, 0, 0, 0
		xRenderWorld
		
		' right plane
		xSetCubeFace tex, 2
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, 0, -90, 0
		xRenderWorld
	Else
		' back plane
		xSetCubeFace tex, 3
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, 0, 180, 0
		xRenderWorld
		
		' top plane
		xSetCubeFace tex, 4
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, -90, 0, 0
		xRenderWorld
		
		' bottom plane
		xSetCubeFace tex, 5
		xSetBuffer(xTextureBuffer(tex))
		xCameraViewport camera, 0, 0, tex_sz, tex_sz
		xRotateEntity camera, 90, 0, 0
		xRenderWorld
	EndIf
	' unhiding the object
	xShowEntity entity
	
	'  turning the camera off
	xHideEntity camera
	
	' setting the render to backbuffer
	xSetBuffer(xBackBuffer())
	
	' turning the main camera on
	xShowEntity view_cam
	
End Function