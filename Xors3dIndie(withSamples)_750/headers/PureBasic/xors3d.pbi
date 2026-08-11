; *****************************************************************
; *                                                               *
; * Xors3d Engine header file for PureBasic, (c) 2012 XorsTeam    *
; * www:    http://xors3d.com                                     *
; * e-mail: support@xors3d.com                                    *
; *                                                               *
; *****************************************************************

XIncludeFile "xors3d_decls.pbi"
; Log levels
#LOG_NO            = 5
#LOG_FATAL         = 4
#LOG_ERROR         = 3
#LOG_WARNING       = 2
#LOG_MESSAGE       = 1
#LOG_INFO          = 0

; Log targets
#LOG_HTML          = 1
#LOG_COUT          = 2
#LOG_STRING        = 4

; Skinning types
#SKIN_SOFTWARE = 2
#SKIN_HARDWARE = 1

; Light sources types
#LIGHT_DIRECTIONAL = 1
#LIGHT_POINT       = 2
#LIGHT_SPOT        = 3

; Texture filtering
#TF_NONE           = 0
#TF_POINT          = 1
#TF_LINEAR         = 2
#TF_ANISOTROPIC    = 3
#TF_ANISOTROPICX4  = 4
#TF_ANISOTROPICX8  = 5
#TF_ANISOTROPICX16 = 6

; PixelShader versions
#PS_1_1 = 0
#PS_1_2 = 1
#PS_1_3 = 2
#PS_1_4 = 3
#PS_2_0 = 4
#PS_3_0 = 5

; VertexShader versions
#VS_1_1 = 0
#VS_2_0 = 1
#VS_3_0 = 2

; Matrix semantics
#WORLD                         = 0
#WORLDVIEWPROJ                 = 1
#VIEWPROJ                      = 2
#VIEW                          = 3
#PROJ                          = 4
#WORLDVIEW                     = 5
#VIEWINVERSE                   = 6
#WORLDINVERSETRANSPOSE         = 15
#WORLDINVERSE                  = 16
#WORLDTRANSPOSE                = 17
#VIEWPROJINVERSE               = 18
#VIEWPROJINVERSETRANSPOSE      = 19
#VIEWTRANSPOSE                 = 20
#VIEWINVRSETRANSPOSE           = 21
#PROJINVERSE                   = 22
#PROJTRANSPOSE                 = 23
#PROJINVRSETRANSPOSE           = 24
#WORLDVIEWPROJTRANSPOSE        = 25
#WORLDVIEWPROJINVERSE          = 26
#WORLDVIEWPROJINVERSETRANSPOSE = 27
#WORLDVIEWTRANSPOSE            = 28
#WORLDVIEWINVERSE              = 29
#WORLDVIEWINVERSETRANSPOSE     = 30

; Antialiasing types
#AANONE      = 0
#AA2SAMPLES  = 1
#AA3SAMPLES  = 2
#AA4SAMPLES  = 3
#AA5SAMPLES  = 4
#AA6SAMPLES  = 5
#AA7SAMPLES  = 6
#AA8SAMPLES  = 7
#AA9SAMPLES  = 8
#AA10SAMPLES = 9
#AA11SAMPLES = 10
#AA12SAMPLES = 11
#AA13SAMPLES = 12
#AA14SAMPLES = 13
#AA15SAMPLES = 14
#AA16SAMPLES = 15

; Camera fog mode
#FOG_NONE     = 0
#FOG_LINEAR   = 1

; Camera projection mode
#PROJ_DISABLE      = 0
#PROJ_PERSPECTIVE	= 1
#PROJ_ORTHOGRAPHIC = 2

; Entity FX flags
#FX_NOTHING        = 0
#FX_FULLBRIGHT     = 1
#FX_VERTEXCOLOR    = 2
#FX_FLATSHADED     = 4
#FX_DISABLEFOG     = 8
#FX_DISABLECULLING = 16
#FX_NOALPHABLEND   = 32

