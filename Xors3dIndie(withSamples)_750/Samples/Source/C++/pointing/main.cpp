/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Pointing sample, (c) 2010 XorsTeam       *
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
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(xGetMaxAntiAlias());

	// set application window caption
	xAppTitle("Pointing sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();

	// position camera
	xPositionEntity(camera, 0, 2, -10);

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
	int kuznec = xLoadAnimMesh("../../../media/meshes/kuznec.b3d");
	int head   = xFindChild(kuznec, "Bone10");
	xRotateEntity(kuznec, 0, 180, 0);

	// if we use hardware skinning
	if(xGetMaxVertexShaderVersion() > -1 && forceSoftware == false)
	{
		// load shader
		int shader = xLoadFXFile("../../../media/shaders/skinning.fx");
		// assign it to mesh
		xSetEntityEffect(kuznec, shader);
		// setup constant name for bones matrices
		xSetBonesArrayName(kuznec, "bonesMatrixArray");
		// setup technique
		xSetEffectTechnique(kuznec, "Skinned");
	}

	// extract animation sequences
	xExtractAnimSeq(kuznec, 99, 129);

	// play idle animation
	xAnimate(kuznec, 1, 1.0f, 1);
	xAnimate(kuznec, 0, 1.0f, 0, 0, "Bone10"); //disable animation for head

	// create target sphere
	int target = xCreateSphere();
	xScaleEntity(target, 0.1f, 0.1f, 0.1f);
	xPositionEntity(target, 3, 2, -2);
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);

	// main program loop
	while(!xKeyDown(KEY_ESCAPE))
	{

		// target control
		xMoveEntity(target, xMouseXSpeed() * 0.05f, -(xMouseYSpeed() * 0.05f), 0.0f);
		xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);

		// check borders
		if(xEntityX(target) >  5.0f) xPositionEntity(target,  5, xEntityY(target), 0);
		if(xEntityX(target) < -5.0f) xPositionEntity(target, -5, xEntityY(target), 0);
		if(xEntityY(target) >  6.0f) xPositionEntity(target, xEntityX(target),  6, 0);
		if(xEntityY(target) < -2.0f) xPositionEntity(target, xEntityX(target), -2, 0);

		// point head
		xPointEntity(head, target);
		xTurnEntity(head, 0, -90, 90); // fixing axis

		// update animations
		xUpdateWorld();

		// render scene
		xRenderWorld();

		// draw texts
		char buffer[128];
		sprintf(buffer, "FPS: ", xGetFPS());
		xText(10, 10, buffer);
		xText(10, 30, "Move mouse");

		// switch back buffer
		xFlip();
	}
	return 0;
}