/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Terrain splatting sample, (c) 2010 XorsTeam      *
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
	// initialization
	xSetAntiAliasType(xGetMaxAntiAlias());
	xAppTitle("Terrain");
	xGraphics3D(1024, 768, 32, true, true);

	// enabling antialiasing
	xAntiAlias(true);

	// setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPICX16);

	// creating the cameta
	int camera = xCreateCamera();
	xPositionEntity(camera, 2048, 100, 2048);
	xCameraClsColor(camera, 92, 152, 192);
	xCameraRange(camera, 0.25, 1000);
	xCameraFogColor(camera, 92,152, 192);
	xCameraFogRange(camera, 300, 1000);
	xCameraFogMode(camera, 1);

	// loading the font
	int arial = xLoadFont("Arial", 12);

	// creating the terrain
	int terrain = xLoadTerrain("../../../media/textures/terrain2.png");
	xScaleEntity(terrain, 4, 350, 4);

	// load textures for splatting
	int grass1_diff = xLoadTexture("../../../media/textures/grass1_diff.dds");
	int grass2_diff = xLoadTexture("../../../media/textures/grass3_diff.dds");
	int rock_diff   = xLoadTexture("../../../media/textures/rock_diff.dds");
	int mask        = xLoadTexture("../../../media/textures/mask.png");

	// scale textures
	float scale1 = 64.0f;
	float scale2 = 128.0f;
	xScaleTexture(grass1_diff, 1.0f / scale2, 1.0f / scale2);
	xScaleTexture(grass2_diff, 1.0f / scale1, 1.0f / scale1);
	xScaleTexture(rock_diff,   1.0f / scale2, 1.0f / scale2);

	// apply textures to terrain and enable splatting
	xEntityTexture(terrain, rock_diff,   0, 0);
	xEntityTexture(terrain, grass2_diff, 0, 1);
	xEntityTexture(terrain, grass1_diff, 0, 2);
	xEntityTexture(terrain, mask,        0, 3);
	//xEntityTexture(terrain, lightmap,    0, 7); // <- 7-th texture layer reserved for terrain lightmap
	xTerrainSplatting(terrain, true);

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

		// setting the camera above the terrain
		float x       = xEntityX(camera);
		float y       = xEntityY(camera);
		float z       = xEntityZ(camera);
		float terra_y = xTerrainY(terrain, x, y, z) + 5;
		if(xEntityY(camera, true) < terra_y) xPositionEntity(camera, x, terra_y, z);

		// updating and rendering the world
		xUpdateWorld();
		xRenderWorld();

		// fps and triangle counter
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "Polygons on terrain: %i", xTerrainSize(terrain) * xTerrainSize(terrain) * 2);
		xText(10, 30, buffer);
		sprintf(buffer, "Polygons rendered: %i", xTrisRendered());
		xText(10, 50, buffer);

		// drawing the scene
		xFlip();
	}
	return 0;
}