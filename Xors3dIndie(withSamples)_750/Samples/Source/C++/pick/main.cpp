/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Pick sample, (c) 2010 XorsTeam                   *
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
	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// create camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 2, -10);

	// create light
	int light = xCreateLight();
	xRotateEntity(light, 45, 45, 45);

	// create cube
	int cube = xCreateCube();
	xEntityPickMode(cube, 2); // Make the cube entity 'pickable'. Use pick_geometry mode no.2 for polygon collision. 
	xPositionEntity(cube, 0, 0, 0); 
	xRotateEntity(cube, 0, 45, 0);

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

		// If left mouse button is hitted then use CameraPick with mouse coordinates 
		// only three things can be picked in this example: the plane, the cube or nothing 
		if(xMouseHit(1)) xCameraPick(camera, xMouseX(), xMouseY());

		// render scene
		xRenderWorld();

		// draw picking info
		char buffer[128];
		xText(0, 20, "Use cursor keys to move");
		xText(0, 40, "Press left mouse button to use CameraPick with mouse coordinates");
		sprintf(buffer, "PickedX: %f", xPickedX());
		xText(0, 60, buffer);
		sprintf(buffer, "PickedY: %f", xPickedY());
		xText(0, 80, buffer);
		sprintf(buffer, "PickedZ: %f", xPickedZ());
		xText(0, 100, buffer);
		sprintf(buffer, "PickedNX: %f", xPickedNX());
		xText(0, 120, buffer);
		sprintf(buffer, "PickedNY: %f", xPickedNY());
		xText(0, 140, buffer);
		sprintf(buffer, "PickedNZ: %f", xPickedNZ());
		xText(0, 160, buffer);
		sprintf(buffer, "PickedTime: %i", xPickedTime());
		xText(0, 180, buffer);
		sprintf(buffer, "PickedEntity: 0x%.8X", xPickedEntity());
		xText(0, 200, buffer);
		sprintf(buffer, "PickedSurface: %i", xPickedSurface());
		xText(0, 220, buffer);
		sprintf(buffer, "PickedTriangle: %i", xPickedTriangle());
		xText(0, 240, buffer);
		sprintf(buffer, "xMouseX: %i", xMouseX());
		xText(0, 280, buffer);
		sprintf(buffer, "xMouseY: %i", xMouseY());
		xText(0, 300, buffer);

		// draw scene
		xFlip();
	}
	return 0;
}