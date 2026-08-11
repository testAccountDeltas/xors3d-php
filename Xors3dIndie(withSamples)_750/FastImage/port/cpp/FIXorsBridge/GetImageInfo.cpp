/*
Original TDCImageInfo by David Crowell © 2001, www.davidcrowell.com

Modified by MixailV aka Monster^Sage [monster-sage@mail.ru]

C++ port from Blitz3D by Mechael Meschangin (wolfhound512 -- www.siberiansun.ru)
*/

bool ImageInfo_ReadPNG(FILE * pFile, int FileSize) {
	if (FileSize<25) return(false);

	ImgInfo.Type = IMGTYPE_PNG;
	fseek(pFile, 24, SEEK_SET);

	int depth = fgetc(pFile);
	int type = fgetc(pFile);

	switch (type) {
		case 0:		/* Grayscale */
			ImgInfo.Depth = depth;
			break;
		case 2:		/* RGB */
			ImgInfo.Depth = depth * 3;
			break;
		case 3:		/* Palette based */
			ImgInfo.Depth = 8;
			break;
		case 4:		/* Grayscale with alpha */
			ImgInfo.Depth = depth * 2;
			break;
		case 6:		/* RGB with alpha */
			ImgInfo.Depth = depth * 4;
			break;
		default:
			ImgInfo.Type = IMGTYPE_UNKNOWN;
			return(false);
			break;
	}

	BYTE data[4];
	fseek(pFile, 16, SEEK_SET);
	fread(data,1,4,pFile);
	ImgInfo.Width = ((int)data[0]<<24)|((int)data[1]<<16)|((int)data[2]<<8)|data[3];
	fseek(pFile, 20, SEEK_SET);
	fread(data,1,4,pFile);
	ImgInfo.Height = ((int)data[0]<<24)|((int)data[1]<<16)|((int)data[2]<<8)|data[3];

	return(true);
}

bool ImageInfo_ReadBMP(FILE * pFile, int FileSize) {
	if (FileSize<29) return(false);

	BYTE data[2];
	ImgInfo.Type = IMGTYPE_BMP;

	/* Ширина изображения */
	fseek(pFile, 18, SEEK_SET);
	fread(data,1,2,pFile);
	ImgInfo.Width = ((int)data[1]<<8)|data[0];

	/* Высота изображения */
	fseek(pFile, 22, SEEK_SET);
	fread(data,1,2,pFile);
	ImgInfo.Height = ((int)data[1]<<8)|data[0];

	/* Глубина цвета */
	fseek(pFile, 28, SEEK_SET);
	ImgInfo.Depth = fgetc(pFile);

	return(true);
}

bool ImageInfo_ReadDDS(FILE * pFile, int FileSize) {
	if (FileSize<28) return(false);

	BYTE data[16];
	ImgInfo.Type = IMGTYPE_DDS;

	fseek(pFile, 12, SEEK_SET);
	fread(data,1,16,pFile);

	/* Ширина изображения */
	ImgInfo.Width = ((int)data[3]<<24)|((int)data[2]<<16)|((int)data[1]<<8)|data[0];

	/* Высота изображения */
	ImgInfo.Height = ((int)data[7]<<24)|((int)data[6]<<16)|((int)data[5]<<8)|data[4];

	/* Глубина цвета */
	ImgInfo.Depth = ((int)data[15]<<24)|((int)data[14]<<16)|((int)data[13]<<8)|data[12];

	return(true);
}

bool ImageInfo_ReadTGA(FILE * pFile, int FileSize) {
	if (FileSize<18) return(false);

	BYTE data[6];
	ImgInfo.Type = IMGTYPE_TGA;

	fseek(pFile, 12, SEEK_SET);
	fread(data,1,6,pFile);

	/* Ширина изображения */
	ImgInfo.Width = ((int)data[1]<<8)|data[0];

	/* Высота изображения */
	ImgInfo.Height = ((int)data[3]<<8)|data[2];

	/* Глубина цвета */
	ImgInfo.Depth = ((int)data[5]<<8)|data[4];

	return(true);
}

bool ImageInfo_ReadJPEG(FILE * pFile, int FileSize) {
	BYTE data[5];
	int seek = 0;
	bool ok = false;

	/* Поиск начала файла */
	while (seek < FileSize-4) {
		fseek(pFile, seek, SEEK_SET);
		fread(data,1,4,pFile);
		if (data[0]==0xFF && data[1]==0xD8 && data[2]==0xFF && data[3]==0xE0) {
			ok = true;
			break;
		}
		seek++;
	}
	if (!ok) return(false);
	fseek(pFile, seek+4, SEEK_SET);
	fread(data,1,2,pFile);
	seek += 4 + ((int)data[0]<<8)|data[1];
	fseek(pFile, seek, SEEK_SET);

	/* Ищем сегмент SOF0 */
	ok = false;
	int mark,type;
	while ((mark=fgetc(pFile)) != -1) {
		if (mark == 0xFF) {
			type = fgetc(pFile);

			if(0xC0<=type && type<=0xC3) {
				fseek(pFile, ftell(pFile)+3, SEEK_SET);
				fread(data,1,5,pFile);
				ImgInfo.Height = ((int)data[0]<<8)|data[1];
				ImgInfo.Width = ((int)data[2]<<8)|data[3];
				ImgInfo.Depth = data[4] * 8;
				ImgInfo.Type = IMGTYPE_JPEG;
				return(true);
			}

			seek = ftell(pFile);
			fseek(pFile, seek, SEEK_SET);
			fread(data,1,2,pFile);
			seek += ((int)data[0]<<8)|data[1];
			fseek(pFile, seek, SEEK_SET);
		}
	}

	return(false);
}

int ImageInfo_ReadFile(const char* filename) {
	FILE * pFile;
	long size;

	ImgInfo.Type = IMGTYPE_UNKNOWN;
	ImgInfo.Width = 0;
	ImgInfo.Height = 0;
	ImgInfo.Depth = 0;

	/* Открываем файл */
	fopen_s (&pFile,filename,"rb");
	if (pFile == NULL) return 0;

	/* Размер файла */
	fseek(pFile, 0, SEEK_END);
	size = ftell(pFile);
	if (size < 3) {
		fclose(pFile);
		return 0;
	}
	fseek(pFile, 0, SEEK_SET);

	BYTE data[4];
	bool ImgOk = false;

	/* Start comparsion */
	fread(data,1,4,pFile);

	/* Check PNG */
	if (data[0]==137 && data[1]==80 && data[2]==78) {
		ImgOk = ImageInfo_ReadPNG(pFile,size);
	}

	/* Check BMP */
	if (ImgOk==false && data[0]==66 && data[1]==77) {
		ImgOk = ImageInfo_ReadBMP(pFile,size);
	}

	/* Check DDS */
	if (ImgOk==false && data[0]==68 && data[1]==68 && data[2]==83 && data[3]==32) {
		ImgOk = ImageInfo_ReadDDS(pFile,size);
	}

	/* Check TGA */
	if (ImgOk==false && data[0]==0 && data[1]==0 && data[2]==2) {
		ImgOk = ImageInfo_ReadTGA(pFile,size);
	}

	/* Check JPEG */
	if (ImgOk==false) ImgOk = ImageInfo_ReadJPEG(pFile,size);

	fclose(pFile);
	return(ImgOk);
}