; Entity blending modes
#BLEND_ALPHA       = 1
#BLEND_MULTIPLY    = 2
#BLEND_ADD         = 3
#BLEND_PUREADD     = 4

; Compare functions
#CMP_NEVER         = 1
#CMP_LESS          = 2
#CMP_EQUAL         = 3
#CMP_LESSEQUAL     = 4
#CMP_GREATER       = 5
#CMP_NOTEQUAL      = 6
#CMP_GREATEREQUAL  = 7
#CMP_ALWAYS        = 8

; Axis
#AXIS_X    = 1
#AXIS_Y    = 2
#AXIS_Z    = 3

; Texture loading flags
#FLAGS_COLOR             = 1
#FLAGS_ALPHA             = 2
#FLAGS_MASKED            = 4
#FLAGS_MIPMAPPED         = 8
#FLAGS_CLAMPU            = 16
#FLAGS_CLAMPV            = 32
#FLAGS_SPHERICALENVMAP   = 64
#FLAGS_CUBICENVMAP       = 128
#FLAGS_R32F              = 256
#FLAGS_SKIPCACHE         = 512
#FLAGS_VOLUMETEXTURE     = 1024
#FLAGS_ARBG16F           = 2048
#FLAGS_ARBG32F           = 4096

; Texture blending modes
#TEXBLEND_NONE          = 0
#TEXBLEND_ALPHA         = 1
#TEXBLEND_MULTIPLY      = 2
#TEXBLEND_ADD           = 3
#TEXBLEND_DOT3          = 4
#TEXBLEND_LIGHTMAP      = 5
#TEXBLEND_SEPARATEALPHA = 6

; Cube map faces
#FACE_LEFT     = 0
#FACE_FORWARD  = 1
#FACE_RIGHT    = 2
#FACE_BACKWARD = 3
#FACE_UP       = 4
#FACE_DOWN     = 5

; Entity animation types
#ANIMATION_STOP      = 0
#ANIMATION_LOOP      = 1
#ANIMATION_PINGPONG  = 2
#ANIMATION_ONE       = 3

; Collision types
#SPHERETOSPHERE  = 1
#SPHERETOBOX     = 3
#SPHERETOTRIMESH = 2

; Collision respones types
#RESPONSE_STOP             = 1
#RESPONSE_SLIDING          = 2
#RESPONSE_SLIDING_DOWNLOCK = 3

; Entity picking modes
#PICK_NONE     = 0
#PICK_SPHERE   = 1
#PICK_TRIMESH  = 2
#PICK_BOX      = 3

; Sprite view modes
#SPRITE_FIXED    = 1
#SPRITE_FREE     = 2
#SPRITE_FREEROLL = 3
#SPRITE_FIXEDYAW = 4

; Joystick types
#JOY_NONE    = 0
#JOY_DIGITAL = 1
#JOY_ANALOG  = 2

; Cubemap rendering modes
#CUBEMAP_SPECULAR   = 1
#CUBEMAP_DIFFUSE    = 2
#CUBEMAP_REFRACTION = 3

; Shadow's blur levels
#SHADOWS_BLUR_NONE  = 0
#SHADOWS_BLUR_3     = 1
#SHADOWS_BLUR_5     = 2
#SHADOWS_BLUR_7     = 3
#SHADOWS_BLUR_11    = 4
#SHADOWS_BLUR_13    = 5

; primitives types
#PRIMITIVE_POINTLIST     = 1
#PRIMITIVE_LINELIST      = 2
#PRIMITIVE_LINESTRIP     = 3
#PRIMITIVE_TRIANGLELIST  = 4
#PRIMITIVE_TRIANGLESTRIP = 5
#PRIMITIVE_TRIANGLEFAN   = 6

; line separator types
#LS_NUL	= 0
#LS_CR		= 1
#LS_LF		= 2
#LS_CRLF	= 3

; physics: joint types
#JOINT_POINT2POINT	= 0
#JOINT_6DOF		= 1
#JOINT_6DOFSPRING	= 2
#JOINT_HINGE		= 3

