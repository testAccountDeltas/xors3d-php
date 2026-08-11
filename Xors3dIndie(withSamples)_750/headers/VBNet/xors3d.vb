'*****************************************************************
'*                                                               *
'* Xors3d Engine header file for VB.NET, (c) 2012 XorsTeam       *
'* www:    http://xors3d.com                                     *
'* e-mail: support@xors3d.com                                    *
'*                                                               *
'*****************************************************************

Imports System.Runtime.InteropServices
Imports System.Text
Imports System

Public Module Xors3d
	' Log levels
	Public Const LOG_NO            As Integer = 5
	Public Const LOG_FATAL         As Integer = 4
	Public Const LOG_ERROR         As Integer = 3
	Public Const LOG_WARNING       As Integer = 2
	Public Const LOG_MESSAGE       As Integer = 1
	Public Const LOG_INFO          As Integer = 0

	' Log targets
	Public Const LOG_HTML             As Integer = 1
	Public Const LOG_COUT             As Integer = 2
	Public Const LOG_STRING           As Integer = 4

	' Skinning types
	Public Const SKIN_SOFTWARE As Integer = 2
	Public Const SKIN_HARDWARE As Integer = 1

	' Light sources types
	Public Const LIGHT_DIRECTIONAL As Integer = 1
	Public Const LIGHT_POINT       As Integer = 2
	Public Const LIGHT_SPOT        As Integer = 3

	' Texture filtering
	Public Const TF_NONE           As Integer = 0
	Public Const TF_POINT          As Integer = 1
	Public Const TF_LINEAR         As Integer = 2
	Public Const TF_ANISOTROPIC    As Integer = 3
	Public Const TF_ANISOTROPICX4  As Integer = 4
	Public Const TF_ANISOTROPICX8  As Integer = 5
	Public Const TF_ANISOTROPICX16 As Integer = 6

	' PixelShader versions
	Public Const PS_1_1 As Integer = 0
	Public Const PS_1_2 As Integer = 1
	Public Const PS_1_3 As Integer = 2
	Public Const PS_1_4 As Integer = 3
	Public Const PS_2_0 As Integer = 4
	Public Const PS_3_0 As Integer = 5

	' VertexShader versions
	Public Const VS_1_1 As Integer = 0
	Public Const VS_2_0 As Integer = 1
	Public Const VS_3_0 As Integer = 2

	' Matrix semantics
	Public Const WORLD                         As Integer = 0
	Public Const WORLDVIEWPROJ                 As Integer = 1
	Public Const VIEWPROJ                      As Integer = 2
	Public Const VIEW                          As Integer = 3
	Public Const PROJ                          As Integer = 4
	Public Const WORLDVIEW                     As Integer = 5
	Public Const VIEWINVERSE                   As Integer = 6
	Public Const WORLDINVERSETRANSPOSE         As Integer = 15
	Public Const WORLDINVERSE                  As Integer = 16
	Public Const WORLDTRANSPOSE                As Integer = 17
	Public Const VIEWPROJINVERSE               As Integer = 18
	Public Const VIEWPROJINVERSETRANSPOSE      As Integer = 19
	Public Const VIEWTRANSPOSE                 As Integer = 20
	Public Const VIEWINVRSETRANSPOSE           As Integer = 21
	Public Const PROJINVERSE                   As Integer = 22
	Public Const PROJTRANSPOSE                 As Integer = 23
	Public Const PROJINVRSETRANSPOSE           As Integer = 24
	Public Const WORLDVIEWPROJTRANSPOSE        As Integer = 25
	Public Const WORLDVIEWPROJINVERSE          As Integer = 26
	Public Const WORLDVIEWPROJINVERSETRANSPOSE As Integer = 27
	Public Const WORLDVIEWTRANSPOSE            As Integer = 28
	Public Const WORLDVIEWINVERSE              As Integer = 29
	Public Const WORLDVIEWINVERSETRANSPOSE     As Integer = 30

	' Antialiasing types
	Public Const AANONE      As Integer = 0
	Public Const AA2SAMPLES  As Integer = 1
	Public Const AA3SAMPLES  As Integer = 2
	Public Const AA4SAMPLES  As Integer = 3
	Public Const AA5SAMPLES  As Integer = 4
	Public Const AA6SAMPLES  As Integer = 5
	Public Const AA7SAMPLES  As Integer = 6
	Public Const AA8SAMPLES  As Integer = 7
	Public Const AA9SAMPLES  As Integer = 8
	Public Const AA10SAMPLES As Integer = 9
	Public Const AA11SAMPLES As Integer = 10
	Public Const AA12SAMPLES As Integer = 11
	Public Const AA13SAMPLES As Integer = 12
	Public Const AA14SAMPLES As Integer = 13
	Public Const AA15SAMPLES As Integer = 14
	Public Const AA16SAMPLES As Integer = 15

	' Camera fog mode
	Public Const FOG_NONE     As Integer = 0
	Public Const FOG_LINEAR   As Integer = 1

	' Camera projection mode
	Public Const PROJ_DISABLE      As Integer = 0
	Public Const PROJ_PERSPECTIVE	As Integer = 1
	Public Const PROJ_ORTHOGRAPHIC As Integer = 2

	' Entity FX flags
	Public Const FX_NOTHING        As Integer = 0
	Public Const FX_FULLBRIGHT     As Integer = 1
	Public Const FX_VERTEXCOLOR    As Integer = 2
	Public Const FX_FLATSHADED     As Integer = 4
	Public Const FX_DISABLEFOG     As Integer = 8
	Public Const FX_DISABLECULLING As Integer = 16
	Public Const FX_NOALPHABLEND   As Integer = 32

	' Entity blending modes
	Public Const BLEND_ALPHA       As Integer = 1
	Public Const BLEND_MULTIPLY    As Integer = 2
	Public Const BLEND_ADD         As Integer = 3
	Public Const BLEND_PUREADD     As Integer = 4

	' Compare functions
	Public Const CMP_NEVER         As Integer = 1
	Public Const CMP_LESS          As Integer = 2
	Public Const CMP_EQUAL         As Integer = 3
	Public Const CMP_LESSEQUAL     As Integer = 4
	Public Const CMP_GREATER       As Integer = 5
	Public Const CMP_NOTEQUAL      As Integer = 6
	Public Const CMP_GREATEREQUAL  As Integer = 7
	Public Const CMP_ALWAYS        As Integer = 8

	' Axis
	Public Const AXIS_X    As Integer = 1
	Public Const AXIS_Y    As Integer = 2
	Public Const AXIS_Z    As Integer = 3

	' Texture loading flags
	Public Const FLAGS_COLOR             As Integer = 1
	Public Const FLAGS_ALPHA             As Integer = 2
	Public Const FLAGS_MASKED            As Integer = 4
	Public Const FLAGS_MIPMAPPED         As Integer = 8
	Public Const FLAGS_CLAMPU            As Integer = 16
	Public Const FLAGS_CLAMPV            As Integer = 32
	Public Const FLAGS_SPHERICALENVMAP   As Integer = 64
	Public Const FLAGS_CUBICENVMAP       As Integer = 128
	Public Const FLAGS_R32F              As Integer = 256
	Public Const FLAGS_SKIPCACHE         As Integer = 512
	Public Const FLAGS_VOLUMETEXTURE     As Integer = 1024
	Public Const FLAGS_ARBG16F           As Integer = 2048
	Public Const FLAGS_ARBG32F           As Integer = 4096

	' Texture blending modes
	Public Const TEXBLEND_NONE          As Integer = 0
	Public Const TEXBLEND_ALPHA         As Integer = 1
	Public Const TEXBLEND_MULTIPLY      As Integer = 2
	Public Const TEXBLEND_ADD           As Integer = 3
	Public Const TEXBLEND_DOT3          As Integer = 4
	Public Const TEXBLEND_LIGHTMAP      As Integer = 5
	Public Const TEXBLEND_SEPARATEALPHA As Integer = 6

	' Cube map faces
	Public Const FACE_LEFT     As Integer = 0
	Public Const FACE_FORWARD  As Integer = 1
	Public Const FACE_RIGHT    As Integer = 2
	Public Const FACE_BACKWARD As Integer = 3
	Public Const FACE_UP       As Integer = 4
	Public Const FACE_DOWN     As Integer = 5

	' Entity animation types
	Public Const ANIMATION_STOP      As Integer = 0
	Public Const ANIMATION_LOOP      As Integer = 1
	Public Const ANIMATION_PINGPONG  As Integer = 2
	Public Const ANIMATION_ONE       As Integer = 3

	' Collision types
	Public Const SPHERETOSPHERE  As Integer = 1
	Public Const SPHERETOBOX     As Integer = 3
	Public Const SPHERETOTRIMESH As Integer = 2

	' Collision respones types
	Public Const RESPONSE_STOP             As Integer = 1
	Public Const RESPONSE_SLIDING          As Integer = 2
	Public Const RESPONSE_SLIDING_DOWNLOCK As Integer = 3

	' Entity picking modes
	Public Const PICK_NONE     As Integer = 0
	Public Const PICK_SPHERE   As Integer = 1
	Public Const PICK_TRIMESH  As Integer = 2
	Public Const PICK_BOX      As Integer = 3

	' Sprite view modes
	Public Const SPRITE_FIXED    As Integer = 1
	Public Const SPRITE_FREE     As Integer = 2
	Public Const SPRITE_FREEROLL As Integer = 3
	Public Const SPRITE_FIXEDYAW As Integer = 4

	' Joystick types
	Public Const JOY_NONE    As Integer = 0
	Public Const JOY_DIGITAL As Integer = 1
	Public Const JOY_ANALOG  As Integer = 2

	' Cubemap rendering modes
	Public Const CUBEMAP_SPECULAR   As Integer = 1
	Public Const CUBEMAP_DIFFUSE    As Integer = 2
	Public Const CUBEMAP_REFRACTION As Integer = 3

	' Shadow's blur levels
	Public Const SHADOWS_BLUR_NONE As Integer = 0
	Public Const SHADOWS_BLUR_3    As Integer = 1
	Public Const SHADOWS_BLUR_5    As Integer = 2
	Public Const SHADOWS_BLUR_7    As Integer = 3
	Public Const SHADOWS_BLUR_11   As Integer = 4
	Public Const SHADOWS_BLUR_13   As Integer = 5

	' primitives types
	Public Const PRIMITIVE_POINTLIST     As Integer = 1
	Public Const PRIMITIVE_LINELIST      As Integer = 2
	Public Const PRIMITIVE_LINESTRIP     As Integer = 3
	Public Const PRIMITIVE_TRIANGLELIST  As Integer = 4
	Public Const PRIMITIVE_TRIANGLESTRIP As Integer = 5
	Public Const PRIMITIVE_TRIANGLEFAN   As Integer = 6
	
	' line separator types
	Public Const LS_NUL		As Integer = 0
	Public Const LS_CR		As Integer = 1
	Public Const LS_LF		As Integer = 2
	Public Const LS_CRLF	As Integer = 3
	
	' physics: jotypes
	Public Const JOINT_POINT2POINT	As Integer = 0
	Public Const JOINT_6DOF			As Integer = 1
	Public Const JOINT_6DOFSPRING	As Integer = 2
	Public Const JOINT_HINGE		As Integer = 3
	
	' physics: debug drawer modes
	Public Const PXDD_NO           As Integer = 0
	Public Const PXDD_WIREFRAME    As Integer = 1
	Public Const PXDD_AABB         As Integer = 2
	Public Const PXDD_CONTACTS     As Integer = 4
	Public Const PXDD_JOINTS       As Integer = 8
	Public Const PXDD_JOINT_LIMITS As Integer = 16
	Public Const PXDD_NO_AXIS      As Integer = 32;

	' physics: ray casting modes
	Public Const PXRC_SINGLE   As Integer = 0
	Public Const PXRC_MULTIPLE As Integer = 1

	' 3dlines commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateLine3D(ByVal fromX As Single, ByVal fromY As Single, ByVal fromZ As Single, ByVal toX As Single, ByVal toY As Single, ByVal toZ As Single, Optional ByVal red As Integer = 255, Optional ByVal green As Integer = 255, Optional ByVal blue As Integer = 255, Optional ByVal alpha As Integer = 255, Optional ByVal useZBuffer As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLine3DOrigin(ByVal line3d As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLine3DAddNode(ByVal line3d As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLine3DColor(ByVal line3d As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, ByVal alpha As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLine3DUseZBuffer(ByVal line3d As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xLine3DOriginX(ByVal line3d As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DOriginY(ByVal line3d As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DOriginZ(ByVal line3d As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DNodesCount(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLine3DNodePosition(ByVal line3d As Integer, ByVal index As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xLine3DNodeX(ByVal line3d As Integer, ByVal index As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DNodeY(ByVal line3d As Integer, ByVal index As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DNodeZ(ByVal line3d As Integer, ByVal index As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DRed(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DGreen(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DBlue(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xLine3DAlpha(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetLine3DUseZBuffer(ByVal line3d As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteLine3DNode(ByVal line3d As Integer, ByVal index As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearLine3D(ByVal line3d As Integer)
	End Sub


	' brushes commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadBrush")> _
	Public Function xLoadBrush_(ByVal path As StringBuilder, ByVal flags As Integer, ByVal xScale As Single, ByVal yScale As Single) As Integer
	End Function
	Public Function xLoadBrush(ByVal path As String, Optional ByVal flags As Integer = 9, Optional ByVal xScale As Single = 1.0, Optional ByVal yScale As Single = 1.0) As Integer
		Return xLoadBrush_(new StringBuilder(path), flags, xScale, yScale)
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateBrush(Optional ByVal red As Single = 255.0, Optional ByVal green As Single = 255.0, Optional ByVal blue As Single = 255.0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeBrush(ByVal brush As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushTexture(ByVal brush As Integer, Optional ByVal index As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xBrushColor(ByVal brush As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xBrushAlpha(ByVal brush As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xBrushShininess(ByVal brush As Integer, ByVal shininess As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xBrushBlend(ByVal brush As Integer, ByVal blend As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xBrushFX(ByVal brush As Integer, ByVal FX As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xBrushTexture(ByVal brush As Integer, ByVal texture As Integer, Optional ByVal frame As Integer = 0, Optional ByVal index As Integer = 0)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xGetBrushName")> _
	Public Function xGetBrushName_(ByVal brush As Integer) As IntPtr
	End Function
	Public Function xGetBrushName(ByVal brush As Integer) As String
		Return Marshal.PtrToStringAnsi(xGetBrushName_(brush))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xBrushName")> _
	Public Sub xBrushName_(ByVal brush As Integer, ByVal name As StringBuilder)
	End Sub
	Public Sub xBrushName(ByVal brush As Integer, ByVal name As String)
		xBrushName_(brush, new StringBuilder(name))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushAlpha(ByVal brush As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushBlend(ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushRed(ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushGreen(ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushBlue(ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushFX(ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetBrushShininess(ByVal brush As Integer) As Single
	End Function


	' cameras commands
	<DllImport("xors3d.dll")> _
	Public Sub xCameraFogMode(ByVal camera As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraFogColor(ByVal camera As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraFogRange(ByVal camera As Integer, ByVal nearRange As Single, ByVal farRange As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraClsColor(ByVal camera As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal alpha As Integer = 255)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraProjMode(ByVal camera As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraClsMode(ByVal camera As Integer, ByVal clearColor As Integer, ByVal clearZBuffer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xSphereInFrustum(ByVal camera As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal radii As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCameraClipPlane(ByVal camera As Integer, ByVal index As Integer, ByVal enabled As Integer, ByVal a As Single, ByVal b As Single, ByVal c As Single, ByVal d As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraRange(ByVal camera As Integer, ByVal nearRange As Single, ByVal farRange As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraViewport(ByVal camera As Integer, ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraCropViewport(ByVal camera As Integer, ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCreateCamera(Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCameraProject(ByVal camera As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraProject2D(ByVal camera As Integer, ByVal x As Integer, ByVal y As Integer, ByVal zDistance As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xProjectedX() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xProjectedY() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xProjectedZ() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetViewMatrix(ByVal camera As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetProjectionMatrix(ByVal camera As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCameraZoom(ByVal camera As Integer, ByVal zoom As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetViewProjMatrix(ByVal camera As Integer) As Integer
	End Function


	' collisions commands
	<DllImport("xors3d.dll")> _
	Public Sub xCollisions(ByVal srcType As Integer, ByVal destType As Integer, ByVal collideMethod As Integer, ByVal response As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearCollisions()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xResetEntity(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityRadius(ByVal entity As Integer, ByVal xRadius As Single, Optional ByVal yRadius As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityBox(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal width As Single, ByVal height As Single, ByVal depth As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityType(ByVal entity As Integer, ByVal typeID As Integer, Optional ByVal recurse As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityCollided(ByVal entity As Integer, ByVal typeID As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCountCollisions(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionX(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionY(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionZ(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionNX(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionNY(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionNZ(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionTime(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionEntity(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionSurface(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCollisionTriangle(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityType(ByVal entity As Integer) As Integer
	End Function


	' constants commands
	<DllImport("xors3d.dll")> _
	Public Sub xRenderPostEffect(ByVal poly As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCreatePostEffectPoly(ByVal camera As Integer, ByVal mode As Integer) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xGetFunctionAddress")> _
	Public Function xGetFunctionAddress_(ByVal name As StringBuilder) As Integer
	End Function
	Public Function xGetFunctionAddress(ByVal name As String) As Integer
		Return xGetFunctionAddress_(new StringBuilder(name))
	End Function


	' effects commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadFXFile")> _
	Public Function xLoadFXFile_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadFXFile(ByVal path As String) As Integer
		Return xLoadFXFile_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeEffect(ByVal effect As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetEntityEffect(ByVal entity As Integer, ByVal effect As Integer, Optional ByVal index As Integer = -1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetSurfaceEffect(ByVal surface As Integer, ByVal effect As Integer, Optional ByVal index As Integer = -1)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetBonesArrayName")> _
	Public Sub xSetBonesArrayName_(ByVal entity As Integer, ByVal arrayName As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xSetBonesArrayName(ByVal entity As Integer, ByVal arrayName As String, Optional ByVal layer As Integer = -1)
		xSetBonesArrayName_(entity, new StringBuilder(arrayName), layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceBonesArrayName")> _
	Public Sub xSurfaceBonesArrayName_(ByVal surface As Integer, ByVal arrayName As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceBonesArrayName(ByVal surface As Integer, ByVal arrayName As String, Optional ByVal layer As Integer = -1)
		xSurfaceBonesArrayName_(surface, new StringBuilder(arrayName), layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectInt")> _
	Public Sub xSetEffectInt_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectInt(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectInt_(entity, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectInt")> _
	Public Sub xSurfaceEffectInt_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectInt(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectInt_(surface, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectFloat")> _
	Public Sub xSetEffectFloat_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectFloat(ByVal entity As Integer, ByVal name As String, ByVal value As Single, Optional ByVal layer As Integer = -1)
		xSetEffectFloat_(entity, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectFloat")> _
	Public Sub xSurfaceEffectFloat_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectFloat(ByVal surface As Integer, ByVal name As String, ByVal value As Single, Optional ByVal layer As Integer = -1)
		xSurfaceEffectFloat_(surface, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectBool")> _
	Public Sub xSetEffectBool_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectBool(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectBool_(entity, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectBool")> _
	Public Sub xSurfaceEffectBool_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectBool(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectBool_(surface, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectVector")> _
	Public Sub xSetEffectVector_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectVector(ByVal entity As Integer, ByVal name As String, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal w As Single = 0.0, Optional ByVal layer As Integer = -1)
		xSetEffectVector_(entity, new StringBuilder(name), x, y, z, w, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectVector")> _
	Public Sub xSurfaceEffectVector_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectVector(ByVal surface As Integer, ByVal name As String, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal w As Single = 0.0, Optional ByVal layer As Integer = -1)
		xSurfaceEffectVector_(surface, new StringBuilder(name), x, y, z, w, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectVectorArray")> _
	Public Sub xSetEffectVectorArray_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectVectorArray(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectVectorArray_(entity, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectVectorArray")> _
	Public Sub xSurfaceEffectVectorArray_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectVectorArray(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectVectorArray_(surface, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectMatrixArray")> _
	Public Sub xSurfaceEffectMatrixArray_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectMatrixArray(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectMatrixArray_(surface, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectFloatArray")> _
	Public Sub xSurfaceEffectFloatArray_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectFloatArray(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectFloatArray_(surface, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectIntArray")> _
	Public Sub xSurfaceEffectIntArray_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectIntArray(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectIntArray_(surface, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectMatrixArray")> _
	Public Sub xSetEffectMatrixArray_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectMatrixArray(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectMatrixArray_(entity, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectFloatArray")> _
	Public Sub xSetEffectFloatArray_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectFloatArray(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectFloatArray_(entity, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectIntArray")> _
	Public Sub xSetEffectIntArray_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectIntArray(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectIntArray_(entity, new StringBuilder(name), value, count, layer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCreateBufferVectors(ByVal count As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xBufferVectorsSetElement(ByVal buffer As Integer, ByVal number As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCreateBufferMatrix(ByVal count As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xBufferMatrixSetElement(ByVal buffer As Integer, ByVal number As Integer, ByVal matrix As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xBufferMatrixGetElement(ByVal buffer As Integer, ByVal number As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateBufferFloats(ByVal count As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xBufferFloatsSetElement(ByVal buffer As Integer, ByVal number As Integer, ByVal value As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xBufferFloatsGetElement(ByVal buffer As Integer, ByVal number As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xBufferDelete(ByVal buffer As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectMatrixWithElements")> _
	Public Sub xSetEffectMatrixWithElements_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal m11 As Single, ByVal m12 As Single, ByVal m13 As Single, ByVal m14 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal m23 As Single, ByVal m24 As Single, ByVal m31 As Single, ByVal m32 As Single, ByVal m33 As Single, ByVal m34 As Single, ByVal m41 As Single, ByVal m42 As Single, ByVal m43 As Single, ByVal m44 As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectMatrixWithElements(ByVal entity As Integer, ByVal name As String, ByVal m11 As Single, ByVal m12 As Single, ByVal m13 As Single, ByVal m14 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal m23 As Single, ByVal m24 As Single, ByVal m31 As Single, ByVal m32 As Single, ByVal m33 As Single, ByVal m34 As Single, ByVal m41 As Single, ByVal m42 As Single, ByVal m43 As Single, ByVal m44 As Single, Optional ByVal layer As Integer = -1)
		xSetEffectMatrixWithElements_(entity, new StringBuilder(name), m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectMatrix")> _
	Public Sub xSetEffectMatrix_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal matrix As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectMatrix(ByVal entity As Integer, ByVal name As String, ByVal matrix As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectMatrix_(entity, new StringBuilder(name), matrix, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectMatrix")> _
	Public Sub xSurfaceEffectMatrix_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal matrix As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectMatrix(ByVal surface As Integer, ByVal name As String, ByVal matrix As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectMatrix_(surface, new StringBuilder(name), matrix, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectMatrixWithElements")> _
	Public Sub xSurfaceEffectMatrixWithElements_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal m11 As Single, ByVal m12 As Single, ByVal m13 As Single, ByVal m14 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal m23 As Single, ByVal m24 As Single, ByVal m31 As Single, ByVal m32 As Single, ByVal m33 As Single, ByVal m34 As Single, ByVal m41 As Single, ByVal m42 As Single, ByVal m43 As Single, ByVal m44 As Single, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectMatrixWithElements(ByVal surface As Integer, ByVal name As String, ByVal m11 As Single, ByVal m12 As Single, ByVal m13 As Single, ByVal m14 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal m23 As Single, ByVal m24 As Single, ByVal m31 As Single, ByVal m32 As Single, ByVal m33 As Single, ByVal m34 As Single, ByVal m41 As Single, ByVal m42 As Single, ByVal m43 As Single, ByVal m44 As Single, Optional ByVal layer As Integer = -1)
		xSurfaceEffectMatrixWithElements_(surface, new StringBuilder(name), m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectEntityTexture")> _
	Public Sub xSetEffectEntityTexture_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal index As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectEntityTexture(ByVal entity As Integer, ByVal name As String, Optional ByVal index As Integer = 0, Optional ByVal layer As Integer = -1)
		xSetEffectEntityTexture_(entity, new StringBuilder(name), index, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectTexture")> _
	Public Sub xSetEffectTexture_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal texture As Integer, ByVal frame As Integer, ByVal layer As Integer, ByVal isRecursive As Integer)
	End Sub
	Public Sub xSetEffectTexture(ByVal entity As Integer, ByVal name As String, ByVal texture As Integer, Optional ByVal frame As Integer = 0, Optional ByVal layer As Integer = -1, Optional ByVal isRecursive As Integer = 1)
		xSetEffectTexture_(entity, new StringBuilder(name), texture, frame, layer, isRecursive)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectTexture")> _
	Public Sub xSurfaceEffectTexture_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal texture As Integer, ByVal frame As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectTexture(ByVal surface As Integer, ByVal name As String, ByVal texture As Integer, Optional ByVal frame As Integer = 0, Optional ByVal layer As Integer = -1)
		xSurfaceEffectTexture_(surface, new StringBuilder(name), texture, frame, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceEffectMatrixSemantic")> _
	Public Sub xSurfaceEffectMatrixSemantic_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceEffectMatrixSemantic(ByVal surface As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSurfaceEffectMatrixSemantic_(surface, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectMatrixSemantic")> _
	Public Sub xSetEffectMatrixSemantic_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectMatrixSemantic(ByVal entity As Integer, ByVal name As String, ByVal value As Integer, Optional ByVal layer As Integer = -1)
		xSetEffectMatrixSemantic_(entity, new StringBuilder(name), value, layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xDeleteSurfaceConstant")> _
	Public Sub xDeleteSurfaceConstant_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xDeleteSurfaceConstant(ByVal surface As Integer, ByVal name As String, Optional ByVal layer As Integer = -1)
		xDeleteSurfaceConstant_(surface, new StringBuilder(name), layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xDeleteEffectConstant")> _
	Public Sub xDeleteEffectConstant_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xDeleteEffectConstant(ByVal entity As Integer, ByVal name As String, Optional ByVal layer As Integer = -1)
		xDeleteEffectConstant_(entity, new StringBuilder(name), layer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearSurfaceConstants(ByVal surface As Integer, Optional ByVal layer As Integer = -1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearEffectConstants(ByVal entity As Integer, Optional ByVal layer As Integer = -1)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEffectTechnique")> _
	Public Sub xSetEffectTechnique_(ByVal entity As Integer, ByVal name As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xSetEffectTechnique(ByVal entity As Integer, ByVal name As String, Optional ByVal layer As Integer = -1)
		xSetEffectTechnique_(entity, new StringBuilder(name), layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSurfaceTechnique")> _
	Public Sub xSurfaceTechnique_(ByVal surface As Integer, ByVal name As StringBuilder, ByVal layer As Integer)
	End Sub
	Public Sub xSurfaceTechnique(ByVal surface As Integer, ByVal name As String, Optional ByVal layer As Integer = -1)
		xSurfaceTechnique_(surface, new StringBuilder(name), layer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xValidateEffectTechnique")> _
	Public Function xValidateEffectTechnique_(ByVal effect As Integer, ByVal name As StringBuilder) As Integer
	End Function
	Public Function xValidateEffectTechnique(ByVal effect As Integer, ByVal name As String) As Integer
		Return xValidateEffectTechnique_(effect, new StringBuilder(name))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetEntityShaderLayer(ByVal entity As Integer, ByVal layer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityShaderLayer(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetSurfaceShaderLayer(ByVal surface As Integer, ByVal layer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetSurfaceShaderLayer(ByVal surface As Integer) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xSetFXInt")> _
	Public Sub xSetFXInt_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer)
	End Sub
	Public Sub xSetFXInt(ByVal effect As Integer, ByVal name As String, ByVal value As Integer)
		xSetFXInt_(effect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXFloat")> _
	Public Sub xSetFXFloat_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Single)
	End Sub
	Public Sub xSetFXFloat(ByVal effect As Integer, ByVal name As String, ByVal value As Single)
		xSetFXFloat_(effect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXBool")> _
	Public Sub xSetFXBool_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer)
	End Sub
	Public Sub xSetFXBool(ByVal effect As Integer, ByVal name As String, ByVal value As Integer)
		xSetFXBool_(effect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXVector")> _
	Public Sub xSetFXVector_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single)
	End Sub
	Public Sub xSetFXVector(ByVal effect As Integer, ByVal name As String, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal w As Single = 0.0)
		xSetFXVector_(effect, new StringBuilder(name), x, y, z, w)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXVectorArray")> _
	Public Sub xSetFXVectorArray_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer)
	End Sub
	Public Sub xSetFXVectorArray(ByVal effect As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer)
		xSetFXVectorArray_(effect, new StringBuilder(name), value, count)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXMatrixArray")> _
	Public Sub xSetFXMatrixArray_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer)
	End Sub
	Public Sub xSetFXMatrixArray(ByVal effect As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer)
		xSetFXMatrixArray_(effect, new StringBuilder(name), value, count)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXFloatArray")> _
	Public Sub xSetFXFloatArray_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer)
	End Sub
	Public Sub xSetFXFloatArray(ByVal effect As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer)
		xSetFXFloatArray_(effect, new StringBuilder(name), value, count)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXIntArray")> _
	Public Sub xSetFXIntArray_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer, ByVal count As Integer)
	End Sub
	Public Sub xSetFXIntArray(ByVal effect As Integer, ByVal name As String, ByVal value As Integer, ByVal count As Integer)
		xSetFXIntArray_(effect, new StringBuilder(name), value, count)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXEntityMatrix")> _
	Public Sub xSetFXEntityMatrix_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal matrix As Integer)
	End Sub
	Public Sub xSetFXEntityMatrix(ByVal effect As Integer, ByVal name As String, ByVal matrix As Integer)
		xSetFXEntityMatrix_(effect, new StringBuilder(name), matrix)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXTexture")> _
	Public Sub xSetFXTexture_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal texture As Integer, ByVal frame As Integer)
	End Sub
	Public Sub xSetFXTexture(ByVal effect As Integer, ByVal name As String, ByVal texture As Integer, Optional ByVal frame As Integer = 0)
		xSetFXTexture_(effect, new StringBuilder(name), texture, frame)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXMatrixSemantic")> _
	Public Sub xSetFXMatrixSemantic_(ByVal effect As Integer, ByVal name As StringBuilder, ByVal value As Integer)
	End Sub
	Public Sub xSetFXMatrixSemantic(ByVal effect As Integer, ByVal name As String, ByVal value As Integer)
		xSetFXMatrixSemantic_(effect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xDeleteFXConstant")> _
	Public Sub xDeleteFXConstant_(ByVal effect As Integer, ByVal name As StringBuilder)
	End Sub
	Public Sub xDeleteFXConstant(ByVal effect As Integer, ByVal name As String)
		xDeleteFXConstant_(effect, new StringBuilder(name))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearFXConstants(ByVal effect As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetFXTechnique")> _
	Public Sub xSetFXTechnique_(ByVal effect As Integer, ByVal name As StringBuilder)
	End Sub
	Public Sub xSetFXTechnique(ByVal effect As Integer, ByVal name As String)
		xSetFXTechnique_(effect, new StringBuilder(name))
	End Sub


	' emitters commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateEmitter(ByVal psystem As Integer, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEmitterEnable(ByVal emitter As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEmitterEnabled(ByVal emitter As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitterGetPSystem(ByVal emitter As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitterAddParticle(ByVal emitter As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEmitterFreeParticle(ByVal emitter As Integer, ByVal particle As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEmitterValidateParticle(ByVal emitter As Integer, ByVal particle As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitterCountParticles(ByVal emitter As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitterGetParticle(ByVal emitter As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitterAlive(ByVal emitter As Integer) As Integer
	End Function


	' entity_animation commands
	<DllImport("xors3d.dll")> _
	Public Function xExtractAnimSeq(ByVal entity As Integer, ByVal firstFrame As Integer, ByVal lastFrame As Integer, Optional ByVal sequence As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadAnimSeq")> _
	Public Function xLoadAnimSeq_(ByVal entity As Integer, ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadAnimSeq(ByVal entity As Integer, ByVal path As String) As Integer
		Return xLoadAnimSeq_(entity, new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xSetAnimSpeed")> _
	Public Sub xSetAnimSpeed_(ByVal entity As Integer, ByVal speed As Single, ByVal rootBone As StringBuilder)
	End Sub
	Public Sub xSetAnimSpeed(ByVal entity As Integer, ByVal speed As Single, Optional ByVal rootBone As String = "")
		xSetAnimSpeed_(entity, speed, new StringBuilder(rootBone))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xAnimSpeed")> _
	Public Function xAnimSpeed_(ByVal entity As Integer, ByVal rootBone As StringBuilder) As Single
	End Function
	Public Function xAnimSpeed(ByVal entity As Integer, Optional ByVal rootBone As String = "") As Single
		Return xAnimSpeed_(entity, new StringBuilder(rootBone))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xAnimating")> _
	Public Function xAnimating_(ByVal entity As Integer, ByVal rootBone As StringBuilder) As Integer
	End Function
	Public Function xAnimating(ByVal entity As Integer, Optional ByVal rootBone As String = "") As Integer
		Return xAnimating_(entity, new StringBuilder(rootBone))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xAnimTime")> _
	Public Function xAnimTime_(ByVal entity As Integer, ByVal rootBone As StringBuilder) As Single
	End Function
	Public Function xAnimTime(ByVal entity As Integer, Optional ByVal rootBone As String = "") As Single
		Return xAnimTime_(entity, new StringBuilder(rootBone))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xAnimate")> _
	Public Sub xAnimate_(ByVal entity As Integer, ByVal mode As Integer, ByVal speed As Single, ByVal sequence As Integer, ByVal translate As Single, ByVal rootBone As StringBuilder)
	End Sub
	Public Sub xAnimate(ByVal entity As Integer, Optional ByVal mode As Integer = 1, Optional ByVal speed As Single = 1.0, Optional ByVal sequence As Integer = 0, Optional ByVal translate As Single = 0.0, Optional ByVal rootBone As String = "")
		xAnimate_(entity, mode, speed, sequence, translate, new StringBuilder(rootBone))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xAnimSeq")> _
	Public Function xAnimSeq_(ByVal entity As Integer, ByVal rootBone As StringBuilder) As Integer
	End Function
	Public Function xAnimSeq(ByVal entity As Integer, Optional ByVal rootBone As String = "") As Integer
		Return xAnimSeq_(entity, new StringBuilder(rootBone))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xAnimLength")> _
	Public Function xAnimLength_(ByVal entity As Integer, ByVal rootBone As StringBuilder) As Single
	End Function
	Public Function xAnimLength(ByVal entity As Integer, Optional ByVal rootBone As String = "") As Single
		Return xAnimLength_(entity, new StringBuilder(rootBone))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xSetAnimTime")> _
	Public Sub xSetAnimTime_(ByVal entity As Integer, ByVal time As Single, ByVal sequence As Integer, ByVal rootBone As StringBuilder)
	End Sub
	Public Sub xSetAnimTime(ByVal entity As Integer, ByVal time As Single, ByVal sequence As Integer, Optional ByVal rootBone As String = "")
		xSetAnimTime_(entity, time, sequence, new StringBuilder(rootBone))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetAnimFrame")> _
	Public Sub xSetAnimFrame_(ByVal entity As Integer, ByVal frame As Single, ByVal sequence As Integer, ByVal rootBone As StringBuilder)
	End Sub
	Public Sub xSetAnimFrame(ByVal entity As Integer, ByVal frame As Single, ByVal sequence As Integer, Optional ByVal rootBone As String = "")
		xSetAnimFrame_(entity, frame, sequence, new StringBuilder(rootBone))
	End Sub


	' entity_control commands
	<DllImport("xors3d.dll")> _
	Public Sub xEntityAutoFade(ByVal entity As Integer, ByVal nearRange As Single, ByVal farRange As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityOrder(ByVal entity As Integer, ByVal order As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFreeEntity(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCopyEntity(ByVal entity As Integer, Optional ByVal parent As Integer = 0, Optional ByVal cloneBuffers As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPaintEntity(ByVal entity As Integer, ByVal brush As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityShininess(ByVal entity As Integer, ByVal shininess As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityPickMode(ByVal entity As Integer, ByVal mode As Integer, Optional ByVal obscurer As Integer = 1, Optional ByVal recursive As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityTexture(ByVal entity As Integer, ByVal texture As Integer, Optional ByVal frame As Integer = 0, Optional ByVal index As Integer = 0, Optional ByVal isRecursive As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityFX(ByVal entity As Integer, ByVal fx As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetParent(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetFrustumSphere(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal radii As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCalculateFrustumVolume(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityParent(ByVal entity As Integer, Optional ByVal parent As Integer = 0, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xShowEntity(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xHideEntity(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xNameEntity")> _
	Public Sub xNameEntity_(ByVal entity As Integer, ByVal name As StringBuilder)
	End Sub
	Public Sub xNameEntity(ByVal entity As Integer, ByVal name As String)
		xNameEntity_(entity, new StringBuilder(name))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetEntityQuaternion(ByVal entity As Integer, ByVal quaternion As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetEntityMatrix(ByVal entity As Integer, ByVal matrix As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAlpha(ByVal entity As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityColor(ByVal entity As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySpecularColor(ByVal entity As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAmbientColor(ByVal entity As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityEmissiveColor(ByVal entity As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityBlend(ByVal entity As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAlphaRef(ByVal entity As Integer, ByVal value As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAlphaFunc(ByVal entity As Integer, ByVal value As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCreateInstance(ByVal entity As Integer, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreezeInstances(ByVal entity As Integer, Optional ByVal enable As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xInstancingAvaliable() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityWorld(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetEntityWorld(ByVal entity As Integer, ByVal world As Integer)
	End Sub


	' entity_movement commands
	<DllImport("xors3d.dll")> _
	Public Sub xScaleEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPositionEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xMoveEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTranslateEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRotateEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTurnEntity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPointEntity(ByVal entity1 As Integer, ByVal entity2 As Integer, Optional ByVal roll As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xAlignToVector(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal axis As Integer, Optional ByVal factor As Single = 1.0)
	End Sub


	' entity_state commands
	<DllImport("xors3d.dll")> _
	Public Function xEntityDistance(ByVal entity1 As Integer, ByVal entity2 As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMatElement(ByVal entity As Integer, ByVal row As Integer, ByVal col As Integer) As Single
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xEntityClass")> _
	Public Function xEntityClass_(ByVal entity As Integer) As IntPtr
	End Function
	Public Function xEntityClass(ByVal entity As Integer) As String
		Return Marshal.PtrToStringAnsi(xEntityClass_(entity))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityBrush(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityX(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityY(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityZ(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityVisible(ByVal entity As Integer, ByVal destination As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityScaleX(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityScaleY(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityScaleZ(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityRoll(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityYaw(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityPitch(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xEntityName")> _
	Public Function xEntityName_(ByVal entity As Integer) As IntPtr
	End Function
	Public Function xEntityName(ByVal entity As Integer) As String
		Return Marshal.PtrToStringAnsi(xEntityName_(entity))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCountChildren(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetChild(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityInView(ByVal entity As Integer, ByVal camera As Integer) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFindChild")> _
	Public Function xFindChild_(ByVal entity As Integer, ByVal name As StringBuilder) As Integer
	End Function
	Public Function xFindChild(ByVal entity As Integer, ByVal name As String) As Integer
		Return xFindChild_(entity, new StringBuilder(name))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityMatrix(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityAlpha(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAlphaRef(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAlphaFunc(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityRed(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGreen(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityBlue(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityShininess(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityBlend(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetEntityFX(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityHidden(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntitiesBBIntersect(ByVal entity1 As Integer, ByVal entity2 As Integer) As Integer
	End Function


	' filesystems commands
	<DllImport("xors3d.dll", EntryPoint := "xMountPackFile")> _
	Public Function xMountPackFile_(ByVal path As StringBuilder, ByVal mountpoint As StringBuilder, ByVal password As StringBuilder) As Integer
	End Function
	Public Function xMountPackFile(ByVal path As String, Optional ByVal mountpoint As String = "", Optional ByVal password As String = "") As Integer
		Return xMountPackFile_(new StringBuilder(path), new StringBuilder(mountpoint), new StringBuilder(password))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xUnmountPackFile(ByVal packfile As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xOpenFile")> _
	Public Function xOpenFile_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xOpenFile(ByVal path As String) As Integer
		Return xOpenFile_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xReadFile")> _
	Public Function xReadFile_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xReadFile(ByVal path As String) As Integer
		Return xReadFile_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xWriteFile")> _
	Public Function xWriteFile_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xWriteFile(ByVal path As String) As Integer
		Return xWriteFile_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCloseFile(ByVal file As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xFilePos(ByVal file As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSeekFile(ByVal file As Integer, ByVal offset As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xFileType")> _
	Public Function xFileType_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xFileType(ByVal path As String) As Integer
		Return xFileType_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFileSize")> _
	Public Function xFileSize_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xFileSize(ByVal path As String) As Integer
		Return xFileSize_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFileCreationTime")> _
	Public Function xFileCreationTime_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xFileCreationTime(ByVal path As String) As Integer
		Return xFileCreationTime_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFileCreationTimeStr")> _
	Public Function xFileCreationTimeStr_(ByVal path As StringBuilder) As IntPtr
	End Function
	Public Function xFileCreationTimeStr(ByVal path As String) As String
		Return Marshal.PtrToStringAnsi(xFileCreationTimeStr_(new StringBuilder(path)))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFileModificationTime")> _
	Public Function xFileModificationTime_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xFileModificationTime(ByVal path As String) As Integer
		Return xFileModificationTime_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xFileModificationTimeStr")> _
	Public Function xFileModificationTimeStr_(ByVal path As StringBuilder) As IntPtr
	End Function
	Public Function xFileModificationTimeStr(ByVal path As String) As String
		Return Marshal.PtrToStringAnsi(xFileModificationTimeStr_(new StringBuilder(path)))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xReadDir")> _
	Public Function xReadDir_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xReadDir(ByVal path As String) As Integer
		Return xReadDir_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCloseDir(ByVal handle As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xNextFile")> _
	Public Function xNextFile_(ByVal handle As Integer) As IntPtr
	End Function
	Public Function xNextFile(ByVal handle As Integer) As String
		Return Marshal.PtrToStringAnsi(xNextFile_(handle))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xCurrentDir")> _
	Public Function xCurrentDir_() As IntPtr
	End Function
	Public Function xCurrentDir() As String
		Return Marshal.PtrToStringAnsi(xCurrentDir_())
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xChangeDir")> _
	Public Sub xChangeDir_(ByVal path As StringBuilder)
	End Sub
	Public Sub xChangeDir(ByVal path As String)
		xChangeDir_(new StringBuilder(path))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xCreateDir")> _
	Public Function xCreateDir_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xCreateDir(ByVal path As String) As Integer
		Return xCreateDir_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xDeleteDir")> _
	Public Function xDeleteDir_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xDeleteDir(ByVal path As String) As Integer
		Return xDeleteDir_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xCopyFile")> _
	Public Function xCopyFile_(ByVal pathSrc As StringBuilder, ByVal pathDest As StringBuilder) As Integer
	End Function
	Public Function xCopyFile(ByVal pathSrc As String, ByVal pathDest As String) As Integer
		Return xCopyFile_(new StringBuilder(pathSrc), new StringBuilder(pathDest))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xDeleteFile")> _
	Public Function xDeleteFile_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xDeleteFile(ByVal path As String) As Integer
		Return xDeleteFile_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEof(ByVal file As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xReadByte(ByVal file As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xReadShort(ByVal file As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xReadInt(ByVal file As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xReadFloat(ByVal file As Integer) As Single
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xReadString")> _
	Public Function xReadString_(ByVal file As Integer) As IntPtr
	End Function
	Public Function xReadString(ByVal file As Integer) As String
		Return Marshal.PtrToStringAnsi(xReadString_(file))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xReadLine")> _
	Public Function xReadLine_(ByVal file As Integer, ByVal ls_flag As Integer) As IntPtr
	End Function
	Public Function xReadLine(ByVal file As Integer, Optional ByVal ls_flag As Integer = 0) As String
		Return Marshal.PtrToStringAnsi(xReadLine_(file, ls_flag))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xWriteByte(ByVal file As Integer, ByVal value As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWriteShort(ByVal file As Integer, ByVal value As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWriteInt(ByVal file As Integer, ByVal value As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWriteFloat(ByVal file As Integer, ByVal value As Single)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xWriteString")> _
	Public Sub xWriteString_(ByVal file As Integer, ByVal value As StringBuilder)
	End Sub
	Public Sub xWriteString(ByVal file As Integer, ByVal value As String)
		xWriteString_(file, new StringBuilder(value))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xWriteLine")> _
	Public Sub xWriteLine_(ByVal file As Integer, ByVal value As StringBuilder, ByVal ls_flag As Integer)
	End Sub
	Public Sub xWriteLine(ByVal file As Integer, ByVal value As String, Optional ByVal ls_flag As Integer = 0)
		xWriteLine_(file, new StringBuilder(value), ls_flag)
	End Sub


	' fonts commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadFont")> _
	Public Function xLoadFont_(ByVal name As StringBuilder, ByVal height As Integer, ByVal bold As Integer, ByVal italic As Integer, ByVal underline As Integer, ByVal fontface As StringBuilder) As Integer
	End Function
	Public Function xLoadFont(ByVal name As String, ByVal height As Integer, Optional ByVal bold As Integer = 0, Optional ByVal italic As Integer = 0, Optional ByVal underline As Integer = 0, Optional ByVal fontface As String = "") As Integer
		Return xLoadFont_(new StringBuilder(name), height, bold, italic, underline, new StringBuilder(fontface))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xText")> _
	Public Sub xText_(ByVal x As Single, ByVal y As Single, ByVal textString As StringBuilder, ByVal centerx As Integer, ByVal centery As Integer)
	End Sub
	Public Sub xText(ByVal x As Single, ByVal y As Single, ByVal textString As String, Optional ByVal centerx As Integer = 0, Optional ByVal centery As Integer = 0)
		xText_(x, y, new StringBuilder(textString), centerx, centery)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetFont(ByVal font As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFreeFont(ByVal font As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xFontWidth() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xFontHeight() As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xStringWidth")> _
	Public Function xStringWidth_(ByVal textString As StringBuilder) As Integer
	End Function
	Public Function xStringWidth(ByVal textString As String) As Integer
		Return xStringWidth_(new StringBuilder(textString))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xStringHeight")> _
	Public Function xStringHeight_(ByVal textString As StringBuilder) As Integer
	End Function
	Public Function xStringHeight(ByVal textString As String) As Integer
		Return xStringHeight_(new StringBuilder(textString))
	End Function


	' graphics commands
	<DllImport("xors3d.dll", EntryPoint := "xWinMessage")> _
	Public Function xWinMessage_(ByVal message As StringBuilder) As Integer
	End Function
	Public Function xWinMessage(ByVal message As String) As Integer
		Return xWinMessage_(new StringBuilder(message))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMaxPixelShaderVersion() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLine(ByVal x1 As Integer, ByVal y1 As Integer, ByVal x2 As Integer, ByVal y2 As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRect(ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer, Optional ByVal solid As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xRectsOverlap(ByVal x1 As Integer, ByVal y1 As Integer, ByVal width1 As Integer, ByVal height1 As Integer, ByVal x2 As Integer, ByVal y2 As Integer, ByVal width2 As Integer, ByVal height2 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xViewport(ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xOval(ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer, Optional ByVal solid As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xOrigin(ByVal x As Integer, ByVal y As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetMaxVertexShaderVersion() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMaxAntiAlias() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMaxTextureFiltering() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetAntiAliasType(ByVal typeID As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xAppTitle")> _
	Public Sub xAppTitle_(ByVal title As StringBuilder)
	End Sub
	Public Sub xAppTitle(ByVal title As String)
		xAppTitle_(new StringBuilder(title))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetWND(ByVal window As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetRenderWindow(ByVal window As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetTopWindow(ByVal window As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDestroyRenderWindow()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFlip()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xBackBuffer() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLockBuffer(Optional ByVal buffer As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUnlockBuffer(Optional ByVal buffer As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWritePixelFast(ByVal x As Integer, ByVal y As Integer, ByVal argb As Integer, Optional ByVal buffer As Integer = -1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xReadPixelFast(ByVal x As Integer, ByVal y As Integer, Optional ByVal buffer As Integer = -1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetPixels(Optional ByVal buffer As Integer = -1) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xSaveBuffer")> _
	Public Sub xSaveBuffer_(ByVal buffer As Integer, ByVal path As StringBuilder)
	End Sub
	Public Sub xSaveBuffer(ByVal buffer As Integer, ByVal path As String)
		xSaveBuffer_(buffer, new StringBuilder(path))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetCurrentBuffer() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xBufferWidth(Optional ByVal buffer As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xBufferHeight(Optional ByVal buffer As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCatchTimestamp() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetElapsedTime(ByVal timeStamp As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetBuffer(Optional ByVal buffer As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetMRT(ByVal buffer As Integer, ByVal frame As Integer, ByVal index As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUnSetMRT()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetNumberRT() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTextureBuffer(ByVal texture As Integer, Optional ByVal frame As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadBuffer")> _
	Public Sub xLoadBuffer_(ByVal buffer As Integer, ByVal path As StringBuilder)
	End Sub
	Public Sub xLoadBuffer(ByVal buffer As Integer, ByVal path As String)
		xLoadBuffer_(buffer, new StringBuilder(path))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWritePixel(ByVal x As Integer, ByVal y As Integer, ByVal argb As Integer, Optional ByVal buffer As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCopyPixel(ByVal sx As Integer, ByVal sy As Integer, ByVal sourceBuffer As Integer, ByVal dx As Integer, ByVal dy As Integer, ByVal destinationBuffer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCopyPixelFast(ByVal sx As Integer, ByVal sy As Integer, ByVal sourceBuffer As Integer, ByVal dx As Integer, ByVal dy As Integer, ByVal destinationBuffer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCopyRect(ByVal sx As Integer, ByVal sy As Integer, ByVal sw As Integer, ByVal sh As Integer, ByVal dx As Integer, ByVal dy As Integer, ByVal sourceBuffer As Integer, ByVal destinationBuffer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGraphicsBuffer() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetColor(ByVal x As Integer, ByVal y As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xReadPixel(ByVal x As Integer, ByVal y As Integer, Optional ByVal buffer As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGraphicsWidth(Optional ByVal isVirtual As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGraphicsHeight(Optional ByVal isVirtual As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGraphicsDepth() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xColorAlpha() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xColorRed() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xColorGreen() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xColorBlue() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xClsColor(ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal alpha As Integer = 255)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearWorld(Optional ByVal entities As Integer = 1, Optional ByVal brushes As Integer = 1, Optional ByVal textures As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xColor(ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal alpha As Integer = 255)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCls()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUpdateWorld(Optional ByVal speed As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRenderEntity(ByVal camera As Integer, ByVal entity As Integer, Optional ByVal tween As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRenderWorld(Optional ByVal tween As Single = 1.0, Optional ByVal renderShadows As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetAutoTB(ByVal flag As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMaxClipPlanes() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xWireframe(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDither(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetSkinningMethod(ByVal skinMethod As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xTrisRendered() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xDIPCounter() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xSurfRendered() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityRendered() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xAmbientLight(ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal world As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetFPS() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xAntiAlias(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetTextureFiltering(ByVal filter As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xStretchRect(ByVal texture1 As Integer, ByVal x1 As Integer, ByVal y1 As Integer, ByVal width1 As Integer, ByVal height1 As Integer, ByVal texture2 As Integer, ByVal x2 As Integer, ByVal y2 As Integer, ByVal width2 As Integer, ByVal height2 As Integer, ByVal filter As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xStretchBackBuffer(ByVal texture As Integer, ByVal x As Integer, ByVal y As Integer, ByVal width As Integer, ByVal height As Integer, ByVal filter As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetDevice() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xReleaseGraphics()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xShowPointer()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xHidePointer()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCreateDSS(ByVal width As Integer, ByVal height As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteDSS()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xGridColor(ByVal centerRed As Integer, ByVal centerGreen As Integer, ByVal centerBlue As Integer, ByVal gridRed As Integer, ByVal gridGreen As Integer, ByVal gridBlue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawGrid(ByVal x As Single, ByVal z As Single, ByVal gridSize As Integer, ByVal range As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawBBox(ByVal draw As Integer, ByVal zOn As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, ByVal alpha As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xGraphics3D(Optional ByVal width As Integer = 1024, Optional ByVal height As Integer = 768, Optional ByVal depth As Integer = 0, Optional ByVal mode As Integer = 0, Optional ByVal vsync As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xGraphicsAspectRatio(ByVal aspectRatio As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xGraphicsBorderColor(ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetRenderWindow() As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xKey")> _
	Public Sub xKey_(ByVal key As StringBuilder)
	End Sub
	Public Sub xKey(ByVal key As String)
		xKey_(new StringBuilder(key))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetEngineSetting")> _
	Public Sub xSetEngineSetting_(ByVal parameter As StringBuilder, ByVal value As StringBuilder)
	End Sub
	Public Sub xSetEngineSetting(ByVal parameter As String, ByVal value As String)
		xSetEngineSetting_(new StringBuilder(parameter), new StringBuilder(value))
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xGetEngineSetting")> _
	Public Function xGetEngineSetting_(ByVal parameter As StringBuilder) As IntPtr
	End Function
	Public Function xGetEngineSetting(ByVal parameter As String) As String
		Return Marshal.PtrToStringAnsi(xGetEngineSetting_(new StringBuilder(parameter)))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xHWInstancingAvailable() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xShaderInstancingAvailable() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetShaderLayer(ByVal layer As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetShaderLayer() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xDrawMovementGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal selectMask As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawScaleGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal selectMask As Integer = 0, Optional ByVal sx As Single = 1.0, Optional ByVal sy As Single = 1.0, Optional ByVal sz As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawRotationGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal selectMask As Integer = 0, Optional ByVal pitch As Single = 0.0, Optional ByVal yaw As Single = 0.0, Optional ByVal roll As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCheckMovementGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal camera As Integer, ByVal mx As Integer, ByVal my As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCheckScaleGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal camera As Integer, ByVal mx As Integer, ByVal my As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCheckRotationGizmo(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal camera As Integer, ByVal mx As Integer, ByVal my As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCaptureWorld()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCountGfxModes() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGfxModeWidth(ByVal mode As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGfxModeHeight(ByVal mode As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGfxModeDepth(ByVal mode As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGfxModeExists(ByVal width As Integer, ByVal height As Integer, ByVal depth As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xAppWindowFrame(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMillisecs() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xDeltaTime(Optional ByVal fromInit As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xDeltaValue(ByVal value As Single, Optional ByVal time As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xAddDeviceLostCallback(ByVal func As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteDeviceLostCallback(ByVal func As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDeinit()
	End Sub


	' images commands
	<DllImport("xors3d.dll")> _
	Public Sub xImageColor(ByVal image As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xImageAlpha(ByVal image As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xImageBuffer(ByVal image As Integer, Optional ByVal frame As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateImage(ByVal width As Integer, ByVal height As Integer, Optional ByVal frame As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xGrabImage(ByVal image As Integer, ByVal x As Integer, ByVal y As Integer, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFreeImage(ByVal image As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLoadImage")> _
	Public Function xLoadImage_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadImage(ByVal path As String) As Integer
		Return xLoadImage_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadAnimImage")> _
	Public Function xLoadAnimImage_(ByVal path As StringBuilder, ByVal width As Integer, ByVal height As Integer, ByVal startFrame As Integer, ByVal frames As Integer) As Integer
	End Function
	Public Function xLoadAnimImage(ByVal path As String, ByVal width As Integer, ByVal height As Integer, ByVal startFrame As Integer, ByVal frames As Integer) As Integer
		Return xLoadAnimImage_(new StringBuilder(path), width, height, startFrame, frames)
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xSaveImage")> _
	Public Sub xSaveImage_(ByVal image As Integer, ByVal path As StringBuilder, ByVal frame As Integer)
	End Sub
	Public Sub xSaveImage(ByVal image As Integer, ByVal path As String, Optional ByVal frame As Integer = 0)
		xSaveImage_(image, new StringBuilder(path), frame)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawImage(ByVal image As Integer, ByVal x As Single, ByVal y As Single, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawImageRect(ByVal image As Integer, ByVal x As Single, ByVal y As Single, ByVal rectx As Single, ByVal recty As Single, ByVal rectWidth As Single, ByVal rectHeight As Single, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xScaleImage(ByVal image As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xResizeImage(ByVal image As Integer, ByVal width As Single, ByVal height As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRotateImage(ByVal image As Integer, ByVal angle As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xImageAngle(ByVal image As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageWidth(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageHeight(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImagesCollide(ByVal image1 As Integer, ByVal x1 As Integer, ByVal y1 As Integer, ByVal frame1 As Integer, ByVal image2 As Integer, ByVal x2 As Integer, ByVal y2 As Integer, ByVal frame2 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageRectCollide(ByVal image As Integer, ByVal x As Integer, ByVal y As Integer, ByVal frame As Integer, ByVal rectx As Integer, ByVal recty As Integer, ByVal rectWidth As Integer, ByVal rectHeight As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageRectOverlap(ByVal image As Integer, ByVal x As Single, ByVal y As Single, ByVal rectx As Single, ByVal recty As Single, ByVal rectWidth As Single, ByVal rectHeight As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageXHandle(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageYHandle(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xHandleImage(ByVal image As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xMidHandle(ByVal image As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xAutoMidHandle(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTileImage(ByVal image As Integer, ByVal x As Single, ByVal y As Single, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xImagesOverlap(ByVal image1 As Integer, ByVal x1 As Single, ByVal y1 As Single, ByVal image2 As Integer, ByVal x2 As Single, ByVal y2 As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xMaskImage(ByVal image As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCopyImage(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xDrawBlock(ByVal image As Integer, ByVal x As Single, ByVal y As Single, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawBlockRect(ByVal image As Integer, ByVal x As Single, ByVal y As Single, ByVal rectx As Single, ByVal recty As Single, ByVal rectWidth As Single, ByVal rectHeight As Single, Optional ByVal frame As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xImageActualWidth(ByVal image As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xImageActualHeight(ByVal image As Integer) As Integer
	End Function


	' inputs commands
	<DllImport("xors3d.dll")> _
	Public Sub xFlushKeys()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFlushMouse()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xKeyHit(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xKeyUp(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xWaitKey()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMouseHit(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xKeyDown(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetKey() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseDown(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseUp(ByVal key As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMouse() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseX() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseY() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseZ() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseXSpeed() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseYSpeed() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseZSpeed() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMouseSpeed() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xMoveMouse(ByVal x As Integer, ByVal y As Integer)
	End Sub


	' joysticks commands
	<DllImport("xors3d.dll")> _
	Public Function xJoyType(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyDown(ByVal key As Integer, Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyHit(ByVal key As Integer, Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetJoy(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFlushJoy()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xWaitJoy(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyX(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyY(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyZ(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyU(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyV(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyPitch(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyYaw(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyRoll(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyHat(Optional ByVal portID As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyXDir(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyYDir(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyZDir(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyUDir(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJoyVDir(Optional ByVal portID As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCountJoys() As Integer
	End Function


	' lights commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateLight(Optional ByVal typeID As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLightShadowEpsilons(ByVal light As Integer, ByVal epsilon1 As Single, ByVal epsilon2 As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLightEnableShadows(ByVal light As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xLightShadowsEnabled(ByVal light As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLightRange(ByVal light As Integer, ByVal range As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLightColor(ByVal light As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLightConeAngles(ByVal light As Integer, ByVal inner As Single, ByVal outer As Single)
	End Sub


	' logging commands
	<DllImport("xors3d.dll", EntryPoint := "xCreateLog")> _
	Public Function xCreateLog_(ByVal target As Integer, ByVal level As Integer, ByVal filename As StringBuilder, ByVal cssfilename As StringBuilder) As Integer
	End Function
	Public Function xCreateLog(Optional ByVal target As Integer = 1, Optional ByVal level As Integer = 0, Optional ByVal filename As String = "xors_log.html", Optional ByVal cssfilename As String = "") As Integer
		Return xCreateLog_(target, level, new StringBuilder(filename), new StringBuilder(cssfilename))
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCloseLog() As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xGetLogString")> _
	Public Function xGetLogString_() As IntPtr
	End Function
	Public Function xGetLogString() As String
		Return Marshal.PtrToStringAnsi(xGetLogString_())
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xClearLogString()
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetLogLevel(Optional ByVal level As Integer = 2)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetLogTarget(Optional ByVal target As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetLogLevel() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetLogTarget() As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLogInfo")> _
	Public Sub xLogInfo_(ByVal message As StringBuilder, ByVal func As StringBuilder, ByVal file As StringBuilder, ByVal line As Integer)
	End Sub
	Public Sub xLogInfo(ByVal message As String, Optional ByVal func As String = "", Optional ByVal file As String = "", Optional ByVal line As Integer = -1)
		xLogInfo_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLogMessage")> _
	Public Sub xLogMessage_(ByVal message As StringBuilder, ByVal func As StringBuilder, ByVal file As StringBuilder, ByVal line As Integer)
	End Sub
	Public Sub xLogMessage(ByVal message As String, Optional ByVal func As String = "", Optional ByVal file As String = "", Optional ByVal line As Integer = -1)
		xLogMessage_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLogWarning")> _
	Public Sub xLogWarning_(ByVal message As StringBuilder, ByVal func As StringBuilder, ByVal file As StringBuilder, ByVal line As Integer)
	End Sub
	Public Sub xLogWarning(ByVal message As String, Optional ByVal func As String = "", Optional ByVal file As String = "", Optional ByVal line As Integer = -1)
		xLogWarning_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLogError")> _
	Public Sub xLogError_(ByVal message As StringBuilder, ByVal func As StringBuilder, ByVal file As StringBuilder, ByVal line As Integer)
	End Sub
	Public Sub xLogError(ByVal message As String, Optional ByVal func As String = "", Optional ByVal file As String = "", Optional ByVal line As Integer = -1)
		xLogError_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLogFatal")> _
	Public Sub xLogFatal_(ByVal message As StringBuilder, ByVal func As StringBuilder, ByVal file As StringBuilder, ByVal line As Integer)
	End Sub
	Public Sub xLogFatal(ByVal message As String, Optional ByVal func As String = "", Optional ByVal file As String = "", Optional ByVal line As Integer = -1)
		xLogFatal_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line)
	End Sub


	' meshes commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateMesh(Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadMesh")> _
	Public Function xLoadMesh_(ByVal path As StringBuilder, ByVal parent As Integer) As Integer
	End Function
	Public Function xLoadMesh(ByVal path As String, Optional ByVal parent As Integer = 0) As Integer
		Return xLoadMesh_(new StringBuilder(path), parent)
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadMeshWithChild")> _
	Public Function xLoadMeshWithChild_(ByVal path As StringBuilder, ByVal parent As Integer) As Integer
	End Function
	Public Function xLoadMeshWithChild(ByVal path As String, Optional ByVal parent As Integer = 0) As Integer
		Return xLoadMeshWithChild_(new StringBuilder(path), parent)
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoadAnimMesh")> _
	Public Function xLoadAnimMesh_(ByVal path As StringBuilder, ByVal parent As Integer) As Integer
	End Function
	Public Function xLoadAnimMesh(ByVal path As String, Optional ByVal parent As Integer = 0) As Integer
		Return xLoadAnimMesh_(new StringBuilder(path), parent)
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateCube(Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateSphere(Optional ByVal segments As Integer = 16, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateCylinder(Optional ByVal segments As Integer = 16, Optional ByVal solid As Integer = 1, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateTorus(Optional ByVal segments As Integer = 16, Optional ByVal R As Single = 1.0, Optional ByVal r_tube As Single = 0.025, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateCone(Optional ByVal segments As Integer = 16, Optional ByVal solid As Integer = 1, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCopyMesh(ByVal entity As Integer, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xAddMesh(ByVal source As Integer, ByVal destination As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFlipMesh(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPaintMesh(ByVal entity As Integer, ByVal brush As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xFitMesh(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal width As Single, ByVal height As Single, ByVal depth As Single, Optional ByVal uniform As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMeshWidth(ByVal entity As Integer, Optional ByVal recursive As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMeshHeight(ByVal entity As Integer, Optional ByVal recursive As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMeshDepth(ByVal entity As Integer, Optional ByVal recursive As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xScaleMesh(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRotateMesh(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPositionMesh(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUpdateNormals(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUpdateN(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xUpdateTB(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMeshesBBIntersect(ByVal entity1 As Integer, ByVal entity2 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMeshesIntersect(ByVal entity1 As Integer, ByVal entity2 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMeshVB(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMeshIB(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMeshVBSize(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetMeshIBSize(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteMeshVB(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteMeshIB(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCountSurfaces(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetSurface(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreatePivot(Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xFindSurface(ByVal entity As Integer, ByVal brush As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreatePoly(Optional ByVal sides As Integer = 0, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xMeshSingleSurface(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSaveMesh")> _
	Public Function xSaveMesh_(ByVal entity As Integer, ByVal path As StringBuilder) As Integer
	End Function
	Public Function xSaveMesh(ByVal entity As Integer, ByVal path As String) As Integer
		Return xSaveMesh_(entity, new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xLightMesh(ByVal entity As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal range As Single = 0.0, Optional ByVal lightX As Single = 0.0, Optional ByVal lightY As Single = 0.0, Optional ByVal lightZ As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xMeshPrimitiveType(ByVal entity As Integer, ByVal ptype As Integer)
	End Sub


	' particles commands
	<DllImport("xors3d.dll")> _
	Public Sub xParticlePosition(ByVal particle As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleX(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleY(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleZ(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleVeclocity(ByVal particle As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleVX(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleVY(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleVZ(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleRotation(ByVal particle As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticlePitch(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleYaw(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleRoll(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleTorque(ByVal particle As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleTPitch(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleTYaw(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleTRoll(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleSetAlpha(ByVal particle As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleGetAlpha(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleColor(ByVal particle As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleRed(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleGreen(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleBlue(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleScale(ByVal particle As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleSX(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleSY(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xParticleScaleSpeed(ByVal particle As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xParticleScaleSpeedX(ByVal particle As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xParticleScaleSpeedY(ByVal particle As Integer) As Single
	End Function


	' physics commands
	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddDummyShape(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddBoxShape(ByVal entity As Integer, ByVal mass As Single, Optional ByVal width As Single = 0.0, Optional ByVal height As Single = 0.0, Optional ByVal depth As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddSphereShape(ByVal entity As Integer, ByVal mass As Single, Optional ByVal radius As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddCapsuleShape(ByVal entity As Integer, ByVal mass As Single, Optional ByVal radius As Single = 0.0, Optional ByVal height As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddConeShape(ByVal entity As Integer, ByVal mass As Single, Optional ByVal radius As Single = 0.0, Optional ByVal height As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddCylinderShape(ByVal entity As Integer, ByVal mass As Single, Optional ByVal width As Single = 0.0, Optional ByVal height As Single = 0.0, Optional ByVal depth As Single = 0.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddTriMeshShape(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddTriMeshShapeProxy(ByVal entity As Integer, ByVal proxy As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddConvexShape(ByVal entity As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddConvexShapeProxy(ByVal entity As Integer, ByVal proxy As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddConcaveShape(ByVal entity As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddConcaveShapeProxy(ByVal entity As Integer, ByVal proxy As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddTerrainShape(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAttachBody(ByVal entity As Integer, ByVal body As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityDetachBody(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeEntityBody(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityAddCompoundShape(ByVal entity As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundAddBox(ByVal entity As Integer, ByVal width As Single, ByVal height As Single, ByVal depth As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundAddSphere(ByVal entity As Integer, ByVal radius As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundAddCapsule(ByVal entity As Integer, ByVal radius As Single, ByVal height As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundAddCone(ByVal entity As Integer, ByVal radius As Single, ByVal height As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundAddCylinder(ByVal entity As Integer, ByVal radius As Single, ByVal height As Single) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundCountChildren(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityCompoundRemoveChild(ByVal entity As Integer, ByVal index As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityCompoundChildSetPosition(ByVal entity As Integer, ByVal index As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetX(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetY(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetZ(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityCompoundChildSetRotation(ByVal entity As Integer, ByVal index As Integer, ByVal pitch As Single, ByVal yaw As Single, ByVal roll As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetPitch(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetYaw(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCompoundChildGetRoll(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateHingeJoint(ByVal firstBody As Integer, ByVal secondBody As Integer, ByVal pivotX As Single, ByVal pivotY As Single, ByVal pivotZ As Single, ByVal axisX As Single, ByVal axisY As Single, ByVal axisZ As Single, Optional ByVal isGlobal As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateBallJoint(ByVal firstBody As Integer, ByVal secondBody As Integer, ByVal pivotX As Single, ByVal pivotY As Single, ByVal pivotZ As Single, Optional ByVal isGlobal As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateD6Joint(ByVal firstBody As Integer, ByVal secondBody As Integer, ByVal pivot1X As Single, ByVal pivot1Y As Single, ByVal pivot1Z As Single, ByVal pivot2X As Single, ByVal pivot2Y As Single, ByVal pivot2Z As Single, Optional ByVal isGlobal1 As Integer = 0, Optional ByVal isGlobal2 As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateD6SpringJoint(ByVal firstBody As Integer, ByVal secondBody As Integer, ByVal pivot1X As Single, ByVal pivot1Y As Single, ByVal pivot1Z As Single, ByVal pivot2X As Single, ByVal pivot2Y As Single, ByVal pivot2Z As Single, Optional ByVal isGlobal1 As Integer = 0, Optional ByVal isGlobal2 As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointHingeGetAngle(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetPitchAngle(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetYawAngle(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetRollAngle(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngle(ByVal joint As Integer, Optional ByVal axis As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xJointDisableCollisions(ByVal joint As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointEnable(ByVal joint As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xJointIsEnabled(ByVal joint As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointGetImpulse(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeJoint(ByVal joint As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointBallSetPivot(ByVal joint As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xJointBallGetPivotX(ByVal joint As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointBallGetPivotY(ByVal joint As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointBallGetPivotZ(ByVal joint As Integer, Optional ByVal isGlobal As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetLimits(ByVal joint As Integer, ByVal axis As Integer, ByVal lower As Single, ByVal upper As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetLowerLinearLimits(ByVal joint As Integer, ByVal lowerX As Single, ByVal lowerY As Single, ByVal lowerZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetUpperLinearLimits(ByVal joint As Integer, ByVal upperX As Single, ByVal upperY As Single, ByVal upperZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetLowerAngularLimits(ByVal joint As Integer, ByVal lowerX As Single, ByVal lowerY As Single, ByVal lowerZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetUpperAngularLimits(ByVal joint As Integer, ByVal upperX As Single, ByVal upperY As Single, ByVal upperZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetLinearLimits(ByVal joint As Integer, ByVal lowerX As Single, ByVal lowerY As Single, ByVal lowerZ As Single, ByVal upperX As Single, ByVal upperY As Single, ByVal upperZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SetAngularLimits(ByVal joint As Integer, ByVal lowerX As Single, ByVal lowerY As Single, ByVal lowerZ As Single, ByVal upperX As Single, ByVal upperY As Single, ByVal upperZ As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearLowerX(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearLowerY(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearLowerZ(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearUpperX(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearUpperY(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetLinearUpperZ(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularLowerX(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularLowerY(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularLowerZ(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularUpperX(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularUpperY(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointD6GetAngularUpperZ(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xJointD6SpringSetParam(ByVal joint As Integer, ByVal index As Integer, ByVal enabled As Integer, Optional ByVal damping As Single = 1.0, Optional ByVal stiffness As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointHingeSetAxis(ByVal joint As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointHingeSetLimits(ByVal joint As Integer, ByVal lowerLimit As Single, ByVal upperLimit As Single, Optional ByVal softness As Single = 0.9, Optional ByVal biasFactor As Single = 0.3, Optional ByVal relaxationFactor As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xJointHingeGetLowerLimit(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointHingeGetUpperLimit(ByVal joint As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xJointEnableMotor(ByVal joint As Integer, ByVal enabled As Integer, ByVal targetVelocity As Single, ByVal maxForce As Single, Optional ByVal index As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xJointHingeSetMotorTarget(ByVal joint As Integer, ByVal targetAngle As Single, ByVal deltaTime As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xJointGetEntityA(ByVal joint As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xJointGetEntityB(ByVal joint As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyCentralForce(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyCentralImpulse(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyTorque(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyTorqueImpulse(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyForce(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal pointx As Single, ByVal pointy As Single, ByVal pointz As Single, Optional ByVal isGlobal As Integer = 1, Optional ByVal globalPoint As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityApplyImpulse(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal pointx As Single, ByVal pointy As Single, ByVal pointz As Single, Optional ByVal isGlobal As Integer = 1, Optional ByVal globalPoint As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityReleaseForces(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWorldSetGravity(ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal world As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xWorldGetGravityX(Optional ByVal world As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xWorldGetGravityY(Optional ByVal world As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xWorldGetGravityZ(Optional ByVal world As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetGravity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetGravityX(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetGravityY(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetGravityZ(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetLinearVelocity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearVelocityX(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearVelocityY(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearVelocityZ(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetAngularVelocity(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularVelocityX(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularVelocityY(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularVelocityZ(ByVal entity As Integer, Optional ByVal isGlobal As Integer = 1) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetDamping(ByVal entity As Integer, ByVal linear As Single, ByVal angular As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearDamping(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularDamping(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetFriction(ByVal entity As Integer, ByVal friction As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetFriction(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetAnisotropicFriction(ByVal entity As Integer, ByVal fx As Single, ByVal fy As Single, ByVal fz As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAnisotropicFrictionX(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAnisotropicFrictionY(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAnisotropicFrictionZ(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetLinearFactor(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearFactorX(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearFactorY(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearFactorZ(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetAngularFactor(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularFactorX(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularFactorY(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularFactorZ(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetRestitution(ByVal entity As Integer, ByVal restitution As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetRestitution(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetMass(ByVal entity As Integer, ByVal mass As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetMass(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityCountContacts(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactX(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactY(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactZ(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactNX(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactNY(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactNZ(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactDistance(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContact(ByVal entity As Integer, ByVal index As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactImpulse(ByVal entity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetCollisionGroup(ByVal entity As Integer, ByVal group As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetCollisionGroup(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetContactGroup(ByVal entity As Integer, ByVal group As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetContactGroup(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetRaycastGroup(ByVal entity As Integer, ByVal group As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetRaycastGroup(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPhysicsSetCollisionFilter(ByVal group0 As Integer, ByVal group1 As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetCollisionFilter(ByVal group0 As Integer, ByVal group1 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPhysicsSetContactFilter(ByVal group0 As Integer, ByVal group1 As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetContactFilter(ByVal group0 As Integer, ByVal group1 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPhysicsSetRaycastFilter(ByVal rayGroup As Integer, ByVal bodyGroup As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetRaycastFilter(ByVal rayGroup As Integer, ByVal bodyGroup As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityIsSleeping(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityDisableSleeping(ByVal entity As Integer, Optional ByVal state As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWakeUp(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySleep(ByVal entity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntitySetSleepingThresholds(ByVal entity As Integer, ByVal linearThreshold As Single, ByVal angularThreshold As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetLinearSleepingThreshold(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityGetAngularSleepingThreshold(ByVal entity As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPhysicsRayCast(ByVal fromX As Single, ByVal fromY As Single, ByVal fromZ As Single, ByVal toX As Single, ByVal toY As Single, ByVal toZ As Single, Optional ByVal rcType As Integer = 0, Optional ByVal rayGroup As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitEntity(Optional ByVal index As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitPointX(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitPointY(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitPointZ(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitNormalX(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitNormalY(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitNormalZ(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsGetHitDistance(Optional ByVal index As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPhysicsCountHits() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityBodyLocalPosition(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityBodyLocalRotation(ByVal entity As Integer, ByVal pitch As Single, ByVal yaw As Single, ByVal roll As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityBodyLocalScale(ByVal entity As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xWorldSetFrequency(ByVal frequency As Single, Optional ByVal world As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityMakeKinematic(ByVal entity As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityIsKinematic(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPhysicsDebugRender(ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityDisableSimulation(ByVal entity As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityHasBody(ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityCreateVehicle(ByVal chassisEntity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityFreeVehicle(ByVal chassisEntity As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityCountWheels(ByVal chassisEntity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityAddWheel(ByVal chassisEntity As Integer, ByVal wheelEntity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetRadius(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal radius As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetAxle(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetRay(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetSuspensionLength(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal length As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetBrake(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal brake As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetMaxSuspensionForce(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal force As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetMaxSuspensionTravel(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal travel As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetSuspensionStiffness(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal stiffness As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetSuspensionDamping(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal damping As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetSuspensionCompression(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal compression As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetFriction(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal friction As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetEngineForce(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal force As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetRollInfluence(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal roll As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetRotation(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal rotation As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetSteering(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal steering As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityWheelSetConnectionPoint(ByVal chassisEntity As Integer, ByVal index As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal isGlobal As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityWheelGetSuspensionLength(ByVal chassisEntity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityWheelGetPitch(ByVal chassisEntity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityWheelGetYaw(ByVal chassisEntity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityWheelGetRoll(ByVal chassisEntity As Integer, ByVal index As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityWheelGetContactEntity(ByVal chassisEntity As Integer, ByVal index As Integer) As Integer
	End Function


	' posteffects commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadPostEffect")> _
	Public Function xLoadPostEffect_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadPostEffect(ByVal path As String) As Integer
		Return xLoadPostEffect_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreePostEffect(ByVal postEffect As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffect")> _
	Public Sub xSetPostEffect_(ByVal index As Integer, ByVal postEffect As Integer, ByVal technique As StringBuilder)
	End Sub
	Public Sub xSetPostEffect(ByVal index As Integer, ByVal postEffect As Integer, Optional ByVal technique As String = "MainTechnique")
		xSetPostEffect_(index, postEffect, new StringBuilder(technique))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRenderPostEffects()
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffectInt")> _
	Public Sub xSetPostEffectInt_(ByVal postEffect As Integer, ByVal name As StringBuilder, ByVal value As Integer)
	End Sub
	Public Sub xSetPostEffectInt(ByVal postEffect As Integer, ByVal name As String, ByVal value As Integer)
		xSetPostEffectInt_(postEffect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffectFloat")> _
	Public Sub xSetPostEffectFloat_(ByVal postEffect As Integer, ByVal name As StringBuilder, ByVal value As Single)
	End Sub
	Public Sub xSetPostEffectFloat(ByVal postEffect As Integer, ByVal name As String, ByVal value As Single)
		xSetPostEffectFloat_(postEffect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffectBool")> _
	Public Sub xSetPostEffectBool_(ByVal postEffect As Integer, ByVal name As StringBuilder, ByVal value As Integer)
	End Sub
	Public Sub xSetPostEffectBool(ByVal postEffect As Integer, ByVal name As String, ByVal value As Integer)
		xSetPostEffectBool_(postEffect, new StringBuilder(name), value)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffectVector")> _
	Public Sub xSetPostEffectVector_(ByVal postEffect As Integer, ByVal name As StringBuilder, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single)
	End Sub
	Public Sub xSetPostEffectVector(ByVal postEffect As Integer, ByVal name As String, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal w As Single = 1.0)
		xSetPostEffectVector_(postEffect, new StringBuilder(name), x, y, z, w)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetPostEffectTexture")> _
	Public Sub xSetPostEffectTexture_(ByVal postEffect As Integer, ByVal name As StringBuilder, ByVal texture As Integer, ByVal frame As Integer)
	End Sub
	Public Sub xSetPostEffectTexture(ByVal postEffect As Integer, ByVal name As String, ByVal texture As Integer, Optional ByVal frame As Integer = 0)
		xSetPostEffectTexture_(postEffect, new StringBuilder(name), texture, frame)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xDeletePostEffectConstant")> _
	Public Sub xDeletePostEffectConstant_(ByVal postEffect As Integer, ByVal name As StringBuilder)
	End Sub
	Public Sub xDeletePostEffectConstant(ByVal postEffect As Integer, ByVal name As String)
		xDeletePostEffectConstant_(postEffect, new StringBuilder(name))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearPostEffectConstants(ByVal postEffect As Integer)
	End Sub


	' psystems commands
	<DllImport("xors3d.dll")> _
	Public Function xCreatePSystem(Optional ByVal pointSprites As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemType(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetBlend(ByVal psystem As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetBlend(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetMaxParticles(ByVal psystem As Integer, ByVal maxNumber As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetMaxParticles(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetEmitterLifetime(ByVal psystem As Integer, ByVal lifetime As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetEmitterLifetime(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetParticleLifetime(ByVal psystem As Integer, ByVal lifetime As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetParticleLifetime(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetCreationInterval(ByVal psystem As Integer, ByVal interval As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetCreationInterval(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetCreationFrequency(ByVal psystem As Integer, ByVal frequency As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetCreationFrequency(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetTexture(ByVal psystem As Integer, ByVal texture As Integer, ByVal frames As Integer, ByVal speed As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTexture(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTextureFrames(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTextureAnimationSpeed(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetOffset(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal minz As Single, ByVal maxx As Single, ByVal maxy As Single, ByVal maxz As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMinZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetOffsetMaxZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetVelocity(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal minz As Single, ByVal maxx As Single, ByVal maxy As Single, ByVal maxz As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMinZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetVelocityMaxZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemEnableFixedQuads(ByVal psystem As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemFixedQuadsUsed(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetTorque(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal minz As Single, ByVal maxx As Single, ByVal maxy As Single, ByVal maxz As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMinZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetTorqueMaxZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetGravity(ByVal psystem As Integer, ByVal gravity As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetGravity(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetAlpha(ByVal psystem As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAlpha(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetFadeSpeed(ByVal psystem As Integer, ByVal speed As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetFadeSpeed(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetParticleSize(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal maxx As Single, ByVal maxy As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetSizeMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetSizeMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetSizeMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetSizeMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetScaleSpeed(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal maxx As Single, ByVal maxy As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetScaleSpeedMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetScaleSpeedMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetScaleSpeedMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetScaleSpeedMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetAngles(ByVal psystem As Integer, ByVal minx As Single, ByVal miny As Single, ByVal minz As Single, ByVal maxx As Single, ByVal maxy As Single, ByVal maxz As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMinX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMinY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMinZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMaxX(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMaxY(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetAnglesMaxZ(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetColorMode(ByVal psystem As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetColorMode(ByVal psystem As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetColors(ByVal psystem As Integer, ByVal sred As Single, ByVal sgreen As Single, ByVal sblue As Single, ByVal ered As Single, ByVal egreen As Single, ByVal eblue As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetBeginColorRed(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetBeginColorGreen(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetBeginColorBlue(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetEndColorRed(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetEndColorGreen(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetEndColorBlue(ByVal psystem As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreePSystem(ByVal psystem As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPSystemSetParticleParenting(ByVal psystem As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPSystemGetParticleParenting(ByVal psystem As Integer) As Integer
	End Function


	' raypicks commands
	<DllImport("xors3d.dll")> _
	Public Function xLinePick(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal dx As Single, ByVal dy As Single, ByVal dz As Single, Optional ByVal distance As Single = 0.0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityPick(ByVal entity As Integer, Optional ByVal range As Single = 0.0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCameraPick(ByVal camera As Integer, ByVal x As Integer, ByVal y As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedNX() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedNY() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedNZ() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedX() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedY() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedZ() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedEntity() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedSurface() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedTriangle() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xPickedTime() As Integer
	End Function


	' shadows commands
	<DllImport("xors3d.dll")> _
	Public Sub xSetShadowsBlur(ByVal blurLevel As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xSetShadowShader")> _
	Public Sub xSetShadowShader_(ByVal path As StringBuilder)
	End Sub
	Public Sub xSetShadowShader(ByVal path As String)
		xSetShadowShader_(new StringBuilder(path))
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xInitShadows(ByVal dirSize As Integer, ByVal spotSize As Integer, ByVal pointSize As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetShadowParams(Optional ByVal splitPlanes As Integer = 4, Optional ByVal splitLambda As Single = 0.95, Optional ByVal useOrtho As Integer = 1, Optional ByVal lightDist As Single = 300.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRenderShadows(ByVal mainCamera As Integer, ByVal texture As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xShadowPriority(ByVal priority As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraDisableShadows(ByVal camera As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xCameraEnableShadows(ByVal camera As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityCastShadows(ByVal entity As Integer, ByVal light As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xEntityReceiveShadows(ByVal entity As Integer, ByVal light As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xEntityIsCaster(ByVal entity As Integer, ByVal light As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEntityIsReceiver(ByVal entity As Integer, ByVal light As Integer) As Integer
	End Function


	' sounds commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadSound")> _
	Public Function xLoadSound_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadSound(ByVal path As String) As Integer
		Return xLoadSound_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xLoad3DSound")> _
	Public Function xLoad3DSound_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoad3DSound(ByVal path As String) As Integer
		Return xLoad3DSound_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeSound(ByVal sound As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xLoopSound(ByVal sound As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSoundPitch(ByVal sound As Integer, ByVal pitch As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSoundVolume(ByVal sound As Integer, ByVal volume As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSoundPan(ByVal sound As Integer, ByVal pan As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xPlaySound(ByVal sound As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xStopChannel(ByVal channel As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xPauseChannel(ByVal channel As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xResumeChannel(ByVal channel As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xPlayMusic")> _
	Public Function xPlayMusic_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xPlayMusic(ByVal path As String) As Integer
		Return xPlayMusic_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xChannelPitch(ByVal channel As Integer, ByVal pitch As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xChannelVolume(ByVal channel As Integer, ByVal volume As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xChannelPan(ByVal channel As Integer, ByVal pan As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xChannelPlaying(ByVal channel As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xEmitSound(ByVal sound As Integer, ByVal entity As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateListener(Optional ByVal parent As Integer = 0, Optional ByVal roFactor As Single = 1.0, Optional ByVal doplerFactor As Single = 1.0, Optional ByVal distFactor As Single = 1.0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetListener() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xInitalizeSound() As Integer
	End Function


	' sprites commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateSprite(Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSpriteViewMode(ByVal sprite As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xHandleSprite(ByVal sprite As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLoadSprite")> _
	Public Function xLoadSprite_(ByVal path As StringBuilder, ByVal flags As Integer, ByVal parent As Integer) As Integer
	End Function
	Public Function xLoadSprite(ByVal path As String, Optional ByVal flags As Integer = 9, Optional ByVal parent As Integer = 0) As Integer
		Return xLoadSprite_(new StringBuilder(path), flags, parent)
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xRotateSprite(ByVal sprite As Integer, ByVal angle As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xScaleSprite(ByVal sprite As Integer, ByVal xScale As Single, ByVal yScale As Single)
	End Sub


	' surfaces commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateSurface(ByVal entity As Integer, Optional ByVal brush As Integer = 0, Optional ByVal dynamic As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetSurfaceBrush(ByVal surface As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xAddVertex(ByVal surface As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, Optional ByVal u As Single = 0.0, Optional ByVal v As Single = 0.0, Optional ByVal w As Single = 0.0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xAddTriangle(ByVal surface As Integer, ByVal v0 As Integer, ByVal v1 As Integer, ByVal v2 As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetSurfaceFrustumSphere(ByVal surface As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal radii As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexCoords(ByVal surface As Integer, ByVal vertex As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexNormal(ByVal surface As Integer, ByVal vertex As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexTangent(ByVal surface As Integer, ByVal vertex As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexBinormal(ByVal surface As Integer, ByVal vertex As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexColor(ByVal surface As Integer, ByVal vertex As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer, Optional ByVal alpha As Single = 1.0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xVertexTexCoords(ByVal surface As Integer, ByVal vertex As Integer, ByVal u As Single, ByVal v As Single, Optional ByVal w As Single = 1.0, Optional ByVal textureSet As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xCountVertices(ByVal surface As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexX(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexY(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexZ(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexNX(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexNY(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexNZ(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexTX(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexTY(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexTZ(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexBX(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexBY(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexBZ(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexU(ByVal surface As Integer, ByVal vertex As Integer, Optional ByVal textureSet As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexV(ByVal surface As Integer, ByVal vertex As Integer, Optional ByVal textureSet As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexW(ByVal surface As Integer, ByVal vertex As Integer, Optional ByVal textureSet As Integer = 0) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexRed(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexGreen(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexBlue(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVertexAlpha(ByVal surface As Integer, ByVal vertex As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTriangleVertex(ByVal surface As Integer, ByVal triangle As Integer, ByVal corner As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCountTriangles(ByVal surface As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPaintSurface(ByVal surface As Integer, ByVal brush As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearSurface(ByVal surface As Integer, Optional ByVal vertices As Integer = 1, Optional ByVal triangles As Integer = 1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetSurfaceTexture(ByVal surface As Integer, Optional ByVal index As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeSurface(ByVal surface As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfacePrimitiveType(ByVal surface As Integer, ByVal ptype As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceTexture(ByVal surface As Integer, ByVal texture As Integer, ByVal frame As Integer, ByVal index As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceColor(ByVal surface As Integer, ByVal red As Integer, ByVal green As Integer, ByVal blue As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceAlpha(ByVal surface As Integer, ByVal alpha As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceShininess(ByVal surface As Integer, ByVal shininess As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceBlend(ByVal surface As Integer, ByVal blendMode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceFX(ByVal surface As Integer, ByVal fxFlags As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceAlphaRef(ByVal surface As Integer, ByVal alphaRef As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSurfaceAlphaFunc(ByVal surface As Integer, ByVal alphaFunc As Integer)
	End Sub


	' sysinfos commands
	<DllImport("xors3d.dll", EntryPoint := "xCPUName")> _
	Public Function xCPUName_() As IntPtr
	End Function
	Public Function xCPUName() As String
		Return Marshal.PtrToStringAnsi(xCPUName_())
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xCPUVendor")> _
	Public Function xCPUVendor_() As IntPtr
	End Function
	Public Function xCPUVendor() As String
		Return Marshal.PtrToStringAnsi(xCPUVendor_())
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCPUFamily() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCPUModel() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCPUStepping() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCPUSpeed() As Integer
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xVideoInfo")> _
	Public Function xVideoInfo_() As IntPtr
	End Function
	Public Function xVideoInfo() As String
		Return Marshal.PtrToStringAnsi(xVideoInfo_())
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVideoAspectRatio() As Single
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xVideoAspectRatioStr")> _
	Public Function xVideoAspectRatioStr_() As IntPtr
	End Function
	Public Function xVideoAspectRatioStr() As String
		Return Marshal.PtrToStringAnsi(xVideoAspectRatioStr_())
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTotalPhysMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAvailPhysMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTotalPageMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAvailPageMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTotalVidMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAvailVidMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTotalVidLocalMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAvailVidLocalMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTotalVidNonlocalMem() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetAvailVidNonlocalMem() As Single
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xGetXors3dVersion")> _
	Public Function xGetXors3dVersion_() As IntPtr
	End Function
	Public Function xGetXors3dVersion() As String
		Return Marshal.PtrToStringAnsi(xGetXors3dVersion_())
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetXors3dMajorVersion() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetXors3dMinorVersion() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetXors3dRevision() As Integer
	End Function


	' terrains commands
	<DllImport("xors3d.dll", EntryPoint := "xLoadTerrain")> _
	Public Function xLoadTerrain_(ByVal path As StringBuilder, ByVal parent As Integer) As Integer
	End Function
	Public Function xLoadTerrain(ByVal path As String, Optional ByVal parent As Integer = 0) As Integer
		Return xLoadTerrain_(new StringBuilder(path), parent)
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateTerrain(ByVal size As Integer, Optional ByVal parent As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainShading(ByVal terrain As Integer, Optional ByVal state As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xTerrainHeight(ByVal terrain As Integer, ByVal x As Integer, ByVal y As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTerrainSize(ByVal terrain As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTerrainX(ByVal terrain As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTerrainY(ByVal terrain As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTerrainZ(ByVal terrain As Integer, ByVal x As Single, ByVal y As Single, ByVal z As Single) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xModifyTerrain(ByVal terrain As Integer, ByVal x As Integer, ByVal y As Integer, ByVal height As Single, Optional ByVal realtime As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainDetail(ByVal terrain As Integer, ByVal detail As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainSplatting(ByVal terrain As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLoadTerrainTexture")> _
	Public Function xLoadTerrainTexture_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xLoadTerrainTexture(ByVal path As String) As Integer
		Return xLoadTerrainTexture_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeTerrainTexture(ByVal texture As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainTextureLightmap(ByVal texture As Integer, ByVal state As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainTexture(ByVal terrain As Integer, ByVal texture As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainViewZone(ByVal terrain As Integer, ByVal viewZone As Integer, Optional ByVal texturingZone As Integer = -1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTerrainLODs(ByVal lodsCount As Integer)
	End Sub


	' textures commands
	<DllImport("xors3d.dll")> _
	Public Function xTextureWidth(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTextureHeight(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateTexture(ByVal width As Integer, ByVal height As Integer, Optional ByVal flags As Integer = 9, Optional ByVal frames As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xFreeTexture(ByVal texture As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetTextureFilter(ByVal texture As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTextureBlend(ByVal texture As Integer, ByVal blend As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTextureCoords(ByVal texture As Integer, ByVal coords As Integer)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xTextureFilter")> _
	Public Sub xTextureFilter_(ByVal matchText As StringBuilder, ByVal flags As Integer)
	End Sub
	Public Sub xTextureFilter(ByVal matchText As String, ByVal flags As Integer)
		xTextureFilter_(new StringBuilder(matchText), flags)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xClearTextureFilters()
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLoadTexture")> _
	Public Function xLoadTexture_(ByVal path As StringBuilder, ByVal flags As Integer) As Integer
	End Function
	Public Function xLoadTexture(ByVal path As String, Optional ByVal flags As Integer = 9) As Integer
		Return xLoadTexture_(new StringBuilder(path), flags)
	End Function

	<DllImport("xors3d.dll", EntryPoint := "xTextureName")> _
	Public Function xTextureName_(ByVal texture As Integer) As IntPtr
	End Function
	Public Function xTextureName(ByVal texture As Integer) As String
		Return Marshal.PtrToStringAnsi(xTextureName_(texture))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xPositionTexture(ByVal texture As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xScaleTexture(ByVal texture As Integer, ByVal x As Single, ByVal y As Single)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xRotateTexture(ByVal texture As Integer, ByVal angle As Single)
	End Sub

	<DllImport("xors3d.dll", EntryPoint := "xLoadAnimTexture")> _
	Public Function xLoadAnimTexture_(ByVal path As StringBuilder, ByVal flags As Integer, ByVal width As Integer, ByVal height As Integer, ByVal startFrame As Integer, ByVal frames As Integer) As Integer
	End Function
	Public Function xLoadAnimTexture(ByVal path As String, ByVal flags As Integer, ByVal width As Integer, ByVal height As Integer, ByVal startFrame As Integer, ByVal frames As Integer) As Integer
		Return xLoadAnimTexture_(new StringBuilder(path), flags, width, height, startFrame, frames)
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xCreateTextureFromData(ByVal pixelsData As Integer, ByVal width As Integer, ByVal height As Integer, Optional ByVal flags As Integer = 9, Optional ByVal frames As Integer = 1) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureData(ByVal texture As Integer, Optional ByVal frame As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureDataPitch(ByVal texture As Integer, Optional ByVal frame As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureSurface(ByVal texture As Integer, Optional ByVal frame As Integer = 0) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureFrames(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetCubeFace(ByVal texture As Integer, ByVal face As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xSetCubeMode(ByVal texture As Integer, ByVal mode As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureBlend(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureX(ByVal texture As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureY(ByVal texture As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureScaleX(ByVal texture As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureScaleY(ByVal texture As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureAngle(ByVal texture As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureCoords(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetCubeFace(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetCubeMode(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetTextureFlags(ByVal texture As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetTextureFlags(ByVal texture As Integer, ByVal flags As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xTextureCounter(ByVal texture As Integer) As Integer
	End Function


	' transforms commands
	<DllImport("xors3d.dll")> _
	Public Function xVectorPitch(ByVal x As Single, ByVal y As Single, ByVal z As Single) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xVectorYaw(ByVal x As Single, ByVal y As Single, ByVal z As Single) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xDeltaPitch(ByVal entity1 As Integer, ByVal entity2 As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xDeltaYaw(ByVal entity1 As Integer, ByVal entity2 As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTFormedX() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTFormedY() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xTFormedZ() As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xTFormPoint(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal source As Integer, ByVal destination As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTFormVector(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal source As Integer, ByVal destination As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xTFormNormal(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal source As Integer, ByVal destination As Integer)
	End Sub


	' videos commands
	<DllImport("xors3d.dll", EntryPoint := "xOpenMovie")> _
	Public Function xOpenMovie_(ByVal path As StringBuilder) As Integer
	End Function
	Public Function xOpenMovie(ByVal path As String) As Integer
		Return xOpenMovie_(new StringBuilder(path))
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xCloseMovie(ByVal video As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xDrawMovie(ByVal video As Integer, Optional ByVal x As Integer = 0, Optional ByVal y As Integer = 0, Optional ByVal width As Integer = -1, Optional ByVal height As Integer = -1)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMovieWidth(ByVal video As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMovieHeight(ByVal video As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMoviePlaying(ByVal video As Integer) As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xMovieSeek(ByVal video As Integer, ByVal time As Single, Optional ByVal relative As Integer = 0)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMovieLength(ByVal video As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xMovieCurrentTime(ByVal video As Integer) As Single
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xMoviePause(ByVal video As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Sub xMovieResume(ByVal video As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xMovieTexture(ByVal video As Integer) As Integer
	End Function


	' worlds commands
	<DllImport("xors3d.dll")> _
	Public Function xCreateWorld() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xSetActiveWorld(ByVal world As Integer)
	End Sub

	<DllImport("xors3d.dll")> _
	Public Function xGetActiveWorld() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Function xGetDefaultWorld() As Integer
	End Function

	<DllImport("xors3d.dll")> _
	Public Sub xDeleteWorld(ByVal world As Integer)
	End Sub


	' Scancodes for keyboard and mouse
	Public Const MOUSE_LEFT        As Integer = 1
	Public Const MOUSE_RIGHT       As Integer = 2
	Public Const MOUSE_MIDDLE      As Integer = 3
	Public Const MOUSE4            As Integer = 4
	Public Const MOUSE5            As Integer = 5
	Public Const MOUSE6            As Integer = 6
	Public Const MOUSE7            As Integer = 7
	Public Const MOUSE8            As Integer = 8
	
	Public Const xMOUSE_LEFT       As Integer = 1
	Public Const xMOUSE_RIGHT      As Integer = 2
	Public Const xMOUSE_MIDDLE     As Integer = 3
	Public Const xMOUSE4           As Integer = 4
	Public Const xMOUSE5           As Integer = 5
	Public Const xMOUSE6           As Integer = 6
	Public Const xMOUSE7           As Integer = 7
	Public Const xMOUSE8           As Integer = 8
	
	Public Const KEY_ESCAPE        As Integer = 1
	Public Const KEY_1             As Integer = 2
	Public Const KEY_2             As Integer = 3
	Public Const KEY_3             As Integer = 4
	Public Const KEY_4             As Integer = 5
	Public Const KEY_5             As Integer = 6
	Public Const KEY_6             As Integer = 7
	Public Const KEY_7             As Integer = 8
	Public Const KEY_8             As Integer = 9
	Public Const KEY_9             As Integer = 10
	Public Const KEY_0             As Integer = 11
	Public Const KEY_MINUS         As Integer = 12
	Public Const KEY_EQUALS        As Integer = 13
	Public Const KEY_BACK          As Integer = 14
	Public Const KEY_TAB           As Integer = 15
	Public Const KEY_Q             As Integer = 16
	Public Const KEY_W             As Integer = 17
	Public Const KEY_E             As Integer = 18
	Public Const KEY_R             As Integer = 19
	Public Const KEY_T             As Integer = 20
	Public Const KEY_Y             As Integer = 21
	Public Const KEY_U             As Integer = 22
	Public Const KEY_I             As Integer = 23
	Public Const KEY_O             As Integer = 24
	Public Const KEY_P             As Integer = 25
	Public Const KEY_LBRACKET      As Integer = 26
	Public Const KEY_RBRACKET      As Integer = 27
	Public Const KEY_RETURN        As Integer = 28
	Public Const KEY_ENTER         As Integer = KEY_RETURN
	Public Const KEY_LCONTROL      As Integer = 29
	Public Const KEY_RCONTROL      As Integer = 157
	Public Const KEY_A             As Integer = 30
	Public Const KEY_S             As Integer = 31
	Public Const KEY_D             As Integer = 32
	Public Const KEY_F             As Integer = 33
	Public Const KEY_G             As Integer = 34
	Public Const KEY_H             As Integer = 35
	Public Const KEY_J             As Integer = 36
	Public Const KEY_K             As Integer = 37
	Public Const KEY_L             As Integer = 38
	Public Const KEY_SEMICOLON     As Integer = 39
	Public Const KEY_APOSTROPHE    As Integer = 40
	Public Const KEY_GRAVE         As Integer = 41
	Public Const KEY_LSHIFT        As Integer = 42
	Public Const KEY_BACKSLASH     As Integer = 43
	Public Const KEY_Z             As Integer = 44
	Public Const KEY_X             As Integer = 45
	Public Const KEY_C             As Integer = 46
	Public Const KEY_V             As Integer = 47
	Public Const KEY_B             As Integer = 48
	Public Const KEY_N             As Integer = 49
	Public Const KEY_M             As Integer = 50
	Public Const KEY_COMMA         As Integer = 51
	Public Const KEY_PERIOD        As Integer = 52
	Public Const KEY_SLASH         As Integer = 53
	Public Const KEY_RSHIFT        As Integer = 54
	Public Const KEY_MULTIPLY      As Integer = 55
	Public Const KEY_MENU          As Integer = 56
	Public Const KEY_SPACE         As Integer = 57
	Public Const KEY_F1            As Integer = 59
	Public Const KEY_F2            As Integer = 60
	Public Const KEY_F3            As Integer = 61
	Public Const KEY_F4            As Integer = 62
	Public Const KEY_F5            As Integer = 63
	Public Const KEY_F6            As Integer = 64
	Public Const KEY_F7            As Integer = 65
	Public Const KEY_F8            As Integer = 66
	Public Const KEY_F9            As Integer = 67
	Public Const KEY_F10           As Integer = 68
	Public Const KEY_NUMLOCK       As Integer = 69
	Public Const KEY_SCROLL        As Integer = 70
	Public Const KEY_NUMPAD7       As Integer = 71
	Public Const KEY_NUMPAD8       As Integer = 72
	Public Const KEY_NUMPAD9       As Integer = 73
	Public Const KEY_SUBTRACT      As Integer = 74
	Public Const KEY_NUMPAD4       As Integer = 75
	Public Const KEY_NUMPAD5       As Integer = 76
	Public Const KEY_NUMPAD6       As Integer = 77
	Public Const KEY_ADD           As Integer = 78
	Public Const KEY_NUMPAD1       As Integer = 79
	Public Const KEY_NUMPAD2       As Integer = 80
	Public Const KEY_NUMPAD3       As Integer = 81
	Public Const KEY_NUMPAD0       As Integer = 82
	Public Const KEY_DECIMAL       As Integer = 83
	Public Const KEY_TILD          As Integer = 86
	Public Const KEY_F11           As Integer = 87
	Public Const KEY_F12           As Integer = 88
	Public Const KEY_NUMPADENTER   As Integer = 156
	Public Const KEY_RMENU         As Integer = 221
	Public Const KEY_PAUSE         As Integer = 197
	Public Const KEY_HOME          As Integer = 199
	Public Const KEY_UP            As Integer = 200
	Public Const KEY_PRIOR         As Integer = 201
	Public Const KEY_LEFT          As Integer = 203
	Public Const KEY_RIGHT         As Integer = 205
	Public Const KEY_END           As Integer = 207
	Public Const KEY_DOWN          As Integer = 208
	Public Const KEY_NEXT          As Integer = 209
	Public Const KEY_INSERT        As Integer = 210
	Public Const KEY_DELETE        As Integer = 211
	Public Const KEY_LWIN          As Integer = 219
	Public Const KEY_RWIN          As Integer = 220
	Public Const KEY_BACKSPACE     As Integer = KEY_BACK
	Public Const KEY_NUMPADSTAR    As Integer = KEY_MULTIPLY
	Public Const KEY_LALT          As Integer = 184
	Public Const KEY_CAPSLOCK      As Integer = 58
	Public Const KEY_NUMPADMINUS   As Integer = KEY_SUBTRACT
	Public Const KEY_NUMPADPLUS    As Integer = KEY_ADD
	Public Const KEY_NUMPADPERIOD  As Integer = KEY_DECIMAL
	Public Const KEY_DIVIDE        As Integer = 181
	Public Const KEY_NUMPADSLASH   As Integer = KEY_DIVIDE
	Public Const KEY_RALT          As Integer = 56
	Public Const KEY_UPARROW       As Integer = KEY_UP
	Public Const KEY_PGUP          As Integer = KEY_PRIOR
	Public Const KEY_LEFTARROW     As Integer = KEY_LEFT
	Public Const KEY_RIGHTARROW    As Integer = KEY_RIGHT
	Public Const KEY_DOWNARROW     As Integer = KEY_DOWN
	Public Const KEY_PGDN          As Integer = KEY_NEXT
	
	Public Const xKEY_ESCAPE       As Integer = 1
	Public Const xKEY_1            As Integer = 2
	Public Const xKEY_2            As Integer = 3
	Public Const xKEY_3            As Integer = 4
	Public Const xKEY_4            As Integer = 5
	Public Const xKEY_5            As Integer = 6
	Public Const xKEY_6            As Integer = 7
	Public Const xKEY_7            As Integer = 8
	Public Const xKEY_8            As Integer = 9
	Public Const xKEY_9            As Integer = 10
	Public Const xKEY_0            As Integer = 11
	Public Const xKEY_MINUS        As Integer = 12
	Public Const xKEY_EQUALS       As Integer = 13
	Public Const xKEY_BACK         As Integer = 14
	Public Const xKEY_TAB          As Integer = 15
	Public Const xKEY_Q            As Integer = 16
	Public Const xKEY_W            As Integer = 17
	Public Const xKEY_E            As Integer = 18
	Public Const xKEY_R            As Integer = 19
	Public Const xKEY_T            As Integer = 20
	Public Const xKEY_Y            As Integer = 21
	Public Const xKEY_U            As Integer = 22
	Public Const xKEY_I            As Integer = 23
	Public Const xKEY_O            As Integer = 24
	Public Const xKEY_P            As Integer = 25
	Public Const xKEY_LBRACKET     As Integer = 26
	Public Const xKEY_RBRACKET     As Integer = 27
	Public Const xKEY_RETURN       As Integer = 28
	Public Const xKEY_ENTER        As Integer = KEY_RETURN
	Public Const xKEY_LCONTROL     As Integer = 29
	Public Const xKEY_RCONTROL     As Integer = 157
	Public Const xKEY_A            As Integer = 30
	Public Const xKEY_S            As Integer = 31
	Public Const xKEY_D            As Integer = 32
	Public Const xKEY_F            As Integer = 33
	Public Const xKEY_G            As Integer = 34
	Public Const xKEY_H            As Integer = 35
	Public Const xKEY_J            As Integer = 36
	Public Const xKEY_K            As Integer = 37
	Public Const xKEY_L            As Integer = 38
	Public Const xKEY_SEMICOLON    As Integer = 39
	Public Const xKEY_APOSTROPHE   As Integer = 40
	Public Const xKEY_GRAVE        As Integer = 41
	Public Const xKEY_LSHIFT       As Integer = 42
	Public Const xKEY_BACKSLASH    As Integer = 43
	Public Const xKEY_Z            As Integer = 44
	Public Const xKEY_X            As Integer = 45
	Public Const xKEY_C            As Integer = 46
	Public Const xKEY_V            As Integer = 47
	Public Const xKEY_B            As Integer = 48
	Public Const xKEY_N            As Integer = 49
	Public Const xKEY_M            As Integer = 50
	Public Const xKEY_COMMA        As Integer = 51
	Public Const xKEY_PERIOD       As Integer = 52
	Public Const xKEY_SLASH        As Integer = 53
	Public Const xKEY_RSHIFT       As Integer = 54
	Public Const xKEY_MULTIPLY     As Integer = 55
	Public Const xKEY_MENU         As Integer = 56
	Public Const xKEY_SPACE        As Integer = 57
	Public Const xKEY_F1           As Integer = 59
	Public Const xKEY_F2           As Integer = 60
	Public Const xKEY_F3           As Integer = 61
	Public Const xKEY_F4           As Integer = 62
	Public Const xKEY_F5           As Integer = 63
	Public Const xKEY_F6           As Integer = 64
	Public Const xKEY_F7           As Integer = 65
	Public Const xKEY_F8           As Integer = 66
	Public Const xKEY_F9           As Integer = 67
	Public Const xKEY_F10          As Integer = 68
	Public Const xKEY_NUMLOCK      As Integer = 69
	Public Const xKEY_SCROLL       As Integer = 70
	Public Const xKEY_NUMPAD7      As Integer = 71
	Public Const xKEY_NUMPAD8      As Integer = 72
	Public Const xKEY_NUMPAD9      As Integer = 73
	Public Const xKEY_SUBTRACT     As Integer = 74
	Public Const xKEY_NUMPAD4      As Integer = 75
	Public Const xKEY_NUMPAD5      As Integer = 76
	Public Const xKEY_NUMPAD6      As Integer = 77
	Public Const xKEY_ADD          As Integer = 78
	Public Const xKEY_NUMPAD1      As Integer = 79
	Public Const xKEY_NUMPAD2      As Integer = 80
	Public Const xKEY_NUMPAD3      As Integer = 81
	Public Const xKEY_NUMPAD0      As Integer = 82
	Public Const xKEY_DECIMAL      As Integer = 83
	Public Const xKEY_TILD         As Integer = 86
	Public Const xKEY_F11          As Integer = 87
	Public Const xKEY_F12          As Integer = 88
	Public Const xKEY_NUMPADENTER  As Integer = 156
	Public Const xKEY_RMENU        As Integer = 221
	Public Const xKEY_PAUSE        As Integer = 197
	Public Const xKEY_HOME         As Integer = 199
	Public Const xKEY_UP           As Integer = 200
	Public Const xKEY_PRIOR        As Integer = 201
	Public Const xKEY_LEFT         As Integer = 203
	Public Const xKEY_RIGHT        As Integer = 205
	Public Const xKEY_END          As Integer = 207
	Public Const xKEY_DOWN         As Integer = 208
	Public Const xKEY_NEXT         As Integer = 209
	Public Const xKEY_INSERT       As Integer = 210
	Public Const xKEY_DELETE       As Integer = 211
	Public Const xKEY_LWIN         As Integer = 219
	Public Const xKEY_RWIN         As Integer = 220
	Public Const xKEY_BACKSPACE    As Integer = KEY_BACK
	Public Const xKEY_NUMPADSTAR   As Integer = KEY_MULTIPLY
	Public Const xKEY_LALT         As Integer = 184
	Public Const xKEY_CAPSLOCK     As Integer = 58
	Public Const xKEY_NUMPADMINUS  As Integer = KEY_SUBTRACT
	Public Const xKEY_NUMPADPLUS   As Integer = KEY_ADD
	Public Const xKEY_NUMPADPERIOD As Integer = KEY_DECIMAL
	Public Const xKEY_DIVIDE       As Integer = 181
	Public Const xKEY_NUMPADSLASH  As Integer = KEY_DIVIDE
	Public Const xKEY_RALT         As Integer = 56
	Public Const xKEY_UPARROW      As Integer = KEY_UP
	Public Const xKEY_PGUP         As Integer = KEY_PRIOR
	Public Const xKEY_LEFTARROW    As Integer = KEY_LEFT
	Public Const xKEY_RIGHTARROW   As Integer = KEY_RIGHT
	Public Const xKEY_DOWNARROW    As Integer = KEY_DOWN
	Public Const xKEY_PGDN         As Integer = KEY_NEXT
End Module