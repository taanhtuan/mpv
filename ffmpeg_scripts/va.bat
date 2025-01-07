@echo off
set INAME=%1
set ANAME=%2
set FNAME=%INAME:.=&rem.%

if "%ANAME%" == "" (
  if exist %FNAME%.m4a (
    ffmpeg -i %INAME% -i %FNAME%.m4a -c:v copy -c:a aac %FNAME%_a.mp4
  ) else (
    ffmpeg -i %INAME% -i %FNAME%.weba -c:v copy -c:a aac %FNAME%_a.mp4
  )
) else (
  ffmpeg -i %INAME% -i %ANAME% -c:v copy -c:a aac %FNAME%_a.mp4
)