; physics: debug drawer modes
#PXDD_NO           = 0
#PXDD_WIREFRAME    = 1
#PXDD_AABB         = 2
#PXDD_CONTACTS     = 4
#PXDD_JOINTS       = 8
#PXDD_JOINT_LIMITS = 16
#PXDD_NO_AXIS      = 32

; physics: ray casting modes
#PXRC_SINGLE   = 0
#PXRC_MULTIPLE = 1

Macro xGetBrushName(brush)
	PeekS ( xGetBrushName_(brush) )
EndMacro

Macro xEntityClass(entity)
	PeekS ( xEntityClass_(entity) )
EndMacro

Macro xEntityName(entity)
	PeekS ( xEntityName_(entity) )
EndMacro

Macro xFileCreationTimeStr(path)
	PeekS ( xFileCreationTimeStr_(path) )
EndMacro

Macro xFileModificationTimeStr(path)
	PeekS ( xFileModificationTimeStr_(path) )
EndMacro

Macro xNextFile(handle)
	PeekS ( xNextFile_(handle) )
EndMacro

Macro xCurrentDir()
	PeekS ( xCurrentDir_() )
EndMacro

Macro xReadString(file)
	PeekS ( xReadString_(file) )
EndMacro

Macro xReadLine(file, ls_flag = 0)
	PeekS ( xReadLine_(file, ls_flag) )
EndMacro

Macro xGetEngineSetting(parameter)
	PeekS ( xGetEngineSetting_(parameter) )
EndMacro

Macro xGetLogString()
	PeekS ( xGetLogString_() )
EndMacro

Macro xCPUName()
	PeekS ( xCPUName_() )
EndMacro

Macro xCPUVendor()
	PeekS ( xCPUVendor_() )
EndMacro

Macro xVideoInfo()
	PeekS ( xVideoInfo_() )
EndMacro

Macro xVideoAspectRatioStr()
	PeekS ( xVideoAspectRatioStr_() )
EndMacro

Macro xGetXors3dVersion()
	PeekS ( xGetXors3dVersion_() )
EndMacro

Macro xTextureName(texture)
	PeekS ( xTextureName_(texture) )
EndMacro
; Scancodes for keyboard and mouse
#MOUSE_LEFT        = 1
#MOUSE_RIGHT       = 2
#MOUSE_MIDDLE      = 3
#MOUSE4            = 4
#MOUSE5            = 5
#MOUSE6            = 6
#MOUSE7            = 7
#MOUSE8            = 8

#xMOUSE_LEFT       = 1
#xMOUSE_RIGHT      = 2
#xMOUSE_MIDDLE     = 3
#xMOUSE4           = 4
#xMOUSE5           = 5
#xMOUSE6           = 6
#xMOUSE7           = 7
#xMOUSE8           = 8

