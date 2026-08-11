Strict
Module xorsteam.xscript
Import brl.blitz

ModuleInfo "Version: 1.02"
ModuleInfo "Copyright: LGPL (c) 2009-2010 XorsTeam"

' win32 extern functions
Extern "win32"
	Function FindWindowA%(class%,title$z)
	Function LoadLibraryA(lib$z)
	Function GetProcAddress:Byte Ptr(lib%,fname$z) 
End Extern

' library file name
Global gxScriptLibName$ = "xscript.dll"

' library functions
Global xLoadScript_%(fileName:Byte Ptr) "win32"
Global xExecuteScript_%(script%, entryPoint:Byte Ptr) "win32"
Global xDeleteScript(script%) "win32"
Global xSetIntegerVariable_(script%, varName:Byte Ptr, value%) "win32"
Global xGetIntegerVariable_%(script%, varName:Byte Ptr) "win32"
Global xSetFloatVariable_(script%, varName:Byte Ptr, value#) "win32"
Global xGetFloatVariable_#(script%, varName:Byte Ptr) "win32"
Global xSetStringVariable_(script%, varName:Byte Ptr, value:Byte Ptr) "win32"
Global xGetStringVariable_:Byte Ptr(script%, varName:Byte Ptr) "win32"
Global xRegisterFunction_(decl:Byte Ptr, funcAddr%) "win32"
Global xSetIntegerArg(index%, value%) "win32"
Global xSetFloatArg(index%, value#) "win32"
Global xSetStringArg_(index%, value:Byte Ptr) "win32"
Global xGetIntegerReturn%() "win32"
Global xGetFloatReturn#() "win32"
Global xGetStringReturn_:Byte Ptr() "win32"
Global xCreateScript%(data%, length%) "win32"

' load library
Global lib% = LoadLibraryA(gxScriptLibName)

' Read functionds addresses
If lib%
	xCreateScript = GetProcAddress(lib, "_xCreateScript@8")
	xLoadScript_ = GetProcAddress(lib, "_xLoadScript@4")
	xExecuteScript_ = GetProcAddress(lib, "_xExecuteScript@8")
	xDeleteScript = GetProcAddress(lib, "_xDeleteScript@4")
	xSetIntegerVariable_ = GetProcAddress(lib, "_xSetIntegerVariable@12")
	xGetIntegerVariable_ = GetProcAddress(lib, "_xGetIntegerVariable@8")
	xSetFloatVariable_ = GetProcAddress(lib, "_xSetFloatVariable@12")
	xGetFloatVariable_ = GetProcAddress(lib, "_xGetFloatVariable@8")
	xSetStringVariable_ = GetProcAddress(lib, "_xSetStringVariable@12")
	xGetStringVariable_ = GetProcAddress(lib, "_xGetStringVariable@8")
	xRegisterFunction_ = GetProcAddress(lib, "_xRegisterFunction@8")
	xSetIntegerArg = GetProcAddress(lib, "_xSetIntegerArg@8")
	xSetFloatArg = GetProcAddress(lib, "_xSetFloatArg@8")
	xSetStringArg_ = GetProcAddress(lib, "_xSetStringArg@8")
	xGetIntegerReturn = GetProcAddress(lib, "_xGetIntegerReturn@0")
	xGetFloatReturn = GetProcAddress(lib, "_xGetFloatReturn@0")
	xGetStringReturn_ = GetProcAddress(lib, "_xGetStringReturn@0")
Else
	RuntimeError("Invalid " + gxScriptLibName) 
	End
End If

' library functions
Function xLoadScript%(fileName:String)
	Return xLoadScript_(String(fileName).ToCString()) 
End Function

Function xExecuteScript%(script%, entryPoint:String)
	Return xExecuteScript_(script%, String(entryPoint).ToCString()) 
End Function

Function xSetIntegerVariable(script%, varName:String, value%)
	xSetIntegerVariable_(script, String(varName).ToCString(), value)
End Function

Function xGetIntegerVariable%(script%, varName:String)
	Return xGetIntegerVariable_(script, String(varName).ToCString())
End Function

Function xSetFloatVariable(script%, varName:String, value#)
	xSetFloatVariable_(script, String(varName).ToCString(), value)
End Function

Function xGetFloatVariable#(script%, varName:String)
	Return xGetFloatVariable_(script, String(varName).ToCString())
End Function

Function xSetStringVariable(script%, varName:String, value:String)
	xSetStringVariable_(script, String(varName).ToCString(), String(value).ToCString())
End Function

Function xRegisterFunction(decl:String, funcAddr%)
	xRegisterFunction_(String(decl).ToCString(), funcAddr)
End Function

Function xSetStringArg(index%, value:String)
	xSetStringArg_(index, String(value).ToCString())
End Function

Function xGetStringVariable:String(script%, varName:String)
	Local CharSet:Byte Ptr = xGetStringVariable_(script, String(varName).ToCString())
	Local value$, CharI%
	Repeat
		If CharSet[CharI]=Null Return value
		value:+Chr(Int(CharSet[CharI]))
		CharI:+1
	Forever
End Function

Function xGetStringReturn:String()
	Local CharSet:Byte Ptr = xGetStringReturn_()
	Local value$, CharI%
	Repeat
		If CharSet[CharI]=Null Return value
		value:+Chr(Int(CharSet[CharI]))
		CharI:+1
	Forever
End Function