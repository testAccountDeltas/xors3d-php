Include "..\xors3d.bb"

Const sizeX# = 2.0
Const sizeY# = 1.5
Const alphaVal# = 0.8

Global scaleY# = 1.0
Global deltaScaleY# = 0.1
Global state% = 1
Global zoom# = 1.0

xCreateLog(LOG_HTML, LOG_INFO, "Holoscreen.html")

xGraphics3D(1280, 720, 32, False, True)

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
xCameraZoom(camera, zoom)

Global skybox = LoadSkybox("..\..\Media\Textures\Skybox\Miramar\miramar", "dds", camera)

Global screen = xCreatePoly(0)
xPositionEntity(screen, 0.0, 0.0, 4.0)
xScaleEntity(screen, sizeX, sizeY, 0.0)
xEntityColor(screen, 255, 255, 255)
xEntityAlpha(screen, alphaVal)

Global tempTexture = xLoadTexture("..\..\Media\textures\copperhead.jpg", 1 + 2 + 32768)
Global noiseTexture = xLoadTexture("..\..\Media\textures\noise.png")
xEntityTexture(screen, tempTexture, 0, 0)
xEntityTexture(screen, noiseTexture, 0, 1)

Global effect = xLoadFXFile("..\..\Media\shaders\holoscreen.fx")
If Not xValidateEffectTechnique(effect, "Holoscreen")
	RuntimeError "Technique isn’t supported"
EndIf
xSetEntityEffect screen, effect
xSetEffectTechnique screen, "Holoscreen"

Global snd_in = xLoadSound("..\..\Media\sounds\beep_in.ogg")
Global snd_out = xLoadSound("..\..\Media\sounds\beep_out.ogg")
xSoundVolume(snd_in, 0.5)
xSoundVolume(snd_out, 0.5)

xPointEntity(camera, screen)
While Not xKeyDown(KEY_ESCAPE)
	
	UpdateControl()
	UpdateScreen()
	xRenderWorld()
	PrintInfo()
	xFlip()
	
Wend

End

Function LoadSkybox(path$, ext$, parent% = 0)
	Local tex_cube% = xLoadTexture(path + "_cubemap_dxt1." + ext, FLAGS_COLOR + FLAGS_CUBICENVMAP )
	Local skybox% = xCreateCube()
	xFlipMesh(skybox)
	xScaleMesh(skybox, 10.0, 10.0, 10.0)
	xEntityOrder(skybox, 1024)
	xEntityTexture(skybox, tex_cube)
	xEntityFX(skybox, FX_FULLBRIGHT)
	xEntityColor(skybox, 192, 224, 255)
	
	Return skybox
End Function

Function UpdateControl()
	Local mX# = (xMouseX() - Float(xGraphicsWidth()) * 0.5) * 0.05
	Local mY# = -(xMouseY() - Float(xGraphicsHeight()) * 0.5) * 0.05
	xRotateEntity(screen, mY, mX, 0)
	xRotateEntity(camera, -mY * 0.25, -mX * 0.25, 0)
	
	If xKeyHit(KEY_SPACE)
		If state = 1
			xPlaySound(snd_out)
		Else
			xPlaySound(snd_in)
		EndIf
		If (scaleY = 1.0) Or (scaleY = 0.0)
			state = 1 - state
		EndIf
	EndIf
	
	Local scroll# = xMouseZSpeed()
	If scroll
		zoom = zoom + scroll * 0.25
		If zoom < 0.5
			zoom = 0.5
		EndIf
		If zoom > 5.0
			zoom = 5.0
		EndIf
		xCameraZoom(camera, zoom)
	EndIf
End Function

Function UpdateScreen()
	Local needsScale% = 0
	Local scaleX# = 1.0
	If state = 1
		If scaleY < 1.0
			scaleY = scaleY + deltaScaleY
			If scaleY > 1.0
				scaleY = 1.0
			EndIf
			needsScale = 1
		EndIf
	Else
		If scaleY > 0.0
			scaleY = scaleY - deltaScaleY
			If scaleY < 0.0
				scaleY = 0.0
			EndIf
			needsScale = 1
		EndIf
	EndIf
	If needsScale = 1
		scaleX = 1.0 + (1.0 - scaleY) * 0.35
		xScaleEntity(screen, sizeX * scaleX, sizeY * scaleY, 1.0)
		xEntityAlpha(screen, alphaVal * Sqr(scaleY))
	EndIf
End Function

Function PrintInfo(x% = 10, y% = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 255 + x, 95 + y, True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 255 + x, 95 + y, False)
	xColor(96, 152, 255, 255)
	xText(10 + x + 120, 10 + y, "Holoscreen", 1)
	xText(10 + x, 25 + y, "Triangles: " + xTrisRendered())
	xText(10 + x, 40 + y, "DIP calls: " + xDIPCounter())
	xText(10 + x, 55 + y, "FPS: " + xGetFPS())
	If state = 1
		xText(10 + x, 70 + y, "Press <SPACE> to turn screen OFF")
	Else
		xText(10 + x, 70 + y, "Press <SPACE> to turn screen ON")
	EndIf
	xText(10 + x, 85 + y, "Use <MOUSE SCROLL> to zoom camera. Zoom: " + zoom)
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D