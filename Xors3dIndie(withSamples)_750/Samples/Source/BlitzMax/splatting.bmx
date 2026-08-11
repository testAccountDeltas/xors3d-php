'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Terrain splatting sample, (c) 2010 Xors3D Team   *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialization
xSetAntiAliasType xGetMaxAntiAlias()
xAppTitle "Terrain"
xGraphics3D 1024, 768, 32, True, True

' enabling antialiasing
xAntiAlias True

' setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPICX16

' creating the cameta
cam = xCreateCamera()
xPositionEntity cam, 2048, 100, 2048
xCameraClsColor cam, 92, 152, 192
xCameraRange cam, 0.25, 1000
xCameraFogColor cam, 92,152, 192
xCameraFogRange cam, 300, 1000
xCameraFogMode cam, 1

' loading the font
arial = xLoadFont("Arial", 12)

' creating the terrain
terr = xLoadTerrain("../../media/textures/terrain2.png")
xScaleEntity terr, 4, 350, 4

' load textures for splatting
grass1_diff = xLoadTexture("../../media/textures/grass1_diff.dds")
grass2_diff = xLoadTexture("../../media/textures/grass3_diff.dds")
rock_diff   = xLoadTexture("../../media/textures/rock_diff.dds")
mask        = xLoadTexture("../../media/textures/mask.png")

' scale textures
scale_1# = 64.0
scale_2# = 128.0
xScaleTexture grass1_diff, 1.0 / scale_2, 1.0 / scale_2
xScaleTexture grass2_diff, 1.0 / scale_1, 1.0 / scale_1
xScaleTexture rock_diff,   1.0 / scale_2, 1.0 / scale_2

' apply textures to terrain and enable splatting
xEntityTexture terr, rock_diff,   0, 0
xEntityTexture terr, grass2_diff, 0, 1
xEntityTexture terr, grass1_diff, 0, 2
xEntityTexture terr, mask,        0, 3
'xEntityTexture terr, lightmap,    0, 7 ' <- 7-th texture layer reserved for terrain lightmap
xTerrainSplatting terr, True

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5
camerasmoothness# = 4.5

' main loop
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
	
	' setting the camera above the terrain
	x# = xEntityX(cam)
	y# = xEntityY(cam)
	z# = xEntityZ(cam)
	terra_y# = xTerrainY(terr, x#, y#, z#) + 5
	If xEntityY(cam, True) < terra_y# Then xPositionEntity cam, x#, terra_y#, z#
	
	' updating and rendering the world
	xUpdateWorld
	xRenderWorld
	
	' fps and triangle counter
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Polygons on terrain: " + xTerrainSize(terr) * xTerrainSize(terr) * 2
	xText 10, 50, "Polygons rendered: " + xTrisRendered()
	
	' drawing the scene
	xFlip
Wend
End

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function