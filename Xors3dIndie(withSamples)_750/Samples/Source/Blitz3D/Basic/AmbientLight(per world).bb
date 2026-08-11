Include "..\xors3d.bb"

xGraphics3d 1024, 768, 32, 0, 1

Global world0 = xGetDefaultWorld()
Global camera0 = xCreateCamera()
Global cube0 = xCreateCube()
xPositionEntity cube0, 0, 0, 5
xAmbientLight(255, 0, 0)

Global world1 = xCreateWorld()
xSetActiveWorld(world1)
Global camera1 = xCreateCamera()
Global cube1 = xCreateCube()
xPositionEntity cube1, 0, 0, 5
;xAmbientLight(0, 0, 255)

xSetActiveWorld(world0)
xAmbientLight(0, 0, 255, world1)

Global worldNum = 0
While Not xKeyHit(KEY_ESCAPE)
	
	xTurnEntity cube0, .1, .1, .1
	xTurnEntity cube1, -.1, -.1, -.1
	
	If xKeyHit(KEY_SPACE)
		worldNum = 1 - worldNum
		If worldNum = 0
			xSetActiveWorld(world0)
		Else
			xSetActiveWorld(world1)
		EndIf
	EndIf
	
	xRenderWorld()
	xText 10, 10, "Press <Space> to toggle world"
	xText 10, 25, "World #" + worldNum
	xFlip
Wend
End
;~IDEal Editor Parameters:
;~C#Blitz3D