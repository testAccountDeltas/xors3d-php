;DrawImagePart Sample(version 1.7x)
;(ñ) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

;DrawImagePart% (image%, x%, y%, width%, height%, tx%=0, ty%=0, twidth%=0, theight%=0, frame%=0)
; x - X coord
; y - Y coord
; width - visible Width
; heigth - visible Heigth
; tx - displace X in image
; ty - displace Y in image
; twidth - part Width of image
; theight - part Height of image
; frame - frame of image


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


; loading textures to create images
tex1=xLoadTexture ("..\media\devil.png",1+2)
tex2=xLoadTexture ("..\media\tounge.png",1+2)	



; creating images
imgFast1=xCreateImageEx(tex1, 256, 256, FI_FILTERED)
imgFast2=xCreateImageEx(tex2, 256, 256, FI_NONE)


x=0
y=0

While Not xKeyHit (1)
	MouseLook(cam)


	xRenderWorld


	; starting drawing
	xStartDraw
		xSetBlend FI_ALPHABLEND
		xSetAlpha 1

		xSetColor 255,255,0
		xDrawImagePart (imgFast1, 10, 600-256-10, 256, 128, 0, 0, 768, 256, 0, FI_WRAPU)
		
		xSetColor 0,255,255
		xDrawImagePart (imgFast1, 0, 600-128, 800, 128, x, y, 4000, 768, 0, FI_MIRRORUV)
		x=x+2 : y=y+1

		xSetColor 255,255,255
		xDrawImageEx imgFast1,10,10
		xDrawImageEx imgFast2,xGraphicsWidth()-256-10,10

		xSetAlpha 0.5
		xDrawImagePart (imgFast1, xMouseX()-64, xMouseY()-64, 256, 256, 64, 64, 128, 128)
		
		xSetAlpha 1
		xDrawImagePart (imgFast1, xMouseX()-128, xMouseY()-128, 128, 128, 0, 0)
		xDrawImagePart (imgFast1, xMouseX()+128, xMouseY()-128, 128, 128, 128, 0)
		xDrawImagePart (imgFast1, xMouseX()-128, xMouseY()+128, 128, 128, 0, 128)
		xDrawImagePart (imgFast1, xMouseX()+128, xMouseY()+128, 128, 128, 128, 128)
		xDrawImagePart (imgFast2, xMouseX(), xMouseY(), 128, 128, 64, 64)
		
		; ending drawing
	xEndDraw 

	frame=frame+1

	rotation=rotation+1
	scale=scale+2

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
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function