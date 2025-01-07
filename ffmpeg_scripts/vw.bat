@echo off
set INAME=%1
set FNAME=%INAME:.=&rem.%
ffmpeg -i %INAME% -q:a 2 -q:v 2 -vcodec wmv2 -acodec wmav2 %FNAME%.wmv
exit