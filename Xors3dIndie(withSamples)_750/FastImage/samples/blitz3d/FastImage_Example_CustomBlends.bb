;Custom Blends Sample(version 1.7x)
;(ñ) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"


xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xSetFont xLoadFont("Tahoma",13)
xCreateLight()
Musor()
cam=xCreateCamera()


;loading textures with alpha channel
tex1=xLoadTexture ("..\media\Test.png",1+2)


; creating images from texture loaded earlier
; setting size for that case if size of image should differ from size of texture
imgFast1=xCreateImageEx(tex1, 256, 256, FI_AUTOFLAGS)


; default blend mode (alphablend)
SrcBlend=5
DestBlend=6


While Not xKeyHit (1)
	MouseLook(cam)
	
	
	; generating random blend mode
	If xKeyHit(57)
		SeedRnd MilliSecs()
		SrcBlend=Rand(1,10)
		DestBlend=Rand(1,10)
	EndIf


	; drawing a background with gradient
	xCls
	xStartDraw
		; applying all settings
		xSetBlend FI_SOLIDBLEND
		xSetCustomColor $00FFFFFF, $00FFFFFF, 0, 0
		xDrawRectSimple 0,0,800,600,1
	xEndDraw
	;this is needed to avoid erasing our background image by rendering
	xCameraClsMode cam, 0, 1


	xRenderWorld


	; starting drawing
	xStartDraw	
		xSetColor 255,255,255
		; setting our custom blend mode generated randomly
		xSetCustomBlend SrcBlend, DestBlend
		;drawing the smile running after the mouse cursor
		xDrawImageEx imgFast1, xMouseX(), xMouseY()
		; ending drawing
	xEndDraw 

	xColor 0,0,0
	xText 10,10,"Use W,A,S,D and Mouse to fly"
	xText 10,40,"Press SPACE key for random custom blending"
	xText 10,55,"Source operation: "+Str(SrcBlend)
	xText 10,70,"Destination operation: "+Str(DestBlend)
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
