@echo off
set INAME=%1
set FR=%2
set SPEED=1
set FNAME=%INAME:.=&rem.%

if "%~3"=="e" (
  call :fr_encode %4
  goto :eof
) else (
  goto :fr_copy
)

:fr_copy
echo Converting %INAME% to %FNAME%_fr%FR%.mp4 at framerate %FR% without re-encoding
ffmpeg -i %INAME% -c copy -f h264 %FNAME%.h264
ffmpeg -r %FR% -i %FNAME%.h264 -c copy %FNAME%_fr%FR%.mp4
del %FNAME%.h264
goto :eof

:fr_encode
if not "%~1"=="" set SPEED=%~1
echo Re-encoding %INAME% to %FNAME%_fr%FR%.mp4 at framerate %FR% and speed %SPEED%
ffmpeg -i %INAME% -vf "setpts=%SPEED%*PTS" -r %FR% %FNAME%_fr%FR%.mp4
exit /b 0
