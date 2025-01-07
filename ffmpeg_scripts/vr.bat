@echo off
set INAME=%1
set ANGLE=%2
set FNAME=%INAME:.=&rem.%

if "%ANGLE%" == "f" (
  goto :flip
) else if "%ANGLE%" == "180" (
  goto :rotate_180
) else if "%ANGLE%" == "r" (
  goto :rotate_right
) else (
  goto :rotate_left
)

:rotate_left
echo Rotate left and export %INAME% to %FNAME%_r.mp4
ffmpeg -i %INAME% -codec:v libx264 -preset slow -crf 18 -codec:a copy -vf "transpose=2" %FNAME%_r.mp4
goto :eof

:rotate_right
echo Rotate right degree and export %INAME% to %FNAME%_r.mp4
ffmpeg -i %INAME% -codec:v libx264 -preset slow -crf 18 -codec:a copy -vf "transpose=1" %FNAME%_r.mp4
goto :eof

:rotate_180
echo Rotate 180 degree and export %INAME% to %FNAME%_r.mp4
ffmpeg -i %INAME% -codec:v libx264 -preset slow -crf 18 -codec:a copy -vf "transpose=2,transpose=2" %FNAME%_r.mp4
goto :eof

:flip
echo Vertical flip and export %INAME% to %FNAME%_r.mp4
ffmpeg -i %INAME% -codec:v libx264 -preset slow -crf 18 -codec:a copy -vf "transpose=0" %FNAME%_r.mp4
goto :eof
