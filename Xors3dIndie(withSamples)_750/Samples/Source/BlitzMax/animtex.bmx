'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Animated texture sample, (c) 2010 Xors3D Team    *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialization
xAppTitle "Animation texture"
xGraphics3D 800, 600, 32, False, True

' enabling antialiasing
xAntiAlias True

' setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPIC

' camera creating
camera = xCreateCamera()
xPositionEntity camera, 0, 10, -170

' light source creating
light = xCreateLight()
xRotateEntity light, -45, 0, 0

' creating of the cube
cube = xCreateCube()

' animated texture loading
xScaleEntity cube, 20, 20, 20
anim_tex = xLoadAnimTexture("../../media/textures/boomstrip.bmp", 1, 64, 64, 0, 39)

' setting the colour of camera clearing
xCameraClsColor camera, 192, 192, 192

' font loading
arial = xLoadFont("Arial", 12)

' main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	' counting for changing texture frame
	frame = MilliSecs() / 50 Mod 39
	
	' putting texture on the cube
	xEntityTexture cube, anim_tex, frame
	
	' cube rotation
	pitch# = 0
	yaw#   = 0
	roll#  = 0
	If xKeyDown(208) Then pitch# = -1
	If xKeyDown(200) Then pitch# =  1
	If xKeyDown(203) Then yaw#   = -1
	If xKeyDown(205) Then yaw#   =  1
	If xKeyDown(45)  Then roll#  = -1
	If xKeyDown(44)  Then roll#  =  1
	xTurnEntity cube, pitch#, yaw#, roll#
	
	' rendering of the world
	xRenderWorld
	
	' fps counter and debug info
	xColor 0, 0, 0
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "Up\Down\Left\Right\Z\X - rotate cube" 

	' drawing the scene
	xFlip

Wend