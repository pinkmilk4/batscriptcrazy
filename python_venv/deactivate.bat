@echo off

call .\env.bat INIT || goto :ERROR

if not exist %VIRTUAL_ENV%\Scripts\deactivate.bat (
   set ERR=deactivate.bat is missing
   goto :ERROR 
)

if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    set ERR=python.exe is missing
    goto :ERROR
)

@REM deactivate will unset VIRTUAL_ENV 
set PY_EXE=%VIRTUAL_ENV%\Scripts\python.exe

call %VIRTUAL_ENV%\Scripts\deactivate.bat 
for /f "delims=" %%a in ('where python') do if %%a == %PY_EXE% (
    set ERR=%PY_EXE% still activated
    goto :ERROR
)

echo Virtual environment deactivated 
goto :EXIT

:ERROR 
if not defined ERR set ERR=unknown reason
echo Error, deactivating virtual environment failed (%ERR%) 
goto :EXIT

:EXIT
set ERR= 
set PY_EXE=
call .\env.bat CLEANUP
goto :eof
