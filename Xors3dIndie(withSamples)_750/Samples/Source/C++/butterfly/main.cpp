/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Butterfly sample, (c) 2010 XorsTeam              *
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
	xAppTitle("Butterfly");
	xGraphics3D(800, 600, 32, false, true);

	//creating the camera
	int camera = xCreateCamera();
	xPositionEntity(camera, 0, 70, -120);
	xRotateEntity(camera, 15, 0, 0);
	xCameraClsColor(camera, 192, 192, 192);

	//enabling antialiasing
	xAntiAlias(true);

	//objects loading
	int wings = xLoadMesh("../../../media/Meshes/ButterflyWings.b3d");
	xRotateEntity(wings, 0, 0, -90);
	int body = xLoadMesh("../../../media/Meshes/ButterflyBody.b3d");
	xRotateEntity(body, 0, 0, -90);

	//light source creating
	int light = xCreateLight();
	xRotateEntity(light, -45, 0, 0);

	//loading effect from file
	int butterfly = xLoadFXFile("../../../media/shaders/IridescentButterfly.fx");

	//checking if this technique is supported by hardware
	if(xValidateEffectTechnique(butterfly, "IridescentButterfly") == false)
	{
		MessageBox(NULL, L"Technique is not supported.", L"Error", MB_ICONERROR);
	}

	//loading textures
	int tex1 = xLoadTexture("../../../media/textures/gradientMap.bmp");
	int tex2 = xLoadTexture("../../../media/textures/baseOpacityMap.tga");
	int tex3 = xLoadTexture("../../../media/textures/bumpGlossMap.tga");

	//setting the effect and constants
	xSetEntityEffect(wings, butterfly);
	xSetEffectTechnique(wings, "IridescentButterfly");
	xSetEffectMatrixSemantic(wings, "world_view_proj_matrix", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(wings, "inv_view_matrix", VIEWINVERSE);
	xSetEffectTexture(wings, "baseOpacityMap_Tex", tex2);
	xSetEffectTexture(wings, "bumpGlossMap_Tex", tex3);
	xSetEffectTexture(wings, "gradientMap_Tex", tex1);
	xEntityAlpha(wings, 0.5);

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

		//setting the spectator's position
		xSetEffectVector(wings, "view_position", xEntityX(camera), xEntityY(camera), xEntityZ(camera));

		//rendering the world
		xRenderWorld();

		//fps output
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xColor(0, 0, 0);
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);

		//drawing
		xFlip();

	}
	return 0;
}