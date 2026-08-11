' *****************************************************************
' *                                                               *
' * Xors3d Engine header file for BlitzMax, (c) 2012 XorsTeam     *
' * www:    http://xors3d.com                                     *
' * e-mail: support@xors3d.com                                    *
' *                                                               *
' *****************************************************************

Strict
Module xorsteam.xors3d
Import brl.blitz

ModuleInfo "Version: 1.0"
ModuleInfo "Copyright: LGPL. XorsTeam http://xors3d.com"

Extern "win32"
	Function FindWindowA%(class%, title$z)
	Function LoadLibraryA(lib$z)
	Function GetProcAddress:Byte Ptr(lib%, functionName$z) 
End Extern

Global xorsLibName$ = "Xors3D.dll"

' Log levels
Const LOG_NO            = 5
Const LOG_FATAL         = 4
Const LOG_ERROR         = 3
Const LOG_WARNING       = 2
Const LOG_MESSAGE       = 1
Const LOG_INFO          = 0

' Log targets
Const LOG_HTML             = 1
Const LOG_COUT             = 2
Const LOG_STRING           = 4

' Skinning types
Const SKIN_SOFTWARE = 2
Const SKIN_HARDWARE = 1

' Light sources types
Const LIGHT_DIRECTIONAL = 1
Const LIGHT_POINT       = 2
Const LIGHT_SPOT        = 3

' Texture filtering
Const TF_NONE           = 0
Const TF_POINT          = 1
Const TF_LINEAR         = 2
Const TF_ANISOTROPIC    = 3
Const TF_ANISOTROPICX4  = 4
Const TF_ANISOTROPICX8  = 5
Const TF_ANISOTROPICX16 = 6

' PixelShader versions
Const PS_1_1 = 0
Const PS_1_2 = 1
Const PS_1_3 = 2
Const PS_1_4 = 3
Const PS_2_0 = 4
Const PS_3_0 = 5

' VertexShader versions
Const VS_1_1 = 0
Const VS_2_0 = 1
Const VS_3_0 = 2

' Matrix semantics
Const WORLD                         = 0
Const WORLDVIEWPROJ                 = 1
Const VIEWPROJ                      = 2
Const VIEW                          = 3
Const PROJ                          = 4
Const WORLDVIEW                     = 5
Const VIEWINVERSE                   = 6
Const WORLDINVERSETRANSPOSE         = 15
Const WORLDINVERSE                  = 16
Const WORLDTRANSPOSE                = 17
Const VIEWPROJINVERSE               = 18
Const VIEWPROJINVERSETRANSPOSE      = 19
Const VIEWTRANSPOSE                 = 20
Const VIEWINVRSETRANSPOSE           = 21
Const PROJINVERSE                   = 22
Const PROJTRANSPOSE                 = 23
Const PROJINVRSETRANSPOSE           = 24
Const WORLDVIEWPROJTRANSPOSE        = 25
Const WORLDVIEWPROJINVERSE          = 26
Const WORLDVIEWPROJINVERSETRANSPOSE = 27
Const WORLDVIEWTRANSPOSE            = 28
Const WORLDVIEWINVERSE              = 29
Const WORLDVIEWINVERSETRANSPOSE     = 30

' Antialiasing types
Const AANONE      = 0
Const AA2SAMPLES  = 1
Const AA3SAMPLES  = 2
Const AA4SAMPLES  = 3
Const AA5SAMPLES  = 4
Const AA6SAMPLES  = 5
Const AA7SAMPLES  = 6
Const AA8SAMPLES  = 7
Const AA9SAMPLES  = 8
Const AA10SAMPLES = 9
Const AA11SAMPLES = 10
Const AA12SAMPLES = 11
Const AA13SAMPLES = 12
Const AA14SAMPLES = 13
Const AA15SAMPLES = 14
Const AA16SAMPLES = 15

' Camera fog mode
Const FOG_NONE     = 0
Const FOG_LINEAR   = 1

' Camera projection mode
Const PROJ_DISABLE      = 0
Const PROJ_PERSPECTIVE	= 1
Const PROJ_ORTHOGRAPHIC = 2

' Entity FX flags
Const FX_NOTHING        = 0
Const FX_FULLBRIGHT     = 1
Const FX_VERTEXCOLOR    = 2
Const FX_FLATSHADED     = 4
Const FX_DISABLEFOG     = 8
Const FX_DISABLECULLING = 16
Const FX_NOALPHABLEND   = 32

' Entity blending modes
Const BLEND_ALPHA       = 1
Const BLEND_MULTIPLY    = 2
Const BLEND_ADD         = 3
Const BLEND_PUREADD     = 4

' Compare functions
Const CMP_NEVER         = 1
Const CMP_LESS          = 2
Const CMP_EQUAL         = 3
Const CMP_LESSEQUAL     = 4
Const CMP_GREATER       = 5
Const CMP_NOTEQUAL      = 6
Const CMP_GREATEREQUAL  = 7
Const CMP_ALWAYS        = 8

' Axis
Const AXIS_X    = 1
Const AXIS_Y    = 2
Const AXIS_Z    = 3

' Texture loading flags
Const FLAGS_COLOR             = 1
Const FLAGS_ALPHA             = 2
Const FLAGS_MASKED            = 4
Const FLAGS_MIPMAPPED         = 8
Const FLAGS_CLAMPU            = 16
Const FLAGS_CLAMPV            = 32
Const FLAGS_SPHERICALENVMAP   = 64
Const FLAGS_CUBICENVMAP       = 128
Const FLAGS_R32F              = 256
Const FLAGS_SKIPCACHE         = 512
Const FLAGS_VOLUMETEXTURE     = 1024
Const FLAGS_ARBG16F           = 2048
Const FLAGS_ARBG32F           = 4096

' Texture blending modes
Const TEXBLEND_NONE          = 0
Const TEXBLEND_ALPHA         = 1
Const TEXBLEND_MULTIPLY      = 2
Const TEXBLEND_ADD           = 3
Const TEXBLEND_DOT3          = 4
Const TEXBLEND_LIGHTMAP      = 5
Const TEXBLEND_SEPARATEALPHA = 6

' Cube map faces
Const FACE_LEFT     = 0
Const FACE_FORWARD  = 1
Const FACE_RIGHT    = 2
Const FACE_BACKWARD = 3
Const FACE_UP       = 4
Const FACE_DOWN     = 5

' Entity animation types
Const ANIMATION_STOP      = 0
Const ANIMATION_LOOP      = 1
Const ANIMATION_PINGPONG  = 2
Const ANIMATION_ONE       = 3

' Collision types
Const SPHERETOSPHERE  = 1
Const SPHERETOBOX     = 3
Const SPHERETOTRIMESH = 2

' Collision respones types
Const RESPONSE_STOP             = 1
Const RESPONSE_SLIDING          = 2
Const RESPONSE_SLIDING_DOWNLOCK = 3

' Entity picking modes
Const PICK_NONE     = 0
Const PICK_SPHERE   = 1
Const PICK_TRIMESH  = 2
Const PICK_BOX      = 3

' Sprite view modes
Const SPRITE_FIXED    = 1
Const SPRITE_FREE     = 2
Const SPRITE_FREEROLL = 3
Const SPRITE_FIXEDYAW = 4

' Joystick types
Const JOY_NONE    = 0
Const JOY_DIGITAL = 1
Const JOY_ANALOG  = 2

' Cubemap rendering modes
Const CUBEMAP_SPECULAR   = 1
Const CUBEMAP_DIFFUSE    = 2
Const CUBEMAP_REFRACTION = 3

' Shadow's blur levels
Const SHADOWS_BLUR_NONE = 0
Const SHADOWS_BLUR_3    = 1
Const SHADOWS_BLUR_5    = 2
Const SHADOWS_BLUR_7    = 3
Const SHADOWS_BLUR_11   = 4
Const SHADOWS_BLUR_13   = 5


' primitives types
Const PRIMITIVE_POINTLIST     = 1
Const PRIMITIVE_LINELIST      = 2
Const PRIMITIVE_LINESTRIP     = 3
Const PRIMITIVE_TRIANGLELIST  = 4
Const PRIMITIVE_TRIANGLESTRIP = 5
Const PRIMITIVE_TRIANGLEFAN   = 6

' line separator types
Const LS_NUL	= 0
Const LS_CR		= 1
Const LS_LF		= 2
Const LS_CRLF	= 3

' physics: joint types
Const JOINT_POINT2POINT	= 0
Const JOINT_6DOF		= 1
Const JOINT_6DOFSPRING	= 2
Const JOINT_HINGE		= 3

' physics: debug drawer modes
Const PXDD_NO           = 0
Const PXDD_WIREFRAME    = 1
Const PXDD_AABB         = 2
Const PXDD_CONTACTS     = 4
Const PXDD_JOINTS       = 8
Const PXDD_JOINT_LIMITS = 16
Const PXDD_NO_AXIS      = 32

' physics: ray casting modes
Const PXRC_SINGLE   = 0
Const PXRC_MULTIPLE = 1

' 3dlines commands
Rem
	bbdoc:
