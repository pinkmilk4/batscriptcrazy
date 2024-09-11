@echo off

( call :cleanup_venv ) 
( call :set_alias python3 || call :set_alias python || call :set_alias py )
if not defined PYTHON (
    echo Error, could not detect valid python in system path && goto :eof
) 

set VIRTUAL_ENV=%USERPROFILE%\venv
( %PYTHON% -m venv %VIRTUAL_ENV% && echo Virtual environment created ) || (
    echo Error, could not create environment && goto :eof
)

if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    echo Error, something went wrong creating environment (python.exe missing) && goto :eof
)

call ./activate.bat || ( call :cleanup_venv && goto :eof )

echo Starting package installation
%PYTHON% -m pip install -r requirements.txt > nul && %PYTHON% -m pip list || (
    echo Error, installing packages failed && call :cleanup_venv && goto :eof
)
echo Installation complete

if exist test.py (
    echo Starting quick test && call %PYTHON% test.py 2> nul && echo Test ok! || (
        echo Test failed... && call :cleanup_venv && goto :eof
    )
)

echo Python virtual environment ready and active
goto :eof

:cleanup_venv
    set PYTHON=
    if exist %VIRTUAL_ENV% (
        echo Cleaning up environment %VIRTUAL_ENV%
        call ./deactivate.bat
        rmdir /s /q %VIRTUAL_ENV%
    )
    exit /b 0
    
:set_alias 
    setlocal
    ( where %~1 2> nul 1> nul && for /f "delims=" %%a in ('%~1 --version') do set pythonVersion=%%a ) || endlocal && exit /b 1
    set minimumPythonVersion=Python 3.5
    for /f "tokens=2,3,4 delims=. " %%a in ("%minimumPythonVersion%") do (
        for /f "tokens=2,3,4 delims=. " %%i in ("%pythonVersion%") do (
            if %%i geq %%a (
                if %%j geq %%b (
                    echo Python Version: %pythonVersion% 
                    endlocal && set PYTHON=%~1 && exit /b 0
                )
            )
        )
    )
    echo Warning, found python installed under alias %~1 with version %pythonVersion% but needs upgrade to %minimumPythonVersion% 
    endlocal && exit /b 1

