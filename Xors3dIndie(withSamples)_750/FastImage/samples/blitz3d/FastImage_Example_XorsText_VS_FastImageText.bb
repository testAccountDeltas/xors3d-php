;FastImageText Sample(version 1.7x)
;(ñ) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 0
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xFont = xLoadFont("Tahoma",8)
xCreateLight()
Musor()
cam=xCreateCamera()
xCameraClsColor cam,40,40,40



; loading special font using lib
fontFast=xLoadImageFont("..\media\Tahoma.txt")



mode=0
While Not xKeyHit (1)

	MouseLook(cam)
	xRenderWorld
	xColor 255,255,255


	If xKeyHit(57)<>0 Then mode=1-mode
	time=MilliSecs()


	If mode=1
	
		;---- Xors3D
		xSetFont xFont
		xText 10,10,"Press SPACE for mode change:  Xors3D Text"
		y=40
		For i=0 To 54
			xText 10,y,"Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text   Xors3D Text"
			y=y+10
		Next 	
	
	Else
	
		;---- FastImage
		xStartDraw
			xSetImageFont fontFast
			xSetBlend FI_ALPHABLEND
			xSetAlpha 1
			xDrawText "Press SPACE for mode change:  FastImage DrawText",10,10
			xSetAlpha 0.55+0.45*Sin(a) : a=a+5
			y=40
			For i=0 To 54
				xDrawText "FastImage DrawText    FastImage DrawText    FastImage DrawText    FastImage DrawText    FastImage DrawText    FastImage DrawText    FastImage DrawText",10,y
				y=y+10
			Next
		xEndDraw 
	
	EndIf




	time=MilliSecs()-time
	xText 400,10,"Time: "+Str(time)+" ms"
	xColor 40,40,40
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