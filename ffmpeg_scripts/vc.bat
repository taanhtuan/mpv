@echo off
set INAME=%1
set ST=%2
set ET=%3
set FNAME=%INAME:.=&rem.%

if "%INAME%" == "ts" (
  goto :copy_ts
) else if "%ST%" == "" (
  call :copy_full %INAME% %FNAME%_c.mp4
  goto :eof
) else if "%ET%" == "" (
  goto :copy_at
) else (
  goto :copy_segment
)

:copy_ts
for %%f in (*.ts) do (
  if "%%~xf"==".ts" call :copy_full %%f %%~nf_c.mp4
)
goto :eof

:copy_full
echo Converting %~1 to %~2 without re-encoding
ffmpeg -i %~1 -c copy %~2
exit /b

:copy_at
echo Converting %INAME% to %FNAME%_c.mp4 without re-encoding, starting at %ST% to the end
ffmpeg -ss %ST% -i %INAME% -c copy %FNAME%_c.mp4
goto :eof

:copy_segment
echo Converting %INAME% to %FNAME%_c.mp4 without re-encoding, starting at %ST% to %ET%
ffmpeg -ss %ST% -to %ET% -i %INAME% -c copy %FNAME%_c.mp4
goto :eof
