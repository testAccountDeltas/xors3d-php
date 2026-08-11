;Anim Image Sample(version 1.7x)
;(ñ) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xSetFont xLoadFont("Tahoma",13) : xCreateLight() : Musor() : cam=xCreateCamera() : xCameraClsColor cam,40,40,40



; The old way to load animated image is to load textyre and create an image from the texture
;
;	loading animated texture (23 frames)
;	texA=LoadAnimTexture("media\wateranim.jpg", 1+8+256, 124, 124, 0, 23)
;
;	creating animated image and setting the size of one frame
;	imgFastAnim=CreateImageEx( texA, 124,124, FI_FILTERED Or FI_MIDHANDLE )


; New way is much easier. Flags 8 and 256 are setted automatically.
	imgFastAnim = xLoadAnimImageEx( "..\media\wateranim.jpg", 1, 124,124, 0,23, FI_FILTERED Or FI_MIDHANDLE )



; setting the frame counter to zero
frame=0 : rotation=0 : scale=0



While Not xKeyHit (1)
	MouseLook(cam)   :   xRenderWorld


	;starting drawing
	xStartDraw
		; setting color and blend type for drawing
		xSetBlend FI_SOLIDBLEND
		xSetColor 255,255,255
		; setting angle and scale to default
		xSetRotation 0
		xSetScale 1,1
		
		;drawing animated image (frames 0 - 22)
		xDrawImageEx imgFastAnim, 100, 100, (frame Mod 23)

		;now lets try differnt settings
		xSetBlend FI_ALPHABLEND
		xSetColor 255,255,0
		xSetAlpha 0.5
		xDrawImageEx imgFastAnim, 170, 170, (frame Mod 23)
		xSetColor 255,0,255
		xDrawImageEx imgFastAnim, 240, 240
		
		xSetColor 0,255,0
		xSetScale 1.2+Sin(scale),1.2+Sin(scale)
		xSetRotation rotation
		xSetAlpha 0.8
		xDrawImageEx imgFastAnim, xMouseX(), xMouseY(), (frame Mod 23)

		;ending drawing
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