	[Blitz3d Installation]

1) Copy all decls-files from [Xors3d Engine Folder]/port/blitz3d into [Blitz3d Folder]/userlibs
2) Copy Xors3d.bb from [Xors3d Engine Folder]/port/blitz3d into your project's folder and include it
3) Copy all dlls from [Xors3d Engine Folder]/dlls into [Blitz3d Folder]/bin

	[BlitzMax installation]

1) Copy xorsteam.mod from [Xors3d Engine Folder]/port/blitzmax into [BlitzMax folder]/mod
2) Rebuild modules.
3) Copy all dlls from [Xors3d Engine Folder]/dlls into your project's directory


	[C/C++ installation for Microsoft Visual Studio]

1) Copy all files from [Xors3d Engine Folder]/port/cpp into your projects folder. For example your project is in MyGame folder. Create xors3d folder and copy mentioned files into it.
2) Create a c header-file in your project and place this code into it
		#include "../xors3d_include/xors3d.h"
3) Add xors3d.lib to linker additional dependencies