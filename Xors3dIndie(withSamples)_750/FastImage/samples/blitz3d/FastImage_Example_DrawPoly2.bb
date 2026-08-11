; DrawPoly example 2 -  FastImage (version 1.7x)
; (c) 2010 created by MixailV aka Monster^Sage [monster-sage@mail.ru]

Include "include\Xors3D.bb"
Include "include\FastImageXors.bb"



xGraphics3D 800, 600, 32, 0, 1
; initiate library after xGraphics3D using xInitDraw
xInitDraw



cam=xCreateCamera(): xCameraClsColor cam,40,40,40 : xCreateLight() : Musor() : xSetFont xLoadFont("Arial Cyr",11)



; loading images
imgFast1 = xLoadImageEx ("..\media\devil.png",1+2)
imgFast2 = xLoadAnimImageEx ("..\media\wateranim.jpg", 1+8, 124, 124, 0, 23)




pWidth# = 256
pHeight# = 256
nCols = 16
nRows = 16
dCols# = Float(pWidth) / Float(nCols)
dRows# = Float(pHeight) / Float(nRows)

; creating a primitive
MyPoly = CreateFace ( pWidth, pHeight, nCols, nRows )




xMoveMouse xGraphicsWidth()/2-20, xGraphicsHeight()/2
t#=0 : frame = 0 : rotation# = 0
While Not xKeyHit (1)
	MouseLook cam   :   xRenderWorld


	; start drawing with FastImage
	xStartDraw
		xSetBlend FI_ALPHABLEND : xSetHandle 128,128


		; start drawing with FastImage
		xDrawPoly 200, 200, MyPoly, imgFast1
		


		; setting alpha and color for all vertices of the triangle
		xSetAlpha 0.5 : xSetColor 0,255,0	
		
		; drawing the primitive
		xDrawPoly xMouseX(), xMouseY(), MyPoly, imgFast1, 0, FI_COLOROVERLAY		; replace color and alphaи (overlay mode)

		
		
		; setting alpha and color for all vertices of the triangle
		xSetAlpha 0.5 : xSetColor 0,255,255
		
		; drawing custom primitive with animated 'imgFast2' image
		xDrawPoly 600, 400, MyPoly, imgFast2, (frame Mod 23), FI_COLOROVERLAY



		If xKeyHit(57)
			Trans = 1-Trans
			Mode=Mode+1
			If Mode=3 Then Mode=0
		EndIf
		

		; в зависимости от режима трансформации будем пересчитывать X и Y всех вершин сетки
		; depending on the transformation mode recalculating X and Y for all vertices of the mesh
		Select Mode
			Case 0
				offset = 20
				For i=0 To nRows
					For j=0 To nCols
						PokeFloat	MyPoly,offset, dCols*Float(j) + dCols*Cos( t*4+Float( (i+j)*10 ) )			;setting new X
						PokeFloat	MyPoly,offset+4, dRows*Float(i) + dRows*Sin( t*4+Float( (i+j)*10 ) )		;setting new Y
						offset = offset + 20
					Next
				Next
					
			Case 1
				offset = 20
				For i=0 To nRows
					For j=0 To nCols
						ddx# = Float(j-nCols/2) : ddy# = Float(i-nRows/2)
						r# = Sqr(ddx*ddx+ddy*ddy) : a#=r*Cos(t)*24.0
						dx#=Sin(a)*(Float(i)*dRows-pHeight/2)+Cos(a)*( Float(j)*dCols-pWidth/2);
						dy#=Cos(a)*(Float(i)*dRows-pHeight/2)-Sin(a)*( Float(j)*dCols-pWidth/2);
					
						PokeFloat	MyPoly,offset, dCols*Float(j) +dx*0.25			;setting new X
						PokeFloat	MyPoly,offset+4, dRows*Float(i) + dy*0.25		;setting new Y
						offset = offset + 20
					Next
				Next

			
			Case 2
				offset = 20
				For i=0 To nRows
					For j=0 To nCols
						dx# = Cos(t*4+j*20)*18
						col = Int((Cos(t*4+(i+j)*20)+1)*100+80)
						If col>255 Then col=255
												
						PokeFloat	MyPoly,offset, dCols*Float(j) + dx				;setting new X
						PokeFloat	MyPoly,offset+4, dRows*Float(i) +dx*0.5			;setting new Y
						PokeInt MyPoly,offset+8, $FF000000 Or (col Shl 16) Or (col Shl 8) Or col		;setting new color of the vertex
						
						offset = offset + 20
					Next
				Next
		
		End Select


		

		;end drawing	
		t=t+1	
	xEndDraw



	xText 10,10,"Press <Space> to change transformation mode"
	frame=frame+1 : rotation=rotation+0.5 : xFlip
