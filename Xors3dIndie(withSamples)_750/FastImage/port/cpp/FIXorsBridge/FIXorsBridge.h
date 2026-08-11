/*
FastImageXors Bridge
version 1.02
Copyright (c) 2009 Mikhail Meshchangin (wolfhound512 -- www.siberiansun.ru)
*/

#ifndef __FIXORSBRIDGE__
#define __FIXORSBRIDGE__

//##################################################
//						Defines
//##################################################

#define FIXCALL _stdcall

//	CreateImageEx Flags (при создании картинки)
#define FI_AUTOFLAGS -1
#define FI_NONE 0
#define FI_MIDHANDLE 1
#define FI_FILTEREDIMAGE 2
#define FI_FILTERED 2

//	SetBlend Flags (при использовании бленда (смешивания)
#define FI_SOLIDBLEND 0
#define FI_ALPHABLEND 1
#define FI_LIGHTBLEND 2
#define FI_SHADEBLEND 3
#define FI_MASKBLEND 4
#define FI_MASKBLEND2 5
#define FI_INVALPHABLEND 6

//	D3D Blend Flags для SetCustomBlend
#define FI_D3DBLEND_ZERO			1
#define FI_D3DBLEND_ONE				2
#define FI_D3DBLEND_SRCCOLOR		3
#define FI_D3DBLEND_INVSRCCOLOR		4
#define FI_D3DBLEND_SRCALPHA		5
#define FI_D3DBLEND_INVSRCALPHA		6
#define FI_D3DBLEND_DESTALPHA		7
#define FI_D3DBLEND_INVDESTALPHA	8
#define FI_D3DBLEND_DESTCOLOR		9
#define FI_D3DBLEND_INVDESTCOLOR	10
#define FI_D3DBLEND_SRCALPHASAT		11
#define FI_D3DBLEND_BOTHSRCALPHA	12
#define FI_D3DBLEND_BOTHINVSRCALPHA	13

//	ImageFonts Flags
#define FI_SMOOTHFONT 1

//	DrawImagePart Wrap Flags
#define FI_NOWRAP 0
#define FI_WRAPU 1
#define FI_MIRRORU 2
#define FI_WRAPV 4
#define FI_MORRORV 8
#define FI_WRAPUV 5
#define FI_MIRRORUV 10

//	DrawPoly consts
#define FI_POINTLIST 1
#define FI_LINELIST 2
#define FI_LINESTRIP 3
#define FI_TRIANGLELIST 4
#define FI_TRIANGLESTRIP 5
#define FI_TRIANGLEFAN 6 

/*	FI_POINTLIST 
		Renders the vertices as a collection of isolated points. 
	FI_LINELIST 
		Renders the vertices as a list of isolated straight line segments. Calls using this primitive type fail If the count is less than 2 or is odd. 
	FI_LINESTRIP 
		Renders the vertices as a single polyline. Calls using this primitive type fail If the count is less than 2. 
	FI_TRIANGLELIST 
		Renders the specified vertices as a sequence of isolated triangles. Each group of three vertices defines a separate triangle.
		Calls using this primitive type fail If the count is less than 3 or not evenly divisible by 3. 
	FI_TRIANGLESTRIP 
		Renders the vertices as a triangle strip. Calls using this primitive type fail If the count is less than 3.
	FI_TRIANGLEFAN 
		Renders the vertices as a triangle fan. Calls using this primitive type fail If the count is less than 3. */

#define FI_COLOROVERLAY 1

//##################################################
//					Стуктуры FastImage
//##################################################

struct sFI_Property {
	int Blend;
	float Alpha;
	int Red, Green, Blue;
	int ColorVertex0, ColorVertex1, ColorVertex2, ColorVertex3;
	float Rotation, ScaleX, ScaleY;
	float MatrixXX, MatrixXY, MatrixYX, MatrixYY;
	int HandleX, HandleY;
	int OriginX, OriginY;
	int AutoHandle, AutoFlags;
	float LineWidth;
	int ViewportX, ViewportY, ViewportWidth, ViewportHeight;
	int MipLevel;
	float ProjScaleX, ProjScaleY, ProjRotation;
	int ProjOriginX, ProjOriginY;
	int ProjHandleX, ProjHandleY;
	int Reserved0,Reserved1;
};

struct sFI_ImageProperty {
	int HandleX;
	int HandleY;
	int Width;
	int Height;
	int Frames;
	int Flags;
	int Texture;
	int Reserved0;
	int Reserved1;
};

struct sFI_FontProperty {
	int Width,Height,FirstChar,Kerning;
	int Image,FrameWidth,FrameHeight,FrameCount;
	int* Chars;

