; DrawPoly example -  FastImage (версия 1.7x)
; (c) 2010 Created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initialize FastImage library after Graphics3D with command xInitDraw
xInitDraw



cam=xCreateCamera(): xCameraClsColor cam,40,40,40 : xCreateLight() : Musor()



; load textures
tex1=xLoadTexture ("..\media\devil.png",1+2)
tex2=xLoadAnimTexture("..\media\wateranim.jpg", 1+8+256, 124, 124, 0, 23)	



; create images (fast-images) from textures
imgFast1=xCreateImageEx(tex1, 256, 256)
imgFast2=xCreateImageEx(tex2, 124, 124)



; create polies
MyPoly1 = CreateStar($FFFFFFFF, 150, 58, 8)
MyPoly2 = CreateSpiral($FFFFFFFF, 120, 20)
MyPoly3 = CreateLineStar ($FFFFFFFF, 150, 58, 8)



frame = 0 : rotation# = 0
While Not xKeyHit (1)
	MouseLook cam   :   xRenderWorld


	; start drawing with FastImage
	xStartDraw
		xSetBlend FI_ALPHABLEND
		xSetRotation rotation

		; this used for overlay-color
		xSetAlpha 0.5
		xSetColor 255,255,0

		; draw MyPoly1 (Star)
		xDrawPoly 160, 400, MyPoly1
		xDrawPoly 400, 400, MyPoly1, 0, 0, FI_COLOROVERLAY							;draw with overlay color
		xDrawPoly 600, 400, MyPoly1, imgFast2, (frame Mod 23), FI_COLOROVERLAY		;draw with overlay color

		; draw MyPoly3 (LineStar)
		xDrawPoly 160, 260, MyPoly3
		xDrawPoly 400, 260, MyPoly3, 0, 0, FI_COLOROVERLAY							;draw with overlay color 
		xDrawPoly 600, 260, MyPoly3, imgFast2, (frame Mod 23)						;draw Line-primitive with image (texture)

		; draw MyPoly2 (Spiral)
		xDrawPoly 120, 120, MyPoly2, imgFast2, (frame Mod 23)
		xDrawPoly 320, 120, MyPoly2, 0, 0, FI_COLOROVERLAY							;draw with overlay color
		xDrawPoly 520, 120, MyPoly2

		; draw MyPoly1 at cursor position
		xSetRotation 0
		xDrawPoly xMouseX(), xMouseY(), MyPoly1, imgFast1
		
		;end drawing
	xEndDraw 


	frame=frame+1 : rotation=rotation+0.5 : xFlip
Wend

FreeBank MyPoly1		; free banks with Polies
FreeBank MyPoly2		; ...
FreeBank MyPoly3		; ...

End






