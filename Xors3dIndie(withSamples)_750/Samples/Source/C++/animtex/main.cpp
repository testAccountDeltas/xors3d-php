/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Animated texture sample, (c) 2010 XorsTeam       *
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
	// initialization
	xAppTitle("Animation texture");
	xGraphics3D(800, 600, 32, false, true);

	// enabling antialiasing
	xAntiAlias(true);

	// setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPIC);

	// camera creating
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 10, -170);

	// light source creating
	int light = xCreateLight();
	xRotateEntity(light, -45, 0, 0);

	// creating of the cube
	int cube = xCreateCube();

	// animated texture loading
	xScaleEntity(cube, 20, 20, 20);
	int anim_tex = xLoadAnimTexture("../../../media/textures/boomstrip.bmp", 1, 64, 64, 0, 39);

	// setting the colour of camera clearing
	xCameraClsColor(camera, 192, 192, 192);

	// font loading
	int arial = xLoadFont("Arial", 12);

	// main loop
	while(!xKeyDown(1) || xWinMessage("WM_CLOSE"))
	{
		// counting for changing texture frame
		int frame = timeGetTime() / 50 % 39;

		// putting texture on the cube
		xEntityTexture(cube, anim_tex, frame);

		// cube rotation
		float pitch = 0.0f;
		float yaw   = 0.0f;
		float roll  = 0.0f;
		if(xKeyDown(208)) pitch = -1.0f;
		if(xKeyDown(200)) pitch =  1.0f;
		if(xKeyDown(203)) yaw   = -1.0f;
		if(xKeyDown(205)) yaw   =  1.0f;
		if(xKeyDown(45))  roll  = -1.0f;
		if(xKeyDown(44))  roll  =  1.0f;
		xTurnEntity(cube, pitch, yaw, roll);

		// rendering of the world
		xRenderWorld();

		// fps counter and debug info
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xColor(0, 0, 0);
		xText(10, 10, buffer);
		xText(10, 30, "Up\\Down\\Left\\Right\\Z\\X - rotate cube");

		// drawing the scene
		xFlip();
	}
	return 0;
}