	//sFI_FontProperty() { Chars = new int[256]; }
	//~sFI_FontProperty() { delete Chars; }
};

struct sFI_Test {
	int Result;
	int ProjectedX, ProjectedY;
	int RectX, RectY;
	float RectU, RectV;
	int TextureX, TextureY;
	int Texture;
	int Frame;
	int Reserved1;
};

struct sFI_Surfaces {
	int Count;
	int* Array;
	int Texture;
};

//##################################################
//			Объявления функций FastImage
//##################################################

class cFIXorsBridge {
private:
	/* Singleton - Ссылка на единственный экземпляр класса */
	static cFIXorsBridge* vsSelf;
	/* Singleton - Количество выданых ссылок */
	static int vsRefcount;

	/* Дескриптор FastImageXors.dll */
	void* vHandleDLL;

	/* Загрузка FastImageXors.dll */
	bool LoadFastImage();

	/* Указатели на функции FastImageXors.dll */
	int (FIXCALL*pInitDraw)(int Direct3DDevice9, int reserved);
	int (FIXCALL*pDeinitDraw)();
	int (FIXCALL*pStartDraw)();
	int (FIXCALL*pEndDraw)();
	int (FIXCALL*pSysUpdateTransform)(int width, int height);
	int (FIXCALL*pSetCustomState)(int operation, int value);
	int (FIXCALL*pSetCustomTextureState)(int operation, int value);
	int (FIXCALL*pSetMipLevel)(int level);
	int (FIXCALL*pSetBlend)(int blend);
	int (FIXCALL*pSetAlpha)(float alpha);
	int (FIXCALL*pSetColor)(int r, int g, int b);
	int (FIXCALL*pSetCustomColor)(int colorVertex0, int colorVertex1, int colorVertex2, int colorVertex3);
	int (FIXCALL*pSetRotation)(float rotation);
	int (FIXCALL*pSetScale)(float scaleX, float scaleY);
	int (FIXCALL*pSetTransform)(float rotation, float scaleX, float scaleY);
	int (FIXCALL*pSetMatrix)(float xx, float xy, float yx, float yy);
	int (FIXCALL*pSetHandle)(int x, int y);
	int (FIXCALL*pSetOrigin)(int x, int y);
	int (FIXCALL*pMidHandleImage)(int image);
	int (FIXCALL*pSetImageHandle)(int image, int x, int y);
	int (FIXCALL*pAutoMidHandleEx)(int state);
	int (FIXCALL*pAutoImageFlags)(int flags);
	int (FIXCALL*pSetLineWidth)(float width);
	int (FIXCALL*pSetViewport)(int x, int y, int width, int height);
	int (FIXCALL*pCreateImageEx)(void* texures, int width, int height, int flags);
	int (FIXCALL*pFreeImageEx)(int image);
	int (FIXCALL*pDrawImageEx)(int image, int x, int y, int frame);
	int (FIXCALL*pDrawImageRectEx)(int image, int x, int y, int width, int height, int frame);
	int (FIXCALL*pDrawImagePart)(int image, int x, int y, int width, int height, int partX, int partY, int partWidth, int partHeight, int frame, int wrap);
	int (FIXCALL*pDrawPoly)(int x, int y, int bank, int image, int frame, int color);
	int (FIXCALL*pDrawRect)(int x, int y, int width, int height, int fill);
	int (FIXCALL*pDrawRectSimple)(int x, int y, int width, int height, int fill);
	int (FIXCALL*pDrawLine)(int x, int y, int x2, int y2);
	int (FIXCALL*pDrawLineSimple)(int x, int y, int x2, int y2);
	int (FIXCALL*pDrawPlot)(int x, int y);
	int (FIXCALL*pDrawOval)(int x, int y, int width, int height);
	int (FIXCALL*pGetProperty)(void* type);
	int (FIXCALL*pGetImageProperty)(int img, void* type);
	int (FIXCALL*pSetProjScale)(int scaleX, int scaleY);
	int (FIXCALL*pSetProjRotation)(float rotation);
	int (FIXCALL*pSetProjTransform)(float rotation, float scaleX, float scaleY);
	int (FIXCALL*pSetProjOrigin)(int x, int y);
	int (FIXCALL*pSetProjHandle)(int x, int y);
	int (FIXCALL*pMidHandleProj)();
	int (FIXCALL*pCreateImageFont)(void* type);
	int (FIXCALL*pSetImageFont)(int font);
	int (FIXCALL*pFreeImageFont)(int font);
	int (FIXCALL*pDrawTextEx)(const char* txt, int x, int y, int centerX, int centerY, int maxWidth);
	int (FIXCALL*pDrawTextRect)(const char* txt, int x, int y, int w, int h, int centerX, int centerY, int lineSpacing);
	int (FIXCALL*pTextRectCount)();
	int (FIXCALL*pTextRectMaxWidth)();
	int (FIXCALL*pTextRectWidth)(int StringNumber);
	int (FIXCALL*pStringWidthEx)(const char* txt, int maxWidth);
	int (FIXCALL*pStringHeightEx)(const char* txt);
	int (FIXCALL*pGetFontProperty)(int font, void* type);
	int (FIXCALL*pTestRect)(int xPoint, int yPoint, int xRect, int yRect, int WidthRect, int HeightRect, int Local, void* Result, int ResultFlag);
	int (FIXCALL*pTestOval)(int xPoint, int yPoint, int xOval, int yOval, int WidthOval, int HeightOval, int Local, void* Result, int ResultFlag);
	int (FIXCALL*pTestImage)(int xPoint, int yPoint, int xImage, int yImage, int Image, int Local, void* Result, int ResultFlag);
	int (FIXCALL*pTestRendered)(int xPoint, int yPoint, int Local, void* Result, int ResultFlag);
	int (FIXCALL*pGetCustomTransform)(int type, void* martix);
	int (FIXCALL*pSetCustomTransform)(int type, void* martix);

protected:
	/* Конструктор */
	cFIXorsBridge();
	/* Деструктор */
	virtual ~cFIXorsBridge();

public:
	/* Загрузка и инициализация FastImage */
	static cFIXorsBridge* Initiate(bool initDraw = true);

