/*
FastImageXors Bridge
version 1.02
Copyright (c) 2009 Mikhail Meshchangin (wolfhound512 -- www.siberiansun.ru)
*/

#define UNICODE
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <fstream>
#include "FIXorsBridge.h"
#include "GetImageInfo.h"

/* Xors3D */
#define XDECL extern "C" __declspec(dllimport)
#define XCALL __stdcall
XDECL int XCALL xGetDevice();
XDECL void XCALL xSetBuffer(int buffer);
XDECL int XCALL xBufferWidth(int buffer);
XDECL int XCALL xBufferHeight(int buffer);
XDECL int XCALL xTextureBuffer(int texture, int frame = 0);
XDECL int XCALL xGetTextureFrames (int texture);
XDECL int XCALL xGetTextureSurface (int texture, int frame);
XDECL int XCALL xLoadTexture(const char * path, int flags = 1 | 8);
XDECL int XCALL xLoadAnimTexture(const char * path, int flags, int frameWidth, int frameHeight, int startFrame, int totalFrames);
XDECL int XCALL xReadPixel(int x, int y, int buffer = 0);
XDECL void XCALL xFreeTexture(int texture);

using namespace std;

//---------------------------------------------------------------------
cFIXorsBridge* cFIXorsBridge::vsSelf = NULL;
//---------------------------------------------------------------------
int cFIXorsBridge::vsRefcount = 0;
//---------------------------------------------------------------------
cFIXorsBridge::cFIXorsBridge() {
	/* Дескриптор DLL */
	vHandleDLL = 0;
	/* Создание массива структуры */
	vFontProperty.Chars = new int[256];
	/* Сброс параметров */
	vIsDrawing = false;
	vIsDrawInit = false;
}
//---------------------------------------------------------------------
cFIXorsBridge::~cFIXorsBridge() {
	/* Обнуление ссылки на себя */
	vsSelf = NULL;
	/* Выгрузка библиотеки */
	if (vHandleDLL) FreeLibrary( (HMODULE)vHandleDLL );
	/* Удаление массива структуры */
	delete[] vFontProperty.Chars;
}
//---------------------------------------------------------------------
cFIXorsBridge* cFIXorsBridge::Initiate(bool initDraw) {
	/* Если объект класса еще не создан */
	if (!vsSelf) {
		/* Создание объекта */
		vsSelf = new cFIXorsBridge;
		/* Загрузка Dll и импорт функций */
		if ( !vsSelf->LoadFastImage() ) {
			delete vsSelf;
			return NULL;
		}
	}
	/* Инициализация вывода */
	if (initDraw) vsSelf->InitDraw();
	/* Увеличение счетчика инициализаций */
	vsRefcount++;
	/* Возвращение указателя на объект */
	return vsSelf;
}
//---------------------------------------------------------------------
void cFIXorsBridge::FreeSingleton() {
	if (vsRefcount) {
		if(--vsRefcount==0) {
			if (vIsDrawInit) DeinitDraw();
			delete this;
		}
	}
}
//---------------------------------------------------------------------
bool cFIXorsBridge::LoadFastImage() {
	HMODULE hLib = LoadLibrary(L"FastImageXors.dll");
	if (hLib == NULL) { return(false); }
	vHandleDLL = (void*)hLib;

	(FARPROC &)pInitDraw = GetProcAddress(hLib, "InitDraw_");
	if (!pInitDraw) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDeinitDraw = GetProcAddress(hLib, "DeinitDraw_");
	if (!pDeinitDraw) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pStartDraw = GetProcAddress(hLib, "StartDraw_");
	if (!pStartDraw) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pEndDraw = GetProcAddress(hLib, "EndDraw_");
	if (!pEndDraw) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSysUpdateTransform = GetProcAddress(hLib, "SysUpdateTransform_");
	if (!pSysUpdateTransform) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetCustomState = GetProcAddress(hLib, "SetCustomState_");
	if (!pSetCustomState) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetCustomTextureState = GetProcAddress(hLib, "SetCustomTextureState_");
	if (!pSetCustomTextureState) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetMipLevel = GetProcAddress(hLib, "SetMipLevel_");
	if (!pSetMipLevel) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetBlend = GetProcAddress(hLib, "SetBlend_");
	if (!pSetBlend) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetAlpha = GetProcAddress(hLib, "SetAlpha_");
	if (!pSetAlpha) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetColor = GetProcAddress(hLib, "SetColor_");
	if (!pSetColor) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetCustomColor = GetProcAddress(hLib, "SetCustomColor_");
	if (!pSetCustomColor) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetRotation = GetProcAddress(hLib, "SetRotation_");
	if (!pSetRotation) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetScale = GetProcAddress(hLib, "SetScale_");
	if (!pSetScale) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetTransform = GetProcAddress(hLib, "SetTransform_");
	if (!pSetTransform) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetMatrix = GetProcAddress(hLib, "SetMatrix_");
	if (!pSetMatrix) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetHandle = GetProcAddress(hLib, "SetHandle_");
	if (!pSetHandle) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetOrigin = GetProcAddress(hLib, "SetOrigin_");
	if (!pSetOrigin) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pMidHandleImage = GetProcAddress(hLib, "MidHandleImage_");
	if (!pMidHandleImage) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetImageHandle = GetProcAddress(hLib, "SetImageHandle_");
	if (!pSetImageHandle) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pAutoMidHandleEx = GetProcAddress(hLib, "AutoMidHandleEx_");
	if (!pAutoMidHandleEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pAutoImageFlags = GetProcAddress(hLib, "AutoImageFlags_");
	if (!pAutoImageFlags) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetLineWidth = GetProcAddress(hLib, "SetLineWidth_");
	if (!pSetLineWidth) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetViewport = GetProcAddress(hLib, "SetViewport_");
	if (!pSetViewport) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pCreateImageEx = GetProcAddress(hLib, "CreateImageEx_");
	if (!pCreateImageEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pFreeImageEx = GetProcAddress(hLib, "FreeImageEx_");
	if (!pFreeImageEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawImageEx = GetProcAddress(hLib, "DrawImageEx_");
	if (!pDrawImageEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawImageRectEx = GetProcAddress(hLib, "DrawImageRectEx_");
	if (!pDrawImageRectEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawImagePart = GetProcAddress(hLib, "DrawImagePart_");
	if (!pDrawImagePart) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawPoly = GetProcAddress(hLib, "DrawPoly_");
	if (!pDrawPoly) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawRect = GetProcAddress(hLib, "DrawRect_");
	if (!pDrawRect) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawRectSimple = GetProcAddress(hLib, "DrawRectSimple_");
	if (!pDrawRectSimple) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawLine = GetProcAddress(hLib, "DrawLine_");
	if (!pDrawLine) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawLineSimple = GetProcAddress(hLib, "DrawLineSimple_");
	if (!pDrawLineSimple) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawPlot = GetProcAddress(hLib, "DrawPlot_");
	if (!pDrawPlot) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawOval = GetProcAddress(hLib, "DrawOval_");
	if (!pDrawOval) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pGetProperty = GetProcAddress(hLib, "GetProperty_");
	if (!pGetProperty) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pGetImageProperty = GetProcAddress(hLib, "GetImageProperty_");
	if (!pGetImageProperty) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetProjScale = GetProcAddress(hLib, "SetProjScale_");
	if (!pSetProjScale) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetProjRotation = GetProcAddress(hLib, "SetProjRotation_");
	if (!pSetProjRotation) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetProjTransform = GetProcAddress(hLib, "SetProjTransform_");
	if (!pSetProjTransform) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetProjOrigin = GetProcAddress(hLib, "SetProjOrigin_");
	if (!pSetProjOrigin) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetProjHandle = GetProcAddress(hLib, "SetProjHandle_");
	if (!pSetProjHandle) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pMidHandleProj = GetProcAddress(hLib, "MidHandleProj_");
	if (!pMidHandleProj) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pCreateImageFont = GetProcAddress(hLib, "CreateImageFont_");
	if (!pCreateImageFont) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetImageFont = GetProcAddress(hLib, "SetImageFont_");
	if (!pSetImageFont) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pFreeImageFont = GetProcAddress(hLib, "FreeImageFont_");
	if (!pFreeImageFont) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawTextEx = GetProcAddress(hLib, "DrawTextEx_");
	if (!pDrawTextEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pDrawTextRect = GetProcAddress(hLib, "DrawTextRect_");
	if (!pDrawTextRect) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTextRectCount = GetProcAddress(hLib, "TextRectCount_");
	if (!pTextRectCount) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTextRectMaxWidth = GetProcAddress(hLib, "TextRectMaxWidth_");
	if (!pTextRectMaxWidth) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTextRectWidth = GetProcAddress(hLib, "TextRectWidth_");
	if (!pTextRectWidth) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pStringWidthEx = GetProcAddress(hLib, "StringWidthEx_");
	if (!pStringWidthEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pStringHeightEx = GetProcAddress(hLib, "StringHeightEx_");
	if (!pStringHeightEx) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pGetFontProperty = GetProcAddress(hLib, "GetFontProperty_");
	if (!pGetFontProperty) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTestRect = GetProcAddress(hLib, "TestRect_");
	if (!pTestRect) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTestOval = GetProcAddress(hLib, "TestOval_");
	if (!pTestOval) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTestImage = GetProcAddress(hLib, "TestImage_");
	if (!pTestImage) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pTestRendered = GetProcAddress(hLib, "TestRendered_");
	if (!pTestRendered) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pGetCustomTransform = GetProcAddress(hLib, "GetCustomTransform_");
	if (!pGetCustomTransform) { FreeLibrary(hLib); return(false); }

	(FARPROC &)pSetCustomTransform = GetProcAddress(hLib, "SetCustomTransform_");
	if (!pSetCustomTransform) { FreeLibrary(hLib); return(false); }

	return(true);
}
//---------------------------------------------------------------------
char* trim_str(char* ch) {
	int shift = 0, num = 0;
	do { if (ch[num] == ' ') { shift++; } else { ch[num-shift] = ch[num]; } } while(ch[num++]);
	return(ch);
}
//---------------------------------------------------------------------
int cFIXorsBridge::InitDraw() {
	if ( pInitDraw(xGetDevice(), 0) )
		return vIsDrawInit = true;
	else
		return vIsDrawInit = false;
}
//---------------------------------------------------------------------
void cFIXorsBridge::SetBuffer(int buffer) {
	xSetBuffer(buffer);
	if (vIsDrawing)
		SysUpdateTransform( xBufferWidth(buffer), xBufferHeight(buffer) );
}
//---------------------------------------------------------------------
int cFIXorsBridge::SetCustomBlend(int src, int dest) {
	pSetCustomState(15,0);		//	DX7  SetRenderState ( D3DRENDERSTATE_AlphaTestEnable, False )
	pSetCustomState(27,1);		//	DX7  SetRenderState ( D3DRENDERSTATE_AlphaBlendEnable, True )
	pSetCustomState(19,src);	//	DX7  SetRenderState ( D3DRENDERSTATE_SrcBlend, src )
	return pSetCustomState(20,dest);	//	DX7  SetRenderState ( D3DRENDERSTATE_DestBlend, dest )
}
//---------------------------------------------------------------------
int cFIXorsBridge::CreateImage(int texture, int width, int height, int imageFlags) {
	if (texture) {
		int Array[256];
		sFI_Surfaces surf;
		surf.Texture = texture;
		surf.Array = Array;
		surf.Count = xGetTextureFrames(texture);
		if (surf.Count>0) {
			if (surf.Count>256) surf.Count=256;
			for(register int i=0; i<surf.Count; i++) {
				surf.Array[i] = xGetTextureSurface(texture, i);
			}
			return(pCreateImageEx(&surf, width, height, imageFlags));
		}
	}
	return(0);
}
//---------------------------------------------------------------------
int cFIXorsBridge::LoadImageF(const char* fileName, int textureFlags, int imageFlags) {
	if (ImageInfo_ReadFile(fileName)) {
		return( CreateImage(xLoadTexture(fileName, textureFlags), ImgInfo.Width, ImgInfo.Height, imageFlags) );
	}
	return(0);
}
//---------------------------------------------------------------------
int cFIXorsBridge::LoadAnimImage(const char* fileName, int textureFlags, int frameWidth, int frameHeight, int firstFrame, int frameCount, int imageFlags) {
	textureFlags = (textureFlags & 0x3F) | 0x9;
	return( CreateImage( xLoadAnimTexture (fileName, textureFlags, frameWidth, frameHeight, firstFrame, frameCount), frameWidth, frameHeight, imageFlags) );
}
//---------------------------------------------------------------------
int cFIXorsBridge::TestImage(int xPoint, int yPoint, int xImage, int yImage, int Image, int alphaLevel, int Frame, int Local) {
	if (pTestImage(xPoint, yPoint, xImage, yImage, Image, Local, &vTest, 1) && alphaLevel>0 && vTest.Texture!=0) {
		if ( (xReadPixel(vTest.TextureX, vTest.TextureY, xTextureBuffer(vTest.Texture,Frame))>>24)<alphaLevel ) vTest.Result = 0;
	}
	return(vTest.Result);
}
//---------------------------------------------------------------------
int cFIXorsBridge::TestRendered(int xPoint, int yPoint, int alphaLevel, int Local) {
	if (pTestRendered(xPoint, yPoint, Local, &vTest, 1) && alphaLevel>0 && vTest.Texture!=0) {
		if ( (xReadPixel(vTest.TextureX, vTest.TextureY, xTextureBuffer(vTest.Texture,vTest.Frame))>>24)<alphaLevel ) vTest.Result = 0;
	}
	return(vTest.Result);
}
//---------------------------------------------------------------------
void cFIXorsBridge::FreeImage(int image, bool freeTexture) {
	if (freeTexture && GetImageProperty(image)!=0) {
		if (vImageProperty.Texture != 0) xFreeTexture(vImageProperty.Texture);
	}
	pFreeImageEx(image);
}
//---------------------------------------------------------------------
void cFIXorsBridge::FreeImageFont(int font) {
	if ( GetFontProperty(font) ){
		if (vFontProperty.Image) FreeImage(vFontProperty.Image, true);
	}
	pFreeImageFont(font);
}
//---------------------------------------------------------------------
int cFIXorsBridge::LoadImageFont(const char* filename, int flags) {
	/* Загрузка файла описания шрифта */
	ifstream file(filename, ios::in | ios::binary);
	if (!file) { return(0); }

	char name[100];
	char *val;
	char *AnimTex = 0;
	int AnimTexFlag = 0;
	int num;

	//sFI_FontProperty font;

	/*	Чтение файла */
	while (file.getline(name,99)) {
		/*	Если строка не закомментирована */
		if (name[0]==59 && name[0]==13) continue;
		/*	Если в строке присутствует символ = */
		if ((val = strchr(name,'=')) == NULL) continue;

		/*	Заменяем символ = на символ конца строки (0)
			и сдвигаем указатель на 1 символ вперед */
		*val++ = 0;
		/*	Проверяем: если последний символ значения переменной
			равен символу новой строки, то удаляем его */
		num = strlen(val)-1;
		if (val[num] == 13) val[num] = 0;
		/*	Удаляем пробелы в названии переменной и в ее значении */
		trim_str(name);
		trim_str(val);

		/*	Переводим название переменной в верхний регистр */
		num = -1;
		while(name[++num]) { name[num] = toupper(name[num]); }
		
		/*	Сверяем имя переменной и заносим значение в структуру */
		if (strcmp(name,"ANIMTEXTURE") == 0) {
			/*	Если память уже была выделена - освобождаем */
			if (AnimTex) delete AnimTex;
			/*	Узнаем количество символов */
			num = strlen(val)+1;
			if (num > 1) {
				/*	Выделяем память под них */
				AnimTex = new char[num];
				/*	Копируем имя текстуры */
				strcpy_s(AnimTex,num,val);
			}
			else { AnimTex = 0; }
		}
		else if (strcmp(name,"ANIMTEXTUREFLAGS") == 0) {
			AnimTexFlag = atoi(val);
		}
		else if (strcmp(name,"FRAMEWIDTH") == 0) {
			vFontProperty.FrameWidth = atoi(val);
		}
		else if (strcmp(name,"FRAMEHEIGHT") == 0) {
			vFontProperty.FrameHeight = atoi(val);
		}
		else if (strcmp(name,"FRAMECOUNT") == 0) {
			vFontProperty.FrameCount = atoi(val);
		}
		else if (strcmp(name,"WIDTH") == 0) {
			vFontProperty.Width = atoi(val);
		}
		else if (strcmp(name,"HEIGHT") == 0) {
			vFontProperty.Height = atoi(val);
		}
		else if (strcmp(name,"FIRSTCHAR") == 0) {
			vFontProperty.FirstChar = atoi(val);
		}
		else if (strcmp(name,"KERNING") == 0) {
			vFontProperty.Kerning = atoi(val);
		}
		else {
			num = atoi(name);
			if (-1 < num && num < 256) {
				vFontProperty.Chars[num] = atoi(val);
			}
		}
	}

	file.close();
	int ImgFont = 0;

	/*	Узнаем количество символов */
	num = strlen(AnimTex);
	/*	Если известны необходимые данные */
	if (num>0 && vFontProperty.FrameWidth>0 && vFontProperty.FrameHeight>0 && vFontProperty.FrameCount>0) {
		/*	Вычисляем путь к файлу */
		const char* tmp = filename;
		const char* slash;
		char* path;
		do { slash = strchr(tmp,'/'); if (slash) tmp = slash + 1; } while(slash);
		/*	Вычисляем длину пути и записываем адрес файла текустуры */
		bool clear = false;
		if (tmp != filename) {
			int len = ((int)(tmp - filename))/sizeof(char);
			path = new char[len + num + 1];
			strncpy_s(path,len+1,filename,len);
			strcat_s(path,len+num+1,AnimTex);
			clear = true;
		} else { path = AnimTex; }
		/*	Устанавливаем флаг изображению */
		if (flags == FI_SMOOTHFONT) flags = FI_FILTEREDIMAGE;
		else flags = FI_NONE;
		/*	Загружаем изображение */
		vFontProperty.Image = LoadImageF(path, (AnimTexFlag & 0x6) | 0x39, flags);
		/*	Загружаем шрифт */
		ImgFont = pCreateImageFont(&vFontProperty);
		/*	Освобождаем память если она была выделена */
		if (clear) delete path;
	}

	/*	Освобождаем память если она была выделена */
	if (AnimTex) delete AnimTex;

	return(ImgFont);
}