EndRem
Global xCreateLine3D_%(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, red%, green%, blue%, alpha%, useZBuffer%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DOrigin_(line3d%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DAddNode_(line3d%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DColor(line3d%, red%, green%, blue%, alpha%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DUseZBuffer(line3d%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DOriginX_#(line3d%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DOriginY_#(line3d%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DOriginZ_#(line3d%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DNodesCount%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DNodePosition_(line3d%, index%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DNodeX_#(line3d%, index%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DNodeY_#(line3d%, index%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DNodeZ_#(line3d%, index%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DRed%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DGreen%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DBlue%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xLine3DAlpha%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xGetLine3DUseZBuffer%(line3d%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteLine3DNode(line3d%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xClearLine3D(line3d%) "win32"

' brushes commands
Rem
	bbdoc:
EndRem
Global xLoadBrush_%(path$z, flags%, xScale#, yScale#) "win32"
Rem
	bbdoc:
EndRem
Global xCreateBrush_%(red#, green#, blue#) "win32"
Rem
	bbdoc:
EndRem
Global xFreeBrush(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushTexture_%(brush%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xBrushColor(brush%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xBrushAlpha(brush%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xBrushShininess(brush%, shininess#) "win32"
Rem
	bbdoc:
EndRem
Global xBrushBlend(brush%, blend%) "win32"
Rem
	bbdoc:
EndRem
Global xBrushFX(brush%, FX%) "win32"
Rem
	bbdoc:
EndRem
Global xBrushTexture_(brush%, texture%, frame%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushName$z(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xBrushName(brush%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushAlpha#(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushBlend%(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushRed%(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushGreen%(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushBlue%(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushFX%(brush%) "win32"
Rem
	bbdoc:
EndRem
Global xGetBrushShininess#(brush%) "win32"

' cameras commands
Rem
	bbdoc:
EndRem
Global xCameraFogMode(camera%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraFogColor(camera%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraFogRange(camera%, nearRange#, farRange#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraClsColor_(camera%, red%, green%, blue%, alpha%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraProjMode(camera%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraClsMode(camera%, clearColor%, clearZBuffer%) "win32"
Rem
	bbdoc:
EndRem
Global xSphereInFrustum%(camera%, x#, y#, z#, radii#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraClipPlane(camera%, index%, enabled%, a#, b#, c#, d#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraRange(camera%, nearRange#, farRange#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraViewport(camera%, x%, y%, width%, height%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraCropViewport(camera%, x%, y%, width%, height%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateCamera_%(parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraProject(camera%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraProject2D(camera%, x%, y%, zDistance#) "win32"
Rem
	bbdoc:
EndRem
Global xProjectedX#() "win32"
Rem
	bbdoc:
EndRem
Global xProjectedY#() "win32"
Rem
	bbdoc:
EndRem
Global xProjectedZ#() "win32"
Rem
	bbdoc:
EndRem
Global xGetViewMatrix%(camera%) "win32"
Rem
	bbdoc:
EndRem
Global xGetProjectionMatrix%(camera%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraZoom(camera%, zoom#) "win32"
Rem
	bbdoc:
EndRem
Global xGetViewProjMatrix%(camera%) "win32"

' collisions commands
Rem
	bbdoc:
EndRem
Global xCollisions(srcType%, destType%, collideMethod%, response%) "win32"
Rem
	bbdoc:
EndRem
Global xClearCollisions() "win32"
Rem
	bbdoc:
EndRem
Global xResetEntity(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityRadius_(entity%, xRadius#, yRadius#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityBox(entity%, x#, y#, z#, width#, height#, depth#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityType_(entity%, typeID%, recurse%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCollided%(entity%, typeID%) "win32"
Rem
	bbdoc:
EndRem
Global xCountCollisions%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionX#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionY#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionZ#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionNX#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionNY#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionNZ#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionTime#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionEntity%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionSurface%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCollisionTriangle%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityType%(entity%) "win32"

' constants commands
Rem
	bbdoc:
EndRem
Global xRenderPostEffect(poly%) "win32"
Rem
	bbdoc:
EndRem
Global xCreatePostEffectPoly%(camera%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xGetFunctionAddress%(name$z) "win32"

' effects commands
Rem
	bbdoc:
EndRem
Global xLoadFXFile%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFreeEffect(effect%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEntityEffect_(entity%, effect%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xSetSurfaceEffect_(surface%, effect%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xSetBonesArrayName_(entity%, arrayName$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceBonesArrayName_(surface%, arrayName$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectInt_(entity%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectInt_(surface%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectFloat_(entity%, name$z, value#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectFloat_(surface%, name$z, value#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectBool_(entity%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectBool_(surface%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectVector_(entity%, name$z, x#, y#, z#, w#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectVector_(surface%, name$z, x#, y#, z#, w#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectVectorArray_(entity%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectVectorArray_(surface%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectMatrixArray_(surface%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectFloatArray_(surface%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectIntArray_(surface%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectMatrixArray_(entity%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectFloatArray_(entity%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectIntArray_(entity%, name$z, value%, count%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateBufferVectors%(count%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferVectorsSetElement(buffer%, number%, x#, y#, z#, w#) "win32"
Rem
	bbdoc:
EndRem
Global xCreateBufferMatrix%(count%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferMatrixSetElement(buffer%, number%, matrix%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferMatrixGetElement%(buffer%, number%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateBufferFloats%(count%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferFloatsSetElement(buffer%, number%, value#) "win32"
Rem
	bbdoc:
EndRem
Global xBufferFloatsGetElement#(buffer%, number%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferDelete(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectMatrixWithElements_(entity%, name$z, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectMatrix_(entity%, name$z, matrix%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectMatrix_(surface%, name$z, matrix%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectMatrixWithElements_(surface%, name$z, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectEntityTexture_(entity%, name$z, index%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectTexture_(entity%, name$z, texture%, frame%, layer%, isRecursive%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectTexture_(surface%, name$z, texture%, frame%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceEffectMatrixSemantic_(surface%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectMatrixSemantic_(entity%, name$z, value%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteSurfaceConstant_(surface%, name$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteEffectConstant_(entity%, name$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xClearSurfaceConstants_(surface%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xClearEffectConstants_(entity%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEffectTechnique_(entity%, name$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceTechnique_(surface%, name$z, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xValidateEffectTechnique%(effect%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetEntityShaderLayer(entity%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityShaderLayer%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xSetSurfaceShaderLayer(surface%, layer%) "win32"
Rem
	bbdoc:
EndRem
Global xGetSurfaceShaderLayer%(surface%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXInt(effect%, name$z, value%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXFloat(effect%, name$z, value#) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXBool(effect%, name$z, value%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXVector_(effect%, name$z, x#, y#, z#, w#) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXVectorArray(effect%, name$z, value%, count%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXMatrixArray(effect%, name$z, value%, count%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXFloatArray(effect%, name$z, value%, count%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXIntArray(effect%, name$z, value%, count%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXEntityMatrix(effect%, name$z, matrix%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXTexture_(effect%, name$z, texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXMatrixSemantic(effect%, name$z, value%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteFXConstant(effect%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xClearFXConstants(effect%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFXTechnique(effect%, name$z) "win32"

' emitters commands
Rem
	bbdoc:
EndRem
Global xCreateEmitter_%(psystem%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterEnable(emitter%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterEnabled%(emitter%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterGetPSystem%(emitter%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterAddParticle%(emitter%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterFreeParticle(emitter%, particle%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterValidateParticle%(emitter%, particle%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterCountParticles%(emitter%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterGetParticle%(emitter%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitterAlive%(emitter%) "win32"

' entity_animation commands
Rem
	bbdoc:
EndRem
Global xExtractAnimSeq_%(entity%, firstFrame%, lastFrame%, sequence%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadAnimSeq%(entity%, path$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetAnimSpeed_(entity%, speed#, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimSpeed_#(entity%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimating_%(entity%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimTime_#(entity%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimate_(entity%, mode%, speed#, sequence%, translate#, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimSeq_%(entity%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xAnimLength_#(entity%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetAnimTime_(entity%, time#, sequence%, rootBone$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetAnimFrame_(entity%, frame#, sequence%, rootBone$z) "win32"

' entity_control commands
Rem
	bbdoc:
EndRem
Global xEntityAutoFade(entity%, nearRange#, farRange#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityOrder(entity%, order%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeEntity(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyEntity_%(entity%, parent%, cloneBuffers%) "win32"
Rem
	bbdoc:
EndRem
Global xPaintEntity(entity%, brush%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityShininess(entity%, shininess#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityPickMode_(entity%, mode%, obscurer%, recursive%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityTexture_(entity%, texture%, frame%, index%, isRecursive%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityFX(entity%, fx%) "win32"
Rem
	bbdoc:
EndRem
Global xGetParent%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFrustumSphere(entity%, x#, y#, z#, radii#) "win32"
Rem
	bbdoc:
EndRem
Global xCalculateFrustumVolume(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityParent_(entity%, parent%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xShowEntity(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xHideEntity(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xNameEntity(entity%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetEntityQuaternion(entity%, quaternion%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEntityMatrix(entity%, matrix%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAlpha(entity%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityColor(entity%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySpecularColor(entity%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAmbientColor(entity%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityEmissiveColor(entity%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityBlend(entity%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAlphaRef(entity%, value%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAlphaFunc(entity%, value%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateInstance_%(entity%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xFreezeInstances_(entity%, enable%) "win32"
Rem
	bbdoc:
EndRem
Global xInstancingAvaliable%() "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityWorld%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xSetEntityWorld(entity%, world%) "win32"

' entity_movement commands
Rem
	bbdoc:
EndRem
Global xScaleEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xPositionEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xMoveEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xTranslateEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xRotateEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xTurnEntity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xPointEntity_(entity1%, entity2%, roll#) "win32"
Rem
	bbdoc:
EndRem
Global xAlignToVector_(entity%, x#, y#, z#, axis%, factor#) "win32"

' entity_state commands
Rem
	bbdoc:
EndRem
Global xEntityDistance#(entity1%, entity2%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMatElement#(entity%, row%, col%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityClass$z(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityBrush%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityX_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityY_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityZ_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityVisible%(entity%, destination%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityScaleX#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityScaleY#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityScaleZ#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityRoll_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityYaw_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityPitch_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityName$z(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xCountChildren%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetChild%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityInView%(entity%, camera%) "win32"
Rem
	bbdoc:
EndRem
Global xFindChild%(entity%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityMatrix%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityAlpha#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetAlphaRef%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetAlphaFunc%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityRed%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGreen%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityBlue%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityShininess#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityBlend%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetEntityFX%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityHidden%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitiesBBIntersect%(entity1%, entity2%) "win32"

' filesystems commands
Rem
	bbdoc:
EndRem
Global xMountPackFile_%(path$z, mountpoint$z, password$z) "win32"
Rem
	bbdoc:
EndRem
Global xUnmountPackFile(packfile%) "win32"
Rem
	bbdoc:
EndRem
Global xOpenFile%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xReadFile%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xWriteFile%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xCloseFile(file%) "win32"
Rem
	bbdoc:
EndRem
Global xFilePos%(file%) "win32"
Rem
	bbdoc:
EndRem
Global xSeekFile(file%, offset%) "win32"
Rem
	bbdoc:
EndRem
Global xFileType%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFileSize%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFileCreationTime%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFileCreationTimeStr$z(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFileModificationTime%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFileModificationTimeStr$z(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xReadDir%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xCloseDir(handle%) "win32"
Rem
	bbdoc:
EndRem
Global xNextFile$z(handle%) "win32"
Rem
	bbdoc:
EndRem
Global xCurrentDir$z() "win32"
Rem
	bbdoc:
EndRem
Global xChangeDir(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xCreateDir%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteDir%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xCopyFile%(pathSrc$z, pathDest$z) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteFile%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xEof%(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadByte%(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadShort%(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadInt%(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadFloat#(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadString$z(file%) "win32"
Rem
	bbdoc:
EndRem
Global xReadLine_$z(file%, ls_flag%) "win32"
Rem
	bbdoc:
EndRem
Global xWriteByte(file%, value%) "win32"
Rem
	bbdoc:
EndRem
Global xWriteShort(file%, value%) "win32"
Rem
	bbdoc:
EndRem
Global xWriteInt(file%, value%) "win32"
Rem
	bbdoc:
EndRem
Global xWriteFloat(file%, value#) "win32"
Rem
	bbdoc:
EndRem
Global xWriteString(file%, value$z) "win32"
Rem
	bbdoc:
EndRem
Global xWriteLine_(file%, value$z, ls_flag%) "win32"

' fonts commands
Rem
	bbdoc:
EndRem
Global xLoadFont_%(name$z, height%, bold%, italic%, underline%, fontface$z) "win32"
Rem
	bbdoc:
EndRem
Global xText_(x#, y#, textString$z, centerx%, centery%) "win32"
Rem
	bbdoc:
EndRem
Global xSetFont(font%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeFont(font%) "win32"
Rem
	bbdoc:
EndRem
Global xFontWidth%() "win32"
Rem
	bbdoc:
EndRem
Global xFontHeight%() "win32"
Rem
	bbdoc:
EndRem
Global xStringWidth%(textString$z) "win32"
Rem
	bbdoc:
EndRem
Global xStringHeight%(textString$z) "win32"

' graphics commands
Rem
	bbdoc:
EndRem
Global xWinMessage%(message$z) "win32"
Rem
	bbdoc:
EndRem
Global xGetMaxPixelShaderVersion%() "win32"
Rem
	bbdoc:
EndRem
Global xLine(x1%, y1%, x2%, y2%) "win32"
Rem
	bbdoc:
EndRem
Global xRect_(x%, y%, width%, height%, solid%) "win32"
Rem
	bbdoc:
EndRem
Global xRectsOverlap%(x1%, y1%, width1%, height1%, x2%, y2%, width2%, height2%) "win32"
Rem
	bbdoc:
EndRem
Global xViewport(x%, y%, width%, height%) "win32"
Rem
	bbdoc:
EndRem
Global xOval_(x%, y%, width%, height%, solid%) "win32"
Rem
	bbdoc:
EndRem
Global xOrigin(x%, y%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMaxVertexShaderVersion%() "win32"
Rem
	bbdoc:
EndRem
Global xGetMaxAntiAlias%() "win32"
Rem
	bbdoc:
EndRem
Global xGetMaxTextureFiltering%() "win32"
Rem
	bbdoc:
EndRem
Global xSetAntiAliasType(typeID%) "win32"
Rem
	bbdoc:
EndRem
Global xAppTitle(title$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetWND(window%) "win32"
Rem
	bbdoc:
EndRem
Global xSetRenderWindow(window%) "win32"
Rem
	bbdoc:
EndRem
Global xSetTopWindow(window%) "win32"
Rem
	bbdoc:
EndRem
Global xDestroyRenderWindow() "win32"
Rem
	bbdoc:
EndRem
Global xFlip() "win32"
Rem
	bbdoc:
EndRem
Global xBackBuffer%() "win32"
Rem
	bbdoc:
EndRem
Global xLockBuffer_(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xUnlockBuffer_(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xWritePixelFast_(x%, y%, argb%, buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xReadPixelFast_%(x%, y%, buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xGetPixels_%(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xSaveBuffer(buffer%, path$z) "win32"
Rem
	bbdoc:
EndRem
Global xGetCurrentBuffer%() "win32"
Rem
	bbdoc:
EndRem
Global xBufferWidth_%(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xBufferHeight_%(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xCatchTimestamp%() "win32"
Rem
	bbdoc:
EndRem
Global xGetElapsedTime#(timeStamp%) "win32"
Rem
	bbdoc:
EndRem
Global xSetBuffer_(buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xSetMRT(buffer%, frame%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xUnSetMRT() "win32"
Rem
	bbdoc:
EndRem
Global xGetNumberRT%() "win32"
Rem
	bbdoc:
EndRem
Global xTextureBuffer_%(texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadBuffer(buffer%, path$z) "win32"
Rem
	bbdoc:
EndRem
Global xWritePixel_(x%, y%, argb%, buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyPixel(sx%, sy%, sourceBuffer%, dx%, dy%, destinationBuffer%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyPixelFast(sx%, sy%, sourceBuffer%, dx%, dy%, destinationBuffer%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyRect(sx%, sy%, sw%, sh%, dx%, dy%, sourceBuffer%, destinationBuffer%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsBuffer%() "win32"
Rem
	bbdoc:
EndRem
Global xGetColor%(x%, y%) "win32"
Rem
	bbdoc:
EndRem
Global xReadPixel_%(x%, y%, buffer%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsWidth_%(isVirtual%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsHeight_%(isVirtual%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsDepth%() "win32"
Rem
	bbdoc:
EndRem
Global xColorAlpha%() "win32"
Rem
	bbdoc:
EndRem
Global xColorRed%() "win32"
Rem
	bbdoc:
EndRem
Global xColorGreen%() "win32"
Rem
	bbdoc:
EndRem
Global xColorBlue%() "win32"
Rem
	bbdoc:
EndRem
Global xClsColor_(red%, green%, blue%, alpha%) "win32"
Rem
	bbdoc:
EndRem
Global xClearWorld_(entities%, brushes%, textures%) "win32"
Rem
	bbdoc:
EndRem
Global xColor_(red%, green%, blue%, alpha%) "win32"
Rem
	bbdoc:
EndRem
Global xCls() "win32"
Rem
	bbdoc:
EndRem
Global xUpdateWorld_(speed#) "win32"
Rem
	bbdoc:
EndRem
Global xRenderEntity_(camera%, entity%, tween#) "win32"
Rem
	bbdoc:
EndRem
Global xRenderWorld_(tween#, renderShadows%) "win32"
Rem
	bbdoc:
EndRem
Global xSetAutoTB(flag%) "win32"
Rem
	bbdoc:
EndRem
Global xMaxClipPlanes%() "win32"
Rem
	bbdoc:
EndRem
Global xWireframe(state%) "win32"
Rem
	bbdoc:
EndRem
Global xDither(state%) "win32"
Rem
	bbdoc:
EndRem
Global xSetSkinningMethod(skinMethod%) "win32"
Rem
	bbdoc:
EndRem
Global xTrisRendered%() "win32"
Rem
	bbdoc:
EndRem
Global xDIPCounter%() "win32"
Rem
	bbdoc:
EndRem
Global xSurfRendered%() "win32"
Rem
	bbdoc:
EndRem
Global xEntityRendered%() "win32"
Rem
	bbdoc:
EndRem
Global xAmbientLight_(red%, green%, blue%, world%) "win32"
Rem
	bbdoc:
EndRem
Global xGetFPS%() "win32"
Rem
	bbdoc:
EndRem
Global xAntiAlias(state%) "win32"
Rem
	bbdoc:
EndRem
Global xSetTextureFiltering(filter%) "win32"
Rem
	bbdoc:
EndRem
Global xStretchRect(texture1%, x1%, y1%, width1%, height1%, texture2%, x2%, y2%, width2%, height2%, filter%) "win32"
Rem
	bbdoc:
EndRem
Global xStretchBackBuffer(texture%, x%, y%, width%, height%, filter%) "win32"
Rem
	bbdoc:
EndRem
Global xGetDevice%() "win32"
Rem
	bbdoc:
EndRem
Global xReleaseGraphics() "win32"
Rem
	bbdoc:
EndRem
Global xShowPointer() "win32"
Rem
	bbdoc:
EndRem
Global xHidePointer() "win32"
Rem
	bbdoc:
EndRem
Global xCreateDSS(width%, height%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteDSS() "win32"
Rem
	bbdoc:
EndRem
Global xGridColor(centerRed%, centerGreen%, centerBlue%, gridRed%, gridGreen%, gridBlue%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawGrid(x#, z#, gridSize%, range%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawBBox(draw%, zOn%, red%, green%, blue%, alpha%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphics3D_(width%, height%, depth%, mode%, vsync%) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsAspectRatio(aspectRatio#) "win32"
Rem
	bbdoc:
EndRem
Global xGraphicsBorderColor(red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xGetRenderWindow%() "win32"
Rem
	bbdoc:
EndRem
Global xKey(key$z) "win32"
Rem
	bbdoc:
EndRem
Global xSetEngineSetting(parameter$z, value$z) "win32"
Rem
	bbdoc:
EndRem
Global xGetEngineSetting$z(parameter$z) "win32"
Rem
	bbdoc:
EndRem
Global xHWInstancingAvailable%() "win32"
Rem
	bbdoc:
EndRem
Global xShaderInstancingAvailable%() "win32"
Rem
	bbdoc:
EndRem
Global xSetShaderLayer(layer%) "win32"
Rem
	bbdoc:
EndRem
Global xGetShaderLayer%() "win32"
Rem
	bbdoc:
EndRem
Global xDrawMovementGizmo_(x#, y#, z#, selectMask%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawScaleGizmo_(x#, y#, z#, selectMask%, sx#, sy#, sz#) "win32"
Rem
	bbdoc:
EndRem
Global xDrawRotationGizmo_(x#, y#, z#, selectMask%, pitch#, yaw#, roll#) "win32"
Rem
	bbdoc:
EndRem
Global xCheckMovementGizmo%(x#, y#, z#, camera%, mx%, my%) "win32"
Rem
	bbdoc:
EndRem
Global xCheckScaleGizmo%(x#, y#, z#, camera%, mx%, my%) "win32"
Rem
	bbdoc:
EndRem
Global xCheckRotationGizmo%(x#, y#, z#, camera%, mx%, my%) "win32"
Rem
	bbdoc:
EndRem
Global xCaptureWorld() "win32"
Rem
	bbdoc:
EndRem
Global xCountGfxModes%() "win32"
Rem
	bbdoc:
EndRem
Global xGfxModeWidth%(mode%) "win32"
Rem
	bbdoc:
EndRem
Global xGfxModeHeight%(mode%) "win32"
Rem
	bbdoc:
EndRem
Global xGfxModeDepth%(mode%) "win32"
Rem
	bbdoc:
EndRem
Global xGfxModeExists%(width%, height%, depth%) "win32"
Rem
	bbdoc:
EndRem
Global xAppWindowFrame(state%) "win32"
Rem
	bbdoc:
EndRem
Global xMillisecs%() "win32"
Rem
	bbdoc:
EndRem
Global xDeltaTime_%(fromInit%) "win32"
Rem
	bbdoc:
EndRem
Global xDeltaValue_#(value#, time%) "win32"
Rem
	bbdoc:
EndRem
Global xAddDeviceLostCallback(func%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteDeviceLostCallback(func%) "win32"
Rem
	bbdoc:
EndRem
Global xDeinit() "win32"

' images commands
Rem
	bbdoc:
EndRem
Global xImageColor(image%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xImageAlpha(image%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xImageBuffer_%(image%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateImage_%(width%, height%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xGrabImage_(image%, x%, y%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeImage(image%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadImage%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xLoadAnimImage%(path$z, width%, height%, startFrame%, frames%) "win32"
Rem
	bbdoc:
EndRem
Global xSaveImage_(image%, path$z, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawImage_(image%, x#, y#, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawImageRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xScaleImage(image%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xResizeImage(image%, width#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xRotateImage(image%, angle#) "win32"
Rem
	bbdoc:
EndRem
Global xImageAngle#(image%) "win32"
Rem
	bbdoc:
EndRem
Global xImageWidth%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xImageHeight%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xImagesCollide%(image1%, x1%, y1%, frame1%, image2%, x2%, y2%, frame2%) "win32"
Rem
	bbdoc:
EndRem
Global xImageRectCollide%(image%, x%, y%, frame%, rectx%, recty%, rectWidth%, rectHeight%) "win32"
Rem
	bbdoc:
EndRem
Global xImageRectOverlap%(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#) "win32"
Rem
	bbdoc:
EndRem
Global xImageXHandle%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xImageYHandle%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xHandleImage(image%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xMidHandle(image%) "win32"
Rem
	bbdoc:
EndRem
Global xAutoMidHandle(state%) "win32"
Rem
	bbdoc:
EndRem
Global xTileImage_(image%, x#, y#, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xImagesOverlap%(image1%, x1#, y1#, image2%, x2#, y2#) "win32"
Rem
	bbdoc:
EndRem
Global xMaskImage(image%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyImage%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawBlock_(image%, x#, y#, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawBlockRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xImageActualWidth%(image%) "win32"
Rem
	bbdoc:
EndRem
Global xImageActualHeight%(image%) "win32"

' inputs commands
Rem
	bbdoc:
EndRem
Global xFlushKeys() "win32"
Rem
	bbdoc:
EndRem
Global xFlushMouse() "win32"
Rem
	bbdoc:
EndRem
Global xKeyHit%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xKeyUp%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xWaitKey() "win32"
Rem
	bbdoc:
EndRem
Global xMouseHit%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xKeyDown%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xGetKey%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseDown%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xMouseUp%(key%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMouse%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseX%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseY%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseZ%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseXSpeed%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseYSpeed%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseZSpeed%() "win32"
Rem
	bbdoc:
EndRem
Global xMouseSpeed%() "win32"
Rem
	bbdoc:
EndRem
Global xMoveMouse(x%, y%) "win32"

' joysticks commands
Rem
	bbdoc:
EndRem
Global xJoyType_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyDown_%(key%, portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyHit_%(key%, portID%) "win32"
Rem
	bbdoc:
EndRem
Global xGetJoy_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xFlushJoy() "win32"
Rem
	bbdoc:
EndRem
Global xWaitJoy_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyX_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyY_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyZ_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyU_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyV_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyPitch_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyYaw_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyRoll_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyHat_#(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyXDir_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyYDir_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyZDir_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyUDir_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xJoyVDir_%(portID%) "win32"
Rem
	bbdoc:
EndRem
Global xCountJoys%() "win32"

' lights commands
Rem
	bbdoc:
EndRem
Global xCreateLight_%(typeID%) "win32"
Rem
	bbdoc:
EndRem
Global xLightShadowEpsilons(light%, epsilon1#, epsilon2#) "win32"
Rem
	bbdoc:
EndRem
Global xLightEnableShadows(light%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xLightShadowsEnabled%(light%) "win32"
Rem
	bbdoc:
EndRem
Global xLightRange(light%, range#) "win32"
Rem
	bbdoc:
EndRem
Global xLightColor(light%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xLightConeAngles(light%, inner#, outer#) "win32"

' logging commands
Rem
	bbdoc:
EndRem
Global xCreateLog_%(target%, level%, filename$z, cssfilename$z) "win32"
Rem
	bbdoc:
EndRem
Global xCloseLog%() "win32"
Rem
	bbdoc:
EndRem
Global xGetLogString$z() "win32"
Rem
	bbdoc:
EndRem
Global xClearLogString() "win32"
Rem
	bbdoc:
EndRem
Global xSetLogLevel_(level%) "win32"
Rem
	bbdoc:
EndRem
Global xSetLogTarget_(target%) "win32"
Rem
	bbdoc:
EndRem
Global xGetLogLevel%() "win32"
Rem
	bbdoc:
EndRem
Global xGetLogTarget%() "win32"
Rem
	bbdoc:
EndRem
Global xLogInfo_(message$z, func$z, file$z, line%) "win32"
Rem
	bbdoc:
EndRem
Global xLogMessage_(message$z, func$z, file$z, line%) "win32"
Rem
	bbdoc:
EndRem
Global xLogWarning_(message$z, func$z, file$z, line%) "win32"
Rem
	bbdoc:
EndRem
Global xLogError_(message$z, func$z, file$z, line%) "win32"
Rem
	bbdoc:
EndRem
Global xLogFatal_(message$z, func$z, file$z, line%) "win32"

' meshes commands
Rem
	bbdoc:
EndRem
Global xCreateMesh_%(parent%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadMesh_%(path$z, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadMeshWithChild_%(path$z, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadAnimMesh_%(path$z, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateCube_%(parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateSphere_%(segments%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateCylinder_%(segments%, solid%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateTorus_%(segments%, R#, r_tube#, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateCone_%(segments%, solid%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCopyMesh_%(entity%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xAddMesh(source%, destination%) "win32"
Rem
	bbdoc:
EndRem
Global xFlipMesh(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xPaintMesh(entity%, brush%) "win32"
Rem
	bbdoc:
EndRem
Global xFitMesh_(entity%, x#, y#, z#, width#, height#, depth#, uniform%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshWidth_#(entity%, recursive%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshHeight_#(entity%, recursive%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshDepth_#(entity%, recursive%) "win32"
Rem
	bbdoc:
EndRem
Global xScaleMesh(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xRotateMesh(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xPositionMesh(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xUpdateNormals(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xUpdateN(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xUpdateTB(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshesBBIntersect%(entity1%, entity2%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshesIntersect%(entity1%, entity2%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMeshVB%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMeshIB%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMeshVBSize%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetMeshIBSize%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteMeshVB(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xDeleteMeshIB(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xCountSurfaces%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xGetSurface%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCreatePivot_%(parent%) "win32"
Rem
	bbdoc:
EndRem
Global xFindSurface%(entity%, brush%) "win32"
Rem
	bbdoc:
EndRem
Global xCreatePoly_%(sides%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xMeshSingleSurface(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xSaveMesh%(entity%, path$z) "win32"
Rem
	bbdoc:
EndRem
Global xLightMesh_(entity%, red%, green%, blue%, range#, lightX#, lightY#, lightZ#) "win32"
Rem
	bbdoc:
EndRem
Global xMeshPrimitiveType(entity%, ptype%) "win32"

' particles commands
Rem
	bbdoc:
EndRem
Global xParticlePosition(particle%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleX#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleY#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleZ#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleVeclocity(particle%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleVX#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleVY#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleVZ#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleRotation(particle%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xParticlePitch#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleYaw#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleRoll#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleTorque(particle%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleTPitch#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleTYaw#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleTRoll#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleSetAlpha(particle%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleGetAlpha#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleColor(particle%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleRed#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleGreen#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleBlue#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleScale(particle%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleSX#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleSY#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleScaleSpeed(particle%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xParticleScaleSpeedX#(particle%) "win32"
Rem
	bbdoc:
EndRem
Global xParticleScaleSpeedY#(particle%) "win32"

' physics commands
Rem
	bbdoc:
EndRem
Global xEntityAddDummyShape(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddBoxShape_(entity%, mass#, width#, height#, depth#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddSphereShape_(entity%, mass#, radius#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddCapsuleShape_(entity%, mass#, radius#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddConeShape_(entity%, mass#, radius#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddCylinderShape_(entity%, mass#, width#, height#, depth#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddTriMeshShape(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddTriMeshShapeProxy(entity%, proxy%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddConvexShape(entity%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddConvexShapeProxy(entity%, proxy%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddConcaveShape(entity%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddConcaveShapeProxy(entity%, proxy%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddTerrainShape(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAttachBody(entity%, body%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityDetachBody%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeEntityBody(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddCompoundShape(entity%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundAddBox%(entity%, width#, height#, depth#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundAddSphere%(entity%, radius#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundAddCapsule%(entity%, radius#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundAddCone%(entity%, radius#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundAddCylinder%(entity%, radius#, height#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundCountChildren%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundRemoveChild(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildSetPosition(entity%, index%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetX#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetY#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetZ#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildSetRotation(entity%, index%, pitch#, yaw#, roll#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetPitch#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetYaw#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCompoundChildGetRoll#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateHingeJoint_%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, axisX#, axisY#, axisZ#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateBallJoint_%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateD6Joint_%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateD6SpringJoint_%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeGetAngle#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetPitchAngle#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetYawAngle#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetRollAngle#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngle_#(joint%, axis%) "win32"
Rem
	bbdoc:
EndRem
Global xJointDisableCollisions(joint%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xJointEnable(joint%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xJointIsEnabled%(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointGetImpulse#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeJoint(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointBallSetPivot_(joint%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xJointBallGetPivotX_#(joint%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xJointBallGetPivotY_#(joint%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xJointBallGetPivotZ_#(joint%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetLimits(joint%, axis%, lower#, upper#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetLowerLinearLimits(joint%, lowerX#, lowerY#, lowerZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetUpperLinearLimits(joint%, upperX#, upperY#, upperZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetLowerAngularLimits(joint%, lowerX#, lowerY#, lowerZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetUpperAngularLimits(joint%, upperX#, upperY#, upperZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetLinearLimits(joint%, lowerX#, lowerY#, lowerZ#, upperX#, upperY#, upperZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SetAngularLimits(joint%, lowerX#, lowerY#, lowerZ#, upperX#, upperY#, upperZ#) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearLowerX#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearLowerY#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearLowerZ#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearUpperX#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearUpperY#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetLinearUpperZ#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularLowerX#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularLowerY#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularLowerZ#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularUpperX#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularUpperY#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6GetAngularUpperZ#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointD6SpringSetParam_(joint%, index%, enabled%, damping#, stiffness#) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeSetAxis(joint%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeSetLimits_(joint%, lowerLimit#, upperLimit#, softness#, biasFactor#, relaxationFactor#) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeGetLowerLimit#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeGetUpperLimit#(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointEnableMotor_(joint%, enabled%, targetVelocity#, maxForce#, index%) "win32"
Rem
	bbdoc:
EndRem
Global xJointHingeSetMotorTarget(joint%, targetAngle#, deltaTime#) "win32"
Rem
	bbdoc:
EndRem
Global xJointGetEntityA%(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xJointGetEntityB%(joint%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyCentralForce_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyCentralImpulse_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyTorque_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyTorqueImpulse_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyForce_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityApplyImpulse_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityReleaseForces(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xWorldSetGravity_(x#, y#, z#, world%) "win32"
Rem
	bbdoc:
EndRem
Global xWorldGetGravityX_#(world%) "win32"
Rem
	bbdoc:
EndRem
Global xWorldGetGravityY_#(world%) "win32"
Rem
	bbdoc:
EndRem
Global xWorldGetGravityZ_#(world%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetGravity(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetGravityX#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetGravityY#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetGravityZ#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetLinearVelocity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearVelocityX_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearVelocityY_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearVelocityZ_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetAngularVelocity_(entity%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularVelocityX_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularVelocityY_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularVelocityZ_#(entity%, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetDamping(entity%, linear#, angular#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearDamping#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularDamping#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetFriction(entity%, friction#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetFriction#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetAnisotropicFriction(entity%, fx#, fy#, fz#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAnisotropicFrictionX#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAnisotropicFrictionY#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAnisotropicFrictionZ#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetLinearFactor(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearFactorX#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearFactorY#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearFactorZ#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetAngularFactor(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularFactorX#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularFactorY#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularFactorZ#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetRestitution(entity%, restitution#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetRestitution#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetMass(entity%, mass#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetMass#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCountContacts%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactX#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactY#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactZ#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactNX#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactNY#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactNZ#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactDistance#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContact%(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactImpulse#(entity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetCollisionGroup(entity%, group%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetCollisionGroup%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetContactGroup(entity%, group%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetContactGroup%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetRaycastGroup(entity%, group%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetRaycastGroup%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsSetCollisionFilter(group0%, group1%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetCollisionFilter%(group0%, group1%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsSetContactFilter(group0%, group1%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetContactFilter%(group0%, group1%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsSetRaycastFilter(rayGroup%, bodyGroup%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetRaycastFilter%(rayGroup%, bodyGroup%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityIsSleeping%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityDisableSleeping_(entity%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWakeUp(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySleep(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntitySetSleepingThresholds(entity%, linearThreshold#, angularThreshold#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetLinearSleepingThreshold#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityGetAngularSleepingThreshold#(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsRayCast_(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, rcType%, rayGroup%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitEntity_%(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitPointX_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitPointY_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitPointZ_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitNormalX_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitNormalY_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitNormalZ_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsGetHitDistance_#(index%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsCountHits%() "win32"
Rem
	bbdoc:
EndRem
Global xEntityBodyLocalPosition(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityBodyLocalRotation(entity%, pitch#, yaw#, roll#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityBodyLocalScale(entity%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xWorldSetFrequency_(frequency#, world%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityMakeKinematic(entity%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityIsKinematic%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xPhysicsDebugRender(state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityDisableSimulation(entity%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityHasBody%(entity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCreateVehicle(chassisEntity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityFreeVehicle(chassisEntity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCountWheels%(chassisEntity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityAddWheel%(chassisEntity%, wheelEntity%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetRadius(chassisEntity%, index%, radius#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetAxle(chassisEntity%, index%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetRay(chassisEntity%, index%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetSuspensionLength(chassisEntity%, index%, length#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetBrake(chassisEntity%, index%, brake#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetMaxSuspensionForce(chassisEntity%, index%, force#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetMaxSuspensionTravel(chassisEntity%, index%, travel#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetSuspensionStiffness(chassisEntity%, index%, stiffness#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetSuspensionDamping(chassisEntity%, index%, damping#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetSuspensionCompression(chassisEntity%, index%, compression#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetFriction(chassisEntity%, index%, friction#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetEngineForce(chassisEntity%, index%, force#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetRollInfluence(chassisEntity%, index%, roll#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetRotation(chassisEntity%, index%, rotation#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetSteering(chassisEntity%, index%, steering#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelSetConnectionPoint_(chassisEntity%, index%, x#, y#, z#, isGlobal%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelGetSuspensionLength#(chassisEntity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelGetPitch#(chassisEntity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelGetYaw#(chassisEntity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelGetRoll#(chassisEntity%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityWheelGetContactEntity%(chassisEntity%, index%) "win32"

' posteffects commands
Rem
	bbdoc:
EndRem
Global xLoadPostEffect%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFreePostEffect(postEffect%) "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffect_(index%, postEffect%, technique$z) "win32"
Rem
	bbdoc:
EndRem
Global xRenderPostEffects() "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffectInt(postEffect%, name$z, value%) "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffectFloat(postEffect%, name$z, value#) "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffectBool(postEffect%, name$z, value%) "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffectVector_(postEffect%, name$z, x#, y#, z#, w#) "win32"
Rem
	bbdoc:
EndRem
Global xSetPostEffectTexture_(postEffect%, name$z, texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xDeletePostEffectConstant(postEffect%, name$z) "win32"
Rem
	bbdoc:
EndRem
Global xClearPostEffectConstants(postEffect%) "win32"

' psystems commands
Rem
	bbdoc:
EndRem
Global xCreatePSystem_%(pointSprites%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemType%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetBlend(psystem%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetBlend%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetMaxParticles(psystem%, maxNumber%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetMaxParticles%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetEmitterLifetime(psystem%, lifetime%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetEmitterLifetime%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetParticleLifetime(psystem%, lifetime%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetParticleLifetime%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetCreationInterval(psystem%, interval%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetCreationInterval%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetCreationFrequency(psystem%, frequency%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetCreationFrequency%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetTexture(psystem%, texture%, frames%, speed#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTexture%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTextureFrames%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTextureAnimationSpeed%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetOffset(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMinZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetOffsetMaxZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetVelocity(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMinZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetVelocityMaxZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemEnableFixedQuads(psystem%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemFixedQuadsUsed%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetTorque(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMinZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetTorqueMaxZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetGravity(psystem%, gravity#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetGravity#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetAlpha(psystem%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAlpha#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetFadeSpeed(psystem%, speed#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetFadeSpeed#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetParticleSize(psystem%, minx#, miny#, maxx#, maxy#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetSizeMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetSizeMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetSizeMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetSizeMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetScaleSpeed(psystem%, minx#, miny#, maxx#, maxy#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetScaleSpeedMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetScaleSpeedMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetScaleSpeedMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetScaleSpeedMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetAngles(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMinX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMinY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMinZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMaxX#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMaxY#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetAnglesMaxZ#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetColorMode(psystem%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetColorMode%(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetColors(psystem%, sred#, sgreen#, sblue#, ered#, egreen#, eblue#) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetBeginColorRed#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetBeginColorGreen#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetBeginColorBlue#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetEndColorRed#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetEndColorGreen#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetEndColorBlue#(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xFreePSystem(psystem%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemSetParticleParenting(psystem%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xPSystemGetParticleParenting%(psystem%) "win32"

' raypicks commands
Rem
	bbdoc:
EndRem
Global xLinePick_%(x#, y#, z#, dx#, dy#, dz#, distance#) "win32"
Rem
	bbdoc:
EndRem
Global xEntityPick_%(entity%, range#) "win32"
Rem
	bbdoc:
EndRem
Global xCameraPick%(camera%, x%, y%) "win32"
Rem
	bbdoc:
EndRem
Global xPickedNX#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedNY#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedNZ#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedX#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedY#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedZ#() "win32"
Rem
	bbdoc:
EndRem
Global xPickedEntity%() "win32"
Rem
	bbdoc:
EndRem
Global xPickedSurface%() "win32"
Rem
	bbdoc:
EndRem
Global xPickedTriangle%() "win32"
Rem
	bbdoc:
EndRem
Global xPickedTime%() "win32"

' shadows commands
Rem
	bbdoc:
EndRem
Global xSetShadowsBlur(blurLevel%) "win32"
Rem
	bbdoc:
EndRem
Global xSetShadowShader(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xInitShadows%(dirSize%, spotSize%, pointSize%) "win32"
Rem
	bbdoc:
EndRem
Global xSetShadowParams_(splitPlanes%, splitLambda#, useOrtho%, lightDist#) "win32"
Rem
	bbdoc:
EndRem
Global xRenderShadows(mainCamera%, texture%) "win32"
Rem
	bbdoc:
EndRem
Global xShadowPriority(priority%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraDisableShadows(camera%) "win32"
Rem
	bbdoc:
EndRem
Global xCameraEnableShadows(camera%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityCastShadows(entity%, light%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityReceiveShadows(entity%, light%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityIsCaster%(entity%, light%) "win32"
Rem
	bbdoc:
EndRem
Global xEntityIsReceiver%(entity%, light%) "win32"

' sounds commands
Rem
	bbdoc:
EndRem
Global xLoadSound%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xLoad3DSound%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFreeSound(sound%) "win32"
Rem
	bbdoc:
EndRem
Global xLoopSound(sound%) "win32"
Rem
	bbdoc:
EndRem
Global xSoundPitch(sound%, pitch%) "win32"
Rem
	bbdoc:
EndRem
Global xSoundVolume(sound%, volume#) "win32"
Rem
	bbdoc:
EndRem
Global xSoundPan(sound%, pan#) "win32"
Rem
	bbdoc:
EndRem
Global xPlaySound%(sound%) "win32"
Rem
	bbdoc:
EndRem
Global xStopChannel(channel%) "win32"
Rem
	bbdoc:
EndRem
Global xPauseChannel(channel%) "win32"
Rem
	bbdoc:
EndRem
Global xResumeChannel(channel%) "win32"
Rem
	bbdoc:
EndRem
Global xPlayMusic%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xChannelPitch(channel%, pitch%) "win32"
Rem
	bbdoc:
EndRem
Global xChannelVolume(channel%, volume#) "win32"
Rem
	bbdoc:
EndRem
Global xChannelPan(channel%, pan#) "win32"
Rem
	bbdoc:
EndRem
Global xChannelPlaying%(channel%) "win32"
Rem
	bbdoc:
EndRem
Global xEmitSound%(sound%, entity%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateListener_%(parent%, roFactor#, doplerFactor#, distFactor#) "win32"
Rem
	bbdoc:
EndRem
Global xGetListener%() "win32"
Rem
	bbdoc:
EndRem
Global xInitalizeSound%() "win32"

' sprites commands
Rem
	bbdoc:
EndRem
Global xCreateSprite_%(parent%) "win32"
Rem
	bbdoc:
EndRem
Global xSpriteViewMode(sprite%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xHandleSprite(sprite%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xLoadSprite_%(path$z, flags%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xRotateSprite(sprite%, angle#) "win32"
Rem
	bbdoc:
EndRem
Global xScaleSprite(sprite%, xScale#, yScale#) "win32"

' surfaces commands
Rem
	bbdoc:
EndRem
Global xCreateSurface_%(entity%, brush%, dynamic%) "win32"
Rem
	bbdoc:
EndRem
Global xGetSurfaceBrush%(surface%) "win32"
Rem
	bbdoc:
EndRem
Global xAddVertex_%(surface%, x#, y#, z#, u#, v#, w#) "win32"
Rem
	bbdoc:
EndRem
Global xAddTriangle%(surface%, v0%, v1%, v2%) "win32"
Rem
	bbdoc:
EndRem
Global xSetSurfaceFrustumSphere(surface%, x#, y#, z#, radii#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexCoords(surface%, vertex%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexNormal(surface%, vertex%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexTangent(surface%, vertex%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexBinormal(surface%, vertex%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexColor_(surface%, vertex%, red%, green%, blue%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xVertexTexCoords_(surface%, vertex%, u#, v#, w#, textureSet%) "win32"
Rem
	bbdoc:
EndRem
Global xCountVertices%(surface%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexX#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexY#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexZ#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexNX#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexNY#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexNZ#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexTX#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexTY#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexTZ#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexBX#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexBY#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexBZ#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexU_#(surface%, vertex%, textureSet%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexV_#(surface%, vertex%, textureSet%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexW_#(surface%, vertex%, textureSet%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexRed#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexGreen#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexBlue#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xVertexAlpha#(surface%, vertex%) "win32"
Rem
	bbdoc:
EndRem
Global xTriangleVertex%(surface%, triangle%, corner%) "win32"
Rem
	bbdoc:
EndRem
Global xCountTriangles%(surface%) "win32"
Rem
	bbdoc:
EndRem
Global xPaintSurface(surface%, brush%) "win32"
Rem
	bbdoc:
EndRem
Global xClearSurface_(surface%, vertices%, triangles%) "win32"
Rem
	bbdoc:
EndRem
Global xGetSurfaceTexture_%(surface%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeSurface(surface%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfacePrimitiveType(surface%, ptype%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceTexture(surface%, texture%, frame%, index%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceColor(surface%, red%, green%, blue%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceAlpha(surface%, alpha#) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceShininess(surface%, shininess#) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceBlend(surface%, blendMode%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceFX(surface%, fxFlags%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceAlphaRef(surface%, alphaRef%) "win32"
Rem
	bbdoc:
EndRem
Global xSurfaceAlphaFunc(surface%, alphaFunc%) "win32"

' sysinfos commands
Rem
	bbdoc:
EndRem
Global xCPUName$z() "win32"
Rem
	bbdoc:
EndRem
Global xCPUVendor$z() "win32"
Rem
	bbdoc:
EndRem
Global xCPUFamily%() "win32"
Rem
	bbdoc:
EndRem
Global xCPUModel%() "win32"
Rem
	bbdoc:
EndRem
Global xCPUStepping%() "win32"
Rem
	bbdoc:
EndRem
Global xCPUSpeed%() "win32"
Rem
	bbdoc:
EndRem
Global xVideoInfo$z() "win32"
Rem
	bbdoc:
EndRem
Global xVideoAspectRatio#() "win32"
Rem
	bbdoc:
EndRem
Global xVideoAspectRatioStr$z() "win32"
Rem
	bbdoc:
EndRem
Global xGetTotalPhysMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetAvailPhysMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetTotalPageMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetAvailPageMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetTotalVidMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetAvailVidMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetTotalVidLocalMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetAvailVidLocalMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetTotalVidNonlocalMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetAvailVidNonlocalMem#() "win32"
Rem
	bbdoc:
EndRem
Global xGetXors3dVersion$z() "win32"
Rem
	bbdoc:
EndRem
Global xGetXors3dMajorVersion%() "win32"
Rem
	bbdoc:
EndRem
Global xGetXors3dMinorVersion%() "win32"
Rem
	bbdoc:
EndRem
Global xGetXors3dRevision%() "win32"

' terrains commands
Rem
	bbdoc:
EndRem
Global xLoadTerrain_%(path$z, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateTerrain_%(size%, parent%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainShading_(terrain%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainHeight#(terrain%, x%, y%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainSize%(terrain%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainX#(terrain%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainY#(terrain%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainZ#(terrain%, x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xModifyTerrain_(terrain%, x%, y%, height#, realtime%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainDetail(terrain%, detail%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainSplatting(terrain%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xLoadTerrainTexture%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xFreeTerrainTexture(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainTextureLightmap(texture%, state%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainTexture(terrain%, texture%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainViewZone_(terrain%, viewZone%, texturingZone%) "win32"
Rem
	bbdoc:
EndRem
Global xTerrainLODs(lodsCount%) "win32"

' textures commands
Rem
	bbdoc:
EndRem
Global xTextureWidth%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureHeight%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateTexture_%(width%, height%, flags%, frames%) "win32"
Rem
	bbdoc:
EndRem
Global xFreeTexture(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xSetTextureFilter(texture%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureBlend(texture%, blend%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureCoords(texture%, coords%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureFilter(matchText$z, flags%) "win32"
Rem
	bbdoc:
EndRem
Global xClearTextureFilters() "win32"
Rem
	bbdoc:
EndRem
Global xLoadTexture_%(path$z, flags%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureName$z(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xPositionTexture(texture%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xScaleTexture(texture%, x#, y#) "win32"
Rem
	bbdoc:
EndRem
Global xRotateTexture(texture%, angle#) "win32"
Rem
	bbdoc:
EndRem
Global xLoadAnimTexture%(path$z, flags%, width%, height%, startFrame%, frames%) "win32"
Rem
	bbdoc:
EndRem
Global xCreateTextureFromData_%(pixelsData%, width%, height%, flags%, frames%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureData_%(texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureDataPitch_%(texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureSurface_%(texture%, frame%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureFrames%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xSetCubeFace(texture%, face%) "win32"
Rem
	bbdoc:
EndRem
Global xSetCubeMode(texture%, mode%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureBlend%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureX#(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureY#(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureScaleX#(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureScaleY#(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureAngle#(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureCoords%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetCubeFace%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetCubeMode%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xGetTextureFlags%(texture%) "win32"
Rem
	bbdoc:
EndRem
Global xSetTextureFlags(texture%, flags%) "win32"
Rem
	bbdoc:
EndRem
Global xTextureCounter%(texture%) "win32"

' transforms commands
Rem
	bbdoc:
EndRem
Global xVectorPitch#(x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xVectorYaw#(x#, y#, z#) "win32"
Rem
	bbdoc:
EndRem
Global xDeltaPitch#(entity1%, entity2%) "win32"
Rem
	bbdoc:
EndRem
Global xDeltaYaw#(entity1%, entity2%) "win32"
Rem
	bbdoc:
EndRem
Global xTFormedX#() "win32"
Rem
	bbdoc:
EndRem
Global xTFormedY#() "win32"
Rem
	bbdoc:
EndRem
Global xTFormedZ#() "win32"
Rem
	bbdoc:
EndRem
Global xTFormPoint(x#, y#, z#, source%, destination%) "win32"
Rem
	bbdoc:
EndRem
Global xTFormVector(x#, y#, z#, source%, destination%) "win32"
Rem
	bbdoc:
EndRem
Global xTFormNormal(x#, y#, z#, source%, destination%) "win32"

' videos commands
Rem
	bbdoc:
EndRem
Global xOpenMovie%(path$z) "win32"
Rem
	bbdoc:
EndRem
Global xCloseMovie(video%) "win32"
Rem
	bbdoc:
EndRem
Global xDrawMovie_(video%, x%, y%, width%, height%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieWidth%(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieHeight%(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMoviePlaying%(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieSeek_(video%, time#, relative%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieLength#(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieCurrentTime#(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMoviePause(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieResume(video%) "win32"
Rem
	bbdoc:
EndRem
Global xMovieTexture%(video%) "win32"

' worlds commands
Rem
	bbdoc:
EndRem
Global xCreateWorld%() "win32"
Rem
	bbdoc:
EndRem
Global xSetActiveWorld(world%) "win32"
Rem
	bbdoc:
EndRem
Global xGetActiveWorld%() "win32"
Rem
	bbdoc:
EndRem
Global xGetDefaultWorld%() "win32"
Rem
	bbdoc:
EndRem
Global xDeleteWorld(world%) "win32"

' Import functions from DLL
Global lib% = LoadLibraryA(xorsLibName)
If lib%
	xCreateLine3D_ = GetProcAddress(lib, "_xCreateLine3D@44")
	xLine3DOrigin_ = GetProcAddress(lib, "_xLine3DOrigin@20")
	xLine3DAddNode_ = GetProcAddress(lib, "_xLine3DAddNode@20")
	xLine3DColor = GetProcAddress(lib, "_xLine3DColor@20")
	xLine3DUseZBuffer = GetProcAddress(lib, "_xLine3DUseZBuffer@8")
	xLine3DOriginX_ = GetProcAddress(lib, "_xLine3DOriginX@8")
	xLine3DOriginY_ = GetProcAddress(lib, "_xLine3DOriginY@8")
	xLine3DOriginZ_ = GetProcAddress(lib, "_xLine3DOriginZ@8")
	xLine3DNodesCount = GetProcAddress(lib, "_xLine3DNodesCount@4")
	xLine3DNodePosition_ = GetProcAddress(lib, "_xLine3DNodePosition@24")
	xLine3DNodeX_ = GetProcAddress(lib, "_xLine3DNodeX@12")
	xLine3DNodeY_ = GetProcAddress(lib, "_xLine3DNodeY@12")
	xLine3DNodeZ_ = GetProcAddress(lib, "_xLine3DNodeZ@12")
	xLine3DRed = GetProcAddress(lib, "_xLine3DRed@4")
	xLine3DGreen = GetProcAddress(lib, "_xLine3DGreen@4")
	xLine3DBlue = GetProcAddress(lib, "_xLine3DBlue@4")
	xLine3DAlpha = GetProcAddress(lib, "_xLine3DAlpha@4")
	xGetLine3DUseZBuffer = GetProcAddress(lib, "_xGetLine3DUseZBuffer@4")
	xDeleteLine3DNode = GetProcAddress(lib, "_xDeleteLine3DNode@8")
	xClearLine3D = GetProcAddress(lib, "_xClearLine3D@4")
	xLoadBrush_ = GetProcAddress(lib, "_xLoadBrush@16")
	xCreateBrush_ = GetProcAddress(lib, "_xCreateBrush@12")
	xFreeBrush = GetProcAddress(lib, "_xFreeBrush@4")
	xGetBrushTexture_ = GetProcAddress(lib, "_xGetBrushTexture@8")
	xBrushColor = GetProcAddress(lib, "_xBrushColor@16")
	xBrushAlpha = GetProcAddress(lib, "_xBrushAlpha@8")
	xBrushShininess = GetProcAddress(lib, "_xBrushShininess@8")
	xBrushBlend = GetProcAddress(lib, "_xBrushBlend@8")
	xBrushFX = GetProcAddress(lib, "_xBrushFX@8")
	xBrushTexture_ = GetProcAddress(lib, "_xBrushTexture@16")
	xGetBrushName = GetProcAddress(lib, "_xGetBrushName@4")
	xBrushName = GetProcAddress(lib, "_xBrushName@8")
	xGetBrushAlpha = GetProcAddress(lib, "_xGetBrushAlpha@4")
	xGetBrushBlend = GetProcAddress(lib, "_xGetBrushBlend@4")
	xGetBrushRed = GetProcAddress(lib, "_xGetBrushRed@4")
	xGetBrushGreen = GetProcAddress(lib, "_xGetBrushGreen@4")
	xGetBrushBlue = GetProcAddress(lib, "_xGetBrushBlue@4")
	xGetBrushFX = GetProcAddress(lib, "_xGetBrushFX@4")
	xGetBrushShininess = GetProcAddress(lib, "_xGetBrushShininess@4")
	xCameraFogMode = GetProcAddress(lib, "_xCameraFogMode@8")
	xCameraFogColor = GetProcAddress(lib, "_xCameraFogColor@16")
	xCameraFogRange = GetProcAddress(lib, "_xCameraFogRange@12")
	xCameraClsColor_ = GetProcAddress(lib, "_xCameraClsColor@20")
	xCameraProjMode = GetProcAddress(lib, "_xCameraProjMode@8")
	xCameraClsMode = GetProcAddress(lib, "_xCameraClsMode@12")
	xSphereInFrustum = GetProcAddress(lib, "_xSphereInFrustum@20")
	xCameraClipPlane = GetProcAddress(lib, "_xCameraClipPlane@28")
	xCameraRange = GetProcAddress(lib, "_xCameraRange@12")
	xCameraViewport = GetProcAddress(lib, "_xCameraViewport@20")
	xCameraCropViewport = GetProcAddress(lib, "_xCameraCropViewport@20")
	xCreateCamera_ = GetProcAddress(lib, "_xCreateCamera@4")
	xCameraProject = GetProcAddress(lib, "_xCameraProject@16")
	xCameraProject2D = GetProcAddress(lib, "_xCameraProject2D@16")
	xProjectedX = GetProcAddress(lib, "_xProjectedX@0")
	xProjectedY = GetProcAddress(lib, "_xProjectedY@0")
	xProjectedZ = GetProcAddress(lib, "_xProjectedZ@0")
	xGetViewMatrix = GetProcAddress(lib, "_xGetViewMatrix@4")
	xGetProjectionMatrix = GetProcAddress(lib, "_xGetProjectionMatrix@4")
	xCameraZoom = GetProcAddress(lib, "_xCameraZoom@8")
	xGetViewProjMatrix = GetProcAddress(lib, "_xGetViewProjMatrix@4")
	xCollisions = GetProcAddress(lib, "_xCollisions@16")
	xClearCollisions = GetProcAddress(lib, "_xClearCollisions@0")
	xResetEntity = GetProcAddress(lib, "_xResetEntity@4")
	xEntityRadius_ = GetProcAddress(lib, "_xEntityRadius@12")
	xEntityBox = GetProcAddress(lib, "_xEntityBox@28")
	xEntityType_ = GetProcAddress(lib, "_xEntityType@12")
	xEntityCollided = GetProcAddress(lib, "_xEntityCollided@8")
	xCountCollisions = GetProcAddress(lib, "_xCountCollisions@4")
	xCollisionX = GetProcAddress(lib, "_xCollisionX@8")
	xCollisionY = GetProcAddress(lib, "_xCollisionY@8")
	xCollisionZ = GetProcAddress(lib, "_xCollisionZ@8")
	xCollisionNX = GetProcAddress(lib, "_xCollisionNX@8")
	xCollisionNY = GetProcAddress(lib, "_xCollisionNY@8")
	xCollisionNZ = GetProcAddress(lib, "_xCollisionNZ@8")
	xCollisionTime = GetProcAddress(lib, "_xCollisionTime@8")
	xCollisionEntity = GetProcAddress(lib, "_xCollisionEntity@8")
	xCollisionSurface = GetProcAddress(lib, "_xCollisionSurface@8")
	xCollisionTriangle = GetProcAddress(lib, "_xCollisionTriangle@8")
	xGetEntityType = GetProcAddress(lib, "_xGetEntityType@4")
	xRenderPostEffect = GetProcAddress(lib, "_xRenderPostEffect@4")
	xCreatePostEffectPoly = GetProcAddress(lib, "_xCreatePostEffectPoly@8")
	xGetFunctionAddress = GetProcAddress(lib, "_xGetFunctionAddress@4")
	xLoadFXFile = GetProcAddress(lib, "_xLoadFXFile@4")
	xFreeEffect = GetProcAddress(lib, "_xFreeEffect@4")
	xSetEntityEffect_ = GetProcAddress(lib, "_xSetEntityEffect@12")
	xSetSurfaceEffect_ = GetProcAddress(lib, "_xSetSurfaceEffect@12")
	xSetBonesArrayName_ = GetProcAddress(lib, "_xSetBonesArrayName@12")
	xSurfaceBonesArrayName_ = GetProcAddress(lib, "_xSurfaceBonesArrayName@12")
	xSetEffectInt_ = GetProcAddress(lib, "_xSetEffectInt@16")
	xSurfaceEffectInt_ = GetProcAddress(lib, "_xSurfaceEffectInt@16")
	xSetEffectFloat_ = GetProcAddress(lib, "_xSetEffectFloat@16")
	xSurfaceEffectFloat_ = GetProcAddress(lib, "_xSurfaceEffectFloat@16")
	xSetEffectBool_ = GetProcAddress(lib, "_xSetEffectBool@16")
	xSurfaceEffectBool_ = GetProcAddress(lib, "_xSurfaceEffectBool@16")
	xSetEffectVector_ = GetProcAddress(lib, "_xSetEffectVector@28")
	xSurfaceEffectVector_ = GetProcAddress(lib, "_xSurfaceEffectVector@28")
	xSetEffectVectorArray_ = GetProcAddress(lib, "_xSetEffectVectorArray@20")
	xSurfaceEffectVectorArray_ = GetProcAddress(lib, "_xSurfaceEffectVectorArray@20")
	xSurfaceEffectMatrixArray_ = GetProcAddress(lib, "_xSurfaceEffectMatrixArray@20")
	xSurfaceEffectFloatArray_ = GetProcAddress(lib, "_xSurfaceEffectFloatArray@20")
	xSurfaceEffectIntArray_ = GetProcAddress(lib, "_xSurfaceEffectIntArray@20")
	xSetEffectMatrixArray_ = GetProcAddress(lib, "_xSetEffectMatrixArray@20")
	xSetEffectFloatArray_ = GetProcAddress(lib, "_xSetEffectFloatArray@20")
	xSetEffectIntArray_ = GetProcAddress(lib, "_xSetEffectIntArray@20")
	xCreateBufferVectors = GetProcAddress(lib, "_xCreateBufferVectors@4")
	xBufferVectorsSetElement = GetProcAddress(lib, "_xBufferVectorsSetElement@24")
	xCreateBufferMatrix = GetProcAddress(lib, "_xCreateBufferMatrix@4")
	xBufferMatrixSetElement = GetProcAddress(lib, "_xBufferMatrixSetElement@12")
	xBufferMatrixGetElement = GetProcAddress(lib, "_xBufferMatrixGetElement@8")
	xCreateBufferFloats = GetProcAddress(lib, "_xCreateBufferFloats@4")
	xBufferFloatsSetElement = GetProcAddress(lib, "_xBufferFloatsSetElement@12")
	xBufferFloatsGetElement = GetProcAddress(lib, "_xBufferFloatsGetElement@8")
	xBufferDelete = GetProcAddress(lib, "_xBufferDelete@4")
	xSetEffectMatrixWithElements_ = GetProcAddress(lib, "_xSetEffectMatrixWithElements@76")
	xSetEffectMatrix_ = GetProcAddress(lib, "_xSetEffectMatrix@16")
	xSurfaceEffectMatrix_ = GetProcAddress(lib, "_xSurfaceEffectMatrix@16")
	xSurfaceEffectMatrixWithElements_ = GetProcAddress(lib, "_xSurfaceEffectMatrixWithElements@76")
	xSetEffectEntityTexture_ = GetProcAddress(lib, "_xSetEffectEntityTexture@16")
	xSetEffectTexture_ = GetProcAddress(lib, "_xSetEffectTexture@24")
	xSurfaceEffectTexture_ = GetProcAddress(lib, "_xSurfaceEffectTexture@20")
	xSurfaceEffectMatrixSemantic_ = GetProcAddress(lib, "_xSurfaceEffectMatrixSemantic@16")
	xSetEffectMatrixSemantic_ = GetProcAddress(lib, "_xSetEffectMatrixSemantic@16")
	xDeleteSurfaceConstant_ = GetProcAddress(lib, "_xDeleteSurfaceConstant@12")
	xDeleteEffectConstant_ = GetProcAddress(lib, "_xDeleteEffectConstant@12")
	xClearSurfaceConstants_ = GetProcAddress(lib, "_xClearSurfaceConstants@8")
	xClearEffectConstants_ = GetProcAddress(lib, "_xClearEffectConstants@8")
	xSetEffectTechnique_ = GetProcAddress(lib, "_xSetEffectTechnique@12")
	xSurfaceTechnique_ = GetProcAddress(lib, "_xSurfaceTechnique@12")
	xValidateEffectTechnique = GetProcAddress(lib, "_xValidateEffectTechnique@8")
	xSetEntityShaderLayer = GetProcAddress(lib, "_xSetEntityShaderLayer@8")
	xGetEntityShaderLayer = GetProcAddress(lib, "_xGetEntityShaderLayer@4")
	xSetSurfaceShaderLayer = GetProcAddress(lib, "_xSetSurfaceShaderLayer@8")
	xGetSurfaceShaderLayer = GetProcAddress(lib, "_xGetSurfaceShaderLayer@4")
	xSetFXInt = GetProcAddress(lib, "_xSetFXInt@12")
	xSetFXFloat = GetProcAddress(lib, "_xSetFXFloat@12")
	xSetFXBool = GetProcAddress(lib, "_xSetFXBool@12")
	xSetFXVector_ = GetProcAddress(lib, "_xSetFXVector@24")
	xSetFXVectorArray = GetProcAddress(lib, "_xSetFXVectorArray@16")
	xSetFXMatrixArray = GetProcAddress(lib, "_xSetFXMatrixArray@16")
	xSetFXFloatArray = GetProcAddress(lib, "_xSetFXFloatArray@16")
	xSetFXIntArray = GetProcAddress(lib, "_xSetFXIntArray@16")
	xSetFXEntityMatrix = GetProcAddress(lib, "_xSetFXEntityMatrix@12")
	xSetFXTexture_ = GetProcAddress(lib, "_xSetFXTexture@16")
	xSetFXMatrixSemantic = GetProcAddress(lib, "_xSetFXMatrixSemantic@12")
	xDeleteFXConstant = GetProcAddress(lib, "_xDeleteFXConstant@8")
	xClearFXConstants = GetProcAddress(lib, "_xClearFXConstants@4")
	xSetFXTechnique = GetProcAddress(lib, "_xSetFXTechnique@8")
	xCreateEmitter_ = GetProcAddress(lib, "_xCreateEmitter@8")
	xEmitterEnable = GetProcAddress(lib, "_xEmitterEnable@8")
	xEmitterEnabled = GetProcAddress(lib, "_xEmitterEnabled@4")
	xEmitterGetPSystem = GetProcAddress(lib, "_xEmitterGetPSystem@4")
	xEmitterAddParticle = GetProcAddress(lib, "_xEmitterAddParticle@4")
	xEmitterFreeParticle = GetProcAddress(lib, "_xEmitterFreeParticle@8")
	xEmitterValidateParticle = GetProcAddress(lib, "_xEmitterValidateParticle@8")
	xEmitterCountParticles = GetProcAddress(lib, "_xEmitterCountParticles@4")
	xEmitterGetParticle = GetProcAddress(lib, "_xEmitterGetParticle@8")
	xEmitterAlive = GetProcAddress(lib, "_xEmitterAlive@4")
	xExtractAnimSeq_ = GetProcAddress(lib, "_xExtractAnimSeq@16")
	xLoadAnimSeq = GetProcAddress(lib, "_xLoadAnimSeq@8")
	xSetAnimSpeed_ = GetProcAddress(lib, "_xSetAnimSpeed@12")
	xAnimSpeed_ = GetProcAddress(lib, "_xAnimSpeed@8")
	xAnimating_ = GetProcAddress(lib, "_xAnimating@8")
	xAnimTime_ = GetProcAddress(lib, "_xAnimTime@8")
	xAnimate_ = GetProcAddress(lib, "_xAnimate@24")
	xAnimSeq_ = GetProcAddress(lib, "_xAnimSeq@8")
	xAnimLength_ = GetProcAddress(lib, "_xAnimLength@8")
	xSetAnimTime_ = GetProcAddress(lib, "_xSetAnimTime@16")
	xSetAnimFrame_ = GetProcAddress(lib, "_xSetAnimFrame@16")
	xEntityAutoFade = GetProcAddress(lib, "_xEntityAutoFade@12")
	xEntityOrder = GetProcAddress(lib, "_xEntityOrder@8")
	xFreeEntity = GetProcAddress(lib, "_xFreeEntity@4")
	xCopyEntity_ = GetProcAddress(lib, "_xCopyEntity@12")
	xPaintEntity = GetProcAddress(lib, "_xPaintEntity@8")
	xEntityShininess = GetProcAddress(lib, "_xEntityShininess@8")
	xEntityPickMode_ = GetProcAddress(lib, "_xEntityPickMode@16")
	xEntityTexture_ = GetProcAddress(lib, "_xEntityTexture@20")
	xEntityFX = GetProcAddress(lib, "_xEntityFX@8")
	xGetParent = GetProcAddress(lib, "_xGetParent@4")
	xSetFrustumSphere = GetProcAddress(lib, "_xSetFrustumSphere@20")
	xCalculateFrustumVolume = GetProcAddress(lib, "_xCalculateFrustumVolume@4")
	xEntityParent_ = GetProcAddress(lib, "_xEntityParent@12")
	xShowEntity = GetProcAddress(lib, "_xShowEntity@4")
	xHideEntity = GetProcAddress(lib, "_xHideEntity@4")
	xNameEntity = GetProcAddress(lib, "_xNameEntity@8")
	xSetEntityQuaternion = GetProcAddress(lib, "_xSetEntityQuaternion@8")
	xSetEntityMatrix = GetProcAddress(lib, "_xSetEntityMatrix@8")
	xEntityAlpha = GetProcAddress(lib, "_xEntityAlpha@8")
	xEntityColor = GetProcAddress(lib, "_xEntityColor@16")
	xEntitySpecularColor = GetProcAddress(lib, "_xEntitySpecularColor@16")
	xEntityAmbientColor = GetProcAddress(lib, "_xEntityAmbientColor@16")
	xEntityEmissiveColor = GetProcAddress(lib, "_xEntityEmissiveColor@16")
	xEntityBlend = GetProcAddress(lib, "_xEntityBlend@8")
	xEntityAlphaRef = GetProcAddress(lib, "_xEntityAlphaRef@8")
	xEntityAlphaFunc = GetProcAddress(lib, "_xEntityAlphaFunc@8")
	xCreateInstance_ = GetProcAddress(lib, "_xCreateInstance@8")
	xFreezeInstances_ = GetProcAddress(lib, "_xFreezeInstances@8")
	xInstancingAvaliable = GetProcAddress(lib, "_xInstancingAvaliable@0")
	xGetEntityWorld = GetProcAddress(lib, "_xGetEntityWorld@4")
	xSetEntityWorld = GetProcAddress(lib, "_xSetEntityWorld@8")
	xScaleEntity_ = GetProcAddress(lib, "_xScaleEntity@20")
	xPositionEntity_ = GetProcAddress(lib, "_xPositionEntity@20")
	xMoveEntity_ = GetProcAddress(lib, "_xMoveEntity@20")
	xTranslateEntity_ = GetProcAddress(lib, "_xTranslateEntity@20")
	xRotateEntity_ = GetProcAddress(lib, "_xRotateEntity@20")
	xTurnEntity_ = GetProcAddress(lib, "_xTurnEntity@20")
	xPointEntity_ = GetProcAddress(lib, "_xPointEntity@12")
	xAlignToVector_ = GetProcAddress(lib, "_xAlignToVector@24")
	xEntityDistance = GetProcAddress(lib, "_xEntityDistance@8")
	xGetMatElement = GetProcAddress(lib, "_xGetMatElement@12")
	xEntityClass = GetProcAddress(lib, "_xEntityClass@4")
	xGetEntityBrush = GetProcAddress(lib, "_xGetEntityBrush@4")
	xEntityX_ = GetProcAddress(lib, "_xEntityX@8")
	xEntityY_ = GetProcAddress(lib, "_xEntityY@8")
	xEntityZ_ = GetProcAddress(lib, "_xEntityZ@8")
	xEntityVisible = GetProcAddress(lib, "_xEntityVisible@8")
	xEntityScaleX = GetProcAddress(lib, "_xEntityScaleX@4")
	xEntityScaleY = GetProcAddress(lib, "_xEntityScaleY@4")
	xEntityScaleZ = GetProcAddress(lib, "_xEntityScaleZ@4")
	xEntityRoll_ = GetProcAddress(lib, "_xEntityRoll@8")
	xEntityYaw_ = GetProcAddress(lib, "_xEntityYaw@8")
	xEntityPitch_ = GetProcAddress(lib, "_xEntityPitch@8")
	xEntityName = GetProcAddress(lib, "_xEntityName@4")
	xCountChildren = GetProcAddress(lib, "_xCountChildren@4")
	xGetChild = GetProcAddress(lib, "_xGetChild@8")
	xEntityInView = GetProcAddress(lib, "_xEntityInView@8")
	xFindChild = GetProcAddress(lib, "_xFindChild@8")
	xGetEntityMatrix = GetProcAddress(lib, "_xGetEntityMatrix@4")
	xGetEntityAlpha = GetProcAddress(lib, "_xGetEntityAlpha@4")
	xGetAlphaRef = GetProcAddress(lib, "_xGetAlphaRef@4")
	xGetAlphaFunc = GetProcAddress(lib, "_xGetAlphaFunc@4")
	xEntityRed = GetProcAddress(lib, "_xEntityRed@4")
	xEntityGreen = GetProcAddress(lib, "_xEntityGreen@4")
	xEntityBlue = GetProcAddress(lib, "_xEntityBlue@4")
	xGetEntityShininess = GetProcAddress(lib, "_xGetEntityShininess@4")
	xGetEntityBlend = GetProcAddress(lib, "_xGetEntityBlend@4")
	xGetEntityFX = GetProcAddress(lib, "_xGetEntityFX@4")
	xEntityHidden = GetProcAddress(lib, "_xEntityHidden@4")
	xEntitiesBBIntersect = GetProcAddress(lib, "_xEntitiesBBIntersect@8")
	xMountPackFile_ = GetProcAddress(lib, "_xMountPackFile@12")
	xUnmountPackFile = GetProcAddress(lib, "_xUnmountPackFile@4")
	xOpenFile = GetProcAddress(lib, "_xOpenFile@4")
	xReadFile = GetProcAddress(lib, "_xReadFile@4")
	xWriteFile = GetProcAddress(lib, "_xWriteFile@4")
	xCloseFile = GetProcAddress(lib, "_xCloseFile@4")
	xFilePos = GetProcAddress(lib, "_xFilePos@4")
	xSeekFile = GetProcAddress(lib, "_xSeekFile@8")
	xFileType = GetProcAddress(lib, "_xFileType@4")
	xFileSize = GetProcAddress(lib, "_xFileSize@4")
	xFileCreationTime = GetProcAddress(lib, "_xFileCreationTime@4")
	xFileCreationTimeStr = GetProcAddress(lib, "_xFileCreationTimeStr@4")
	xFileModificationTime = GetProcAddress(lib, "_xFileModificationTime@4")
	xFileModificationTimeStr = GetProcAddress(lib, "_xFileModificationTimeStr@4")
	xReadDir = GetProcAddress(lib, "_xReadDir@4")
	xCloseDir = GetProcAddress(lib, "_xCloseDir@4")
	xNextFile = GetProcAddress(lib, "_xNextFile@4")
	xCurrentDir = GetProcAddress(lib, "_xCurrentDir@0")
	xChangeDir = GetProcAddress(lib, "_xChangeDir@4")
	xCreateDir = GetProcAddress(lib, "_xCreateDir@4")
	xDeleteDir = GetProcAddress(lib, "_xDeleteDir@4")
	xCopyFile = GetProcAddress(lib, "_xCopyFile@8")
	xDeleteFile = GetProcAddress(lib, "_xDeleteFile@4")
	xEof = GetProcAddress(lib, "_xEof@4")
	xReadByte = GetProcAddress(lib, "_xReadByte@4")
	xReadShort = GetProcAddress(lib, "_xReadShort@4")
	xReadInt = GetProcAddress(lib, "_xReadInt@4")
	xReadFloat = GetProcAddress(lib, "_xReadFloat@4")
	xReadString = GetProcAddress(lib, "_xReadString@4")
	xReadLine_ = GetProcAddress(lib, "_xReadLine@8")
	xWriteByte = GetProcAddress(lib, "_xWriteByte@8")
	xWriteShort = GetProcAddress(lib, "_xWriteShort@8")
	xWriteInt = GetProcAddress(lib, "_xWriteInt@8")
	xWriteFloat = GetProcAddress(lib, "_xWriteFloat@8")
	xWriteString = GetProcAddress(lib, "_xWriteString@8")
	xWriteLine_ = GetProcAddress(lib, "_xWriteLine@12")
	xLoadFont_ = GetProcAddress(lib, "_xLoadFont@24")
	xText_ = GetProcAddress(lib, "_xText@20")
	xSetFont = GetProcAddress(lib, "_xSetFont@4")
	xFreeFont = GetProcAddress(lib, "_xFreeFont@4")
	xFontWidth = GetProcAddress(lib, "_xFontWidth@0")
	xFontHeight = GetProcAddress(lib, "_xFontHeight@0")
	xStringWidth = GetProcAddress(lib, "_xStringWidth@4")
	xStringHeight = GetProcAddress(lib, "_xStringHeight@4")
	xWinMessage = GetProcAddress(lib, "_xWinMessage@4")
	xGetMaxPixelShaderVersion = GetProcAddress(lib, "_xGetMaxPixelShaderVersion@0")
	xLine = GetProcAddress(lib, "_xLine@16")
	xRect_ = GetProcAddress(lib, "_xRect@20")
	xRectsOverlap = GetProcAddress(lib, "_xRectsOverlap@32")
	xViewport = GetProcAddress(lib, "_xViewport@16")
	xOval_ = GetProcAddress(lib, "_xOval@20")
	xOrigin = GetProcAddress(lib, "_xOrigin@8")
	xGetMaxVertexShaderVersion = GetProcAddress(lib, "_xGetMaxVertexShaderVersion@0")
	xGetMaxAntiAlias = GetProcAddress(lib, "_xGetMaxAntiAlias@0")
	xGetMaxTextureFiltering = GetProcAddress(lib, "_xGetMaxTextureFiltering@0")
	xSetAntiAliasType = GetProcAddress(lib, "_xSetAntiAliasType@4")
	xAppTitle = GetProcAddress(lib, "_xAppTitle@4")
	xSetWND = GetProcAddress(lib, "_xSetWND@4")
	xSetRenderWindow = GetProcAddress(lib, "_xSetRenderWindow@4")
	xSetTopWindow = GetProcAddress(lib, "_xSetTopWindow@4")
	xDestroyRenderWindow = GetProcAddress(lib, "_xDestroyRenderWindow@0")
	xFlip = GetProcAddress(lib, "_xFlip@0")
	xBackBuffer = GetProcAddress(lib, "_xBackBuffer@0")
	xLockBuffer_ = GetProcAddress(lib, "_xLockBuffer@4")
	xUnlockBuffer_ = GetProcAddress(lib, "_xUnlockBuffer@4")
	xWritePixelFast_ = GetProcAddress(lib, "_xWritePixelFast@16")
	xReadPixelFast_ = GetProcAddress(lib, "_xReadPixelFast@12")
	xGetPixels_ = GetProcAddress(lib, "_xGetPixels@4")
	xSaveBuffer = GetProcAddress(lib, "_xSaveBuffer@8")
	xGetCurrentBuffer = GetProcAddress(lib, "_xGetCurrentBuffer@0")
	xBufferWidth_ = GetProcAddress(lib, "_xBufferWidth@4")
	xBufferHeight_ = GetProcAddress(lib, "_xBufferHeight@4")
	xCatchTimestamp = GetProcAddress(lib, "_xCatchTimestamp@0")
	xGetElapsedTime = GetProcAddress(lib, "_xGetElapsedTime@4")
	xSetBuffer_ = GetProcAddress(lib, "_xSetBuffer@4")
	xSetMRT = GetProcAddress(lib, "_xSetMRT@12")
	xUnSetMRT = GetProcAddress(lib, "_xUnSetMRT@0")
	xGetNumberRT = GetProcAddress(lib, "_xGetNumberRT@0")
	xTextureBuffer_ = GetProcAddress(lib, "_xTextureBuffer@8")
	xLoadBuffer = GetProcAddress(lib, "_xLoadBuffer@8")
	xWritePixel_ = GetProcAddress(lib, "_xWritePixel@16")
	xCopyPixel = GetProcAddress(lib, "_xCopyPixel@24")
	xCopyPixelFast = GetProcAddress(lib, "_xCopyPixelFast@24")
	xCopyRect = GetProcAddress(lib, "_xCopyRect@32")
	xGraphicsBuffer = GetProcAddress(lib, "_xGraphicsBuffer@0")
	xGetColor = GetProcAddress(lib, "_xGetColor@8")
	xReadPixel_ = GetProcAddress(lib, "_xReadPixel@12")
	xGraphicsWidth_ = GetProcAddress(lib, "_xGraphicsWidth@4")
	xGraphicsHeight_ = GetProcAddress(lib, "_xGraphicsHeight@4")
	xGraphicsDepth = GetProcAddress(lib, "_xGraphicsDepth@0")
	xColorAlpha = GetProcAddress(lib, "_xColorAlpha@0")
	xColorRed = GetProcAddress(lib, "_xColorRed@0")
	xColorGreen = GetProcAddress(lib, "_xColorGreen@0")
	xColorBlue = GetProcAddress(lib, "_xColorBlue@0")
	xClsColor_ = GetProcAddress(lib, "_xClsColor@16")
	xClearWorld_ = GetProcAddress(lib, "_xClearWorld@12")
	xColor_ = GetProcAddress(lib, "_xColor@16")
	xCls = GetProcAddress(lib, "_xCls@0")
	xUpdateWorld_ = GetProcAddress(lib, "_xUpdateWorld@4")
	xRenderEntity_ = GetProcAddress(lib, "_xRenderEntity@12")
	xRenderWorld_ = GetProcAddress(lib, "_xRenderWorld@8")
	xSetAutoTB = GetProcAddress(lib, "_xSetAutoTB@4")
	xMaxClipPlanes = GetProcAddress(lib, "_xMaxClipPlanes@0")
	xWireframe = GetProcAddress(lib, "_xWireframe@4")
	xDither = GetProcAddress(lib, "_xDither@4")
	xSetSkinningMethod = GetProcAddress(lib, "_xSetSkinningMethod@4")
	xTrisRendered = GetProcAddress(lib, "_xTrisRendered@0")
	xDIPCounter = GetProcAddress(lib, "_xDIPCounter@0")
	xSurfRendered = GetProcAddress(lib, "_xSurfRendered@0")
	xEntityRendered = GetProcAddress(lib, "_xEntityRendered@0")
	xAmbientLight_ = GetProcAddress(lib, "_xAmbientLight@16")
	xGetFPS = GetProcAddress(lib, "_xGetFPS@0")
	xAntiAlias = GetProcAddress(lib, "_xAntiAlias@4")
	xSetTextureFiltering = GetProcAddress(lib, "_xSetTextureFiltering@4")
	xStretchRect = GetProcAddress(lib, "_xStretchRect@44")
	xStretchBackBuffer = GetProcAddress(lib, "_xStretchBackBuffer@24")
	xGetDevice = GetProcAddress(lib, "_xGetDevice@0")
	xReleaseGraphics = GetProcAddress(lib, "_xReleaseGraphics@0")
	xShowPointer = GetProcAddress(lib, "_xShowPointer@0")
	xHidePointer = GetProcAddress(lib, "_xHidePointer@0")
	xCreateDSS = GetProcAddress(lib, "_xCreateDSS@8")
	xDeleteDSS = GetProcAddress(lib, "_xDeleteDSS@0")
	xGridColor = GetProcAddress(lib, "_xGridColor@24")
	xDrawGrid = GetProcAddress(lib, "_xDrawGrid@16")
	xDrawBBox = GetProcAddress(lib, "_xDrawBBox@24")
	xGraphics3D_ = GetProcAddress(lib, "_xGraphics3D@20")
	xGraphicsAspectRatio = GetProcAddress(lib, "_xGraphicsAspectRatio@4")
	xGraphicsBorderColor = GetProcAddress(lib, "_xGraphicsBorderColor@12")
	xGetRenderWindow = GetProcAddress(lib, "_xGetRenderWindow@0")
	xKey = GetProcAddress(lib, "_xKey@4")
	xSetEngineSetting = GetProcAddress(lib, "_xSetEngineSetting@8")
	xGetEngineSetting = GetProcAddress(lib, "_xGetEngineSetting@4")
	xHWInstancingAvailable = GetProcAddress(lib, "_xHWInstancingAvailable@0")
	xShaderInstancingAvailable = GetProcAddress(lib, "_xShaderInstancingAvailable@0")
	xSetShaderLayer = GetProcAddress(lib, "_xSetShaderLayer@4")
	xGetShaderLayer = GetProcAddress(lib, "_xGetShaderLayer@0")
	xDrawMovementGizmo_ = GetProcAddress(lib, "_xDrawMovementGizmo@16")
	xDrawScaleGizmo_ = GetProcAddress(lib, "_xDrawScaleGizmo@28")
	xDrawRotationGizmo_ = GetProcAddress(lib, "_xDrawRotationGizmo@28")
	xCheckMovementGizmo = GetProcAddress(lib, "_xCheckMovementGizmo@24")
	xCheckScaleGizmo = GetProcAddress(lib, "_xCheckScaleGizmo@24")
	xCheckRotationGizmo = GetProcAddress(lib, "_xCheckRotationGizmo@24")
	xCaptureWorld = GetProcAddress(lib, "_xCaptureWorld@0")
	xCountGfxModes = GetProcAddress(lib, "_xCountGfxModes@0")
	xGfxModeWidth = GetProcAddress(lib, "_xGfxModeWidth@4")
	xGfxModeHeight = GetProcAddress(lib, "_xGfxModeHeight@4")
	xGfxModeDepth = GetProcAddress(lib, "_xGfxModeDepth@4")
	xGfxModeExists = GetProcAddress(lib, "_xGfxModeExists@12")
	xAppWindowFrame = GetProcAddress(lib, "_xAppWindowFrame@4")
	xMillisecs = GetProcAddress(lib, "_xMillisecs@0")
	xDeltaTime_ = GetProcAddress(lib, "_xDeltaTime@4")
	xDeltaValue_ = GetProcAddress(lib, "_xDeltaValue@8")
	xAddDeviceLostCallback = GetProcAddress(lib, "_xAddDeviceLostCallback@4")
	xDeleteDeviceLostCallback = GetProcAddress(lib, "_xDeleteDeviceLostCallback@4")
	xDeinit = GetProcAddress(lib, "_xDeinit@0")
	xImageColor = GetProcAddress(lib, "_xImageColor@16")
	xImageAlpha = GetProcAddress(lib, "_xImageAlpha@8")
	xImageBuffer_ = GetProcAddress(lib, "_xImageBuffer@8")
	xCreateImage_ = GetProcAddress(lib, "_xCreateImage@12")
	xGrabImage_ = GetProcAddress(lib, "_xGrabImage@16")
	xFreeImage = GetProcAddress(lib, "_xFreeImage@4")
	xLoadImage = GetProcAddress(lib, "_xLoadImage@4")
	xLoadAnimImage = GetProcAddress(lib, "_xLoadAnimImage@20")
	xSaveImage_ = GetProcAddress(lib, "_xSaveImage@12")
	xDrawImage_ = GetProcAddress(lib, "_xDrawImage@16")
	xDrawImageRect_ = GetProcAddress(lib, "_xDrawImageRect@32")
	xScaleImage = GetProcAddress(lib, "_xScaleImage@12")
	xResizeImage = GetProcAddress(lib, "_xResizeImage@12")
	xRotateImage = GetProcAddress(lib, "_xRotateImage@8")
	xImageAngle = GetProcAddress(lib, "_xImageAngle@4")
	xImageWidth = GetProcAddress(lib, "_xImageWidth@4")
	xImageHeight = GetProcAddress(lib, "_xImageHeight@4")
	xImagesCollide = GetProcAddress(lib, "_xImagesCollide@32")
	xImageRectCollide = GetProcAddress(lib, "_xImageRectCollide@32")
	xImageRectOverlap = GetProcAddress(lib, "_xImageRectOverlap@28")
	xImageXHandle = GetProcAddress(lib, "_xImageXHandle@4")
	xImageYHandle = GetProcAddress(lib, "_xImageYHandle@4")
	xHandleImage = GetProcAddress(lib, "_xHandleImage@12")
	xMidHandle = GetProcAddress(lib, "_xMidHandle@4")
	xAutoMidHandle = GetProcAddress(lib, "_xAutoMidHandle@4")
	xTileImage_ = GetProcAddress(lib, "_xTileImage@16")
	xImagesOverlap = GetProcAddress(lib, "_xImagesOverlap@24")
	xMaskImage = GetProcAddress(lib, "_xMaskImage@16")
	xCopyImage = GetProcAddress(lib, "_xCopyImage@4")
	xDrawBlock_ = GetProcAddress(lib, "_xDrawBlock@16")
	xDrawBlockRect_ = GetProcAddress(lib, "_xDrawBlockRect@32")
	xImageActualWidth = GetProcAddress(lib, "_xImageActualWidth@4")
	xImageActualHeight = GetProcAddress(lib, "_xImageActualHeight@4")
	xFlushKeys = GetProcAddress(lib, "_xFlushKeys@0")
	xFlushMouse = GetProcAddress(lib, "_xFlushMouse@0")
	xKeyHit = GetProcAddress(lib, "_xKeyHit@4")
	xKeyUp = GetProcAddress(lib, "_xKeyUp@4")
	xWaitKey = GetProcAddress(lib, "_xWaitKey@0")
	xMouseHit = GetProcAddress(lib, "_xMouseHit@4")
	xKeyDown = GetProcAddress(lib, "_xKeyDown@4")
	xGetKey = GetProcAddress(lib, "_xGetKey@0")
	xMouseDown = GetProcAddress(lib, "_xMouseDown@4")
	xMouseUp = GetProcAddress(lib, "_xMouseUp@4")
	xGetMouse = GetProcAddress(lib, "_xGetMouse@0")
	xMouseX = GetProcAddress(lib, "_xMouseX@0")
	xMouseY = GetProcAddress(lib, "_xMouseY@0")
	xMouseZ = GetProcAddress(lib, "_xMouseZ@0")
	xMouseXSpeed = GetProcAddress(lib, "_xMouseXSpeed@0")
	xMouseYSpeed = GetProcAddress(lib, "_xMouseYSpeed@0")
	xMouseZSpeed = GetProcAddress(lib, "_xMouseZSpeed@0")
	xMouseSpeed = GetProcAddress(lib, "_xMouseSpeed@0")
	xMoveMouse = GetProcAddress(lib, "_xMoveMouse@8")
	xJoyType_ = GetProcAddress(lib, "_xJoyType@4")
	xJoyDown_ = GetProcAddress(lib, "_xJoyDown@8")
	xJoyHit_ = GetProcAddress(lib, "_xJoyHit@8")
	xGetJoy_ = GetProcAddress(lib, "_xGetJoy@4")
	xFlushJoy = GetProcAddress(lib, "_xFlushJoy@0")
	xWaitJoy_ = GetProcAddress(lib, "_xWaitJoy@4")
	xJoyX_ = GetProcAddress(lib, "_xJoyX@4")
	xJoyY_ = GetProcAddress(lib, "_xJoyY@4")
	xJoyZ_ = GetProcAddress(lib, "_xJoyZ@4")
	xJoyU_ = GetProcAddress(lib, "_xJoyU@4")
	xJoyV_ = GetProcAddress(lib, "_xJoyV@4")
	xJoyPitch_ = GetProcAddress(lib, "_xJoyPitch@4")
	xJoyYaw_ = GetProcAddress(lib, "_xJoyYaw@4")
	xJoyRoll_ = GetProcAddress(lib, "_xJoyRoll@4")
	xJoyHat_ = GetProcAddress(lib, "_xJoyHat@4")
	xJoyXDir_ = GetProcAddress(lib, "_xJoyXDir@4")
	xJoyYDir_ = GetProcAddress(lib, "_xJoyYDir@4")
	xJoyZDir_ = GetProcAddress(lib, "_xJoyZDir@4")
	xJoyUDir_ = GetProcAddress(lib, "_xJoyUDir@4")
	xJoyVDir_ = GetProcAddress(lib, "_xJoyVDir@4")
	xCountJoys = GetProcAddress(lib, "_xCountJoys@0")
	xCreateLight_ = GetProcAddress(lib, "_xCreateLight@4")
	xLightShadowEpsilons = GetProcAddress(lib, "_xLightShadowEpsilons@12")
	xLightEnableShadows = GetProcAddress(lib, "_xLightEnableShadows@8")
	xLightShadowsEnabled = GetProcAddress(lib, "_xLightShadowsEnabled@4")
	xLightRange = GetProcAddress(lib, "_xLightRange@8")
	xLightColor = GetProcAddress(lib, "_xLightColor@16")
	xLightConeAngles = GetProcAddress(lib, "_xLightConeAngles@12")
	xCreateLog_ = GetProcAddress(lib, "_xCreateLog@16")
	xCloseLog = GetProcAddress(lib, "_xCloseLog@0")
	xGetLogString = GetProcAddress(lib, "_xGetLogString@0")
	xClearLogString = GetProcAddress(lib, "_xClearLogString@0")
	xSetLogLevel_ = GetProcAddress(lib, "_xSetLogLevel@4")
	xSetLogTarget_ = GetProcAddress(lib, "_xSetLogTarget@4")
	xGetLogLevel = GetProcAddress(lib, "_xGetLogLevel@0")
	xGetLogTarget = GetProcAddress(lib, "_xGetLogTarget@0")
	xLogInfo_ = GetProcAddress(lib, "_xLogInfo@16")
	xLogMessage_ = GetProcAddress(lib, "_xLogMessage@16")
	xLogWarning_ = GetProcAddress(lib, "_xLogWarning@16")
	xLogError_ = GetProcAddress(lib, "_xLogError@16")
	xLogFatal_ = GetProcAddress(lib, "_xLogFatal@16")
	xCreateMesh_ = GetProcAddress(lib, "_xCreateMesh@4")
	xLoadMesh_ = GetProcAddress(lib, "_xLoadMesh@8")
	xLoadMeshWithChild_ = GetProcAddress(lib, "_xLoadMeshWithChild@8")
	xLoadAnimMesh_ = GetProcAddress(lib, "_xLoadAnimMesh@8")
	xCreateCube_ = GetProcAddress(lib, "_xCreateCube@4")
	xCreateSphere_ = GetProcAddress(lib, "_xCreateSphere@8")
	xCreateCylinder_ = GetProcAddress(lib, "_xCreateCylinder@12")
	xCreateTorus_ = GetProcAddress(lib, "_xCreateTorus@16")
	xCreateCone_ = GetProcAddress(lib, "_xCreateCone@12")
	xCopyMesh_ = GetProcAddress(lib, "_xCopyMesh@8")
	xAddMesh = GetProcAddress(lib, "_xAddMesh@8")
	xFlipMesh = GetProcAddress(lib, "_xFlipMesh@4")
	xPaintMesh = GetProcAddress(lib, "_xPaintMesh@8")
	xFitMesh_ = GetProcAddress(lib, "_xFitMesh@32")
	xMeshWidth_ = GetProcAddress(lib, "_xMeshWidth@8")
	xMeshHeight_ = GetProcAddress(lib, "_xMeshHeight@8")
	xMeshDepth_ = GetProcAddress(lib, "_xMeshDepth@8")
	xScaleMesh = GetProcAddress(lib, "_xScaleMesh@16")
	xRotateMesh = GetProcAddress(lib, "_xRotateMesh@16")
	xPositionMesh = GetProcAddress(lib, "_xPositionMesh@16")
	xUpdateNormals = GetProcAddress(lib, "_xUpdateNormals@4")
	xUpdateN = GetProcAddress(lib, "_xUpdateN@4")
	xUpdateTB = GetProcAddress(lib, "_xUpdateTB@4")
	xMeshesBBIntersect = GetProcAddress(lib, "_xMeshesBBIntersect@8")
	xMeshesIntersect = GetProcAddress(lib, "_xMeshesIntersect@8")
	xGetMeshVB = GetProcAddress(lib, "_xGetMeshVB@4")
	xGetMeshIB = GetProcAddress(lib, "_xGetMeshIB@4")
	xGetMeshVBSize = GetProcAddress(lib, "_xGetMeshVBSize@4")
	xGetMeshIBSize = GetProcAddress(lib, "_xGetMeshIBSize@4")
	xDeleteMeshVB = GetProcAddress(lib, "_xDeleteMeshVB@4")
	xDeleteMeshIB = GetProcAddress(lib, "_xDeleteMeshIB@4")
	xCountSurfaces = GetProcAddress(lib, "_xCountSurfaces@4")
	xGetSurface = GetProcAddress(lib, "_xGetSurface@8")
	xCreatePivot_ = GetProcAddress(lib, "_xCreatePivot@4")
	xFindSurface = GetProcAddress(lib, "_xFindSurface@8")
	xCreatePoly_ = GetProcAddress(lib, "_xCreatePoly@8")
	xMeshSingleSurface = GetProcAddress(lib, "_xMeshSingleSurface@4")
	xSaveMesh = GetProcAddress(lib, "_xSaveMesh@8")
	xLightMesh_ = GetProcAddress(lib, "_xLightMesh@32")
	xMeshPrimitiveType = GetProcAddress(lib, "_xMeshPrimitiveType@8")
	xParticlePosition = GetProcAddress(lib, "_xParticlePosition@16")
	xParticleX = GetProcAddress(lib, "_xParticleX@4")
	xParticleY = GetProcAddress(lib, "_xParticleY@4")
	xParticleZ = GetProcAddress(lib, "_xParticleZ@4")
	xParticleVeclocity = GetProcAddress(lib, "_xParticleVeclocity@16")
	xParticleVX = GetProcAddress(lib, "_xParticleVX@4")
	xParticleVY = GetProcAddress(lib, "_xParticleVY@4")
	xParticleVZ = GetProcAddress(lib, "_xParticleVZ@4")
	xParticleRotation = GetProcAddress(lib, "_xParticleRotation@16")
	xParticlePitch = GetProcAddress(lib, "_xParticlePitch@4")
	xParticleYaw = GetProcAddress(lib, "_xParticleYaw@4")
	xParticleRoll = GetProcAddress(lib, "_xParticleRoll@4")
	xParticleTorque = GetProcAddress(lib, "_xParticleTorque@16")
	xParticleTPitch = GetProcAddress(lib, "_xParticleTPitch@4")
	xParticleTYaw = GetProcAddress(lib, "_xParticleTYaw@4")
	xParticleTRoll = GetProcAddress(lib, "_xParticleTRoll@4")
	xParticleSetAlpha = GetProcAddress(lib, "_xParticleSetAlpha@8")
	xParticleGetAlpha = GetProcAddress(lib, "_xParticleGetAlpha@4")
	xParticleColor = GetProcAddress(lib, "_xParticleColor@16")
	xParticleRed = GetProcAddress(lib, "_xParticleRed@4")
	xParticleGreen = GetProcAddress(lib, "_xParticleGreen@4")
	xParticleBlue = GetProcAddress(lib, "_xParticleBlue@4")
	xParticleScale = GetProcAddress(lib, "_xParticleScale@12")
	xParticleSX = GetProcAddress(lib, "_xParticleSX@4")
	xParticleSY = GetProcAddress(lib, "_xParticleSY@4")
	xParticleScaleSpeed = GetProcAddress(lib, "_xParticleScaleSpeed@12")
	xParticleScaleSpeedX = GetProcAddress(lib, "_xParticleScaleSpeedX@4")
	xParticleScaleSpeedY = GetProcAddress(lib, "_xParticleScaleSpeedY@4")
	xEntityAddDummyShape = GetProcAddress(lib, "_xEntityAddDummyShape@4")
	xEntityAddBoxShape_ = GetProcAddress(lib, "_xEntityAddBoxShape@20")
	xEntityAddSphereShape_ = GetProcAddress(lib, "_xEntityAddSphereShape@12")
	xEntityAddCapsuleShape_ = GetProcAddress(lib, "_xEntityAddCapsuleShape@16")
	xEntityAddConeShape_ = GetProcAddress(lib, "_xEntityAddConeShape@16")
	xEntityAddCylinderShape_ = GetProcAddress(lib, "_xEntityAddCylinderShape@20")
	xEntityAddTriMeshShape = GetProcAddress(lib, "_xEntityAddTriMeshShape@4")
	xEntityAddTriMeshShapeProxy = GetProcAddress(lib, "_xEntityAddTriMeshShapeProxy@8")
	xEntityAddConvexShape = GetProcAddress(lib, "_xEntityAddConvexShape@8")
	xEntityAddConvexShapeProxy = GetProcAddress(lib, "_xEntityAddConvexShapeProxy@12")
	xEntityAddConcaveShape = GetProcAddress(lib, "_xEntityAddConcaveShape@8")
	xEntityAddConcaveShapeProxy = GetProcAddress(lib, "_xEntityAddConcaveShapeProxy@12")
	xEntityAddTerrainShape = GetProcAddress(lib, "_xEntityAddTerrainShape@4")
	xEntityAttachBody = GetProcAddress(lib, "_xEntityAttachBody@8")
	xEntityDetachBody = GetProcAddress(lib, "_xEntityDetachBody@4")
	xFreeEntityBody = GetProcAddress(lib, "_xFreeEntityBody@4")
	xEntityAddCompoundShape = GetProcAddress(lib, "_xEntityAddCompoundShape@8")
	xEntityCompoundAddBox = GetProcAddress(lib, "_xEntityCompoundAddBox@16")
	xEntityCompoundAddSphere = GetProcAddress(lib, "_xEntityCompoundAddSphere@8")
	xEntityCompoundAddCapsule = GetProcAddress(lib, "_xEntityCompoundAddCapsule@12")
	xEntityCompoundAddCone = GetProcAddress(lib, "_xEntityCompoundAddCone@12")
	xEntityCompoundAddCylinder = GetProcAddress(lib, "_xEntityCompoundAddCylinder@12")
	xEntityCompoundCountChildren = GetProcAddress(lib, "_xEntityCompoundCountChildren@4")
	xEntityCompoundRemoveChild = GetProcAddress(lib, "_xEntityCompoundRemoveChild@8")
	xEntityCompoundChildSetPosition = GetProcAddress(lib, "_xEntityCompoundChildSetPosition@20")
	xEntityCompoundChildGetX = GetProcAddress(lib, "_xEntityCompoundChildGetX@8")
	xEntityCompoundChildGetY = GetProcAddress(lib, "_xEntityCompoundChildGetY@8")
	xEntityCompoundChildGetZ = GetProcAddress(lib, "_xEntityCompoundChildGetZ@8")
	xEntityCompoundChildSetRotation = GetProcAddress(lib, "_xEntityCompoundChildSetRotation@20")
	xEntityCompoundChildGetPitch = GetProcAddress(lib, "_xEntityCompoundChildGetPitch@8")
	xEntityCompoundChildGetYaw = GetProcAddress(lib, "_xEntityCompoundChildGetYaw@8")
	xEntityCompoundChildGetRoll = GetProcAddress(lib, "_xEntityCompoundChildGetRoll@8")
	xCreateHingeJoint_ = GetProcAddress(lib, "_xCreateHingeJoint@36")
	xCreateBallJoint_ = GetProcAddress(lib, "_xCreateBallJoint@24")
	xCreateD6Joint_ = GetProcAddress(lib, "_xCreateD6Joint@40")
	xCreateD6SpringJoint_ = GetProcAddress(lib, "_xCreateD6SpringJoint@40")
	xJointHingeGetAngle = GetProcAddress(lib, "_xJointHingeGetAngle@4")
	xJointD6GetPitchAngle = GetProcAddress(lib, "_xJointD6GetPitchAngle@4")
	xJointD6GetYawAngle = GetProcAddress(lib, "_xJointD6GetYawAngle@4")
	xJointD6GetRollAngle = GetProcAddress(lib, "_xJointD6GetRollAngle@4")
	xJointD6GetAngle_ = GetProcAddress(lib, "_xJointD6GetAngle@8")
	xJointDisableCollisions = GetProcAddress(lib, "_xJointDisableCollisions@8")
	xJointEnable = GetProcAddress(lib, "_xJointEnable@8")
	xJointIsEnabled = GetProcAddress(lib, "_xJointIsEnabled@4")
	xJointGetImpulse = GetProcAddress(lib, "_xJointGetImpulse@4")
	xFreeJoint = GetProcAddress(lib, "_xFreeJoint@4")
	xJointBallSetPivot_ = GetProcAddress(lib, "_xJointBallSetPivot@20")
	xJointBallGetPivotX_ = GetProcAddress(lib, "_xJointBallGetPivotX@8")
	xJointBallGetPivotY_ = GetProcAddress(lib, "_xJointBallGetPivotY@8")
	xJointBallGetPivotZ_ = GetProcAddress(lib, "_xJointBallGetPivotZ@8")
	xJointD6SetLimits = GetProcAddress(lib, "_xJointD6SetLimits@16")
	xJointD6SetLowerLinearLimits = GetProcAddress(lib, "_xJointD6SetLowerLinearLimits@16")
	xJointD6SetUpperLinearLimits = GetProcAddress(lib, "_xJointD6SetUpperLinearLimits@16")
	xJointD6SetLowerAngularLimits = GetProcAddress(lib, "_xJointD6SetLowerAngularLimits@16")
	xJointD6SetUpperAngularLimits = GetProcAddress(lib, "_xJointD6SetUpperAngularLimits@16")
	xJointD6SetLinearLimits = GetProcAddress(lib, "_xJointD6SetLinearLimits@28")
	xJointD6SetAngularLimits = GetProcAddress(lib, "_xJointD6SetAngularLimits@28")
	xJointD6GetLinearLowerX = GetProcAddress(lib, "_xJointD6GetLinearLowerX@4")
	xJointD6GetLinearLowerY = GetProcAddress(lib, "_xJointD6GetLinearLowerY@4")
	xJointD6GetLinearLowerZ = GetProcAddress(lib, "_xJointD6GetLinearLowerZ@4")
	xJointD6GetLinearUpperX = GetProcAddress(lib, "_xJointD6GetLinearUpperX@4")
	xJointD6GetLinearUpperY = GetProcAddress(lib, "_xJointD6GetLinearUpperY@4")
	xJointD6GetLinearUpperZ = GetProcAddress(lib, "_xJointD6GetLinearUpperZ@4")
	xJointD6GetAngularLowerX = GetProcAddress(lib, "_xJointD6GetAngularLowerX@4")
	xJointD6GetAngularLowerY = GetProcAddress(lib, "_xJointD6GetAngularLowerY@4")
	xJointD6GetAngularLowerZ = GetProcAddress(lib, "_xJointD6GetAngularLowerZ@4")
	xJointD6GetAngularUpperX = GetProcAddress(lib, "_xJointD6GetAngularUpperX@4")
	xJointD6GetAngularUpperY = GetProcAddress(lib, "_xJointD6GetAngularUpperY@4")
	xJointD6GetAngularUpperZ = GetProcAddress(lib, "_xJointD6GetAngularUpperZ@4")
	xJointD6SpringSetParam_ = GetProcAddress(lib, "_xJointD6SpringSetParam@20")
	xJointHingeSetAxis = GetProcAddress(lib, "_xJointHingeSetAxis@16")
	xJointHingeSetLimits_ = GetProcAddress(lib, "_xJointHingeSetLimits@24")
	xJointHingeGetLowerLimit = GetProcAddress(lib, "_xJointHingeGetLowerLimit@4")
	xJointHingeGetUpperLimit = GetProcAddress(lib, "_xJointHingeGetUpperLimit@4")
	xJointEnableMotor_ = GetProcAddress(lib, "_xJointEnableMotor@20")
	xJointHingeSetMotorTarget = GetProcAddress(lib, "_xJointHingeSetMotorTarget@12")
	xJointGetEntityA = GetProcAddress(lib, "_xJointGetEntityA@4")
	xJointGetEntityB = GetProcAddress(lib, "_xJointGetEntityB@4")
	xEntityApplyCentralForce_ = GetProcAddress(lib, "_xEntityApplyCentralForce@20")
	xEntityApplyCentralImpulse_ = GetProcAddress(lib, "_xEntityApplyCentralImpulse@20")
	xEntityApplyTorque_ = GetProcAddress(lib, "_xEntityApplyTorque@20")
	xEntityApplyTorqueImpulse_ = GetProcAddress(lib, "_xEntityApplyTorqueImpulse@20")
	xEntityApplyForce_ = GetProcAddress(lib, "_xEntityApplyForce@36")
	xEntityApplyImpulse_ = GetProcAddress(lib, "_xEntityApplyImpulse@36")
	xEntityReleaseForces = GetProcAddress(lib, "_xEntityReleaseForces@4")
	xWorldSetGravity_ = GetProcAddress(lib, "_xWorldSetGravity@16")
	xWorldGetGravityX_ = GetProcAddress(lib, "_xWorldGetGravityX@4")
	xWorldGetGravityY_ = GetProcAddress(lib, "_xWorldGetGravityY@4")
	xWorldGetGravityZ_ = GetProcAddress(lib, "_xWorldGetGravityZ@4")
	xEntitySetGravity = GetProcAddress(lib, "_xEntitySetGravity@16")
	xEntityGetGravityX = GetProcAddress(lib, "_xEntityGetGravityX@4")
	xEntityGetGravityY = GetProcAddress(lib, "_xEntityGetGravityY@4")
	xEntityGetGravityZ = GetProcAddress(lib, "_xEntityGetGravityZ@4")
	xEntitySetLinearVelocity_ = GetProcAddress(lib, "_xEntitySetLinearVelocity@20")
	xEntityGetLinearVelocityX_ = GetProcAddress(lib, "_xEntityGetLinearVelocityX@8")
	xEntityGetLinearVelocityY_ = GetProcAddress(lib, "_xEntityGetLinearVelocityY@8")
	xEntityGetLinearVelocityZ_ = GetProcAddress(lib, "_xEntityGetLinearVelocityZ@8")
	xEntitySetAngularVelocity_ = GetProcAddress(lib, "_xEntitySetAngularVelocity@20")
	xEntityGetAngularVelocityX_ = GetProcAddress(lib, "_xEntityGetAngularVelocityX@8")
	xEntityGetAngularVelocityY_ = GetProcAddress(lib, "_xEntityGetAngularVelocityY@8")
	xEntityGetAngularVelocityZ_ = GetProcAddress(lib, "_xEntityGetAngularVelocityZ@8")
	xEntitySetDamping = GetProcAddress(lib, "_xEntitySetDamping@12")
	xEntityGetLinearDamping = GetProcAddress(lib, "_xEntityGetLinearDamping@4")
	xEntityGetAngularDamping = GetProcAddress(lib, "_xEntityGetAngularDamping@4")
	xEntitySetFriction = GetProcAddress(lib, "_xEntitySetFriction@8")
	xEntityGetFriction = GetProcAddress(lib, "_xEntityGetFriction@4")
	xEntitySetAnisotropicFriction = GetProcAddress(lib, "_xEntitySetAnisotropicFriction@16")
	xEntityGetAnisotropicFrictionX = GetProcAddress(lib, "_xEntityGetAnisotropicFrictionX@4")
	xEntityGetAnisotropicFrictionY = GetProcAddress(lib, "_xEntityGetAnisotropicFrictionY@4")
	xEntityGetAnisotropicFrictionZ = GetProcAddress(lib, "_xEntityGetAnisotropicFrictionZ@4")
	xEntitySetLinearFactor = GetProcAddress(lib, "_xEntitySetLinearFactor@16")
	xEntityGetLinearFactorX = GetProcAddress(lib, "_xEntityGetLinearFactorX@4")
	xEntityGetLinearFactorY = GetProcAddress(lib, "_xEntityGetLinearFactorY@4")
	xEntityGetLinearFactorZ = GetProcAddress(lib, "_xEntityGetLinearFactorZ@4")
	xEntitySetAngularFactor = GetProcAddress(lib, "_xEntitySetAngularFactor@16")
	xEntityGetAngularFactorX = GetProcAddress(lib, "_xEntityGetAngularFactorX@4")
	xEntityGetAngularFactorY = GetProcAddress(lib, "_xEntityGetAngularFactorY@4")
	xEntityGetAngularFactorZ = GetProcAddress(lib, "_xEntityGetAngularFactorZ@4")
	xEntitySetRestitution = GetProcAddress(lib, "_xEntitySetRestitution@8")
	xEntityGetRestitution = GetProcAddress(lib, "_xEntityGetRestitution@4")
	xEntitySetMass = GetProcAddress(lib, "_xEntitySetMass@8")
	xEntityGetMass = GetProcAddress(lib, "_xEntityGetMass@4")
	xEntityCountContacts = GetProcAddress(lib, "_xEntityCountContacts@4")
	xEntityGetContactX = GetProcAddress(lib, "_xEntityGetContactX@8")
	xEntityGetContactY = GetProcAddress(lib, "_xEntityGetContactY@8")
	xEntityGetContactZ = GetProcAddress(lib, "_xEntityGetContactZ@8")
	xEntityGetContactNX = GetProcAddress(lib, "_xEntityGetContactNX@8")
	xEntityGetContactNY = GetProcAddress(lib, "_xEntityGetContactNY@8")
	xEntityGetContactNZ = GetProcAddress(lib, "_xEntityGetContactNZ@8")
	xEntityGetContactDistance = GetProcAddress(lib, "_xEntityGetContactDistance@8")
	xEntityGetContact = GetProcAddress(lib, "_xEntityGetContact@8")
	xEntityGetContactImpulse = GetProcAddress(lib, "_xEntityGetContactImpulse@8")
	xEntitySetCollisionGroup = GetProcAddress(lib, "_xEntitySetCollisionGroup@8")
	xEntityGetCollisionGroup = GetProcAddress(lib, "_xEntityGetCollisionGroup@4")
	xEntitySetContactGroup = GetProcAddress(lib, "_xEntitySetContactGroup@8")
	xEntityGetContactGroup = GetProcAddress(lib, "_xEntityGetContactGroup@4")
	xEntitySetRaycastGroup = GetProcAddress(lib, "_xEntitySetRaycastGroup@8")
	xEntityGetRaycastGroup = GetProcAddress(lib, "_xEntityGetRaycastGroup@4")
	xPhysicsSetCollisionFilter = GetProcAddress(lib, "_xPhysicsSetCollisionFilter@12")
	xPhysicsGetCollisionFilter = GetProcAddress(lib, "_xPhysicsGetCollisionFilter@8")
	xPhysicsSetContactFilter = GetProcAddress(lib, "_xPhysicsSetContactFilter@12")
	xPhysicsGetContactFilter = GetProcAddress(lib, "_xPhysicsGetContactFilter@8")
	xPhysicsSetRaycastFilter = GetProcAddress(lib, "_xPhysicsSetRaycastFilter@12")
	xPhysicsGetRaycastFilter = GetProcAddress(lib, "_xPhysicsGetRaycastFilter@8")
	xEntityIsSleeping = GetProcAddress(lib, "_xEntityIsSleeping@4")
	xEntityDisableSleeping_ = GetProcAddress(lib, "_xEntityDisableSleeping@8")
	xEntityWakeUp = GetProcAddress(lib, "_xEntityWakeUp@4")
	xEntitySleep = GetProcAddress(lib, "_xEntitySleep@4")
	xEntitySetSleepingThresholds = GetProcAddress(lib, "_xEntitySetSleepingThresholds@12")
	xEntityGetLinearSleepingThreshold = GetProcAddress(lib, "_xEntityGetLinearSleepingThreshold@4")
	xEntityGetAngularSleepingThreshold = GetProcAddress(lib, "_xEntityGetAngularSleepingThreshold@4")
	xPhysicsRayCast_ = GetProcAddress(lib, "_xPhysicsRayCast@32")
	xPhysicsGetHitEntity_ = GetProcAddress(lib, "_xPhysicsGetHitEntity@4")
	xPhysicsGetHitPointX_ = GetProcAddress(lib, "_xPhysicsGetHitPointX@4")
	xPhysicsGetHitPointY_ = GetProcAddress(lib, "_xPhysicsGetHitPointY@4")
	xPhysicsGetHitPointZ_ = GetProcAddress(lib, "_xPhysicsGetHitPointZ@4")
	xPhysicsGetHitNormalX_ = GetProcAddress(lib, "_xPhysicsGetHitNormalX@4")
	xPhysicsGetHitNormalY_ = GetProcAddress(lib, "_xPhysicsGetHitNormalY@4")
	xPhysicsGetHitNormalZ_ = GetProcAddress(lib, "_xPhysicsGetHitNormalZ@4")
	xPhysicsGetHitDistance_ = GetProcAddress(lib, "_xPhysicsGetHitDistance@4")
	xPhysicsCountHits = GetProcAddress(lib, "_xPhysicsCountHits@0")
	xEntityBodyLocalPosition = GetProcAddress(lib, "_xEntityBodyLocalPosition@16")
	xEntityBodyLocalRotation = GetProcAddress(lib, "_xEntityBodyLocalRotation@16")
	xEntityBodyLocalScale = GetProcAddress(lib, "_xEntityBodyLocalScale@16")
	xWorldSetFrequency_ = GetProcAddress(lib, "_xWorldSetFrequency@8")
	xEntityMakeKinematic = GetProcAddress(lib, "_xEntityMakeKinematic@8")
	xEntityIsKinematic = GetProcAddress(lib, "_xEntityIsKinematic@4")
	xPhysicsDebugRender = GetProcAddress(lib, "_xPhysicsDebugRender@4")
	xEntityDisableSimulation = GetProcAddress(lib, "_xEntityDisableSimulation@8")
	xEntityHasBody = GetProcAddress(lib, "_xEntityHasBody@4")
	xEntityCreateVehicle = GetProcAddress(lib, "_xEntityCreateVehicle@4")
	xEntityFreeVehicle = GetProcAddress(lib, "_xEntityFreeVehicle@4")
	xEntityCountWheels = GetProcAddress(lib, "_xEntityCountWheels@4")
	xEntityAddWheel = GetProcAddress(lib, "_xEntityAddWheel@8")
	xEntityWheelSetRadius = GetProcAddress(lib, "_xEntityWheelSetRadius@12")
	xEntityWheelSetAxle = GetProcAddress(lib, "_xEntityWheelSetAxle@20")
	xEntityWheelSetRay = GetProcAddress(lib, "_xEntityWheelSetRay@20")
	xEntityWheelSetSuspensionLength = GetProcAddress(lib, "_xEntityWheelSetSuspensionLength@12")
	xEntityWheelSetBrake = GetProcAddress(lib, "_xEntityWheelSetBrake@12")
	xEntityWheelSetMaxSuspensionForce = GetProcAddress(lib, "_xEntityWheelSetMaxSuspensionForce@12")
	xEntityWheelSetMaxSuspensionTravel = GetProcAddress(lib, "_xEntityWheelSetMaxSuspensionTravel@12")
	xEntityWheelSetSuspensionStiffness = GetProcAddress(lib, "_xEntityWheelSetSuspensionStiffness@12")
	xEntityWheelSetSuspensionDamping = GetProcAddress(lib, "_xEntityWheelSetSuspensionDamping@12")
	xEntityWheelSetSuspensionCompression = GetProcAddress(lib, "_xEntityWheelSetSuspensionCompression@12")
	xEntityWheelSetFriction = GetProcAddress(lib, "_xEntityWheelSetFriction@12")
	xEntityWheelSetEngineForce = GetProcAddress(lib, "_xEntityWheelSetEngineForce@12")
	xEntityWheelSetRollInfluence = GetProcAddress(lib, "_xEntityWheelSetRollInfluence@12")
	xEntityWheelSetRotation = GetProcAddress(lib, "_xEntityWheelSetRotation@12")
	xEntityWheelSetSteering = GetProcAddress(lib, "_xEntityWheelSetSteering@12")
	xEntityWheelSetConnectionPoint_ = GetProcAddress(lib, "_xEntityWheelSetConnectionPoint@24")
	xEntityWheelGetSuspensionLength = GetProcAddress(lib, "_xEntityWheelGetSuspensionLength@8")
	xEntityWheelGetPitch = GetProcAddress(lib, "_xEntityWheelGetPitch@8")
	xEntityWheelGetYaw = GetProcAddress(lib, "_xEntityWheelGetYaw@8")
	xEntityWheelGetRoll = GetProcAddress(lib, "_xEntityWheelGetRoll@8")
	xEntityWheelGetContactEntity = GetProcAddress(lib, "_xEntityWheelGetContactEntity@8")
	xLoadPostEffect = GetProcAddress(lib, "_xLoadPostEffect@4")
	xFreePostEffect = GetProcAddress(lib, "_xFreePostEffect@4")
	xSetPostEffect_ = GetProcAddress(lib, "_xSetPostEffect@12")
	xRenderPostEffects = GetProcAddress(lib, "_xRenderPostEffects@0")
	xSetPostEffectInt = GetProcAddress(lib, "_xSetPostEffectInt@12")
	xSetPostEffectFloat = GetProcAddress(lib, "_xSetPostEffectFloat@12")
	xSetPostEffectBool = GetProcAddress(lib, "_xSetPostEffectBool@12")
	xSetPostEffectVector_ = GetProcAddress(lib, "_xSetPostEffectVector@24")
	xSetPostEffectTexture_ = GetProcAddress(lib, "_xSetPostEffectTexture@16")
	xDeletePostEffectConstant = GetProcAddress(lib, "_xDeletePostEffectConstant@8")
	xClearPostEffectConstants = GetProcAddress(lib, "_xClearPostEffectConstants@4")
	xCreatePSystem_ = GetProcAddress(lib, "_xCreatePSystem@4")
	xPSystemType = GetProcAddress(lib, "_xPSystemType@4")
	xPSystemSetBlend = GetProcAddress(lib, "_xPSystemSetBlend@8")
	xPSystemGetBlend = GetProcAddress(lib, "_xPSystemGetBlend@4")
	xPSystemSetMaxParticles = GetProcAddress(lib, "_xPSystemSetMaxParticles@8")
	xPSystemGetMaxParticles = GetProcAddress(lib, "_xPSystemGetMaxParticles@4")
	xPSystemSetEmitterLifetime = GetProcAddress(lib, "_xPSystemSetEmitterLifetime@8")
	xPSystemGetEmitterLifetime = GetProcAddress(lib, "_xPSystemGetEmitterLifetime@4")
	xPSystemSetParticleLifetime = GetProcAddress(lib, "_xPSystemSetParticleLifetime@8")
	xPSystemGetParticleLifetime = GetProcAddress(lib, "_xPSystemGetParticleLifetime@4")
	xPSystemSetCreationInterval = GetProcAddress(lib, "_xPSystemSetCreationInterval@8")
	xPSystemGetCreationInterval = GetProcAddress(lib, "_xPSystemGetCreationInterval@4")
	xPSystemSetCreationFrequency = GetProcAddress(lib, "_xPSystemSetCreationFrequency@8")
	xPSystemGetCreationFrequency = GetProcAddress(lib, "_xPSystemGetCreationFrequency@4")
	xPSystemSetTexture = GetProcAddress(lib, "_xPSystemSetTexture@16")
	xPSystemGetTexture = GetProcAddress(lib, "_xPSystemGetTexture@4")
	xPSystemGetTextureFrames = GetProcAddress(lib, "_xPSystemGetTextureFrames@4")
	xPSystemGetTextureAnimationSpeed = GetProcAddress(lib, "_xPSystemGetTextureAnimationSpeed@4")
	xPSystemSetOffset = GetProcAddress(lib, "_xPSystemSetOffset@28")
	xPSystemGetOffsetMinX = GetProcAddress(lib, "_xPSystemGetOffsetMinX@4")
	xPSystemGetOffsetMinY = GetProcAddress(lib, "_xPSystemGetOffsetMinY@4")
	xPSystemGetOffsetMinZ = GetProcAddress(lib, "_xPSystemGetOffsetMinZ@4")
	xPSystemGetOffsetMaxX = GetProcAddress(lib, "_xPSystemGetOffsetMaxX@4")
	xPSystemGetOffsetMaxY = GetProcAddress(lib, "_xPSystemGetOffsetMaxY@4")
	xPSystemGetOffsetMaxZ = GetProcAddress(lib, "_xPSystemGetOffsetMaxZ@4")
	xPSystemSetVelocity = GetProcAddress(lib, "_xPSystemSetVelocity@28")
	xPSystemGetVelocityMinX = GetProcAddress(lib, "_xPSystemGetVelocityMinX@4")
	xPSystemGetVelocityMinY = GetProcAddress(lib, "_xPSystemGetVelocityMinY@4")
	xPSystemGetVelocityMinZ = GetProcAddress(lib, "_xPSystemGetVelocityMinZ@4")
	xPSystemGetVelocityMaxX = GetProcAddress(lib, "_xPSystemGetVelocityMaxX@4")
	xPSystemGetVelocityMaxY = GetProcAddress(lib, "_xPSystemGetVelocityMaxY@4")
	xPSystemGetVelocityMaxZ = GetProcAddress(lib, "_xPSystemGetVelocityMaxZ@4")
	xPSystemEnableFixedQuads = GetProcAddress(lib, "_xPSystemEnableFixedQuads@8")
	xPSystemFixedQuadsUsed = GetProcAddress(lib, "_xPSystemFixedQuadsUsed@4")
	xPSystemSetTorque = GetProcAddress(lib, "_xPSystemSetTorque@28")
	xPSystemGetTorqueMinX = GetProcAddress(lib, "_xPSystemGetTorqueMinX@4")
	xPSystemGetTorqueMinY = GetProcAddress(lib, "_xPSystemGetTorqueMinY@4")
	xPSystemGetTorqueMinZ = GetProcAddress(lib, "_xPSystemGetTorqueMinZ@4")
	xPSystemGetTorqueMaxX = GetProcAddress(lib, "_xPSystemGetTorqueMaxX@4")
	xPSystemGetTorqueMaxY = GetProcAddress(lib, "_xPSystemGetTorqueMaxY@4")
	xPSystemGetTorqueMaxZ = GetProcAddress(lib, "_xPSystemGetTorqueMaxZ@4")
	xPSystemSetGravity = GetProcAddress(lib, "_xPSystemSetGravity@8")
	xPSystemGetGravity = GetProcAddress(lib, "_xPSystemGetGravity@4")
	xPSystemSetAlpha = GetProcAddress(lib, "_xPSystemSetAlpha@8")
	xPSystemGetAlpha = GetProcAddress(lib, "_xPSystemGetAlpha@4")
	xPSystemSetFadeSpeed = GetProcAddress(lib, "_xPSystemSetFadeSpeed@8")
	xPSystemGetFadeSpeed = GetProcAddress(lib, "_xPSystemGetFadeSpeed@4")
	xPSystemSetParticleSize = GetProcAddress(lib, "_xPSystemSetParticleSize@20")
	xPSystemGetSizeMinX = GetProcAddress(lib, "_xPSystemGetSizeMinX@4")
	xPSystemGetSizeMinY = GetProcAddress(lib, "_xPSystemGetSizeMinY@4")
	xPSystemGetSizeMaxX = GetProcAddress(lib, "_xPSystemGetSizeMaxX@4")
	xPSystemGetSizeMaxY = GetProcAddress(lib, "_xPSystemGetSizeMaxY@4")
	xPSystemSetScaleSpeed = GetProcAddress(lib, "_xPSystemSetScaleSpeed@20")
	xPSystemGetScaleSpeedMinX = GetProcAddress(lib, "_xPSystemGetScaleSpeedMinX@4")
	xPSystemGetScaleSpeedMinY = GetProcAddress(lib, "_xPSystemGetScaleSpeedMinY@4")
	xPSystemGetScaleSpeedMaxX = GetProcAddress(lib, "_xPSystemGetScaleSpeedMaxX@4")
	xPSystemGetScaleSpeedMaxY = GetProcAddress(lib, "_xPSystemGetScaleSpeedMaxY@4")
	xPSystemSetAngles = GetProcAddress(lib, "_xPSystemSetAngles@28")
	xPSystemGetAnglesMinX = GetProcAddress(lib, "_xPSystemGetAnglesMinX@4")
	xPSystemGetAnglesMinY = GetProcAddress(lib, "_xPSystemGetAnglesMinY@4")
	xPSystemGetAnglesMinZ = GetProcAddress(lib, "_xPSystemGetAnglesMinZ@4")
	xPSystemGetAnglesMaxX = GetProcAddress(lib, "_xPSystemGetAnglesMaxX@4")
	xPSystemGetAnglesMaxY = GetProcAddress(lib, "_xPSystemGetAnglesMaxY@4")
	xPSystemGetAnglesMaxZ = GetProcAddress(lib, "_xPSystemGetAnglesMaxZ@4")
	xPSystemSetColorMode = GetProcAddress(lib, "_xPSystemSetColorMode@8")
	xPSystemGetColorMode = GetProcAddress(lib, "_xPSystemGetColorMode@4")
	xPSystemSetColors = GetProcAddress(lib, "_xPSystemSetColors@28")
	xPSystemGetBeginColorRed = GetProcAddress(lib, "_xPSystemGetBeginColorRed@4")
	xPSystemGetBeginColorGreen = GetProcAddress(lib, "_xPSystemGetBeginColorGreen@4")
	xPSystemGetBeginColorBlue = GetProcAddress(lib, "_xPSystemGetBeginColorBlue@4")
	xPSystemGetEndColorRed = GetProcAddress(lib, "_xPSystemGetEndColorRed@4")
	xPSystemGetEndColorGreen = GetProcAddress(lib, "_xPSystemGetEndColorGreen@4")
	xPSystemGetEndColorBlue = GetProcAddress(lib, "_xPSystemGetEndColorBlue@4")
	xFreePSystem = GetProcAddress(lib, "_xFreePSystem@4")
	xPSystemSetParticleParenting = GetProcAddress(lib, "_xPSystemSetParticleParenting@8")
	xPSystemGetParticleParenting = GetProcAddress(lib, "_xPSystemGetParticleParenting@4")
	xLinePick_ = GetProcAddress(lib, "_xLinePick@28")
	xEntityPick_ = GetProcAddress(lib, "_xEntityPick@8")
	xCameraPick = GetProcAddress(lib, "_xCameraPick@12")
	xPickedNX = GetProcAddress(lib, "_xPickedNX@0")
	xPickedNY = GetProcAddress(lib, "_xPickedNY@0")
	xPickedNZ = GetProcAddress(lib, "_xPickedNZ@0")
	xPickedX = GetProcAddress(lib, "_xPickedX@0")
	xPickedY = GetProcAddress(lib, "_xPickedY@0")
	xPickedZ = GetProcAddress(lib, "_xPickedZ@0")
	xPickedEntity = GetProcAddress(lib, "_xPickedEntity@0")
	xPickedSurface = GetProcAddress(lib, "_xPickedSurface@0")
	xPickedTriangle = GetProcAddress(lib, "_xPickedTriangle@0")
	xPickedTime = GetProcAddress(lib, "_xPickedTime@0")
	xSetShadowsBlur = GetProcAddress(lib, "_xSetShadowsBlur@4")
	xSetShadowShader = GetProcAddress(lib, "_xSetShadowShader@4")
	xInitShadows = GetProcAddress(lib, "_xInitShadows@12")
	xSetShadowParams_ = GetProcAddress(lib, "_xSetShadowParams@16")
	xRenderShadows = GetProcAddress(lib, "_xRenderShadows@8")
	xShadowPriority = GetProcAddress(lib, "_xShadowPriority@4")
	xCameraDisableShadows = GetProcAddress(lib, "_xCameraDisableShadows@4")
	xCameraEnableShadows = GetProcAddress(lib, "_xCameraEnableShadows@4")
	xEntityCastShadows = GetProcAddress(lib, "_xEntityCastShadows@12")
	xEntityReceiveShadows = GetProcAddress(lib, "_xEntityReceiveShadows@12")
	xEntityIsCaster = GetProcAddress(lib, "_xEntityIsCaster@8")
	xEntityIsReceiver = GetProcAddress(lib, "_xEntityIsReceiver@8")
	xLoadSound = GetProcAddress(lib, "_xLoadSound@4")
	xLoad3DSound = GetProcAddress(lib, "_xLoad3DSound@4")
	xFreeSound = GetProcAddress(lib, "_xFreeSound@4")
	xLoopSound = GetProcAddress(lib, "_xLoopSound@4")
	xSoundPitch = GetProcAddress(lib, "_xSoundPitch@8")
	xSoundVolume = GetProcAddress(lib, "_xSoundVolume@8")
	xSoundPan = GetProcAddress(lib, "_xSoundPan@8")
	xPlaySound = GetProcAddress(lib, "_xPlaySound@4")
	xStopChannel = GetProcAddress(lib, "_xStopChannel@4")
	xPauseChannel = GetProcAddress(lib, "_xPauseChannel@4")
	xResumeChannel = GetProcAddress(lib, "_xResumeChannel@4")
	xPlayMusic = GetProcAddress(lib, "_xPlayMusic@4")
	xChannelPitch = GetProcAddress(lib, "_xChannelPitch@8")
	xChannelVolume = GetProcAddress(lib, "_xChannelVolume@8")
	xChannelPan = GetProcAddress(lib, "_xChannelPan@8")
	xChannelPlaying = GetProcAddress(lib, "_xChannelPlaying@4")
	xEmitSound = GetProcAddress(lib, "_xEmitSound@8")
	xCreateListener_ = GetProcAddress(lib, "_xCreateListener@16")
	xGetListener = GetProcAddress(lib, "_xGetListener@0")
	xInitalizeSound = GetProcAddress(lib, "_xInitalizeSound@0")
	xCreateSprite_ = GetProcAddress(lib, "_xCreateSprite@4")
	xSpriteViewMode = GetProcAddress(lib, "_xSpriteViewMode@8")
	xHandleSprite = GetProcAddress(lib, "_xHandleSprite@12")
	xLoadSprite_ = GetProcAddress(lib, "_xLoadSprite@12")
	xRotateSprite = GetProcAddress(lib, "_xRotateSprite@8")
	xScaleSprite = GetProcAddress(lib, "_xScaleSprite@12")
	xCreateSurface_ = GetProcAddress(lib, "_xCreateSurface@12")
	xGetSurfaceBrush = GetProcAddress(lib, "_xGetSurfaceBrush@4")
	xAddVertex_ = GetProcAddress(lib, "_xAddVertex@28")
	xAddTriangle = GetProcAddress(lib, "_xAddTriangle@16")
	xSetSurfaceFrustumSphere = GetProcAddress(lib, "_xSetSurfaceFrustumSphere@20")
	xVertexCoords = GetProcAddress(lib, "_xVertexCoords@20")
	xVertexNormal = GetProcAddress(lib, "_xVertexNormal@20")
	xVertexTangent = GetProcAddress(lib, "_xVertexTangent@20")
	xVertexBinormal = GetProcAddress(lib, "_xVertexBinormal@20")
	xVertexColor_ = GetProcAddress(lib, "_xVertexColor@24")
	xVertexTexCoords_ = GetProcAddress(lib, "_xVertexTexCoords@24")
	xCountVertices = GetProcAddress(lib, "_xCountVertices@4")
	xVertexX = GetProcAddress(lib, "_xVertexX@8")
	xVertexY = GetProcAddress(lib, "_xVertexY@8")
	xVertexZ = GetProcAddress(lib, "_xVertexZ@8")
	xVertexNX = GetProcAddress(lib, "_xVertexNX@8")
	xVertexNY = GetProcAddress(lib, "_xVertexNY@8")
	xVertexNZ = GetProcAddress(lib, "_xVertexNZ@8")
	xVertexTX = GetProcAddress(lib, "_xVertexTX@8")
	xVertexTY = GetProcAddress(lib, "_xVertexTY@8")
	xVertexTZ = GetProcAddress(lib, "_xVertexTZ@8")
	xVertexBX = GetProcAddress(lib, "_xVertexBX@8")
	xVertexBY = GetProcAddress(lib, "_xVertexBY@8")
	xVertexBZ = GetProcAddress(lib, "_xVertexBZ@8")
	xVertexU_ = GetProcAddress(lib, "_xVertexU@12")
	xVertexV_ = GetProcAddress(lib, "_xVertexV@12")
	xVertexW_ = GetProcAddress(lib, "_xVertexW@12")
	xVertexRed = GetProcAddress(lib, "_xVertexRed@8")
	xVertexGreen = GetProcAddress(lib, "_xVertexGreen@8")
	xVertexBlue = GetProcAddress(lib, "_xVertexBlue@8")
	xVertexAlpha = GetProcAddress(lib, "_xVertexAlpha@8")
	xTriangleVertex = GetProcAddress(lib, "_xTriangleVertex@12")
	xCountTriangles = GetProcAddress(lib, "_xCountTriangles@4")
	xPaintSurface = GetProcAddress(lib, "_xPaintSurface@8")
	xClearSurface_ = GetProcAddress(lib, "_xClearSurface@12")
	xGetSurfaceTexture_ = GetProcAddress(lib, "_xGetSurfaceTexture@8")
	xFreeSurface = GetProcAddress(lib, "_xFreeSurface@4")
	xSurfacePrimitiveType = GetProcAddress(lib, "_xSurfacePrimitiveType@8")
	xSurfaceTexture = GetProcAddress(lib, "_xSurfaceTexture@16")
	xSurfaceColor = GetProcAddress(lib, "_xSurfaceColor@16")
	xSurfaceAlpha = GetProcAddress(lib, "_xSurfaceAlpha@8")
	xSurfaceShininess = GetProcAddress(lib, "_xSurfaceShininess@8")
	xSurfaceBlend = GetProcAddress(lib, "_xSurfaceBlend@8")
	xSurfaceFX = GetProcAddress(lib, "_xSurfaceFX@8")
	xSurfaceAlphaRef = GetProcAddress(lib, "_xSurfaceAlphaRef@8")
	xSurfaceAlphaFunc = GetProcAddress(lib, "_xSurfaceAlphaFunc@8")
	xCPUName = GetProcAddress(lib, "_xCPUName@0")
	xCPUVendor = GetProcAddress(lib, "_xCPUVendor@0")
	xCPUFamily = GetProcAddress(lib, "_xCPUFamily@0")
	xCPUModel = GetProcAddress(lib, "_xCPUModel@0")
	xCPUStepping = GetProcAddress(lib, "_xCPUStepping@0")
	xCPUSpeed = GetProcAddress(lib, "_xCPUSpeed@0")
	xVideoInfo = GetProcAddress(lib, "_xVideoInfo@0")
	xVideoAspectRatio = GetProcAddress(lib, "_xVideoAspectRatio@0")
	xVideoAspectRatioStr = GetProcAddress(lib, "_xVideoAspectRatioStr@0")
	xGetTotalPhysMem = GetProcAddress(lib, "_xGetTotalPhysMem@0")
	xGetAvailPhysMem = GetProcAddress(lib, "_xGetAvailPhysMem@0")
	xGetTotalPageMem = GetProcAddress(lib, "_xGetTotalPageMem@0")
	xGetAvailPageMem = GetProcAddress(lib, "_xGetAvailPageMem@0")
	xGetTotalVidMem = GetProcAddress(lib, "_xGetTotalVidMem@0")
	xGetAvailVidMem = GetProcAddress(lib, "_xGetAvailVidMem@0")
	xGetTotalVidLocalMem = GetProcAddress(lib, "_xGetTotalVidLocalMem@0")
	xGetAvailVidLocalMem = GetProcAddress(lib, "_xGetAvailVidLocalMem@0")
	xGetTotalVidNonlocalMem = GetProcAddress(lib, "_xGetTotalVidNonlocalMem@0")
	xGetAvailVidNonlocalMem = GetProcAddress(lib, "_xGetAvailVidNonlocalMem@0")
	xGetXors3dVersion = GetProcAddress(lib, "_xGetXors3dVersion@0")
	xGetXors3dMajorVersion = GetProcAddress(lib, "_xGetXors3dMajorVersion@0")
	xGetXors3dMinorVersion = GetProcAddress(lib, "_xGetXors3dMinorVersion@0")
	xGetXors3dRevision = GetProcAddress(lib, "_xGetXors3dRevision@0")
	xLoadTerrain_ = GetProcAddress(lib, "_xLoadTerrain@8")
	xCreateTerrain_ = GetProcAddress(lib, "_xCreateTerrain@8")
	xTerrainShading_ = GetProcAddress(lib, "_xTerrainShading@8")
	xTerrainHeight = GetProcAddress(lib, "_xTerrainHeight@12")
	xTerrainSize = GetProcAddress(lib, "_xTerrainSize@4")
	xTerrainX = GetProcAddress(lib, "_xTerrainX@16")
	xTerrainY = GetProcAddress(lib, "_xTerrainY@16")
	xTerrainZ = GetProcAddress(lib, "_xTerrainZ@16")
	xModifyTerrain_ = GetProcAddress(lib, "_xModifyTerrain@20")
	xTerrainDetail = GetProcAddress(lib, "_xTerrainDetail@8")
	xTerrainSplatting = GetProcAddress(lib, "_xTerrainSplatting@8")
	xLoadTerrainTexture = GetProcAddress(lib, "_xLoadTerrainTexture@4")
	xFreeTerrainTexture = GetProcAddress(lib, "_xFreeTerrainTexture@4")
	xTerrainTextureLightmap = GetProcAddress(lib, "_xTerrainTextureLightmap@8")
	xTerrainTexture = GetProcAddress(lib, "_xTerrainTexture@8")
	xTerrainViewZone_ = GetProcAddress(lib, "_xTerrainViewZone@12")
	xTerrainLODs = GetProcAddress(lib, "_xTerrainLODs@4")
	xTextureWidth = GetProcAddress(lib, "_xTextureWidth@4")
	xTextureHeight = GetProcAddress(lib, "_xTextureHeight@4")
	xCreateTexture_ = GetProcAddress(lib, "_xCreateTexture@16")
	xFreeTexture = GetProcAddress(lib, "_xFreeTexture@4")
	xSetTextureFilter = GetProcAddress(lib, "_xSetTextureFilter@8")
	xTextureBlend = GetProcAddress(lib, "_xTextureBlend@8")
	xTextureCoords = GetProcAddress(lib, "_xTextureCoords@8")
	xTextureFilter = GetProcAddress(lib, "_xTextureFilter@8")
	xClearTextureFilters = GetProcAddress(lib, "_xClearTextureFilters@0")
	xLoadTexture_ = GetProcAddress(lib, "_xLoadTexture@8")
	xTextureName = GetProcAddress(lib, "_xTextureName@4")
	xPositionTexture = GetProcAddress(lib, "_xPositionTexture@12")
	xScaleTexture = GetProcAddress(lib, "_xScaleTexture@12")
	xRotateTexture = GetProcAddress(lib, "_xRotateTexture@8")
	xLoadAnimTexture = GetProcAddress(lib, "_xLoadAnimTexture@24")
	xCreateTextureFromData_ = GetProcAddress(lib, "_xCreateTextureFromData@20")
	xGetTextureData_ = GetProcAddress(lib, "_xGetTextureData@8")
	xGetTextureDataPitch_ = GetProcAddress(lib, "_xGetTextureDataPitch@8")
	xGetTextureSurface_ = GetProcAddress(lib, "_xGetTextureSurface@8")
	xGetTextureFrames = GetProcAddress(lib, "_xGetTextureFrames@4")
	xSetCubeFace = GetProcAddress(lib, "_xSetCubeFace@8")
	xSetCubeMode = GetProcAddress(lib, "_xSetCubeMode@8")
	xGetTextureBlend = GetProcAddress(lib, "_xGetTextureBlend@4")
	xGetTextureX = GetProcAddress(lib, "_xGetTextureX@4")
	xGetTextureY = GetProcAddress(lib, "_xGetTextureY@4")
	xGetTextureScaleX = GetProcAddress(lib, "_xGetTextureScaleX@4")
	xGetTextureScaleY = GetProcAddress(lib, "_xGetTextureScaleY@4")
	xGetTextureAngle = GetProcAddress(lib, "_xGetTextureAngle@4")
	xGetTextureCoords = GetProcAddress(lib, "_xGetTextureCoords@4")
	xGetCubeFace = GetProcAddress(lib, "_xGetCubeFace@4")
	xGetCubeMode = GetProcAddress(lib, "_xGetCubeMode@4")
	xGetTextureFlags = GetProcAddress(lib, "_xGetTextureFlags@4")
	xSetTextureFlags = GetProcAddress(lib, "_xSetTextureFlags@8")
	xTextureCounter = GetProcAddress(lib, "_xTextureCounter@4")
	xVectorPitch = GetProcAddress(lib, "_xVectorPitch@12")
	xVectorYaw = GetProcAddress(lib, "_xVectorYaw@12")
	xDeltaPitch = GetProcAddress(lib, "_xDeltaPitch@8")
	xDeltaYaw = GetProcAddress(lib, "_xDeltaYaw@8")
	xTFormedX = GetProcAddress(lib, "_xTFormedX@0")
	xTFormedY = GetProcAddress(lib, "_xTFormedY@0")
	xTFormedZ = GetProcAddress(lib, "_xTFormedZ@0")
	xTFormPoint = GetProcAddress(lib, "_xTFormPoint@20")
	xTFormVector = GetProcAddress(lib, "_xTFormVector@20")
	xTFormNormal = GetProcAddress(lib, "_xTFormNormal@20")
	xOpenMovie = GetProcAddress(lib, "_xOpenMovie@4")
	xCloseMovie = GetProcAddress(lib, "_xCloseMovie@4")
	xDrawMovie_ = GetProcAddress(lib, "_xDrawMovie@20")
	xMovieWidth = GetProcAddress(lib, "_xMovieWidth@4")
	xMovieHeight = GetProcAddress(lib, "_xMovieHeight@4")
	xMoviePlaying = GetProcAddress(lib, "_xMoviePlaying@4")
	xMovieSeek_ = GetProcAddress(lib, "_xMovieSeek@12")
	xMovieLength = GetProcAddress(lib, "_xMovieLength@4")
	xMovieCurrentTime = GetProcAddress(lib, "_xMovieCurrentTime@4")
	xMoviePause = GetProcAddress(lib, "_xMoviePause@4")
	xMovieResume = GetProcAddress(lib, "_xMovieResume@4")
	xMovieTexture = GetProcAddress(lib, "_xMovieTexture@4")
	xCreateWorld = GetProcAddress(lib, "_xCreateWorld@0")
	xSetActiveWorld = GetProcAddress(lib, "_xSetActiveWorld@4")
	xGetActiveWorld = GetProcAddress(lib, "_xGetActiveWorld@0")
	xGetDefaultWorld = GetProcAddress(lib, "_xGetDefaultWorld@0")
	xDeleteWorld = GetProcAddress(lib, "_xDeleteWorld@4")
Else
	RuntimeError("Invalid " + xorsLibName)
	End
End If


' Wrap functions with defult parameters
Rem
	bbdoc:
EndRem
Function xCreateLine3D%(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, red% = 255, green% = 255, blue% = 255, alpha% = 255, useZBuffer% = true)
	Return xCreateLine3D_(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, red%, green%, blue%, alpha%, useZBuffer%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DOrigin(line3d%, x#, y#, z#, isGlobal% = false)
	xLine3DOrigin_(line3d%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DAddNode(line3d%, x#, y#, z#, isGlobal% = false)
	xLine3DAddNode_(line3d%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DOriginX#(line3d%, isGlobal% = false)
	Return xLine3DOriginX_(line3d%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DOriginY#(line3d%, isGlobal% = false)
	Return xLine3DOriginY_(line3d%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DOriginZ#(line3d%, isGlobal% = false)
	Return xLine3DOriginZ_(line3d%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DNodePosition(line3d%, index%, x#, y#, z#, isGlobal% = false)
	xLine3DNodePosition_(line3d%, index%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DNodeX#(line3d%, index%, isGlobal% = false)
	Return xLine3DNodeX_(line3d%, index%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DNodeY#(line3d%, index%, isGlobal% = false)
	Return xLine3DNodeY_(line3d%, index%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLine3DNodeZ#(line3d%, index%, isGlobal% = false)
	Return xLine3DNodeZ_(line3d%, index%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadBrush%(path$, flags% = 9, xScale# = 1.0, yScale# = 1.0)
	Return xLoadBrush_(path$, flags%, xScale#, yScale#)
End Function

Rem
	bbdoc:
EndRem
Function xCreateBrush%(red# = 255.0, green# = 255.0, blue# = 255.0)
	Return xCreateBrush_(red#, green#, blue#)
End Function

Rem
	bbdoc:
EndRem
Function xGetBrushTexture%(brush%, index% = 0)
	Return xGetBrushTexture_(brush%, index%)
End Function

Rem
	bbdoc:
EndRem
Function xBrushTexture(brush%, texture%, frame% = 0, index% = 0)
	xBrushTexture_(brush%, texture%, frame%, index%)
End Function

Rem
	bbdoc:
EndRem
Function xCameraClsColor(camera%, red%, green%, blue%, alpha% = 255)
	xCameraClsColor_(camera%, red%, green%, blue%, alpha%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateCamera%(parent% = 0)
	Return xCreateCamera_(parent%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityRadius(entity%, xRadius#, yRadius# = 0.0)
	xEntityRadius_(entity%, xRadius#, yRadius#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityType(entity%, typeID%, recurse% = false)
	xEntityType_(entity%, typeID%, recurse%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEntityEffect(entity%, effect%, index% = -1)
	xSetEntityEffect_(entity%, effect%, index%)
End Function

Rem
	bbdoc:
EndRem
Function xSetSurfaceEffect(surface%, effect%, index% = -1)
	xSetSurfaceEffect_(surface%, effect%, index%)
End Function

Rem
	bbdoc:
EndRem
Function xSetBonesArrayName(entity%, arrayName$, layer% = -1)
	xSetBonesArrayName_(entity%, arrayName$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceBonesArrayName(surface%, arrayName$, layer% = -1)
	xSurfaceBonesArrayName_(surface%, arrayName$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectInt(entity%, name$, value%, layer% = -1)
	xSetEffectInt_(entity%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectInt(surface%, name$, value%, layer% = -1)
	xSurfaceEffectInt_(surface%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectFloat(entity%, name$, value#, layer% = -1)
	xSetEffectFloat_(entity%, name$, value#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectFloat(surface%, name$, value#, layer% = -1)
	xSurfaceEffectFloat_(surface%, name$, value#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectBool(entity%, name$, value%, layer% = -1)
	xSetEffectBool_(entity%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectBool(surface%, name$, value%, layer% = -1)
	xSurfaceEffectBool_(surface%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectVector(entity%, name$, x#, y#, z#, w# = 0.0, layer% = -1)
	xSetEffectVector_(entity%, name$, x#, y#, z#, w#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectVector(surface%, name$, x#, y#, z#, w# = 0.0, layer% = -1)
	xSurfaceEffectVector_(surface%, name$, x#, y#, z#, w#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectVectorArray(entity%, name$, value%, count%, layer% = -1)
	xSetEffectVectorArray_(entity%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectVectorArray(surface%, name$, value%, count%, layer% = -1)
	xSurfaceEffectVectorArray_(surface%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectMatrixArray(surface%, name$, value%, count%, layer% = -1)
	xSurfaceEffectMatrixArray_(surface%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectFloatArray(surface%, name$, value%, count%, layer% = -1)
	xSurfaceEffectFloatArray_(surface%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectIntArray(surface%, name$, value%, count%, layer% = -1)
	xSurfaceEffectIntArray_(surface%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectMatrixArray(entity%, name$, value%, count%, layer% = -1)
	xSetEffectMatrixArray_(entity%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectFloatArray(entity%, name$, value%, count%, layer% = -1)
	xSetEffectFloatArray_(entity%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectIntArray(entity%, name$, value%, count%, layer% = -1)
	xSetEffectIntArray_(entity%, name$, value%, count%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectMatrixWithElements(entity%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer% = -1)
	xSetEffectMatrixWithElements_(entity%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectMatrix(entity%, name$, matrix%, layer% = -1)
	xSetEffectMatrix_(entity%, name$, matrix%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectMatrix(surface%, name$, matrix%, layer% = -1)
	xSurfaceEffectMatrix_(surface%, name$, matrix%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectMatrixWithElements(surface%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer% = -1)
	xSurfaceEffectMatrixWithElements_(surface%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectEntityTexture(entity%, name$, index% = 0, layer% = -1)
	xSetEffectEntityTexture_(entity%, name$, index%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectTexture(entity%, name$, texture%, frame% = 0, layer% = -1, isRecursive% = 1)
	xSetEffectTexture_(entity%, name$, texture%, frame%, layer%, isRecursive%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectTexture(surface%, name$, texture%, frame% = 0, layer% = -1)
	xSurfaceEffectTexture_(surface%, name$, texture%, frame%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceEffectMatrixSemantic(surface%, name$, value%, layer% = -1)
	xSurfaceEffectMatrixSemantic_(surface%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectMatrixSemantic(entity%, name$, value%, layer% = -1)
	xSetEffectMatrixSemantic_(entity%, name$, value%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xDeleteSurfaceConstant(surface%, name$, layer% = -1)
	xDeleteSurfaceConstant_(surface%, name$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xDeleteEffectConstant(entity%, name$, layer% = -1)
	xDeleteEffectConstant_(entity%, name$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xClearSurfaceConstants(surface%, layer% = -1)
	xClearSurfaceConstants_(surface%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xClearEffectConstants(entity%, layer% = -1)
	xClearEffectConstants_(entity%, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetEffectTechnique(entity%, name$, layer% = -1)
	xSetEffectTechnique_(entity%, name$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSurfaceTechnique(surface%, name$, layer% = -1)
	xSurfaceTechnique_(surface%, name$, layer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetFXVector(effect%, name$, x#, y#, z#, w# = 0.0)
	xSetFXVector_(effect%, name$, x#, y#, z#, w#)
End Function

Rem
	bbdoc:
EndRem
Function xSetFXTexture(effect%, name$, texture%, frame% = 0)
	xSetFXTexture_(effect%, name$, texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateEmitter%(psystem%, parent% = 0)
	Return xCreateEmitter_(psystem%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xExtractAnimSeq%(entity%, firstFrame%, lastFrame%, sequence% = 0)
	Return xExtractAnimSeq_(entity%, firstFrame%, lastFrame%, sequence%)
End Function

Rem
	bbdoc:
EndRem
Function xSetAnimSpeed(entity%, speed#, rootBone$ = "")
	xSetAnimSpeed_(entity%, speed#, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimSpeed#(entity%, rootBone$ = "")
	Return xAnimSpeed_(entity%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimating%(entity%, rootBone$ = "")
	Return xAnimating_(entity%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimTime#(entity%, rootBone$ = "")
	Return xAnimTime_(entity%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimate(entity%, mode% = 1, speed# = 1.0, sequence% = 0, translate# = 0.0, rootBone$ = "")
	xAnimate_(entity%, mode%, speed#, sequence%, translate#, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimSeq%(entity%, rootBone$ = "")
	Return xAnimSeq_(entity%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xAnimLength#(entity%, rootBone$ = "")
	Return xAnimLength_(entity%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xSetAnimTime(entity%, time#, sequence%, rootBone$ = "")
	xSetAnimTime_(entity%, time#, sequence%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xSetAnimFrame(entity%, frame#, sequence%, rootBone$ = "")
	xSetAnimFrame_(entity%, frame#, sequence%, rootBone$)
End Function

Rem
	bbdoc:
EndRem
Function xCopyEntity%(entity%, parent% = 0, cloneBuffers% = 0)
	Return xCopyEntity_(entity%, parent%, cloneBuffers%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityPickMode(entity%, mode%, obscurer% = true, recursive% = true)
	xEntityPickMode_(entity%, mode%, obscurer%, recursive%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityTexture(entity%, texture%, frame% = 0, index% = 0, isRecursive% = 1)
	xEntityTexture_(entity%, texture%, frame%, index%, isRecursive%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityParent(entity%, parent% = 0, isGlobal% = true)
	xEntityParent_(entity%, parent%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateInstance%(entity%, parent% = 0)
	Return xCreateInstance_(entity%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xFreezeInstances(entity%, enable% = true)
	xFreezeInstances_(entity%, enable%)
End Function

Rem
	bbdoc:
EndRem
Function xScaleEntity(entity%, x#, y#, z#, isGlobal% = false)
	xScaleEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xPositionEntity(entity%, x#, y#, z#, isGlobal% = false)
	xPositionEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xMoveEntity(entity%, x#, y#, z#, isGlobal% = false)
	xMoveEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xTranslateEntity(entity%, x#, y#, z#, isGlobal% = false)
	xTranslateEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xRotateEntity(entity%, x#, y#, z#, isGlobal% = false)
	xRotateEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xTurnEntity(entity%, x#, y#, z#, isGlobal% = false)
	xTurnEntity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xPointEntity(entity1%, entity2%, roll# = 0.0)
	xPointEntity_(entity1%, entity2%, roll#)
End Function

Rem
	bbdoc:
EndRem
Function xAlignToVector(entity%, x#, y#, z#, axis%, factor# = 1.0)
	xAlignToVector_(entity%, x#, y#, z#, axis%, factor#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityX#(entity%, isGlobal% = false)
	Return xEntityX_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityY#(entity%, isGlobal% = false)
	Return xEntityY_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityZ#(entity%, isGlobal% = false)
	Return xEntityZ_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityRoll#(entity%, isGlobal% = false)
	Return xEntityRoll_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityYaw#(entity%, isGlobal% = false)
	Return xEntityYaw_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityPitch#(entity%, isGlobal% = false)
	Return xEntityPitch_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xMountPackFile%(path$, mountpoint$ = "", password$ = "")
	Return xMountPackFile_(path$, mountpoint$, password$)
End Function

Rem
	bbdoc:
EndRem
Function xReadLine$(file%, ls_flag% = 0)
	Return xReadLine_(file%, ls_flag%)
End Function

Rem
	bbdoc:
EndRem
Function xWriteLine(file%, value$, ls_flag% = 0)
	xWriteLine_(file%, value$, ls_flag%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadFont%(name$, height%, bold% = false, italic% = false, underline% = false, fontface$ = "")
	Return xLoadFont_(name$, height%, bold%, italic%, underline%, fontface$)
End Function

Rem
	bbdoc:
EndRem
Function xText(x#, y#, textString$, centerx% = false, centery% = false)
	xText_(x#, y#, textString$, centerx%, centery%)
End Function

Rem
	bbdoc:
EndRem
Function xRect(x%, y%, width%, height%, solid% = false)
	xRect_(x%, y%, width%, height%, solid%)
End Function

Rem
	bbdoc:
EndRem
Function xOval(x%, y%, width%, height%, solid% = false)
	xOval_(x%, y%, width%, height%, solid%)
End Function

Rem
	bbdoc:
EndRem
Function xLockBuffer(buffer% = 0)
	xLockBuffer_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xUnlockBuffer(buffer% = 0)
	xUnlockBuffer_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xWritePixelFast(x%, y%, argb%, buffer% = -1)
	xWritePixelFast_(x%, y%, argb%, buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xReadPixelFast%(x%, y%, buffer% = -1)
	Return xReadPixelFast_(x%, y%, buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xGetPixels%(buffer% = -1)
	Return xGetPixels_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xBufferWidth%(buffer% = 0)
	Return xBufferWidth_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xBufferHeight%(buffer% = 0)
	Return xBufferHeight_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xSetBuffer(buffer% = 0)
	xSetBuffer_(buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xTextureBuffer%(texture%, frame% = 0)
	Return xTextureBuffer_(texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xWritePixel(x%, y%, argb%, buffer% = 0)
	xWritePixel_(x%, y%, argb%, buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xReadPixel%(x%, y%, buffer% = 0)
	Return xReadPixel_(x%, y%, buffer%)
End Function

Rem
	bbdoc:
EndRem
Function xGraphicsWidth%(isVirtual% = true)
	Return xGraphicsWidth_(isVirtual%)
End Function

Rem
	bbdoc:
EndRem
Function xGraphicsHeight%(isVirtual% = true)
	Return xGraphicsHeight_(isVirtual%)
End Function

Rem
	bbdoc:
EndRem
Function xClsColor(red%, green%, blue%, alpha% = 255)
	xClsColor_(red%, green%, blue%, alpha%)
End Function

Rem
	bbdoc:
EndRem
Function xClearWorld(entities% = true, brushes% = true, textures% = true)
	xClearWorld_(entities%, brushes%, textures%)
End Function

Rem
	bbdoc:
EndRem
Function xColor(red%, green%, blue%, alpha% = 255)
	xColor_(red%, green%, blue%, alpha%)
End Function

Rem
	bbdoc:
EndRem
Function xUpdateWorld(speed# = 1.0)
	xUpdateWorld_(speed#)
End Function

Rem
	bbdoc:
EndRem
Function xRenderEntity(camera%, entity%, tween# = 1.0)
	xRenderEntity_(camera%, entity%, tween#)
End Function

Rem
	bbdoc:
EndRem
Function xRenderWorld(tween# = 1.0, renderShadows% = false)
	xRenderWorld_(tween#, renderShadows%)
End Function

Rem
	bbdoc:
EndRem
Function xAmbientLight(red%, green%, blue%, world% = 0)
	xAmbientLight_(red%, green%, blue%, world%)
End Function

Rem
	bbdoc:
EndRem
Function xGraphics3D(width% = 1024, height% = 768, depth% = 0, mode% = 0, vsync% = 1)
	xGraphics3D_(width%, height%, depth%, mode%, vsync%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawMovementGizmo(x#, y#, z#, selectMask% = 0)
	xDrawMovementGizmo_(x#, y#, z#, selectMask%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawScaleGizmo(x#, y#, z#, selectMask% = 0, sx# = 1.0, sy# = 1.0, sz# = 1.0)
	xDrawScaleGizmo_(x#, y#, z#, selectMask%, sx#, sy#, sz#)
End Function

Rem
	bbdoc:
EndRem
Function xDrawRotationGizmo(x#, y#, z#, selectMask% = 0, pitch# = 0.0, yaw# = 0.0, roll# = 0.0)
	xDrawRotationGizmo_(x#, y#, z#, selectMask%, pitch#, yaw#, roll#)
End Function

Rem
	bbdoc:
EndRem
Function xDeltaTime%(fromInit% = false)
	Return xDeltaTime_(fromInit%)
End Function

Rem
	bbdoc:
EndRem
Function xDeltaValue#(value#, time% = 0)
	Return xDeltaValue_(value#, time%)
End Function

Rem
	bbdoc:
EndRem
Function xImageBuffer%(image%, frame% = 0)
	Return xImageBuffer_(image%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateImage%(width%, height%, frame% = 1)
	Return xCreateImage_(width%, height%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xGrabImage(image%, x%, y%, frame% = 0)
	xGrabImage_(image%, x%, y%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xSaveImage(image%, path$, frame% = 0)
	xSaveImage_(image%, path$, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawImage(image%, x#, y#, frame% = 0)
	xDrawImage_(image%, x#, y#, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawImageRect(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame% = 0)
	xDrawImageRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xTileImage(image%, x#, y#, frame% = 0)
	xTileImage_(image%, x#, y#, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawBlock(image%, x#, y#, frame% = 0)
	xDrawBlock_(image%, x#, y#, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawBlockRect(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame% = 0)
	xDrawBlockRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyType%(portID% = 0)
	Return xJoyType_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyDown%(key%, portID% = 0)
	Return xJoyDown_(key%, portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyHit%(key%, portID% = 0)
	Return xJoyHit_(key%, portID%)
End Function

Rem
	bbdoc:
EndRem
Function xGetJoy%(portID% = 0)
	Return xGetJoy_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xWaitJoy%(portID% = 0)
	Return xWaitJoy_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyX#(portID% = 0)
	Return xJoyX_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyY#(portID% = 0)
	Return xJoyY_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyZ#(portID% = 0)
	Return xJoyZ_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyU#(portID% = 0)
	Return xJoyU_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyV#(portID% = 0)
	Return xJoyV_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyPitch#(portID% = 0)
	Return xJoyPitch_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyYaw#(portID% = 0)
	Return xJoyYaw_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyRoll#(portID% = 0)
	Return xJoyRoll_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyHat#(portID% = 0)
	Return xJoyHat_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyXDir%(portID% = 0)
	Return xJoyXDir_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyYDir%(portID% = 0)
	Return xJoyYDir_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyZDir%(portID% = 0)
	Return xJoyZDir_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyUDir%(portID% = 0)
	Return xJoyUDir_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xJoyVDir%(portID% = 0)
	Return xJoyVDir_(portID%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateLight%(typeID% = 1)
	Return xCreateLight_(typeID%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateLog%(target% = 1, level% = 0, filename$ = "xors_log.html", cssfilename$ = "")
	Return xCreateLog_(target%, level%, filename$, cssfilename$)
End Function

Rem
	bbdoc:
EndRem
Function xSetLogLevel(level% = 2)
	xSetLogLevel_(level%)
End Function

Rem
	bbdoc:
EndRem
Function xSetLogTarget(target% = 1)
	xSetLogTarget_(target%)
End Function

Rem
	bbdoc:
EndRem
Function xLogInfo(message$, func$ = "", file$ = "", line% = -1)
	xLogInfo_(message$, func$, file$, line%)
End Function

Rem
	bbdoc:
EndRem
Function xLogMessage(message$, func$ = "", file$ = "", line% = -1)
	xLogMessage_(message$, func$, file$, line%)
End Function

Rem
	bbdoc:
EndRem
Function xLogWarning(message$, func$ = "", file$ = "", line% = -1)
	xLogWarning_(message$, func$, file$, line%)
End Function

Rem
	bbdoc:
EndRem
Function xLogError(message$, func$ = "", file$ = "", line% = -1)
	xLogError_(message$, func$, file$, line%)
End Function

Rem
	bbdoc:
EndRem
Function xLogFatal(message$, func$ = "", file$ = "", line% = -1)
	xLogFatal_(message$, func$, file$, line%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateMesh%(parent% = 0)
	Return xCreateMesh_(parent%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadMesh%(path$, parent% = 0)
	Return xLoadMesh_(path$, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadMeshWithChild%(path$, parent% = 0)
	Return xLoadMeshWithChild_(path$, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadAnimMesh%(path$, parent% = 0)
	Return xLoadAnimMesh_(path$, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateCube%(parent% = 0)
	Return xCreateCube_(parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateSphere%(segments% = 16, parent% = 0)
	Return xCreateSphere_(segments%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateCylinder%(segments% = 16, solid% = true, parent% = 0)
	Return xCreateCylinder_(segments%, solid%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateTorus%(segments% = 16, R# = 1.0, r_tube# = 0.025, parent% = 0)
	Return xCreateTorus_(segments%, R#, r_tube#, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateCone%(segments% = 16, solid% = true, parent% = 0)
	Return xCreateCone_(segments%, solid%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCopyMesh%(entity%, parent% = 0)
	Return xCopyMesh_(entity%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xFitMesh(entity%, x#, y#, z#, width#, height#, depth#, uniform% = false)
	xFitMesh_(entity%, x#, y#, z#, width#, height#, depth#, uniform%)
End Function

Rem
	bbdoc:
EndRem
Function xMeshWidth#(entity%, recursive% = false)
	Return xMeshWidth_(entity%, recursive%)
End Function

Rem
	bbdoc:
EndRem
Function xMeshHeight#(entity%, recursive% = false)
	Return xMeshHeight_(entity%, recursive%)
End Function

Rem
	bbdoc:
EndRem
Function xMeshDepth#(entity%, recursive% = false)
	Return xMeshDepth_(entity%, recursive%)
End Function

Rem
	bbdoc:
EndRem
Function xCreatePivot%(parent% = 0)
	Return xCreatePivot_(parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreatePoly%(sides% = 0, parent% = 0)
	Return xCreatePoly_(sides%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xLightMesh(entity%, red%, green%, blue%, range# = 0.0, lightX# = 0.0, lightY# = 0.0, lightZ# = 0.0)
	xLightMesh_(entity%, red%, green%, blue%, range#, lightX#, lightY#, lightZ#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityAddBoxShape(entity%, mass#, width# = 0.0, height# = 0.0, depth# = 0.0)
	xEntityAddBoxShape_(entity%, mass#, width#, height#, depth#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityAddSphereShape(entity%, mass#, radius# = 0.0)
	xEntityAddSphereShape_(entity%, mass#, radius#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityAddCapsuleShape(entity%, mass#, radius# = 0.0, height# = 0.0)
	xEntityAddCapsuleShape_(entity%, mass#, radius#, height#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityAddConeShape(entity%, mass#, radius# = 0.0, height# = 0.0)
	xEntityAddConeShape_(entity%, mass#, radius#, height#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityAddCylinderShape(entity%, mass#, width# = 0.0, height# = 0.0, depth# = 0.0)
	xEntityAddCylinderShape_(entity%, mass#, width#, height#, depth#)
End Function

Rem
	bbdoc:
EndRem
Function xCreateHingeJoint%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, axisX#, axisY#, axisZ#, isGlobal% = false)
	Return xCreateHingeJoint_(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, axisX#, axisY#, axisZ#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateBallJoint%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, isGlobal% = false)
	Return xCreateBallJoint_(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateD6Joint%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1% = false, isGlobal2% = false)
	Return xCreateD6Joint_(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateD6SpringJoint%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1% = false, isGlobal2% = false)
	Return xCreateD6SpringJoint_(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%)
End Function

Rem
	bbdoc:
EndRem
Function xJointD6GetAngle#(joint%, axis% = 0)
	Return xJointD6GetAngle_(joint%, axis%)
End Function

Rem
	bbdoc:
EndRem
Function xJointBallSetPivot(joint%, x#, y#, z#, isGlobal% = false)
	xJointBallSetPivot_(joint%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xJointBallGetPivotX#(joint%, isGlobal% = false)
	Return xJointBallGetPivotX_(joint%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xJointBallGetPivotY#(joint%, isGlobal% = false)
	Return xJointBallGetPivotY_(joint%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xJointBallGetPivotZ#(joint%, isGlobal% = false)
	Return xJointBallGetPivotZ_(joint%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xJointD6SpringSetParam(joint%, index%, enabled%, damping# = 1.0, stiffness# = 1.0)
	xJointD6SpringSetParam_(joint%, index%, enabled%, damping#, stiffness#)
End Function

Rem
	bbdoc:
EndRem
Function xJointHingeSetLimits(joint%, lowerLimit#, upperLimit#, softness# = 0.9, biasFactor# = 0.3, relaxationFactor# = 1.0)
	xJointHingeSetLimits_(joint%, lowerLimit#, upperLimit#, softness#, biasFactor#, relaxationFactor#)
End Function

Rem
	bbdoc:
EndRem
Function xJointEnableMotor(joint%, enabled%, targetVelocity#, maxForce#, index% = 0)
	xJointEnableMotor_(joint%, enabled%, targetVelocity#, maxForce#, index%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyCentralForce(entity%, x#, y#, z#, isGlobal% = true)
	xEntityApplyCentralForce_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyCentralImpulse(entity%, x#, y#, z#, isGlobal% = true)
	xEntityApplyCentralImpulse_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyTorque(entity%, x#, y#, z#, isGlobal% = true)
	xEntityApplyTorque_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyTorqueImpulse(entity%, x#, y#, z#, isGlobal% = true)
	xEntityApplyTorqueImpulse_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyForce(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal% = true, globalPoint% = true)
	xEntityApplyForce_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityApplyImpulse(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal% = true, globalPoint% = true)
	xEntityApplyImpulse_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%)
End Function

Rem
	bbdoc:
EndRem
Function xWorldSetGravity(x#, y#, z#, world% = 0)
	xWorldSetGravity_(x#, y#, z#, world%)
End Function

Rem
	bbdoc:
EndRem
Function xWorldGetGravityX#(world% = 0)
	Return xWorldGetGravityX_(world%)
End Function

Rem
	bbdoc:
EndRem
Function xWorldGetGravityY#(world% = 0)
	Return xWorldGetGravityY_(world%)
End Function

Rem
	bbdoc:
EndRem
Function xWorldGetGravityZ#(world% = 0)
	Return xWorldGetGravityZ_(world%)
End Function

Rem
	bbdoc:
EndRem
Function xEntitySetLinearVelocity(entity%, x#, y#, z#, isGlobal% = true)
	xEntitySetLinearVelocity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetLinearVelocityX#(entity%, isGlobal% = true)
	Return xEntityGetLinearVelocityX_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetLinearVelocityY#(entity%, isGlobal% = true)
	Return xEntityGetLinearVelocityY_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetLinearVelocityZ#(entity%, isGlobal% = true)
	Return xEntityGetLinearVelocityZ_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntitySetAngularVelocity(entity%, x#, y#, z#, isGlobal% = true)
	xEntitySetAngularVelocity_(entity%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetAngularVelocityX#(entity%, isGlobal% = true)
	Return xEntityGetAngularVelocityX_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetAngularVelocityY#(entity%, isGlobal% = true)
	Return xEntityGetAngularVelocityY_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityGetAngularVelocityZ#(entity%, isGlobal% = true)
	Return xEntityGetAngularVelocityZ_(entity%, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityDisableSleeping(entity%, state% = 1)
	xEntityDisableSleeping_(entity%, state%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsRayCast(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, rcType% = 0, rayGroup% = 0)
	xPhysicsRayCast_(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, rcType%, rayGroup%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitEntity%(index% = 0)
	Return xPhysicsGetHitEntity_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitPointX#(index% = 0)
	Return xPhysicsGetHitPointX_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitPointY#(index% = 0)
	Return xPhysicsGetHitPointY_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitPointZ#(index% = 0)
	Return xPhysicsGetHitPointZ_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitNormalX#(index% = 0)
	Return xPhysicsGetHitNormalX_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitNormalY#(index% = 0)
	Return xPhysicsGetHitNormalY_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitNormalZ#(index% = 0)
	Return xPhysicsGetHitNormalZ_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xPhysicsGetHitDistance#(index% = 0)
	Return xPhysicsGetHitDistance_(index%)
End Function

Rem
	bbdoc:
EndRem
Function xWorldSetFrequency(frequency#, world% = 0)
	xWorldSetFrequency_(frequency#, world%)
End Function

Rem
	bbdoc:
EndRem
Function xEntityWheelSetConnectionPoint(chassisEntity%, index%, x#, y#, z#, isGlobal% = false)
	xEntityWheelSetConnectionPoint_(chassisEntity%, index%, x#, y#, z#, isGlobal%)
End Function

Rem
	bbdoc:
EndRem
Function xSetPostEffect(index%, postEffect%, technique$ = "MainTechnique")
	xSetPostEffect_(index%, postEffect%, technique$)
End Function

Rem
	bbdoc:
EndRem
Function xSetPostEffectVector(postEffect%, name$, x#, y#, z#, w# = 1.0)
	xSetPostEffectVector_(postEffect%, name$, x#, y#, z#, w#)
End Function

Rem
	bbdoc:
EndRem
Function xSetPostEffectTexture(postEffect%, name$, texture%, frame% = 0)
	xSetPostEffectTexture_(postEffect%, name$, texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xCreatePSystem%(pointSprites% = false)
	Return xCreatePSystem_(pointSprites%)
End Function

Rem
	bbdoc:
EndRem
Function xLinePick%(x#, y#, z#, dx#, dy#, dz#, distance# = 0.0)
	Return xLinePick_(x#, y#, z#, dx#, dy#, dz#, distance#)
End Function

Rem
	bbdoc:
EndRem
Function xEntityPick%(entity%, range# = 0.0)
	Return xEntityPick_(entity%, range#)
End Function

Rem
	bbdoc:
EndRem
Function xSetShadowParams(splitPlanes% = 4, splitLambda# = 0.95, useOrtho% = true, lightDist# = 300.0)
	xSetShadowParams_(splitPlanes%, splitLambda#, useOrtho%, lightDist#)
End Function

Rem
	bbdoc:
EndRem
Function xCreateListener%(parent% = 0, roFactor# = 1.0, doplerFactor# = 1.0, distFactor# = 1.0)
	Return xCreateListener_(parent%, roFactor#, doplerFactor#, distFactor#)
End Function

Rem
	bbdoc:
EndRem
Function xCreateSprite%(parent% = 0)
	Return xCreateSprite_(parent%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadSprite%(path$, flags% = 9, parent% = 0)
	Return xLoadSprite_(path$, flags%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateSurface%(entity%, brush% = 0, dynamic% = false)
	Return xCreateSurface_(entity%, brush%, dynamic%)
End Function

Rem
	bbdoc:
EndRem
Function xAddVertex%(surface%, x#, y#, z#, u# = 0.0, v# = 0.0, w# = 0.0)
	Return xAddVertex_(surface%, x#, y#, z#, u#, v#, w#)
End Function

Rem
	bbdoc:
EndRem
Function xVertexColor(surface%, vertex%, red%, green%, blue%, alpha# = 1.0)
	xVertexColor_(surface%, vertex%, red%, green%, blue%, alpha#)
End Function

Rem
	bbdoc:
EndRem
Function xVertexTexCoords(surface%, vertex%, u#, v#, w# = 1.0, textureSet% = 0)
	xVertexTexCoords_(surface%, vertex%, u#, v#, w#, textureSet%)
End Function

Rem
	bbdoc:
EndRem
Function xVertexU#(surface%, vertex%, textureSet% = 0)
	Return xVertexU_(surface%, vertex%, textureSet%)
End Function

Rem
	bbdoc:
EndRem
Function xVertexV#(surface%, vertex%, textureSet% = 0)
	Return xVertexV_(surface%, vertex%, textureSet%)
End Function

Rem
	bbdoc:
EndRem
Function xVertexW#(surface%, vertex%, textureSet% = 0)
	Return xVertexW_(surface%, vertex%, textureSet%)
End Function

Rem
	bbdoc:
EndRem
Function xClearSurface(surface%, vertices% = true, triangles% = true)
	xClearSurface_(surface%, vertices%, triangles%)
End Function

Rem
	bbdoc:
EndRem
Function xGetSurfaceTexture%(surface%, index% = 0)
	Return xGetSurfaceTexture_(surface%, index%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadTerrain%(path$, parent% = 0)
	Return xLoadTerrain_(path$, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateTerrain%(size%, parent% = 0)
	Return xCreateTerrain_(size%, parent%)
End Function

Rem
	bbdoc:
EndRem
Function xTerrainShading(terrain%, state% = false)
	xTerrainShading_(terrain%, state%)
End Function

Rem
	bbdoc:
EndRem
Function xModifyTerrain(terrain%, x%, y%, height#, realtime% = false)
	xModifyTerrain_(terrain%, x%, y%, height#, realtime%)
End Function

Rem
	bbdoc:
EndRem
Function xTerrainViewZone(terrain%, viewZone%, texturingZone% = -1)
	xTerrainViewZone_(terrain%, viewZone%, texturingZone%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateTexture%(width%, height%, flags% = 9, frames% = 1)
	Return xCreateTexture_(width%, height%, flags%, frames%)
End Function

Rem
	bbdoc:
EndRem
Function xLoadTexture%(path$, flags% = 9)
	Return xLoadTexture_(path$, flags%)
End Function

Rem
	bbdoc:
EndRem
Function xCreateTextureFromData%(pixelsData%, width%, height%, flags% = 9, frames% = 1)
	Return xCreateTextureFromData_(pixelsData%, width%, height%, flags%, frames%)
End Function

Rem
	bbdoc:
EndRem
Function xGetTextureData%(texture%, frame% = 0)
	Return xGetTextureData_(texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xGetTextureDataPitch%(texture%, frame% = 0)
	Return xGetTextureDataPitch_(texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xGetTextureSurface%(texture%, frame% = 0)
	Return xGetTextureSurface_(texture%, frame%)
End Function

Rem
	bbdoc:
EndRem
Function xDrawMovie(video%, x% = 0, y% = 0, width% = -1, height% = -1)
	xDrawMovie_(video%, x%, y%, width%, height%)
End Function

Rem
	bbdoc:
EndRem
Function xMovieSeek(video%, time#, relative% = false)
	xMovieSeek_(video%, time#, relative%)
End Function

' Scancodes for keyboard and mouse
Const MOUSE_LEFT         = 1
Const MOUSE_RIGHT        = 2
Const MOUSE_MIDDLE       = 3
Const MOUSE4             = 4
Const MOUSE5             = 5
Const MOUSE6             = 6
Const MOUSE7             = 7
Const MOUSE8             = 8

Const xMOUSE_LEFT        = 1
Const xMOUSE_RIGHT       = 2
Const xMOUSE_MIDDLE      = 3
Const xMOUSE4            = 4
Const xMOUSE5            = 5
Const xMOUSE6            = 6
Const xMOUSE7            = 7
Const xMOUSE8            = 8

Const KEY_ESCAPE         = 1
Const KEY_1              = 2
Const KEY_2              = 3
Const KEY_3              = 4
Const KEY_4              = 5
Const KEY_5              = 6
Const KEY_6              = 7
Const KEY_7              = 8
Const KEY_8              = 9
Const KEY_9              = 10
Const KEY_0              = 11
Const KEY_MINUS          = 12
Const KEY_EQUALS         = 13
Const KEY_BACK           = 14
Const KEY_TAB            = 15
Const KEY_Q              = 16
Const KEY_W              = 17
Const KEY_E              = 18
Const KEY_R              = 19
Const KEY_T              = 20
Const KEY_Y              = 21
Const KEY_U              = 22
Const KEY_I              = 23
Const KEY_O              = 24
Const KEY_P              = 25
Const KEY_LBRACKET       = 26
Const KEY_RBRACKET       = 27
Const KEY_RETURN         = 28
Const KEY_ENTER          = KEY_RETURN
Const KEY_LCONTROL       = 29
Const KEY_RCONTROL       = 157
Const KEY_A              = 30
Const KEY_S              = 31
Const KEY_D              = 32
Const KEY_F              = 33
Const KEY_G              = 34
Const KEY_H              = 35
Const KEY_J              = 36
Const KEY_K              = 37
Const KEY_L              = 38
Const KEY_SEMICOLON      = 39
Const KEY_APOSTROPHE     = 40
Const KEY_GRAVE          = 41
Const KEY_LSHIFT         = 42
Const KEY_BACKSLASH      = 43
Const KEY_Z              = 44
Const KEY_X              = 45
Const KEY_C              = 46
Const KEY_V              = 47
Const KEY_B              = 48
Const KEY_N              = 49
Const KEY_M              = 50
Const KEY_COMMA          = 51
Const KEY_PERIOD         = 52
Const KEY_SLASH          = 53
Const KEY_RSHIFT         = 54
Const KEY_MULTIPLY       = 55
Const KEY_MENU           = 56
Const KEY_SPACE          = 57
Const KEY_F1             = 59
Const KEY_F2             = 60
Const KEY_F3             = 61
Const KEY_F4             = 62
Const KEY_F5             = 63
Const KEY_F6             = 64
Const KEY_F7             = 65
Const KEY_F8             = 66
Const KEY_F9             = 67
Const KEY_F10            = 68
Const KEY_NUMLOCK        = 69
Const KEY_SCROLL         = 70
Const KEY_NUMPAD7        = 71
Const KEY_NUMPAD8        = 72
Const KEY_NUMPAD9        = 73
Const KEY_SUBTRACT       = 74
Const KEY_NUMPAD4        = 75
Const KEY_NUMPAD5        = 76
Const KEY_NUMPAD6        = 77
Const KEY_ADD            = 78
Const KEY_NUMPAD1        = 79
Const KEY_NUMPAD2        = 80
Const KEY_NUMPAD3        = 81
Const KEY_NUMPAD0        = 82
Const KEY_DECIMAL        = 83
Const KEY_TILD           = 86
Const KEY_F11            = 87
Const KEY_F12            = 88
Const KEY_NUMPADENTER    = 156
Const KEY_RMENU          = 221
Const KEY_PAUSE          = 197
Const KEY_HOME           = 199
Const KEY_UP             = 200
Const KEY_PRIOR          = 201
Const KEY_LEFT           = 203
Const KEY_RIGHT          = 205
Const KEY_END            = 207
Const KEY_DOWN           = 208
Const KEY_NEXT           = 209
Const KEY_INSERT         = 210
Const KEY_DELETE         = 211
Const KEY_LWIN           = 219
Const KEY_RWIN           = 220
Const KEY_BACKSPACE      = KEY_BACK
Const KEY_NUMPADSTAR     = KEY_MULTIPLY
Const KEY_RALT           = 184
Const KEY_CAPSLOCK       = 58
Const KEY_NUMPADMINUS    = KEY_SUBTRACT
Const KEY_NUMPADPLUS     = KEY_ADD
Const KEY_NUMPADPERIOD   = KEY_DECIMAL
Const KEY_DIVIDE         = 181
Const KEY_NUMPADSLASH    = KEY_DIVIDE
Const KEY_LALT           = 56
Const KEY_UPARROW        = KEY_UP
Const KEY_PGUP           = KEY_PRIOR
Const KEY_LEFTARROW      = KEY_LEFT
Const KEY_RIGHTARROW     = KEY_RIGHT
Const KEY_DOWNARROW      = KEY_DOWN
Const KEY_PGDN           = KEY_NEXT

Const xKEY_ESCAPE        = 1
Const xKEY_1             = 2
Const xKEY_2             = 3
Const xKEY_3             = 4
Const xKEY_4             = 5
Const xKEY_5             = 6
Const xKEY_6             = 7
Const xKEY_7             = 8
Const xKEY_8             = 9
Const xKEY_9             = 10
Const xKEY_0             = 11
Const xKEY_MINUS         = 12
Const xKEY_EQUALS        = 13
Const xKEY_BACK          = 14
Const xKEY_TAB           = 15
Const xKEY_Q             = 16
Const xKEY_W             = 17
Const xKEY_E             = 18
Const xKEY_R             = 19
Const xKEY_T             = 20
Const xKEY_Y             = 21
Const xKEY_U             = 22
Const xKEY_I             = 23
Const xKEY_O             = 24
Const xKEY_P             = 25
Const xKEY_LBRACKET      = 26
Const xKEY_RBRACKET      = 27
Const xKEY_RETURN        = 28
Const xKEY_ENTER         = xKEY_RETURN
Const xKEY_LCONTROL      = 29
Const xKEY_RCONTROL      = 157
Const xKEY_A             = 30
Const xKEY_S             = 31
Const xKEY_D             = 32
Const xKEY_F             = 33
Const xKEY_G             = 34
Const xKEY_H             = 35
Const xKEY_J             = 36
Const xKEY_K             = 37
Const xKEY_L             = 38
Const xKEY_SEMICOLON     = 39
Const xKEY_APOSTROPHE    = 40
Const xKEY_GRAVE         = 41
Const xKEY_LSHIFT        = 42
Const xKEY_BACKSLASH     = 43
Const xKEY_Z             = 44
Const xKEY_X             = 45
Const xKEY_C             = 46
Const xKEY_V             = 47
Const xKEY_B             = 48
Const xKEY_N             = 49
Const xKEY_M             = 50
Const xKEY_COMMA         = 51
Const xKEY_PERIOD        = 52
Const xKEY_SLASH         = 53
Const xKEY_RSHIFT        = 54
Const xKEY_MULTIPLY      = 55
Const xKEY_MENU          = 56
Const xKEY_SPACE         = 57
Const xKEY_F1            = 59
Const xKEY_F2            = 60
Const xKEY_F3            = 61
Const xKEY_F4            = 62
Const xKEY_F5            = 63
Const xKEY_F6            = 64
Const xKEY_F7            = 65
Const xKEY_F8            = 66
Const xKEY_F9            = 67
Const xKEY_F10           = 68
Const xKEY_NUMLOCK       = 69
Const xKEY_SCROLL        = 70
Const xKEY_NUMPAD7       = 71
Const xKEY_NUMPAD8       = 72
Const xKEY_NUMPAD9       = 73
Const xKEY_SUBTRACT      = 74
Const xKEY_NUMPAD4       = 75
Const xKEY_NUMPAD5       = 76
Const xKEY_NUMPAD6       = 77
Const xKEY_ADD           = 78
Const xKEY_NUMPAD1       = 79
Const xKEY_NUMPAD2       = 80
Const xKEY_NUMPAD3       = 81
Const xKEY_NUMPAD0       = 82
Const xKEY_DECIMAL       = 83
Const xKEY_TILD          = 86
Const xKEY_F11           = 87
Const xKEY_F12           = 88
Const xKEY_NUMPADENTER   = 156
Const xKEY_RMENU         = 221
Const xKEY_PAUSE         = 197
Const xKEY_HOME          = 199
Const xKEY_UP            = 200
Const xKEY_PRIOR         = 201
Const xKEY_LEFT          = 203
Const xKEY_RIGHT         = 205
Const xKEY_END           = 207
Const xKEY_DOWN          = 208
Const xKEY_NEXT          = 209
Const xKEY_INSERT        = 210
Const xKEY_DELETE        = 211
Const xKEY_LWIN          = 219
Const xKEY_RWIN          = 220
Const xKEY_BACKSPACE     = xKEY_BACK
Const xKEY_NUMPADSTAR    = xKEY_MULTIPLY
Const xKEY_RALT          = 184
Const xKEY_CAPSLOCK      = 58
Const xKEY_NUMPADMINUS   = xKEY_SUBTRACT
Const xKEY_NUMPADPLUS    = xKEY_ADD
Const xKEY_NUMPADPERIOD  = xKEY_DECIMAL
Const xKEY_DIVIDE        = 181
Const xKEY_NUMPADSLASH   = xKEY_DIVIDE
Const xKEY_LALT          = 56
Const xKEY_UPARROW       = xKEY_UP
Const xKEY_PGUP          = xKEY_PRIOR
Const xKEY_LEFTARROW     = xKEY_LEFT
Const xKEY_RIGHTARROW    = xKEY_RIGHT
Const xKEY_DOWNARROW     = xKEY_DOWN
Const xKEY_PGDN          = xKEY_NEXT