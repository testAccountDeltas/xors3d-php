'*******************************************************************
'*                                                                 *
'* Xors3D Engine. Bump-mapping sample, (c) 2009 Xors3D Team        *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' setup maximum supported AntiAlias Type
xSetAntiAliasType xGetMaxAntiAlias()

' set application window caption
xAppTitle "Bump-mapping sample"

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True

' hide mouse pointer
xHidePointer()

' enable antialiasing
xAntiAlias True

' create camera
camera = xCreateCamera()

' position camera
xPositionEntity camera, 0, 0, -25

' set this variable to true to use FFP DOT3 bump-mapping (for old video-cards)
Const forceFFP = False

' create cube
cube = xCreateCube()
xScaleEntity cube, 5, 5, 5
xEntityShininess cube, 1.0
xUpdateNormals cube

' load logo texture from file
diffuse = xLoadTexture("..\..\media\textures\blue_marble.jpg")
normal = xLoadTexture("..\..\media\textures\blue_marble_norm.jpg")

If forceFFP = False Then
	' texture cube
	xEntityTexture cube, diffuse, 0, 0 ' layer0 - diffuse
	xEntityTexture cube, normal, 0, 1 ' layer1 - normal-map
Else
	' texture cube
	xEntityTexture cube, diffuse, 0, 1 ' layer0 - diffuse
	xEntityTexture cube, normal, 0, 0 ' layer1 - normal-map
	
	' set DOT3 blend for FFP bump
	xTextureBlend normal, 4
	xTextureBlend diffuse, 2
EndIf

' create light
pivot = xCreatePivot()
light1 = xCreateLight(2)
xEntityParent light1, pivot
xPositionEntity light1, 0, 0, -10
sphere = xCreateSphere(12, light1)
xScaleEntity sphere, 0.1, 0.1, 0.1

If forceFFP = False Then
	' load bump shader
	bump = xLoadFXFile("..\..\media\shaders\bump.fx")
	
	' assing it to cube
	xSetEntityEffect cube, bump
	
	'set technique
	xSetEffectTechnique cube, "Bump"
EndIf

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main program loop
While Not xKeyDown(xKEY_ESCAPE)

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity camera,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity camera,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity camera, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity camera,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity camera, camya, camxa, 0.0
	
	' turn cube
	xTurnEntity pivot, 0, 1, 0
	
	If forceFFP = False Then
		' pass camera position into shader
		xSetEffectVector cube, "cameraPosition", xEntityX(camera), xEntityY(camera), xEntityZ(camera)
	EndIf
	' render scene
	xRenderWorld()
	
	' draw back buffer
	xFlip()
	
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function