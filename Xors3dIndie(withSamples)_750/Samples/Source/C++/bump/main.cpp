/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Bump sample, (c) 2010 XorsTeam                   *
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
	xAppTitle("Bump-mapping sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 0, 0, -25);

	// set this variable to true to use FFP DOT3 bump-mapping (for old video-cards)
	const bool forceFFP = false;

	// create cube
	int cube = xCreateCube();
	xScaleEntity(cube, 5, 5, 5);
	xEntityShininess(cube, 1.0);
	xUpdateNormals(cube);

	// load logo texture from file
	int diffuse = xLoadTexture("../../../media/textures/blue_marble.jpg");
	int normal  = xLoadTexture("../../../media/textures/blue_marble_norm.jpg");

	if(forceFFP == false)
	{
		// texture cube
		xEntityTexture(cube, diffuse, 0, 0); // layer0 - diffuse
		xEntityTexture(cube, normal,  0, 1); // layer1 - normal-map
	}
	else
	{
		// texture cube
		xEntityTexture(cube, diffuse, 0, 1); // layer1 - diffuse
		xEntityTexture(cube, normal,  0, 0); // layer0 - normal-map

		// set DOT3 blend for FFP bump
		xTextureBlend(normal,  4);
		xTextureBlend(diffuse, 2);
	}

	// create light
	int pivot  = xCreatePivot();
	int light1 = xCreateLight(2);
	xEntityParent(light1, pivot);
	xPositionEntity(light1, 0, 0, -10);
	int sphere = xCreateSphere(12, light1);
	xScaleEntity(sphere, 0.1, 0.1, 0.1);

	if(forceFFP == false)
	{
		// load bump shader
		int bump = xLoadFXFile("../../../media/shaders/bump.fx");

		// assing it to cube
		xSetEntityEffect(cube, bump);

		//set technique
		xSetEffectTechnique(cube, "Bump");
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

		// turn cube
		xTurnEntity(pivot, 0, 1, 0);

		if(forceFFP == false)
		{
			// pass camera position into shader
			xSetEffectVector(cube, "cameraPosition", xEntityX(camera), xEntityY(camera), xEntityZ(camera));
		}

		// render scene
		xRenderWorld();

		// draw back buffer
		xFlip();
	}
	return 0;
}