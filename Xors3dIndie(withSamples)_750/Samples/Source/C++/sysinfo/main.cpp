/*******************************************************************
 *                                                                 *
 * Xors3D Engine. System information sample, (c) 2010 XorsTeam     *
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
	// set application window caption
	xAppTitle("SYSInfo sample");

	// initialize graphics mode
	xGraphics3D(600, 500, 32, false, false);

	// main progam loop
	while(!xKeyHit(KEY_ESCAPE))
	{
		// clear screen
		xCls();

		// CPU information
		char buffer[128];
		sprintf(buffer, "Name: %s", xCPUName());
		xText(45, 50, buffer);
		sprintf(buffer, "Speed: %i MHz", xCPUSpeed());
		xText(45, 70, buffer);
		sprintf(buffer, "Vendor: %s", xCPUVendor());
		xText(45, 90, buffer);
		sprintf(buffer, "Family: %i", xCPUFamily());
		xText(45, 110, buffer);
		sprintf(buffer, "Model: %i", xCPUModel());
		xText(45, 130, buffer);
		sprintf(buffer, "Stepping: %i", xCPUStepping());
		xText(45, 150, buffer);

		// Memory information
		sprintf(buffer, "Total Phys: %f MB", float(xGetTotalPhysMem() / 1024.0f));
		xText(45,  200, buffer);
		sprintf(buffer, "Avail Phys: %f MB", float(xGetAvailPhysMem() / 1024.0f));
		xText(45,  220, buffer);
		sprintf(buffer, "Total Page: %f MB", float(xGetTotalPageMem() / 1024.0f));
		xText(45,  240, buffer);
		sprintf(buffer, "Avail Page: %f MB", float(xGetAvailPageMem() / 1024.0f));
		xText(45,  260, buffer);
		sprintf(buffer, "Used Phys: %f MB", (float(xGetTotalPhysMem() / 1024.0f) - float(xGetAvailPhysMem() / 1024.0f)));
		xText(245, 200, buffer);
		sprintf(buffer, "Used Page: %f MB", (float(xGetTotalPageMem() / 1024.0f) - float(xGetAvailPageMem() / 1024.0f)));
		xText(245, 240, buffer);

		// Video system infromation
		sprintf(buffer, "Video Decription:                     %s", xVideoInfo());
		xText(45,  330, buffer);
		sprintf(buffer, "Total Vid: %f MB", float(xGetTotalVidMem() / 1024.0f));
		xText(45,  350, buffer);
		sprintf(buffer, "Avail Vid: %f MB", float(xGetAvailVidMem() / 1024.0f));
		xText(45,  370, buffer);
		sprintf(buffer, "Total Vid Local: %f MB", float(xGetTotalVidLocalMem() / 1024.0f));
		xText(45,  390, buffer);
		sprintf(buffer, "Avail Vid Local: %f MB", float(xGetAvailVidLocalMem() / 1024.0f));
		xText(45,  410, buffer);
		sprintf(buffer, "Total Vid Nonlocal: %f MB", float(xGetTotalVidNonlocalMem() / 1024.0f));
		xText(45,  430, buffer);
		sprintf(buffer, "Avail Vid Nonlocal: %f MB", float(xGetAvailVidNonlocalMem() / 1024.0f));
		xText(45,  450, buffer);
		sprintf(buffer, "Used Vid: %f MB", (float(xGetTotalVidMem() / 1024.0f) - float(xGetAvailVidMem() / 1024.0f)));
		xText(295, 360, buffer);
		sprintf(buffer, "Used Vid Local: %f MB", (float(xGetTotalVidLocalMem() / 1024.0f) - float(xGetAvailVidLocalMem() / 1024.0f)));
		xText(295, 400, buffer);
		sprintf(buffer, "Used Vid Nonlocal: %f MB", (float(xGetTotalVidNonlocalMem() / 1024.0f) - float(xGetAvailVidNonlocalMem() / 1024.0f)));
		xText(295, 440, buffer);

		// switch back buffer
		xFlip();
	}
	return 0;
}