	/* Возвращают указатель на объект класса и сам объект */
	static cFIXorsBridge& GetSingleton() { return *vsSelf; }
	static cFIXorsBridge* GetSingletonPtr() { return vsSelf; }

	/* Удаление/выгрузка FastImage */
	void FreeSingleton();

	/* Состояние */
	bool vIsDrawInit;
	bool vIsDrawing;

	/* Структуры свойств */
	sFI_Property vProperty;
	sFI_ImageProperty vImageProperty;
	sFI_FontProperty vFontProperty;
	sFI_Test vTest;

	int InitDraw();
	int DeinitDraw() { vIsDrawInit = false; return pDeinitDraw(); }
	int StartDraw() { return( pStartDraw() ? vIsDrawing = true : vIsDrawing = false); }
	int EndDraw() { vIsDrawing = false; return pEndDraw(); }
	int SysUpdateTransform(int width, int height) { return pSysUpdateTransform(width, height); }
	int GetProperty() { return pGetProperty(&vProperty); }
	int GetImageProperty(int img) { return pGetImageProperty(img, &vImageProperty); }
	int GetFontProperty(int font) { return pGetFontProperty(font, &vFontProperty); }
	void SetBuffer(int buffer);

	int SetCustomState(int operation, int value) { return pSetCustomState(operation, value); }
	int SetCustomTextureState(int operation, int value) { return pSetCustomTextureState(operation, value); }
	int SetMipLevel(int level) { return pSetMipLevel(level); }
	int SetBlend(int blend) { return pSetBlend(blend); }
	int SetAlpha(float alpha) { return pSetAlpha(alpha); }
	int SetColor(int r, int g, int b) { return pSetColor(r, g, b); }
	int SetCustomColor(int colorVertex0, int colorVertex1, int colorVertex2, int colorVertex3) { return pSetCustomColor(colorVertex0, colorVertex1, colorVertex2, colorVertex3); }
	int SetRotation(float rotation) { return pSetRotation(rotation); }
	int SetScale(float scaleX, float scaleY) { return pSetScale(scaleX, scaleY); }
	int SetTransform(float rotation, float scaleX, float scaleY) { return pSetTransform(rotation, scaleX, scaleY); }
	int SetMatrix(float xx, float xy, float yx, float yy) { return pSetMatrix(xx, xy, yx, yy); }
	int SetHandle(int x, int y) { return pSetHandle(x, y); }
	int SetOrigin(int x, int y) { return pSetOrigin(x, y); }
	int MidHandleImage(int image) { return pMidHandleImage(image); }
	int SetImageHandle(int image, int x, int y) { return pSetImageHandle(image, x, y); }
	int AutoMidHandleEx(int state) { return pAutoMidHandleEx(state); }
	int AutoImageFlags(int flags) { return pAutoImageFlags(flags); }
	int SetLineWidth(float width) { return pSetLineWidth(width); }
	int SetViewport(int x, int y, int width, int height) { return pSetViewport(x, y, width, height); }
	int SetProjScale(int scaleX, int scaleY) { return pSetProjScale(scaleX, scaleY); }
	int SetProjRotation(float rotation) { return pSetProjRotation(rotation); }
	int SetProjTransform(float rotation, float scaleX, float scaleY) { return pSetProjTransform(rotation, scaleX, scaleY); }
	int SetProjOrigin(int x, int y) { return pSetProjOrigin(x, y); }
	int SetProjHandle(int x, int y) { return pSetProjHandle(x, y); }
	int MidHandleProj() { return pMidHandleProj(); }
	int SetImageFont(int font) { return pSetImageFont(font); }

