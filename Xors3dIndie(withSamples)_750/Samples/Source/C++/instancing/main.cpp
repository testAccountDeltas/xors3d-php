/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Instancing sample, (c) 2010 XorsTeam             *
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

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(xGetMaxAntiAlias());

	// set application window caption
	xAppTitle("Instancing sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, false);

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 13, 13, -50);

	// create cube
	int cube = xCreateCube();

	// loading logo from file
	int logoTexture = xLoadTexture("../../../media/textures/logo.jpg");

	// texture cube
	xEntityTexture(cube, logoTexture);

	// load instancing shader
	int shader = 0;
	const char * instancingType = "Software emulation";
	if(xHWInstancingAvailable())
	{
		shader         = xLoadFXFile("../../../media/shaders/hwinstancing.fx");
		instancingType = "Hardware";
	}
	else if(xShaderInstancingAvailable())
	{
		shader         = xLoadFXFile("../../../media/shaders/shaderinstancing.fx");
		instancingType = "Shaders emulation";
	}
	xSetEntityEffect(cube, shader);
	xSetEffectTechnique(cube, "Instancing");

	// create cube instances
	for(int x = 0; x < 10; x++)
	{
		for(int y = 0; y < 10; y++)
		{
			for(int z = 0; z < 10; z++)
			{
				int clone = xCreateInstance(cube);
				xPositionEntity(clone, x * 3.0f, y * 3.0f, z * 3.0f);
			}
		}
	}

	// hide original entity
	xHideEntity(cube);

	// create light source
	int light = xCreateLight();
	xRotateEntity(light, 45, 0, 0);

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

		// render scene
		xRenderWorld();

		// draw info
		char buffer[128];
		sprintf(buffer,  "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer,  "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);
		sprintf(buffer,  "DIP calls: %i", xDIPCounter());
		xText(10, 50, buffer);
		sprintf(buffer,  "Instncing type: %s", instancingType);
		xText(10, 70, buffer);

		// switch back buffer
		xFlip();
	}
	return 0;
}