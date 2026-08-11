/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Bloom sample, (c) 2010 XorsTeam                  *
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
	xAppTitle("Bloom sample");

	// create camera
	int camera = xCreateCamera();
	xCameraRange(camera, 0.9, 3000);
	xPositionEntity(camera, 10, 0, -20);
	xRotateEntity(camera, -10, 20, 0);

	// create scene
	int cube = xLoadMesh("../../../media/meshes/teapot.b3d");
	xPositionEntity(cube, 0, 0, 5);
	xScaleMesh(cube, 0.3, 0.3, 0.3);
	int texture1 = xLoadTexture("../../../media/textures/tex_bloom.jpg");
	xEntityTexture(cube, texture1);

	// create light
	int light = xCreateLight();

	// create posteffect poly
	int poly = xCreatePostEffectPoly(camera, 1);

	// create posteffect textures
	int texture  = xCreateTexture(256, 256);
	int texture2 = xCreateTexture(800, 600);

	// load posteffect shader
	int shader = xLoadFXFile("../../../media/shaders/Bloom.fx");

	xSetEntityEffect(poly, shader);
	xSetEffectTechnique(poly, "Diffuse");
	xSetEffectMatrixSemantic(poly, "MatWorldViewProj", WORLDVIEWPROJ);
	xSetEffectTexture(poly, "tDiffuse", texture);
	xSetEffectTexture(poly, "tEmissive", texture2);

	// create skybox
	int sky = CreateSkyBox("../../../media/textures/skybox/");
	xScaleEntity(sky, 1000, 500, 1000);
	xPositionEntity(sky, 0, 200, 0);

	// create cube
	int cube2 = xCreateCube();
	xPositionEntity(cube2, 0, 0, 30);
	xScaleEntity(cube2, 5, 5, 5);

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
		xTurnEntity(cube, 0, 1, 0);

		// switch bloom
		if(xKeyHit(KEY_SPACE)) enable = !enable;

		// render scene
		xRenderWorld();

		// bloom
		if(enable == true)
		{
			xStretchBackBuffer(texture, 0, 0, 256, 256, 0);
			xStretchBackBuffer(texture2, 0, 0, 800, 600, 0);
			xSetEffectTechnique(poly, "Diffuse");
			xRenderPostEffect(poly);
			xStretchBackBuffer(texture, 0, 0, 256, 256, 0);
			xSetEffectTechnique(poly, "DiffuseH");
			xRenderPostEffect(poly);
			xStretchBackBuffer(texture, 0, 0, 256, 256, 0);
			xSetEffectTechnique(poly, "DiffuseV");
			xRenderPostEffect(poly);
		}

		// draw texts
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(40, 30, buffer);
		xText(40, 50, "Space - enable\\disable bloom");

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