/********************************************************************
 *                                                                  *
 * Xors3D Engine. Read\write pixel sample sample, (c) 2010 XorsTeam *
 * www: http://xors3d.com                                           *
 * e-mail: support@xors3d.com                                       *
 *                                                                  *
 ********************************************************************/

// include Xors3d Engine header
#include <xors3d.h>
#include <iostream>

// program entry point
int APIENTRY WinMain(HINSTANCE instance, HINSTANCE prevInstance, LPSTR commandLine, int commandShow)
{
	//initialization
	xAppTitle("Read/Write Pixel");
	xGraphics3D(640, 480, 32, false, false);

	//enabling antialiasing
	xAntiAlias(true);

	//setting texture filtering mode
	xSetTextureFiltering(TF_ANISOTROPIC);

	//loading tht image
	int image = xLoadImage("../../../media/textures/stones_normal.tga");

	//pixel array
	int ** pixels;
	pixels = new int*[xGraphicsWidth()];
	for(int i = 0; i < xGraphicsWidth(); i++)
	{
		pixels[i] = new int[xGraphicsHeight()];
	}

	//main loop
	while(!xKeyHit(1) || xWinMessage("WM_CLOSE"))
	{
		xRenderWorld();
		//clearing the screen
		xCls();

		//drawing the image
		xDrawImage(image, 0, 0);
		xText(10, 10, "Some text here...");

		//backbuffer locking
		xLockBuffer(xBackBuffer());

		//writing the pixels to the array
		for(int y = 0; y < xGraphicsHeight(); y++)
		{
			for(int x = 0; x < xGraphicsWidth(); x++)
			{
				pixels[x][y] = xReadPixelFast(x, y);
			}
		}

		//clearing the screen
		xCls();

		//reading the pixels in descending order
		for(int y = 0; y < xGraphicsHeight(); y++)
		{
			for(int x = 0; x < xGraphicsWidth(); x++)
			{
				xWritePixelFast(x, y, pixels[x][xGraphicsHeight() - y - 1]);
			}
		}

		//unclocking the backbuffer
		xUnlockBuffer(xBackBuffer());

		//drawing the scene
		xFlip();
	}
	return 0;
}