/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Meshes intersect sample, (c) 2010 XorsTeam       *
 * www: http://xors3d.com                                          *
 * e-mail: support@xors3d.com                                      *
 *                                                                 *
 *******************************************************************/

// include Xors3d Engine header
#include <xors3d.h>
#include <iostream>

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(xGetMaxAntiAlias());

	// set application window caption
	xAppTitle("Mesh intersect sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// create camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 2, -20);

	// create light
	int light = xCreateLight(LIGHT_DIRECTIONAL);
	xRotateEntity(light, -20, 0, 0);

	// create cone
	int cone = xCreateCone();

	// create cube
	int cube = xCreateCube();
	xPositionEntity(cube, -3, 0, 0);
	xRotateEntity(cube, 0, 0, 0);


	// main program loop
	while(!xKeyDown(1) || xWinMessage("WM_CLOSE"))
	{
		// if meshes inersection detected
		if(xMeshesIntersect(cube, cone))
		{
			xEntityColor(cone, 0, 200,0);
		}
		else
		{
			xEntityColor(cone, 255, 255,255);
		}

		// Move cube
		if(xKeyDown(KEY_W)) xMoveEntity(cube,  0.0f,  0.1f, 0.0f);
		if(xKeyDown(KEY_S)) xMoveEntity(cube,  0.0f, -0.1f, 0.0f);
		if(xKeyDown(KEY_A)) xMoveEntity(cube, -0.1f,  0.0f, 0.0f);
		if(xKeyDown(KEY_D)) xMoveEntity(cube,  0.1f,  0.0f, 0.0f);

		// render scene
		xRenderWorld();

		// draw text
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 30, buffer);
		xText(10, 50, "W/A/S/D - Move Cube");

		// switch back buffer
		xFlip();
	}
	return 0;
}