@echo off
rem Launch the "Craft" voxel game directly (32-bit PHP + FFI).
rem Double-click this file, or run:  craft.bat
rem Optional: craft.bat 300   -> auto-exit after 300 frames (for testing).
setlocal
set "PHP=%~dp0phpx86\php.exe"
"%PHP%" "%~dp0xors3d-php\app.php" minecraft %*
endlocal
