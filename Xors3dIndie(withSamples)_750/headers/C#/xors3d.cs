//*****************************************************************
//*                                                               *
//* Xors3d Engine header file for C#, (c) 2012 XorsTeam           *
//* www:    http://xors3d.com                                     *
//* e-mail: support@xors3d.com                                    *
//*                                                               *
//*****************************************************************

using System;
using System.Text;
using System.Runtime.InteropServices;

public class Xors3d
{
	// Log levels
	public const int LOG_NO            = 5;
	public const int LOG_FATAL         = 4;
	public const int LOG_ERROR         = 3;
	public const int LOG_WARNING       = 2;
	public const int LOG_MESSAGE       = 1;
	public const int LOG_INFO          = 0;

	// Log targets
	public const int LOG_HTML             = 1;
	public const int LOG_COUT             = 2;
	public const int LOG_STRING           = 4;

	// Skinning types
	public const int SKIN_SOFTWARE = 2;
	public const int SKIN_HARDWARE = 1;

	// Light sources types
	public const int LIGHT_DIRECTIONAL = 1;
	public const int LIGHT_POINT       = 2;
	public const int LIGHT_SPOT        = 3;

	// Texture filtering
	public const int TF_NONE           = 0;
	public const int TF_POINT          = 1;
	public const int TF_LINEAR         = 2;
	public const int TF_ANISOTROPIC    = 3;
	public const int TF_ANISOTROPICX4  = 4;
	public const int TF_ANISOTROPICX8  = 5;
	public const int TF_ANISOTROPICX16 = 6;

	// PixelShader versions
	public const int PS_1_1 = 0;
	public const int PS_1_2 = 1;
	public const int PS_1_3 = 2;
	public const int PS_1_4 = 3;
	public const int PS_2_0 = 4;
	public const int PS_3_0 = 5;

	// VertexShader versions
	public const int VS_1_1 = 0;
	public const int VS_2_0 = 1;
	public const int VS_3_0 = 2;

	// Matrix semantics
	public const int WORLD                         = 0;
	public const int WORLDVIEWPROJ                 = 1;
	public const int VIEWPROJ                      = 2;
	public const int VIEW                          = 3;
	public const int PROJ                          = 4;
	public const int WORLDVIEW                     = 5;
	public const int VIEWINVERSE                   = 6;
	public const int WORLDINVERSETRANSPOSE         = 15;
	public const int WORLDINVERSE                  = 16;
	public const int WORLDTRANSPOSE                = 17;
	public const int VIEWPROJINVERSE               = 18;
	public const int VIEWPROJINVERSETRANSPOSE      = 19;
	public const int VIEWTRANSPOSE                 = 20;
	public const int VIEWINVRSETRANSPOSE           = 21;
	public const int PROJINVERSE                   = 22;
	public const int PROJTRANSPOSE                 = 23;
	public const int PROJINVRSETRANSPOSE           = 24;
	public const int WORLDVIEWPROJTRANSPOSE        = 25;
	public const int WORLDVIEWPROJINVERSE          = 26;
	public const int WORLDVIEWPROJINVERSETRANSPOSE = 27;
	public const int WORLDVIEWTRANSPOSE            = 28;
	public const int WORLDVIEWINVERSE              = 29;
	public const int WORLDVIEWINVERSETRANSPOSE     = 30;

	// Antialiasing types
	public const int AANONE      = 0;
	public const int AA2SAMPLES  = 1;
	public const int AA3SAMPLES  = 2;
	public const int AA4SAMPLES  = 3;
	public const int AA5SAMPLES  = 4;
	public const int AA6SAMPLES  = 5;
	public const int AA7SAMPLES  = 6;
	public const int AA8SAMPLES  = 7;
	public const int AA9SAMPLES  = 8;
	public const int AA10SAMPLES = 9;
	public const int AA11SAMPLES = 10;
	public const int AA12SAMPLES = 11;
	public const int AA13SAMPLES = 12;
	public const int AA14SAMPLES = 13;
	public const int AA15SAMPLES = 14;
	public const int AA16SAMPLES = 15;

	// Camera fog mode
	public const int FOG_NONE     = 0;
	public const int FOG_LINEAR   = 1;

	// Camera projection mode
	public const int PROJ_DISABLE      = 0;
	public const int PROJ_PERSPECTIVE	= 1;
	public const int PROJ_ORTHOGRAPHIC = 2;

	// Entity FX flags
	public const int FX_NOTHING        = 0;
	public const int FX_FULLBRIGHT     = 1;
	public const int FX_VERTEXCOLOR    = 2;
	public const int FX_FLATSHADED     = 4;
	public const int FX_DISABLEFOG     = 8;
	public const int FX_DISABLECULLING = 16;
	public const int FX_NOALPHABLEND   = 32;

	// Entity blending modes
	public const int BLEND_ALPHA       = 1;
	public const int BLEND_MULTIPLY    = 2;
	public const int BLEND_ADD         = 3;
	public const int BLEND_PUREADD     = 4;

	// Compare functions
	public const int CMP_NEVER         = 1;
	public const int CMP_LESS          = 2;
	public const int CMP_EQUAL         = 3;
	public const int CMP_LESSEQUAL     = 4;
	public const int CMP_GREATER       = 5;
	public const int CMP_NOTEQUAL      = 6;
	public const int CMP_GREATEREQUAL  = 7;
	public const int CMP_ALWAYS        = 8;

	// Axis
	public const int AXIS_X    = 1;
	public const int AXIS_Y    = 2;
	public const int AXIS_Z    = 3;

	// Texture loading flags
	public const int FLAGS_COLOR             = 1;
	public const int FLAGS_ALPHA             = 2;
	public const int FLAGS_MASKED            = 4;
	public const int FLAGS_MIPMAPPED         = 8;
	public const int FLAGS_CLAMPU            = 16;
	public const int FLAGS_CLAMPV            = 32;
	public const int FLAGS_SPHERICALENVMAP   = 64;
	public const int FLAGS_CUBICENVMAP       = 128;
	public const int FLAGS_R32F              = 256;
	public const int FLAGS_SKIPCACHE         = 512;
	public const int FLAGS_VOLUMETEXTURE     = 1024;
	public const int FLAGS_ARBG16F           = 2048;
	public const int FLAGS_ARBG32F           = 4096;

	// Texture blending modes
	public const int TEXBLEND_NONE          = 0;
	public const int TEXBLEND_ALPHA         = 1;
	public const int TEXBLEND_MULTIPLY      = 2;
	public const int TEXBLEND_ADD           = 3;
	public const int TEXBLEND_DOT3          = 4;
	public const int TEXBLEND_LIGHTMAP      = 5;
	public const int TEXBLEND_SEPARATEALPHA = 6;

	// Cube map faces
	public const int FACE_LEFT     = 0;
	public const int FACE_FORWARD  = 1;
	public const int FACE_RIGHT    = 2;
	public const int FACE_BACKWARD = 3;
	public const int FACE_UP       = 4;
	public const int FACE_DOWN     = 5;

	// Entity animation types
	public const int ANIMATION_STOP      = 0;
	public const int ANIMATION_LOOP      = 1;
	public const int ANIMATION_PINGPONG  = 2;
	public const int ANIMATION_ONE       = 3;

	// Collision types
	public const int SPHERETOSPHERE  = 1;
	public const int SPHERETOBOX     = 3;
	public const int SPHERETOTRIMESH = 2;

	// Collision respones types
	public const int RESPONSE_STOP             = 1;
	public const int RESPONSE_SLIDING          = 2;
	public const int RESPONSE_SLIDING_DOWNLOCK = 3;

	// Entity picking modes
	public const int PICK_NONE     = 0;
	public const int PICK_SPHERE   = 1;
	public const int PICK_TRIMESH  = 2;
	public const int PICK_BOX      = 3;

	// Sprite view modes
	public const int SPRITE_FIXED    = 1;
	public const int SPRITE_FREE     = 2;
	public const int SPRITE_FREEROLL = 3;
	public const int SPRITE_FIXEDYAW = 4;

	// Joystick types
	public const int JOY_NONE    = 0;
	public const int JOY_DIGITAL = 1;
	public const int JOY_ANALOG  = 2;

	// Cubemap rendering modes
	public const int CUBEMAP_SPECULAR   = 1;
	public const int CUBEMAP_DIFFUSE    = 2;
	public const int CUBEMAP_REFRACTION = 3;

	// Shadow's blur levels
	public const int SHADOWS_BLUR_NONE = 0;
	public const int SHADOWS_BLUR_3    = 1;
	public const int SHADOWS_BLUR_5    = 2;
	public const int SHADOWS_BLUR_7    = 3;
	public const int SHADOWS_BLUR_11   = 4;
	public const int SHADOWS_BLUR_13   = 5;


	// primitives types
	public const int PRIMITIVE_POINTLIST     = 1;
	public const int PRIMITIVE_LINELIST      = 2;
	public const int PRIMITIVE_LINESTRIP     = 3;
	public const int PRIMITIVE_TRIANGLELIST  = 4;
	public const int PRIMITIVE_TRIANGLESTRIP = 5;
	public const int PRIMITIVE_TRIANGLEFAN   = 6;
	
	// line separator types
	public const int LS_NUL		= 0;
	public const int LS_CR		= 1;
	public const int LS_LF		= 2;
	public const int LS_CRLF	= 3;
	
	// physics: joint types
	public const int JOINT_POINT2POINT	= 0;
	public const int JOINT_6DOF			= 1;
	public const int JOINT_6DOFSPRING	= 2;
	public const int JOINT_HINGE		= 3;
	
	// physics: debug drawer modes
	public const int PXDD_NO           = 0;
	public const int PXDD_WIREFRAME    = 1;
	public const int PXDD_AABB         = 2;
	public const int PXDD_CONTACTS     = 4;
	public const int PXDD_JOINTS       = 8;
	public const int PXDD_JOINT_LIMITS = 16;
	public const int PXDD_NO_AXIS      = 32;

	// physics: ray casting modes
	public const int PXRC_SINGLE   = 0;
	public const int PXRC_MULTIPLE = 1;

