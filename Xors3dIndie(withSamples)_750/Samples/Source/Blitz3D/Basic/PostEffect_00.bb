Include "..\xors3d.bb"

Global masterCube = 0
Global pe_invertion_enabled% = 1
Global pe_rgb2brg_enabled% = 0

;xCreateLog(LOG_HTML, LOG_INFO, "PostEffect_00.html")
xAppTitle("Simple invertion post-effect")
xGraphics3d(1024, 768, 32, 0, 1)

xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
Global mousespeed#       = 0.5
Global camerasmoothness# = 4.5
Global camxa# = 0
Global camya# = 0

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
Local light = xCreateLight()

CubeField()

Global PostEffect_Invertion = xLoadPostEffect("..\..\media\shaders\simple_posteffect_invertion.fx")
Global PostEffect_RGB2BRG = xLoadPostEffect("..\..\media\shaders\simple_posteffect_rgb2brg.fx")

If pe_invertion_enabled
	xSetPostEffect(0, PostEffect_Invertion)
EndIf
If pe_rgb2brg_enabled
	xSetPostEffect(0, PostEffect_RGB2BRG)
EndIf

While Not xKeyHit(KEY_ESCAPE)
	
	PostEffectControl()
;	CameraControl()
	xRenderWorld()
	Draw2D()
	xRenderPostEffects()
	PrintInfo()
	xFlip()
Wend

End

Function CubeField(num% = 10)
	Local x%, y%
	Local i%
	
	For x = 0 To num - 1
		For y = 0 To num - 1
			Local obj%
			If (x = 0 And y = 0)
				obj = xCreateCube()
				masterCube = obj
			Else
				obj = xCopyEntity(masterCube)
			EndIf
			xPositionEntity(obj, (x - num * 0.5 + 0.5) * 2.5, (y - num * 0.5 + 0.5) * 2.5, num * 4.0)
			Local r% = x * 255 / num
			Local g% = y * 255 / num
			Local b% = 255 - g
			xEntityColor(obj, r, g, b)
		Next
	Next
End Function

Function CameraControl()
	If xKeyDown(KEY_W) Then xMoveEntity camera,  0,  0,  1.0
	If xKeyDown(KEY_S) Then xMoveEntity camera,  0,  0, -1.0
	If xKeyDown(KEY_A) Then xMoveEntity camera, -1.0,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity camera,  1.0,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
End Function

Function PostEffectControl()
	If xKeyHit(KEY_1)
		pe_invertion_enabled = 1 - pe_invertion_enabled
		If pe_invertion_enabled
			xSetPostEffect(0, PostEffect_Invertion)
		Else
			xSetPostEffect(0, 0)
		EndIf
	EndIf
	If xKeyHit(KEY_2)
		pe_rgb2brg_enabled = 1 - pe_rgb2brg_enabled
		If pe_rgb2brg_enabled
			xSetPostEffect(1, PostEffect_RGB2BRG)
		Else
			xSetPostEffect(1, 0)
		EndIf
	EndIf
End Function

Function PrintInfo()
	Local state$
	xColor(255, 128, 64, 128)
	xRect(9, 9, 262, 62, 0)
	xColor(0, 0, 0, 128)
	xRect(10, 10, 260, 60, 1)
	xColor(255, 255, 255, 255)
	If (pe_invertion_enabled = 1)
		state = "DISABLE"
	Else
		state = "ENABLE"
	EndIf
	xText(25, 20, "Press '1' to " + state + " Invertion posteffect.")
	If (pe_rgb2brg_enabled = 1)
		state = "DISABLE"
	Else
		state = "ENABLE"
	EndIf
	xText(25, 40, "Press '2' to " + state + " RGB2BRG posteffect.")
End Function

Function Draw2D()
	xColor(255, 128, 0, 255)
	xRect(20, xGraphicsHeight() - 40, xGraphicsWidth() - 40, 30, 1)
	xColor(128, 0, 255, 255)
	xText(xGraphicsWidth() / 2, xGraphicsHeight() - 25, "We can post process 2d graphics too", 1, 1)
End Function

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D