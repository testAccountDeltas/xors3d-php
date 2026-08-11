	[Blitz3d Installation]

1) Copy all decls-files from Xors3dEngine/addons/FastImage/port/blitz3d into [Blitz3d Folder]/userlibs
2) Copy all dlls from Xors3dEngine/addons/FastImage/dll into [Blitz3d Folder]/bin



	[C/C++ installation for Microsoft Visual Studio]

1) Copy all *.h and *.cpp files from Xors3dEngine/addons/FastImage/port/cpp into your projects folder. For example your project is in MyGame folder. Create fastimage folder and copy mentioned files into it.
2) Create a cpp header-file in your project and place this code into it
		#include "../fastimage/FIXorsBridge.cpp

  
   Check out the example to learn how to use CPP-port of FastImage