Wend
End





; this is an example how to use banks for creating primitive and drawing it with DrawPoly
; this function prepares a 'mesh' with FI_TRIANGLELIST mode (list of vertices + list of indecies)
Function CreateFace (width%, height%, cols%=16, rows%=16, col%=$FFFFFFFF)
	CountVertexs = (rows+1)*(cols+1)
	bank = CreateBank( 20 +  CountVertexs  * 20 )		; creating a bank for header of primitive and all its vertices
	
	CountTriangles = rows*cols*2
	bankIndexes = CreateBank ( CountTriangles*6 )		; creating a bank for all indecies of triangles

	; заголовок (всегда 20 байт)
	PokeInt		bank,0,CountTriangles				; amount of vertices
	PokeInt		bank,4,FI_NOWRAP				; texture rendering mode (combine flags: FI_WRAPU, FI_MIRRORU, FI_WRAPV, FI_MIRRORV or use: FI_NOWRAP, FI_WRAPUV, FI_MIRRORUV)
	PokeInt		bank,8,FI_TRIANGLELIST			; drawing mode
	PokeInt		bank,12,bankIndexes				; bank which contains the list of indecies of vertices for all triangles (3 vertices per triangle)
	PokeInt		bank,16,CountTriangles*3			; amount of indecies (should be a multiple of three)
	offset = 20

	dx# = Float(width) / Float(cols)
	dy# = Float(height) / Float(rows)
	dtx# = 1.0 / Float(cols)
	dty# = 1.0 / Float(rows)

	; filling the bank with vertices (each vertex consists of 20 bytes)
	For y=0 To rows
		For x=0 To cols
			PokeFloat	bank,offset, dx*Float(x)			; X - coord
			PokeFloat	bank,offset+4, dy*Float(y)			; X - coord
			PokeInt	bank,offset+8, col				; ÷вет вершины в формате $AARRGGBB (учите 16-ричную систему чисел :) )
			PokeFloat	bank,offset+12, dtx*Float(x)		; U - coord
			PokeFloat	bank,offset+16, dty*Float(y)		; V - coord
			offset = offset + 20
		Next
	Next			

	; filling the bank of indecies
	; it looks like creating triangles in surface in Blitz3d
	; 2 bytes per index, so 6 bytes per triangle
	offset = 0
	For y=0 To rows-1
		For x=0 To cols-1
			; the 1-st triangle
			PokeShort bankIndexes,offset, y*(cols+1) + x		; index of the 1-st vertex
			PokeShort bankIndexes,offset+2, y*(cols+1) + x +1	; index of the 2-nd vertex
			PokeShort bankIndexes,offset+4, (y+1)*(cols+1) + x	; index of the 3-rd vertex
			
			; the 2-nd triangle
			PokeShort bankIndexes,offset+6, y*(cols+1) + x +1		; index of the 1-st vertex
			PokeShort bankIndexes,offset+8, (y+1)*(cols+1) + x +1		; index of the 2-nd vertex
			PokeShort bankIndexes,offset+10, (y+1)*(cols+1) + x		; index of the 3-rd vertex
			
			offset=offset+12
		Next
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
		xScaleEntity cub,Rnd(0.3,0.5),Rnd(0.3,0.5),Rnd(0.3,0.5)
		xTurnEntity cub,Rnd(0,90),Rnd(0,90),Rnd(0,90)
	Next
End Function
