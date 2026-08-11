/*******************************************************************
 *                                                                 *
 * Xors3D Engine. FX file sample, (c) 2010 XorsTeam                *
 * www: http://xors3d.com                                          *
 * e-mail: support@xors3d.com                                      *
 *                                                                 *
 *******************************************************************/

// include Xors3d Engine header
#include <xors3d.h>
#include <iostream>
#include <math.h>

// for camera mouse look
float CurveValue(float newvalue, float oldvalue, float increments)
{
	if(increments >  1.0f) oldvalue = oldvalue - (oldvalue - newvalue) / increments;
	if(increments <= 1.0f) oldvalue = newvalue; 
	return oldvalue;
}

//function of texture updating
void UpdateCubemap(int texture, int camera, int entity);

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	//initialization
	xAppTitle("FX File");
	xGraphics3D(800, 600, 32, false, true);

	//creating the camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 0,   30,  -120);
	xCameraClsColor(camera, 192, 192,  192);
	int cubeMapCamera = xCreateCamera();
	xCameraZoom(cubeMapCamera, 0.5f);

	//enabling antialiasing
	xAntiAlias(true);

	//setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPIC);

	//objects loading
	int teapot = xLoadMesh("../../../media/meshes/teapot.b3d");
	xPositionEntity(teapot, 0, 10, -50);
	int scene = xLoadMesh("../../../media/meshes/level.b3d");

	//light source creating
	int light = xCreateLight();
	xRotateEntity(light, -45, 0, 0);

	//loading effect from file
	int bumpyGlossyMetal = xLoadFXFile("../../../media/shaders/BumpyGlossyMetal.fx");

	//texture loading
	int texColor  = xLoadTexture("../../../media/textures/stones.bmp");
	int texNormal = xLoadTexture("../../../media/textures/bump_map.bmp");
	int texGloss  = xLoadTexture("../../../media/textures/bump_map.bmp");
	int texEnv    = xCreateTexture(256, 256, 1 + 128);

	//setting the effect and constants
	xSetEntityEffect(teapot, bumpyGlossyMetal);
	xSetEffectTechnique(teapot, "Main");
	xSetEffectMatrixSemantic(teapot, "WorldITXf", WORLDINVERSETRANSPOSE);
	xSetEffectMatrixSemantic(teapot, "WVPXf", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(teapot, "WorldXf", WORLD);
	xSetEffectMatrixSemantic(teapot, "ViewIXf", VIEWINVERSE);
	xSetEffectTexture(teapot, "colorTexture", texColor);
	xSetEffectTexture(teapot, "normalTexture", texNormal);
	xSetEffectTexture(teapot, "glossTexture", texGloss);
	xSetEffectTexture(teapot, "envTexture", texEnv);
	xSetEffectFloat(teapot, "Bumpy", 2);

	// for mouse look
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
	float mousespeed       = 0.5;
	float camerasmoothness = 4.5;
	float mxs   = 0.0f;
	float mys   = 0.0f;
	float camxa = 0.0f;
	float camya = 0.0f;

	// main program loop
	while(!xKeyDown(KEY_ESCAPE))
	{
		// camera control
		if(xKeyDown(KEY_W)) xMoveEntity(camera,  0,  0,  1);
		if(xKeyDown(KEY_S)) xMoveEntity(camera,  0,  0, -1);
		if(xKeyDown(KEY_A)) xMoveEntity(camera, -1,  0,  0);
		if(xKeyDown(KEY_D)) xMoveEntity(camera,  1,  0,  0);
		mxs   = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness);
		mys   = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness);
		camxa = fmodf(camxa - mxs, 360.0f);
		camya = camya + mys;
		if(camya < -89.0f) camya = -89.0f;
		if(camya >  89.0f) camya =  89.0f;
		xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
		xRotateEntity(camera, camya, camxa, 0.0);

		// rotate teapot
		xTurnEntity(teapot, 0, 1, 0);

		//if we can't see teapot then we won't update its texture
		if(xEntityInView(teapot, camera))
		{
			//turning the main camera off 
			xHideEntity(camera);
			//updating the texture
			UpdateCubemap(texEnv, cubeMapCamera, teapot);
			//turning the main camera on
			xShowEntity(camera);
		}

		//rendering the world
		xRenderWorld();

		//fps output
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);

		//drawing
		xFlip();
	}
	return 0;
}

//function of texture updating
void UpdateCubemap(int texture, int camera, int entity)
{
	//getting size of the texture
	int size = xTextureWidth(texture);

	//turning camera on
	xShowEntity(camera);

	//hiding the object so it won't be rendered to its own texture
	xHideEntity(entity);

	//moving camera to the position of the object
	xPositionEntity(camera, xEntityX(entity, true), xEntityY(entity, true), xEntityZ(entity, true));

	xCameraClsMode(camera, false, true);

	//changing the size of viewport according to the size of the texture
	xCameraViewport(camera, 0, 0, size, size);

	//rendering to the texture

	//left plane
	xSetCubeFace(texture, 0);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, 0, 90, 0);
	xRenderWorld();

	//front plane
	xSetCubeFace(texture, 1);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, 0, 0, 0);
	xRenderWorld();

	//right plane
	xSetCubeFace(texture, 2);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, 0, -90, 0);
	xRenderWorld();

	//back plane
	xSetCubeFace(texture, 3);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, 0, 180, 0);
	xRenderWorld();

	//top plane
	xSetCubeFace(texture, 4);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, -90, 0, 0);
	xRenderWorld();

	//bottom plane
	xSetCubeFace(texture, 5);
	xSetBuffer(xTextureBuffer(texture));
	xRotateEntity(camera, 90, 0, 0);
	xRenderWorld();

	//unhiding the object
	xShowEntity(entity);

	//hiding the camera
	xHideEntity(camera);

	//setting the render to backbuffer
	xSetBuffer(xBackBuffer());
}