Include "..\xors3d.bb"

Const USE_TEXTURED_POLY = True

Type TDisk
	Field entity%
	Field speed#
End Type

xGraphics3d(1024, 768, 32, 0, 1)

Global camera = xCreateCamera()
xPositionEntity(camera, 0.0, 0.0, -16.0)

Global tex
If USE_TEXTURED_POLY
	tex = xLoadTexture("../../Media/Textures/magic_circle.png")
EndIf

CreateDisks()

While Not xKeyHit(KEY_ESCAPE)
	UpdateDisks()
	xRenderWorld()
	xFlip()
Wend
End

Function CreateDisks(num% = 8)
	Local i%
	For i = 1 To num
		Local ni# = (num - i) * 0.5
		Local si# = ni / num * 20
		Local ci#
		If USE_TEXTURED_POLY
			ci = i * 0.35
		Else
			ci = i
		EndIf
		Local disk.TDisk = New TDisk
		If (i = 1)
			If USE_TEXTURED_POLY
				disk\entity = xCreatePoly(False)
				xEntityTexture(disk\entity, tex)
				xEntityBlend(disk\entity, BLEND_PUREADD)
			Else
				disk\entity = xCreateCylinder(32, True)
				xRotateMesh(disk\entity, 90, 0, 0)
				xScaleMesh(disk\entity, 1.0, 1.0, 0.1)
			EndIf
		Else
			Local f.TDisk = First TDisk
			Local l.TDisk = Before Last TDisk
			disk\entity = xCopyEntity(l\entity, l\entity)
		EndIf
		xEntityFX(disk\entity, FX_FULLBRIGHT)
		xEntityOrder(disk\entity, ni + 1)
		xScaleEntity(disk\entity, si, si, si, True)
		xPositionEntity(disk\entity, ci, 0.0, 0.0, True)
		xEntityColor(disk\entity, 0, 255 * Float(i) / Float(num), 255 * (1.0 - Float(i) / Float(num)))
		If USE_TEXTURED_POLY
			xEntityAlpha(disk\entity, Float(i * 0.5) / num + 0.5)
		EndIf
		disk\speed = Float(i) / num
	Next
End Function

Function UpdateDisks()
	Local disk.TDisk
	For disk.TDisk = Each TDisk
		xTurnEntity(disk\entity, 0.0, 0.0, disk\speed, True)
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D