	int SetCustomBlend(int src, int dest);
	int CreateImage(int texture, int width, int height, int imageFlags = FI_AUTOFLAGS);
	int LoadImageF(const char* fileName, int textureFlags = 0, int imageFlags = FI_AUTOFLAGS);
	int LoadAnimImage(const char* fileName, int textureFlags, int frameWidth, int frameHeight, int firstFrame, int frameCount, int imageFlags = FI_AUTOFLAGS);
	int LoadImageFont(const char* filename, int flags = FI_SMOOTHFONT);
	void FreeImage(int image, bool freeTexture = false);
	void FreeImageFont(int font);

	int DrawImage(int image, int x, int y, int frame = 0) { return( pDrawImageEx(image, x, y, frame) ); }
	int DrawImageRect(int image, int x, int y, int width, int height, int frame = 0) { return( pDrawImageRectEx(image, x, y, width, height, frame) ); }
	int DrawImagePart(int image, int x, int y, int width, int height, int partX = 0, int partY = 0, int partWidth = 0, int partHeight = 0, int frame = 0, int wrap = FI_NOWRAP) { return( pDrawImagePart(image, x, y, width, height, partX, partY, partWidth, partHeight, frame, wrap) ); }
	int DrawPoly(int x, int y, int bank, int image = 0, int frame = 0, int color = FI_NONE) { return( pDrawPoly(x, y, bank, image, frame, color) ); }
	int DrawRect(int x, int y, int width, int height, bool fill = true) { return( pDrawRect(x, y, width, height, fill) ); }
	int DrawRectSimple(int x, int y, int width, int height, bool fill = true) { return( pDrawRectSimple(x, y, width, height, fill) ); }
	int DrawLine(int x, int y, int x2, int y2) { return pDrawLine(x, y, x2, y2); }
	int DrawLineSimple(int x, int y, int x2, int y2) { return pDrawLineSimple(x, y, x2,  y2); }
	int DrawPlot(int x, int y) { return pDrawPlot(x, y); }
	int DrawOval(int x, int y, int width, int height) { return pDrawOval(x, y, width, height); }
	int DrawTextA(const char* txt, int x, int y, int centerX = 0, int centerY = 0, int maxWidth = 10000) { return( pDrawTextEx(txt, x, y, centerX, centerY, maxWidth) ); }
	int DrawTextRect(const char* txt, int x, int y, int w, int h, int centerX = 0, int centerY = 0, int lineSpacing = 0) { return( pDrawTextRect(txt, x, y, w, h, centerX, centerY, lineSpacing) ); }
	int TextRectCount() { return pTextRectCount(); }
	int TextRectMaxWidth() { return pTextRectMaxWidth(); }
	int TextRectWidth(int StringNumber) { return pTextRectWidth(StringNumber); }
	int StringWidth(const char* txt, int maxWidth = 10000) { return pStringWidthEx(txt, maxWidth); }
	int StringHeight(const char* txt) { return pStringHeightEx(txt); }

	int TestRect(int xPoint, int yPoint, int xRect, int yRect, int WidthRect, int HeightRect, int Local = 0) { return( pTestRect(xPoint, yPoint, xRect, yRect, WidthRect, HeightRect, Local, &vTest, 1) ); }
	int TestOval(int xPoint, int yPoint, int xOval, int yOval, int WidthOval, int HeightOval, int Local = 0) { return( pTestOval(xPoint, yPoint, xOval, yOval, WidthOval, HeightOval, Local, &vTest, 1) ); }
	int TestImage(int xPoint, int yPoint, int xImage, int yImage, int Image, int alphaLevel = 0, int Frame = 0, int Loc = 0);
	int TestRendered(int xPoint, int yPoint, int alphaLevel = 0, int Loc = 0);
	int GetCustomTransform(int type, void* martix) { return pGetCustomTransform(type, martix); }
	int SetCustomTransform(int type, void* martix) { return pSetCustomTransform(type, martix); }
};

#endif /*__FIXORSBRIDGE__*/