call :remux m4a
call :remux mp4a

:remux
for %%a in ("*.%~1") do (
  if exist "%%~a" (
    if exist "%%~na.mp4" (
      va %%~na.mp4 %%~a
      del %%~na.mp4
    )

    if exist "%%~na.webm" (
      va %%~na.webm %%~a
      del %%~na.webm
    )
    
    del %%~a
  )
)