#KEY_ESCAPE        = 1
#KEY_1             = 2
#KEY_2             = 3
#KEY_3             = 4
#KEY_4             = 5
#KEY_5             = 6
#KEY_6             = 7
#KEY_7             = 8
#KEY_8             = 9
#KEY_9             = 10
#KEY_0             = 11
#KEY_MINUS         = 12
#KEY_EQUALS        = 13
#KEY_BACK          = 14
#KEY_TAB           = 15
#KEY_Q             = 16
#KEY_W             = 17
#KEY_E             = 18
#KEY_R             = 19
#KEY_T             = 20
#KEY_Y             = 21
#KEY_U             = 22
#KEY_I             = 23
#KEY_O             = 24
#KEY_P             = 25
#KEY_LBRACKET      = 26
#KEY_RBRACKET      = 27
#KEY_RETURN        = 28
#KEY_ENTER         = #KEY_RETURN
#KEY_LCONTROL      = 29
#KEY_RCONTROL      = 157
#KEY_A             = 30
#KEY_S             = 31
#KEY_D             = 32
#KEY_F             = 33
#KEY_G             = 34
#KEY_H             = 35
#KEY_J             = 36
#KEY_K             = 37
#KEY_L             = 38
#KEY_SEMICOLON     = 39
#KEY_APOSTROPHE    = 40
#KEY_GRAVE         = 41
#KEY_LSHIFT        = 42
#KEY_BACKSLASH     = 43
#KEY_Z             = 44
#KEY_X             = 45
#KEY_C             = 46
#KEY_V             = 47
#KEY_B             = 48
#KEY_N             = 49
#KEY_M             = 50
#KEY_COMMA         = 51
#KEY_PERIOD        = 52
#KEY_SLASH         = 53
#KEY_RSHIFT        = 54
#KEY_MULTIPLY      = 55
#KEY_MENU          = 56
#KEY_SPACE         = 57
#KEY_F1            = 59
#KEY_F2            = 60
#KEY_F3            = 61
#KEY_F4            = 62
#KEY_F5            = 63
#KEY_F6            = 64
#KEY_F7            = 65
#KEY_F8            = 66
#KEY_F9            = 67
#KEY_F10           = 68
#KEY_NUMLOCK       = 69
#KEY_SCROLL        = 70
#KEY_NUMPAD7       = 71
#KEY_NUMPAD8       = 72
#KEY_NUMPAD9       = 73
#KEY_SUBTRACT      = 74
#KEY_NUMPAD4       = 75
#KEY_NUMPAD5       = 76
#KEY_NUMPAD6       = 77
#KEY_ADD           = 78
#KEY_NUMPAD1       = 79
#KEY_NUMPAD2       = 80
#KEY_NUMPAD3       = 81
#KEY_NUMPAD0       = 82
#KEY_DECIMAL       = 83
#KEY_TILD          = 86
#KEY_F11           = 87
#KEY_F12           = 88
#KEY_NUMPADENTER   = 156
#KEY_RMENU         = 221
#KEY_PAUSE         = 197
#KEY_HOME          = 199
#KEY_UP            = 200
#KEY_PRIOR         = 201
#KEY_LEFT          = 203
#KEY_RIGHT         = 205
#KEY_END           = 207
#KEY_DOWN          = 208
#KEY_NEXT          = 209
#KEY_INSERT        = 210
#KEY_DELETE        = 211
#KEY_LWIN          = 219
#KEY_RWIN          = 220
#KEY_BACKSPACE     = #KEY_BACK
#KEY_NUMPADSTAR    = #KEY_MULTIPLY
#KEY_CAPSLOCK      = 58
#KEY_NUMPADMINUS   = #KEY_SUBTRACT
#KEY_NUMPADPLUS    = #KEY_ADD
#KEY_NUMPADPERIOD  = #KEY_DECIMAL
#KEY_DIVIDE        = 181
#KEY_NUMPADSLASH   = #KEY_DIVIDE
#KEY_LALT          = 56
#KEY_RALT          = 184
#KEY_UPARROW       = #KEY_UP
#KEY_PGUP          = #KEY_PRIOR
#KEY_LEFTARROW     = #KEY_LEFT
#KEY_RIGHTARROW    = #KEY_RIGHT
#KEY_DOWNARROW     = #KEY_DOWN
#KEY_PGDN          = #KEY_NEXT

