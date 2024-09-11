@echo off

if not defined VIRTUAL_ENV (
    echo Error, could not activate virtual environment (VIRTUAL_ENV is not defined) && exit /b 1
)

if not exist %VIRTUAL_ENV%\Scripts\activate.bat (
    echo Error, could not activate virtual environment (activate.bat is missing) && exit /b 1
)

if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    echo Error, could not activate virtual environment (python.exe missing) && exit /b 1
)

call %VIRTUAL_ENV%\Scripts\activate.bat
for /f "delims=" %%a in ('where python') do ( 
    if %%a == %VIRTUAL_ENV%\Scripts\python.exe (
        set PYTHON=python && echo Virtual environment activated && exit /b 0
    )
)

echo Error, activating virtual environment failed && exit /b 1