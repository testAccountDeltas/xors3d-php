Include "..\xors3d.bb"

Const maxCameraAngle# = 85.0
Const minCameraDistance# = 50
Const maxCameraDistance# = 110

xCreateLog(LOG_HTML, LOG_INFO, "Compound.html")

xGraphics3D 1024, 768, 32, False, True
xHidePointer()

xCreateDSS 1024, 1024

Global cameraDistance# = 55
Global camPiv = xCreatePivot()
Global camera= xcreatecamera(camPiv)
xpositionentity camera, 0, 10, -cameraDistance
xCameraClsColor camera, 96, 128, 192
xRotateEntity camPiv, maxCameraAngle / 2, 45, 0
xCameraEnableShadows camera

lightRed = xcreatelight()
xRotateEntity lightRed, 60, 15, 0
xLightColor lightRed, 255, 128, 128

lightBlue = xcreatelight()
xRotateEntity lightBlue, 60, 195, 0
xLightColor lightBlue, 128, 128, 255
xLightEnableShadows lightBlue, True
xLightShadowEpsilons lightBlue, 0.0001, 0.0001

xSetShadowParams(2, 0.75)
xInitShadows(1024, 0, 0)

tex = CreateCheckerTexture()
xScaleTexture(tex, 0.1, 0.1)

Global ground = xCreateCube()
xScaleEntity(ground, 100, 1, 100)
xEntityColor(ground, 64, 64, 64)
xEntityTexture(ground, tex)
xEntityFX(ground, FX_FULLBRIGHT)
xEntityAddBoxShape(ground, 0)

Global border = xCreateCube()
xHideEntity(border)
xFlipMesh(border)
xScaleEntity(border, xEntityScaleX(ground), 50.0, xEntityScaleZ(ground))
xPositionEntity(border, 0.0, xEntityScaleY(border), 0.0)
xEntityAddTrimeshShape(border)

Global compound0 = CreateCompound0()
xEntityColor(compound0, 255, 128, 32)
xPositionEntity(compound0, -5.0, 10.0, -5.0)
xRotateEntity(compound0, 35.0, 35.0, 35.0)

Global compound1 = CreateCompound1()
xEntityColor(compound1, 255, 128, 32)
xPositionEntity(compound1, 5.0, 10.0, 5.0)
xRotateEntity(compound1, 15.0, 25.0, 35.0)

xPhysicsDebugRender(PXDD_WIREFRAME)

While Not xKeyDown(KEY_ESCAPE)
	
	If xKeyHit(KEY_SPACE)
		Reset()
	EndIf
	
	If xKeyHit(KEY_ENTER)
		xEntityApplyTorqueImpulse(compound0, 25.0, 0.0, 0.0, True)
		xEntityApplyTorqueImpulse(compound1, -5.0, 0.0, 0.0, True)
	EndIf
	
	UpdateCamera(0.25)
	
	xUpdateWorld()
	xRenderWorld(1, True)
	xText(10, 10, "Press <Space> to reset scene")
	xText(10, 30, "Press <Enter> to add impulse")
	xFlip()	
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

Function Reset()
	xEntityReleaseForces(compound0)
	xPositionEntity(compound0, -5.0, 10.0, -5.0)
	xRotateEntity(compound0, 35.0, 35.0, 35.0)
	xEntityReleaseForces(compound1)
	xPositionEntity(compound1, 5.0, 10.0, 5.0)
	xRotateEntity(compound1, 15.0, 25.0, 35.0)
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

Function CreateCompound0()
	Local lMesh
	Local lSubmesh
	
	lMesh = xCreateCube()
	xScaleMesh(lMesh, 1.0, 4.0, 1.0)
	
	lSubmesh = xCreateCube()
	xScaleMesh(lSubmesh, 4.0, 1.0, 1.0)
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	lSubmesh = xCreateCube()
	xScaleMesh(lSubmesh, 1.0, 1.0, 4.0)
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	xEntityAddCompoundShape(lMesh, 1.0)
	xEntityCompoundAddBox(lMesh, 1.0 *2, 4.0 *2, 1.0 *2)
	xEntityCompoundAddBox(lMesh, 4.0 *2, 1.0 *2, 1.0 *2)
	xEntityCompoundAddBox(lMesh, 1.0 *2, 1.0 *2, 4.0 *2)
	
	Return lMesh
End Function

Function CreateCompound1()
	Local lMesh
	Local lSubmesh
	
	lMesh = xCreateMesh()
	
	lSubmesh = xCreateSphere()
	xPositionMesh(lSubmesh, -1.0, -Cos(60), -Cos(60))
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	lSubmesh = xCreateSphere()
	xPositionMesh(lSubmesh, 1.0, -Cos(60), -Cos(60))
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	lSubmesh = xCreateSphere()
	xPositionMesh(lSubmesh, 0.0, -Cos(60), 1.0)
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	lSubmesh = xCreateSphere()
	xPositionMesh(lSubmesh, 0.0, 1.0, 0.0)
	xAddMesh(lSubmesh, lMesh)
	xFreeEntity(lSubmesh)
	
	xEntityAddCompoundShape(lMesh, 1.0)
	xEntityCompoundAddSphere(lMesh, 1.0 *1)
	xEntityCompoundAddSphere(lMesh, 1.0 *1)
	xEntityCompoundAddSphere(lMesh, 1.0 *1)
	xEntityCompoundAddSphere(lMesh, 1.0 *1)
	xEntityCompoundChildSetPosition(lMesh, 0, -1.0, -Cos(60), -Cos(60))
	xEntityCompoundChildSetPosition(lMesh, 1, 1.0, -Cos(60), -Cos(60))
	xEntityCompoundChildSetPosition(lMesh, 2, 0.0, -Cos(60), 1.0)
	xEntityCompoundChildSetPosition(lMesh, 3, 0.0, 1.0, 0.0)
	
	Return lMesh
End Function
;~IDEal Editor Parameters:
;~C#Blitz3D