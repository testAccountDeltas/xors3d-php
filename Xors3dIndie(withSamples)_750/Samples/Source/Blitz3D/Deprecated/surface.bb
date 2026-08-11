;*******************************************************************
;*                                                                 *
;* Xors3D Engine. Surface sample, (c) 2009 Xors3D Team             *
;* www: http://xors3d.com                                          *
;* e-mail: support@xors3d.com                                      *
;*                                                                 *
;*******************************************************************
Include "..\xors3d.bb"

;initialization
xAppTitle "Surface"
xGraphics3D 800, 600, 32, False, True

;setting texture filtering mode
xSetTextureFiltering TF_ANISOTROPIC

;enabling antialiasing
xAntiAlias True

;loading the texture and creating the brush
tex = xLoadTexture("../../../media/textures/radiation_box.tga")
;brush = xCreateBrush()
;xBrushTexture brush, tex

;creating the mesh and its surface
mesh = xCreateMesh()
surf = xCreateSurface(mesh, brush)

;creating 4 vertices
v0 = xAddVertex(surf, -5, -5, 0, 0, 1)
v1 = xAddVertex(surf, -5,  5, 0, 0, 0)
v2 = xAddVertex(surf,  5,  5, 0, 1, 0)
v3 = xAddVertex(surf,  5, -5, 0, 1, 1)

;creating 2 triangles
tri1 = xAddTriangle(surf, v0, v1, v2)
tri2 = xAddTriangle(surf, v3, v0, v2)

;generating the normals
xUpdateNormals mesh
xEntityTexture mesh,tex

;light source creating
light1 = xCreateLight(LIGHT_DIRECTION)
xRotateEntity light1, -45, 0, 0

;creating the camera
cam = xCreateCamera()
xMoveEntity cam, 0, 0, -15

; for mouse look
xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
mousespeed#       = 0.5 
camerasmoothness# = 4.5

;main loop
While Not xKeyDown(1)

	; camera control
	If xKeyDown(KEY_W) Then xMoveEntity cam,  0,  0,  1
	If xKeyDown(KEY_S) Then xMoveEntity cam,  0,  0, -1
	If xKeyDown(KEY_A) Then xMoveEntity cam, -1,  0,  0
	If xKeyDown(KEY_D) Then xMoveEntity cam,  1,  0,  0
	mxs# = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys# = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	camxa# = camxa - mxs Mod 360
	camya# = camya + mys
	If camya < -89 Then camya = -89
	If camya >  89 Then camya =  89
	xMoveMouse xGraphicsWidth() / 2, xGraphicsHeight() / 2
	xRotateEntity cam, camya, camxa, 0.0
	
	;updating and rendering the scene
	xUpdateWorld
	xRenderWorld
	
	;fps and traingle counters
	xText 10, 10, "FPS: " + xGetFPS()
	xText 10, 30, "TrisRendered: " + xTrisRendered()
	xText 10, 50, "Vertices: " + xCountVertices(surf)
	xText 10, 70, "Triangles: " + xCountTriangles(surf)
	
	;drawing the scene
	xFlip

Wend

; for camera mouse look
Function CurveValue#(newvalue#, oldvalue#, increments)
	If increments >  1 Then oldvalue# = oldvalue# - (oldvalue# - newvalue#) / increments 
	If increments <= 1 Then oldvalue# = newvalue# 
	Return oldvalue# 
End Function