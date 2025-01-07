::https://askubuntu.com/questions/866186/how-to-get-good-quality-when-converting-digital-video
::https://www.reddit.com/r/ffmpeg/comments/d3cwxp/what_is_the_difference_between_bwdif_and_yadif1/
::https://forum.doom9.org/showthread.php?t=176951
::https://github.com/kfrn/ffmpeg-things/blob/master/deinterlacing.md
@echo off
setlocal EnableDelayedExpansion
set INAME=%1
set ST=%2
set ET=%3
set FNAME=%INAME:.=&rem.%
set FILTER=bwdif
set MODEL="E:\app\ffmpeg\scripts\nnedi3_weights.bin"

if "%ST%" == "" (
  goto :deinterlace_full
) else if "%ST%" == "n" (
  set "FILTER=nnedi=weights=nnedi3_weights.bin,format=yuv420p"
  xcopy %MODEL% .
  goto :deinterlace_full
  if exist nnedi3_weights.bin del nnedi3_weights.bin
) else  if "%ST%" == "y" (
  set "FILTER=yadif=0:-1:0"
  goto :deinterlace_full
) else if "%ET%" == "" (
  goto :deinterlace_at
) else (
  goto :deinterlace_segment
)

:deinterlace_full
echo Deinterlace %INAME% to %FNAME%_i.mp4 by filter !FILTER!
ffmpeg -i %INAME% -c:a copy -c:v libx264 -crf 18 -vf !FILTER! -preset slow %FNAME%_i.mp4
goto :eof

:deinterlace_at
echo Deinterlace %INAME% to %FNAME%_i.mp4, starting at %ST% to the end, by filter %FILTER%
ffmpeg -ss %ST% -i %INAME% -c:a copy -c:v libx264 -crf 18 -vf %FILTER% -preset slow %FNAME%_i.mp4
goto :eof

:deinterlace_segment
echo Deinterlace %INAME% to %FNAME%_i.mp4, starting at %ST% to %ET%, by filter %FILTER%
ffmpeg -ss %ST% -to %ET% -i %INAME% -c:a copy -c:v libx264 -crf 18 -vf %FILTER% -preset slow %FNAME%_i.mp4
goto :eof
