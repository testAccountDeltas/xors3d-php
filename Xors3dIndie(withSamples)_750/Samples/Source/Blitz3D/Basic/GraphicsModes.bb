Include "..\xors3d.bb"
xCreateLog()
Global g_appRuns = True

Type tGfxMode
	Field item%
	Field width%, height%, depth%
	Field gfxMode$
	Field desktop%
End Type : Global gfx.tGfxMode

xGraphics3d(800, 600, 0, False, True)
xSetFont(xLoadFont("Tahoma", 10))
GetAllModes()

time = MilliSecs()
yy = 1
While AppRunning()
	If (MilliSecs() - time) > 500
		yy = yy + 1
		If yy > 50
			yy = 1
		EndIf
		time = MilliSecs()
	EndIf
	xCls()
	UpdateApp()
	ListAllModes()
	xFlip()
Wend
End

Function AppRunning()
	Return g_appRuns
End Function

Function UpdateApp()
	If xKeyHit(KEY_ESCAPE) Or xWinMessage("WM_CLOSE")
		g_appRuns = False
	EndIf
End Function

Function GetAllModes()
	For i = 0 To xCountGfxModes()-1
		gfx.tGfxMode = New tGfxMode
		gfx\width = xGfxModeWidth(i)
		gfx\height= xGfxModeHeight(i)
		gfx\depth = xGfxModeDepth(i)
		If (gfx\width = xGfxModeWidth(-1)) And (gfx\height = xGfxModeHeight(-1)) And (gfx\depth = xGfxModeDepth(-1))
			gfx\desktop = 1
		Else
			gfx\desktop = 0
		EndIf
		gfx\gfxMode = gfx\width + " x " + gfx\height + " x " + gfx\depth + "bpp"
	Next
End Function

Function ListAllModes()
	Local i = 0	
	Local x, xS = 10
	Local y, yS = 50
	Local xStep = 200
	Local yStep = 20
	Local heightCap = Floor((xGraphicsHeight() - yS) / yStep)
	For gfx.tGfxMode = Each tGfxMode
		x = xS + Floor(i / heightCap) * xStep
		y = yS + i Mod heightCap * yStep
		xColor(24, 26, 28)
		xRect(x, y + 1, xStep * 0.9, yStep - 1, True)
		If (gfx\desktop = 1)
			xColor(255, 128, 32)
			xText(x + 2, y + 2, ">")
		EndIf
		xColor(196, 196, 196)
		xText(x + 15, y + 2, (i+1) + ". ")
		xText(x + 45, y + 2, gfx\gfxMode)
		i = i + 1
	Next 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D