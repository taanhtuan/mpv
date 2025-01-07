:: https://stackoverflow.com/questions/9913032/how-can-i-extract-audio-from-video-with-ffmpeg
:: https://stackoverflow.com/questions/61946575/problem-using-ffmpeg-to-convert-mkv-with-a-52-b-audio-aka-e-ac3-to-aac
:: https://superuser.com/questions/516806/how-to-encode-audio-with-opus-codec
:: ffmpeg -i <input> -c:a libopus -b:a bitrate <output>
:: https://www.reddit.com/r/ffmpeg/comments/1fq4lf5/can_someone_explain_opus_libopus_encoder/
:: It has two modes of compression "celt" and "silk" which are good at different kinds of audio compression. A single audio file can switch between modes whenever.
:: By specifying -c:a libopus, you are using the libopus encoder, and not ffmpeg's opus encoder, so youll get better results than using -c:a opus.
:: recommend bitrate: 2.1 128k, 5.1 384k
:: usage 1: extract 3rd audio stream input.mkv starting from 5.5 seconds to 1 minute 30 seconds, and reencode in AAC format at 192k bitrate, then export to file input.acc
:: vea input.mkv aac 2 00:00:05.500 00:01:30 192
:: usage 2: simple export full first track to AAC at highest quality
:: vea input.mkv
@echo off
setlocal EnableDelayedExpansion
set INAME=%1
set FNAME=%INAME:.=&rem.%
set LIB=aac
set SUBFIX=.vi

if "%2" == "" (
  call :extract_audio aac 0 00:00:00
) else (
  if "%2" == "mp3" (
    set LIB=libmp3lame -q:a 4
  ) else (
    if "%2" == "opus" (
      set LIB=libopus
    )
  )

  if "%3" == "" (
    call :extract_audio %2 0 00:00:00
  ) else (
    if "%4" == "" (
        call :extract_audio %2 %3 00:00:00
    ) else (
      if "%5" == "" (
        call :extract_audio %2 %3 %4
      ) else (
        if "%6" == "" (
          call :extract_audio %2 %3 %4 %5
        ) else (
          call :extract_audio %2 %3 %4 %5 %6
        )
      )
    )
  )
)
goto :eof

:extract_audio
echo Extracts audio stream %~2 from %INAME%, then uses [%LIB%] to convert to file %FNAME%%SUBFIX%.%~1
if "%~4" == "" (
  ffmpeg -i %INAME% -ss %~3 -map 0:a:%~2 -c:a %LIB% %FNAME%%SUBFIX%.%~1
) else (
  if "%~5" == "" (
    ffmpeg -i %INAME% -ss %~3 -to %~4 -map 0:a:%~2 -c:a %LIB% %FNAME%%SUBFIX%.%~1
  ) else (
    ffmpeg -i %INAME% -ss %~3 -to %~4 -map 0:a:%~2 -c:a %LIB% -b:a %~5k %FNAME%%SUBFIX%.%~1
  ) 
)
exit /b