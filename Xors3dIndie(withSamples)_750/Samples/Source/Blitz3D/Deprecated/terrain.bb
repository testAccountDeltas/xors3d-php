;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Terrain sample, (c) 2009 Xors3D Team             *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************

; Include header file
;Include "..\xors3d.bb"
Include "d:\tools\blitz3d\userlibs\xors3d.bb"

; initialization
xSetAntiAliasType xGetMaxAntiAlias()
xAppTitle "Terrain"
xGraphics3D 1024, 768, 32, 0, 0

; enabling antialiasing
xAntiAlias True
xSetEngineSetting("Terrain::HWGeneration", "true")

; setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPICX16

; creating the cameta
cam = xCreateCamera()
xPositionEntity cam, 2048, 0, 2048
xCameraClsColor cam, 192, 192, 192
xCameraRange cam, 0.1, 1000
xCameraFogMode cam, 1
xCameraFogColor cam, 130, 130, 150
xCameraFogRange cam, 500, 1000

; loading the font
arial = xLoadFont("Arial", 12)

; light source creating
light1 = xCreateLight(LIGHT_DIRECTION)
xRotateEntity light1, 45, 0, 0

; creating the terrain
terr = xLoadTerrain("../../../media/textures/terrain.png")
xScaleEntity terr, 1, 200, 1
grass = xLoadTexture("../../../media/textures/IceTerrain.jpg")
xEntityTexture terr, grass, 0, 0
xEntityFX terr, 1

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5
camerasmoothness# = 4.5

; main loop
While Not xKeyDown(1)

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
	terra_y# = xTerrainY(terr, x#, y#, z#) + 5
	xPositionEntity cam, x#, terra_y#, z#
	
	; updating and rendering the world
	xUpdateWorld
	xRenderWorld
	
	; fps and triangle counter
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Polygons on terrain: " + xTerrainSize(terr) * xTerrainSize(terr) * 2
	xText 10, 50, "Polygons rendered: " + xTrisRendered()
	
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
;~IDEal Editor Parameters:
;~C#Blitz3D