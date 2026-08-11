'*******************************************************************
'*                                                                 *
'* Xors3D Engine. System information sample, (c) 2009 Xors3D Team  *
'* www: http://xors3d.com                                          *
'* e-mail: support@xors3d.com                                      *
'*                                                                 *
'*******************************************************************

' import module
Import xorsteam.xors3d

' set application window caption
xAppTitle "SYSInfo sample"

' initialize graphics mode
xGraphics3D 600, 500, 32, False, False

' main progam loop
While Not xKeyHit(xKEY_ESCAPE)

	' clear screen
	xCls()
	
	' CPU information
	xText 45, 50,  "Name: "     + xCPUName()
	xText 45, 70,  "Speed: "    + xCPUSpeed()    + " MHz"
	xText 45, 90,  "Vendor: "   + xCPUVendor()
	xText 45, 110, "Family: "   + xCPUFamily()
	xText 45, 130, "Model: "    + xCPUModel()
	xText 45, 150, "Stepping: " + xCPUStepping()
	
	' Memory information
	xText 45,  200, "Total Phys: " + Float(xGetTotalPhysMem()/1024)  + " MB"
	xText 45,  220, "Avail Phys: " + Float(xGetAvailPhysMem()/1024)  + " MB"
	xText 45,  240, "Total Page: " + Float(xGetTotalPageMem()/1024)  + " MB"
	xText 45,  260, "Avail Page: " + Float(xGetAvailPageMem()/1024)  + " MB"
	xText 245, 200, "Used Phys: " + (Float(xGetTotalPhysMem()/1024) - Float(xGetAvailPhysMem()/1024))  + " MB"
	xText 245, 240, "Used Page: " + (Float(xGetTotalPageMem()/1024) - Float(xGetAvailPageMem()/1024))  + " MB"
	
	' Video system infromation
	xText 45,  330, "Video Decription:                     " + xVideoInfo()
	xText 45,  350, "Total Vid: " + Float(xGetTotalVidMem()/1024)  + " MB"
	xText 45,  370, "Avail Vid: " + Float(xGetAvailVidMem()/1024)  + " MB"
	xText 45,  390, "Total Vid Local: " + Float(xGetTotalVidLocalMem()/1024)  + " MB"
	xText 45,  410, "Avail Vid Local: " + Float(xGetAvailVidLocalMem()/1024)  + " MB"
	xText 45,  430, "Total Vid Nonlocal: " + Float(xGetTotalVidNonlocalMem()/1024)  + " MB"
	xText 45,  450, "Avail Vid Nonlocal: " + Float(xGetAvailVidNonlocalMem()/1024)  + " MB"
	xText 295, 360, "Used Vid : " + (Float(xGetTotalVidMem()/1024) - Float(xGetAvailVidMem()/1024))  + " MB"
	xText 295, 400, "Used Vid  Local: " + (Float(xGetTotalVidLocalMem()/1024) - Float(xGetAvailVidLocalMem()/1024))  + " MB"
	xText 295, 440, "Used Vid Nonlocal: " + (Float(xGetTotalVidNonlocalMem()/1024) - Float(xGetAvailVidNonlocalMem()/1024))  + " MB"
	
	' switch back buffer
	xFlip()
Wend