#xKEY_ESCAPE       = 1
#xKEY_1            = 2
#xKEY_2            = 3
#xKEY_3            = 4
#xKEY_4            = 5
#xKEY_5            = 6
#xKEY_6            = 7
#xKEY_7            = 8
#xKEY_8            = 9
#xKEY_9            = 10
#xKEY_0            = 11
#xKEY_MINUS        = 12
#xKEY_EQUALS       = 13
#xKEY_BACK         = 14
#xKEY_TAB          = 15
#xKEY_Q            = 16
#xKEY_W            = 17
#xKEY_E            = 18
#xKEY_R            = 19
#xKEY_T            = 20
#xKEY_Y            = 21
#xKEY_U            = 22
#xKEY_I            = 23
#xKEY_O            = 24
#xKEY_P            = 25
#xKEY_LBRACKET     = 26
#xKEY_RBRACKET     = 27
#xKEY_RETURN       = 28
#xKEY_ENTER        = #xKEY_RETURN
#xKEY_LCONTROL     = 29
#xKEY_RCONTROL     = 157
#xKEY_A            = 30
#xKEY_S            = 31
#xKEY_D            = 32
#xKEY_F            = 33
#xKEY_G            = 34
#xKEY_H            = 35
#xKEY_J            = 36
#xKEY_K            = 37
#xKEY_L            = 38
#xKEY_SEMICOLON    = 39
#xKEY_APOSTROPHE   = 40
#xKEY_GRAVE        = 41
#xKEY_LSHIFT       = 42
#xKEY_BACKSLASH    = 43
#xKEY_Z            = 44
#xKEY_X            = 45
#xKEY_C            = 46
#xKEY_V            = 47
#xKEY_B            = 48
#xKEY_N            = 49
#xKEY_M            = 50
#xKEY_COMMA        = 51
#xKEY_PERIOD       = 52
#xKEY_SLASH        = 53
#xKEY_RSHIFT       = 54
#xKEY_MULTIPLY     = 55
#xKEY_MENU         = 56
#xKEY_SPACE        = 57
#xKEY_F1           = 59
#xKEY_F2           = 60
#xKEY_F3           = 61
#xKEY_F4           = 62
#xKEY_F5           = 63
#xKEY_F6           = 64
#xKEY_F7           = 65
#xKEY_F8           = 66
#xKEY_F9           = 67
#xKEY_F10          = 68
#xKEY_NUMLOCK      = 69
#xKEY_SCROLL       = 70
#xKEY_NUMPAD7      = 71
#xKEY_NUMPAD8      = 72
#xKEY_NUMPAD9      = 73
#xKEY_SUBTRACT     = 74
#xKEY_NUMPAD4      = 75
#xKEY_NUMPAD5      = 76
#xKEY_NUMPAD6      = 77
#xKEY_ADD          = 78
#xKEY_NUMPAD1      = 79
#xKEY_NUMPAD2      = 80
#xKEY_NUMPAD3      = 81
#xKEY_NUMPAD0      = 82
#xKEY_DECIMAL      = 83
#xKEY_TILD         = 86
#xKEY_F11          = 87
#xKEY_F12          = 88
#xKEY_NUMPADENTER  = 156
#xKEY_RMENU        = 221
#xKEY_PAUSE        = 197
#xKEY_HOME         = 199
#xKEY_UP           = 200
#xKEY_PRIOR        = 201
#xKEY_LEFT         = 203
#xKEY_RIGHT        = 205
#xKEY_END          = 207
#xKEY_DOWN         = 208
#xKEY_NEXT         = 209
#xKEY_INSERT       = 210
#xKEY_DELETE       = 211
#xKEY_LWIN         = 219
#xKEY_RWIN         = 220
#xKEY_BACKSPACE    = #xKEY_BACK
#xKEY_NUMPADSTAR   = #xKEY_MULTIPLY
#xKEY_CAPSLOCK     = 58
#xKEY_NUMPADMINUS  = #xKEY_SUBTRACT
#xKEY_NUMPADPLUS   = #xKEY_ADD
#xKEY_NUMPADPERIOD = #xKEY_DECIMAL
#xKEY_DIVIDE       = 181
#xKEY_NUMPADSLASH  = #xKEY_DIVIDE
#xKEY_LALT         = 56
#xKEY_RALT         = 184
#xKEY_UPARROW      = #xKEY_UP
#xKEY_PGUP         = #xKEY_PRIOR
#xKEY_LEFTARROW    = #xKEY_LEFT
#xKEY_RIGHTARROW   = #xKEY_RIGHT
#xKEY_DOWNARROW    = #xKEY_DOWN
#xKEY_PGDN         = #xKEY_NEXT