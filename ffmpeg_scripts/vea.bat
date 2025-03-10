:: https://stackoverflow.com/questions/9913032/how-can-i-extract-audio-from-video-with-ffmpeg
:: https://stackoverflow.com/questions/61946575/problem-using-ffmpeg-to-convert-mkv-with-a-52-b-audio-aka-e-ac3-to-aac
:: https://superuser.com/questions/516806/how-to-encode-audio-with-opus-codec
:: ffmpeg -i <input> -c:a libopus -b:a bitrate <output>
:: https://www.reddit.com/r/ffmpeg/comments/1fq4lf5/can_someone_explain_opus_libopus_encoder/
:: It has two modes of compression "celt" and "silk" which are good at different kinds of audio compression. A single audio file can switch between modes whenever.
:: By specifying -c:a libopus, you are using the libopus encoder, and not ffmpeg's opus encoder, so youll get better results than using -c:a opus.
:: https://www.reddit.com/r/ffmpeg/comments/v4s61h/correctly_mapping_51_to_opus/
:: The issue is the channel layout mismatch between AC-3/DTS and Opus.
:: AC-3 and DTS use the 5.1(side) layout (FL FR FC LFE SL SR), the Opus spec only allows the 5.1 layout (FL FR FC LFE BL BR). 
:: The easiest solution is to use the channelmap-filter to map the two side speakers to the back speakers.
:: -filter:a "channelmap=FL-FL|FR-FR|FC-FC|LFE-LFE|SL-BL|SR-BR:5.1"
:: Explicitly setting the switch -ac 6 is the solution. You can also set -mapping_family 1.
::
:: recommend bitrate: 
:: aac  (64kb/1ch): 2.0 128k,     5.1 384k,      7.1 512k-640k
:: opus (48kb/1ch): 2.0 96k-128k, 5.1 256k-288k, 7.1 450k (https://wiki.xiph.org/Opus_Recommended_Settings)
::
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
set EXT=aac

if "%2" == "" (
  call :extract_audio aac 0 00:00:00
) else (
  set EXT=%2
  if "%2" == "mp3" (
    set LIB=libmp3lame -q:a 4
  ) else (
    if "%2" == "opus" (
      set LIB=libopus
    ) else (
      if "%2" == "opus6" (
        set LIB=libopus -ac 6 -mapping_family 1
        set EXT=opus
        set SUBFIX=_5.1%SUBFIX%
      ) else (
        if "%2" == "aac6" (
          set LIB=aac -ac 6
          set EXT=aac
          set SUBFIX=_5.1%SUBFIX%
        )
      )
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
  ffmpeg -i %INAME% -ss %~3 -map 0:a:%~2 -c:a %LIB% %FNAME%%SUBFIX%.%EXT%
) else (
  if "%~5" == "" (
    ffmpeg -i %INAME% -ss %~3 -to %~4 -map 0:a:%~2 -c:a %LIB% %FNAME%%SUBFIX%.%EXT%
  ) else (
    ffmpeg -i %INAME% -ss %~3 -to %~4 -map 0:a:%~2 -c:a %LIB% -b:a %~5k %FNAME%%SUBFIX%.%EXT%
  ) 
)
exit /b