'*******************************************************************
'*                                                                 *
'* Xors3D Engine. WireFrame posteffect sample, (c) 2010 Xors Team  *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' initialize graphics mode
xGraphics3D 800, 600, 32, False, True

' create camera
cam=xCreateCamera() 
xPositionEntity cam, 0, 10, -20
xRotateEntity cam, 10, 0, 0

' load teapot mesh
teapot = xLoadMesh("../../media/meshes/teapot.b3d")
xPositionEntity teapot, 0, 0, 5
xScaleMesh teapot, 0.3, 0.3, 0.3

' create post effect polygon
poly = xCreatePostEffectPoly(cam, 1)

' create textures
tex = xCreateTexture(800, 600)
tex2 = xCreateTexture(800, 600) 

' load post effect shader
postEffect = xLoadFXFile("../../media/shaders/WireFrame_postEffect.fx")

xSetEntityEffect poly, postEffect
xSetEffectTechnique(poly, "Diffuse")
xSetEffectMatrixSemantic poly, "MatWorldViewProj", WORLDVIEWPROJ
xSetEffectTexture poly, "tDiffuse", tex
xSetEffectTexture poly, "tEmissive", tex2

' for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

' main loop
While Not xKeyHit(1) Or xWinMessage("WM_CLOSE")

	' enable wireframe
	xWireFrame True

	' camera control
	If xKeyDown(xKEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(xKEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(xKEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(xKEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0

	' turn teaport
	xTurnEntity teapot, 0,1,0
	
	' render scene
	xEntityColor teapot, 0, 255, 0
	xRenderWorld()
	' strech BB to texture
	xStretchBackBuffer(tex, 0, 0, 800, 600, 0)
	
	' isable wireframe
	xCls
	xWireFrame False
	' render world
	xEntityColor teapot, 200, 0, 0
	xRenderWorld()
	' strech BB to texture
	xStretchBackBuffer(tex2, 0, 0, 800, 600, 0)
	
	' render post effect
	xRenderPostEffect(poly)
	xColor 255,0,0

	' draw text
	xText 40,30,"FPS: "+xGetFPS()
	xFlip
Wend

' for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function