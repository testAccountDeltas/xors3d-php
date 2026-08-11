/*******************************************************************
 *                                                                 *
 * Xors3D Engine. Forest sample, (c) 2010 XorsTeam                 *
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
	// setup maximum supported AntiAlias Type
	xSetAntiAliasType(0); //xGetMaxAntiAlias()

	// set application window caption
	xAppTitle("Forest sample");

	// initialize graphics mode
	xGraphics3D(800, 600, 32, false, false);
	xSetEngineSetting("LoadMesh::RelativePaths", "false");
	xCreateDSS(1024, 1024);

	// set texture filtring
	xSetTextureFiltering(TF_ANISOTROPICX16);

	// hide mouse pointer
	xHidePointer();

	// enable antialiasing
	xAntiAlias(true);

	// create camera
	int camera = xCreateCamera();
	xCameraRange(camera, 0.1f, 1000.0f);
	xCameraEnableShadows(camera);
	int cameraDist = 50;

	// create a terrain
	int terrain = xLoadTerrain("../../../media/textures/height_map.bmp");
	xTerrainShading(terrain, true);
	xScaleEntity(terrain, 10, 70, 10);
	// load grass texture
	int grass = xLoadTexture("../../../media/textures/gras_diffuse_1a.jpg");
	xScaleTexture(grass, 0.01f, 0.01f);
	xEntityTexture(terrain, grass, 0, 0);

	// create forest
	int bereza = xLoadMesh("../../../media/meshes/bereza2.b3d");
	int shader = xLoadFXFile("../../../media/shaders/shaderinstancing.fx");
	xSetEntityEffect(bereza, shader);
	xSetEffectTechnique(bereza, "Instancing");
	const int amount = 300;
	for(int i = 0; i < amount; i++)
	{
		int copy = xCreateInstance(bereza);
		float x  = Rnd(0.0, 2000.0);
		float z  = Rnd(0.0, 2000.0);
		float y  = xTerrainY(terrain, x, 0.0f, z) - 1.0f;
		xPositionEntity(copy, x, y, z);
		xRotateEntity(copy, Rnd(-3.0, 3.0), Rnd(0.0, 90.0), Rnd(-3.0, 3.0));
		xScaleEntity(copy, 20, 20, 20);
	}

	// for mouse look
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
	float mousespeed       = 0.5;
	float camerasmoothness = 4.5;
	float mxs   = 0.0f;
	float mys   = 0.0f;
	float camxa = 0.0f;
	float camya = 0.0f;

	// create light
	int light = xCreateLight();
	xRotateEntity(light, 45, 0, 0);

	// create skybox
	int skybox = xLoadMesh("../../../media/meshes/skydome.b3d");
	xEntityFX(skybox, 1);
	xScaleEntity(skybox, 0.5f, 0.5f, 0.5f);
	xEntityColor(skybox, 255, 255, 255);
	xEntityOrder(skybox, 1);

	// warrior
	int warrior = xLoadAnimMesh("../../../media/meshes/kuznec.b3d");
	xEntityColor(warrior, 255, 255, 255);
	float x = 1000.0f;
	float z = 1000.0f;
	float y = xTerrainY(terrain, x, 0.0f, z);
	xPositionEntity(warrior, x, y, z);
	xScaleEntity(warrior, 5, 5, 5);
	xExtractAnimSeq(warrior, 14, 18);
	int animIdle = 1;
	xExtractAnimSeq(warrior, 20, 59);
	int animRun  = 2;
	int currAnim = animIdle;
	int lastAnim = 0;
	xAnimate(warrior, 2, 0.1f, currAnim);
	int lastMoveZ = 0;
	int movez     = 0;

	// shadows
	xInitShadows(1024, 0, 0);

	// set shadows params
	bool enableShadows = true;
	xEntityCastShadows(terrain, light, false);
	xLightEnableShadows(light, 1);
	xSetShadowParams(2, 0.6f, true, 300);
	xLightShadowEpsilons(light, 0.0001f, 0.20f);

	// fire
	int koster = xLoadAnimMesh("../../../Media/Meshes/koster.b3d");
	xEntityColor(koster, 255, 255, 255);
	xScaleEntity(koster, 0.07f, 0.07f, 0.07f);
	x = 1010.0f;
	z = 1000.0f;
	y = xTerrainY(terrain, x, y, z);
	xPositionEntity(koster, x, y, z);
	int flameEmiter = koster;
	int flame = xLoadTexture("../../../Media/Textures/fire.jpg", 1 + 2);
	xTextureBlend(flame, 5);
	unsigned int lastCreated = 0;

	// main program loop
	while(!xKeyDown(KEY_ESCAPE))
	{
		// warrior control
		lastAnim  = currAnim;
		currAnim  = animIdle;
		lastMoveZ = movez;
		movez     = 0;
		int movex = 0;
		if(xKeyDown(KEY_W))
		{
			xMoveEntity(warrior, 0, 0, 1);
			currAnim = animRun;
			movez    = 1;
		}
		if(xKeyDown(KEY_S))
		{
			if(lastMoveZ == 0 || lastMoveZ == 1)
			{
				movex = -1;
			}
			else if(lastMoveZ == -1)
			{
				movex = 1;
			}
			xMoveEntity(warrior, 0, 0, 1);
			currAnim = animRun;
			movez    = -1;
		}

		// rotate skydome
		xTurnEntity(skybox, 0, 0.03f, 0);

		// camera look
		if(xMouseDown(2))
		{
			cameraDist = cameraDist + int(xMouseYSpeed() * mousespeed);
			if(cameraDist < 10)  cameraDist = 10;
			if(cameraDist > 100) cameraDist = 100;
			xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
		}
		else
		{
			mxs   = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness);
			mys   = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness);
			camxa = fmodf(camxa - mxs, 360.0f);
			camya = camya + mys;
			if(camya < 0.0f)  camya = 0.0f;
			if(camya > 45.0f) camya = 45.0f;
			xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2);
			xRotateEntity(camera, camya, camxa, 0.0);
			cameraDist = cameraDist + (xMouseZSpeed() * 3);
			if(cameraDist < 10)  cameraDist = 10;
			if(cameraDist > 100) cameraDist = 100;
		}

		//setting the warrior above the terrain
		float x       = xEntityX(warrior);
		float y       = xEntityY(warrior);
		float z       = xEntityZ(warrior);
		float terra_y = xTerrainY(terrain, x, y, z);
		xPositionEntity(warrior, x, terra_y, z);
		xPositionEntity(camera, xEntityX(warrior), xEntityY(warrior) + 10, xEntityZ(warrior));
		if(movez != 0 || movex != 0)
		{
			if(movez == -1)
			{
				xRotateEntity(warrior, 0, xEntityYaw(camera) + 180, 0);
			}
			else
			{
				xRotateEntity(warrior, 0, xEntityYaw(camera), 0);
			}
		}
		xMoveEntity(camera, 0, 0, -float(cameraDist));

		// position skybox
		xPositionEntity(skybox, xEntityX(camera), xEntityY(camera), xEntityZ(camera));

		// switch animation
		if(currAnim != lastAnim)
		{
			if(currAnim == animRun)
			{
				xAnimate(warrior, 1, 1.7f, currAnim, 10);
			}
			else if(currAnim == animIdle)
			{
				xAnimate(warrior, 2, 0.1f, currAnim, 1);
			}
		}

		// update flame
		if(timeGetTime() > lastCreated)
		{
			float px = xEntityX(flameEmiter, true) + Rnd(-0.1f, 0.1f);
			float py = xEntityY(flameEmiter, true);
			float pz = xEntityZ(flameEmiter, true) + Rnd(-0.1f, 0.1f);
			CreateParticle(px, py, pz, flame);
			lastCreated = timeGetTime() + 25;
		}
		UpdateParticles();

		// switch shadows on/off
		if(xKeyHit(KEY_Q)) enableShadows = !enableShadows;

		// update animations
		xUpdateWorld();

		// render scene
		xRenderWorld(1.0f, enableShadows);

		// draw text
		char buffer[128];
		xColor(200, 0, 0);
		sprintf(buffer, "TrisRendered: %i", xTrisRendered());
		xText(10, 10, buffer);
		sprintf(buffer, "FPS: %i", xGetFPS());
		xText(10, 30, buffer);
		sprintf(buffer, "DIP calls: %i", xDIPCounter());
		xText(10, 50, buffer);
		const char * shadowsState = "enabled";
		if(!enableShadows) shadowsState = "disabled";
		sprintf(buffer, "Q - enable\\disable shadows (%s now)", shadowsState);
		xText(10, 70, buffer);

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