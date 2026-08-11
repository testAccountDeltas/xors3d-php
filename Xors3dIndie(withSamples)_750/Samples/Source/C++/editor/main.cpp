/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Editor sample, (c) 2010 XorsTeam                 *
 * www: http://xors3d.com                                          *
 * e-mail: support@xors3d.com                                      *
 *                                                                 *
 *******************************************************************/

// include Xors3d Engine header
#include <xors3d.h>
#include <iostream>
#include <math.h>

// global variables
float        controllPosX    = 0.0f;
float        controllPosY    = 0.0f;
float        controllPosZ    = 0.0f;
int          mouseSpeedX     = 0;
int          mouseSpeedY     = 0;
const char * used_controller = "";

float ComputeMove(int camera, float x, float y, float z);

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(xGetMaxAntiAlias());

	// set application's title
	xAppTitle("Editor sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();
	xCameraClsColor(camera, 192, 192, 192);
	xPositionEntity(camera, 10,  10,  10);

	// create light
	int light = xCreateLight();

	// create cube
	int cube = xCreateCube();
	xPointEntity(camera, cube);

	// loading logo from file
	int logoTexture = xLoadTexture("../../../media/textures/logo.jpg");

	// texture cube
	xEntityTexture(cube, logoTexture);

	// gizmos' data
	int controlType   = 0; /// 0 - move, 1 - rotate, 2 - scale 
	int selectMask    = 0;
	float deltaX      = 1.0f;
	float deltaY      = 1.0f;
	float deltaZ      = 1.0f;
	float scaleXInit  = 1.0f;
	float scaleYInit  = 1.0f;
	float scaleZInit  = 1.0f;

	// main program loop
	while(!xKeyDown(KEY_ESCAPE))
	{
		xColor(100, 0, 0);
		mouseSpeedX = xMouseXSpeed();
		mouseSpeedY = xMouseYSpeed();

		// camera control
		if(xKeyDown(KEY_W)) xMoveEntity(camera,  0,  0,  1);
		if(xKeyDown(KEY_S)) xMoveEntity(camera,  0,  0, -1);
		if(xKeyDown(KEY_A)) xMoveEntity(camera, -1,  0,  0);
		if(xKeyDown(KEY_D)) xMoveEntity(camera,  1,  0,  0);
		if(xKeyHit(KEY_1))  controlType = 0;
		if(xKeyHit(KEY_2))  controlType = 1;
		if(xKeyHit(KEY_3))  controlType = 2;

		// render scene
		xRenderWorld();

		// draw grid
		xDrawGrid(0, 0, 5, 100);

		// draw gizmos
		float x = xEntityX(cube);
		float y = xEntityY(cube);
		float z = xEntityZ(cube);
		switch(controlType)
		{
			case 0:
			{
				int mask = xCheckMovementGizmo(x, y, z, camera, xMouseX(), xMouseY());
				if(!xMouseDown(1))
				{
					selectMask   = mask;
					controllPosX = x;
					controllPosY = y;
					controllPosZ = z;
				}
				xDrawMovementGizmo(x, y, z, selectMask);
				used_controller = "Used move controler";
			}
			break;
			case 1:
			{
				int mask = xCheckRotationGizmo(x, y, z, camera, xMouseX(), xMouseY());
				if(!xMouseDown(1))
				{
					selectMask   = mask;
					controllPosX = x;
					controllPosY = y;
					controllPosZ = z;
					deltaX       = 0.0f;
					deltaY       = 0.0f;
					deltaZ       = 0.0f;
				}
				xDrawRotationGizmo(x, y, z, selectMask, deltaX, deltaY, deltaZ);
				used_controller = "Used rotate controler";
			}
			break;
			case 2:
			{
				int mask = xCheckScaleGizmo(x, y, z, camera, xMouseX(), xMouseY());
				if(!xMouseDown(1))
				{
					selectMask   = mask;
					controllPosX = x;
					controllPosY = y;
					controllPosZ = z;
					deltaX       = 1.0f;
					deltaY       = 1.0f;
					deltaZ       = 1.0f;
					scaleXInit   = xEntityScaleX(cube);
					scaleYInit   = xEntityScaleY(cube);
					scaleZInit   = xEntityScaleZ(cube);
				}
				xDrawScaleGizmo(x, y, z, selectMask, deltaX, deltaY, deltaZ);
				used_controller = "Used scale controler";
			}
			break;
			default: used_controller = "";
		}

		// object control
		if(xMouseDown(1) && selectMask != 0)
		{
			bool useX     = (selectMask & 1) > 0;
			bool useY     = (selectMask & 2) > 0;
			bool useZ     = (selectMask & 4) > 0;
			bool useG     = (selectMask & 8) > 0;
			float factorX = 0.7f / float(xGraphicsWidth());
			float factorY = 0.7f / float(xGraphicsHeight());
			switch(controlType)
			{
				// if movement gizmo is used
				case 0:
				{
					// move controlled entity
					float dx   = controllPosX - xEntityX(camera, true);
					float dy   = controllPosY - xEntityY(camera, true);
					float dz   = controllPosZ - xEntityZ(camera, true);
					float dist = sqrtf(dx * dx + dy * dy + dz * dz);
					// x-axis
					if(useX)
					{
						float move = ComputeMove(camera, 10.0f, 0.0f, 0.0f) * factorX * dist;
						xTranslateEntity(cube, move, 0.0f, 0.0f, false);
					}
					// y-axis
					if(useY)
					{
						float move = ComputeMove(camera, 0.0f, 10.0f, 0.0f) * factorY * dist;
						xTranslateEntity(cube, 0.0f, move, 0.0f, false);
					}
					// z-axis
					if(useZ)
					{
						float move = ComputeMove(camera, 0.0f, 0.0f, 10.0f) * factorX * dist;
						xTranslateEntity(cube, 0.0f, 0.0f, move, false);
					}
				}
				break;
				// if scaling gizmo is used
				case 2:
				{
					// scale controlled entity
					float dx   = controllPosX - xEntityX(camera, true);
					float dy   = controllPosY - xEntityY(camera, true);
					float dz   = controllPosZ - xEntityZ(camera, true);
					float dist = sqrtf(dx * dx + dy * dy + dz * dz);
					// x-axis
					if(useX)
					{
						float move = ComputeMove(camera, 10.0f, 0.0f, 0.0f) * factorX * dist;
						deltaX     = deltaX     + move;
						scaleXInit = scaleXInit + move;
						xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit);
					}
					// y-axis
					if(useY)
					{
						float move = ComputeMove(camera, 0.0f, 10.0f, 0.0f) * factorY * dist;
						deltaY     = deltaY     + move;
						scaleYInit = scaleYInit + move;
						xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit);
					}
					// z-axis
					if(useZ)
					{
						float move = ComputeMove(camera, 0.0f, 0.0f, 10.0f) * factorX * dist;
						deltaZ     = deltaZ     + move;
						scaleZInit = scaleZInit + move;
						xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit);
					}
				}
				break;
				// if rotation gizmo is used
				case 1:
				{
					// rotate controlled entity
					// x-axis
					if(useX)
					{
						float move = ComputeMove(camera, 0.0f, -10.0f, 0.0f);
						deltaX     = deltaX + move;
						xTurnEntity(cube, move, 0.0f, 0.0f, true);
					}
					// y-axis
					if(useY)
					{
						float move = ComputeMove(camera, -10.0f, -10.0f, 0.0f);
						deltaY     = deltaY + move;
						xTurnEntity(cube, 0.0f, move, 0.0f, true);
					}
					// z-axis
					if(useZ)
					{
						float move = ComputeMove(camera, -10.0f, 0.0f, 0.0f);
						deltaZ     = deltaZ + move;
						xTurnEntity(cube, 0.0f, 0.0f, move, true);
					}
				}
				break;
			}
		}

		// draw info
		xText(10, 10, "Use WSAD to move camera around scene");
		xText(10, 30, "Use 1, 2, 3 to change object controler");
		xText(10, 50, used_controller);

		// switch back buffer
		xFlip();
	}
	return 0;
}

float ComputeMove(int camera, float x, float y, float z)
{
	if(mouseSpeedX == 0 && mouseSpeedY == 0) return 0.0f;
	// project axis on the screen
	xCameraProject(camera, controllPosX, controllPosY, controllPosZ);
	float x1 = xProjectedX();
	float y1 = xProjectedY();
	xCameraProject(camera, controllPosX + x, controllPosY + y, controllPosZ + z);
	float x2 = xProjectedX();
	float y2 = xProjectedY();
	// compute angle between our vectors
	float dx1    = x2 - x1;
	float dy1    = y2 - y1;
	float dx2    = mouseSpeedX;
	float dy2    = mouseSpeedY;
	float len1   = sqrtf(dx1 * dx1 + dy1 * dy1);
	float len2   = sqrtf(dx2 * dx2 + dy2 * dy2);
	float angle  = acosf((dx1 * dx2 + dy1 * dy2) / (len1 * len2));
	// compute distance
	float radii  = sqrtf(dx2 * dx2 + dy2 * dy2);
	// compute a new vector's x-component
	return radii * cosf(angle);
}