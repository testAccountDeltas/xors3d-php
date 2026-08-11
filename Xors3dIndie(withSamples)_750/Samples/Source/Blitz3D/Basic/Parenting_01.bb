Include "..\xors3d.bb"

Type TObj
	Field entity%
	Field factor#
End Type

Global startTime%

xGraphics3d(1024, 768, 32, 0, 1)

Global camera = xCreateCamera()
xPositionEntity(camera, 0.0, 20.0, -50.0)

xCreateLight()

GenerateObjs(40, 0.5, 0.1)

While Not xKeyHit(KEY_ESCAPE)
	UpdateObjs()
	xRenderWorld()
	xFlip()
Wend
End

Function GenerateObjs(count%, height#, size#)
	Local max% = 20
	Local i%, j%
	Local obj.TObj
	Local prevEntity%, parent%
	Local initialObj% = xCreateCube()
	xPositionMesh(initialObj, 0, 1.0, 0)
	xScaleMesh(initialObj, size, height, size)
	
	For j = 1 To max
		prevEntity = 0
		For i = 1 To count
			obj.TObj = New TObj
			obj\factor = 1.0 / (Sin(Float(j) * 45.0 / 15.0) + 1.0)
			If ((i = 1) And (j = 1))
				obj\entity = initialObj
			Else
				obj\entity = xCopyEntity(initialObj)
			EndIf
			xPositionEntity(obj\entity, 0, 2.0 * height * (i - 1) * 0.95, 0)
			xEntityColor(obj\entity, 255.0 / 20 * j, 255.0 / Float(count) * i - 255.0 / 20 * j, 255.0 - 255.0 / Float(count) * i)
			prevEntity = obj\entity
		Next
	Next
	
	obj.TObj = First TObj
	For j = 1 To max
		parent = 0
		For i = 1 To count
			xEntityParent(obj\entity, parent)
			parent% = obj\entity
			If (obj <> Last TObj)
				obj = After obj
			EndIf
		Next
	Next
	startTime = xMillisecs()
End Function

Function UpdateObjs()
	Local obj.TObj
	For obj.TObj = Each TObj
		Local period# = Sin((MilliSecs() - startTime) * 0.05) * 25
		xRotateEntity(obj\entity, 0, 0, period * obj\factor)
		If (xGetParent(obj\entity))
			xTurnEntity(obj\entity, 0, 25.0 * obj\factor, 0)
		EndIf
	Next
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D