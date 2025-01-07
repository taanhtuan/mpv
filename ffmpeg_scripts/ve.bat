@echo off
set INAME=%1
set ST=%2
set ET=%3
set FNAME=%INAME:.=&rem.%

if "%ST%" == "" (
  goto :encode_full
) else if "%ET%" == "" (
  goto :encode_at
) else (
  goto :encode_segment
)

:encode_full
echo Re-encoding %INAME% to %FNAME%_e.mp4
ffmpeg -i %INAME% -c:v libx264 -crf 18 -preset slow -c:a aac -q:a 100 %FNAME%_e.mp4
goto :eof

:encode_at
echo Re-encoding %INAME% to %FNAME%_e.mp4, starting at %ST% to the end
ffmpeg -ss %ST% -i %INAME% -c:v libx264 -crf 18 -preset slow -c:a aac -q:a 100 %FNAME%_e.mp4
goto :eof

:encode_segment
echo Re-encoding %INAME% to %FNAME%_e.mp4, starting at %ST% to %ET%
ffmpeg -ss %ST% -to %ET% -i %INAME% -c:v libx264 -crf 18 -preset slow -c:a aac -q:a 100 %FNAME%_e.mp4
goto :eof