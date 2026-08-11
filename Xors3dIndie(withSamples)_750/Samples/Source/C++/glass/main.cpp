/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Glass sample, (c) 2010 XorsTeam                  *
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
	// set graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// create pivot
	int pivot = xCreatePivot();

	// create camera
	int camera = xCreateCamera(pivot);
	xCameraRange(camera, 0.9f, 3000.0f);
	xPositionEntity(camera, 0, 0, -120);
	xRotateEntity(camera, 0, 0, 0);

	// create scene
	int teapot = xLoadMesh("../../../media/meshes/teapot.b3d");
	xPositionEntity(teapot, 30, -15, 0);

	int sphere = xCreateSphere(30);
	xPositionEntity(sphere, -30, 0, 0);
	xScaleEntity(sphere, 20, 20, 20);

	// load cube texture
	int cubeTex = xLoadTexture("../../../media/textures/Snow.dds", 128);

	// create posteffect poly
	int poly = xCreatePostEffectPoly(camera, 1);

	// create textures
	int lowresTex = xCreateTexture(256, 256);
	int tempTex   = xCreateTexture(256, 256);
	int BBtex     = xCreateTexture(800, 600);

	// load glass shader
	int glassFX = xLoadFXFile("../../../media/shaders/Glass.fx");

	// create sky
	int sky = xCreateSphere();
	xFlipMesh(sky);
	xScaleEntity(sky, 500, 500, 500);
	xSetEntityEffect(sky, glassFX);
	xSetEffectTechnique(sky, "Sky");
	xSetEffectMatrixSemantic(sky, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(sky, "MatWorld", WORLD);
	xSetEffectTexture(sky, "tDiffuse", cubeTex);

	// setup glass shader
	xSetEntityEffect(teapot, glassFX);
	xSetEffectTechnique(teapot, "Diffuse");
	xSetEffectMatrixSemantic(teapot, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(teapot, "MatWorld", WORLD);
	xSetEffectTexture(teapot, "tDiffuse", cubeTex);

	xSetEntityEffect(sphere, glassFX);
	xSetEffectTechnique(sphere, "Diffuse");
	xSetEffectMatrixSemantic(sphere, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(sphere, "MatWorld", WORLD);
	xSetEffectTexture(sphere, "tDiffuse", cubeTex);

	// params
	bool enable      = true;
	float r          = 0.0f;
	float g          = 0.0f;
	float b          = 0.2f;
	float FallOffPow = 3.0f;

	// main loop
	while(!xKeyHit(1) || xWinMessage("WM_CLOSE"))
	{
		// camera controll
		if(xKeyDown(KEY_UP))    xTurnEntity(pivot,  1.0f,  0.0f, 0.0f, true);
		if(xKeyDown(KEY_DOWN))  xTurnEntity(pivot, -1.0f,  0.0f, 0.0f, true);
		if(xKeyDown(KEY_LEFT))  xTurnEntity(pivot,  0.0f,  1.0f, 0.0f, true);
		if(xKeyDown(KEY_RIGHT)) xTurnEntity(pivot,  0.0f, -1.0f, 0.0f, true);

		// glass color controll
		float cl = 0.01f;
		if(xKeyDown(KEY_Q)) r = r + cl;
		if(xKeyDown(KEY_A)) r = r - cl;
		if(xKeyDown(KEY_W)) g = g + cl;
		if(xKeyDown(KEY_S)) g = g - cl;
		if(xKeyDown(KEY_E)) b = b + cl;
		if(xKeyDown(KEY_D)) b = b - cl;
		if(r > 1.0f) r = 1.0f;
		if(r < 0.0f) r = 0.0f;
		if(g > 1.0f) g = 1.0f;
		if(g < 0.0f) g = 0.0f;
		if(b > 1.0f) b = 1.0f;
		if(b < 0.0f) b = 0.0f;

		// falloff controll
		cl = 0.03f;
		if(xKeyDown(KEY_R)) FallOffPow = FallOffPow + cl;
		if(xKeyDown(KEY_F)) FallOffPow = FallOffPow - cl;

		// update shader params
		xSetEffectVector(teapot, "view_position", xEntityX(camera, true), xEntityY(camera, true), xEntityZ(camera, true));
		xSetEffectVector(teapot, "FallOffCol", r, g, b, 1.0f);
		xSetEffectFloat(teapot,	 "FallOffPow", FallOffPow);

		// turn teapot
		xTurnEntity(teapot, 0, 1, 0);

		// render world
		xRenderWorld();

		// draw texts
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 30, buffer);
		sprintf(buffer, "r (Q\\A): %f g (W\\S): %f b (E\\D): %f", r, g, b);
		xText(10, 60, buffer);
		sprintf(buffer, "FallOffPow (R\\F): %f", FallOffPow);
		xText(10, 80, buffer);
		xText(10, 100, "Control: arrows");

		// draw scene
		xFlip();
	}
	return 0;
}