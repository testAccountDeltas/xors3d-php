/*
Original TDCImageInfo by David Crowell © 2001, www.davidcrowell.com

Modified by MixailV aka Monster^Sage [monster-sage@mail.ru]

C++ port from Blitz3D by Mechael Meschangin (wolfhound512 -- www.siberiansun.ru)
*/

#ifndef __GETIMAGEINFO__
#define __GETIMAGEINFO__

#include <cstdio>

//	Image type constants
#define IMGTYPE_UNKNOWN 0
#define IMGTYPE_BMP 1
#define IMGTYPE_PNG 2
#define IMGTYPE_JPEG 3
#define IMGTYPE_TGA 4
#define IMGTYPE_DDS 5

typedef unsigned char BYTE;

//	ImageInfo struct
struct sImageInfo {
	int Type,Width,Height,Depth;
} ImgInfo;

int ImageInfo_ReadFile(char* filename);

#include "GetImageInfo.cpp"

#endif /*__GETIMAGEINFO__*/