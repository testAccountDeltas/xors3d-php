; DrawTextRect example -  FastImage (версия 1.7x)
; (c) 2010 Created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initialize FastImage library after Graphics3D with command xInitDraw
xInitDraw



xCreateLight : Musor : cam=xCreateCamera() : xCameraClsColor cam,40,40,40


; loading the font for text output
fontFast=xLoadImageFont("..\media\Tahoma.txt")


; string for a test
MyString$ = "Test VeryVeryLooooongWord test text test"+Chr(10)+Chr(10)+"(: Text test Text test Text test Text :)"



While Not xKeyHit (1)
	MouseLook cam   :   xRenderWorld



	; starting drawing
	xStartDraw
		xSetBlend FI_ALPHABLEND   :   xSetAlpha 1


		; drawing bounds of text (for visual aid)
		DrawBoxes

	
		; setting necessary font
		xSetImageFont fontFast


		; output of formatted text
		; (without word division,
		; aligned vertically by the top edge)
		xDrawTextRect MyString, 20,20,100,100				; horizontally by the left edge
		xDrawTextRect MyString, 350,20,100,100, 1			; horizontally centered
		xDrawTextRect MyString, 680,20,100,100, 2			; horizontally by the right edge

	
		; with automated word division
		; vertically centered
		xDrawTextRect MyString, 20,170,100,100, 4, 1		; by the right edge
		xDrawTextRect MyString, 350,170,100,100, 4+1, 1		; centered
		xDrawTextRect MyString, 680,170,100,100, 4+2, 1		; by the left edge

		
		; with automated word division
		; vertically aligned by the bottom edge
		xDrawTextRect MyString, 20,320,100,100, 4, 2
		xDrawTextRect MyString, 350,320,100,100, 4+1, 2
		xDrawTextRect MyString, 680,320,100,100, 4+2, 2


		; setting a color (color of each vertex) for each letter, to make more fun :D
;		xSetCustomColor $FFFFFFFF, $FFFFFF00, $FF00FF00, $0000FF00
		xSetCustomColor $FF00FF00, $0000FF00, $FFFF0000, $FFFF0000

		; usage of paremeter which sets vertical distance between lines
		h0 = xDrawTextRect ( MyString, 20,470,100,100, 4,0, 4 )			; +4 pts between lines
		h1 = xDrawTextRect ( MyString, 350,470,100,100, 4+1,0, -4 )		; -4 - too thick text
		h2 = xDrawTextRect ( MyString, 680,470,100,100, 4+2,0, 8 )		; +8 - too thin


		; drawing the height of each line for visual aid
		xDrawRect 124, 470, 4, h0
		xDrawRect 454, 470, 4, h1
		xDrawRect 784, 470, 4, h2

	; end of drawing
	xEndDraw 



	xFlip
Wend








Function DrawBoxes()
		xSetColor 96,96,96  :  xDrawLine 20,0,20,600  :  xDrawLine 400,0,400,600 : xDrawLine 780,0,780,600
		For y=20 To 600 Step 150
			xDrawRect 20,y,100,100,0
			xDrawRect 350,y,100,100,0
			xDrawRect 680,y,100,100,0
		Next
		xSetColor 255,255,255
End Function

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
		xEntityAlpha cub,0.2
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function