/*******************************************************************
 *                                                                 *
 * Xors3D Engine. DOF sample, (c) 2010 XorsTeam                    *
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

// Function for sky box creating
int CreateSkyBox(const char * skyPath);

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// set graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// create camera
	int camera = xCreateCamera();
	xCameraRange(camera, 0.9f, 3000.0f);
	xPositionEntity(camera, 30, 100, -480);
	xRotateEntity(camera, 10, 0, 0);

	// create scene
	int teapot = xLoadMesh("../../../media/meshes/teapot.b3d");
	xPositionEntity(teapot, 0, 0, 5);
	xScaleEntity(teapot, 2, 2, 2);
	int tex1 = xLoadTexture("../../../media/textures/tex_bloom.jpg");
	xEntityTexture(teapot, tex1);

	// create light
	int light = xCreateLight();

	// create posteffect quad
	int poly = xCreatePostEffectPoly(camera, 1);
	// low resolution texture
	int lowresTex = xCreateTexture(256, 256);
	int tempTex   = xCreateTexture(256, 256);
	// screen texture
	int BBtex = xCreateTexture(800, 600);

	// load DOF shader
	int DOF_shader = xLoadFXFile("../../../media/shaders/DOF.fx");

	// setup shader
	xSetEntityEffect(teapot, DOF_shader);
	xSetEffectTechnique(teapot, "Diffuse");
	xSetEffectMatrixSemantic(teapot, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(teapot, "MatView", WORLDVIEWPROJ);
	xSetEffectTexture(teapot, "tDiffuse", tex1);

	// copy teapots
	int teapot1 = xCopyEntity(teapot);
	xPositionEntity(teapot1, 0, 0, 300);
	xScaleEntity(teapot1, 2, 2, 2);
	int teapot2 = xCopyEntity(teapot);
	xPositionEntity(teapot2, 0, 0, -300);
	xScaleEntity(teapot2, 2, 2, 2);

	// setup post effect poly shader
	xSetEntityEffect(poly, DOF_shader);
	xSetEffectTechnique(poly, "DownPass");
	xSetEffectMatrixSemantic(poly, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(poly, "MatView", WORLDVIEWPROJ);
	xSetEffectTexture(poly, "tDiffuse", tex1);
	xSetEffectTexture(poly, "tEmissive", lowresTex);
	xSetEffectTexture(teapot, "tBB", BBtex);

	// sky
	int sky = CreateSkyBox("../../../media/textures/skybox1/");
	xScaleEntity(sky, 1000, 500, 1000);
	xPositionEntity(sky, 0, 200, 0);
	xSetEntityEffect(sky, DOF_shader);
	xSetEffectTechnique(sky, "Diffuse");
	xSetEffectMatrixSemantic(sky, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectMatrixSemantic(sky, "MatView", WORLDVIEWPROJ);

	// params
	bool enable = true;

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

		// turn teapot
		xTurnEntity(teapot, 0, 1, 0);

		// switch DOF
		if(xKeyHit(KEY_SPACE)) enable = !enable;

		//render to screen texture
		xSetBuffer(xTextureBuffer(BBtex));
		xRenderWorld();
		xSetBuffer(xBackBuffer());

		//copy screen texture in low resolution
		xStretchRect(BBtex, 0, 0, 800, 600, lowresTex, 0, 0, 256, 256, 0);                                                

		// DOF
		if(enable == true)
		{
			//Down sampler
			xSetEffectTechnique(poly, "DownPass");
			xRenderPostEffect(poly);
			xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0);
			//Gausian blur 1
			xSetEffectTechnique(poly, "Gaus1");
			xRenderPostEffect(poly);
			xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0);
			//Gausian blur 2
			xSetEffectTechnique(poly, "Gaus2");
			xRenderPostEffect(poly);
			xStretchBackBuffer(lowresTex, 0, 0, 256, 256, 0);
			//DOF 1
			xSetEffectTechnique(poly, "DOF1");
			xRenderPostEffect(poly);
		}
		else
		{
			xRenderWorld();
		}

		// draw texts
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 30, buffer);
		xText(10, 50, "Spase - enable\\disable DOF");

		// draw scene
		xFlip();
	}
	return 0;
}

int CreateSkyBox(const char * skyPath)
{
	int skybox = xCreateMesh();
	// Left
	char texturePath[256];
	sprintf(texturePath, "%sleft.jpg", skyPath);
	int texture = xLoadTexture(texturePath, 49);
	int brush = xCreateBrush();
	xBrushTexture(brush, texture);
	int surface = xCreateSurface(skybox, brush);
	int v0 = xAddVertex(surface, -1.0,  1.0, -1.0, 0.0, 0.0);
	int v1 = xAddVertex(surface, -1.0,  1.0,  1.0, 1.0, 0.0);
	int v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0);
	int v3 = xAddVertex(surface, -1.0, -1.0,  1.0, 1.0, 1.0);
	xAddTriangle(surface, v2, v1, v0);
	xAddTriangle(surface, v1, v2, v3);
	// Front
	sprintf(texturePath, "%sfront.jpg", skyPath);
	texture = xLoadTexture(texturePath, 49);
	brush = xCreateBrush();
	xBrushTexture(brush, texture);
	surface = xCreateSurface(skybox, brush);
	v0 = xAddVertex(surface, -1.0,  1.0, 1.0, 0.0, 0.0);
	v1 = xAddVertex(surface,  1.0,  1.0, 1.0, 1.0, 0.0);
	v2 = xAddVertex(surface, -1.0, -1.0, 1.0, 0.0, 1.0);
	v3 = xAddVertex(surface,  1.0, -1.0, 1.0, 1.0, 1.0);
	xAddTriangle(surface, v2, v1, v0);
	xAddTriangle(surface, v1, v2, v3);
	// Right
	sprintf(texturePath, "%sright.jpg", skyPath);
	texture = xLoadTexture(texturePath, 49);
	brush = xCreateBrush();
	xBrushTexture(brush, texture);
	surface = xCreateSurface(skybox, brush);
	v0 = xAddVertex(surface, 1.0,  1.0,  1.0, 0.0, 0.0);
	v1 = xAddVertex(surface, 1.0,  1.0, -1.0, 1.0, 0.0);
	v2 = xAddVertex(surface, 1.0, -1.0,  1.0, 0.0, 1.0);
	v3 = xAddVertex(surface, 1.0, -1.0, -1.0, 1.0, 1.0);
	xAddTriangle(surface, v2, v1, v0);
	xAddTriangle(surface, v1, v2, v3);
	// Back
	sprintf(texturePath, "%sback.jpg", skyPath);
	texture = xLoadTexture(texturePath, 49);
	brush = xCreateBrush();
	xBrushTexture(brush, texture);
	surface = xCreateSurface(skybox, brush);
	v0 = xAddVertex(surface,  1.0,  1.0, -1.0, 0.0, 0.0);
	v1 = xAddVertex(surface, -1.0,  1.0, -1.0, 1.0, 0.0);
	v2 = xAddVertex(surface,  1.0, -1.0, -1.0, 0.0, 1.0);
	v3 = xAddVertex(surface, -1.0, -1.0, -1.0, 1.0, 1.0);
	xAddTriangle(surface, v2, v1, v0);
	xAddTriangle(surface, v1, v2, v3);
	// Top
	sprintf(texturePath, "%stop.jpg", skyPath);
	texture = xLoadTexture(texturePath, 49);
	brush = xCreateBrush();
	xBrushTexture(brush, texture);
	surface = xCreateSurface(skybox, brush);
	v0 = xAddVertex(surface, -1.0, 1.0,  1.0, 0.0, 0.0);
	v1 = xAddVertex(surface, -1.0, 1.0, -1.0, 1.0, 0.0);
	v2 = xAddVertex(surface,  1.0, 1.0,  1.0, 0.0, 1.0);
	v3 = xAddVertex(surface,  1.0, 1.0, -1.0, 1.0, 1.0);
	xAddTriangle(surface, v2, v1, v0);
	xAddTriangle(surface, v1, v2, v3);
	// set FX flags
	xEntityFX(skybox, 1);
	xFlipMesh(skybox);
	xUpdateNormals(skybox);
	// return skybox handle
	return skybox;
}