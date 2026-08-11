/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Clipplane sample, (c) 2010 XorsTeam              *
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
	//initialization
	xAppTitle("Clipplane");
	xGraphics3D(800, 600, 32, false, true);

	//enabling antialiasing
	xAntiAlias(true);

	//setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPIC);

	//creating the camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 20, 30);
	xRotateEntity(camera, 0, 180, 0);
	xCameraClsColor(camera, 92, 192, 255);
	xCameraRange(camera, 0.1, 1000);

	//font loading
	int arial = xLoadFont("Arial", 12);

	//light source creating
	int light1 = xCreateLight(LIGHT_DIRECTIONAL);
	xRotateEntity(light1, -45, 0, 0);

	int level = xLoadMesh("../../../media/Meshes/level.b3d");

	//setting the clipplane
	xCameraClipPlane(camera, 0, true, 0, 1, 0, 0);
	int pivot = xCreatePivot();

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
		// turn clipplane
		xTurnEntity(pivot, 0, 0, 0.1);
		xTFormPoint(0, 1, 0, pivot, 0);
		xCameraClipPlane(camera, 0, true, xTFormedX(), xTFormedY(), xTFormedZ(), 30);

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

		//updating and rendering the world
		xUpdateWorld();
		xRenderWorld();

		//fps and triangle counters
		char buffer[128];
		xColor(255, 0, 0);
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "Polygons: %i", xTrisRendered());
		xText(10, 30, buffer);

		//drawing the scene
		xFlip();
	}
	return 0;
}