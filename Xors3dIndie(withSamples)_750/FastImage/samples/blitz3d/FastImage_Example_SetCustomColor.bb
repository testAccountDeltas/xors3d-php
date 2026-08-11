;Set Custom Color Sample(version 1.7x)
;(c) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xSetFont xLoadFont("Tahoma",9)
xCreateLight()
Musor()
cam=xCreateCamera()
xCameraClsColor cam,128,100,100


tex=xLoadTexture ("..\media\devil.png",1+2)		;loading textures with alpha channel


; creating images from texture loaded earlier
; setting size for that case if size of image should differ from size of texture
imgFast=xCreateImageEx(tex, 256, 256, FI_FILTEREDIMAGE)


fontFast=xLoadImageFont("..\media\Tahoma.txt")

xSetImageFont fontFast
		
		

While Not xKeyHit (1)
	MouseLook(cam)


	xRenderWorld


	;start drawing
	xStartDraw
		;drawing transparent windows

		DrawWindow 50,50,300,200, "SetCustomColor", imgFast
		DrawWindow 250,150,300,300, "Simple"
		DrawWindow 100,290,300,200, "Example", imgFast

		;end drawing
	xEndDraw 


	xText 10,10,"Use W,A,S,D and Mouse for fly"
	xFlip
Wend


Function DrawWindow(x,y,w,h,head$="",img=0)
	xSetBlend FI_ALPHABLEND
	
	; setting custom color and alpha for each vertex of the primitive
	xSetCustomColor $E0FFFFFF, $E0808080, $E0404040, $E0808080
	; drawing the rectangle (not solid)
	xDrawRectSimple x,y,w,h,0
	xSetCustomColor $E0FFFFFF, $E0808080, $E0606060, $E0808080
	; drawing another rectangle to make border thicker
	xDrawRectSimple x+1,y+1,w-2,h-2,0
	xSetCustomColor $E0eeeae1, $E0eeeae1, $E0aba8a2, $E0aba8a2
	; inner rectangle with gradient
	xDrawRectSimple x+2,y+2,w-4,h-4
	xSetCustomColor $E00a246a, $E0a6caf0, $E0a6caf0, $E00a246a
	; drawing the title of the window on the gradient
	xDrawRectSimple x+3,y+4,w-8,18

	xSetColor 255,255,255
	If img<>0 Then
		xSetAlpha 1
		xSetColor 255,255,255
		; drawing the icon
		xDrawImageRectEx img,x+5,y+5,16,16
		; text output
		xDrawText head, x+24, y+6
	Else		
		xDrawText head, x+7, y+6
	EndIf
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
		;xEntityAlpha cub,Rnd(0.5,1.0)
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function