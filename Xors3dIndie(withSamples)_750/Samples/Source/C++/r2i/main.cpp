/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Render to image sample, (c) 2010 XorsTeam        *
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
	xAppTitle("Render to image");
	xGraphics3D(800, 600, 32, false, true);

	//creating the camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 15, 10, -100);

	//font loading
	int arial = xLoadFont("Arial", 12);

	//light source creating
	int light1 = xCreateLight(LIGHT_DIRECTIONAL);
	xRotateEntity(light1, -45, 0, 0);

	//creating the cube
	int cube = xCreateCube();
	xScaleEntity(cube, 10, 10, 10);

	//creating the image
	int image = xCreateImage(256, 256);

	//creating the sphere and hiding it
	int sphere = xCreateSphere();
	xScaleEntity(sphere, 10, 10, 10);
	xEntityShininess(sphere, 1);
	xEntityColor(sphere, 255, 0, 0);
	xHideEntity(sphere);

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
		//setting the image buffer as the render target
		xSetBuffer(xImageBuffer(image));

		//hiding the cube and unhiding the sphere
		xShowEntity(sphere);
		xHideEntity(cube);

		//buffer clearing
		xCameraClsColor(camera, 192, 192, 192);
		xCls();

		//rendering the world
		xRenderWorld();

		//hiding the sphere and unhiding the cube
		xHideEntity(sphere);
		xShowEntity(cube);

		//setting the backbuffer as a render target
		xSetBuffer(xBackBuffer());
		xCameraClsColor(camera, 0, 0, 0);

		/// camera control
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

		//drawing the image
		xDrawImage(image, 0, 0);

		//fps and triangle counter
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(650, 30, buffer);
		sprintf(buffer, "Polygons: %i", xTrisRendered());
		xText(650, 50, buffer);

		//drawing
		xFlip();
	}
	return 0;
}