Include "..\xors3d.bb"

xCreateLog()

xGraphics3D 1024,768, 32, 0, 1
xSetBuffer xBackBuffer()

; Create first camera
cam1=xCreateCamera()

; Set the first camera's viewport so that it fills the top half of the  camera
w = xGraphicsWidth()
h = xGraphicsHeight()/1.777
xCameraViewport cam1, 0, (xGraphicsHeight() - h)/2, w, h
xCameraViewport cam1, 1025, 769, 1024, 768

light=xCreateLight()
xRotateEntity light,90,0,0

Garbage()

back = xCreateCube()
xEntityColor back, 255, 0, 0
xFlipMesh back
xScaleEntity back, 500.0, 500.0, 500.0

While Not xKeyDown( 1 )
	xCls()
	If xKeyDown( 205 )=True Then xTurnEntity cam1,0,-1,0
	If xKeyDown( 203 )=True Then xTurnEntity cam1,0,1,0
	If xKeyDown( 208 )=True Then xMoveEntity cam1,0,0,-0.05
	If xKeyDown( 200 )=True Then xMoveEntity cam1,0,0,0.05
	
	xRenderWorld
	
	xText 10, 10, "Use cursor keys to move first camera"
	
	xFlip
	
Wend

End

Function Garbage(n% = 100)
	For i = 1 To n
		cube = xCreateCube()
		xPositionEntity cube, Rnd(-20.0, 20.0), Rnd(-20.0, 20.0), Rnd(-20.0, 20.0)
		xTurnEntity cube, Rnd(360.0), Rnd(360.0), Rnd(360.0)
		xEntityColor cube, Rand(127, 255), Rand(127, 255), Rand(127, 255)
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D