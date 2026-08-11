/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Backbuffer strech sample, (c) 2010 XorsTeam      *
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
	xAppTitle("Stretch Back buffer");
	xGraphics3D(800, 600, 32, false, true);

	// create light
	int light = xCreateLight();
	xRotateEntity(light, -40, 40, 40);

	// set texture filtering 
	xSetTextureFiltering(TF_ANISOTROPIC);

	// create camera
	int camera = xCreateCamera();
	xCameraClsColor(camera, 192, 192, 192);
	xPositionEntity(camera, 0, 10, -80);


	// loading textures
	int load_tex   = xLoadTexture("../../../media/textures/bricks.jpg");
	//create texture to copying back buffer
	int BB_tex = xCreateTexture(800, 600);

	// create cubes
	int cube1 = xCreateCube();
	xScaleEntity(cube1, 10, 10, 10);
	xPositionEntity(cube1, 20, 0, 0);
	xEntityTexture(cube1, BB_tex);
	int cube2 = xCreateCube();
	xScaleEntity(cube2, 10, 10, 10);
	xPositionEntity(cube2, -20, 0, 0);
	xEntityTexture(cube2, load_tex);
	int cube3 =  xCreateCube();
	xScaleEntity(cube3, 10, 10, 10);
	xPositionEntity(cube3, 0, 30, 0);
	xEntityTexture(cube3, load_tex);

	// loading font
	int arial = xLoadFont("Arial", 12);

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

		//turn cube
		xTurnEntity(cube1, 0, -1, 0);

		// render scene
		xCameraClsColor(camera, 0, 0, 0);
		xRenderWorld();

		// copy BB to texture "BB_tex"
		xStretchBackBuffer(BB_tex, 0, 0, 800, 600, 0);
		xCameraClsColor(camera, 192, 192, 192);

		//render and update world
		xUpdateWorld();
		xRenderWorld();

		//draw text
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "Polygons: %i", xTrisRendered());
		xText(10, 30, buffer);

		// draw scene
		xFlip();
	}
	return 0;
}