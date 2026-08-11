Include "..\xors3d.bb"

Const domSize# = 1.0
Const domStartRadius# = 4.0
Const domDeltaRadius# = 0.125
Const domDeltaAngle# = 2.5
Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 180
Const maxDominos% = 256

Global cameraDistance# = 85

Global rPos% = maxDominos / 4
Global gPos% = maxDominos / 4 * 2
Global bPos% = maxDominos / 4 * 3
Global rCol = 255
Global gCol = 255
Global bCol = 255

Global launched = False

Type tDomino
	Field entity%
End Type

Global lastDomino.tDomino
Global lastDominoIndex

xCreateLog(LOG_HTML, LOG_INFO, "Domino.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera,0,0, -cameraDistance
xCameraClsColor camera, 96, 128, 192
xRotateEntity camPiv, maxCameraAngle / 3, -135, 0
xCameraEnableShadows camera

lightBlue = xcreatelight()
xRotateEntity lightBlue, 60, 195, 0
xLightColor lightBlue, 128, 128, 255
xLightEnableShadows lightBlue, True
xLightShadowEpsilons lightBlue, 0.0001, 0.0001

xSetShadowParams(2, 0.75)
xInitShadows(1024, 0, 0)

Global inst_shader = 0
instancingType$ = "Software emulation"
If xHWInstancingAvailable()
	inst_shader = xLoadFXFile("Media\Shaders\hwinstancing2.fx")
	instancingType$ = "Hardware"
Else If xShaderInstancingAvailable()
	inst_shader = xLoadFXFile("Media\Shaders\shaderinstancing.fx")
	instancingType$ = "Shaders emulation"
EndIf

Global tex = CreateCheckerTexture()
xScaleTexture(tex, 0.25, 0.25)

Global ground = xCreateCube()
xScaleEntity(ground, 100.0, 1.0, 100.0)
xPositionEntity(ground, 0.0, -1.0, 0.0)
xEntityColor(ground, 64, 64, 64)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityTexture(ground, tex)
xEntityAddBoxShape(ground, 0)

GenerateDominos()

While Not xKeyDown(KEY_ESCAPE)
	If xKeyHit(KEY_SPACE)
		If launched
			Reset()
		Else
			Launch()
		EndIf
	EndIf
	
	UpdateDominos()
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, 0);True)
	xText( 10, 10, "FPS: " + xGetFPS())
	xText( 10, 30, "Dominos: " + maxDominos)
	If launched
		xText( 10, 50, "Press <Space> to reset")
	Else
		xText( 10, 50, "Press <Space> to launch")
	EndIf
	xflip()	
Wend
End

Function UpdateCamera(ViewSensivity#)
	xMoveMouse(xGraphicsWidth()/2, xGraphicsHeight()/2)
	mXSp = xMouseXSpeed()
	mYSp = xMouseYSpeed()
	Local CamP# = xEntityPitch(camPiv) + mYSp * ViewSensivity
	If Abs(CamP) > maxCameraAngle
		CamP = maxCameraAngle * Sgn(CamP)
	EndIf
	xTurnEntity camPiv,0,-mXSp*ViewSensivity*(1.05 - Abs(CamP) / maxCameraAngle),0
	xRotateEntity camPiv,CamP,xEntityYaw(camPiv),0
	mZSp = xMouseZSpeed()
	cameraDistance = cameraDistance + mZSp
	If (cameraDistance < maxCameraDistance) And (cameraDistance > minCameraDistance)
		xMoveEntity camera, 0, 0, -mZSp
	Else
		If cameraDistance > maxCameraDistance
			cameraDistance = maxCameraDistance
		EndIf
		If cameraDistance < minCameraDistance
			cameraDistance = minCameraDistance
		EndIf
	EndIf
	
End Function

Function Launch()
	If launched
		Return
	EndIf
	d.tDomino = First tDomino
	xEntityApplyImpulse(d\entity, 0, 0, 5.0, 0, domSize, 0, False, False)
	launched = True
End Function

Function Reset()
	Local lAngle# = 0.0
	Local lRadius# = domStartRadius
	Local lX#, lZ#
	For d.tDomino = Each tDomino
		lX = lRadius * Cos(lAngle)
		lZ = lRadius * Sin(lAngle)
		xEntityReleaseForces(d\entity)
		xPositionEntity(d\entity, lX, domSize, lZ)
		xRotateEntity(d\entity, 0.0, lAngle, 0.0)
		xEntityColor(d\entity, 255, 255, 255)
		lAngle = lAngle + domDeltaAngle / lRadius * domStartRadius / domDeltaRadius
		lRadius = lRadius + domDeltaRadius
	Next
	lastDomino = First tDomino
	lastDominoIndex = 0
	rCol = 255
	gCol = 255
	bCol = 255
	launched = False
End Function

Function GenerateDominos()
	For i =  0 To maxDominos  - 1
		d.tDomino = New tDomino
		If i = 0
			d\entity = xCreateCube()
			xSetEntityEffect d\entity, inst_shader
			xSetEffectTechnique d\entity, "Instancing"
		Else
			Local master.tDomino = First tDomino
			d\entity = xCreateInstance(master\entity)
		EndIf
		xScaleEntity(d\entity, domSize * 0.4, domSize, domSize * 0.1)
		xEntityAddBoxShape(d\entity, 1)
	Next
	Reset()
End Function

Function UpdateDominos()
	If Not launched
		Return
	EndIf
	Local delta = 1024 / maxDominos
	Local d.tDomino = lastDomino
	While d <> Null
		If Abs(xEntityGetAngularVelocityZ(d\entity, False)) > 0.1
			If lastDominoIndex < rPos
				gCol = gCol - delta
				bCol = bCol - delta
			ElseIf lastDominoIndex < gPos
				gCol = gCol + delta
				rCol = rCol - delta
			ElseIf lastDominoIndex < bPos
				bCol = bCol + delta
				gCol = gCol - delta
			Else
				rCol = rCol + delta
				bCol = bCol - delta
			EndIf
			xEntityColor(d\entity, rCol, gCol, bCol)
			d = After d
			lastDomino = d.tDomino
			lastDominoIndex = lastDominoIndex + 1
		Else
			Exit
		EndIf
	Wend
End Function

Function CreateCheckerTexture(size% = 256)
	Local lTex = xCreateTexture(size, size)
	xSetBuffer(xTextureBuffer(lTex))
	xColor(222, 222, 222)
	xRect(0, 0, size, size, 1)
	xColor(255, 255, 255)
	xRect(0, 0, size / 2, size / 2, 1)
	xRect(size / 2, size / 2, size / 2, size / 2, 1)
	xSetBuffer(xBackBuffer())
	Return lTex
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D