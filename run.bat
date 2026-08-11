@echo off
rem Launch the Xors3d PHP app through the front controller (FFI, 32-bit PHP).
rem Usage:  run.bat <route> [args...]
rem   run.bat                 open the interactive demo launcher (menu)
rem   run.bat info            show engine info (no window)
rem   run.bat simple          run the spinning-cube sample (ESC to quit)
rem   run.bat simple 300      auto-exit after 300 frames
rem   run.bat help            list routes

setlocal
set "PHP=%~dp0phpx86\php.exe"
"%PHP%" "%~dp0xors3d-php\app.php" %*
endlocal
