@echo off

call .\env.bat INIT || goto :ERROR

if not exist %VIRTUAL_ENV%\Scripts\activate.bat (
    set ERR=activate.bat is missing
    goto :ERROR
)

if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    set ERR=python.exe is missing
    goto :ERROR
)

call %VIRTUAL_ENV%\Scripts\activate.bat
for /f "delims=" %%a in ('where python') do ( 
    if %%a == %VIRTUAL_ENV%\Scripts\python.exe (
        set PYTHON=python
        echo Virtual environment activated
        exit /b 0
    ) 
)

:ERROR
    if not defined ERR set ERR=unknown reason
    echo Error, activating virtual environment failed (%ERR%)
    call .\env.bat CLEANUP
    set ERR=
    exit /b 1
