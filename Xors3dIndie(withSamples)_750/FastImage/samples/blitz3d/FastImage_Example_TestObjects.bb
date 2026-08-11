;FastImage Sample(version 1.7x)
;(c) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



xSetFont xLoadFont("Arial Cyr",10) : xCreateLight() : Musor() : cam=xCreateCamera() : xCameraClsColor cam,40,40,40


Global Trans%=0 : Global Ta#=0 : Global Ts#=0 : Global Tr#=0  :   Global Temp%=0


imgFast1 = xLoadImageEx ( "..\media\devil.png", 1+2, FI_FILTERED)
imgFast2 = xLoadImageEx ( "..\media\tounge.png", 1+2, FI_FILTERED)



While Not xKeyHit (1)
	MouseLook(cam)
	xRenderWorld


	mx = xMouseX() : my = xMouseY()
	

	xStartDraw
		xSetBlend FI_ALPHABLEND
		
		
		; только для примера
		MoveProjection



		
		; ---------- TestRect usage example
				
			xSetAlpha 0.1 : xSetRotation 25 : xDrawRect 50,50,150,100 : xSetAlpha 1
	
			; testing if the point (mouse pointer) is situated in the rectangle with size 150x100 and coords 50x50
			If xTestRect (mx,my, 50,50, 150,100) Then
				xDrawImageRectEx imgFast1, 50,50, 150,100
			Else
				xDrawImageRectEx imgFast2, 50,50, 150,100
			EndIf
			
			
			
			
		; ---------- TestImage usage example			
			xSetAlpha 0.1 : xSetRotation -25 : xDrawRect 350,100,256,256 : xSetAlpha 1
	
			; ; testing if the point (mouse pointer) is situated in the image with coords 350x100 (without alphatest)
			If xTestImage (mx,my, 350,100, imgFast1) Then
				xDrawImageEx imgFast1, 350,100
			Else
				xDrawImageEx imgFast2, 350,100
			EndIf
	
	
	

		; ----------- TestRendered usage example
			
			xSetRotation 10   ; just to show that transformation is taken into account

			xSetAlpha 0.5 : xDrawImageEx imgFast1, 50,250
			; alpha is also taken into account, setting the level about 128, so the shadow of the icon will be ignored
			If xTestRendered (mx,my, 128) Then
				xSetAlpha 1
				xDrawImageEx imgFast1, 50,250
			EndIf
			
			
			xSetAlpha 0.1 : xDrawRect 450,400, 150,100
			If xTestRendered (mx,my) Then
				; точка в отрендеренном прямоугольнике!
				xSetAlpha 1
				xDrawRect 450,400, 150,100
			EndIf
			
			
			
			
		; ---------- TestOval usage sample
				
			xSetHandle 100,50 : xSetRotation 50 : xSetAlpha 0.1
			
			If xTestOval (mx,my, 400,300, 200,100) Then
				xSetAlpha 1
				xDrawOval 400,300,200,100
			Else
				xDrawOval 400,300,200,100
			EndIf
			
			xSetHandle 0,0
			



		; ---------- result of testings (for advanced users)
		
			;DebugLog FI_Test\Result
			;DebugLog FI_Test\ProjectedX
			;DebugLog FI_Test\ProjectedY
			;DebugLog FI_Test\RectX
			;DebugLog FI_Test\RectY
			;DebugLog FI_Test\RectU
			;DebugLog FI_Test\RectV
			;DebugLog FI_Test\TextureX
			;DebugLog FI_Test\TextureY
			;DebugLog FI_Test\Texture

		
		; drawing a simple mouse pointer
		xSetProjHandle xGraphicsWidth()/2, xGraphicsHeight()/2
		xSetProjOrigin xGraphicsWidth()/2, xGraphicsHeight()/2
		xSetProjRotation 0
		xSetProjScale 1,1
		xSetAlpha 1   :   xSetScale 1,1   :   xSetRotation 0   :   xSetHandle 0,0   :   xSetColor 0,0,0
		xDrawLine mx-7+1,my+1,mx+7+1,my+1
		xDrawLine mx+1,my-7+1,mx+1,my+7+1
		xSetColor 255,255,255
		xDrawLine mx-7,my,mx+7,my
		xDrawLine mx,my-7,mx,my+7
		

	;end drawing
	xEndDraw
	

	xText 10,10,"Press <Space> to transform projections and objects"
	xFlip
Wend






Function MoveProjection()

	If xKeyHit(57) Then Trans = 1-Trans
	If Trans Then
		xSetProjHandle xGraphicsWidth()/2, xGraphicsHeight()/2
		xSetProjOrigin xGraphicsWidth()/2+50*Cos(Ta), xGraphicsHeight()/2+50*Sin(Ta)
		xSetProjRotation 10*Cos(Tr)-5
		xSetProjScale 0.9+0.2*Cos(Ts), 0.9+0.2*Sin(Ts)
		Ta=Ta+1
		Tr=Tr+1
		Ts=Ts+1
		xSetScale 0.9+0.2*Cos(Ts), 0.9+0.2*Sin(Ts)
	Else
		xSetProjHandle xGraphicsWidth()/2, xGraphicsHeight()/2
		xSetProjOrigin xGraphicsWidth()/2, xGraphicsHeight()/2
		xSetProjRotation 0
		xSetProjScale 1,1
		xSetScale 1,1		
	EndIf
	
	xSetAlpha 0.1 : xSetRotation 0 : xSetScale 1,1 : xDrawRect 0,0,xGraphicsWidth(),xGraphicsHeight(),0
	xDrawLine xGraphicsWidth()/2-4, xGraphicsHeight()/2, xGraphicsWidth()/2+4, xGraphicsHeight()/2
	xDrawLine xGraphicsWidth()/2, xGraphicsHeight()/2-4, xGraphicsWidth()/2, xGraphicsHeight()/2+4	
	
End Function








Function MouseLook(cam)
	dx#=(xGraphicsWidth()/2-xMouseX())*0.01
	dy#=(xGraphicsHeight()/2-xMouseY())*0.01
	xTurnEntity cam,-dy,dx,0
	 If xKeyDown(17) xMoveEntity cam,0,0,.01 
	 If xKeyDown(31) xMoveEntity cam,0,0,-.01
	 If xKeyDown(32) xMoveEntity cam,0.1,0,0 
	 If xKeyDown(30) xMoveEntity cam,-0.1,0,0 
End Function

Function Musor()
	For i=1 To 50
		cub=xCreateCube()
		xEntityColor cub,Rand(128,255),Rand(128,255),Rand(128,255)
		xPositionEntity cub,Rnd(-10,10),Rnd(-10,10),Rnd(-10,10)
		xEntityAlpha cub,0.3
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function