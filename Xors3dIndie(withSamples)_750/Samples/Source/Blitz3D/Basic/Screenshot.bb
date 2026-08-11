Include "d:\tools\blitz3d\userlibs\xors3d.bb"

Const fade_time# = 1500

Const ext_png$ = "png"
Const ext_jpg$ = "jpg"
Const ext_bmp$ = "bmp"
Const ext_tga$ = "tga"
Const ext_dds$ = "dds"

Const file_ext$ = ext_png
Const file_name$ = "screenshot." + file_ext

Global screen_time% = 0

Type TCube
	Field entity%
End Type

xSetAntiAliasType(xGetMaxAntiAlias())
xGraphics3d(1280, 720, 32, 0, 1)
xAntiAlias(True)

Global camera = xCreateCamera()
xCameraClsColor(camera, 128, 196, 32)

GenerateCubes()

While Not xKeyHit(KEY_ESCAPE)
	UpdateCubes()
	If xKeyHit(KEY_SPACE)
		screen_time = xMillisecs()
		xSaveBuffer(xBackBuffer(), file_name)
	EndIf
	xRenderWorld()
	PrintTime()
	xFlip()
Wend
End

Function GenerateCubes(num% = 100)
	Local r%, g%, b%
	Local lmx#, lmy#, lmz#
	Local gx# = Float(xGraphicsWidth()) * 0.05
	Local gy# = Float(xGraphicsHeight()) * 0.05
	For i = 0 To num - 1
		Local cube.TCube = New TCube
		cube\entity = xCreateCube()
		xScaleEntity(cube\entity, Rnd(3.0, 5.0), Rnd(3.0, 5.0), Rnd(3.0, 5.0))
		lmx = Rnd(-gx, gx)
		lmy = Rnd(-gy, gy)
		lmz = Rnd(100.0, 150.0)
		xPositionEntity(cube\entity, lmx, lmy, lmz)
		r = (lmx + 40.0) / 80.0 * 255
		g = (lmy + 40.0) / 80.0 * 255
		b = (lmz + 40.0) / 80.0 * 255
		xEntityColor(cube\entity, r, g, b)
	Next
End Function

Function UpdateCubes()
	Local cube.TCube
	Local cnt% = 0
	For cube.TCube = Each TCube
		Local p% = (cnt Mod 2) * 2 - 1
		Local y% = (cnt Mod 3) * 2 - 1
		Local r% = (cnt Mod 4) * 2 - 1
		xTurnEntity(cube\entity, 0.1 * p, 0.1 * y, 0.1 * r)
		cnt = cnt + 1
	Next
End Function

Function PrintTime()
	Local dT% = xMillisecs() - screen_time
	If (dT < fade_time)
		xColor(0, 0, 0, 255 * (1.0 - Float(dT) / fade_time))
		xText(10, 10, "Screenshot saved to: '" + file_name + "'")
	EndIf
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D