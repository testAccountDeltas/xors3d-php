'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Render to texture sample, (c) 2010 Xors3D Team   *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialization
xAppTitle "Render to texture"
xGraphics3D 800, 600, 32, False, True
xCreateDSS 1024, 1024

' enabling antialiasing
xAntiAlias True

' setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPIC

' creating the camera
cam = xCreateCamera()
xPositionEntity cam, 15, 10, -100

' font loading
arial = xLoadFont("Arial", 12)

' light source creating
light1 = xCreateLight(LIGHT_DIRECTION)
xRotateEntity light1, -45, 0, 0

' creating the cube
cube = xCreateCube()
xScaleEntity cube, 10, 10, 10

' creating the texture and putting it on the cube
test = xCreateTexture(512, 512)
xEntityTexture cube, test

' creating the sphere and hiding it
sph = xCreateCube()
xScaleEntity sph, 10, 10, 10
xEntityShininess sph, 1
xEntityColor sph, 255, 0, 0
xHideEntity sph

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	' set the texture as a render target
	xSetBuffer xTextureBuffer(test)
	
	' hiding the cube and unhiding the sphere
	xShowEntity sph
	xHideEntity cube
	
	' buffer clearing
	xCameraClsColor cam, 192, 192, 192
	xCls
	
	' rendering the world
	xRenderWorld
	
	' hiding the sphere and unhinding the cube
	xHideEntity sph
	xShowEntity cube
	
	' setting the backbuffer as a render target
	xSetBuffer xBackBuffer()
	xCameraClsColor cam, 0, 0, 0
	
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

	' turn cube
	xTurnEntity cube,0,1,0
	
	' updating and rendering the world
	xUpdateWorld
	xRenderWorld
	
	' fps and triangle counets
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Polygons: " + xTrisRendered()

	' drawing
	xFlip
	
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function