	// 3dlines commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateLine3D")]
	public static extern int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int red, int green, int blue, int alpha, bool useZBuffer);

	public static int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int red, int green, int blue, int alpha)
	{
		return CreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, red, green, blue, alpha, true);
	}
	public static int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int red, int green, int blue)
	{
		return CreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, red, green, blue, 255, true);
	}
	public static int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int red, int green)
	{
		return CreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, red, green, 255, 255, true);
	}
	public static int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int red)
	{
		return CreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, red, 255, 255, 255, true);
	}
	public static int CreateLine3D(float fromX, float fromY, float fromZ, float toX, float toY, float toZ)
	{
		return CreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, 255, 255, 255, 255, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DOrigin")]
	public static extern void Line3DOrigin(int line3d, float x, float y, float z, bool isGlobal);

	public static void Line3DOrigin(int line3d, float x, float y, float z)
	{
		 Line3DOrigin(line3d, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DAddNode")]
	public static extern void Line3DAddNode(int line3d, float x, float y, float z, bool isGlobal);

	public static void Line3DAddNode(int line3d, float x, float y, float z)
	{
		 Line3DAddNode(line3d, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DColor")]
	public static extern void Line3DColor(int line3d, int red, int green, int blue, int alpha);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DUseZBuffer")]
	public static extern void Line3DUseZBuffer(int line3d, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DOriginX")]
	public static extern float Line3DOriginX(int line3d, bool isGlobal);

	public static float Line3DOriginX(int line3d)
	{
		return Line3DOriginX(line3d, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DOriginY")]
	public static extern float Line3DOriginY(int line3d, bool isGlobal);

	public static float Line3DOriginY(int line3d)
	{
		return Line3DOriginY(line3d, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DOriginZ")]
	public static extern float Line3DOriginZ(int line3d, bool isGlobal);

	public static float Line3DOriginZ(int line3d)
	{
		return Line3DOriginZ(line3d, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DNodesCount")]
	public static extern int Line3DNodesCount(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DNodePosition")]
	public static extern void Line3DNodePosition(int line3d, int index, float x, float y, float z, bool isGlobal);

	public static void Line3DNodePosition(int line3d, int index, float x, float y, float z)
	{
		 Line3DNodePosition(line3d, index, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DNodeX")]
	public static extern float Line3DNodeX(int line3d, int index, bool isGlobal);

	public static float Line3DNodeX(int line3d, int index)
	{
		return Line3DNodeX(line3d, index, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DNodeY")]
	public static extern float Line3DNodeY(int line3d, int index, bool isGlobal);

	public static float Line3DNodeY(int line3d, int index)
	{
		return Line3DNodeY(line3d, index, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DNodeZ")]
	public static extern float Line3DNodeZ(int line3d, int index, bool isGlobal);

	public static float Line3DNodeZ(int line3d, int index)
	{
		return Line3DNodeZ(line3d, index, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLine3DRed")]
	public static extern int Line3DRed(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DGreen")]
	public static extern int Line3DGreen(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DBlue")]
	public static extern int Line3DBlue(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xLine3DAlpha")]
	public static extern int Line3DAlpha(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xGetLine3DUseZBuffer")]
	public static extern int GetLine3DUseZBuffer(int line3d);

	[DllImport("xors3d.dll", EntryPoint = "xDeleteLine3DNode")]
	public static extern void DeleteLine3DNode(int line3d, int index);

	[DllImport("xors3d.dll", EntryPoint = "xClearLine3D")]
	public static extern void ClearLine3D(int line3d);


	// brushes commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadBrush")]
	public static extern int LoadBrush_(StringBuilder path, int flags, float xScale, float yScale);
	public static int LoadBrush(string path, int flags, float xScale, float yScale)
	{
		return LoadBrush_(new StringBuilder(path), flags, xScale, yScale);
	}
	public static int LoadBrush(string path, int flags, float xScale)
	{
		return LoadBrush(path, flags, xScale, 1.0f);
	}
	public static int LoadBrush(string path, int flags)
	{
		return LoadBrush(path, flags, 1.0f, 1.0f);
	}
	public static int LoadBrush(string path)
	{
		return LoadBrush(path, 9, 1.0f, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateBrush")]
	public static extern int CreateBrush(float red, float green, float blue);

	public static int CreateBrush(float red, float green)
	{
		return CreateBrush(red, green, 255.0f);
	}
	public static int CreateBrush(float red)
	{
		return CreateBrush(red, 255.0f, 255.0f);
	}
	public static int CreateBrush()
	{
		return CreateBrush(255.0f, 255.0f, 255.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeBrush")]
	public static extern void FreeBrush(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushTexture")]
	public static extern int GetBrushTexture(int brush, int index);

	public static int GetBrushTexture(int brush)
	{
		return GetBrushTexture(brush, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xBrushColor")]
	public static extern void BrushColor(int brush, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xBrushAlpha")]
	public static extern void BrushAlpha(int brush, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xBrushShininess")]
	public static extern void BrushShininess(int brush, float shininess);

	[DllImport("xors3d.dll", EntryPoint = "xBrushBlend")]
	public static extern void BrushBlend(int brush, int blend);

	[DllImport("xors3d.dll", EntryPoint = "xBrushFX")]
	public static extern void BrushFX(int brush, int FX);

	[DllImport("xors3d.dll", EntryPoint = "xBrushTexture")]
	public static extern void BrushTexture(int brush, int texture, int frame, int index);

	public static void BrushTexture(int brush, int texture, int frame)
	{
		 BrushTexture(brush, texture, frame, 0);
	}
	public static void BrushTexture(int brush, int texture)
	{
		 BrushTexture(brush, texture, 0, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetBrushName")]
	public static extern IntPtr GetBrushName_(int brush);
	public static string GetBrushName(int brush)
	{
		return Marshal.PtrToStringAnsi(GetBrushName_(brush));
	}

	[DllImport("xors3d.dll", EntryPoint = "xBrushName")]
	public static extern void BrushName_(int brush, StringBuilder name);
	public static void BrushName(int brush, string name)
	{
		BrushName_(brush, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetBrushAlpha")]
	public static extern float GetBrushAlpha(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushBlend")]
	public static extern int GetBrushBlend(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushRed")]
	public static extern int GetBrushRed(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushGreen")]
	public static extern int GetBrushGreen(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushBlue")]
	public static extern int GetBrushBlue(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushFX")]
	public static extern int GetBrushFX(int brush);

	[DllImport("xors3d.dll", EntryPoint = "xGetBrushShininess")]
	public static extern float GetBrushShininess(int brush);


	// cameras commands
	[DllImport("xors3d.dll", EntryPoint = "xCameraFogMode")]
	public static extern void CameraFogMode(int camera, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xCameraFogColor")]
	public static extern void CameraFogColor(int camera, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xCameraFogRange")]
	public static extern void CameraFogRange(int camera, float nearRange, float farRange);

	[DllImport("xors3d.dll", EntryPoint = "xCameraClsColor")]
	public static extern void CameraClsColor(int camera, int red, int green, int blue, int alpha);

	public static void CameraClsColor(int camera, int red, int green, int blue)
	{
		 CameraClsColor(camera, red, green, blue, 255);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCameraProjMode")]
	public static extern void CameraProjMode(int camera, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xCameraClsMode")]
	public static extern void CameraClsMode(int camera, int clearColor, int clearZBuffer);

	[DllImport("xors3d.dll", EntryPoint = "xSphereInFrustum")]
	public static extern int SphereInFrustum(int camera, float x, float y, float z, float radii);

	[DllImport("xors3d.dll", EntryPoint = "xCameraClipPlane")]
	public static extern void CameraClipPlane(int camera, int index, bool enabled, float a, float b, float c, float d);

	[DllImport("xors3d.dll", EntryPoint = "xCameraRange")]
	public static extern void CameraRange(int camera, float nearRange, float farRange);

	[DllImport("xors3d.dll", EntryPoint = "xCameraViewport")]
	public static extern void CameraViewport(int camera, int x, int y, int width, int height);

	[DllImport("xors3d.dll", EntryPoint = "xCameraCropViewport")]
	public static extern void CameraCropViewport(int camera, int x, int y, int width, int height);

	[DllImport("xors3d.dll", EntryPoint = "xCreateCamera")]
	public static extern int CreateCamera(int parent);

	public static int CreateCamera()
	{
		return CreateCamera(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCameraProject")]
	public static extern void CameraProject(int camera, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xCameraProject2D")]
	public static extern void CameraProject2D(int camera, int x, int y, float zDistance);

	[DllImport("xors3d.dll", EntryPoint = "xProjectedX")]
	public static extern float ProjectedX();

	[DllImport("xors3d.dll", EntryPoint = "xProjectedY")]
	public static extern float ProjectedY();

	[DllImport("xors3d.dll", EntryPoint = "xProjectedZ")]
	public static extern float ProjectedZ();

	[DllImport("xors3d.dll", EntryPoint = "xGetViewMatrix")]
	public static extern int GetViewMatrix(int camera);

	[DllImport("xors3d.dll", EntryPoint = "xGetProjectionMatrix")]
	public static extern int GetProjectionMatrix(int camera);

	[DllImport("xors3d.dll", EntryPoint = "xCameraZoom")]
	public static extern void CameraZoom(int camera, float zoom);

	[DllImport("xors3d.dll", EntryPoint = "xGetViewProjMatrix")]
	public static extern int GetViewProjMatrix(int camera);


	// collisions commands
	[DllImport("xors3d.dll", EntryPoint = "xCollisions")]
	public static extern void Collisions(int srcType, int destType, int collideMethod, int response);

	[DllImport("xors3d.dll", EntryPoint = "xClearCollisions")]
	public static extern void ClearCollisions();

	[DllImport("xors3d.dll", EntryPoint = "xResetEntity")]
	public static extern void ResetEntity(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityRadius")]
	public static extern void EntityRadius(int entity, float xRadius, float yRadius);

	public static void EntityRadius(int entity, float xRadius)
	{
		 EntityRadius(entity, xRadius, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityBox")]
	public static extern void EntityBox(int entity, float x, float y, float z, float width, float height, float depth);

	[DllImport("xors3d.dll", EntryPoint = "xEntityType")]
	public static extern void EntityType(int entity, int typeID, bool recurse);

	public static void EntityType(int entity, int typeID)
	{
		 EntityType(entity, typeID, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityCollided")]
	public static extern int EntityCollided(int entity, int typeID);

	[DllImport("xors3d.dll", EntryPoint = "xCountCollisions")]
	public static extern int CountCollisions(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionX")]
	public static extern float CollisionX(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionY")]
	public static extern float CollisionY(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionZ")]
	public static extern float CollisionZ(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionNX")]
	public static extern float CollisionNX(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionNY")]
	public static extern float CollisionNY(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionNZ")]
	public static extern float CollisionNZ(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionTime")]
	public static extern float CollisionTime(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionEntity")]
	public static extern int CollisionEntity(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionSurface")]
	public static extern int CollisionSurface(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCollisionTriangle")]
	public static extern int CollisionTriangle(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityType")]
	public static extern int GetEntityType(int entity);


	// constants commands
	[DllImport("xors3d.dll", EntryPoint = "xRenderPostEffect")]
	public static extern void RenderPostEffect(int poly);

	[DllImport("xors3d.dll", EntryPoint = "xCreatePostEffectPoly")]
	public static extern int CreatePostEffectPoly(int camera, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xGetFunctionAddress")]
	public static extern int GetFunctionAddress_(StringBuilder name);
	public static int GetFunctionAddress(string name)
	{
		return GetFunctionAddress_(new StringBuilder(name));
	}

	// effects commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadFXFile")]
	public static extern int LoadFXFile_(StringBuilder path);
	public static int LoadFXFile(string path)
	{
		return LoadFXFile_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeEffect")]
	public static extern void FreeEffect(int effect);

	[DllImport("xors3d.dll", EntryPoint = "xSetEntityEffect")]
	public static extern void SetEntityEffect(int entity, int effect, int index);

	public static void SetEntityEffect(int entity, int effect)
	{
		 SetEntityEffect(entity, effect, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetSurfaceEffect")]
	public static extern void SetSurfaceEffect(int surface, int effect, int index);

	public static void SetSurfaceEffect(int surface, int effect)
	{
		 SetSurfaceEffect(surface, effect, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetBonesArrayName")]
	public static extern void SetBonesArrayName_(int entity, StringBuilder arrayName, int layer);
	public static void SetBonesArrayName(int entity, string arrayName, int layer)
	{
		SetBonesArrayName_(entity, new StringBuilder(arrayName), layer);
	}
	public static void SetBonesArrayName(int entity, string arrayName)
	{
		 SetBonesArrayName(entity, arrayName, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceBonesArrayName")]
	public static extern void SurfaceBonesArrayName_(int surface, StringBuilder arrayName, int layer);
	public static void SurfaceBonesArrayName(int surface, string arrayName, int layer)
	{
		SurfaceBonesArrayName_(surface, new StringBuilder(arrayName), layer);
	}
	public static void SurfaceBonesArrayName(int surface, string arrayName)
	{
		 SurfaceBonesArrayName(surface, arrayName, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectInt")]
	public static extern void SetEffectInt_(int entity, StringBuilder name, int value, int layer);
	public static void SetEffectInt(int entity, string name, int value, int layer)
	{
		SetEffectInt_(entity, new StringBuilder(name), value, layer);
	}
	public static void SetEffectInt(int entity, string name, int value)
	{
		 SetEffectInt(entity, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectInt")]
	public static extern void SurfaceEffectInt_(int surface, StringBuilder name, int value, int layer);
	public static void SurfaceEffectInt(int surface, string name, int value, int layer)
	{
		SurfaceEffectInt_(surface, new StringBuilder(name), value, layer);
	}
	public static void SurfaceEffectInt(int surface, string name, int value)
	{
		 SurfaceEffectInt(surface, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectFloat")]
	public static extern void SetEffectFloat_(int entity, StringBuilder name, float value, int layer);
	public static void SetEffectFloat(int entity, string name, float value, int layer)
	{
		SetEffectFloat_(entity, new StringBuilder(name), value, layer);
	}
	public static void SetEffectFloat(int entity, string name, float value)
	{
		 SetEffectFloat(entity, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectFloat")]
	public static extern void SurfaceEffectFloat_(int surface, StringBuilder name, float value, int layer);
	public static void SurfaceEffectFloat(int surface, string name, float value, int layer)
	{
		SurfaceEffectFloat_(surface, new StringBuilder(name), value, layer);
	}
	public static void SurfaceEffectFloat(int surface, string name, float value)
	{
		 SurfaceEffectFloat(surface, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectBool")]
	public static extern void SetEffectBool_(int entity, StringBuilder name, bool value, int layer);
	public static void SetEffectBool(int entity, string name, bool value, int layer)
	{
		SetEffectBool_(entity, new StringBuilder(name), value, layer);
	}
	public static void SetEffectBool(int entity, string name, bool value)
	{
		 SetEffectBool(entity, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectBool")]
	public static extern void SurfaceEffectBool_(int surface, StringBuilder name, bool value, int layer);
	public static void SurfaceEffectBool(int surface, string name, bool value, int layer)
	{
		SurfaceEffectBool_(surface, new StringBuilder(name), value, layer);
	}
	public static void SurfaceEffectBool(int surface, string name, bool value)
	{
		 SurfaceEffectBool(surface, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectVector")]
	public static extern void SetEffectVector_(int entity, StringBuilder name, float x, float y, float z, float w, int layer);
	public static void SetEffectVector(int entity, string name, float x, float y, float z, float w, int layer)
	{
		SetEffectVector_(entity, new StringBuilder(name), x, y, z, w, layer);
	}
	public static void SetEffectVector(int entity, string name, float x, float y, float z, float w)
	{
		 SetEffectVector(entity, name, x, y, z, w, -1);
	}
	public static void SetEffectVector(int entity, string name, float x, float y, float z)
	{
		 SetEffectVector(entity, name, x, y, z, 0.0f, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectVector")]
	public static extern void SurfaceEffectVector_(int surface, StringBuilder name, float x, float y, float z, float w, int layer);
	public static void SurfaceEffectVector(int surface, string name, float x, float y, float z, float w, int layer)
	{
		SurfaceEffectVector_(surface, new StringBuilder(name), x, y, z, w, layer);
	}
	public static void SurfaceEffectVector(int surface, string name, float x, float y, float z, float w)
	{
		 SurfaceEffectVector(surface, name, x, y, z, w, -1);
	}
	public static void SurfaceEffectVector(int surface, string name, float x, float y, float z)
	{
		 SurfaceEffectVector(surface, name, x, y, z, 0.0f, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectVectorArray")]
	public static extern void SetEffectVectorArray_(int entity, StringBuilder name, int value, int count, int layer);
	public static void SetEffectVectorArray(int entity, string name, int value, int count, int layer)
	{
		SetEffectVectorArray_(entity, new StringBuilder(name), value, count, layer);
	}
	public static void SetEffectVectorArray(int entity, string name, int value, int count)
	{
		 SetEffectVectorArray(entity, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectVectorArray")]
	public static extern void SurfaceEffectVectorArray_(int surface, StringBuilder name, int value, int count, int layer);
	public static void SurfaceEffectVectorArray(int surface, string name, int value, int count, int layer)
	{
		SurfaceEffectVectorArray_(surface, new StringBuilder(name), value, count, layer);
	}
	public static void SurfaceEffectVectorArray(int surface, string name, int value, int count)
	{
		 SurfaceEffectVectorArray(surface, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectMatrixArray")]
	public static extern void SurfaceEffectMatrixArray_(int surface, StringBuilder name, int value, int count, int layer);
	public static void SurfaceEffectMatrixArray(int surface, string name, int value, int count, int layer)
	{
		SurfaceEffectMatrixArray_(surface, new StringBuilder(name), value, count, layer);
	}
	public static void SurfaceEffectMatrixArray(int surface, string name, int value, int count)
	{
		 SurfaceEffectMatrixArray(surface, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectFloatArray")]
	public static extern void SurfaceEffectFloatArray_(int surface, StringBuilder name, int value, int count, int layer);
	public static void SurfaceEffectFloatArray(int surface, string name, int value, int count, int layer)
	{
		SurfaceEffectFloatArray_(surface, new StringBuilder(name), value, count, layer);
	}
	public static void SurfaceEffectFloatArray(int surface, string name, int value, int count)
	{
		 SurfaceEffectFloatArray(surface, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectIntArray")]
	public static extern void SurfaceEffectIntArray_(int surface, StringBuilder name, int value, int count, int layer);
	public static void SurfaceEffectIntArray(int surface, string name, int value, int count, int layer)
	{
		SurfaceEffectIntArray_(surface, new StringBuilder(name), value, count, layer);
	}
	public static void SurfaceEffectIntArray(int surface, string name, int value, int count)
	{
		 SurfaceEffectIntArray(surface, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectMatrixArray")]
	public static extern void SetEffectMatrixArray_(int entity, StringBuilder name, int value, int count, int layer);
	public static void SetEffectMatrixArray(int entity, string name, int value, int count, int layer)
	{
		SetEffectMatrixArray_(entity, new StringBuilder(name), value, count, layer);
	}
	public static void SetEffectMatrixArray(int entity, string name, int value, int count)
	{
		 SetEffectMatrixArray(entity, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectFloatArray")]
	public static extern void SetEffectFloatArray_(int entity, StringBuilder name, int value, int count, int layer);
	public static void SetEffectFloatArray(int entity, string name, int value, int count, int layer)
	{
		SetEffectFloatArray_(entity, new StringBuilder(name), value, count, layer);
	}
	public static void SetEffectFloatArray(int entity, string name, int value, int count)
	{
		 SetEffectFloatArray(entity, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectIntArray")]
	public static extern void SetEffectIntArray_(int entity, StringBuilder name, int value, int count, int layer);
	public static void SetEffectIntArray(int entity, string name, int value, int count, int layer)
	{
		SetEffectIntArray_(entity, new StringBuilder(name), value, count, layer);
	}
	public static void SetEffectIntArray(int entity, string name, int value, int count)
	{
		 SetEffectIntArray(entity, name, value, count, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateBufferVectors")]
	public static extern int CreateBufferVectors(int count);

	[DllImport("xors3d.dll", EntryPoint = "xBufferVectorsSetElement")]
	public static extern void BufferVectorsSetElement(int buffer, int number, float x, float y, float z, float w);

	[DllImport("xors3d.dll", EntryPoint = "xCreateBufferMatrix")]
	public static extern int CreateBufferMatrix(int count);

	[DllImport("xors3d.dll", EntryPoint = "xBufferMatrixSetElement")]
	public static extern void BufferMatrixSetElement(int buffer, int number, int matrix);

	[DllImport("xors3d.dll", EntryPoint = "xBufferMatrixGetElement")]
	public static extern int BufferMatrixGetElement(int buffer, int number);

	[DllImport("xors3d.dll", EntryPoint = "xCreateBufferFloats")]
	public static extern int CreateBufferFloats(int count);

	[DllImport("xors3d.dll", EntryPoint = "xBufferFloatsSetElement")]
	public static extern void BufferFloatsSetElement(int buffer, int number, float value);

	[DllImport("xors3d.dll", EntryPoint = "xBufferFloatsGetElement")]
	public static extern float BufferFloatsGetElement(int buffer, int number);

	[DllImport("xors3d.dll", EntryPoint = "xBufferDelete")]
	public static extern void BufferDelete(int buffer);

	[DllImport("xors3d.dll", EntryPoint = "xSetEffectMatrixWithElements")]
	public static extern void SetEffectMatrixWithElements_(int entity, StringBuilder name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44, int layer);
	public static void SetEffectMatrixWithElements(int entity, string name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44, int layer)
	{
		SetEffectMatrixWithElements_(entity, new StringBuilder(name), m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer);
	}
	public static void SetEffectMatrixWithElements(int entity, string name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44)
	{
		 SetEffectMatrixWithElements(entity, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectMatrix")]
	public static extern void SetEffectMatrix_(int entity, StringBuilder name, int matrix, int layer);
	public static void SetEffectMatrix(int entity, string name, int matrix, int layer)
	{
		SetEffectMatrix_(entity, new StringBuilder(name), matrix, layer);
	}
	public static void SetEffectMatrix(int entity, string name, int matrix)
	{
		 SetEffectMatrix(entity, name, matrix, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectMatrix")]
	public static extern void SurfaceEffectMatrix_(int surface, StringBuilder name, int matrix, int layer);
	public static void SurfaceEffectMatrix(int surface, string name, int matrix, int layer)
	{
		SurfaceEffectMatrix_(surface, new StringBuilder(name), matrix, layer);
	}
	public static void SurfaceEffectMatrix(int surface, string name, int matrix)
	{
		 SurfaceEffectMatrix(surface, name, matrix, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectMatrixWithElements")]
	public static extern void SurfaceEffectMatrixWithElements_(int surface, StringBuilder name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44, int layer);
	public static void SurfaceEffectMatrixWithElements(int surface, string name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44, int layer)
	{
		SurfaceEffectMatrixWithElements_(surface, new StringBuilder(name), m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer);
	}
	public static void SurfaceEffectMatrixWithElements(int surface, string name, float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44)
	{
		 SurfaceEffectMatrixWithElements(surface, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectEntityTexture")]
	public static extern void SetEffectEntityTexture_(int entity, StringBuilder name, int index, int layer);
	public static void SetEffectEntityTexture(int entity, string name, int index, int layer)
	{
		SetEffectEntityTexture_(entity, new StringBuilder(name), index, layer);
	}
	public static void SetEffectEntityTexture(int entity, string name, int index)
	{
		 SetEffectEntityTexture(entity, name, index, -1);
	}
	public static void SetEffectEntityTexture(int entity, string name)
	{
		 SetEffectEntityTexture(entity, name, 0, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectTexture")]
	public static extern void SetEffectTexture_(int entity, StringBuilder name, int texture, int frame, int layer, int isRecursive);
	public static void SetEffectTexture(int entity, string name, int texture, int frame, int layer, int isRecursive)
	{
		SetEffectTexture_(entity, new StringBuilder(name), texture, frame, layer, isRecursive);
	}
	public static void SetEffectTexture(int entity, string name, int texture, int frame, int layer)
	{
		 SetEffectTexture(entity, name, texture, frame, layer, 1);
	}
	public static void SetEffectTexture(int entity, string name, int texture, int frame)
	{
		 SetEffectTexture(entity, name, texture, frame, -1, 1);
	}
	public static void SetEffectTexture(int entity, string name, int texture)
	{
		 SetEffectTexture(entity, name, texture, 0, -1, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectTexture")]
	public static extern void SurfaceEffectTexture_(int surface, StringBuilder name, int texture, int frame, int layer);
	public static void SurfaceEffectTexture(int surface, string name, int texture, int frame, int layer)
	{
		SurfaceEffectTexture_(surface, new StringBuilder(name), texture, frame, layer);
	}
	public static void SurfaceEffectTexture(int surface, string name, int texture, int frame)
	{
		 SurfaceEffectTexture(surface, name, texture, frame, -1);
	}
	public static void SurfaceEffectTexture(int surface, string name, int texture)
	{
		 SurfaceEffectTexture(surface, name, texture, 0, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceEffectMatrixSemantic")]
	public static extern void SurfaceEffectMatrixSemantic_(int surface, StringBuilder name, int value, int layer);
	public static void SurfaceEffectMatrixSemantic(int surface, string name, int value, int layer)
	{
		SurfaceEffectMatrixSemantic_(surface, new StringBuilder(name), value, layer);
	}
	public static void SurfaceEffectMatrixSemantic(int surface, string name, int value)
	{
		 SurfaceEffectMatrixSemantic(surface, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectMatrixSemantic")]
	public static extern void SetEffectMatrixSemantic_(int entity, StringBuilder name, int value, int layer);
	public static void SetEffectMatrixSemantic(int entity, string name, int value, int layer)
	{
		SetEffectMatrixSemantic_(entity, new StringBuilder(name), value, layer);
	}
	public static void SetEffectMatrixSemantic(int entity, string name, int value)
	{
		 SetEffectMatrixSemantic(entity, name, value, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeleteSurfaceConstant")]
	public static extern void DeleteSurfaceConstant_(int surface, StringBuilder name, int layer);
	public static void DeleteSurfaceConstant(int surface, string name, int layer)
	{
		DeleteSurfaceConstant_(surface, new StringBuilder(name), layer);
	}
	public static void DeleteSurfaceConstant(int surface, string name)
	{
		 DeleteSurfaceConstant(surface, name, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeleteEffectConstant")]
	public static extern void DeleteEffectConstant_(int entity, StringBuilder name, int layer);
	public static void DeleteEffectConstant(int entity, string name, int layer)
	{
		DeleteEffectConstant_(entity, new StringBuilder(name), layer);
	}
	public static void DeleteEffectConstant(int entity, string name)
	{
		 DeleteEffectConstant(entity, name, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearSurfaceConstants")]
	public static extern void ClearSurfaceConstants(int surface, int layer);

	public static void ClearSurfaceConstants(int surface)
	{
		 ClearSurfaceConstants(surface, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearEffectConstants")]
	public static extern void ClearEffectConstants(int entity, int layer);

	public static void ClearEffectConstants(int entity)
	{
		 ClearEffectConstants(entity, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEffectTechnique")]
	public static extern void SetEffectTechnique_(int entity, StringBuilder name, int layer);
	public static void SetEffectTechnique(int entity, string name, int layer)
	{
		SetEffectTechnique_(entity, new StringBuilder(name), layer);
	}
	public static void SetEffectTechnique(int entity, string name)
	{
		 SetEffectTechnique(entity, name, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSurfaceTechnique")]
	public static extern void SurfaceTechnique_(int surface, StringBuilder name, int layer);
	public static void SurfaceTechnique(int surface, string name, int layer)
	{
		SurfaceTechnique_(surface, new StringBuilder(name), layer);
	}
	public static void SurfaceTechnique(int surface, string name)
	{
		 SurfaceTechnique(surface, name, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xValidateEffectTechnique")]
	public static extern int ValidateEffectTechnique_(int effect, StringBuilder name);
	public static int ValidateEffectTechnique(int effect, string name)
	{
		return ValidateEffectTechnique_(effect, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEntityShaderLayer")]
	public static extern void SetEntityShaderLayer(int entity, int layer);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityShaderLayer")]
	public static extern int GetEntityShaderLayer(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xSetSurfaceShaderLayer")]
	public static extern void SetSurfaceShaderLayer(int surface, int layer);

	[DllImport("xors3d.dll", EntryPoint = "xGetSurfaceShaderLayer")]
	public static extern int GetSurfaceShaderLayer(int surface);

	[DllImport("xors3d.dll", EntryPoint = "xSetFXInt")]
	public static extern void SetFXInt_(int effect, StringBuilder name, int value);
	public static void SetFXInt(int effect, string name, int value)
	{
		SetFXInt_(effect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXFloat")]
	public static extern void SetFXFloat_(int effect, StringBuilder name, float value);
	public static void SetFXFloat(int effect, string name, float value)
	{
		SetFXFloat_(effect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXBool")]
	public static extern void SetFXBool_(int effect, StringBuilder name, bool value);
	public static void SetFXBool(int effect, string name, bool value)
	{
		SetFXBool_(effect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXVector")]
	public static extern void SetFXVector_(int effect, StringBuilder name, float x, float y, float z, float w);
	public static void SetFXVector(int effect, string name, float x, float y, float z, float w)
	{
		SetFXVector_(effect, new StringBuilder(name), x, y, z, w);
	}
	public static void SetFXVector(int effect, string name, float x, float y, float z)
	{
		 SetFXVector(effect, name, x, y, z, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXVectorArray")]
	public static extern void SetFXVectorArray_(int effect, StringBuilder name, int value, int count);
	public static void SetFXVectorArray(int effect, string name, int value, int count)
	{
		SetFXVectorArray_(effect, new StringBuilder(name), value, count);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXMatrixArray")]
	public static extern void SetFXMatrixArray_(int effect, StringBuilder name, int value, int count);
	public static void SetFXMatrixArray(int effect, string name, int value, int count)
	{
		SetFXMatrixArray_(effect, new StringBuilder(name), value, count);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXFloatArray")]
	public static extern void SetFXFloatArray_(int effect, StringBuilder name, int value, int count);
	public static void SetFXFloatArray(int effect, string name, int value, int count)
	{
		SetFXFloatArray_(effect, new StringBuilder(name), value, count);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXIntArray")]
	public static extern void SetFXIntArray_(int effect, StringBuilder name, int value, int count);
	public static void SetFXIntArray(int effect, string name, int value, int count)
	{
		SetFXIntArray_(effect, new StringBuilder(name), value, count);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXEntityMatrix")]
	public static extern void SetFXEntityMatrix_(int effect, StringBuilder name, int matrix);
	public static void SetFXEntityMatrix(int effect, string name, int matrix)
	{
		SetFXEntityMatrix_(effect, new StringBuilder(name), matrix);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXTexture")]
	public static extern void SetFXTexture_(int effect, StringBuilder name, int texture, int frame);
	public static void SetFXTexture(int effect, string name, int texture, int frame)
	{
		SetFXTexture_(effect, new StringBuilder(name), texture, frame);
	}
	public static void SetFXTexture(int effect, string name, int texture)
	{
		 SetFXTexture(effect, name, texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFXMatrixSemantic")]
	public static extern void SetFXMatrixSemantic_(int effect, StringBuilder name, int value);
	public static void SetFXMatrixSemantic(int effect, string name, int value)
	{
		SetFXMatrixSemantic_(effect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeleteFXConstant")]
	public static extern void DeleteFXConstant_(int effect, StringBuilder name);
	public static void DeleteFXConstant(int effect, string name)
	{
		DeleteFXConstant_(effect, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearFXConstants")]
	public static extern void ClearFXConstants(int effect);

	[DllImport("xors3d.dll", EntryPoint = "xSetFXTechnique")]
	public static extern void SetFXTechnique_(int effect, StringBuilder name);
	public static void SetFXTechnique(int effect, string name)
	{
		SetFXTechnique_(effect, new StringBuilder(name));
	}

	// emitters commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateEmitter")]
	public static extern int CreateEmitter(int psystem, int parent);

	public static int CreateEmitter(int psystem)
	{
		return CreateEmitter(psystem, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEmitterEnable")]
	public static extern void EmitterEnable(int emitter, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterEnabled")]
	public static extern int EmitterEnabled(int emitter);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterGetPSystem")]
	public static extern int EmitterGetPSystem(int emitter);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterAddParticle")]
	public static extern int EmitterAddParticle(int emitter);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterFreeParticle")]
	public static extern void EmitterFreeParticle(int emitter, int particle);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterValidateParticle")]
	public static extern int EmitterValidateParticle(int emitter, int particle);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterCountParticles")]
	public static extern int EmitterCountParticles(int emitter);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterGetParticle")]
	public static extern int EmitterGetParticle(int emitter, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEmitterAlive")]
	public static extern int EmitterAlive(int emitter);


	// entity_animation commands
	[DllImport("xors3d.dll", EntryPoint = "xExtractAnimSeq")]
	public static extern int ExtractAnimSeq(int entity, int firstFrame, int lastFrame, int sequence);

	public static int ExtractAnimSeq(int entity, int firstFrame, int lastFrame)
	{
		return ExtractAnimSeq(entity, firstFrame, lastFrame, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadAnimSeq")]
	public static extern int LoadAnimSeq_(int entity, StringBuilder path);
	public static int LoadAnimSeq(int entity, string path)
	{
		return LoadAnimSeq_(entity, new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetAnimSpeed")]
	public static extern void SetAnimSpeed_(int entity, float speed, StringBuilder rootBone);
	public static void SetAnimSpeed(int entity, float speed, string rootBone)
	{
		SetAnimSpeed_(entity, speed, new StringBuilder(rootBone));
	}
	public static void SetAnimSpeed(int entity, float speed)
	{
		 SetAnimSpeed(entity, speed, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimSpeed")]
	public static extern float AnimSpeed_(int entity, StringBuilder rootBone);
	public static float AnimSpeed(int entity, string rootBone)
	{
		return AnimSpeed_(entity, new StringBuilder(rootBone));
	}
	public static float AnimSpeed(int entity)
	{
		return AnimSpeed(entity, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimating")]
	public static extern int Animating_(int entity, StringBuilder rootBone);
	public static int Animating(int entity, string rootBone)
	{
		return Animating_(entity, new StringBuilder(rootBone));
	}
	public static int Animating(int entity)
	{
		return Animating(entity, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimTime")]
	public static extern float AnimTime_(int entity, StringBuilder rootBone);
	public static float AnimTime(int entity, string rootBone)
	{
		return AnimTime_(entity, new StringBuilder(rootBone));
	}
	public static float AnimTime(int entity)
	{
		return AnimTime(entity, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimate")]
	public static extern void Animate_(int entity, int mode, float speed, int sequence, float translate, StringBuilder rootBone);
	public static void Animate(int entity, int mode, float speed, int sequence, float translate, string rootBone)
	{
		Animate_(entity, mode, speed, sequence, translate, new StringBuilder(rootBone));
	}
	public static void Animate(int entity, int mode, float speed, int sequence, float translate)
	{
		 Animate(entity, mode, speed, sequence, translate, "");
	}
	public static void Animate(int entity, int mode, float speed, int sequence)
	{
		 Animate(entity, mode, speed, sequence, 0.0f, "");
	}
	public static void Animate(int entity, int mode, float speed)
	{
		 Animate(entity, mode, speed, 0, 0.0f, "");
	}
	public static void Animate(int entity, int mode)
	{
		 Animate(entity, mode, 1.0f, 0, 0.0f, "");
	}
	public static void Animate(int entity)
	{
		 Animate(entity, 1, 1.0f, 0, 0.0f, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimSeq")]
	public static extern int AnimSeq_(int entity, StringBuilder rootBone);
	public static int AnimSeq(int entity, string rootBone)
	{
		return AnimSeq_(entity, new StringBuilder(rootBone));
	}
	public static int AnimSeq(int entity)
	{
		return AnimSeq(entity, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xAnimLength")]
	public static extern float AnimLength_(int entity, StringBuilder rootBone);
	public static float AnimLength(int entity, string rootBone)
	{
		return AnimLength_(entity, new StringBuilder(rootBone));
	}
	public static float AnimLength(int entity)
	{
		return AnimLength(entity, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetAnimTime")]
	public static extern void SetAnimTime_(int entity, float time, int sequence, StringBuilder rootBone);
	public static void SetAnimTime(int entity, float time, int sequence, string rootBone)
	{
		SetAnimTime_(entity, time, sequence, new StringBuilder(rootBone));
	}
	public static void SetAnimTime(int entity, float time, int sequence)
	{
		 SetAnimTime(entity, time, sequence, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetAnimFrame")]
	public static extern void SetAnimFrame_(int entity, float frame, int sequence, StringBuilder rootBone);
	public static void SetAnimFrame(int entity, float frame, int sequence, string rootBone)
	{
		SetAnimFrame_(entity, frame, sequence, new StringBuilder(rootBone));
	}
	public static void SetAnimFrame(int entity, float frame, int sequence)
	{
		 SetAnimFrame(entity, frame, sequence, "");
	}

	// entity_control commands
	[DllImport("xors3d.dll", EntryPoint = "xEntityAutoFade")]
	public static extern void EntityAutoFade(int entity, float nearRange, float farRange);

	[DllImport("xors3d.dll", EntryPoint = "xEntityOrder")]
	public static extern void EntityOrder(int entity, int order);

	[DllImport("xors3d.dll", EntryPoint = "xFreeEntity")]
	public static extern void FreeEntity(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xCopyEntity")]
	public static extern int CopyEntity(int entity, int parent, int cloneBuffers);

	public static int CopyEntity(int entity, int parent)
	{
		return CopyEntity(entity, parent, 0);
	}
	public static int CopyEntity(int entity)
	{
		return CopyEntity(entity, 0, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPaintEntity")]
	public static extern void PaintEntity(int entity, int brush);

	[DllImport("xors3d.dll", EntryPoint = "xEntityShininess")]
	public static extern void EntityShininess(int entity, float shininess);

	[DllImport("xors3d.dll", EntryPoint = "xEntityPickMode")]
	public static extern void EntityPickMode(int entity, int mode, bool obscurer, bool recursive);

	public static void EntityPickMode(int entity, int mode, bool obscurer)
	{
		 EntityPickMode(entity, mode, obscurer, true);
	}
	public static void EntityPickMode(int entity, int mode)
	{
		 EntityPickMode(entity, mode, true, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityTexture")]
	public static extern void EntityTexture(int entity, int texture, int frame, int index, int isRecursive);

	public static void EntityTexture(int entity, int texture, int frame, int index)
	{
		 EntityTexture(entity, texture, frame, index, 1);
	}
	public static void EntityTexture(int entity, int texture, int frame)
	{
		 EntityTexture(entity, texture, frame, 0, 1);
	}
	public static void EntityTexture(int entity, int texture)
	{
		 EntityTexture(entity, texture, 0, 0, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityFX")]
	public static extern void EntityFX(int entity, int fx);

	[DllImport("xors3d.dll", EntryPoint = "xGetParent")]
	public static extern int GetParent(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xSetFrustumSphere")]
	public static extern void SetFrustumSphere(int entity, float x, float y, float z, float radii);

	[DllImport("xors3d.dll", EntryPoint = "xCalculateFrustumVolume")]
	public static extern void CalculateFrustumVolume(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityParent")]
	public static extern void EntityParent(int entity, int parent, bool isGlobal);

	public static void EntityParent(int entity, int parent)
	{
		 EntityParent(entity, parent, true);
	}
	public static void EntityParent(int entity)
	{
		 EntityParent(entity, 0, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xShowEntity")]
	public static extern void ShowEntity(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xHideEntity")]
	public static extern void HideEntity(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xNameEntity")]
	public static extern void NameEntity_(int entity, StringBuilder name);
	public static void NameEntity(int entity, string name)
	{
		NameEntity_(entity, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEntityQuaternion")]
	public static extern void SetEntityQuaternion(int entity, int quaternion);

	[DllImport("xors3d.dll", EntryPoint = "xSetEntityMatrix")]
	public static extern void SetEntityMatrix(int entity, int matrix);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAlpha")]
	public static extern void EntityAlpha(int entity, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xEntityColor")]
	public static extern void EntityColor(int entity, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySpecularColor")]
	public static extern void EntitySpecularColor(int entity, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAmbientColor")]
	public static extern void EntityAmbientColor(int entity, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xEntityEmissiveColor")]
	public static extern void EntityEmissiveColor(int entity, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xEntityBlend")]
	public static extern void EntityBlend(int entity, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAlphaRef")]
	public static extern void EntityAlphaRef(int entity, int value);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAlphaFunc")]
	public static extern void EntityAlphaFunc(int entity, int value);

	[DllImport("xors3d.dll", EntryPoint = "xCreateInstance")]
	public static extern int CreateInstance(int entity, int parent);

	public static int CreateInstance(int entity)
	{
		return CreateInstance(entity, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreezeInstances")]
	public static extern void FreezeInstances(int entity, bool enable);

	public static void FreezeInstances(int entity)
	{
		 FreezeInstances(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xInstancingAvaliable")]
	public static extern int InstancingAvaliable();

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityWorld")]
	public static extern int GetEntityWorld(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xSetEntityWorld")]
	public static extern void SetEntityWorld(int entity, int world);


	// entity_movement commands
	[DllImport("xors3d.dll", EntryPoint = "xScaleEntity")]
	public static extern void ScaleEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void ScaleEntity(int entity, float x, float y, float z)
	{
		 ScaleEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPositionEntity")]
	public static extern void PositionEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void PositionEntity(int entity, float x, float y, float z)
	{
		 PositionEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMoveEntity")]
	public static extern void MoveEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void MoveEntity(int entity, float x, float y, float z)
	{
		 MoveEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTranslateEntity")]
	public static extern void TranslateEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void TranslateEntity(int entity, float x, float y, float z)
	{
		 TranslateEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRotateEntity")]
	public static extern void RotateEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void RotateEntity(int entity, float x, float y, float z)
	{
		 RotateEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTurnEntity")]
	public static extern void TurnEntity(int entity, float x, float y, float z, bool isGlobal);

	public static void TurnEntity(int entity, float x, float y, float z)
	{
		 TurnEntity(entity, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPointEntity")]
	public static extern void PointEntity(int entity1, int entity2, float roll);

	public static void PointEntity(int entity1, int entity2)
	{
		 PointEntity(entity1, entity2, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xAlignToVector")]
	public static extern void AlignToVector(int entity, float x, float y, float z, int axis, float factor);

	public static void AlignToVector(int entity, float x, float y, float z, int axis)
	{
		 AlignToVector(entity, x, y, z, axis, 1.0f);
	}

	// entity_state commands
	[DllImport("xors3d.dll", EntryPoint = "xEntityDistance")]
	public static extern float EntityDistance(int entity1, int entity2);

	[DllImport("xors3d.dll", EntryPoint = "xGetMatElement")]
	public static extern float GetMatElement(int entity, int row, int col);

	[DllImport("xors3d.dll", EntryPoint = "xEntityClass")]
	public static extern IntPtr EntityClass_(int entity);
	public static string EntityClass(int entity)
	{
		return Marshal.PtrToStringAnsi(EntityClass_(entity));
	}

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityBrush")]
	public static extern int GetEntityBrush(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityX")]
	public static extern float EntityX(int entity, bool isGlobal);

	public static float EntityX(int entity)
	{
		return EntityX(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityY")]
	public static extern float EntityY(int entity, bool isGlobal);

	public static float EntityY(int entity)
	{
		return EntityY(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityZ")]
	public static extern float EntityZ(int entity, bool isGlobal);

	public static float EntityZ(int entity)
	{
		return EntityZ(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityVisible")]
	public static extern int EntityVisible(int entity, int destination);

	[DllImport("xors3d.dll", EntryPoint = "xEntityScaleX")]
	public static extern float EntityScaleX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityScaleY")]
	public static extern float EntityScaleY(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityScaleZ")]
	public static extern float EntityScaleZ(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityRoll")]
	public static extern float EntityRoll(int entity, bool isGlobal);

	public static float EntityRoll(int entity)
	{
		return EntityRoll(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityYaw")]
	public static extern float EntityYaw(int entity, bool isGlobal);

	public static float EntityYaw(int entity)
	{
		return EntityYaw(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityPitch")]
	public static extern float EntityPitch(int entity, bool isGlobal);

	public static float EntityPitch(int entity)
	{
		return EntityPitch(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityName")]
	public static extern IntPtr EntityName_(int entity);
	public static string EntityName(int entity)
	{
		return Marshal.PtrToStringAnsi(EntityName_(entity));
	}

	[DllImport("xors3d.dll", EntryPoint = "xCountChildren")]
	public static extern int CountChildren(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetChild")]
	public static extern int GetChild(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityInView")]
	public static extern int EntityInView(int entity, int camera);

	[DllImport("xors3d.dll", EntryPoint = "xFindChild")]
	public static extern int FindChild_(int entity, StringBuilder name);
	public static int FindChild(int entity, string name)
	{
		return FindChild_(entity, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetEntityMatrix")]
	public static extern int GetEntityMatrix(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityAlpha")]
	public static extern float GetEntityAlpha(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetAlphaRef")]
	public static extern int GetAlphaRef(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetAlphaFunc")]
	public static extern int GetAlphaFunc(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityRed")]
	public static extern int EntityRed(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGreen")]
	public static extern int EntityGreen(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityBlue")]
	public static extern int EntityBlue(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityShininess")]
	public static extern float GetEntityShininess(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityBlend")]
	public static extern int GetEntityBlend(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetEntityFX")]
	public static extern int GetEntityFX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityHidden")]
	public static extern int EntityHidden(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitiesBBIntersect")]
	public static extern int EntitiesBBIntersect(int entity1, int entity2);


	// filesystems commands
	[DllImport("xors3d.dll", EntryPoint = "xMountPackFile")]
	public static extern int MountPackFile_(StringBuilder path, StringBuilder mountpoint, StringBuilder password);
	public static int MountPackFile(string path, string mountpoint, string password)
	{
		return MountPackFile_(new StringBuilder(path), new StringBuilder(mountpoint), new StringBuilder(password));
	}
	public static int MountPackFile(string path, string mountpoint)
	{
		return MountPackFile(path, mountpoint, "");
	}
	public static int MountPackFile(string path)
	{
		return MountPackFile(path, "", "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xUnmountPackFile")]
	public static extern void UnmountPackFile(int packfile);

	[DllImport("xors3d.dll", EntryPoint = "xOpenFile")]
	public static extern int OpenFile_(StringBuilder path);
	public static int OpenFile(string path)
	{
		return OpenFile_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xReadFile")]
	public static extern int ReadFile_(StringBuilder path);
	public static int ReadFile(string path)
	{
		return ReadFile_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xWriteFile")]
	public static extern int WriteFile_(StringBuilder path);
	public static int WriteFile(string path)
	{
		return WriteFile_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xCloseFile")]
	public static extern void CloseFile(int file);

	[DllImport("xors3d.dll", EntryPoint = "xFilePos")]
	public static extern int FilePos(int file);

	[DllImport("xors3d.dll", EntryPoint = "xSeekFile")]
	public static extern void SeekFile(int file, int offset);

	[DllImport("xors3d.dll", EntryPoint = "xFileType")]
	public static extern int FileType_(StringBuilder path);
	public static int FileType(string path)
	{
		return FileType_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFileSize")]
	public static extern int FileSize_(StringBuilder path);
	public static int FileSize(string path)
	{
		return FileSize_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFileCreationTime")]
	public static extern int FileCreationTime_(StringBuilder path);
	public static int FileCreationTime(string path)
	{
		return FileCreationTime_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFileCreationTimeStr")]
	public static extern IntPtr FileCreationTimeStr_(StringBuilder path);	public static string FileCreationTimeStr(string path)
	{
		return Marshal.PtrToStringAnsi(FileCreationTimeStr_(new StringBuilder(path)));
	}

	[DllImport("xors3d.dll", EntryPoint = "xFileModificationTime")]
	public static extern int FileModificationTime_(StringBuilder path);
	public static int FileModificationTime(string path)
	{
		return FileModificationTime_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFileModificationTimeStr")]
	public static extern IntPtr FileModificationTimeStr_(StringBuilder path);	public static string FileModificationTimeStr(string path)
	{
		return Marshal.PtrToStringAnsi(FileModificationTimeStr_(new StringBuilder(path)));
	}

	[DllImport("xors3d.dll", EntryPoint = "xReadDir")]
	public static extern int ReadDir_(StringBuilder path);
	public static int ReadDir(string path)
	{
		return ReadDir_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xCloseDir")]
	public static extern void CloseDir(int handle);

	[DllImport("xors3d.dll", EntryPoint = "xNextFile")]
	public static extern IntPtr NextFile_(int handle);
	public static string NextFile(int handle)
	{
		return Marshal.PtrToStringAnsi(NextFile_(handle));
	}

	[DllImport("xors3d.dll", EntryPoint = "xCurrentDir")]
	public static extern IntPtr CurrentDir_();
	public static string CurrentDir()
	{
		return Marshal.PtrToStringAnsi(CurrentDir_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xChangeDir")]
	public static extern void ChangeDir_(StringBuilder path);
	public static void ChangeDir(string path)
	{
		ChangeDir_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateDir")]
	public static extern int CreateDir_(StringBuilder path);
	public static int CreateDir(string path)
	{
		return CreateDir_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeleteDir")]
	public static extern int DeleteDir_(StringBuilder path);
	public static int DeleteDir(string path)
	{
		return DeleteDir_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xCopyFile")]
	public static extern int CopyFile_(StringBuilder pathSrc, StringBuilder pathDest);
	public static int CopyFile(string pathSrc, string pathDest)
	{
		return CopyFile_(new StringBuilder(pathSrc), new StringBuilder(pathDest));
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeleteFile")]
	public static extern int DeleteFile_(StringBuilder path);
	public static int DeleteFile(string path)
	{
		return DeleteFile_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xEof")]
	public static extern int Eof(int file);

	[DllImport("xors3d.dll", EntryPoint = "xReadByte")]
	public static extern int ReadByte(int file);

	[DllImport("xors3d.dll", EntryPoint = "xReadShort")]
	public static extern int ReadShort(int file);

	[DllImport("xors3d.dll", EntryPoint = "xReadInt")]
	public static extern int ReadInt(int file);

	[DllImport("xors3d.dll", EntryPoint = "xReadFloat")]
	public static extern float ReadFloat(int file);

	[DllImport("xors3d.dll", EntryPoint = "xReadString")]
	public static extern IntPtr ReadString_(int file);
	public static string ReadString(int file)
	{
		return Marshal.PtrToStringAnsi(ReadString_(file));
	}

	[DllImport("xors3d.dll", EntryPoint = "xReadLine")]
	public static extern IntPtr ReadLine_(int file, int ls_flag);
	public static string ReadLine(int file, int ls_flag)
	{
		return Marshal.PtrToStringAnsi(ReadLine_(file, ls_flag));
	}

	public static string ReadLine(int file)
	{
		return ReadLine(file, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xWriteByte")]
	public static extern void WriteByte(int file, int value);

	[DllImport("xors3d.dll", EntryPoint = "xWriteShort")]
	public static extern void WriteShort(int file, int value);

	[DllImport("xors3d.dll", EntryPoint = "xWriteInt")]
	public static extern void WriteInt(int file, int value);

	[DllImport("xors3d.dll", EntryPoint = "xWriteFloat")]
	public static extern void WriteFloat(int file, float value);

	[DllImport("xors3d.dll", EntryPoint = "xWriteString")]
	public static extern void WriteString_(int file, StringBuilder value);
	public static void WriteString(int file, string value)
	{
		WriteString_(file, new StringBuilder(value));
	}
	[DllImport("xors3d.dll", EntryPoint = "xWriteLine")]
	public static extern void WriteLine_(int file, StringBuilder value, int ls_flag);
	public static void WriteLine(int file, string value, int ls_flag)
	{
		WriteLine_(file, new StringBuilder(value), ls_flag);
	}
	public static void WriteLine(int file, string value)
	{
		 WriteLine(file, value, 0);
	}

	// fonts commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadFont")]
	public static extern int LoadFont_(StringBuilder name, int height, bool bold, bool italic, bool underline, StringBuilder fontface);
	public static int LoadFont(string name, int height, bool bold, bool italic, bool underline, string fontface)
	{
		return LoadFont_(new StringBuilder(name), height, bold, italic, underline, new StringBuilder(fontface));
	}
	public static int LoadFont(string name, int height, bool bold, bool italic, bool underline)
	{
		return LoadFont(name, height, bold, italic, underline, "");
	}
	public static int LoadFont(string name, int height, bool bold, bool italic)
	{
		return LoadFont(name, height, bold, italic, false, "");
	}
	public static int LoadFont(string name, int height, bool bold)
	{
		return LoadFont(name, height, bold, false, false, "");
	}
	public static int LoadFont(string name, int height)
	{
		return LoadFont(name, height, false, false, false, "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xText")]
	public static extern void Text_(float x, float y, StringBuilder textString, bool centerx, bool centery);
	public static void Text(float x, float y, string textString, bool centerx, bool centery)
	{
		Text_(x, y, new StringBuilder(textString), centerx, centery);
	}
	public static void Text(float x, float y, string textString, bool centerx)
	{
		 Text(x, y, textString, centerx, false);
	}
	public static void Text(float x, float y, string textString)
	{
		 Text(x, y, textString, false, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetFont")]
	public static extern void SetFont(int font);

	[DllImport("xors3d.dll", EntryPoint = "xFreeFont")]
	public static extern void FreeFont(int font);

	[DllImport("xors3d.dll", EntryPoint = "xFontWidth")]
	public static extern int FontWidth();

	[DllImport("xors3d.dll", EntryPoint = "xFontHeight")]
	public static extern int FontHeight();

	[DllImport("xors3d.dll", EntryPoint = "xStringWidth")]
	public static extern int StringWidth_(StringBuilder textString);
	public static int StringWidth(string textString)
	{
		return StringWidth_(new StringBuilder(textString));
	}
	[DllImport("xors3d.dll", EntryPoint = "xStringHeight")]
	public static extern int StringHeight_(StringBuilder textString);
	public static int StringHeight(string textString)
	{
		return StringHeight_(new StringBuilder(textString));
	}

	// graphics commands
	[DllImport("xors3d.dll", EntryPoint = "xWinMessage")]
	public static extern int WinMessage_(StringBuilder message);
	public static int WinMessage(string message)
	{
		return WinMessage_(new StringBuilder(message));
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetMaxPixelShaderVersion")]
	public static extern int GetMaxPixelShaderVersion();

	[DllImport("xors3d.dll", EntryPoint = "xLine")]
	public static extern void Line(int x1, int y1, int x2, int y2);

	[DllImport("xors3d.dll", EntryPoint = "xRect")]
	public static extern void Rect(int x, int y, int width, int height, bool solid);

	public static void Rect(int x, int y, int width, int height)
	{
		 Rect(x, y, width, height, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRectsOverlap")]
	public static extern int RectsOverlap(int x1, int y1, int width1, int height1, int x2, int y2, int width2, int height2);

	[DllImport("xors3d.dll", EntryPoint = "xViewport")]
	public static extern void Viewport(int x, int y, int width, int height);

	[DllImport("xors3d.dll", EntryPoint = "xOval")]
	public static extern void Oval(int x, int y, int width, int height, bool solid);

	public static void Oval(int x, int y, int width, int height)
	{
		 Oval(x, y, width, height, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xOrigin")]
	public static extern void Origin(int x, int y);

	[DllImport("xors3d.dll", EntryPoint = "xGetMaxVertexShaderVersion")]
	public static extern int GetMaxVertexShaderVersion();

	[DllImport("xors3d.dll", EntryPoint = "xGetMaxAntiAlias")]
	public static extern int GetMaxAntiAlias();

	[DllImport("xors3d.dll", EntryPoint = "xGetMaxTextureFiltering")]
	public static extern int GetMaxTextureFiltering();

	[DllImport("xors3d.dll", EntryPoint = "xSetAntiAliasType")]
	public static extern void SetAntiAliasType(int typeID);

	[DllImport("xors3d.dll", EntryPoint = "xAppTitle")]
	public static extern void AppTitle_(StringBuilder title);
	public static void AppTitle(string title)
	{
		AppTitle_(new StringBuilder(title));
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetWND")]
	public static extern void SetWND(int window);

	[DllImport("xors3d.dll", EntryPoint = "xSetRenderWindow")]
	public static extern void SetRenderWindow(int window);

	[DllImport("xors3d.dll", EntryPoint = "xSetTopWindow")]
	public static extern void SetTopWindow(int window);

	[DllImport("xors3d.dll", EntryPoint = "xDestroyRenderWindow")]
	public static extern void DestroyRenderWindow();

	[DllImport("xors3d.dll", EntryPoint = "xFlip")]
	public static extern void Flip();

	[DllImport("xors3d.dll", EntryPoint = "xBackBuffer")]
	public static extern int BackBuffer();

	[DllImport("xors3d.dll", EntryPoint = "xLockBuffer")]
	public static extern void LockBuffer(int buffer);

	public static void LockBuffer()
	{
		 LockBuffer(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xUnlockBuffer")]
	public static extern void UnlockBuffer(int buffer);

	public static void UnlockBuffer()
	{
		 UnlockBuffer(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xWritePixelFast")]
	public static extern void WritePixelFast(int x, int y, int argb, int buffer);

	public static void WritePixelFast(int x, int y, int argb)
	{
		 WritePixelFast(x, y, argb, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xReadPixelFast")]
	public static extern int ReadPixelFast(int x, int y, int buffer);

	public static int ReadPixelFast(int x, int y)
	{
		return ReadPixelFast(x, y, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetPixels")]
	public static extern int GetPixels(int buffer);

	public static int GetPixels()
	{
		return GetPixels(-1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSaveBuffer")]
	public static extern void SaveBuffer_(int buffer, StringBuilder path);
	public static void SaveBuffer(int buffer, string path)
	{
		SaveBuffer_(buffer, new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetCurrentBuffer")]
	public static extern int GetCurrentBuffer();

	[DllImport("xors3d.dll", EntryPoint = "xBufferWidth")]
	public static extern int BufferWidth(int buffer);

	public static int BufferWidth()
	{
		return BufferWidth(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xBufferHeight")]
	public static extern int BufferHeight(int buffer);

	public static int BufferHeight()
	{
		return BufferHeight(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCatchTimestamp")]
	public static extern int CatchTimestamp();

	[DllImport("xors3d.dll", EntryPoint = "xGetElapsedTime")]
	public static extern float GetElapsedTime(int timeStamp);

	[DllImport("xors3d.dll", EntryPoint = "xSetBuffer")]
	public static extern void SetBuffer(int buffer);

	public static void SetBuffer()
	{
		 SetBuffer(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetMRT")]
	public static extern void SetMRT(int buffer, int frame, int index);

	[DllImport("xors3d.dll", EntryPoint = "xUnSetMRT")]
	public static extern void UnSetMRT();

	[DllImport("xors3d.dll", EntryPoint = "xGetNumberRT")]
	public static extern int GetNumberRT();

	[DllImport("xors3d.dll", EntryPoint = "xTextureBuffer")]
	public static extern int TextureBuffer(int texture, int frame);

	public static int TextureBuffer(int texture)
	{
		return TextureBuffer(texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadBuffer")]
	public static extern void LoadBuffer_(int buffer, StringBuilder path);
	public static void LoadBuffer(int buffer, string path)
	{
		LoadBuffer_(buffer, new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xWritePixel")]
	public static extern void WritePixel(int x, int y, int argb, int buffer);

	public static void WritePixel(int x, int y, int argb)
	{
		 WritePixel(x, y, argb, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCopyPixel")]
	public static extern void CopyPixel(int sx, int sy, int sourceBuffer, int dx, int dy, int destinationBuffer);

	[DllImport("xors3d.dll", EntryPoint = "xCopyPixelFast")]
	public static extern void CopyPixelFast(int sx, int sy, int sourceBuffer, int dx, int dy, int destinationBuffer);

	[DllImport("xors3d.dll", EntryPoint = "xCopyRect")]
	public static extern void CopyRect(int sx, int sy, int sw, int sh, int dx, int dy, int sourceBuffer, int destinationBuffer);

	[DllImport("xors3d.dll", EntryPoint = "xGraphicsBuffer")]
	public static extern int GraphicsBuffer();

	[DllImport("xors3d.dll", EntryPoint = "xGetColor")]
	public static extern int GetColor(int x, int y);

	[DllImport("xors3d.dll", EntryPoint = "xReadPixel")]
	public static extern int ReadPixel(int x, int y, int buffer);

	public static int ReadPixel(int x, int y)
	{
		return ReadPixel(x, y, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGraphicsWidth")]
	public static extern int GraphicsWidth(bool isVirtual);

	public static int GraphicsWidth()
	{
		return GraphicsWidth(true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGraphicsHeight")]
	public static extern int GraphicsHeight(bool isVirtual);

	public static int GraphicsHeight()
	{
		return GraphicsHeight(true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGraphicsDepth")]
	public static extern int GraphicsDepth();

	[DllImport("xors3d.dll", EntryPoint = "xColorAlpha")]
	public static extern int ColorAlpha();

	[DllImport("xors3d.dll", EntryPoint = "xColorRed")]
	public static extern int ColorRed();

	[DllImport("xors3d.dll", EntryPoint = "xColorGreen")]
	public static extern int ColorGreen();

	[DllImport("xors3d.dll", EntryPoint = "xColorBlue")]
	public static extern int ColorBlue();

	[DllImport("xors3d.dll", EntryPoint = "xClsColor")]
	public static extern void ClsColor(int red, int green, int blue, int alpha);

	public static void ClsColor(int red, int green, int blue)
	{
		 ClsColor(red, green, blue, 255);
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearWorld")]
	public static extern void ClearWorld(bool entities, bool brushes, bool textures);

	public static void ClearWorld(bool entities, bool brushes)
	{
		 ClearWorld(entities, brushes, true);
	}
	public static void ClearWorld(bool entities)
	{
		 ClearWorld(entities, true, true);
	}
	public static void ClearWorld()
	{
		 ClearWorld(true, true, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xColor")]
	public static extern void Color(int red, int green, int blue, int alpha);

	public static void Color(int red, int green, int blue)
	{
		 Color(red, green, blue, 255);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCls")]
	public static extern void Cls();

	[DllImport("xors3d.dll", EntryPoint = "xUpdateWorld")]
	public static extern void UpdateWorld(float speed);

	public static void UpdateWorld()
	{
		 UpdateWorld(1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRenderEntity")]
	public static extern void RenderEntity(int camera, int entity, float tween);

	public static void RenderEntity(int camera, int entity)
	{
		 RenderEntity(camera, entity, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRenderWorld")]
	public static extern void RenderWorld(float tween, bool renderShadows);

	public static void RenderWorld(float tween)
	{
		 RenderWorld(tween, false);
	}
	public static void RenderWorld()
	{
		 RenderWorld(1.0f, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetAutoTB")]
	public static extern void SetAutoTB(bool flag);

	[DllImport("xors3d.dll", EntryPoint = "xMaxClipPlanes")]
	public static extern int MaxClipPlanes();

	[DllImport("xors3d.dll", EntryPoint = "xWireframe")]
	public static extern void Wireframe(int state);

	[DllImport("xors3d.dll", EntryPoint = "xDither")]
	public static extern void Dither(int state);

	[DllImport("xors3d.dll", EntryPoint = "xSetSkinningMethod")]
	public static extern void SetSkinningMethod(int skinMethod);

	[DllImport("xors3d.dll", EntryPoint = "xTrisRendered")]
	public static extern int TrisRendered();

	[DllImport("xors3d.dll", EntryPoint = "xDIPCounter")]
	public static extern int DIPCounter();

	[DllImport("xors3d.dll", EntryPoint = "xSurfRendered")]
	public static extern int SurfRendered();

	[DllImport("xors3d.dll", EntryPoint = "xEntityRendered")]
	public static extern int EntityRendered();

	[DllImport("xors3d.dll", EntryPoint = "xAmbientLight")]
	public static extern void AmbientLight(int red, int green, int blue, int world);

	public static void AmbientLight(int red, int green, int blue)
	{
		 AmbientLight(red, green, blue, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetFPS")]
	public static extern int GetFPS();

	[DllImport("xors3d.dll", EntryPoint = "xAntiAlias")]
	public static extern void AntiAlias(int state);

	[DllImport("xors3d.dll", EntryPoint = "xSetTextureFiltering")]
	public static extern void SetTextureFiltering(int filter);

	[DllImport("xors3d.dll", EntryPoint = "xStretchRect")]
	public static extern void StretchRect(int texture1, int x1, int y1, int width1, int height1, int texture2, int x2, int y2, int width2, int height2, int filter);

	[DllImport("xors3d.dll", EntryPoint = "xStretchBackBuffer")]
	public static extern void StretchBackBuffer(int texture, int x, int y, int width, int height, int filter);

	[DllImport("xors3d.dll", EntryPoint = "xGetDevice")]
	public static extern int GetDevice();

	[DllImport("xors3d.dll", EntryPoint = "xReleaseGraphics")]
	public static extern void ReleaseGraphics();

	[DllImport("xors3d.dll", EntryPoint = "xShowPointer")]
	public static extern void ShowPointer();

	[DllImport("xors3d.dll", EntryPoint = "xHidePointer")]
	public static extern void HidePointer();

	[DllImport("xors3d.dll", EntryPoint = "xCreateDSS")]
	public static extern void CreateDSS(int width, int height);

	[DllImport("xors3d.dll", EntryPoint = "xDeleteDSS")]
	public static extern void DeleteDSS();

	[DllImport("xors3d.dll", EntryPoint = "xGridColor")]
	public static extern void GridColor(int centerRed, int centerGreen, int centerBlue, int gridRed, int gridGreen, int gridBlue);

	[DllImport("xors3d.dll", EntryPoint = "xDrawGrid")]
	public static extern void DrawGrid(float x, float z, int gridSize, int range);

	[DllImport("xors3d.dll", EntryPoint = "xDrawBBox")]
	public static extern void DrawBBox(bool draw, bool zOn, int red, int green, int blue, int alpha);

	[DllImport("xors3d.dll", EntryPoint = "xGraphics3D")]
	public static extern void Graphics3D(int width, int height, int depth, int mode, int vsync);

	public static void Graphics3D(int width, int height, int depth, int mode)
	{
		 Graphics3D(width, height, depth, mode, 1);
	}
	public static void Graphics3D(int width, int height, int depth)
	{
		 Graphics3D(width, height, depth, 0, 1);
	}
	public static void Graphics3D(int width, int height)
	{
		 Graphics3D(width, height, 0, 0, 1);
	}
	public static void Graphics3D(int width)
	{
		 Graphics3D(width, 768, 0, 0, 1);
	}
	public static void Graphics3D()
	{
		 Graphics3D(1024, 768, 0, 0, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGraphicsAspectRatio")]
	public static extern void GraphicsAspectRatio(float aspectRatio);

	[DllImport("xors3d.dll", EntryPoint = "xGraphicsBorderColor")]
	public static extern void GraphicsBorderColor(int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xGetRenderWindow")]
	public static extern int GetRenderWindow();

	[DllImport("xors3d.dll", EntryPoint = "xKey")]
	public static extern void Key_(StringBuilder key);
	public static void Key(string key)
	{
		Key_(new StringBuilder(key));
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetEngineSetting")]
	public static extern void SetEngineSetting_(StringBuilder parameter, StringBuilder value);
	public static void SetEngineSetting(string parameter, string value)
	{
		SetEngineSetting_(new StringBuilder(parameter), new StringBuilder(value));
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetEngineSetting")]
	public static extern IntPtr GetEngineSetting_(StringBuilder parameter);	public static string GetEngineSetting(string parameter)
	{
		return Marshal.PtrToStringAnsi(GetEngineSetting_(new StringBuilder(parameter)));
	}

	[DllImport("xors3d.dll", EntryPoint = "xHWInstancingAvailable")]
	public static extern int HWInstancingAvailable();

	[DllImport("xors3d.dll", EntryPoint = "xShaderInstancingAvailable")]
	public static extern int ShaderInstancingAvailable();

	[DllImport("xors3d.dll", EntryPoint = "xSetShaderLayer")]
	public static extern void SetShaderLayer(int layer);

	[DllImport("xors3d.dll", EntryPoint = "xGetShaderLayer")]
	public static extern int GetShaderLayer();

	[DllImport("xors3d.dll", EntryPoint = "xDrawMovementGizmo")]
	public static extern void DrawMovementGizmo(float x, float y, float z, int selectMask);

	public static void DrawMovementGizmo(float x, float y, float z)
	{
		 DrawMovementGizmo(x, y, z, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDrawScaleGizmo")]
	public static extern void DrawScaleGizmo(float x, float y, float z, int selectMask, float sx, float sy, float sz);

	public static void DrawScaleGizmo(float x, float y, float z, int selectMask, float sx, float sy)
	{
		 DrawScaleGizmo(x, y, z, selectMask, sx, sy, 1.0f);
	}
	public static void DrawScaleGizmo(float x, float y, float z, int selectMask, float sx)
	{
		 DrawScaleGizmo(x, y, z, selectMask, sx, 1.0f, 1.0f);
	}
	public static void DrawScaleGizmo(float x, float y, float z, int selectMask)
	{
		 DrawScaleGizmo(x, y, z, selectMask, 1.0f, 1.0f, 1.0f);
	}
	public static void DrawScaleGizmo(float x, float y, float z)
	{
		 DrawScaleGizmo(x, y, z, 0, 1.0f, 1.0f, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDrawRotationGizmo")]
	public static extern void DrawRotationGizmo(float x, float y, float z, int selectMask, float pitch, float yaw, float roll);

	public static void DrawRotationGizmo(float x, float y, float z, int selectMask, float pitch, float yaw)
	{
		 DrawRotationGizmo(x, y, z, selectMask, pitch, yaw, 0.0f);
	}
	public static void DrawRotationGizmo(float x, float y, float z, int selectMask, float pitch)
	{
		 DrawRotationGizmo(x, y, z, selectMask, pitch, 0.0f, 0.0f);
	}
	public static void DrawRotationGizmo(float x, float y, float z, int selectMask)
	{
		 DrawRotationGizmo(x, y, z, selectMask, 0.0f, 0.0f, 0.0f);
	}
	public static void DrawRotationGizmo(float x, float y, float z)
	{
		 DrawRotationGizmo(x, y, z, 0, 0.0f, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCheckMovementGizmo")]
	public static extern int CheckMovementGizmo(float x, float y, float z, int camera, int mx, int my);

	[DllImport("xors3d.dll", EntryPoint = "xCheckScaleGizmo")]
	public static extern int CheckScaleGizmo(float x, float y, float z, int camera, int mx, int my);

	[DllImport("xors3d.dll", EntryPoint = "xCheckRotationGizmo")]
	public static extern int CheckRotationGizmo(float x, float y, float z, int camera, int mx, int my);

	[DllImport("xors3d.dll", EntryPoint = "xCaptureWorld")]
	public static extern void CaptureWorld();

	[DllImport("xors3d.dll", EntryPoint = "xCountGfxModes")]
	public static extern int CountGfxModes();

	[DllImport("xors3d.dll", EntryPoint = "xGfxModeWidth")]
	public static extern int GfxModeWidth(int mode);

	[DllImport("xors3d.dll", EntryPoint = "xGfxModeHeight")]
	public static extern int GfxModeHeight(int mode);

	[DllImport("xors3d.dll", EntryPoint = "xGfxModeDepth")]
	public static extern int GfxModeDepth(int mode);

	[DllImport("xors3d.dll", EntryPoint = "xGfxModeExists")]
	public static extern int GfxModeExists(int width, int height, int depth);

	[DllImport("xors3d.dll", EntryPoint = "xAppWindowFrame")]
	public static extern void AppWindowFrame(int state);

	[DllImport("xors3d.dll", EntryPoint = "xMillisecs")]
	public static extern int Millisecs();

	[DllImport("xors3d.dll", EntryPoint = "xDeltaTime")]
	public static extern int DeltaTime(bool fromInit);

	public static int DeltaTime()
	{
		return DeltaTime(false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeltaValue")]
	public static extern float DeltaValue(float value, int time);

	public static float DeltaValue(float value)
	{
		return DeltaValue(value, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xAddDeviceLostCallback")]
	public static extern void AddDeviceLostCallback(int func);

	[DllImport("xors3d.dll", EntryPoint = "xDeleteDeviceLostCallback")]
	public static extern void DeleteDeviceLostCallback(int func);

	[DllImport("xors3d.dll", EntryPoint = "xDeinit")]
	public static extern void Deinit();


	// images commands
	[DllImport("xors3d.dll", EntryPoint = "xImageColor")]
	public static extern void ImageColor(int image, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xImageAlpha")]
	public static extern void ImageAlpha(int image, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xImageBuffer")]
	public static extern int ImageBuffer(int image, int frame);

	public static int ImageBuffer(int image)
	{
		return ImageBuffer(image, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateImage")]
	public static extern int CreateImage(int width, int height, int frame);

	public static int CreateImage(int width, int height)
	{
		return CreateImage(width, height, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGrabImage")]
	public static extern void GrabImage(int image, int x, int y, int frame);

	public static void GrabImage(int image, int x, int y)
	{
		 GrabImage(image, x, y, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeImage")]
	public static extern void FreeImage(int image);

	[DllImport("xors3d.dll", EntryPoint = "xLoadImage")]
	public static extern int LoadImage_(StringBuilder path);
	public static int LoadImage(string path)
	{
		return LoadImage_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadAnimImage")]
	public static extern int LoadAnimImage_(StringBuilder path, int width, int height, int startFrame, int frames);
	public static int LoadAnimImage(string path, int width, int height, int startFrame, int frames)
	{
		return LoadAnimImage_(new StringBuilder(path), width, height, startFrame, frames);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSaveImage")]
	public static extern void SaveImage_(int image, StringBuilder path, int frame);
	public static void SaveImage(int image, string path, int frame)
	{
		SaveImage_(image, new StringBuilder(path), frame);
	}
	public static void SaveImage(int image, string path)
	{
		 SaveImage(image, path, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDrawImage")]
	public static extern void DrawImage(int image, float x, float y, int frame);

	public static void DrawImage(int image, float x, float y)
	{
		 DrawImage(image, x, y, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDrawImageRect")]
	public static extern void DrawImageRect(int image, float x, float y, float rectx, float recty, float rectWidth, float rectHeight, int frame);

	public static void DrawImageRect(int image, float x, float y, float rectx, float recty, float rectWidth, float rectHeight)
	{
		 DrawImageRect(image, x, y, rectx, recty, rectWidth, rectHeight, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xScaleImage")]
	public static extern void ScaleImage(int image, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xResizeImage")]
	public static extern void ResizeImage(int image, float width, float height);

	[DllImport("xors3d.dll", EntryPoint = "xRotateImage")]
	public static extern void RotateImage(int image, float angle);

	[DllImport("xors3d.dll", EntryPoint = "xImageAngle")]
	public static extern float ImageAngle(int image);

	[DllImport("xors3d.dll", EntryPoint = "xImageWidth")]
	public static extern int ImageWidth(int image);

	[DllImport("xors3d.dll", EntryPoint = "xImageHeight")]
	public static extern int ImageHeight(int image);

	[DllImport("xors3d.dll", EntryPoint = "xImagesCollide")]
	public static extern int ImagesCollide(int image1, int x1, int y1, int frame1, int image2, int x2, int y2, int frame2);

	[DllImport("xors3d.dll", EntryPoint = "xImageRectCollide")]
	public static extern int ImageRectCollide(int image, int x, int y, int frame, int rectx, int recty, int rectWidth, int rectHeight);

	[DllImport("xors3d.dll", EntryPoint = "xImageRectOverlap")]
	public static extern int ImageRectOverlap(int image, float x, float y, float rectx, float recty, float rectWidth, float rectHeight);

	[DllImport("xors3d.dll", EntryPoint = "xImageXHandle")]
	public static extern int ImageXHandle(int image);

	[DllImport("xors3d.dll", EntryPoint = "xImageYHandle")]
	public static extern int ImageYHandle(int image);

	[DllImport("xors3d.dll", EntryPoint = "xHandleImage")]
	public static extern void HandleImage(int image, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xMidHandle")]
	public static extern void MidHandle(int image);

	[DllImport("xors3d.dll", EntryPoint = "xAutoMidHandle")]
	public static extern void AutoMidHandle(int state);

	[DllImport("xors3d.dll", EntryPoint = "xTileImage")]
	public static extern void TileImage(int image, float x, float y, int frame);

	public static void TileImage(int image, float x, float y)
	{
		 TileImage(image, x, y, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xImagesOverlap")]
	public static extern int ImagesOverlap(int image1, float x1, float y1, int image2, float x2, float y2);

	[DllImport("xors3d.dll", EntryPoint = "xMaskImage")]
	public static extern void MaskImage(int image, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xCopyImage")]
	public static extern int CopyImage(int image);

	[DllImport("xors3d.dll", EntryPoint = "xDrawBlock")]
	public static extern void DrawBlock(int image, float x, float y, int frame);

	public static void DrawBlock(int image, float x, float y)
	{
		 DrawBlock(image, x, y, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDrawBlockRect")]
	public static extern void DrawBlockRect(int image, float x, float y, float rectx, float recty, float rectWidth, float rectHeight, int frame);

	public static void DrawBlockRect(int image, float x, float y, float rectx, float recty, float rectWidth, float rectHeight)
	{
		 DrawBlockRect(image, x, y, rectx, recty, rectWidth, rectHeight, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xImageActualWidth")]
	public static extern int ImageActualWidth(int image);

	[DllImport("xors3d.dll", EntryPoint = "xImageActualHeight")]
	public static extern int ImageActualHeight(int image);


	// inputs commands
	[DllImport("xors3d.dll", EntryPoint = "xFlushKeys")]
	public static extern void FlushKeys();

	[DllImport("xors3d.dll", EntryPoint = "xFlushMouse")]
	public static extern void FlushMouse();

	[DllImport("xors3d.dll", EntryPoint = "xKeyHit")]
	public static extern int KeyHit(int key);

	[DllImport("xors3d.dll", EntryPoint = "xKeyUp")]
	public static extern int KeyUp(int key);

	[DllImport("xors3d.dll", EntryPoint = "xWaitKey")]
	public static extern void WaitKey();

	[DllImport("xors3d.dll", EntryPoint = "xMouseHit")]
	public static extern int MouseHit(int key);

	[DllImport("xors3d.dll", EntryPoint = "xKeyDown")]
	public static extern int KeyDown(int key);

	[DllImport("xors3d.dll", EntryPoint = "xGetKey")]
	public static extern int GetKey();

	[DllImport("xors3d.dll", EntryPoint = "xMouseDown")]
	public static extern int MouseDown(int key);

	[DllImport("xors3d.dll", EntryPoint = "xMouseUp")]
	public static extern int MouseUp(int key);

	[DllImport("xors3d.dll", EntryPoint = "xGetMouse")]
	public static extern int GetMouse();

	[DllImport("xors3d.dll", EntryPoint = "xMouseX")]
	public static extern int MouseX();

	[DllImport("xors3d.dll", EntryPoint = "xMouseY")]
	public static extern int MouseY();

	[DllImport("xors3d.dll", EntryPoint = "xMouseZ")]
	public static extern int MouseZ();

	[DllImport("xors3d.dll", EntryPoint = "xMouseXSpeed")]
	public static extern int MouseXSpeed();

	[DllImport("xors3d.dll", EntryPoint = "xMouseYSpeed")]
	public static extern int MouseYSpeed();

	[DllImport("xors3d.dll", EntryPoint = "xMouseZSpeed")]
	public static extern int MouseZSpeed();

	[DllImport("xors3d.dll", EntryPoint = "xMouseSpeed")]
	public static extern int MouseSpeed();

	[DllImport("xors3d.dll", EntryPoint = "xMoveMouse")]
	public static extern void MoveMouse(int x, int y);


	// joysticks commands
	[DllImport("xors3d.dll", EntryPoint = "xJoyType")]
	public static extern int JoyType(int portID);

	public static int JoyType()
	{
		return JoyType(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyDown")]
	public static extern int JoyDown(int key, int portID);

	public static int JoyDown(int key)
	{
		return JoyDown(key, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyHit")]
	public static extern int JoyHit(int key, int portID);

	public static int JoyHit(int key)
	{
		return JoyHit(key, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetJoy")]
	public static extern int GetJoy(int portID);

	public static int GetJoy()
	{
		return GetJoy(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFlushJoy")]
	public static extern void FlushJoy();

	[DllImport("xors3d.dll", EntryPoint = "xWaitJoy")]
	public static extern int WaitJoy(int portID);

	public static int WaitJoy()
	{
		return WaitJoy(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyX")]
	public static extern float JoyX(int portID);

	public static float JoyX()
	{
		return JoyX(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyY")]
	public static extern float JoyY(int portID);

	public static float JoyY()
	{
		return JoyY(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyZ")]
	public static extern float JoyZ(int portID);

	public static float JoyZ()
	{
		return JoyZ(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyU")]
	public static extern float JoyU(int portID);

	public static float JoyU()
	{
		return JoyU(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyV")]
	public static extern float JoyV(int portID);

	public static float JoyV()
	{
		return JoyV(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyPitch")]
	public static extern float JoyPitch(int portID);

	public static float JoyPitch()
	{
		return JoyPitch(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyYaw")]
	public static extern float JoyYaw(int portID);

	public static float JoyYaw()
	{
		return JoyYaw(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyRoll")]
	public static extern float JoyRoll(int portID);

	public static float JoyRoll()
	{
		return JoyRoll(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyHat")]
	public static extern float JoyHat(int portID);

	public static float JoyHat()
	{
		return JoyHat(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyXDir")]
	public static extern int JoyXDir(int portID);

	public static int JoyXDir()
	{
		return JoyXDir(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyYDir")]
	public static extern int JoyYDir(int portID);

	public static int JoyYDir()
	{
		return JoyYDir(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyZDir")]
	public static extern int JoyZDir(int portID);

	public static int JoyZDir()
	{
		return JoyZDir(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyUDir")]
	public static extern int JoyUDir(int portID);

	public static int JoyUDir()
	{
		return JoyUDir(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJoyVDir")]
	public static extern int JoyVDir(int portID);

	public static int JoyVDir()
	{
		return JoyVDir(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCountJoys")]
	public static extern int CountJoys();


	// lights commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateLight")]
	public static extern int CreateLight(int typeID);

	public static int CreateLight()
	{
		return CreateLight(1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLightShadowEpsilons")]
	public static extern void LightShadowEpsilons(int light, float epsilon1, float epsilon2);

	[DllImport("xors3d.dll", EntryPoint = "xLightEnableShadows")]
	public static extern void LightEnableShadows(int light, int state);

	[DllImport("xors3d.dll", EntryPoint = "xLightShadowsEnabled")]
	public static extern int LightShadowsEnabled(int light);

	[DllImport("xors3d.dll", EntryPoint = "xLightRange")]
	public static extern void LightRange(int light, float range);

	[DllImport("xors3d.dll", EntryPoint = "xLightColor")]
	public static extern void LightColor(int light, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xLightConeAngles")]
	public static extern void LightConeAngles(int light, float inner, float outer);


	// logging commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateLog")]
	public static extern int CreateLog_(int target, int level, StringBuilder filename, StringBuilder cssfilename);
	public static int CreateLog(int target, int level, string filename, string cssfilename)
	{
		return CreateLog_(target, level, new StringBuilder(filename), new StringBuilder(cssfilename));
	}
	public static int CreateLog(int target, int level, string filename)
	{
		return CreateLog(target, level, filename, "");
	}
	public static int CreateLog(int target, int level)
	{
		return CreateLog(target, level, "xors_log.html", "");
	}
	public static int CreateLog(int target)
	{
		return CreateLog(target, 0, "xors_log.html", "");
	}
	public static int CreateLog()
	{
		return CreateLog(1, 0, "xors_log.html", "");
	}
	[DllImport("xors3d.dll", EntryPoint = "xCloseLog")]
	public static extern int CloseLog();

	[DllImport("xors3d.dll", EntryPoint = "xGetLogString")]
	public static extern IntPtr GetLogString_();
	public static string GetLogString()
	{
		return Marshal.PtrToStringAnsi(GetLogString_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xClearLogString")]
	public static extern void ClearLogString();

	[DllImport("xors3d.dll", EntryPoint = "xSetLogLevel")]
	public static extern void SetLogLevel(int level);

	public static void SetLogLevel()
	{
		 SetLogLevel(2);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetLogTarget")]
	public static extern void SetLogTarget(int target);

	public static void SetLogTarget()
	{
		 SetLogTarget(1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetLogLevel")]
	public static extern int GetLogLevel();

	[DllImport("xors3d.dll", EntryPoint = "xGetLogTarget")]
	public static extern int GetLogTarget();

	[DllImport("xors3d.dll", EntryPoint = "xLogInfo")]
	public static extern void LogInfo_(StringBuilder message, StringBuilder func, StringBuilder file, int line);
	public static void LogInfo(string message, string func, string file, int line)
	{
		LogInfo_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line);
	}
	public static void LogInfo(string message, string func, string file)
	{
		 LogInfo(message, func, file, -1);
	}
	public static void LogInfo(string message, string func)
	{
		 LogInfo(message, func, "", -1);
	}
	public static void LogInfo(string message)
	{
		 LogInfo(message, "", "", -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLogMessage")]
	public static extern void LogMessage_(StringBuilder message, StringBuilder func, StringBuilder file, int line);
	public static void LogMessage(string message, string func, string file, int line)
	{
		LogMessage_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line);
	}
	public static void LogMessage(string message, string func, string file)
	{
		 LogMessage(message, func, file, -1);
	}
	public static void LogMessage(string message, string func)
	{
		 LogMessage(message, func, "", -1);
	}
	public static void LogMessage(string message)
	{
		 LogMessage(message, "", "", -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLogWarning")]
	public static extern void LogWarning_(StringBuilder message, StringBuilder func, StringBuilder file, int line);
	public static void LogWarning(string message, string func, string file, int line)
	{
		LogWarning_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line);
	}
	public static void LogWarning(string message, string func, string file)
	{
		 LogWarning(message, func, file, -1);
	}
	public static void LogWarning(string message, string func)
	{
		 LogWarning(message, func, "", -1);
	}
	public static void LogWarning(string message)
	{
		 LogWarning(message, "", "", -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLogError")]
	public static extern void LogError_(StringBuilder message, StringBuilder func, StringBuilder file, int line);
	public static void LogError(string message, string func, string file, int line)
	{
		LogError_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line);
	}
	public static void LogError(string message, string func, string file)
	{
		 LogError(message, func, file, -1);
	}
	public static void LogError(string message, string func)
	{
		 LogError(message, func, "", -1);
	}
	public static void LogError(string message)
	{
		 LogError(message, "", "", -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLogFatal")]
	public static extern void LogFatal_(StringBuilder message, StringBuilder func, StringBuilder file, int line);
	public static void LogFatal(string message, string func, string file, int line)
	{
		LogFatal_(new StringBuilder(message), new StringBuilder(func), new StringBuilder(file), line);
	}
	public static void LogFatal(string message, string func, string file)
	{
		 LogFatal(message, func, file, -1);
	}
	public static void LogFatal(string message, string func)
	{
		 LogFatal(message, func, "", -1);
	}
	public static void LogFatal(string message)
	{
		 LogFatal(message, "", "", -1);
	}

	// meshes commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateMesh")]
	public static extern int CreateMesh(int parent);

	public static int CreateMesh()
	{
		return CreateMesh(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadMesh")]
	public static extern int LoadMesh_(StringBuilder path, int parent);
	public static int LoadMesh(string path, int parent)
	{
		return LoadMesh_(new StringBuilder(path), parent);
	}
	public static int LoadMesh(string path)
	{
		return LoadMesh(path, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadMeshWithChild")]
	public static extern int LoadMeshWithChild_(StringBuilder path, int parent);
	public static int LoadMeshWithChild(string path, int parent)
	{
		return LoadMeshWithChild_(new StringBuilder(path), parent);
	}
	public static int LoadMeshWithChild(string path)
	{
		return LoadMeshWithChild(path, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoadAnimMesh")]
	public static extern int LoadAnimMesh_(StringBuilder path, int parent);
	public static int LoadAnimMesh(string path, int parent)
	{
		return LoadAnimMesh_(new StringBuilder(path), parent);
	}
	public static int LoadAnimMesh(string path)
	{
		return LoadAnimMesh(path, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateCube")]
	public static extern int CreateCube(int parent);

	public static int CreateCube()
	{
		return CreateCube(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateSphere")]
	public static extern int CreateSphere(int segments, int parent);

	public static int CreateSphere(int segments)
	{
		return CreateSphere(segments, 0);
	}
	public static int CreateSphere()
	{
		return CreateSphere(16, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateCylinder")]
	public static extern int CreateCylinder(int segments, bool solid, int parent);

	public static int CreateCylinder(int segments, bool solid)
	{
		return CreateCylinder(segments, solid, 0);
	}
	public static int CreateCylinder(int segments)
	{
		return CreateCylinder(segments, true, 0);
	}
	public static int CreateCylinder()
	{
		return CreateCylinder(16, true, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateTorus")]
	public static extern int CreateTorus(int segments, float R, float r_tube, int parent);

	public static int CreateTorus(int segments, float R, float r_tube)
	{
		return CreateTorus(segments, R, r_tube, 0);
	}
	public static int CreateTorus(int segments, float R)
	{
		return CreateTorus(segments, R, 0.025f, 0);
	}
	public static int CreateTorus(int segments)
	{
		return CreateTorus(segments, 1.0f, 0.025f, 0);
	}
	public static int CreateTorus()
	{
		return CreateTorus(16, 1.0f, 0.025f, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateCone")]
	public static extern int CreateCone(int segments, bool solid, int parent);

	public static int CreateCone(int segments, bool solid)
	{
		return CreateCone(segments, solid, 0);
	}
	public static int CreateCone(int segments)
	{
		return CreateCone(segments, true, 0);
	}
	public static int CreateCone()
	{
		return CreateCone(16, true, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCopyMesh")]
	public static extern int CopyMesh(int entity, int parent);

	public static int CopyMesh(int entity)
	{
		return CopyMesh(entity, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xAddMesh")]
	public static extern void AddMesh(int source, int destination);

	[DllImport("xors3d.dll", EntryPoint = "xFlipMesh")]
	public static extern void FlipMesh(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xPaintMesh")]
	public static extern void PaintMesh(int entity, int brush);

	[DllImport("xors3d.dll", EntryPoint = "xFitMesh")]
	public static extern void FitMesh(int entity, float x, float y, float z, float width, float height, float depth, bool uniform);

	public static void FitMesh(int entity, float x, float y, float z, float width, float height, float depth)
	{
		 FitMesh(entity, x, y, z, width, height, depth, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMeshWidth")]
	public static extern float MeshWidth(int entity, bool recursive);

	public static float MeshWidth(int entity)
	{
		return MeshWidth(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMeshHeight")]
	public static extern float MeshHeight(int entity, bool recursive);

	public static float MeshHeight(int entity)
	{
		return MeshHeight(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMeshDepth")]
	public static extern float MeshDepth(int entity, bool recursive);

	public static float MeshDepth(int entity)
	{
		return MeshDepth(entity, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xScaleMesh")]
	public static extern void ScaleMesh(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xRotateMesh")]
	public static extern void RotateMesh(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xPositionMesh")]
	public static extern void PositionMesh(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xUpdateNormals")]
	public static extern void UpdateNormals(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xUpdateN")]
	public static extern void UpdateN(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xUpdateTB")]
	public static extern void UpdateTB(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xMeshesBBIntersect")]
	public static extern int MeshesBBIntersect(int entity1, int entity2);

	[DllImport("xors3d.dll", EntryPoint = "xMeshesIntersect")]
	public static extern int MeshesIntersect(int entity1, int entity2);

	[DllImport("xors3d.dll", EntryPoint = "xGetMeshVB")]
	public static extern int GetMeshVB(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetMeshIB")]
	public static extern int GetMeshIB(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetMeshVBSize")]
	public static extern int GetMeshVBSize(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetMeshIBSize")]
	public static extern int GetMeshIBSize(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xDeleteMeshVB")]
	public static extern void DeleteMeshVB(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xDeleteMeshIB")]
	public static extern void DeleteMeshIB(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xCountSurfaces")]
	public static extern int CountSurfaces(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xGetSurface")]
	public static extern int GetSurface(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCreatePivot")]
	public static extern int CreatePivot(int parent);

	public static int CreatePivot()
	{
		return CreatePivot(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFindSurface")]
	public static extern int FindSurface(int entity, int brush);

	[DllImport("xors3d.dll", EntryPoint = "xCreatePoly")]
	public static extern int CreatePoly(int sides, int parent);

	public static int CreatePoly(int sides)
	{
		return CreatePoly(sides, 0);
	}
	public static int CreatePoly()
	{
		return CreatePoly(0, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMeshSingleSurface")]
	public static extern void MeshSingleSurface(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xSaveMesh")]
	public static extern int SaveMesh_(int entity, StringBuilder path);
	public static int SaveMesh(int entity, string path)
	{
		return SaveMesh_(entity, new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xLightMesh")]
	public static extern void LightMesh(int entity, int red, int green, int blue, float range, float lightX, float lightY, float lightZ);

	public static void LightMesh(int entity, int red, int green, int blue, float range, float lightX, float lightY)
	{
		 LightMesh(entity, red, green, blue, range, lightX, lightY, 0.0f);
	}
	public static void LightMesh(int entity, int red, int green, int blue, float range, float lightX)
	{
		 LightMesh(entity, red, green, blue, range, lightX, 0.0f, 0.0f);
	}
	public static void LightMesh(int entity, int red, int green, int blue, float range)
	{
		 LightMesh(entity, red, green, blue, range, 0.0f, 0.0f, 0.0f);
	}
	public static void LightMesh(int entity, int red, int green, int blue)
	{
		 LightMesh(entity, red, green, blue, 0.0f, 0.0f, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMeshPrimitiveType")]
	public static extern void MeshPrimitiveType(int entity, int ptype);


	// particles commands
	[DllImport("xors3d.dll", EntryPoint = "xParticlePosition")]
	public static extern void ParticlePosition(int particle, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xParticleX")]
	public static extern float ParticleX(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleY")]
	public static extern float ParticleY(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleZ")]
	public static extern float ParticleZ(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleVeclocity")]
	public static extern void ParticleVeclocity(int particle, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xParticleVX")]
	public static extern float ParticleVX(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleVY")]
	public static extern float ParticleVY(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleVZ")]
	public static extern float ParticleVZ(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleRotation")]
	public static extern void ParticleRotation(int particle, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xParticlePitch")]
	public static extern float ParticlePitch(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleYaw")]
	public static extern float ParticleYaw(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleRoll")]
	public static extern float ParticleRoll(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleTorque")]
	public static extern void ParticleTorque(int particle, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xParticleTPitch")]
	public static extern float ParticleTPitch(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleTYaw")]
	public static extern float ParticleTYaw(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleTRoll")]
	public static extern float ParticleTRoll(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleSetAlpha")]
	public static extern void ParticleSetAlpha(int particle, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xParticleGetAlpha")]
	public static extern float ParticleGetAlpha(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleColor")]
	public static extern void ParticleColor(int particle, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xParticleRed")]
	public static extern float ParticleRed(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleGreen")]
	public static extern float ParticleGreen(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleBlue")]
	public static extern float ParticleBlue(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleScale")]
	public static extern void ParticleScale(int particle, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xParticleSX")]
	public static extern float ParticleSX(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleSY")]
	public static extern float ParticleSY(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleScaleSpeed")]
	public static extern void ParticleScaleSpeed(int particle, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xParticleScaleSpeedX")]
	public static extern float ParticleScaleSpeedX(int particle);

	[DllImport("xors3d.dll", EntryPoint = "xParticleScaleSpeedY")]
	public static extern float ParticleScaleSpeedY(int particle);


	// physics commands
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddDummyShape")]
	public static extern void EntityAddDummyShape(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddBoxShape")]
	public static extern void EntityAddBoxShape(int entity, float mass, float width, float height, float depth);

	public static void EntityAddBoxShape(int entity, float mass, float width, float height)
	{
		 EntityAddBoxShape(entity, mass, width, height, 0.0f);
	}
	public static void EntityAddBoxShape(int entity, float mass, float width)
	{
		 EntityAddBoxShape(entity, mass, width, 0.0f, 0.0f);
	}
	public static void EntityAddBoxShape(int entity, float mass)
	{
		 EntityAddBoxShape(entity, mass, 0.0f, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddSphereShape")]
	public static extern void EntityAddSphereShape(int entity, float mass, float radius);

	public static void EntityAddSphereShape(int entity, float mass)
	{
		 EntityAddSphereShape(entity, mass, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddCapsuleShape")]
	public static extern void EntityAddCapsuleShape(int entity, float mass, float radius, float height);

	public static void EntityAddCapsuleShape(int entity, float mass, float radius)
	{
		 EntityAddCapsuleShape(entity, mass, radius, 0.0f);
	}
	public static void EntityAddCapsuleShape(int entity, float mass)
	{
		 EntityAddCapsuleShape(entity, mass, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddConeShape")]
	public static extern void EntityAddConeShape(int entity, float mass, float radius, float height);

	public static void EntityAddConeShape(int entity, float mass, float radius)
	{
		 EntityAddConeShape(entity, mass, radius, 0.0f);
	}
	public static void EntityAddConeShape(int entity, float mass)
	{
		 EntityAddConeShape(entity, mass, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddCylinderShape")]
	public static extern void EntityAddCylinderShape(int entity, float mass, float width, float height, float depth);

	public static void EntityAddCylinderShape(int entity, float mass, float width, float height)
	{
		 EntityAddCylinderShape(entity, mass, width, height, 0.0f);
	}
	public static void EntityAddCylinderShape(int entity, float mass, float width)
	{
		 EntityAddCylinderShape(entity, mass, width, 0.0f, 0.0f);
	}
	public static void EntityAddCylinderShape(int entity, float mass)
	{
		 EntityAddCylinderShape(entity, mass, 0.0f, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityAddTriMeshShape")]
	public static extern void EntityAddTriMeshShape(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddTriMeshShapeProxy")]
	public static extern void EntityAddTriMeshShapeProxy(int entity, int proxy);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddConvexShape")]
	public static extern void EntityAddConvexShape(int entity, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddConvexShapeProxy")]
	public static extern void EntityAddConvexShapeProxy(int entity, int proxy, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddConcaveShape")]
	public static extern void EntityAddConcaveShape(int entity, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddConcaveShapeProxy")]
	public static extern void EntityAddConcaveShapeProxy(int entity, int proxy, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddTerrainShape")]
	public static extern void EntityAddTerrainShape(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAttachBody")]
	public static extern void EntityAttachBody(int entity, int body);

	[DllImport("xors3d.dll", EntryPoint = "xEntityDetachBody")]
	public static extern int EntityDetachBody(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xFreeEntityBody")]
	public static extern void FreeEntityBody(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddCompoundShape")]
	public static extern void EntityAddCompoundShape(int entity, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundAddBox")]
	public static extern int EntityCompoundAddBox(int entity, float width, float height, float depth);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundAddSphere")]
	public static extern int EntityCompoundAddSphere(int entity, float radius);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundAddCapsule")]
	public static extern int EntityCompoundAddCapsule(int entity, float radius, float height);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundAddCone")]
	public static extern int EntityCompoundAddCone(int entity, float radius, float height);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundAddCylinder")]
	public static extern int EntityCompoundAddCylinder(int entity, float radius, float height);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundCountChildren")]
	public static extern int EntityCompoundCountChildren(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundRemoveChild")]
	public static extern void EntityCompoundRemoveChild(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildSetPosition")]
	public static extern void EntityCompoundChildSetPosition(int entity, int index, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetX")]
	public static extern float EntityCompoundChildGetX(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetY")]
	public static extern float EntityCompoundChildGetY(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetZ")]
	public static extern float EntityCompoundChildGetZ(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildSetRotation")]
	public static extern void EntityCompoundChildSetRotation(int entity, int index, float pitch, float yaw, float roll);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetPitch")]
	public static extern float EntityCompoundChildGetPitch(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetYaw")]
	public static extern float EntityCompoundChildGetYaw(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCompoundChildGetRoll")]
	public static extern float EntityCompoundChildGetRoll(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xCreateHingeJoint")]
	public static extern int CreateHingeJoint(int firstBody, int secondBody, float pivotX, float pivotY, float pivotZ, float axisX, float axisY, float axisZ, bool isGlobal);

	public static int CreateHingeJoint(int firstBody, int secondBody, float pivotX, float pivotY, float pivotZ, float axisX, float axisY, float axisZ)
	{
		return CreateHingeJoint(firstBody, secondBody, pivotX, pivotY, pivotZ, axisX, axisY, axisZ, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateBallJoint")]
	public static extern int CreateBallJoint(int firstBody, int secondBody, float pivotX, float pivotY, float pivotZ, bool isGlobal);

	public static int CreateBallJoint(int firstBody, int secondBody, float pivotX, float pivotY, float pivotZ)
	{
		return CreateBallJoint(firstBody, secondBody, pivotX, pivotY, pivotZ, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateD6Joint")]
	public static extern int CreateD6Joint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z, bool isGlobal1, bool isGlobal2);

	public static int CreateD6Joint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z, bool isGlobal1)
	{
		return CreateD6Joint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1, false);
	}
	public static int CreateD6Joint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z)
	{
		return CreateD6Joint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, false, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateD6SpringJoint")]
	public static extern int CreateD6SpringJoint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z, bool isGlobal1, bool isGlobal2);

	public static int CreateD6SpringJoint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z, bool isGlobal1)
	{
		return CreateD6SpringJoint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1, false);
	}
	public static int CreateD6SpringJoint(int firstBody, int secondBody, float pivot1X, float pivot1Y, float pivot1Z, float pivot2X, float pivot2Y, float pivot2Z)
	{
		return CreateD6SpringJoint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, false, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointHingeGetAngle")]
	public static extern float JointHingeGetAngle(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetPitchAngle")]
	public static extern float JointD6GetPitchAngle(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetYawAngle")]
	public static extern float JointD6GetYawAngle(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetRollAngle")]
	public static extern float JointD6GetRollAngle(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngle")]
	public static extern float JointD6GetAngle(int joint, int axis);

	public static float JointD6GetAngle(int joint)
	{
		return JointD6GetAngle(joint, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointDisableCollisions")]
	public static extern void JointDisableCollisions(int joint, int state);

	[DllImport("xors3d.dll", EntryPoint = "xJointEnable")]
	public static extern void JointEnable(int joint, int state);

	[DllImport("xors3d.dll", EntryPoint = "xJointIsEnabled")]
	public static extern int JointIsEnabled(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointGetImpulse")]
	public static extern float JointGetImpulse(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xFreeJoint")]
	public static extern void FreeJoint(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointBallSetPivot")]
	public static extern void JointBallSetPivot(int joint, float x, float y, float z, bool isGlobal);

	public static void JointBallSetPivot(int joint, float x, float y, float z)
	{
		 JointBallSetPivot(joint, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointBallGetPivotX")]
	public static extern float JointBallGetPivotX(int joint, bool isGlobal);

	public static float JointBallGetPivotX(int joint)
	{
		return JointBallGetPivotX(joint, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointBallGetPivotY")]
	public static extern float JointBallGetPivotY(int joint, bool isGlobal);

	public static float JointBallGetPivotY(int joint)
	{
		return JointBallGetPivotY(joint, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointBallGetPivotZ")]
	public static extern float JointBallGetPivotZ(int joint, bool isGlobal);

	public static float JointBallGetPivotZ(int joint)
	{
		return JointBallGetPivotZ(joint, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetLimits")]
	public static extern void JointD6SetLimits(int joint, int axis, float lower, float upper);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetLowerLinearLimits")]
	public static extern void JointD6SetLowerLinearLimits(int joint, float lowerX, float lowerY, float lowerZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetUpperLinearLimits")]
	public static extern void JointD6SetUpperLinearLimits(int joint, float upperX, float upperY, float upperZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetLowerAngularLimits")]
	public static extern void JointD6SetLowerAngularLimits(int joint, float lowerX, float lowerY, float lowerZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetUpperAngularLimits")]
	public static extern void JointD6SetUpperAngularLimits(int joint, float upperX, float upperY, float upperZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetLinearLimits")]
	public static extern void JointD6SetLinearLimits(int joint, float lowerX, float lowerY, float lowerZ, float upperX, float upperY, float upperZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SetAngularLimits")]
	public static extern void JointD6SetAngularLimits(int joint, float lowerX, float lowerY, float lowerZ, float upperX, float upperY, float upperZ);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearLowerX")]
	public static extern float JointD6GetLinearLowerX(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearLowerY")]
	public static extern float JointD6GetLinearLowerY(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearLowerZ")]
	public static extern float JointD6GetLinearLowerZ(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearUpperX")]
	public static extern float JointD6GetLinearUpperX(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearUpperY")]
	public static extern float JointD6GetLinearUpperY(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetLinearUpperZ")]
	public static extern float JointD6GetLinearUpperZ(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularLowerX")]
	public static extern float JointD6GetAngularLowerX(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularLowerY")]
	public static extern float JointD6GetAngularLowerY(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularLowerZ")]
	public static extern float JointD6GetAngularLowerZ(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularUpperX")]
	public static extern float JointD6GetAngularUpperX(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularUpperY")]
	public static extern float JointD6GetAngularUpperY(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6GetAngularUpperZ")]
	public static extern float JointD6GetAngularUpperZ(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointD6SpringSetParam")]
	public static extern void JointD6SpringSetParam(int joint, int index, int enabled, float damping, float stiffness);

	public static void JointD6SpringSetParam(int joint, int index, int enabled, float damping)
	{
		 JointD6SpringSetParam(joint, index, enabled, damping, 1.0f);
	}
	public static void JointD6SpringSetParam(int joint, int index, int enabled)
	{
		 JointD6SpringSetParam(joint, index, enabled, 1.0f, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointHingeSetAxis")]
	public static extern void JointHingeSetAxis(int joint, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xJointHingeSetLimits")]
	public static extern void JointHingeSetLimits(int joint, float lowerLimit, float upperLimit, float softness, float biasFactor, float relaxationFactor);

	public static void JointHingeSetLimits(int joint, float lowerLimit, float upperLimit, float softness, float biasFactor)
	{
		 JointHingeSetLimits(joint, lowerLimit, upperLimit, softness, biasFactor, 1.0f);
	}
	public static void JointHingeSetLimits(int joint, float lowerLimit, float upperLimit, float softness)
	{
		 JointHingeSetLimits(joint, lowerLimit, upperLimit, softness, 0.3f, 1.0f);
	}
	public static void JointHingeSetLimits(int joint, float lowerLimit, float upperLimit)
	{
		 JointHingeSetLimits(joint, lowerLimit, upperLimit, 0.9f, 0.3f, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointHingeGetLowerLimit")]
	public static extern float JointHingeGetLowerLimit(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointHingeGetUpperLimit")]
	public static extern float JointHingeGetUpperLimit(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointEnableMotor")]
	public static extern void JointEnableMotor(int joint, int enabled, float targetVelocity, float maxForce, int index);

	public static void JointEnableMotor(int joint, int enabled, float targetVelocity, float maxForce)
	{
		 JointEnableMotor(joint, enabled, targetVelocity, maxForce, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xJointHingeSetMotorTarget")]
	public static extern void JointHingeSetMotorTarget(int joint, float targetAngle, float deltaTime);

	[DllImport("xors3d.dll", EntryPoint = "xJointGetEntityA")]
	public static extern int JointGetEntityA(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xJointGetEntityB")]
	public static extern int JointGetEntityB(int joint);

	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyCentralForce")]
	public static extern void EntityApplyCentralForce(int entity, float x, float y, float z, bool isGlobal);

	public static void EntityApplyCentralForce(int entity, float x, float y, float z)
	{
		 EntityApplyCentralForce(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyCentralImpulse")]
	public static extern void EntityApplyCentralImpulse(int entity, float x, float y, float z, bool isGlobal);

	public static void EntityApplyCentralImpulse(int entity, float x, float y, float z)
	{
		 EntityApplyCentralImpulse(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyTorque")]
	public static extern void EntityApplyTorque(int entity, float x, float y, float z, bool isGlobal);

	public static void EntityApplyTorque(int entity, float x, float y, float z)
	{
		 EntityApplyTorque(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyTorqueImpulse")]
	public static extern void EntityApplyTorqueImpulse(int entity, float x, float y, float z, bool isGlobal);

	public static void EntityApplyTorqueImpulse(int entity, float x, float y, float z)
	{
		 EntityApplyTorqueImpulse(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyForce")]
	public static extern void EntityApplyForce(int entity, float x, float y, float z, float pointx, float pointy, float pointz, bool isGlobal, bool globalPoint);

	public static void EntityApplyForce(int entity, float x, float y, float z, float pointx, float pointy, float pointz, bool isGlobal)
	{
		 EntityApplyForce(entity, x, y, z, pointx, pointy, pointz, isGlobal, true);
	}
	public static void EntityApplyForce(int entity, float x, float y, float z, float pointx, float pointy, float pointz)
	{
		 EntityApplyForce(entity, x, y, z, pointx, pointy, pointz, true, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityApplyImpulse")]
	public static extern void EntityApplyImpulse(int entity, float x, float y, float z, float pointx, float pointy, float pointz, bool isGlobal, bool globalPoint);

	public static void EntityApplyImpulse(int entity, float x, float y, float z, float pointx, float pointy, float pointz, bool isGlobal)
	{
		 EntityApplyImpulse(entity, x, y, z, pointx, pointy, pointz, isGlobal, true);
	}
	public static void EntityApplyImpulse(int entity, float x, float y, float z, float pointx, float pointy, float pointz)
	{
		 EntityApplyImpulse(entity, x, y, z, pointx, pointy, pointz, true, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityReleaseForces")]
	public static extern void EntityReleaseForces(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xWorldSetGravity")]
	public static extern void WorldSetGravity(float x, float y, float z, int world);

	public static void WorldSetGravity(float x, float y, float z)
	{
		 WorldSetGravity(x, y, z, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xWorldGetGravityX")]
	public static extern float WorldGetGravityX(int world);

	public static float WorldGetGravityX()
	{
		return WorldGetGravityX(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xWorldGetGravityY")]
	public static extern float WorldGetGravityY(int world);

	public static float WorldGetGravityY()
	{
		return WorldGetGravityY(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xWorldGetGravityZ")]
	public static extern float WorldGetGravityZ(int world);

	public static float WorldGetGravityZ()
	{
		return WorldGetGravityZ(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntitySetGravity")]
	public static extern void EntitySetGravity(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetGravityX")]
	public static extern float EntityGetGravityX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetGravityY")]
	public static extern float EntityGetGravityY(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetGravityZ")]
	public static extern float EntityGetGravityZ(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetLinearVelocity")]
	public static extern void EntitySetLinearVelocity(int entity, float x, float y, float z, bool isGlobal);

	public static void EntitySetLinearVelocity(int entity, float x, float y, float z)
	{
		 EntitySetLinearVelocity(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearVelocityX")]
	public static extern float EntityGetLinearVelocityX(int entity, bool isGlobal);

	public static float EntityGetLinearVelocityX(int entity)
	{
		return EntityGetLinearVelocityX(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearVelocityY")]
	public static extern float EntityGetLinearVelocityY(int entity, bool isGlobal);

	public static float EntityGetLinearVelocityY(int entity)
	{
		return EntityGetLinearVelocityY(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearVelocityZ")]
	public static extern float EntityGetLinearVelocityZ(int entity, bool isGlobal);

	public static float EntityGetLinearVelocityZ(int entity)
	{
		return EntityGetLinearVelocityZ(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntitySetAngularVelocity")]
	public static extern void EntitySetAngularVelocity(int entity, float x, float y, float z, bool isGlobal);

	public static void EntitySetAngularVelocity(int entity, float x, float y, float z)
	{
		 EntitySetAngularVelocity(entity, x, y, z, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularVelocityX")]
	public static extern float EntityGetAngularVelocityX(int entity, bool isGlobal);

	public static float EntityGetAngularVelocityX(int entity)
	{
		return EntityGetAngularVelocityX(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularVelocityY")]
	public static extern float EntityGetAngularVelocityY(int entity, bool isGlobal);

	public static float EntityGetAngularVelocityY(int entity)
	{
		return EntityGetAngularVelocityY(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularVelocityZ")]
	public static extern float EntityGetAngularVelocityZ(int entity, bool isGlobal);

	public static float EntityGetAngularVelocityZ(int entity)
	{
		return EntityGetAngularVelocityZ(entity, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntitySetDamping")]
	public static extern void EntitySetDamping(int entity, float linear, float angular);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearDamping")]
	public static extern float EntityGetLinearDamping(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularDamping")]
	public static extern float EntityGetAngularDamping(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetFriction")]
	public static extern void EntitySetFriction(int entity, float friction);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetFriction")]
	public static extern float EntityGetFriction(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetAnisotropicFriction")]
	public static extern void EntitySetAnisotropicFriction(int entity, float fx, float fy, float fz);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAnisotropicFrictionX")]
	public static extern float EntityGetAnisotropicFrictionX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAnisotropicFrictionY")]
	public static extern float EntityGetAnisotropicFrictionY(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAnisotropicFrictionZ")]
	public static extern float EntityGetAnisotropicFrictionZ(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetLinearFactor")]
	public static extern void EntitySetLinearFactor(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearFactorX")]
	public static extern float EntityGetLinearFactorX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearFactorY")]
	public static extern float EntityGetLinearFactorY(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearFactorZ")]
	public static extern float EntityGetLinearFactorZ(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetAngularFactor")]
	public static extern void EntitySetAngularFactor(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularFactorX")]
	public static extern float EntityGetAngularFactorX(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularFactorY")]
	public static extern float EntityGetAngularFactorY(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularFactorZ")]
	public static extern float EntityGetAngularFactorZ(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetRestitution")]
	public static extern void EntitySetRestitution(int entity, float restitution);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetRestitution")]
	public static extern float EntityGetRestitution(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetMass")]
	public static extern void EntitySetMass(int entity, float mass);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetMass")]
	public static extern float EntityGetMass(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCountContacts")]
	public static extern int EntityCountContacts(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactX")]
	public static extern float EntityGetContactX(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactY")]
	public static extern float EntityGetContactY(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactZ")]
	public static extern float EntityGetContactZ(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactNX")]
	public static extern float EntityGetContactNX(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactNY")]
	public static extern float EntityGetContactNY(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactNZ")]
	public static extern float EntityGetContactNZ(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactDistance")]
	public static extern float EntityGetContactDistance(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContact")]
	public static extern int EntityGetContact(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactImpulse")]
	public static extern float EntityGetContactImpulse(int entity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetCollisionGroup")]
	public static extern void EntitySetCollisionGroup(int entity, int group);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetCollisionGroup")]
	public static extern int EntityGetCollisionGroup(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetContactGroup")]
	public static extern void EntitySetContactGroup(int entity, int group);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetContactGroup")]
	public static extern int EntityGetContactGroup(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetRaycastGroup")]
	public static extern void EntitySetRaycastGroup(int entity, int group);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetRaycastGroup")]
	public static extern int EntityGetRaycastGroup(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsSetCollisionFilter")]
	public static extern void PhysicsSetCollisionFilter(int group0, int group1, int state);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetCollisionFilter")]
	public static extern int PhysicsGetCollisionFilter(int group0, int group1);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsSetContactFilter")]
	public static extern void PhysicsSetContactFilter(int group0, int group1, int state);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetContactFilter")]
	public static extern int PhysicsGetContactFilter(int group0, int group1);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsSetRaycastFilter")]
	public static extern void PhysicsSetRaycastFilter(int rayGroup, int bodyGroup, int state);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetRaycastFilter")]
	public static extern int PhysicsGetRaycastFilter(int rayGroup, int bodyGroup);

	[DllImport("xors3d.dll", EntryPoint = "xEntityIsSleeping")]
	public static extern int EntityIsSleeping(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityDisableSleeping")]
	public static extern void EntityDisableSleeping(int entity, int state);

	public static void EntityDisableSleeping(int entity)
	{
		 EntityDisableSleeping(entity, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityWakeUp")]
	public static extern void EntityWakeUp(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySleep")]
	public static extern void EntitySleep(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntitySetSleepingThresholds")]
	public static extern void EntitySetSleepingThresholds(int entity, float linearThreshold, float angularThreshold);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetLinearSleepingThreshold")]
	public static extern float EntityGetLinearSleepingThreshold(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityGetAngularSleepingThreshold")]
	public static extern float EntityGetAngularSleepingThreshold(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsRayCast")]
	public static extern void PhysicsRayCast(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int rcType, int rayGroup);

	public static void PhysicsRayCast(float fromX, float fromY, float fromZ, float toX, float toY, float toZ, int rcType)
	{
		 PhysicsRayCast(fromX, fromY, fromZ, toX, toY, toZ, rcType, 0);
	}
	public static void PhysicsRayCast(float fromX, float fromY, float fromZ, float toX, float toY, float toZ)
	{
		 PhysicsRayCast(fromX, fromY, fromZ, toX, toY, toZ, 0, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitEntity")]
	public static extern int PhysicsGetHitEntity(int index);

	public static int PhysicsGetHitEntity()
	{
		return PhysicsGetHitEntity(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitPointX")]
	public static extern float PhysicsGetHitPointX(int index);

	public static float PhysicsGetHitPointX()
	{
		return PhysicsGetHitPointX(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitPointY")]
	public static extern float PhysicsGetHitPointY(int index);

	public static float PhysicsGetHitPointY()
	{
		return PhysicsGetHitPointY(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitPointZ")]
	public static extern float PhysicsGetHitPointZ(int index);

	public static float PhysicsGetHitPointZ()
	{
		return PhysicsGetHitPointZ(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitNormalX")]
	public static extern float PhysicsGetHitNormalX(int index);

	public static float PhysicsGetHitNormalX()
	{
		return PhysicsGetHitNormalX(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitNormalY")]
	public static extern float PhysicsGetHitNormalY(int index);

	public static float PhysicsGetHitNormalY()
	{
		return PhysicsGetHitNormalY(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitNormalZ")]
	public static extern float PhysicsGetHitNormalZ(int index);

	public static float PhysicsGetHitNormalZ()
	{
		return PhysicsGetHitNormalZ(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsGetHitDistance")]
	public static extern float PhysicsGetHitDistance(int index);

	public static float PhysicsGetHitDistance()
	{
		return PhysicsGetHitDistance(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPhysicsCountHits")]
	public static extern int PhysicsCountHits();

	[DllImport("xors3d.dll", EntryPoint = "xEntityBodyLocalPosition")]
	public static extern void EntityBodyLocalPosition(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityBodyLocalRotation")]
	public static extern void EntityBodyLocalRotation(int entity, float pitch, float yaw, float roll);

	[DllImport("xors3d.dll", EntryPoint = "xEntityBodyLocalScale")]
	public static extern void EntityBodyLocalScale(int entity, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xWorldSetFrequency")]
	public static extern void WorldSetFrequency(float frequency, int world);

	public static void WorldSetFrequency(float frequency)
	{
		 WorldSetFrequency(frequency, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityMakeKinematic")]
	public static extern void EntityMakeKinematic(int entity, int state);

	[DllImport("xors3d.dll", EntryPoint = "xEntityIsKinematic")]
	public static extern int EntityIsKinematic(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xPhysicsDebugRender")]
	public static extern void PhysicsDebugRender(int state);

	[DllImport("xors3d.dll", EntryPoint = "xEntityDisableSimulation")]
	public static extern void EntityDisableSimulation(int entity, int state);

	[DllImport("xors3d.dll", EntryPoint = "xEntityHasBody")]
	public static extern int EntityHasBody(int entity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCreateVehicle")]
	public static extern void EntityCreateVehicle(int chassisEntity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityFreeVehicle")]
	public static extern void EntityFreeVehicle(int chassisEntity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCountWheels")]
	public static extern int EntityCountWheels(int chassisEntity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityAddWheel")]
	public static extern int EntityAddWheel(int chassisEntity, int wheelEntity);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetRadius")]
	public static extern void EntityWheelSetRadius(int chassisEntity, int index, float radius);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetAxle")]
	public static extern void EntityWheelSetAxle(int chassisEntity, int index, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetRay")]
	public static extern void EntityWheelSetRay(int chassisEntity, int index, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetSuspensionLength")]
	public static extern void EntityWheelSetSuspensionLength(int chassisEntity, int index, float length);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetBrake")]
	public static extern void EntityWheelSetBrake(int chassisEntity, int index, float brake);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetMaxSuspensionForce")]
	public static extern void EntityWheelSetMaxSuspensionForce(int chassisEntity, int index, float force);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetMaxSuspensionTravel")]
	public static extern void EntityWheelSetMaxSuspensionTravel(int chassisEntity, int index, float travel);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetSuspensionStiffness")]
	public static extern void EntityWheelSetSuspensionStiffness(int chassisEntity, int index, float stiffness);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetSuspensionDamping")]
	public static extern void EntityWheelSetSuspensionDamping(int chassisEntity, int index, float damping);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetSuspensionCompression")]
	public static extern void EntityWheelSetSuspensionCompression(int chassisEntity, int index, float compression);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetFriction")]
	public static extern void EntityWheelSetFriction(int chassisEntity, int index, float friction);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetEngineForce")]
	public static extern void EntityWheelSetEngineForce(int chassisEntity, int index, float force);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetRollInfluence")]
	public static extern void EntityWheelSetRollInfluence(int chassisEntity, int index, float roll);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetRotation")]
	public static extern void EntityWheelSetRotation(int chassisEntity, int index, float rotation);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetSteering")]
	public static extern void EntityWheelSetSteering(int chassisEntity, int index, float steering);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelSetConnectionPoint")]
	public static extern void EntityWheelSetConnectionPoint(int chassisEntity, int index, float x, float y, float z, bool isGlobal);

	public static void EntityWheelSetConnectionPoint(int chassisEntity, int index, float x, float y, float z)
	{
		 EntityWheelSetConnectionPoint(chassisEntity, index, x, y, z, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelGetSuspensionLength")]
	public static extern float EntityWheelGetSuspensionLength(int chassisEntity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelGetPitch")]
	public static extern float EntityWheelGetPitch(int chassisEntity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelGetYaw")]
	public static extern float EntityWheelGetYaw(int chassisEntity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelGetRoll")]
	public static extern float EntityWheelGetRoll(int chassisEntity, int index);

	[DllImport("xors3d.dll", EntryPoint = "xEntityWheelGetContactEntity")]
	public static extern int EntityWheelGetContactEntity(int chassisEntity, int index);


	// posteffects commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadPostEffect")]
	public static extern int LoadPostEffect_(StringBuilder path);
	public static int LoadPostEffect(string path)
	{
		return LoadPostEffect_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreePostEffect")]
	public static extern void FreePostEffect(int postEffect);

	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffect")]
	public static extern void SetPostEffect_(int index, int postEffect, StringBuilder technique);
	public static void SetPostEffect(int index, int postEffect, string technique)
	{
		SetPostEffect_(index, postEffect, new StringBuilder(technique));
	}
	public static void SetPostEffect(int index, int postEffect)
	{
		 SetPostEffect(index, postEffect, "MainTechnique");
	}
	[DllImport("xors3d.dll", EntryPoint = "xRenderPostEffects")]
	public static extern void RenderPostEffects();

	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffectInt")]
	public static extern void SetPostEffectInt_(int postEffect, StringBuilder name, int value);
	public static void SetPostEffectInt(int postEffect, string name, int value)
	{
		SetPostEffectInt_(postEffect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffectFloat")]
	public static extern void SetPostEffectFloat_(int postEffect, StringBuilder name, float value);
	public static void SetPostEffectFloat(int postEffect, string name, float value)
	{
		SetPostEffectFloat_(postEffect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffectBool")]
	public static extern void SetPostEffectBool_(int postEffect, StringBuilder name, bool value);
	public static void SetPostEffectBool(int postEffect, string name, bool value)
	{
		SetPostEffectBool_(postEffect, new StringBuilder(name), value);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffectVector")]
	public static extern void SetPostEffectVector_(int postEffect, StringBuilder name, float x, float y, float z, float w);
	public static void SetPostEffectVector(int postEffect, string name, float x, float y, float z, float w)
	{
		SetPostEffectVector_(postEffect, new StringBuilder(name), x, y, z, w);
	}
	public static void SetPostEffectVector(int postEffect, string name, float x, float y, float z)
	{
		 SetPostEffectVector(postEffect, name, x, y, z, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSetPostEffectTexture")]
	public static extern void SetPostEffectTexture_(int postEffect, StringBuilder name, int texture, int frame);
	public static void SetPostEffectTexture(int postEffect, string name, int texture, int frame)
	{
		SetPostEffectTexture_(postEffect, new StringBuilder(name), texture, frame);
	}
	public static void SetPostEffectTexture(int postEffect, string name, int texture)
	{
		 SetPostEffectTexture(postEffect, name, texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xDeletePostEffectConstant")]
	public static extern void DeletePostEffectConstant_(int postEffect, StringBuilder name);
	public static void DeletePostEffectConstant(int postEffect, string name)
	{
		DeletePostEffectConstant_(postEffect, new StringBuilder(name));
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearPostEffectConstants")]
	public static extern void ClearPostEffectConstants(int postEffect);


	// psystems commands
	[DllImport("xors3d.dll", EntryPoint = "xCreatePSystem")]
	public static extern int CreatePSystem(bool pointSprites);

	public static int CreatePSystem()
	{
		return CreatePSystem(false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xPSystemType")]
	public static extern int PSystemType(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetBlend")]
	public static extern void PSystemSetBlend(int psystem, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetBlend")]
	public static extern int PSystemGetBlend(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetMaxParticles")]
	public static extern void PSystemSetMaxParticles(int psystem, int maxNumber);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetMaxParticles")]
	public static extern int PSystemGetMaxParticles(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetEmitterLifetime")]
	public static extern void PSystemSetEmitterLifetime(int psystem, int lifetime);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetEmitterLifetime")]
	public static extern int PSystemGetEmitterLifetime(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetParticleLifetime")]
	public static extern void PSystemSetParticleLifetime(int psystem, int lifetime);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetParticleLifetime")]
	public static extern int PSystemGetParticleLifetime(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetCreationInterval")]
	public static extern void PSystemSetCreationInterval(int psystem, int interval);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetCreationInterval")]
	public static extern int PSystemGetCreationInterval(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetCreationFrequency")]
	public static extern void PSystemSetCreationFrequency(int psystem, int frequency);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetCreationFrequency")]
	public static extern int PSystemGetCreationFrequency(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetTexture")]
	public static extern void PSystemSetTexture(int psystem, int texture, int frames, float speed);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTexture")]
	public static extern int PSystemGetTexture(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTextureFrames")]
	public static extern int PSystemGetTextureFrames(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTextureAnimationSpeed")]
	public static extern int PSystemGetTextureAnimationSpeed(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetOffset")]
	public static extern void PSystemSetOffset(int psystem, float minx, float miny, float minz, float maxx, float maxy, float maxz);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMinX")]
	public static extern float PSystemGetOffsetMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMinY")]
	public static extern float PSystemGetOffsetMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMinZ")]
	public static extern float PSystemGetOffsetMinZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMaxX")]
	public static extern float PSystemGetOffsetMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMaxY")]
	public static extern float PSystemGetOffsetMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetOffsetMaxZ")]
	public static extern float PSystemGetOffsetMaxZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetVelocity")]
	public static extern void PSystemSetVelocity(int psystem, float minx, float miny, float minz, float maxx, float maxy, float maxz);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMinX")]
	public static extern float PSystemGetVelocityMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMinY")]
	public static extern float PSystemGetVelocityMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMinZ")]
	public static extern float PSystemGetVelocityMinZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMaxX")]
	public static extern float PSystemGetVelocityMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMaxY")]
	public static extern float PSystemGetVelocityMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetVelocityMaxZ")]
	public static extern float PSystemGetVelocityMaxZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemEnableFixedQuads")]
	public static extern void PSystemEnableFixedQuads(int psystem, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemFixedQuadsUsed")]
	public static extern int PSystemFixedQuadsUsed(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetTorque")]
	public static extern void PSystemSetTorque(int psystem, float minx, float miny, float minz, float maxx, float maxy, float maxz);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMinX")]
	public static extern float PSystemGetTorqueMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMinY")]
	public static extern float PSystemGetTorqueMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMinZ")]
	public static extern float PSystemGetTorqueMinZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMaxX")]
	public static extern float PSystemGetTorqueMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMaxY")]
	public static extern float PSystemGetTorqueMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetTorqueMaxZ")]
	public static extern float PSystemGetTorqueMaxZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetGravity")]
	public static extern void PSystemSetGravity(int psystem, float gravity);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetGravity")]
	public static extern float PSystemGetGravity(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetAlpha")]
	public static extern void PSystemSetAlpha(int psystem, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAlpha")]
	public static extern float PSystemGetAlpha(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetFadeSpeed")]
	public static extern void PSystemSetFadeSpeed(int psystem, float speed);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetFadeSpeed")]
	public static extern float PSystemGetFadeSpeed(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetParticleSize")]
	public static extern void PSystemSetParticleSize(int psystem, float minx, float miny, float maxx, float maxy);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetSizeMinX")]
	public static extern float PSystemGetSizeMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetSizeMinY")]
	public static extern float PSystemGetSizeMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetSizeMaxX")]
	public static extern float PSystemGetSizeMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetSizeMaxY")]
	public static extern float PSystemGetSizeMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetScaleSpeed")]
	public static extern void PSystemSetScaleSpeed(int psystem, float minx, float miny, float maxx, float maxy);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetScaleSpeedMinX")]
	public static extern float PSystemGetScaleSpeedMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetScaleSpeedMinY")]
	public static extern float PSystemGetScaleSpeedMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetScaleSpeedMaxX")]
	public static extern float PSystemGetScaleSpeedMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetScaleSpeedMaxY")]
	public static extern float PSystemGetScaleSpeedMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetAngles")]
	public static extern void PSystemSetAngles(int psystem, float minx, float miny, float minz, float maxx, float maxy, float maxz);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMinX")]
	public static extern float PSystemGetAnglesMinX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMinY")]
	public static extern float PSystemGetAnglesMinY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMinZ")]
	public static extern float PSystemGetAnglesMinZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMaxX")]
	public static extern float PSystemGetAnglesMaxX(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMaxY")]
	public static extern float PSystemGetAnglesMaxY(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetAnglesMaxZ")]
	public static extern float PSystemGetAnglesMaxZ(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetColorMode")]
	public static extern void PSystemSetColorMode(int psystem, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetColorMode")]
	public static extern int PSystemGetColorMode(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetColors")]
	public static extern void PSystemSetColors(int psystem, float sred, float sgreen, float sblue, float ered, float egreen, float eblue);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetBeginColorRed")]
	public static extern float PSystemGetBeginColorRed(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetBeginColorGreen")]
	public static extern float PSystemGetBeginColorGreen(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetBeginColorBlue")]
	public static extern float PSystemGetBeginColorBlue(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetEndColorRed")]
	public static extern float PSystemGetEndColorRed(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetEndColorGreen")]
	public static extern float PSystemGetEndColorGreen(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetEndColorBlue")]
	public static extern float PSystemGetEndColorBlue(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xFreePSystem")]
	public static extern void FreePSystem(int psystem);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemSetParticleParenting")]
	public static extern void PSystemSetParticleParenting(int psystem, bool mode);

	[DllImport("xors3d.dll", EntryPoint = "xPSystemGetParticleParenting")]
	public static extern int PSystemGetParticleParenting(int psystem);


	// raypicks commands
	[DllImport("xors3d.dll", EntryPoint = "xLinePick")]
	public static extern int LinePick(float x, float y, float z, float dx, float dy, float dz, float distance);

	public static int LinePick(float x, float y, float z, float dx, float dy, float dz)
	{
		return LinePick(x, y, z, dx, dy, dz, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xEntityPick")]
	public static extern int EntityPick(int entity, float range);

	public static int EntityPick(int entity)
	{
		return EntityPick(entity, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCameraPick")]
	public static extern int CameraPick(int camera, int x, int y);

	[DllImport("xors3d.dll", EntryPoint = "xPickedNX")]
	public static extern float PickedNX();

	[DllImport("xors3d.dll", EntryPoint = "xPickedNY")]
	public static extern float PickedNY();

	[DllImport("xors3d.dll", EntryPoint = "xPickedNZ")]
	public static extern float PickedNZ();

	[DllImport("xors3d.dll", EntryPoint = "xPickedX")]
	public static extern float PickedX();

	[DllImport("xors3d.dll", EntryPoint = "xPickedY")]
	public static extern float PickedY();

	[DllImport("xors3d.dll", EntryPoint = "xPickedZ")]
	public static extern float PickedZ();

	[DllImport("xors3d.dll", EntryPoint = "xPickedEntity")]
	public static extern int PickedEntity();

	[DllImport("xors3d.dll", EntryPoint = "xPickedSurface")]
	public static extern int PickedSurface();

	[DllImport("xors3d.dll", EntryPoint = "xPickedTriangle")]
	public static extern int PickedTriangle();

	[DllImport("xors3d.dll", EntryPoint = "xPickedTime")]
	public static extern int PickedTime();


	// shadows commands
	[DllImport("xors3d.dll", EntryPoint = "xSetShadowsBlur")]
	public static extern void SetShadowsBlur(int blurLevel);

	[DllImport("xors3d.dll", EntryPoint = "xSetShadowShader")]
	public static extern void SetShadowShader_(StringBuilder path);
	public static void SetShadowShader(string path)
	{
		SetShadowShader_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xInitShadows")]
	public static extern int InitShadows(int dirSize, int spotSize, int pointSize);

	[DllImport("xors3d.dll", EntryPoint = "xSetShadowParams")]
	public static extern void SetShadowParams(int splitPlanes, float splitLambda, bool useOrtho, float lightDist);

	public static void SetShadowParams(int splitPlanes, float splitLambda, bool useOrtho)
	{
		 SetShadowParams(splitPlanes, splitLambda, useOrtho, 300.0f);
	}
	public static void SetShadowParams(int splitPlanes, float splitLambda)
	{
		 SetShadowParams(splitPlanes, splitLambda, true, 300.0f);
	}
	public static void SetShadowParams(int splitPlanes)
	{
		 SetShadowParams(splitPlanes, 0.95f, true, 300.0f);
	}
	public static void SetShadowParams()
	{
		 SetShadowParams(4, 0.95f, true, 300.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRenderShadows")]
	public static extern void RenderShadows(int mainCamera, int texture);

	[DllImport("xors3d.dll", EntryPoint = "xShadowPriority")]
	public static extern void ShadowPriority(int priority);

	[DllImport("xors3d.dll", EntryPoint = "xCameraDisableShadows")]
	public static extern void CameraDisableShadows(int camera);

	[DllImport("xors3d.dll", EntryPoint = "xCameraEnableShadows")]
	public static extern void CameraEnableShadows(int camera);

	[DllImport("xors3d.dll", EntryPoint = "xEntityCastShadows")]
	public static extern void EntityCastShadows(int entity, int light, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xEntityReceiveShadows")]
	public static extern void EntityReceiveShadows(int entity, int light, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xEntityIsCaster")]
	public static extern int EntityIsCaster(int entity, int light);

	[DllImport("xors3d.dll", EntryPoint = "xEntityIsReceiver")]
	public static extern int EntityIsReceiver(int entity, int light);


	// sounds commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadSound")]
	public static extern int LoadSound_(StringBuilder path);
	public static int LoadSound(string path)
	{
		return LoadSound_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xLoad3DSound")]
	public static extern int Load3DSound_(StringBuilder path);
	public static int Load3DSound(string path)
	{
		return Load3DSound_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeSound")]
	public static extern void FreeSound(int sound);

	[DllImport("xors3d.dll", EntryPoint = "xLoopSound")]
	public static extern void LoopSound(int sound);

	[DllImport("xors3d.dll", EntryPoint = "xSoundPitch")]
	public static extern void SoundPitch(int sound, int pitch);

	[DllImport("xors3d.dll", EntryPoint = "xSoundVolume")]
	public static extern void SoundVolume(int sound, float volume);

	[DllImport("xors3d.dll", EntryPoint = "xSoundPan")]
	public static extern void SoundPan(int sound, float pan);

	[DllImport("xors3d.dll", EntryPoint = "xPlaySound")]
	public static extern int PlaySound(int sound);

	[DllImport("xors3d.dll", EntryPoint = "xStopChannel")]
	public static extern void StopChannel(int channel);

	[DllImport("xors3d.dll", EntryPoint = "xPauseChannel")]
	public static extern void PauseChannel(int channel);

	[DllImport("xors3d.dll", EntryPoint = "xResumeChannel")]
	public static extern void ResumeChannel(int channel);

	[DllImport("xors3d.dll", EntryPoint = "xPlayMusic")]
	public static extern int PlayMusic_(StringBuilder path);
	public static int PlayMusic(string path)
	{
		return PlayMusic_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xChannelPitch")]
	public static extern void ChannelPitch(int channel, int pitch);

	[DllImport("xors3d.dll", EntryPoint = "xChannelVolume")]
	public static extern void ChannelVolume(int channel, float volume);

	[DllImport("xors3d.dll", EntryPoint = "xChannelPan")]
	public static extern void ChannelPan(int channel, float pan);

	[DllImport("xors3d.dll", EntryPoint = "xChannelPlaying")]
	public static extern int ChannelPlaying(int channel);

	[DllImport("xors3d.dll", EntryPoint = "xEmitSound")]
	public static extern int EmitSound(int sound, int entity);

	[DllImport("xors3d.dll", EntryPoint = "xCreateListener")]
	public static extern int CreateListener(int parent, float roFactor, float doplerFactor, float distFactor);

	public static int CreateListener(int parent, float roFactor, float doplerFactor)
	{
		return CreateListener(parent, roFactor, doplerFactor, 1.0f);
	}
	public static int CreateListener(int parent, float roFactor)
	{
		return CreateListener(parent, roFactor, 1.0f, 1.0f);
	}
	public static int CreateListener(int parent)
	{
		return CreateListener(parent, 1.0f, 1.0f, 1.0f);
	}
	public static int CreateListener()
	{
		return CreateListener(0, 1.0f, 1.0f, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetListener")]
	public static extern int GetListener();

	[DllImport("xors3d.dll", EntryPoint = "xInitalizeSound")]
	public static extern int InitalizeSound();


	// sprites commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateSprite")]
	public static extern int CreateSprite(int parent);

	public static int CreateSprite()
	{
		return CreateSprite(0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xSpriteViewMode")]
	public static extern void SpriteViewMode(int sprite, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xHandleSprite")]
	public static extern void HandleSprite(int sprite, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xLoadSprite")]
	public static extern int LoadSprite_(StringBuilder path, int flags, int parent);
	public static int LoadSprite(string path, int flags, int parent)
	{
		return LoadSprite_(new StringBuilder(path), flags, parent);
	}
	public static int LoadSprite(string path, int flags)
	{
		return LoadSprite(path, flags, 0);
	}
	public static int LoadSprite(string path)
	{
		return LoadSprite(path, 9, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xRotateSprite")]
	public static extern void RotateSprite(int sprite, float angle);

	[DllImport("xors3d.dll", EntryPoint = "xScaleSprite")]
	public static extern void ScaleSprite(int sprite, float xScale, float yScale);


	// surfaces commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateSurface")]
	public static extern int CreateSurface(int entity, int brush, bool dynamic);

	public static int CreateSurface(int entity, int brush)
	{
		return CreateSurface(entity, brush, false);
	}
	public static int CreateSurface(int entity)
	{
		return CreateSurface(entity, 0, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetSurfaceBrush")]
	public static extern int GetSurfaceBrush(int surface);

	[DllImport("xors3d.dll", EntryPoint = "xAddVertex")]
	public static extern int AddVertex(int surface, float x, float y, float z, float u, float v, float w);

	public static int AddVertex(int surface, float x, float y, float z, float u, float v)
	{
		return AddVertex(surface, x, y, z, u, v, 0.0f);
	}
	public static int AddVertex(int surface, float x, float y, float z, float u)
	{
		return AddVertex(surface, x, y, z, u, 0.0f, 0.0f);
	}
	public static int AddVertex(int surface, float x, float y, float z)
	{
		return AddVertex(surface, x, y, z, 0.0f, 0.0f, 0.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xAddTriangle")]
	public static extern int AddTriangle(int surface, int v0, int v1, int v2);

	[DllImport("xors3d.dll", EntryPoint = "xSetSurfaceFrustumSphere")]
	public static extern void SetSurfaceFrustumSphere(int surface, float x, float y, float z, float radii);

	[DllImport("xors3d.dll", EntryPoint = "xVertexCoords")]
	public static extern void VertexCoords(int surface, int vertex, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xVertexNormal")]
	public static extern void VertexNormal(int surface, int vertex, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xVertexTangent")]
	public static extern void VertexTangent(int surface, int vertex, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xVertexBinormal")]
	public static extern void VertexBinormal(int surface, int vertex, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xVertexColor")]
	public static extern void VertexColor(int surface, int vertex, int red, int green, int blue, float alpha);

	public static void VertexColor(int surface, int vertex, int red, int green, int blue)
	{
		 VertexColor(surface, vertex, red, green, blue, 1.0f);
	}
	[DllImport("xors3d.dll", EntryPoint = "xVertexTexCoords")]
	public static extern void VertexTexCoords(int surface, int vertex, float u, float v, float w, int textureSet);

	public static void VertexTexCoords(int surface, int vertex, float u, float v, float w)
	{
		 VertexTexCoords(surface, vertex, u, v, w, 0);
	}
	public static void VertexTexCoords(int surface, int vertex, float u, float v)
	{
		 VertexTexCoords(surface, vertex, u, v, 1.0f, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCountVertices")]
	public static extern int CountVertices(int surface);

	[DllImport("xors3d.dll", EntryPoint = "xVertexX")]
	public static extern float VertexX(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexY")]
	public static extern float VertexY(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexZ")]
	public static extern float VertexZ(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexNX")]
	public static extern float VertexNX(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexNY")]
	public static extern float VertexNY(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexNZ")]
	public static extern float VertexNZ(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexTX")]
	public static extern float VertexTX(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexTY")]
	public static extern float VertexTY(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexTZ")]
	public static extern float VertexTZ(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexBX")]
	public static extern float VertexBX(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexBY")]
	public static extern float VertexBY(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexBZ")]
	public static extern float VertexBZ(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexU")]
	public static extern float VertexU(int surface, int vertex, int textureSet);

	public static float VertexU(int surface, int vertex)
	{
		return VertexU(surface, vertex, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xVertexV")]
	public static extern float VertexV(int surface, int vertex, int textureSet);

	public static float VertexV(int surface, int vertex)
	{
		return VertexV(surface, vertex, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xVertexW")]
	public static extern float VertexW(int surface, int vertex, int textureSet);

	public static float VertexW(int surface, int vertex)
	{
		return VertexW(surface, vertex, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xVertexRed")]
	public static extern float VertexRed(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexGreen")]
	public static extern float VertexGreen(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexBlue")]
	public static extern float VertexBlue(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xVertexAlpha")]
	public static extern float VertexAlpha(int surface, int vertex);

	[DllImport("xors3d.dll", EntryPoint = "xTriangleVertex")]
	public static extern int TriangleVertex(int surface, int triangle, int corner);

	[DllImport("xors3d.dll", EntryPoint = "xCountTriangles")]
	public static extern int CountTriangles(int surface);

	[DllImport("xors3d.dll", EntryPoint = "xPaintSurface")]
	public static extern void PaintSurface(int surface, int brush);

	[DllImport("xors3d.dll", EntryPoint = "xClearSurface")]
	public static extern void ClearSurface(int surface, bool vertices, bool triangles);

	public static void ClearSurface(int surface, bool vertices)
	{
		 ClearSurface(surface, vertices, true);
	}
	public static void ClearSurface(int surface)
	{
		 ClearSurface(surface, true, true);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetSurfaceTexture")]
	public static extern int GetSurfaceTexture(int surface, int index);

	public static int GetSurfaceTexture(int surface)
	{
		return GetSurfaceTexture(surface, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeSurface")]
	public static extern void FreeSurface(int surface);

	[DllImport("xors3d.dll", EntryPoint = "xSurfacePrimitiveType")]
	public static extern void SurfacePrimitiveType(int surface, int ptype);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceTexture")]
	public static extern void SurfaceTexture(int surface, int texture, int frame, int index);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceColor")]
	public static extern void SurfaceColor(int surface, int red, int green, int blue);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceAlpha")]
	public static extern void SurfaceAlpha(int surface, float alpha);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceShininess")]
	public static extern void SurfaceShininess(int surface, float shininess);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceBlend")]
	public static extern void SurfaceBlend(int surface, int blendMode);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceFX")]
	public static extern void SurfaceFX(int surface, int fxFlags);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceAlphaRef")]
	public static extern void SurfaceAlphaRef(int surface, int alphaRef);

	[DllImport("xors3d.dll", EntryPoint = "xSurfaceAlphaFunc")]
	public static extern void SurfaceAlphaFunc(int surface, int alphaFunc);


	// sysinfos commands
	[DllImport("xors3d.dll", EntryPoint = "xCPUName")]
	public static extern IntPtr CPUName_();
	public static string CPUName()
	{
		return Marshal.PtrToStringAnsi(CPUName_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xCPUVendor")]
	public static extern IntPtr CPUVendor_();
	public static string CPUVendor()
	{
		return Marshal.PtrToStringAnsi(CPUVendor_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xCPUFamily")]
	public static extern int CPUFamily();

	[DllImport("xors3d.dll", EntryPoint = "xCPUModel")]
	public static extern int CPUModel();

	[DllImport("xors3d.dll", EntryPoint = "xCPUStepping")]
	public static extern int CPUStepping();

	[DllImport("xors3d.dll", EntryPoint = "xCPUSpeed")]
	public static extern int CPUSpeed();

	[DllImport("xors3d.dll", EntryPoint = "xVideoInfo")]
	public static extern IntPtr VideoInfo_();
	public static string VideoInfo()
	{
		return Marshal.PtrToStringAnsi(VideoInfo_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xVideoAspectRatio")]
	public static extern float VideoAspectRatio();

	[DllImport("xors3d.dll", EntryPoint = "xVideoAspectRatioStr")]
	public static extern IntPtr VideoAspectRatioStr_();
	public static string VideoAspectRatioStr()
	{
		return Marshal.PtrToStringAnsi(VideoAspectRatioStr_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xGetTotalPhysMem")]
	public static extern float GetTotalPhysMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetAvailPhysMem")]
	public static extern float GetAvailPhysMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetTotalPageMem")]
	public static extern float GetTotalPageMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetAvailPageMem")]
	public static extern float GetAvailPageMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetTotalVidMem")]
	public static extern float GetTotalVidMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetAvailVidMem")]
	public static extern float GetAvailVidMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetTotalVidLocalMem")]
	public static extern float GetTotalVidLocalMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetAvailVidLocalMem")]
	public static extern float GetAvailVidLocalMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetTotalVidNonlocalMem")]
	public static extern float GetTotalVidNonlocalMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetAvailVidNonlocalMem")]
	public static extern float GetAvailVidNonlocalMem();

	[DllImport("xors3d.dll", EntryPoint = "xGetXors3dVersion")]
	public static extern IntPtr GetXors3dVersion_();
	public static string GetXors3dVersion()
	{
		return Marshal.PtrToStringAnsi(GetXors3dVersion_());
	}

	[DllImport("xors3d.dll", EntryPoint = "xGetXors3dMajorVersion")]
	public static extern int GetXors3dMajorVersion();

	[DllImport("xors3d.dll", EntryPoint = "xGetXors3dMinorVersion")]
	public static extern int GetXors3dMinorVersion();

	[DllImport("xors3d.dll", EntryPoint = "xGetXors3dRevision")]
	public static extern int GetXors3dRevision();


	// terrains commands
	[DllImport("xors3d.dll", EntryPoint = "xLoadTerrain")]
	public static extern int LoadTerrain_(StringBuilder path, int parent);
	public static int LoadTerrain(string path, int parent)
	{
		return LoadTerrain_(new StringBuilder(path), parent);
	}
	public static int LoadTerrain(string path)
	{
		return LoadTerrain(path, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateTerrain")]
	public static extern int CreateTerrain(int size, int parent);

	public static int CreateTerrain(int size)
	{
		return CreateTerrain(size, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTerrainShading")]
	public static extern void TerrainShading(int terrain, bool state);

	public static void TerrainShading(int terrain)
	{
		 TerrainShading(terrain, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTerrainHeight")]
	public static extern float TerrainHeight(int terrain, int x, int y);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainSize")]
	public static extern int TerrainSize(int terrain);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainX")]
	public static extern float TerrainX(int terrain, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainY")]
	public static extern float TerrainY(int terrain, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainZ")]
	public static extern float TerrainZ(int terrain, float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xModifyTerrain")]
	public static extern void ModifyTerrain(int terrain, int x, int y, float height, bool realtime);

	public static void ModifyTerrain(int terrain, int x, int y, float height)
	{
		 ModifyTerrain(terrain, x, y, height, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTerrainDetail")]
	public static extern void TerrainDetail(int terrain, int detail);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainSplatting")]
	public static extern void TerrainSplatting(int terrain, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xLoadTerrainTexture")]
	public static extern int LoadTerrainTexture_(StringBuilder path);
	public static int LoadTerrainTexture(string path)
	{
		return LoadTerrainTexture_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeTerrainTexture")]
	public static extern void FreeTerrainTexture(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainTextureLightmap")]
	public static extern void TerrainTextureLightmap(int texture, bool state);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainTexture")]
	public static extern void TerrainTexture(int terrain, int texture);

	[DllImport("xors3d.dll", EntryPoint = "xTerrainViewZone")]
	public static extern void TerrainViewZone(int terrain, int viewZone, int texturingZone);

	public static void TerrainViewZone(int terrain, int viewZone)
	{
		 TerrainViewZone(terrain, viewZone, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTerrainLODs")]
	public static extern void TerrainLODs(int lodsCount);


	// textures commands
	[DllImport("xors3d.dll", EntryPoint = "xTextureWidth")]
	public static extern int TextureWidth(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xTextureHeight")]
	public static extern int TextureHeight(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xCreateTexture")]
	public static extern int CreateTexture(int width, int height, int flags, int frames);

	public static int CreateTexture(int width, int height, int flags)
	{
		return CreateTexture(width, height, flags, 1);
	}
	public static int CreateTexture(int width, int height)
	{
		return CreateTexture(width, height, 9, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xFreeTexture")]
	public static extern void FreeTexture(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xSetTextureFilter")]
	public static extern void SetTextureFilter(int texture, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xTextureBlend")]
	public static extern void TextureBlend(int texture, int blend);

	[DllImport("xors3d.dll", EntryPoint = "xTextureCoords")]
	public static extern void TextureCoords(int texture, int coords);

	[DllImport("xors3d.dll", EntryPoint = "xTextureFilter")]
	public static extern void TextureFilter_(StringBuilder matchText, int flags);
	public static void TextureFilter(string matchText, int flags)
	{
		TextureFilter_(new StringBuilder(matchText), flags);
	}
	[DllImport("xors3d.dll", EntryPoint = "xClearTextureFilters")]
	public static extern void ClearTextureFilters();

	[DllImport("xors3d.dll", EntryPoint = "xLoadTexture")]
	public static extern int LoadTexture_(StringBuilder path, int flags);
	public static int LoadTexture(string path, int flags)
	{
		return LoadTexture_(new StringBuilder(path), flags);
	}
	public static int LoadTexture(string path)
	{
		return LoadTexture(path, 9);
	}
	[DllImport("xors3d.dll", EntryPoint = "xTextureName")]
	public static extern IntPtr TextureName_(int texture);
	public static string TextureName(int texture)
	{
		return Marshal.PtrToStringAnsi(TextureName_(texture));
	}

	[DllImport("xors3d.dll", EntryPoint = "xPositionTexture")]
	public static extern void PositionTexture(int texture, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xScaleTexture")]
	public static extern void ScaleTexture(int texture, float x, float y);

	[DllImport("xors3d.dll", EntryPoint = "xRotateTexture")]
	public static extern void RotateTexture(int texture, float angle);

	[DllImport("xors3d.dll", EntryPoint = "xLoadAnimTexture")]
	public static extern int LoadAnimTexture_(StringBuilder path, int flags, int width, int height, int startFrame, int frames);
	public static int LoadAnimTexture(string path, int flags, int width, int height, int startFrame, int frames)
	{
		return LoadAnimTexture_(new StringBuilder(path), flags, width, height, startFrame, frames);
	}
	[DllImport("xors3d.dll", EntryPoint = "xCreateTextureFromData")]
	public static extern int CreateTextureFromData(int pixelsData, int width, int height, int flags, int frames);

	public static int CreateTextureFromData(int pixelsData, int width, int height, int flags)
	{
		return CreateTextureFromData(pixelsData, width, height, flags, 1);
	}
	public static int CreateTextureFromData(int pixelsData, int width, int height)
	{
		return CreateTextureFromData(pixelsData, width, height, 9, 1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetTextureData")]
	public static extern int GetTextureData(int texture, int frame);

	public static int GetTextureData(int texture)
	{
		return GetTextureData(texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetTextureDataPitch")]
	public static extern int GetTextureDataPitch(int texture, int frame);

	public static int GetTextureDataPitch(int texture)
	{
		return GetTextureDataPitch(texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetTextureSurface")]
	public static extern int GetTextureSurface(int texture, int frame);

	public static int GetTextureSurface(int texture)
	{
		return GetTextureSurface(texture, 0);
	}
	[DllImport("xors3d.dll", EntryPoint = "xGetTextureFrames")]
	public static extern int GetTextureFrames(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xSetCubeFace")]
	public static extern void SetCubeFace(int texture, int face);

	[DllImport("xors3d.dll", EntryPoint = "xSetCubeMode")]
	public static extern void SetCubeMode(int texture, int mode);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureBlend")]
	public static extern int GetTextureBlend(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureX")]
	public static extern float GetTextureX(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureY")]
	public static extern float GetTextureY(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureScaleX")]
	public static extern float GetTextureScaleX(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureScaleY")]
	public static extern float GetTextureScaleY(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureAngle")]
	public static extern float GetTextureAngle(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureCoords")]
	public static extern int GetTextureCoords(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetCubeFace")]
	public static extern int GetCubeFace(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetCubeMode")]
	public static extern int GetCubeMode(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xGetTextureFlags")]
	public static extern int GetTextureFlags(int texture);

	[DllImport("xors3d.dll", EntryPoint = "xSetTextureFlags")]
	public static extern void SetTextureFlags(int texture, int flags);

	[DllImport("xors3d.dll", EntryPoint = "xTextureCounter")]
	public static extern int TextureCounter(int texture);


	// transforms commands
	[DllImport("xors3d.dll", EntryPoint = "xVectorPitch")]
	public static extern float VectorPitch(float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xVectorYaw")]
	public static extern float VectorYaw(float x, float y, float z);

	[DllImport("xors3d.dll", EntryPoint = "xDeltaPitch")]
	public static extern float DeltaPitch(int entity1, int entity2);

	[DllImport("xors3d.dll", EntryPoint = "xDeltaYaw")]
	public static extern float DeltaYaw(int entity1, int entity2);

	[DllImport("xors3d.dll", EntryPoint = "xTFormedX")]
	public static extern float TFormedX();

	[DllImport("xors3d.dll", EntryPoint = "xTFormedY")]
	public static extern float TFormedY();

	[DllImport("xors3d.dll", EntryPoint = "xTFormedZ")]
	public static extern float TFormedZ();

	[DllImport("xors3d.dll", EntryPoint = "xTFormPoint")]
	public static extern void TFormPoint(float x, float y, float z, int source, int destination);

	[DllImport("xors3d.dll", EntryPoint = "xTFormVector")]
	public static extern void TFormVector(float x, float y, float z, int source, int destination);

	[DllImport("xors3d.dll", EntryPoint = "xTFormNormal")]
	public static extern void TFormNormal(float x, float y, float z, int source, int destination);


	// videos commands
	[DllImport("xors3d.dll", EntryPoint = "xOpenMovie")]
	public static extern int OpenMovie_(StringBuilder path);
	public static int OpenMovie(string path)
	{
		return OpenMovie_(new StringBuilder(path));
	}
	[DllImport("xors3d.dll", EntryPoint = "xCloseMovie")]
	public static extern void CloseMovie(int video);

	[DllImport("xors3d.dll", EntryPoint = "xDrawMovie")]
	public static extern void DrawMovie(int video, int x, int y, int width, int height);

	public static void DrawMovie(int video, int x, int y, int width)
	{
		 DrawMovie(video, x, y, width, -1);
	}
	public static void DrawMovie(int video, int x, int y)
	{
		 DrawMovie(video, x, y, -1, -1);
	}
	public static void DrawMovie(int video, int x)
	{
		 DrawMovie(video, x, 0, -1, -1);
	}
	public static void DrawMovie(int video)
	{
		 DrawMovie(video, 0, 0, -1, -1);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMovieWidth")]
	public static extern int MovieWidth(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMovieHeight")]
	public static extern int MovieHeight(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMoviePlaying")]
	public static extern int MoviePlaying(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMovieSeek")]
	public static extern void MovieSeek(int video, float time, bool relative);

	public static void MovieSeek(int video, float time)
	{
		 MovieSeek(video, time, false);
	}
	[DllImport("xors3d.dll", EntryPoint = "xMovieLength")]
	public static extern float MovieLength(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMovieCurrentTime")]
	public static extern float MovieCurrentTime(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMoviePause")]
	public static extern void MoviePause(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMovieResume")]
	public static extern void MovieResume(int video);

	[DllImport("xors3d.dll", EntryPoint = "xMovieTexture")]
	public static extern int MovieTexture(int video);


	// worlds commands
	[DllImport("xors3d.dll", EntryPoint = "xCreateWorld")]
	public static extern int CreateWorld();

	[DllImport("xors3d.dll", EntryPoint = "xSetActiveWorld")]
	public static extern void SetActiveWorld(int world);

	[DllImport("xors3d.dll", EntryPoint = "xGetActiveWorld")]
	public static extern int GetActiveWorld();

	[DllImport("xors3d.dll", EntryPoint = "xGetDefaultWorld")]
	public static extern int GetDefaultWorld();

	[DllImport("xors3d.dll", EntryPoint = "xDeleteWorld")]
	public static extern void DeleteWorld(int world);

	// Scancodes for keyboard and mouse
	public const int MOUSE_LEFT         = 1;
	public const int MOUSE_RIGHT        = 2;
	public const int MOUSE_MIDDLE       = 3;
	public const int MOUSE4             = 4;
	public const int MOUSE5             = 5;
	public const int MOUSE6             = 6;
	public const int MOUSE7             = 7;
	public const int MOUSE8             = 8;
	
	public const int xMOUSE_LEFT        = 1;
	public const int xMOUSE_RIGHT       = 2;
	public const int xMOUSE_MIDDLE      = 3;
	public const int xMOUSE4            = 4;
	public const int xMOUSE5            = 5;
	public const int xMOUSE6            = 6;
	public const int xMOUSE7            = 7;
	public const int xMOUSE8            = 8;
	
	public const int KEY_ESCAPE         = 1;
	public const int KEY_1              = 2;
	public const int KEY_2              = 3;
	public const int KEY_3              = 4;
	public const int KEY_4              = 5;
	public const int KEY_5              = 6;
	public const int KEY_6              = 7;
	public const int KEY_7              = 8;
	public const int KEY_8              = 9;
	public const int KEY_9              = 10;
	public const int KEY_0              = 11;
	public const int KEY_MINUS          = 12;
	public const int KEY_EQUALS         = 13;
	public const int KEY_BACK           = 14;
	public const int KEY_TAB            = 15;
	public const int KEY_Q              = 16;
	public const int KEY_W              = 17;
	public const int KEY_E              = 18;
	public const int KEY_R              = 19;
	public const int KEY_T              = 20;
	public const int KEY_Y              = 21;
	public const int KEY_U              = 22;
	public const int KEY_I              = 23;
	public const int KEY_O              = 24;
	public const int KEY_P              = 25;
	public const int KEY_LBRACKET       = 26;
	public const int KEY_RBRACKET       = 27;
	public const int KEY_RETURN         = 28;
	public const int KEY_ENTER          = KEY_RETURN;
	public const int KEY_LCONTROL       = 29;
	public const int KEY_RCONTROL       = 157;
	public const int KEY_A              = 30;
	public const int KEY_S              = 31;
	public const int KEY_D              = 32;
	public const int KEY_F              = 33;
	public const int KEY_G              = 34;
	public const int KEY_H              = 35;
	public const int KEY_J              = 36;
	public const int KEY_K              = 37;
	public const int KEY_L              = 38;
	public const int KEY_SEMICOLON      = 39;
	public const int KEY_APOSTROPHE     = 40;
	public const int KEY_GRAVE          = 41;
	public const int KEY_LSHIFT         = 42;
	public const int KEY_BACKSLASH      = 43;
	public const int KEY_Z              = 44;
	public const int KEY_X              = 45;
	public const int KEY_C              = 46;
	public const int KEY_V              = 47;
	public const int KEY_B              = 48;
	public const int KEY_N              = 49;
	public const int KEY_M              = 50;
	public const int KEY_COMMA          = 51;
	public const int KEY_PERIOD         = 52;
	public const int KEY_SLASH          = 53;
	public const int KEY_RSHIFT         = 54;
	public const int KEY_MULTIPLY       = 55;
	public const int KEY_MENU           = 56;
	public const int KEY_SPACE          = 57;
	public const int KEY_F1             = 59;
	public const int KEY_F2             = 60;
	public const int KEY_F3             = 61;
	public const int KEY_F4             = 62;
	public const int KEY_F5             = 63;
	public const int KEY_F6             = 64;
	public const int KEY_F7             = 65;
	public const int KEY_F8             = 66;
	public const int KEY_F9             = 67;
	public const int KEY_F10            = 68;
	public const int KEY_NUMLOCK        = 69;
	public const int KEY_SCROLL         = 70;
	public const int KEY_NUMPAD7        = 71;
	public const int KEY_NUMPAD8        = 72;
	public const int KEY_NUMPAD9        = 73;
	public const int KEY_SUBTRACT       = 74;
	public const int KEY_NUMPAD4        = 75;
	public const int KEY_NUMPAD5        = 76;
	public const int KEY_NUMPAD6        = 77;
	public const int KEY_ADD            = 78;
	public const int KEY_NUMPAD1        = 79;
	public const int KEY_NUMPAD2        = 80;
	public const int KEY_NUMPAD3        = 81;
	public const int KEY_NUMPAD0        = 82;
	public const int KEY_DECIMAL        = 83;
	public const int KEY_TILD           = 86;
	public const int KEY_F11            = 87;
	public const int KEY_F12            = 88;
	public const int KEY_NUMPADENTER    = 156;
	public const int KEY_RMENU          = 221;
	public const int KEY_PAUSE          = 197;
	public const int KEY_HOME           = 199;
	public const int KEY_UP             = 200;
	public const int KEY_PRIOR          = 201;
	public const int KEY_LEFT           = 203;
	public const int KEY_RIGHT          = 205;
	public const int KEY_END            = 207;
	public const int KEY_DOWN           = 208;
	public const int KEY_NEXT           = 209;
	public const int KEY_INSERT         = 210;
	public const int KEY_DELETE         = 211;
	public const int KEY_LWIN           = 219;
	public const int KEY_RWIN           = 220;
	public const int KEY_BACKSPACE      = KEY_BACK;
	public const int KEY_NUMPADSTAR     = KEY_MULTIPLY;
	public const int KEY_LALT           = 184;
	public const int KEY_CAPSLOCK       = 58;
	public const int KEY_NUMPADMINUS    = KEY_SUBTRACT;
	public const int KEY_NUMPADPLUS     = KEY_ADD;
	public const int KEY_NUMPADPERIOD   = KEY_DECIMAL;
	public const int KEY_DIVIDE         = 181;
	public const int KEY_NUMPADSLASH    = KEY_DIVIDE;
	public const int KEY_RALT           = 56;
	public const int KEY_UPARROW        = KEY_UP;
	public const int KEY_PGUP           = KEY_PRIOR;
	public const int KEY_LEFTARROW      = KEY_LEFT;
	public const int KEY_RIGHTARROW     = KEY_RIGHT;
	public const int KEY_DOWNARROW      = KEY_DOWN;
	public const int KEY_PGDN           = KEY_NEXT;
	
	public const int xKEY_ESCAPE        = 1;
	public const int xKEY_1             = 2;
	public const int xKEY_2             = 3;
	public const int xKEY_3             = 4;
	public const int xKEY_4             = 5;
	public const int xKEY_5             = 6;
	public const int xKEY_6             = 7;
	public const int xKEY_7             = 8;
	public const int xKEY_8             = 9;
	public const int xKEY_9             = 10;
	public const int xKEY_0             = 11;
	public const int xKEY_MINUS         = 12;
	public const int xKEY_EQUALS        = 13;
	public const int xKEY_BACK          = 14;
	public const int xKEY_TAB           = 15;
	public const int xKEY_Q             = 16;
	public const int xKEY_W             = 17;
	public const int xKEY_E             = 18;
	public const int xKEY_R             = 19;
	public const int xKEY_T             = 20;
	public const int xKEY_Y             = 21;
	public const int xKEY_U             = 22;
	public const int xKEY_I             = 23;
	public const int xKEY_O             = 24;
	public const int xKEY_P             = 25;
	public const int xKEY_LBRACKET      = 26;
	public const int xKEY_RBRACKET      = 27;
	public const int xKEY_RETURN        = 28;
	public const int xKEY_ENTER         = KEY_RETURN;
	public const int xKEY_LCONTROL      = 29;
	public const int xKEY_RCONTROL      = 157;
	public const int xKEY_A             = 30;
	public const int xKEY_S             = 31;
	public const int xKEY_D             = 32;
	public const int xKEY_F             = 33;
	public const int xKEY_G             = 34;
	public const int xKEY_H             = 35;
	public const int xKEY_J             = 36;
	public const int xKEY_K             = 37;
	public const int xKEY_L             = 38;
	public const int xKEY_SEMICOLON     = 39;
	public const int xKEY_APOSTROPHE    = 40;
	public const int xKEY_GRAVE         = 41;
	public const int xKEY_LSHIFT        = 42;
	public const int xKEY_BACKSLASH     = 43;
	public const int xKEY_Z             = 44;
	public const int xKEY_X             = 45;
	public const int xKEY_C             = 46;
	public const int xKEY_V             = 47;
	public const int xKEY_B             = 48;
	public const int xKEY_N             = 49;
	public const int xKEY_M             = 50;
	public const int xKEY_COMMA         = 51;
	public const int xKEY_PERIOD        = 52;
	public const int xKEY_SLASH         = 53;
	public const int xKEY_RSHIFT        = 54;
	public const int xKEY_MULTIPLY      = 55;
	public const int xKEY_MENU          = 56;
	public const int xKEY_SPACE         = 57;
	public const int xKEY_F1            = 59;
	public const int xKEY_F2            = 60;
	public const int xKEY_F3            = 61;
	public const int xKEY_F4            = 62;
	public const int xKEY_F5            = 63;
	public const int xKEY_F6            = 64;
	public const int xKEY_F7            = 65;
	public const int xKEY_F8            = 66;
	public const int xKEY_F9            = 67;
	public const int xKEY_F10           = 68;
	public const int xKEY_NUMLOCK       = 69;
	public const int xKEY_SCROLL        = 70;
	public const int xKEY_NUMPAD7       = 71;
	public const int xKEY_NUMPAD8       = 72;
	public const int xKEY_NUMPAD9       = 73;
	public const int xKEY_SUBTRACT      = 74;
	public const int xKEY_NUMPAD4       = 75;
	public const int xKEY_NUMPAD5       = 76;
	public const int xKEY_NUMPAD6       = 77;
	public const int xKEY_ADD           = 78;
	public const int xKEY_NUMPAD1       = 79;
	public const int xKEY_NUMPAD2       = 80;
	public const int xKEY_NUMPAD3       = 81;
	public const int xKEY_NUMPAD0       = 82;
	public const int xKEY_DECIMAL       = 83;
	public const int xKEY_TILD          = 86;
	public const int xKEY_F11           = 87;
	public const int xKEY_F12           = 88;
	public const int xKEY_NUMPADENTER   = 156;
	public const int xKEY_RMENU         = 221;
	public const int xKEY_PAUSE         = 197;
	public const int xKEY_HOME          = 199;
	public const int xKEY_UP            = 200;
	public const int xKEY_PRIOR         = 201;
	public const int xKEY_LEFT          = 203;
	public const int xKEY_RIGHT         = 205;
	public const int xKEY_END           = 207;
	public const int xKEY_DOWN          = 208;
	public const int xKEY_NEXT          = 209;
	public const int xKEY_INSERT        = 210;
	public const int xKEY_DELETE        = 211;
	public const int xKEY_LWIN          = 219;
	public const int xKEY_RWIN          = 220;
	public const int xKEY_BACKSPACE     = KEY_BACK;
	public const int xKEY_NUMPADSTAR    = KEY_MULTIPLY;
	public const int xKEY_LALT          = 184;
	public const int xKEY_CAPSLOCK      = 58;
	public const int xKEY_NUMPADMINUS   = KEY_SUBTRACT;
	public const int xKEY_NUMPADPLUS    = KEY_ADD;
	public const int xKEY_NUMPADPERIOD  = KEY_DECIMAL;
	public const int xKEY_DIVIDE        = 181;
	public const int xKEY_NUMPADSLASH   = KEY_DIVIDE;
	public const int xKEY_RALT          = 56;
	public const int xKEY_UPARROW       = KEY_UP;
	public const int xKEY_PGUP          = KEY_PRIOR;
	public const int xKEY_LEFTARROW     = KEY_LEFT;
	public const int xKEY_RIGHTARROW    = KEY_RIGHT;
	public const int xKEY_DOWNARROW     = KEY_DOWN;
	public const int xKEY_PGDN          = KEY_NEXT;
}