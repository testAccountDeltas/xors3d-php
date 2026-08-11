/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Shadows sample, (c) 2010 XorsTeam                *
 * www: http://xors3d.com                                          *
 * e-mail: support@xors3d.com                                      *
 *                                                                 *
 *******************************************************************/

// include Xors3d Engine header
#include <xors3d.h>
#include <iostream>
#include <math.h>
#include <vector>

// for camera mouse look
float CurveValue(float newvalue, float oldvalue, float increments)
{
	if(increments >  1.0f) oldvalue = oldvalue - (oldvalue - newvalue) / increments;
	if(increments <= 1.0f) oldvalue = newvalue; 
	return oldvalue;
}

// generates random float
float Rnd(float fMin, float fMax)
{
	float fRandNum = (float)rand () / RAND_MAX;
	return fMin + (fMax - fMin) * fRandNum;
}

// for particle system
void UpdateParticles();
void CreateParticle(float x, float y, float z, int texture);

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	// disable AntiAlias
	xSetAntiAliasType(0);

	// set application window caption
	xAppTitle("Shadows sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, true);
	xCreateDSS(1024, 1024);

	// set texture filtring
	xSetTextureFiltering(TF_ANISOTROPICX16);

	// hide mouse pointer
	xHidePointer();

	// create camera
	int camera = xCreateCamera();
	xCameraRange(camera, 0.1f, 1000.0f);
	xPositionEntity(camera, -50, 10, -50);
	xCameraEnableShadows(camera);

	// create a terrain
	int terrain = xCreateCube();
	xScaleEntity(terrain, 200, 0.1f, 200);
	// load grass texture
	int grass = xLoadTexture("../../../media/textures/gras_diffuse_1a.jpg");
	xScaleTexture(grass, 0.1f, 0.1f);
	xEntityTexture(terrain, grass, 0, 0);

	// create forest
	int bereza = xLoadMesh("../../../media/meshes/bereza.b3d");
	xScaleEntity(bereza, 7, 7, 7);

	// create light
	int light = xCreateLight();
	xRotateEntity(light, 45, 0, 0);
	xLightColor(light, 25, 25, 25);

	// create skybox
	int skybox = xLoadMesh("../../../media/meshes/skydome.b3d");
	xEntityFX(skybox, 1);
	xScaleEntity(skybox, 0.5f, 0.5f, 0.5f);
	xEntityColor(skybox, 15, 15, 15);
	xEntityOrder(skybox, 1);

	// warrior
	int warrior = xLoadAnimMesh("../../../media/meshes/kuznec.b3d");
	xEntityColor(warrior, 255, 255, 255);
	xPositionEntity(warrior, 10, 0, -5);
	xScaleEntity(warrior, 5, 5, 5);
	xExtractAnimSeq(warrior, 20, 59);
	xAnimate(warrior, 1, 1.2f, 1);

	// assing point light to fire
	int light2 = xCreateLight(2);
	xLightRange(light2, 50);
	xLightColor(light2, 255, 0, 0);
	int fire = xLoadMesh("../../../media/meshes/koster.b3d");
	xPositionEntity(fire, -10, 0, -10);
	xPositionEntity(light2, -10, 10, -10);
	xScaleEntity(fire, 0.07f, 0.07f, 0.07f);
	int flame = xLoadTexture("../../../media/Textures/fire.jpg", 1 + 2);
	xTextureBlend(flame, 5);
	unsigned int lastCreated = 0;

	// shadows
	xInitShadows(1024, 0, 512);

	// set shadows params
	xLightEnableShadows(light, 1);
	xSetShadowParams(4, 0.85f, true, 300);
	xLightShadowEpsilons(light, 0.0001f, 0.16f);
	xLightEnableShadows(light2, 1);
	xLightShadowEpsilons(light2, 0.01f, 0.0f);

	// for mouse look
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
	float mousespeed       = 0.5;
	float camerasmoothness = 4.5;
	float mxs   =  0.0f;
	float mys   =  0.0f;
	float camxa = -45.0f;
	float camya =  5.0f;

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

		// update flame
		if(timeGetTime() > lastCreated)
		{
			float px = xEntityX(fire, true) + Rnd(-0.1f, 0.1f);
			float py = xEntityY(fire, true);
			float pz = xEntityZ(fire, true) + Rnd(-0.1f, 0.1f);
			CreateParticle(px, py, pz, flame);
			lastCreated = timeGetTime() + 25;
		}
		UpdateParticles();

		// move warrior
		xMoveEntity(warrior, 0, 0, 0.3f);
		xTurnEntity(warrior, 0, 1, 0);

		// position skybox
		xPositionEntity(skybox, xEntityX(camera), xEntityY(camera) - 1, xEntityZ(camera));

		// update animations
		xUpdateWorld();

		// render scene
		xRenderWorld(1.0f, true);

		// draw text
		char buffer[128];
		xColor(200, 0, 0);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 10, buffer);
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 30, buffer);
		sprintf(buffer, "DIP calls: %i", xDIPCounter());
		xText(10, 50, buffer);

		// switch back buffer
		xFlip();
	}
	return 0;
}

// for particles
struct Particle
{
	int   entity;
	float speed;
	float alpha;
};
std::vector<Particle> particlesArray;

void UpdateParticles()
{
	std::vector<Particle>::iterator itr = particlesArray.begin();
	while(itr != particlesArray.end())
	{
		xTranslateEntity(itr->entity, 0.0f, itr->speed, 0.0f);
		itr->alpha = itr->alpha - 0.05f;
		xEntityAlpha(itr->entity, itr->alpha);
		if(itr->alpha < 0.001f)
		{
			itr = particlesArray.erase(itr);
		}
		else
		{
			itr++;
		}
	}
}

void CreateParticle(float x, float y, float z, int texture)
{
	Particle newParticle;
	newParticle.entity = xCreateSprite();
	xEntityTexture(newParticle.entity, texture);
	xEntityFX(newParticle.entity, 1);
	xEntityBlend(newParticle.entity, 3);
	xPositionEntity(newParticle.entity, x, y, z);
	xScaleSprite(newParticle.entity, Rnd(2.0f, 5.0f), Rnd(2.0f, 5.0f));
	newParticle.speed = Rnd(0.2f, 0.5f);
	newParticle.alpha = 1.0f;
	particlesArray.push_back(newParticle);
}