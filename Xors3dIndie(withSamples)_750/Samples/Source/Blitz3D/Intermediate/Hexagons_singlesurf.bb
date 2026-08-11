Include "..\xors3d.bb"

Const camZoom# = 1.0
Const zPlane# = 1.0
Const mouseRadius# = 160.0

Global mode% = 0
Global distort% = 1
Global FOV# = ATan(1.0 / camZoom) / 2.0
Global mainCell% = 0
Global lastFrame% = xMillisecs()
Global screenRadius# = 160.0
Global deltaRad# = 180.0
Global vertCount% = 20
Global cellCount% = 0

xCreateLog(LOG_HTML, LOG_INFO, "Hexagons_singlesurf.html")

xAppTitle("Hexagons (Single Surface)")
xGraphics3d(1024, 768, 32, 0, 0)

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
xCameraZoom(camera, camZoom)

;Global backTexture = xLoadTexture("..\..\Media\textures\merkava.jpg")
Global backTexture = xLoadTexture("..\..\Media\textures\copperhead.jpg")
xSetTextureFilter(backTexture, TF_NONE)
Global poly = xCreatePoly(False)
xEntityTexture(poly, backTexture)
xScaleEntity(poly, 1.33333, 1.0, 1.0)
xPositionEntity(poly, 0.0, 0.0, 1.0 / Tan(FOV))
xEntityOrder(poly, 1)
xEntityFX(poly, FX_FULLBRIGHT)

Global shader = xLoadFXFile("..\..\Media\Shaders\hexagons_singlesurf.fx")
Global normalTexture = xCreateTexture(xGraphicsWidth(), xGraphicsHeight(), FLAGS_COLOR + FLAGS_ALPHA )
Global PostEffect_Offset = xLoadPostEffect("..\..\Media\shaders\hexagons_posteffect_offset.fx")
xSetPostEffect( 0, PostEffect_Offset )
xSetPostEffectTexture (PostEffect_Offset, "offsetTexture", normalTexture)

Global cellPiv = xCreatePivot()
mainCell = GenerateCells()

While Not (xKeyHit(KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
	UpdateFrame()
	If (distort = 1)
		xSetBuffer(xTextureBuffer(normalTexture))
		xCameraClsColor(camera, 0, 0, 0)
		xShowEntity(cellPiv)
		xRenderEntity(camera, mainCell)
	Else
		xRenderWorld()
	EndIf
	
	If (distort = 1)
		xSetBuffer(xBackBuffer())
		xCameraClsColor(camera, 32, 64, 128)
		xHideEntity(cellPiv)
		xRenderWorld()
		xRenderPostEffects()
	EndIf
	PrintInfo()
	xFlip()
Wend

End

Function CreateHexagon(surf%, startIndex%, radius#, cx#, cy#, cz#)
	Local i%
	xAddVertex(surf, 0.0 + cx, 0.0 + cy, 0.0 + cz, 0.0, 0.0)
	For i = 0 To 5
		Local angle# = i * 60.0
		Local x# = radius * Cos(angle)
		Local y# = radius * Sin(angle)
		xAddVertex(surf, x + cx, y + cy, cz, x, y)
	Next
	For i = 1 To 5
		xAddTriangle(surf, startIndex + 0, startIndex + i+1, startIndex + i)
	Next
	xAddTriangle(surf, startIndex + 0, startIndex + 1, startIndex + 6)
End Function

Function GenerateCells(aspectRatio# = 1.33333)
	Local cellRadius# = zPlane * Tan(FOV) / Sin(60.0) / Float(vertCount)
	Local horCount% = Ceil(Float(vertCount) * aspectRatio / Sin(60))
	Local offsetX# = cellRadius * (1.0 + Cos(60.0)); + 0.25
	Local offsetY# = cellRadius * Sin(60.0) * 2.0; + 0.25
	
	Local cell% = xCreateMesh(cellPiv)
	Local surf% = xCreateSurface(cell)
	Local x#, y#
	Local index% = 0
	cellCount = 0
	For x = -Ceil(Float(horCount) / 2) To Floor(Float(horCount) / 2)
		For y = -Ceil(Float(vertCount) / 2) To Floor(Float(vertCount) / 2)
			Local localOffset# = 0.0
			If (Abs(x Mod 2) = 1)
				localOffset = offsetY * 0.5
			EndIf
			CreateHexagon(surf, index, cellRadius, x * offsetX, y * offsetY + localOffset, zPlane)
			index = index + 7
			cellCount = cellCount + 1
		Next
	Next
	
	xSetEntityEffect(cell, shader)
	xSetEffectTechnique(cell, "Main")
	
	Return cell
End Function

Function UpdateControl()
	Local newVertCount%
	If xKeyHit(KEY_SPACE)
		mode = 1 - mode
	EndIf
	If xKeyHit(KEY_ENTER)
		distort = 1 - distort
		If distort = 0
			xShowEntity(cellPiv)
		EndIf
	EndIf
	newVertCount = vertCount + xMouseZSpeed()
	If newVertCount > 76
		newVertCount = 76
	EndIf
	If newVertCount < 2
		newVertCount = 2
	EndIf
	If (newVertCount <> vertCount)
		xFreeEntity(mainCell)
		mainCell = GenerateCells()
	EndIf
	vertCount = newVertCount
End Function

Function UpdateFrame()
	Local x#, y#, z#, radius#
	Local screenX#
	Local screenY#
	If mode = 0
		screenX = xGraphicsWidth()* 0.5
		screenY = xGraphicsHeight()* 0.5
		If (screenRadius <= -2.0 * xGraphicsHeight() / vertCount) ; to show the central cell
			screenRadius = -2.0 * xGraphicsHeight() / vertCount
			deltaRad = -deltaRad
		EndIf
		If (screenRadius >= xGraphicsWidth())
			screenRadius = xGraphicsWidth()
			deltaRad = -deltaRad
		EndIf
	Else
		screenX = xMouseX()
		screenY = xMouseY()
		screenRadius = mouseRadius
	EndIf
	
	x = (screenX * 2.0 / xGraphicsWidth() - 1.0) * Tan(FOV) * zPlane * xGraphicsWidth() / xGraphicsHeight()
	y = (-screenY * 2.0 / xGraphicsHeight() + 1.0)  * Tan(FOV) * zPlane
	radius# = screenRadius * Tan(FOV) * zPlane / xGraphicsHeight()
	
	xSetEffectVector(mainCell, "clipPoint", x, y, zPlane, radius)
	If mode = 0
		screenRadius = screenRadius + xDeltaValue(deltaRad, lastFrame)
	EndIf
	lastFrame = xMillisecs()
End Function

Function PrintInfo(x% = 10, y% = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 240 + x, 110 + y, True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 240 + x, 110 + y, False)
	xColor(255, 144, 32, 255)
	xText(10 + x + 120, 10 + y, "Hexagons (Single Surface)", 1)
	xText(10 + x, 25 + y, "Triangles: " + xTrisRendered())
	xText(10 + x, 40 + y, "DIP calls: " + xDIPCounter())
	xText(10 + x, 55 + y, "FPS: " + xGetFPS())
	If mode = 0
		xText(10 + x, 70 + y, "Press <SPACE> to switch to MOUSE mode")
	Else
		xText(10 + x, 70 + y, "Press <SPACE> to switch to AUTO mode")
	EndIf
	If distort = 0
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion ON")
	Else
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion OFF")
	EndIf
	xText(10 + x, 100 + y, "Cells: " + cellCount + " (use <MOUSE SCROLL> to change)")
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D