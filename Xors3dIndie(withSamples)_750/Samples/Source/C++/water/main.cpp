/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Water sample, (c) 2010 XorsTeam                  *
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
void UpdateCubemap(int texture, int camera, int entity, int viewCamera);

// global variables
int frame = 0;

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	//initialization
	xAppTitle("Water");
	xGraphics3D(800, 600, 32, false, true);
	xCreateDSS(1024, 1024);

	//camera creating
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 10, -50);
	xRotateEntity(camera, 0, 180, 0);
	xCameraClsColor(camera, 192, 192, 192);
	int cubeMapCamera = xCreateCamera();
	xHideEntity(cubeMapCamera);
	xCameraClsMode(cubeMapCamera, false, true);
	xCameraZoom(cubeMapCamera, 0);

	//enabling antialiasing
	xAntiAlias(true);

	//objects loading
	int water = xLoadMesh("../../../media/meshes/water.b3d");
	xPositionEntity(water, 0, -5, -200);
	int scene = xLoadMesh("../../../media/meshes/level.b3d");

	//creating the light source
	int light = xCreateLight();
	xRotateEntity(light, -45, 0, 0);

	//loading the effect from file
	int waterFX = xLoadFXFile("../../../media/shaders/water.fx");

	//loading the textures
	int texEnv = xCreateTexture(512, 512, 128 + 48);
	int noise  = xLoadTexture("../../../media/textures/noise.dds", 1 + 512);

	//setting the effect and constants
	xSetEntityEffect(water, waterFX);
	xSetEffectTechnique(water, "Water");
	xSetEffectMatrixSemantic(water, "world_matrix", WORLD);
	xSetEffectMatrixSemantic(water, "view_proj_matrix", VIEWPROJ);
	xSetEffectTexture(water, "Noise_Tex", noise);
	xSetEffectTexture(water, "envBox_Tex", texEnv);

	unsigned int startTime = timeGetTime();
	xAmbientLight(150, 150, 150);
	xEntityAlpha(water, 0.9f);

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

		//if we can't see teapot then we won't update its texture
		if(xEntityInView(water, camera))
		{
			//updating the texture
			UpdateCubemap(texEnv, cubeMapCamera, water, camera);
		}

		//setting the constants
		float timeX = float(timeGetTime() - startTime) / 10000.0f;
		xSetEffectFloat(water, "time_0_X", timeX);
		xSetEffectFloat(water, "freq", float(timeGetTime()) / 1000.0f);
		xSetEffectVector(water, "view_position", xEntityX(camera, true), 2, xEntityZ(camera, true));

		//rendering the world
		xRenderWorld();

		//fps output
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);

		//drawing the scene
		xFlip();
	}
	return 0;
}

//function of texture updating
void UpdateCubemap(int texture, int camera, int entity, int viewCamera)
{

	//turning the main camera off
	xHideEntity(viewCamera);

	//getting size of the texture
	int size = xTextureWidth(texture);

	//turning the camera on
	xShowEntity(camera);

	//hiding the object so it won't be rendered to the texture
	xHideEntity(entity);

	//moving camera to the position of the object
	xPositionEntity(camera, xEntityX(viewCamera, true), xEntityY(entity, true) + 2, xEntityZ(viewCamera, true));
	frame = 1 - frame;

	//rendering to the texture
	if(frame)
	{
		//left plane
		xSetCubeFace(texture, 0);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, 0, 90, 0);
		xRenderWorld();

		//front plane
		xSetCubeFace(texture, 1);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, 0, 0, 0);
		xRenderWorld();

		//right plane
		xSetCubeFace(texture, 2);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, 0, -90, 0);
		xRenderWorld();
	}
	else
	{
		//back plane
		xSetCubeFace(texture, 3);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, 0, 180, 0);
		xRenderWorld();

		//top plane
		xSetCubeFace(texture, 4);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, -90, 0, 0);
		xRenderWorld();

		//bottom plane
		xSetCubeFace(texture, 5);
		xSetBuffer(xTextureBuffer(texture));
		xCameraViewport(camera, 0, 0, size, size);
		xRotateEntity(camera, 90, 0, 0);
		xRenderWorld();
	}
	
	//unhiding the object
	xShowEntity(entity);

	//turning the camera off
	xHideEntity(camera);

	//setting the render to backbuffer
	xSetBuffer(xBackBuffer());

	//turning the main camera on
	xShowEntity(viewCamera);
}