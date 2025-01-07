::https://stackoverflow.com/questions/7333232/how-to-concatenate-two-mp4-files-using-ffmpeg
::https://stackoverflow.com/questions/19835849/batch-script-iterate-through-arguments
@echo off
setlocal EnableDelayedExpansion
set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)
set /A inputCount=%argCount%-1
echo Merging %inputCount% files into !argVec[%argCount%]! without re-encoding
(for /L %%i in (1,1,%inputCount%) do echo file '!argVec[%%i]!')>mvlist.tmp
ffmpeg -safe 0 -f concat -i mvlist.tmp -c copy !argVec[%argCount%]!
del mvlist.tmp
exit /B