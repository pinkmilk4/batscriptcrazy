@echo off
if not defined VIRTUAL_ENV (
    set VIRTUAL_ENV=%USERPROFILE%\venv
)
if not exist %VIRTUAL_ENV%\Scripts\activate.bat (
    echo Error, could not activate virtual environment (activate.bat is missing) && goto :ERROR
)
if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    echo Error, could not activate virtual environment (python.exe missing) && goto :ERROR
)
call %VIRTUAL_ENV%\Scripts\activate.bat
for /f "delims=" %%a in ('where python') do ( 
    if %%a == %VIRTUAL_ENV%\Scripts\python.exe (
        set PYTHON=python && echo Virtual environment activated && exit /b 0
    )
)
echo Error, activating virtual environment failed && goto :ERROR
:ERROR
    set VIRTUAL_ENV= 
    exit /b 1