/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Army sample, (c) 2010 XorsTeam                   *
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
	xAppTitle("Army sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, false);
	xSetEngineSetting("LoadMesh::RelativePaths", "false");
	srand(timeGetTime());

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 0, 2, -5);

	// set this to true to use software skinning
	const bool forceSoftware = false;

	// if shaders are supported (their version is greater than or equal to 1.1)
	// then use them for hardware skinning, else use software skinning
	if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
	{
		xSetSkinningMethod(SKIN_HARDWARE);
	}
	else
	{
		xSetSkinningMethod(SKIN_SOFTWARE);
	}

	// if we use hardware skinning
	int shader = 0;
	if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
	{
		// load shader
		shader = xLoadFXFile("../../../media/shaders/skinning.fx");
	}

	// create units
	int animIndle  = 1;
	int animRun    = 2;
	int animAttack = 3;
	int units[300];
	int unitCnt = 0;
	int lastx = 0;
	int lasty = 0;
	for(int y = 0; y < 1; y++)
	{
		for(int x = 0; x < 10; x++)
		{
			if(y * 10 + x == 0)
			{
				// loading skinned mesh
				units[0] = xLoadAnimMesh("../../../media/meshes/hazar.b3d");
				// extract animation sequences
				xExtractAnimSeq(units[0], 2, 4);
				xExtractAnimSeq(units[0], 20, 59);
				xExtractAnimSeq(units[0], 99, 129);
			}
			else if(y * 10 + x == 1)
			{
				// loading skinned mesh
				units[1] = xLoadAnimMesh("../../../media/meshes/kuznec.b3d");
				// extract animation sequences
				xExtractAnimSeq(units[1], 2, 4);
				xExtractAnimSeq(units[1], 20, 59);
				xExtractAnimSeq(units[1], 99, 129);
			}
			else
			{
				units[y * 10 + x] = xCopyEntity(units[rand() % 2]);
			}
			xRotateEntity(units[y * 10 + x], 0, 180, 0);
			xPositionEntity(units[y * 10 + x], x * 2 - 9, 0, y * 2);
			int   seq   = (rand() % 3) + 1;
			float speed = (seq == 1 ? 0.1f : 1.0f);
			xAnimate(units[y * 10 + x], 1, speed, seq);
			// if we use hardware skinning
			if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
			{
				// assign it to mesh
				xSetEntityEffect(units[y * 10 + x], shader);
				// setup constant name for bones matrices
				xSetBonesArrayName(units[y * 10 + x], "bonesMatrixArray");
				// setup technique
				xSetEffectTechnique(units[y * 10 + x], "Skinned");
			}
			unitCnt++;
			lastx = x;
			lasty = y;
		}
	}

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

		// add a new unit
		if(xKeyHit(KEY_SPACE))
		{
			unitCnt++;
			lastx = lastx + 1;
			if(lastx > 9)
			{
				lastx = 0;
				lasty++;
			}
			units[lasty * 10 + lastx] = xCopyEntity(units[rand() % 2]);
			xRotateEntity(units[lasty * 10 + lastx], 0, 180, 0);
			xPositionEntity(units[lasty * 10 + lastx], lastx * 2 - 9, 0, lasty * 2);
			int   seq   = (rand() % 3) + 1;
			float speed = (seq == 1 ? 0.1f : 1.0f);
			xAnimate(units[lasty * 10 + lastx], 1, speed, seq);
			// if we use hardware skinning
			if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
			{
				// assign it to mesh
				xSetEntityEffect(units[lasty * 10 + lastx], shader);
				// setup constant name for bones matrices
				xSetBonesArrayName(units[lasty * 10 + lastx], "bonesMatrixArray");
				// setup technique
				xSetEffectTechnique(units[lasty * 10 + lastx], "Skinned");
			}
		}

		// update animations
		xUpdateWorld();

		// render scene
		xRenderWorld();

		// draw text
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);
		sprintf(buffer, "Units: %i", unitCnt);
		xText(10, 50, buffer);
		xText(10, 70, "SPACE - Add new unit");

		// switch back buffer
		xFlip();
	}
	return 0;
}