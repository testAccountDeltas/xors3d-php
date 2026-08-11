/*
FastImageXors Bridge
version 1.01
Copyright (c) 2009 Mikhail Meshchangin (wolfhound512 -- www.siberiansun.ru)
*/

#include <cmath>
#include <string>
#include <windows.h>
#include "FIXorsBridge/FIXorsBridge.h"

/* Подключение Xors3D.dll через "#pragma comment" или в настройках проекта */
//#pragma comment "Libs/Xors3D.lib"

/* Используемые функции Xors3D */
#define XCALL __stdcall
#define XDECL extern "C" __declspec(dllimport)
XDECL int XCALL xWinMessage (const char * msgWin);
XDECL void XCALL xAppTitle(const char * title);
XDECL void XCALL xGraphics3D(int width = 640, int height = 480, int depth = 16, bool fullscreen = false, bool vsync = false);
XDECL int XCALL xCreateCamera(int parent = 0);
XDECL int XCALL xCreateCube(int parent = 0);
XDECL int XCALL xCreateLight(int lightType = 1);
XDECL int XCALL xCreateTexture(int width, int height, int flags = 1 | 8, int frames = 1);
XDECL int XCALL xLoadTexture(const char * path, int flags = 1 | 8);
XDECL int XCALL xTextureBuffer(int texture, int frame = 0);
XDECL int XCALL xBackBuffer();
XDECL void XCALL xEntityTexture(int entity, int texture, int frame = 0, int index = 0);
XDECL void XCALL xPositionEntity(int entity, float x, float y, float z, bool global = false);
XDECL void XCALL xPointEntity(int entity1, int entity2, float roll = 0.0f);
XDECL void XCALL xRotateEntity(int entity, float pitch, float yaw, float roll, bool global = false);
XDECL bool XCALL xKeyHit(int key);
XDECL void XCALL xRenderWorld(float tween = 1.0f);
XDECL void XCALL xFlip();

int WINAPI WinMain(HINSTANCE hInstance,
					HINSTANCE hPrevInstance,
					LPSTR lpCmdLine,
					int nCmdShow)
{
	xAppTitle("FastImageBridge Example");
	xGraphics3D(800,600,32,false,false);

	/* Загрузка FastImage */
	if ( !cFIXorsBridge::Initiate() ) {
		MessageBox(NULL, "FastImage not loaded", "Error", MB_OK);
		return 0;
	}

	/*	Можно получить указатель при инициализации:
	cFIXorsBridge *FIX = cFIXorsBridge::Initiate();
		Или в любое время после нее:
	cFIXorsBridge *FIX = cFIXorsBridge::GetSingletonPtr();
	cFIXorsBridge &FIX = cFIXorsBridge::GetSingleton();
	*/

	/* Получение указателя */
	cFIXorsBridge &FIX = cFIXorsBridge::GetSingleton();

	int cam = xCreateCamera();
	int cub = xCreateCube();
	int light = xCreateLight();
	int texture = xCreateTexture(512, 512, 2);
	xPositionEntity(cam,10,10,10);
	xPointEntity(cam,cub);
	xRotateEntity(light,25,10,20);
	xEntityTexture(cub, texture);
	float x = 0, d = 0;

	while (xWinMessage("WM_CLOSE")==0 && xKeyHit(1)==false) {
		xRenderWorld();

		FIX.StartDraw();
			FIX.SetBlend(FI_ALPHABLEND);

			FIX.SetAlpha(0.7f);
			/* Or cFIXorsBridge::GetSingleton().SetAlpha(0.7f); */

			FIX.SetColor(27,177,243);

			x = 180 * sin( d += .0015f );
			FIX.SetRotation( x - 180 );
			FIX.DrawRect(250,150,120,170);
			FIX.SetRotation( x - 90 );
			FIX.DrawRect(550,150,120,170);
			FIX.SetRotation( x );
			FIX.DrawRect(550,450,120,170);
			FIX.SetRotation( x + 90 );
			FIX.DrawRect(250,450,120,170);

			/* Во время вывода FastImage менять буфер только через
			cFIXorsBridge::SetBuffer(int buffer) */

			FIX.SetBuffer(xTextureBuffer(texture));

			FIX.SetColor(255,255,255);
			FIX.DrawRectSimple(0,0,512,512);
			FIX.SetColor(100,200,100);
			FIX.DrawRectSimple(200 + (int)x,300,100,100);
			FIX.DrawRectSimple(200 - (int)x,100,100,100);
			FIX.DrawRectSimple(100,200 + (int)x,100,100);
			FIX.DrawRectSimple(300,200 - (int)x,100,100);

			FIX.SetBuffer(xBackBuffer());

		FIX.EndDraw();
		
		xFlip();
	}

	/* Выгрузка FastImage */
	FIX.FreeSingleton();

	return(0);
}