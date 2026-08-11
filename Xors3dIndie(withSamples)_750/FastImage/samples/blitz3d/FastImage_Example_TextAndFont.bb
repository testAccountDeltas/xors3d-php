;Text and Font Sample(version 1.7x)
;(c) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]


Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xSetFont xLoadFont("Tahoma",13)
xCreateLight()
Musor()
cam=xCreateCamera()
xCameraClsColor cam,40,40,40




fontFast0=xLoadImageFont("..\media\Font.txt")
fontFast1=xLoadImageFont("..\media\Tahoma.txt")




While Not xKeyHit (1)
	MouseLook(cam)   :   xRenderWorld


	xStartDraw
		xSetImageFont fontFast0

		xSetBlend FI_ALPHABLEND
		xSetAlpha 1
		xSetColor 255,255,255
		xDrawText "FastImage fonts are the fastest fonts in the world :)",xMouseX(),xMouseY(),1,1
		
		xSetAlpha 0.4
		xSetColor 255,0,255
		xSetRotation 45
		xDrawText "Test test TeSt TEST !!!",xMouseX(),xMouseY(),1,1

		xSetBlend FI_LIGHTBLEND
		xSetColor 0,255,0
		xSetRotation 90
		xDrawText "Test this! And be happy :)",xMouseX(),xMouseY(),1,1
		
		xSetImageFont fontFast1

		xSetBlend FI_ALPHABLEND
		xSetAlpha 1
		xSetColor 255,255,0
		xSetRotation 0
		xDrawText "Use W,A,S,D and Mouse to fly",xMouseX(),xMouseY()-30
		
	xEndDraw 

	
	xText 10,10,"Use W,A,S,D and Mouse to fly"
	xFlip
Wend


Function MouseLook(cam)
	dx#=(xGraphicsWidth()/2-xMouseX())*0.01
	dy#=(xGraphicsHeight()/2-xMouseY())*0.01
	xTurnEntity cam,-dy,dx,0
	 If xKeyDown(17) xMoveEntity cam,0,0,.1 
	 If xKeyDown(31) xMoveEntity cam,0,0,-.1
	 If xKeyDown(32) xMoveEntity cam,0.1,0,0 
	 If xKeyDown(30) xMoveEntity cam,-0.1,0,0 
End Function

Function Musor()
	For i=1 To 50
		cub=xCreateCube()
		xEntityColor cub,Rand(128,255),Rand(128,255),Rand(128,255)
		xPositionEntity cub,Rnd(-10,10),Rnd(-10,10),Rnd(-10,10)
		;xEntityAlpha cub,Rnd(0.5,1.0)
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function