@echo off
if not defined VIRTUAL_ENV (
    set VIRTUAL_ENV=%USERPROFILE%\venv
)
if not exist %VIRTUAL_ENV%\Scripts\deactivate.bat (
    echo Error, could not deactivate virtual environment (deactivate.bat is missing) && exit /b 1
)
call %VIRTUAL_ENV%\Scripts\deactivate.bat 
for /f "delims=" %%a in ('where python') do ( 
    if %%a == %VIRTUAL_ENV%\Scripts\python.exe (
        echo Error, deactivating virtual environment failed && exit /b 1
    )
)
echo Virtual environment deactivated && exit /b 0