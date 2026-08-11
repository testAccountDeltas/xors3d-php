/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Instancing sample #2, (c) 2010 XorsTeam          *
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

// global variables
const int maxX = 20;
const int maxY = 20;
const int maxZ = 20;
int clones[maxX][maxY][maxZ];

// function for instances animation
void Wave();

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
	xCameraClsColor(camera, 192, 168, 132);

	// position camera
	xPositionEntity(camera, -90, 90, -40);

	// create object
	int obj = xCreateCylinder(32);
	xEntityColor(obj, 0, 0, 0);

	// loading logo from file
	int tex0 = xLoadTexture("../../../Media/Textures/tex0.png");
	int tex1 = xLoadTexture("../../../Media/Textures/tex1.png");

	// texture object
	xEntityTexture(obj, tex0);

	// load instancing shader
	int shader = 0;
	const char * instancingType = "Software emulation";
	if(xHWInstancingAvailable())
	{
		shader         = xLoadFXFile("../../../media/shaders/hwinstancing2.fx");
		instancingType = "Hardware";
	}
	else if(xShaderInstancingAvailable())
	{
		shader         = xLoadFXFile("../../../media/shaders/shaderinstancing.fx");
		instancingType = "Shaders emulation";
	}
	xSetEntityEffect(obj, shader);
	xSetEffectTechnique(obj, "Instancing");

	// create instances
	for(int x = 0; x < maxX; x++)
	{
		for(int y = 0; y < maxY; y++)
		{
			for(int z = 0; z < maxZ; z++)
			{
				clones[x][y][z] = xCreateInstance(obj);
				xPositionEntity(clones[x][y][z], x * 3.0f, y * 3.0f, z * 3.0f);
				xRotateEntity(clones[x][y][z], 90.0f / maxX * x, 90.0f / maxY * y, 90.0f / maxZ * z);
				xEntityColor(clones[x][y][z],  255   / maxX * x, 255   / maxY * y, 255   / maxZ * z);
			}
		}
	}

	// hide original entity
	xHideEntity(obj);

	// create light source
	int light = xCreateLight();
	xRotateEntity(light, 45, 0, 0);

	bool waving = true;

	// for mouse look
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
	float mousespeed       = 0.5;
	float camerasmoothness = 4.5;
	float mxs   =  0.0f;
	float mys   =  0.0f;
	float camxa = -60.0f;
	float camya =  25.0f;

	// main program loop
	while(!xKeyDown(KEY_ESCAPE))
	{
		// wave controll
		if(waving) Wave();
		if(xKeyHit(KEY_SPACE)) waving = !waving;

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
		sprintf(buffer,  "Entities: %i", maxX * maxY * maxZ);
		xText(10, 70, buffer);
		sprintf(buffer,  "Instncing type: %s", instancingType);
		xText(10, 90, buffer);

		// switch back buffer
		xFlip();
	}
	return 0;
}

void Wave()
{
	unsigned int time = timeGetTime();
	for(int x = 0; x < maxX; x++)
	{
		for(int y = 0; y < maxY; y++)
		{
			for(int z = 0; z < maxZ; z++)
			{
				float shift = float(x + y + z) / float(maxX + maxY + maxZ) * 360.0f;
				float scale = 1.0f + powf(sinf(float(time) / 700.0f + shift), 4.0f) / 2.0f;
				xScaleEntity(clones[x][y][z], scale, scale, scale);
			}
		}
	}
}