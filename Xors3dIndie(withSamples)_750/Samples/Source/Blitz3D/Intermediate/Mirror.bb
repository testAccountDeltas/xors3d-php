Include "..\xors3d.bb"

xCreateLog(LOG_HTML, LOG_INFO, "Mirror.html")
xAppTitle "Mirror"

; mirror camera
Global mCamera%

; mirror texture
Global tTextureReflection

xGraphics3D 1024, 768, 32, False, True

; mirror texture dimensions
Global reflSizeX = xGraphicsWidth() ;1024
Global reflSizeY = xGraphicsHeight() ;1024

xCreateDSS(reflSizeX, reflSizeY)

; mouse stuff
Global mousespeed# = 0.5, camerasmoothness# = 4.5
Global camxa# = 0, camya# = 0, mxs# = 0, mys# = 0
Global center_x = xGraphicsWidth() / 2
Global center_y = xGraphicsHeight() / 2
xMoveMouse center_x, center_y
xHidePointer

; some color cubes
Garbage()

Global mirror = CraftMirror()
xRotateEntity(mirror, 0.0, 135.0, 45.0)
xPositionEntity(mirror, 80.0, 0.0, 80.0)

light         = xCreateLight(2)
xPositionEntity light,16,8,0
xRotateEntity   light, 0,0,0
pivLight      = xCreatePivot()
xEntityParent   light, pivLight
lightSource   = xCreateSphere(16)
xEntityFX       lightSource, 1+8
xPositionEntity lightSource, xEntityX(light,1), xEntityY(light,1), xEntityZ(light,1)
xEntityParent   lightSource, pivLight

; main camera
Global Cam     = xCreateCamera()
xCameraClsColor Cam,100,100,255
xPositionEntity Cam, 0,24,-32

; a debug cube which shows the reflection texture
dc = xCreateCube(Cam)
xEntityOrder dc, -1
xEntityFX dc, FX_FULLBRIGHT
xScaleEntity dc, 1, 1, 0.01
xMoveEntity dc, -4.2, 3.0, 10
xEntityTexture dc, tTextureReflection

; a debug cone showing the mirror camera
fake = xCreateCone(16, True, mCamera)
xRotateMesh fake, 90, 0, 0
xScaleMesh fake, 5, 5, 10
xEntityColor fake, 255, 0, 0

checker = CreateCheckerTexture()
xScaleTexture checker, 0.125, 0.125

back = xCreateCube()
xScaleEntity back, 500, 500, 1
xPositionEntity back, 0, 0, -300
xEntityTexture back, checker
xEntityColor back, 0, 255, 0

Global cracked = 0

While Not xKeyDown(KEY_ESCAPE) Or xWinMessage("WM_CLOSE")
	
	If xKeyHit(KEY_SPACE)
		cracked = 1 - cracked
		If Not cracked
			xSetEffectTechnique mirror, "Mirror"
		Else
			xSetEffectTechnique mirror, "Mirror_Broken"
		EndIf
	EndIf
	
	xTurnEntity PivLight, 0, 1, 0
	
	MouseLookAndFly()
	
	xHideEntity dc
	UpdateMirror(mirror, mCamera, Cam)
	xShowEntity dc
	
	xRenderWorld
	xText 10, xGraphicsHeight() - 55, "WASD to move camera"
	xText 10, xGraphicsHeight() - 40, "Drag mouse to rotate camera"
	If Not cracked
		xText 10, xGraphicsHeight() - 25, "Press <SPACE> to break the mirror"
	Else
		xText 10, xGraphicsHeight() - 25, "What have you done?! Fix it immediately! <SPACE>"
	EndIf
	xFlip
	
	
Wend

Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments
	If increments <= 1 Then oldvalue# = newvalue#
	Return oldvalue#
End Function

