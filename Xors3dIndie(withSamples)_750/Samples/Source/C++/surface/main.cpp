/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Surface sample, (c) 2010 XorsTeam                *
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
	xAppTitle("Surface");
	xGraphics3D(800, 600, 32, false, true);

	//setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPIC);

	//enabling antialiasing
	xAntiAlias(true);

	//loading the texture and creating the brush
	int tex = xLoadTexture("../../../media/textures/radiation_box.tga");

	//creating the mesh and its surface
	int mesh = xCreateMesh();
	int surf = xCreateSurface(mesh);

	//creating 4 vertices
	int v0 = xAddVertex(surf, -5, -5, 0, 0, 1);
	int v1 = xAddVertex(surf, -5,  5, 0, 0, 0);
	int v2 = xAddVertex(surf,  5,  5, 0, 1, 0);
	int v3 = xAddVertex(surf,  5, -5, 0, 1, 1);

	//creating 2 triangles
	int tri1 = xAddTriangle(surf, v0, v1, v2);
	int tri2 = xAddTriangle(surf, v3, v0, v2);

	//generating the normals
	xUpdateNormals(mesh);
	xEntityTexture(mesh, tex);

	//light source creating
	int light1 = xCreateLight(LIGHT_DIRECTIONAL);
	xRotateEntity(light1, -45, 0, 0);

	//creating the camera
	int camera = xCreateCamera();
	xMoveEntity(camera, 0, 0, -15);

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

		//updating and rendering the scene
		xUpdateWorld();
		xRenderWorld();

		//fps and traingle counters
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 30, buffer);
		sprintf(buffer, "Vertices: %i", xCountVertices(surf));
		xText(10, 50, buffer);
		sprintf(buffer, "Triangles: %i", xCountTriangles(surf));
		xText(10, 70, buffer);

		//drawing the scene
		xFlip();
	}
	return 0;
}