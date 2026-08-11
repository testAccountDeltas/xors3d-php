Include "..\xors3d.bb"

Const blocksVert% = 10
Const blocksHor% = blocksVert * 2
Const blockScale# = 1.0

Global blockZPos# = blocksHor * 2.5
Global g_state%  = 1
Global g_mode%   = 0
Global g_dirMov% = 1
Global g_dirRot% = 1
Global g_subScale# = 0.0
Global g_texNum% = 0
Global g_uvShift0% = 0
Global g_uvShift1% = 0
Global g_activeSide% = 0
Global g_activeTex%  = 0

Type TBlock
	Field entity%
	Field state%
	Field angle#
End Type

Type TTexture
	Field tex%
End Type

Dim blocks.TBlock(blocksHor, blocksVert)

xCreateLog(LOG_HTML, LOG_INFO, "Blocks.html")

xAppTitle("Blocks")
xGraphics3d(1280, 720, 32, 0, 1)

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)

Global light = xCreateLight()
xTurnEntity(light, 60, 0, 0)

LoadTextures("..\..\Media\Textures\abstract\a")

Global blockPiv = xCreatePivot()
Global initBlock = CreateInitialBlock()
CreateBlocks()
xPositionEntity(blockPiv, 0.0, 0.0, blockZPos)

