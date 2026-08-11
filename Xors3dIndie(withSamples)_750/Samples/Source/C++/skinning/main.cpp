/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Skinning sample, (c) 2010 XorsTeam               *
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
	xAppTitle("Skinning sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);
	xSetEngineSetting("LoadMesh::RelativePaths", "false");

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 0, 2, -5);

	// set this to true for using software skinning
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

	// loading skinned mesh
	int hazar = xLoadAnimMesh("../../../media/meshes/hazar.b3d");
	xRotateEntity(hazar, 0, 180, 0);

	// if we use hardware skinning
	if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
	{
		// load shader
		int shader = xLoadFXFile("../../../media/shaders/skinning.fx");
		// assign it to mesh
		xSetEntityEffect(hazar, shader);
		// setup constant name for bones matrices
		xSetBonesArrayName(hazar, "bonesMatrixArray");
		// setup technique
		xSetEffectTechnique(hazar, "Skinned");
	}

	// we may load animation sequensec only for skinned mesh
	int skinnedHazar = xFindChild(hazar, "Box01");

	// extract animation sequences
	xExtractAnimSeq(hazar, 2, 4);
	int animIndle = 1; // in fact xExtractAnimSeq() return sequence number, but
	// in model 2 animated meshes(man and sword), and we must
	// extract sequences for each of them for real number,
	// but sequences number always increments for next sequence //)
	xExtractAnimSeq(hazar, 20, 59);
	int animRun = 2;
	xExtractAnimSeq(hazar, 99, 129);
	int animAttack = 3;
	xExtractAnimSeq(hazar, 70, 87);
	int animDeath = 4;

	// play idle animation
	xAnimate(hazar, 2, 0.1f, animIndle);
	int curAnimation = animIndle;

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

		// animation switch
		if(xKeyHit(KEY_1))
		{
			xAnimate(hazar, 2, 0.1f, animIndle);
			curAnimation = animIndle;
		}
		if(xKeyHit(KEY_2))
		{
			xAnimate(hazar, 1, 1.0f, animRun);
			curAnimation = animRun;
		}
		if(xKeyHit(KEY_3))
		{
			xAnimate(hazar, 1, 1.0f, animAttack);
			curAnimation = animAttack;
		}
		if(xKeyHit(KEY_4))
		{
			xAnimate(hazar, 3, 1.0f, animDeath);
			curAnimation = animDeath;
		}

		// update animations
		xUpdateWorld();

		// render scene
		xRenderWorld();

		// draw hints
		xText(10, 10, "Key 1 - Idle animation");
		xText(10, 30, "Key 2 - Run animation");
		xText(10, 50, "Key 3 - Attack animation");
		xText(10, 70, "Key 4 - Death animation");
		switch(curAnimation)
		{
			case 1: xText(10, 90, "Now played - Idle animation");   break;
			case 2: xText(10, 90, "Now played - Run animation");    break;
			case 3: xText(10, 90, "Now played - Attack animation"); break;
			case 4: xText(10, 90, "Now played - Death animation");  break;
		}

		// switch back buffer
		xFlip();
	}
	return 0;
}