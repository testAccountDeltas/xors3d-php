; DrawTextRect example -  FastImage (версия 1.7x)
; (c) 2010 Created by MixailV aka Monster^Sage [monster-sage@mail.ru]

; TextRectCount%()
; TextRectMaxWidth%()
; TextRectWidth%(StringNumber%)



Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initialize FastImage library after Graphics3D with command xInitDraw
xInitDraw



xCreateLight : Musor : cam=xCreateCamera() : xCameraClsColor cam,40,40,40



; loading the font for text output
fontFast=xLoadImageFont("..\media\Tahoma.txt")


; string for a test
MyString$ = "Nulla facilisi. Maecenas AccumsanGravidaWisi. Maecenas SodalesGravida neque. Mauris in este ante molestie gravida."+Chr(13)+Chr(13)+ "In id neque. Ut augue. Duis fringilla ullamcorper risus. Nullam at lorem. Quisque consequat. In id neque. Ut augue. Duis fringilla ullamcorper."+Chr(13)+"Nullam at lorem."



While Not xKeyHit (1)
	MouseLook cam   :   xRenderWorld


	; start of drawing
	xStartDraw
		xSetBlend FI_ALPHABLEND   :   xSetAlpha 1
		
		Height = xDrawTextRect ( MyString, 100, 100, 200, 200, 8+4,0 )		; <<< 8 - don't draw,  4 - word division
		Count = xTextRectCount()											; number of strings
		MaxWidth = xTextRectMaxWidth()										; maximum width of the string
		LastWidth = xTextRectWidth(Count-1)									; width of the last string
		
		xSetColor 46,136,56
		xDrawRect 100, 100, 200, 200, 0										; drawing the rectangle around the text
		xDrawRect 90, 100, 2, Height										; and height of the string
		xDrawRect 100, 90, MaxWidth, 2										; and the width of the longest string
		xDrawRect 100, 308, LastWidth, 2									; and the width of the last string
		

		; setting the necessary font
		xSetImageFont fontFast
		xSetColor 255,255,255
		xDrawTextRect ( MyString, 100, 100, 200, 200, 4,0 )	

	; end of drawing
	xEndDraw 


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
	For i=1 To 250
		cub=xCreateCube()
		xEntityColor cub,Rand(128,135),Rand(128,135),Rand(128,135)
		xPositionEntity cub,Rnd(-10,10),Rnd(-10,10),Rnd(-10,10)
		xEntityAlpha cub,0.2
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function