While Not (xKeyHit(KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
	UpdateFrame()
	
	xRenderWorld()
	PrintInfo()
	DrawTexButtons()
	xFlip()
Wend

End

Function LoadOneTexture(path$)
	Local tex% = xLoadTexture(path)
	If (tex <> 0)
		Local t.TTexture = New TTexture
		t\tex = tex
		g_texNum = g_texNum + 1
	EndIf
	Return tex
End Function

Function LoadTextures(path$, ext$ = "jpg")
	Local result% = 0
	Local formedPath$ = ""
	Local index% = 0
	xSetLogLevel(LOG_NO)
	Repeat
		formedPath = path
		If (index < 10)
			formedPath = formedPath + "0"
		EndIf
		formedPath = formedPath + Str(index) + "." + ext
		result = LoadOneTexture(formedPath)
		index = index + 1
	Until result = 0
	xSetLogLevel(LOG_INFO)
End Function

Function CreateInitialBlock()
	Local t0.TTexture, t1.TTexture
	Local shader = xLoadFXFile("..\..\Media\Shaders\blocks_hw_instancing.fx")
	Local block = xCreateCube()
	t0.TTexture = First TTexture
	t1.TTexture = After t0
	xScaleMesh(block, 1.0, 1.0, 0.1)
	xEntityTexture(block, t0\tex, 0, 0)
	xEntityTexture(block, t1\tex, 0, 1)
	xSetEntityEffect(block, shader)
	xSetEffectTechnique(block, "Instancing")
	xHideEntity(block)
	Return block
End Function

Function CreateBlocks()
	Local i%, j%
	
	For i = 0 To blocksHor - 1
		For j = 0 To blocksVert - 1
			blocks(i, j) = New TBlock
			blocks(i, j)\state = 0
			blocks(i, j)\angle = 0.0
			blocks(i, j)\entity = xCreateInstance(initBlock, blockPiv)
			xScaleEntity(blocks(i, j)\entity, blockScale, blockScale, blockScale)
			xPositionEntity(blocks(i, j)\entity, i * 2.0 - blocksHor + 1.0, j * 2.0 - blocksVert + 1.0, 0.0)
			; packing the block id and the number of blocks in the column to the diffuse color of the entity
			xEntityColor(blocks(i, j)\entity, i, j, blocksVert)
		Next
	Next
End Function

Function UpdateBlocks()
	If (g_state = 1)
		Local i%
		Local rndTex%
		Local t.TTexture = First TTexture
		g_mode    = Rand(0, 3)
		If (g_mode > 1)
			g_mode = g_mode Mod 2
			g_subScale = 0.5
		Else
			g_subScale = 0.0
		EndIf
		g_dirMov  = Rand(0, 1)
		g_dirRot  = Rand(0, 1)
		g_activeSide = 1 - g_activeSide
		Repeat
			rndTex = Rand(0, g_texNum - 1)
		Until rndTex <> g_activeTex
		g_activeTex = rndTex
		For i = 0 To g_activeTex - 1
			t = After t
		Next
		xEntityTexture(initBlock, t\tex, 0, g_activeSide)
		If (g_activeSide = 0)
			g_uvShift0 = g_uvShift1
			If (g_dirRot = 0)
			Else
				g_uvShift0 = 1 - g_uvShift0
			EndIf
		Else
			g_uvShift1 = g_uvShift0
			If (g_dirRot = 0)
			Else
				g_uvShift1 = 1 - g_uvShift1
			EndIf
		EndIf
		xSetEffectVector(initBlock, "uvShift", g_uvShift0, g_uvShift1, 0.0, 0.0)
	EndIf
	Select g_mode
		Case 0
			g_state = UpdateBlocksByColumn(g_state, 25.0, 2.0, g_subScale, g_dirMov, g_dirRot)
		Case 1
			g_state = UpdateBlocksByRow(g_state, 25.0, 2.0, g_subScale, g_dirMov, g_dirRot)
	End Select
End Function

Function UpdateBlocksByRow%(firstIteration% = 0, triggerYaw# = 90.0, speed# = 1.0, subScale# = 0.5, dirMov% = 1, dirRot% = 1)
	Local i%, j%, jj%
	Local minJ%, maxJ%, deltaJ%
	Local isFinished% = 1
	If (dirMov = 1)
		minJ = 0
		maxJ = blocksVert - 1
		deltaJ = 1
	Else
		dirMov = -1
		minJ = blocksVert - 1
		maxJ = 0
		deltaJ = -1
	EndIf
	If (dirRot <> 1)
		dirRot = 0
	EndIf
	For jj = 0 To blocksVert - 1
		If (dirMov = 1)
			j = jj
		Else
			j = blocksVert - 1 - jj
		EndIf
		If (j = minJ)
			If (firstIteration = 1)
				isFinished = 0
				For i = 0 To blocksHor - 1
					blocks(i, j)\state = 1
				Next
			EndIf
		EndIf
		For i = 0 To blocksHor - 1
			If (blocks(i, j)\state = 1)
				isFinished = 0
				If (blocks(i, j)\angle >= 180.0)
;					Local roll# = xEntityRoll(blocks(i, j)\entity)
;					Local pitch# = Ceil(FixPitch(xEntityPitch(blocks(i, j)\entity), roll) / 180.0) * 180.0
;					Local yaw# = Ceil(FixYaw(xEntityYaw(blocks(i, j)\entity)) / 180.0) * 180.0
;					xRotateEntity(blocks(i, j)\entity, pitch, yaw, roll)
					blocks(i, j)\angle = 0.0
					blocks(i, j)\state = 0
				Else
					xTurnEntity(blocks(i, j)\entity, speed * dirRot, speed * (1 - dirRot), 0.0)
					Local shift# = Sin(xEntityYaw(blocks(i, j)\entity)) * (1 - dirRot)
					shift = shift + Sin(xEntityPitch(blocks(i, j)\entity)) * dirRot
					shift = shift * 2.5
					xPositionEntity(blocks(i, j)\entity, xEntityX(blocks(i, j)\entity), xEntityY(blocks(i, j)\entity), shift)
					Local scale# = blockScale / (Abs(shift) * subScale + 1.0)
					xScaleEntity(blocks(i, j)\entity, scale, scale, scale)
					blocks(i, j)\angle = blocks(i, j)\angle + Abs(speed)
				EndIf
				If (blocks(i, j)\angle >= triggerYaw)
					If (j * dirMov < maxJ * dirMov)
						blocks(i, j + deltaJ)\state = 1
					EndIf
				EndIf
			EndIf
		Next
	Next
	Return isFinished
End Function

Function UpdateBlocksByColumn%(firstIteration% = 0, triggerYaw# = 90.0, speed# = 1.0, subScale# = 0.5, dirMov% = 1, dirRot% = 1)
	Local i%, j%, jj%
	Local minJ%, maxJ%, deltaJ%
	Local isFinished% = 1
	If (dirMov = 1)
		minJ = 0
		maxJ = blocksHor - 1
		deltaJ = 1
	Else
		dirMov = -1
		minJ = blocksHor - 1
		maxJ = 0
		deltaJ = -1
	EndIf
	If (dirRot <> 1)
		dirRot = 0
	EndIf
	For jj = 0 To blocksHor - 1
		If (dirMov = 1)
			j = jj
		Else
			j = blocksHor - 1 - jj
		EndIf
		If (j = minJ)
			If (firstIteration = 1)
				isFinished = 0
				For i = 0 To blocksVert - 1
					blocks(j, i)\state = 1
				Next
			EndIf
		EndIf
		For i = 0 To blocksVert - 1
			If (blocks(j, i)\state = 1)
				isFinished = 0
				If (blocks(j, i)\angle >= 180.0)
;					Local roll# = xEntityRoll(blocks(j, i)\entity)
;					Local pitch# = Ceil(FixPitch(xEntityPitch(blocks(j, i)\entity), roll) / 180.0) * 180.0
;					Local yaw# = Ceil(FixYaw(xEntityYaw(blocks(j, i)\entity)) / 180.0) * 180.0
;					xRotateEntity(blocks(j, i)\entity, pitch, yaw, roll)
					blocks(j, i)\angle = 0.0
					blocks(j, i)\state = 0
				Else
					xTurnEntity(blocks(j, i)\entity, speed * dirRot, speed * (1 - dirRot), 0.0)
					Local shift# = Sin(xEntityYaw(blocks(j, i)\entity)) * (1 - dirRot)
					shift = shift + Sin(xEntityPitch(blocks(j, i)\entity)) * dirRot
					shift = shift * 2.5
					xPositionEntity(blocks(j, i)\entity, xEntityX(blocks(j, i)\entity), xEntityY(blocks(j, i)\entity), shift)
					Local scale# = blockScale / (Abs(shift) * subScale + 1.0)
					xScaleEntity(blocks(j, i)\entity, scale, scale, scale)
					blocks(j, i)\angle = blocks(j, i)\angle + Abs(speed)
				EndIf
				If (blocks(j, i)\angle >= triggerYaw)
					If (j * dirMov < maxJ * dirMov)
						blocks(j + deltaJ, i)\state = 1
					EndIf
				EndIf
			EndIf
		Next
	Next
	Return isFinished
End Function

Function UpdateBlockBoard()
	Local mX# = (xMouseX() - Float(xGraphicsWidth()) * 0.5) * 0.02
	Local mY# = -(xMouseY() - Float(xGraphicsHeight()) * 0.5) * 0.02
	xRotateEntity(blockPiv, mY, mX, 0)
End Function

Function FixPitch#(pitch#, roll#)
	If (roll >= 180)
		pitch = 180 - pitch
	EndIf
	If (pitch < 0)
		pitch = pitch + 360
	EndIf
	Return pitch
End Function

Function FixYaw#(yaw#)
	If (yaw < 0)
		yaw = 360 + yaw
	EndIf
	Return yaw
End Function

Function Clamp(value#)
	If value > 1.0 Then value = 1.0
	If value < -1.0 Then value = -1.0
	Return value
End Function

Function Saturate(value#)
	If value > 1.0 Then value = 1.0
	If value < 0.0 Then value = 0.0
	Return value
End Function

Function UpdateControl()
	UpdateCamera(camera)
End Function

Function UpdateFrame()
	UpdateBlocks()
	UpdateBlockBoard()
End Function

Function UpdateCamera(cam%)
End Function
Function DrawTexButtons()
	Local xOffset# = Float(xGraphicsWidth()) * 0.5
	Local yOffset# = Float(xGraphicsHeight()) * 0.95
	Local rad# = 20.0
	Local i%
	
	For i = 0 To g_texNum - 1
		Local x# = (i * 2.0 - g_texNum + 1.5) * rad + xOffset
		If (i = g_activeTex)
			xColor(200, 50, 25, 200)
			xRect(x - rad - 2, yOffset - rad - 2, rad + 4, rad + 4, 1)
		EndIf
		xColor(50, 100, 200, 200)
		xRect(x - rad, yOffset - rad, rad, rad, 1)
	Next
End Function

Function PrintInfo(x% = 10, y% = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 245 + x, 95 + y, True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 245 + x, 95 + y, False)
	xColor(96, 152, 255, 255)
	xText(10 + x + 120, 10 + y, "Blocks", 1)
	xText(10 + x, 25 + y, "Triangles: " + xTrisRendered())
	xText(10 + x, 40 + y, "DIP calls: " + xDIPCounter())
	xText(10 + x, 55 + y, "FPS: " + xGetFPS())
	xText(10 + x, 70 + y, "Blocks: " + (blocksHor * blocksVert))
	xText(10 + x, 85 + y, "Use <MOUSE> to rotate the board")
End Function

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D