; ! Example functions - how to use Bank for create primitives "Poly" !
Function CreateStar (col%=$FFFFFFFF, radiusMax#=100, radiusMin#=50, count%=5)
	bank = CreateBank( 20+(count*2+2)*20 )

	; header info (20 bytes (2 integer value reserved))
	PokeInt		bank,0,count*2+2				;count vertices
	PokeInt		bank,4,FI_NOWRAP				;wrap mode (combine flags: FI_WRAPU, FI_MIRRORU, FI_WRAPV, FI_MIRRORV or use: FI_NOWRAP, FI_WRAPUV, FI_MIRRORUV)
	PokeInt		bank,8,FI_TRIANGLEFAN			;drawing mode (possible values: FI_TRIANGLEFAN, FI_TRIANGLESTRIP, FI_LINESTRIP )
	offset = 20

	; star center vertex (20 bytes per vertex)
	PokeFloat	bank,offset,0					;vertex X
	PokeFloat	bank,offset+4,0					;vertex Y
	PokeInt		bank,offset+8,col-$88000000		;vertex Color $AARRGGBB
	PokeFloat	bank,offset+12,0.5				;vetrex U
	PokeFloat	bank,offset+16,0.5				;vertex V
	offset = offset + 20
	
	; all other vertices (20 bytes per vertex)
	mode=0
	For i=0 To (count*2)
		a#=i*360.0/Float(count*2)-90

		If mode=0
			rad#=radiusMax
		Else
			rad#=radiusMin
		EndIf
		mode=1-mode

		x#=rad*Cos(a)
		y#=rad*Sin(a)

		PokeFloat	bank,offset,x							;vertex X
		PokeFloat	bank,offset+4,y							;vertex Y
		PokeInt		bank,offset+8,col						;vertex Color $AARRGGBB
		PokeFloat	bank,offset+12,0.5+0.5*(x/radiusMax)	;vetrex U
		PokeFloat	bank,offset+16,0.5+0.5*(y/radiusMax)	;vertex V

		offset = offset + 20
	Next

	Return bank
End Function

Function CreateSpiral (col%=$FFFFFFFF, radiusMax#=120, radiusMin#=20)
	count=60
	bank = CreateBank( 20+(count*2)*20 )

	; header info (20 bytes (2 integer value reserved))
	PokeInt		bank,0,count*2					;count vertices
	PokeInt		bank,4,FI_NOWRAP				;wrap mode (combine flags: FI_WRAPU, FI_MIRRORU, FI_WRAPV, FI_MIRRORV or use: FI_NOWRAP, FI_WRAPUV, FI_MIRRORUV)
	PokeInt		bank,8,FI_TRIANGLESTRIP			;drawing mode (possible values: FI_TRIANGLEFAN, FI_TRIANGLESTRIP, FI_LINESTRIP )
	offset = 20

	; all vertices  (20 bytes per vertex)
	For i=0 To count-1
		k#=Float(i/Float(count-1))

		a#=720.0*k-90
		rad#=radiusMin+(radiusMax-radiusMin)*k

		x#=(rad-30*k)*Cos(a)
		y#=(rad-30*k)*Sin(a)
		PokeFloat	bank,offset,x							;vertex X
		PokeFloat	bank,offset+4,y							;vertex Y
		PokeInt		bank,offset+8,col						;vertex Color $AARRGGBB
		PokeFloat	bank,offset+12,0.5+0.5*(x/radiusMax)	;vetrex U
		PokeFloat	bank,offset+16,0.5+0.5*(y/radiusMax)	;vertex V
		offset = offset + 20

		x#=rad*Cos(a)
		y#=rad*Sin(a)
		PokeFloat	bank,offset,x							;vertex X
		PokeFloat	bank,offset+4,y							;vertex Y
		PokeInt		bank,offset+8,col						;vertex Color $AARRGGBB
		PokeFloat	bank,offset+12,0.5+0.5*(x/radiusMax)	;vetrex U
		PokeFloat	bank,offset+16,0.5+0.5*(y/radiusMax)	;vertex V
		offset = offset + 20

		; decrease alpha
		col=col-$04000000
	Next

	Return bank
End Function

Function CreateLineStar (col%=$FFFFFFFF, radiusMax#=100, radiusMin#=50, count%=5)
	bank = CreateBank( 20+(count*2+1)*20 )

	; header info (20 bytes (2 integer value reserved))
	PokeInt		bank,0,count*2+1				;count vertices
	PokeInt		bank,4,FI_NOWRAP				;wrap mode (combine flags: FI_WRAPU, FI_MIRRORU, FI_WRAPV, FI_MIRRORV or use: FI_NOWRAP, FI_WRAPUV, FI_MIRRORUV)
	PokeInt		bank,8,FI_LINESTRIP				;drawing mode (possible values: FI_TRIANGLEFAN, FI_TRIANGLESTRIP, FI_LINESTRIP )
	offset = 20

	; all vertices (20 bytes per vertex)
	mode=0
	For i=0 To (count*2)
		a#=i*360.0/Float(count*2)-90

		If mode=0
			rad#=radiusMax
		Else
			rad#=radiusMin
		EndIf
		mode=1-mode

		x#=rad*Cos(a)
		y#=rad*Sin(a)

		PokeFloat	bank,offset,x							;vertex X
		PokeFloat	bank,offset+4,y							;vertex Y
		PokeInt		bank,offset+8,col						;vertex Color $AARRGGBB
		PokeFloat	bank,offset+12,0.5+0.5*(x/radiusMax)	;vetrex U
		PokeFloat	bank,offset+16,0.5+0.5*(y/radiusMax)	;vertex V
		offset = offset + 20
	Next

	Return bank
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