Function MouseLookAndFly(speed#=1.0)
	movx# = (xKeyDown(KEY_D)-xKeyDown(KEY_A))*speed
	movz# = (xMouseDown(1)-xMouseDown(2))*speed
	movz# = movz#+(xKeyDown(KEY_W)-xKeyDown(KEY_S))*speed
	xMoveEntity Cam, movx, 0, movz
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa = camxa - mxs Mod 360
	camya = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xRotateEntity Cam, camya, camxa, 0	
	xMoveMouse center_x, center_y
End Function

Function Garbage(num% = 40)
	Local mesh%
	Local r%, g%, b%
	Local lmx#, lmy#, lmz#
	For i = 0 To num - 1
		mesh = xCreateCube()
		xScaleEntity mesh, Rnd(3.0, 5.0), Rnd(3.0, 5.0), Rnd(3.0, 5.0)
		lmx = Rnd(-40.0, 40.0)
		lmy = Rnd(-40.0, 40.0)
		lmz = Rnd(-40.0, 40.0)
		xPositionEntity mesh, lmx, lmy, lmz
		r = (lmx + 40.0) / 80.0 * 255
		g = (lmy + 40.0) / 80.0 * 255
		b = (lmz + 40.0) / 80.0 * 255
		xEntityColor mesh, r, g, b
	Next
	
End Function

Function CraftMirror()
	
	Local mesh%    = xCreateMesh   ()
	Local surf%    = xCreateSurface(mesh)
	
	; simple quad
	xAddVertex(surf, -1.0, 1.0, 0.0)
	xAddVertex(surf, 1.0, 1.0, 0.0)
	xAddVertex(surf, 1.0, -1.0, 0.0)
	xAddVertex(surf, -1.0, -1.0, 0.0)
	
	xVertexTexCoords(surf, 0, 0.0, 0.0, 1.0)
	xVertexTexCoords(surf, 1, 1.0, 0.0, 1.0)
	xVertexTexCoords(surf, 2, 1.0, 1.0, 1.0)
	xVertexTexCoords(surf, 3, 0.0, 1.0, 1.0)
	
	xAddTriangle(surf, 0, 2, 1)
	xAddTriangle(surf, 0, 3, 2)
	
	xUpdateNormals mesh
	xScaleEntity mesh, 40, 40, 40
	
	; reflection texture
	tTextureReflection = xCreateTexture(reflSizeX, reflSizeY, 1)
	
	; crack textures
	tCrackNorm = xLoadTexture("..\..\Media\Textures\broken-glass_normal.jpg")
	tCrackDiff = xLoadTexture("..\..\Media\Textures\broken-glass_diffuse.jpg")
	
	xEntityTexture(mesh, tTextureReflection, 0, 0)
	xEntityTexture(mesh, tCrackNorm, 0, 1)
	xEntityTexture(mesh, tCrackDiff, 0, 2)
	
	tShader% = xLoadFXFile("..\..\Media\Shaders\mirror.fx")
	xSetEntityEffect mesh, tShader
	xSetEffectTechnique mesh, "Mirror"
	
	; creating the mirror camera
	mCamera% = xCreateCamera()
	xCameraClsColor mCamera,100,100,255
	xHideEntity mCamera
	
	; mirror frame
	Local frame = xCreateCube(mesh)
	xScaleEntity frame, 1.1, 1.1, 0.01
	xMoveEntity frame, 0, 0, -0.02
	xEntityColor frame, 64, 64, 64
	
	Return mesh
End Function

Function UpdateMirror(mirrorEnt%, mirrorCamera%, viewCamera%)
	Local mX#, mY#, mZ#
	Local vX#, vY#, vZ#
	Local d#
	
	; reflecting the position of the main camera and put the mirror camera at that position
	xTFormPoint 0.0, 0.0, 0.0, viewCamera, mirrorEnt
	xTFormPoint xTFormedX(), xTFormedY(), -xTFormedZ(), mirrorEnt, 0
	xPositionEntity mirrorCamera, xTFormedX(), xTFormedY(), xTFormedZ()
	
	; the normal vector of the mirror plane
	xTFormNormal 0.0, 0.0, 1.0, mirrorEnt, 0
	mX = xTFormedX()
	mY = xTFormedY()
	mZ = xTFormedZ()
	
	; view vector of the main camera
	xTFormVector 0.0, 0.0, 1.0, viewCamera, 0
	vX = xTFormedX()
	vY = xTFormedY()
	vZ = xTFormedZ()
	
	d = 2 * (mX*vX + mY*vY + mZ*vZ) / (mX*mX + mY*mY + mZ*mZ)
	vX = vX - mX * d
	vY = vY - mY * d
	vZ = vZ - mZ * d
	
	; reflecting the view vector of the main camera
	xAlignToVector mirrorCamera, vX, vY, vZ, AXIS_Z
	
	; here we have a trouble with the Roll - it causes a wrong texture if the mirror is not vertical
	; TODO: fix that!
	xRotateEntity mirrorCamera, xEntityPitch(mirrorCamera, True), xEntityYaw(mirrorCamera, True), xEntityRoll(viewCamera, True)
	
	xHideEntity viewCamera
	xShowEntity mirrorCamera
	
	; clipping the objects behind the mirror to avoid wrong reflection
	xCameraClipPlane mirrorCamera, 0, True, mX, mY, mZ, -mX * xEntityX(mirrorEnt, True) - mY * xEntityY(mirrorEnt, True) - mZ * xEntityZ(mirrorEnt, True)
	xSetBuffer xTextureBuffer(tTextureReflection)
	; turning the clipping plane off
	xCameraViewport mirrorCamera, 0, 0, reflSizeX, reflSizeY
	xHideEntity(mirror)
	xRenderWorld 1, False
	xShowEntity(mirror)
	xSetBuffer xBackBuffer()
	xHideEntity mirrorCamera
	xShowEntity viewCamera
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

End
;~IDEal Editor Parameters:
;~C#Blitz3D