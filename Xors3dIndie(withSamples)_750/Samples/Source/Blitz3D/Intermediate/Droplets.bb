Include "..\xors3d.bb"

Const camZoom# = 1.0
Const zPlane# = 2.0
Const mousespeed#       = 0.5
Const camerasmoothness# = 4.5
Const maxDropletNum% = 500
Const minDropletNum% = 0
Const dropletAcceleration# = -0.0025

Type TDrop
	Field entity%
	Field size#
	Field x#, y#
	Field vx#, vy#
	Field startTime%
	Field lifeTime%
	Field randTime%
End Type

xCreateLog(LOG_HTML, LOG_INFO, "Droplets.html")

xAppTitle("Droplets")
xGraphics3d(1024, 768, 32, 0, 1)

Global showDistortion = 1
Global showDropletBuffer = 0
Global g_mouseXSpeed# = 0.0
Global g_mouseYSpeed# = 0.0
Global g_cameraXAngle# = 0.0
Global g_cameraYAngle# = 0.0
Global cameraXSpeed# = 0.0
Global cameraYSpeed# = 0.0
Global FOV# = ATan(1.0 / camZoom) / 2.0
Global aspectRatio# = Float(xGraphicsWidth()) / Float(xGraphicsHeight())
Global planeHeight# = zPlane * Tan(FOV)
Global planeWidth# = planeHeight * aspectRatio
Global dropScale# =  planeHeight * 0.02
Global maxDropletYSpeed# = 0.36 * dropScale
Global maxArcLength# = 6.0 * dropScale
Global dropletsNum% = 0
Global limitDropletNum% = 150

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
xCameraRange(camera, 1.0, 1000.0)
xCameraZoom(camera, camZoom)

Global skybox = LoadSkybox("..\..\Media\Textures\Skybox\Miramar\miramar", "dds")

Global droplet_nm% = LoadDropletNormalMap()
Global dropletBuffer% = CreateDropletBuffer()
Global dropPiv% = xCreatePivot(camera)

Global poly = xCreatePoly(0, camera)
xScaleEntity(poly, planeWidth, planeHeight, 1.0)
xPositionEntity(poly, 0.0, 0.0, zPlane)
xEntityFX(poly, FX_FULLBRIGHT)
xEntityTexture(poly, dropletBuffer)
xHideEntity(poly)

Global initialDroplet = CreateInitialDroplet()

Global PostEffect_Offset = xLoadPostEffect("..\..\Media\shaders\droplets_posteffect_distortion.fx")
xSetPostEffect( 0, PostEffect_Offset )
xSetPostEffectTexture (PostEffect_Offset, "distortionTexture", dropletBuffer)

