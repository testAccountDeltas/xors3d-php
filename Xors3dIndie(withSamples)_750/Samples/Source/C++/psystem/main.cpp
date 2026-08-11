/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Particle system sample, (c) 2010 XorsTeam        *
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
	// initialization
	xAppTitle("Particle System");
	xGraphics3D(800, 600, 32, false, true);

	// texture loading
	int texture = xLoadTexture("../../../media/textures/particle.bmp", 1 + 2 + 8);

	// creating the pasrticle system
	int psystem = xCreatePSystem(true);
	xPSystemSetTexture(psystem, texture, 1, 0);
	xPSystemSetParticleLifetime(psystem, 10000);
	xPSystemSetMaxParticles(psystem, 3000);
	xPSystemSetCreationInterval(psystem, 30);
	xPSystemSetCreationFrequency(psystem, 5);
	xPSystemSetVelocity(psystem, -3, -3, -3, 3, 3, 3);
	xPSystemSetParticleSize(psystem, 1, 1, 5, 5);
	xPSystemSetScaleSpeed(psystem, -0.1f, -0.1f, 1, 1);
	xPSystemSetColors(psystem, 0, 255, 0, 255, 0, 0);
	xPSystemSetColorMode(psystem, 1);

	// create emitter
	int emitter = xCreateEmitter(psystem);

	// creating the camera
	int camera = xCreateCamera();
	xMoveEntity(camera, 0, 0, -50);

	// main loop
	while(!xKeyDown(1) || xWinMessage("WM_CLOSE"))
	{
		// turn emitter
		xTurnEntity(emitter, 1, 1, 1);

		// updating and rendering the scene
		xUpdateWorld();
		xRenderWorld();

		// fps and particles counter
		char buffer[128];
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 10, buffer);
		sprintf(buffer, "Particles: %i", xEmitterCountParticles(emitter));
		xText(10, 30, buffer);

		// drawing the scene
		xFlip();
	}
	return 0;
}