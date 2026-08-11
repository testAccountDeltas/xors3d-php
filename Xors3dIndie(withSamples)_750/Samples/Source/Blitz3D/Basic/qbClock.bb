Include "..\xors3d.bb"

Global gSpeed# = 8.0
Dim digitMasks$(16)
digitMasks$(0) = "111101101101111"
digitMasks$(1) = "110010010010111"
digitMasks$(2) = "111001111100111"
digitMasks$(3) = "111001111001111"
digitMasks$(4) = "101101111001001"
digitMasks$(5) = "111100111001111"
digitMasks$(6) = "111100111101111"
digitMasks$(7) = "111001010010010"
digitMasks$(8) = "111101111101111"
digitMasks$(9) = "111101111001001"
digitMasks$(10) = "000010000010000"
digitMasks$(11) = "111111111111111"
digitMasks$(12) = "000000000000000"
digitMasks$(13) = "101101010101101"
digitMasks$(14) = "111101111110101"
digitMasks$(15) = "110101101101110"

Type Digits
	Field pivot%
	Field currentState%
	Field targetState%
	Field factor#
	Field time%
End Type

Type Cubes
	Field currentState
	Field targetState
	Field digit.Digits
	Field entity%
	Field pos%
End Type

xSetAntiAliasType(xGetMaxAntiAlias())
xGraphics3D(1280, 720, 32, 0, 1)
;xGraphics3D(0, 0, 0, 1, 1)

xAntiAlias(True)

cam = xCreateCamera()
xCameraRange(cam, 1.0, 100.0)
xCameraClsColor(cam, 32, 96, 192)
xPositionEntity(cam, -25, 55, -25)

Global gCube = CreateMasterCube()
xPositionEntity(gCube, -5, 0, 0)
xPointEntity(cam, gCube, 20)

CreateClock()

Global appRun = True
Global appFade = False
Global appFadeTime = 0

While appRun
	
	If xGetKey()
		appFade = True
		appFadeTime = MilliSecs()
		gSpeed = 2.0
	EndIf
	If appFade
		UpdateClock(" X0R53D ")
		If (MilliSecs() - appFadeTime) > 3000
			appRun = False
		EndIf
	Else
		UpdateClock(CurrentTime())
	EndIf
	UpdateCubes()
	xRenderWorld
	xFlip
	
Wend
End

Function CreateMasterCube()
	Local ny
	Local lCube = xCreateCube()
	Local lSurf = xGetSurface(lCube, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		ny = xVertexNY(lSurf, i)
		If ny = 1
			xVertexColor(lSurf, i, 32, 96, 192, 1)
			xVertexCoords(lSurf, i, xVertexX(lSurf, i), xVertexY(lSurf, i) + 0.001, xVertexZ(lSurf, i))
		Else
			xVertexColor(lSurf, i, 255, 255, 255, 1)
		EndIf
	Next
	xEntityFX(lCube, FX_FULLBRIGHT + FX_VERTEXCOLOR )
	xHideEntity(lCube)
	Return lCube
End Function

Function CreateClock()
	For i = -4 To 3
		d.Digits = New Digits
		d\pivot = xCreatePivot()
		d\currentState = 11
		d\targetState = 11
		d\factor = 0.0
		For z = -2 To 2
			For x = -1 To 1
				cube.Cubes = New Cubes
				cube\currentState = 0
				cube\targetState = 0
				cube\digit.Digits = Last Digits
				cube\entity = xCopyEntity(gCube, cube\digit.Digits\pivot)
				cube\pos = (x + 2) + (z + 2) * 3
				xPositionEntity(cube\entity, x*2, 0, -z*2)
			Next
		Next
		xPositionEntity(d\pivot, (i + 0.5) * 7.0, 0, 0)
	Next
End Function

Function UpdateClock(time$)
	If Len(time) <> 8
		Return
	EndIf
	Local dI%, dPI%
	Local dS$
	Local pos% = 1
	For d.Digits = Each Digits
		dS = Mid(time, pos, 1)
		If (Asc(dS) > 47) And (Asc(dS) < 58)
			dI = dS
		Else
			If dS = ":"
				dI = 10
			ElseIf Lower(dS) = "x"
				dI = 13
			ElseIf Lower(dS) = "r"
				dI = 14
			ElseIf Lower(dS) = "d"
				dI = 15
			Else
				dI = 12
			EndIf
		EndIf
		pos = pos + 1
		If dI = 10
			If MilliSecs() Mod 1000 > 850
				dI = 12
			EndIf
		EndIf
		If d\currentState <> dI
			d\factor = 0.0
			d\time = MilliSecs()
		Else
			d\factor = (MilliSecs() - d\time)  / 1000.0 * gSpeed
		EndIf
		d\currentState = dI
		If dI < 9
			d\targetState = dI + 1
		Else
			If dI = 9
				d\targetState = 0
			Else
				d\targetState = d\currentState
			EndIf
		EndIf
		If dI < 10
			;xPositionEntity(d\pivot, xEntityX(d\pivot), dI * 0.5, xEntityZ(d\pivot))
			xPositionEntity(d\pivot, xEntityX(d\pivot), dI * 0.25, xEntityZ(d\pivot))
			xScaleEntity(d\pivot, 1, dI * 0.5 + 1.0, 1)
		EndIf
	Next
End Function

Function UpdateCubes()
	Local s1#, s2#
	Local factor#
	For c.Cubes = Each Cubes
		s1 = c\currentState
		s2 = Mid(digitMasks(c\digit.Digits\currentState), c\pos, 1)
		factor = c\digit.Digits\factor
		If factor >= 1.0
			c\currentState = s2
			factor = 1.0 + Abs(Sin((factor - 1.0) * 100)) * 0.5
		EndIf
		scale# = s1 * (1.0 - factor) + s2 * factor
		xScaleEntity(c\entity, scale, scale, scale)
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D