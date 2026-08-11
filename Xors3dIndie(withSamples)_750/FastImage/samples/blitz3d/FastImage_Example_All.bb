;FastImage Sample(version 1.7x)
;(c) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"




xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw


;xAntiAlias True


xSetFont xLoadFont("Tahoma",13)
xCreateLight()
Musor()
cam=xCreateCamera()


tex=xLoadTexture ("..\media\alien.png")		
tex1=xLoadTexture ("..\media\devil.png",1+2)		;loading textures with alpha channel
tex2=xLoadTexture ("..\media\tounge.png",1+2)


; creating images from texture loaded earlier
; setting size for that case if size of image should differ from size of texture
imgFast=xCreateImageEx(tex, 256, 256, FI_FILTEREDIMAGE)
imgFast1=xCreateImageEx(tex1, 256, 256, FI_AUTOFLAGS)
imgFast2=xCreateImageEx(tex2, 256, 256, FI_AUTOFLAGS)


; creating a lot of objects (images and primitives) with different settings
Type Smile
	Field img
	Field typ, blend
	Field x#, y#, rot#, scale#, alpha#
	Field dx#, dy#, dr#
	Field colr#,colg#,colb#
End Type

For i=1 To 100
	j.Smile = New Smile
	If Rnd(0,1)>0.5
		j\img=imgFast1
	Else
		j\img=imgFast2
	EndIf
	j\blend=Rand(0,2)
	j\typ=Rand(0,2)
	j\x=Rnd(0,800)
	j\y=Rnd(0,600)
	j\rot=Rnd(-180,180)
	j\scale=Rnd(0.1,0.5)
	j\alpha=Rnd(0.51,1.0)
	j\dx=Rand(1,4)
	j\dy=Rand(1,4)
	j\dr=Rnd(-4,4)
	j\colr=Rand(128,255)
	j\colg=Rand(128,255)
	j\colb=Rand(128,255)
Next


While Not xKeyHit (1)
	MouseLook(cam)


	; if you want to draw your 2d behide 3d then you should draw before rendering
	; using xCls and xCameraClsMode camera, 0, 1
	xCls
	; starting drawing
	xStartDraw
		;setting all options
		xSetBlend FI_SOLIDBLEND
		xSetColor 128,128,128
		;drawing the image
		xDrawImageRectEx imgFast, 0, -100, 800, 800
		;ending drawing
	xEndDraw
	;this is needed to avoid erasing our background image by rendering
	xCameraClsMode cam, 0, 1


	xRenderWorld


	;starting drawing
	xStartDraw
		;drawing all images
		For j.Smile = Each Smile
			j\x=j\x+j\dx
			If j\x<0 Or j\x>800
				j\dx=-j\dx
			EndIf
			j\y=j\y+j\dy
			If j\y<0 Or j\y>600
				j\dy=-j\dy
			EndIf
			j\rot=j\rot+j\dr
			xSetRotation j\rot
			xSetScale j\scale,j\scale
			xSetAlpha j\alpha
			xSetColor j\colr, j\colg, j\colb
			xSetBlend j\blend
			Select j\Typ
				Case 0
					xDrawImageEx j\img, j\x, j\y
				Case 1
					xSetHandle 60,25
					xDrawRect j\x, j\y,120,50, 1
				Case 2
					xSetHandle 60,25
					xDrawOval j\x, j\y,120,50
			End Select
		Next
		
		;setting all options to default
		xSetBlend FI_ALPHABLEND
		xSetRotation 0
		xSetScale 1,1
		xSetHandle 0,0
		xSetColor 255,190,0
		xSetAlpha 0.5
		;trying to draw lines
		xSetLineWidth 3.0
		For x=-100 To 800 Step 10
			xDrawLine x,0,x+100,100
		Next

		
		;drawing the smile running after the mouse cursor
		xSetColor 255,255,255
		xSetAlpha 1.0
		xDrawImageEx imgFast1, xMouseX(), xMouseY()

		;getting all properties of the library
		xGetProperty
		; in such way you can use any option of the library (see Type FI_PropertyType)
		; uncomment to see in Debug Mode
		;DebugLog FI_Property\Blend
		;DebugLog FI_Property\Alpha
		;DebugLog FI_Property\Red
		;DebugLog FI_Property\Green
		;DebugLog FI_Property\Blue
		;DebugLog FI_Property\ScaleX
		;DebugLog FI_Property\ScaleY
		;DebugLog " "
		;etc.

		;ending drawing
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
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function