While Not (xKeyHit(KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
	UpdateFrame()
	
	If (showDropletBuffer = 0)
		xHideEntity(poly)
	EndIf
	If (showDistortion = 1)
		xSetBuffer(xTextureBuffer(dropletBuffer))
		xCameraClsMode(camera, False, False)
		xHideEntity(skybox)
		xShowEntity(dropPiv)
		xColor(128, 128, 0, 4)
		xRect(0, 0, xGraphicsWidth(), xGraphicsHeight(), 1)
	EndIf
	xRenderWorld()
	
	If (showDropletBuffer = 1)
		xShowEntity(poly)
	EndIf
	If (showDistortion = 1)
		xSetBuffer(xBackBuffer())
		xCameraClsColor(camera, 32, 64, 128)
		xCameraClsMode(camera, True, True)
		xShowEntity(skybox)
		xHideEntity(dropPiv)
		xRenderWorld()
		xHideEntity(poly)
		If (showDropletBuffer = 0)
			xRenderPostEffects()
		EndIf
	EndIf
	
	PrintInfo()
	
	xFlip()
Wend

End

Function LoadSkybox(path$, ext$)
	Local tex_cube% = xLoadTexture(path + "_cubemap_dxt1." + ext, FLAGS_COLOR + FLAGS_CUBICENVMAP )
	Local skybox% = xCreateCube()
	xFlipMesh(skybox)
	xScaleMesh(skybox, 10.0, 10.0, 10.0)
	xEntityOrder(skybox, 1024)
	xEntityTexture(skybox,  tex_cube)
	xEntityFX(skybox, FX_FULLBRIGHT)
	
	Return skybox
End Function

Function CreateDropletBuffer()
	Local buffer% = xCreateTexture(xGraphicsWidth(), xGraphicsHeight(), FLAGS_COLOR + 16384); + FLAGS_ALPHA)
	xSetBuffer(xTextureBuffer(buffer))
	xClsColor(128, 128, 0)
	xCls()
	xSetBuffer(xBackBuffer())
	Return buffer
End Function

Function LoadDropletNormalMap()
	Return xLoadTexture("..\..\Media\Textures\droplet_nm.dds", FLAGS_COLOR + FLAGS_ALPHA)
End Function

Function CreateInitialDroplet()
	Local shader = xLoadFXFile("..\..\Media\Shaders\droplets_hw_instancing.fx")
	Local droplet = xCreatePoly(0)
	xEntityTexture(droplet, droplet_nm)
	xSetEntityEffect(droplet, shader)
	xSetEffectTechnique(droplet, "Instancing")
	xHideEntity(droplet)
	Return droplet
End Function

Function CreateDroplet(x# = 0.0, y# = 0.0, size# = 0.0)
	If x < -1.0 Then x = -1.0
	If x > +1.0 Then x = +1.0
	If y < -1.0 Then y = -1.0
	If y > +1.0 Then y = +1.0
	Local d.TDrop = New TDrop
	d\entity = xCreateInstance(initialDroplet, dropPiv)
	If (size = 0)
		d\size = Rnd(0.25, 1.0) * dropScale
	Else
		d\size = size
	EndIf
	d\x = (planeWidth + d\size) * x
	d\y = (planeHeight + d\size) * y
	d\vx = dropScale * Rnd(-0.0625, 0.0625)
	d\vy = dropScale * Rnd(-0.3125, -0.0156)
	xPositionEntity(d\entity, d\x, d\y, zPlane)
	xScaleEntity(d\entity, d\size, d\size, d\size)
	d\startTime = xMillisecs()
	d\randTime = Rand(5000, 10000)
	d\lifeTime = d\startTime + d\randTime
	dropletsNum = dropletsNum + 1
End Function

Function UpdateDroplets()
	Local localTime% = xMillisecs()
	Local cosCameraPitch# = Cos(xEntityPitch(camera))
	Local sinCameraPitch# = Sin(xEntityPitch(camera))
	Local d.TDrop
	For d.TDrop = Each TDrop
		If (xMilliSecs() - d\startTime > 150)
			d\vx = dropScale * Rnd(-0.0625, 0.0625)
			d\vy = d\vy * (Saturate(Rnd(-100.0, 1.0)) * 0.5 + 1.0) ; sudden rare acceleration
			d\startTime = xMillisecs()
		EndIf
		d\vy = (d\vy + dropletAcceleration * d\size) * cosCameraPitch
		d\vx = d\vx * (cosCameraPitch * 0.5 + 0.5) * (Saturate(Abs(d\vy / maxDropletYSpeed))* 0.85 + 0.15) + Clamp(cameraXSpeed) * 0.032 * dropScale * cosCameraPitch
		; limit speed to avoid unnatural 'dotted' streaks
		If (d\vy < -maxDropletYSpeed)
			d\vy = -maxDropletYSpeed
		EndIf
		d\x = d\x + d\vx
		d\y = d\y + d\vy
		
		; droplets should rotate when the camera faces up or down
		Local r# = Sqr(d\x*d\x + d\y*d\y)
		Local dArc# = Clamp(cameraXSpeed) * 32.0 * dropScale * (1.0 - cosCameraPitch)
		If (Abs(r * dArc) > maxArcLength)
			dArc = maxArcLength / r * Sgn(dArc)
		EndIf
		Local arc# = ATan2(d\y, d\x) - r * dArc
		d\x = r * Cos(arc)
		d\y = r * Sin(arc)
		
		xPositionEntity(d\entity, d\x, d\y, zPlane)
		Local alpha#  = Float(d\lifeTime - localTime) / Float(d\randTime)
		xEntityAlpha(d\entity, alpha)
		If (xEntityY(d\entity) < -(planeHeight + d\size)) Or (d\lifeTime - localTime < 0)
			xFreeEntity(d\entity)
			Delete d
			dropletsNum = dropletsNum - 1
		EndIf
	Next
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
	
	If xKeyHit(KEY_ENTER)
		showDistortion = 1 - showDistortion
		If (showDistortion = 0)
			xHideEntity(dropPiv)
		EndIf
	EndIf
	
	If xKeyHit(KEY_SPACE)
		showDropletBuffer = 1 - showDropletBuffer
	EndIf
	
	limitDropletNum = limitDropletNum + xMouseZSpeed()
	If limitDropletNum > maxDropletNum
		limitDropletNum = maxDropletNum
	EndIf
	If limitDropletNum < minDropletNum
		limitDropletNum = minDropletNum
	EndIf
End Function

Function UpdateFrame()
	UpdateDroplets()
	While dropletsNum < limitDropletNum
		CreateDroplet(Rnd(-1.0, 1.0), Rnd(-1.0, 1.0))
	Wend
End Function

Function UpdateCamera(cam%)
	Local oldPitch# = xEntityPitch(camera)
	Local oldYaw# = xEntityYaw(camera)
	g_mouseXSpeed# = CurveValue(xMouseXSpeed() * mousespeed, g_mouseXSpeed, camerasmoothness)
	g_mouseYSpeed# = CurveValue(xMouseYSpeed() * mousespeed, g_mouseYSpeed, camerasmoothness)
	g_cameraXAngle = g_cameraXAngle - g_mouseXSpeed Mod 360
	g_cameraYAngle = g_cameraYAngle + g_mouseYSpeed
	If g_cameraYAngle < -89.9 Then g_cameraYAngle = -89.9
	If g_cameraYAngle >  89.9 Then g_cameraYAngle =  89.9
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(cam, g_cameraYAngle, g_cameraXAngle, 0.0)
	cameraXSpeed = xEntityYaw(camera) - oldYaw
	cameraYSpeed = xEntityPitch(camera) - oldPitch
End Function

Function PrintInfo(x% = 10, y% = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 245 + x, 125 + y, True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 245 + x, 125 + y, False)
	xColor(96, 152, 255, 255)
	xText(10 + x + 120, 10 + y, "Droplets", 1)
	xText(10 + x, 25 + y, "Triangles: " + xTrisRendered())
	xText(10 + x, 40 + y, "DIP calls: " + xDIPCounter())
	xText(10 + x, 55 + y, "FPS: " + xGetFPS())
	If showDropletBuffer = 0
		xText(10 + x, 70 + y, "Press <SPACE> to SHOW droplet buffer")
	Else
		xText(10 + x, 70 + y, "Press <SPACE> to HIDE droplet buffer")
	EndIf
	If showDistortion = 0
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion ON")
	Else
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion OFF")
	EndIf
	xText(10 + x, 100 + y, "Droplets: " + dropletsNum + " (use <MOUSE SCROLL> to change)")
	xText(10 + x, 115 + y, "Use <MOUSE> to rotate camera")
End Function

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D