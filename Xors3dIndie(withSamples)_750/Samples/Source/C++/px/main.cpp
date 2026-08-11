/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Physics sample, (c) 2010 XorsTeam                *
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

// function to reset cubes positions
void ResetWall();

// function to shoot sphere
void ShootSphere(int camera);

// global variables
const float impulse  = 50.0f;
const int   wallSize = 5;
int wallBlocks[wallSize][wallSize][wallSize];

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(xGetMaxAntiAlias());

	// set application window caption
	xAppTitle("Physics sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, false);
	srand(timeGetTime());

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 0, 20, -100);

	// create ground
	int ground = xCreateCube();
	xPointEntity(camera, ground);
	xScaleEntity(ground, 100, 1, 100);
	xEntityAddBoxShape(ground, 0.0f);

	// loading logo from file
	int logoTexture = xLoadTexture("../../../media/textures/logo.jpg");

	// texture cube
	xEntityTexture(ground, logoTexture);

	// create wall
	for(int x = 0; x < wallSize; x++)
	{
		for(int y = 0; y < wallSize; y++)
		{
			for(int z = 0; z < wallSize; z++)
			{
				if(x == 0 && y == 0 && z == 0)
				{
					wallBlocks[x][y][z] = xCreateCube();
				}
				else
				{
					wallBlocks[x][y][z] = xCopyEntity(wallBlocks[0][0][0]);
				}
				xPositionEntity(wallBlocks[x][y][z], (x - wallSize / 2) * 2.0f, 2 + y * 2.0f, (z - wallSize / 2) * 2.0f);
				xEntityAddBoxShape(wallBlocks[x][y][z], 1.0f);
				xEntityTexture(wallBlocks[x][y][z], logoTexture);
			}
		}
	}

	// create light
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

		// shoot sphere
		if(xMouseHit(1)) ShootSphere(camera);
		if(xMouseHit(2)) xEntityApplyTorqueImpulse(wallBlocks[rand() % wallSize][rand() % wallSize][rand() % wallSize], 0.0f, 100.0f, 0.0f);

		// reset wall
		if(xKeyHit(KEY_SPACE)) ResetWall();

		// render scene
		xUpdateWorld();
		xRenderWorld();

		// FPS & rendered triangles counters
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);
		xText(10, 50, "Left mouse button to shoot, right mouse button to add torque for random cube, space to reset wall");

		// switch back buffer
		xFlip();
	}
	return 0;
}

// function to reset cubes positions
void ResetWall()
{
	for(int x = 0; x < wallSize; x++)
	{
		for(int y = 0; y < wallSize; y++)
		{
			for(int z = 0; z < wallSize; z++)
			{
				xPositionEntity(wallBlocks[x][y][z], (x - wallSize / 2) * 2.0f, 2 + y * 2.0f, (z - wallSize / 2) * 2.0f);
				xRotateEntity(wallBlocks[x][y][z], 0.0f, 0.0f, 0.0f);
				xEntityReleaseForces(wallBlocks[x][y][z]);
			}
		}
	}
}

// function to shoot sphere
void ShootSphere(int camera)
{
	int sphere = xCreateSphere();
	xPositionEntity(sphere, xEntityX(camera, true), xEntityY(camera, true), xEntityZ(camera, true));
	xEntityColor(sphere, 255, 0, 0);
	xEntityAddSphereShape(sphere, 1.0f, 1.0f);
	xTFormNormal(0.0f, 0.0f, 1.0f, camera, 0);
	xEntityApplyCentralImpulse(sphere, xTFormedX() * impulse, xTFormedY() * impulse, xTFormedZ() * impulse);
}