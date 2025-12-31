:: https://www.reddit.com/r/ffmpeg/comments/pglq03/convert_vtt_to_srt_using_ffmpeg/
:: ffmpeg -i input.vtt -c:s subrip output.srt
:: ffmpeg -i input.vtt -vn -an -scodec srt output.srt
@echo off
set INAME=%1
set FNAME=%INAME:.=&rem.%
ffmpeg -i %INAME% %FNAME%.srt
