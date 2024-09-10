@echo off

( call :cleanup_venv ) 
( call :set_alias python3 || call :set_alias python || call :set_alias py )

if not defined PYTHON (
    echo Error, could not detect valid python in system path && goto :eof
) 

echo Creating virtual environment

set VIRTUAL_ENV=%HOMEPATH%\.venv

( %PYTHON% -m venv %VIRTUAL_ENV% && echo Virtual environment created ) || (
    echo Error, could not create environment && goto :eof
)

if not exist %VIRTUAL_ENV%\Scripts\python.exe (
    echo Error, something went wrong creating environment (python.exe missing) && goto :eof
)

if exist %VIRTUAL_ENV%\Scripts\activate.bat (
    set VIRTUAL_ENV_ACTIVATE=%VIRTUAL_ENV%\Scripts\activate.bat
) else (
    echo Error, something went wrong creating environment (activate.bat missing) && goto :eof
)

if exist %VIRTUAL_ENV%\Scripts\deactivate.bat (
    set VIRTUAL_ENV_DEACTIVATE=%VIRTUAL_ENV%\Scripts\deactivate.bat
) else (
    echo Error, something went wrong creating environment (deactivate.bat missing) && goto :eof
)

( call :activate ) || ( echo Error, something went wrong activating environment && goto :eof )

echo Starting package installation
for /f "delims=" %%i in ('where %PYTHON%') do (
    if %%i == %VIRTUAL_ENV%\Scripts\python.exe ( 
        set PYTHON=%%i
        %%i -m pip install -r requirements.txt > nul && %%i -m pip list || (
            echo Error installing packages && call :cleanup_venv && goto :eof
        )
    )
)

if exist test.py (
    echo Starting quick test && call %PYTHON% test.py 2> nul && echo Test ok! || (
        echo Test failed... && call :cleanup_venv && goto :eof
    )
)

echo Python virtual environment ready and active
goto :eof

:cleanup_venv
    if defined VIRTUAL_ENV (
        echo Cleaning up old environment
        ( call :deactivate ) || ( echo Error, something went wrong deactivating environment )
        rmdir /s /q %VIRTUAL_ENV%
    )
    set PYTHON= 
    set VIRTUAL_ENV=
    set VIRTUAL_ENV_ACTIVATE=
    set VIRTUAL_ENV_DEACTIVATE=
    exit /b 0

:activate 
    call %VIRTUAL_ENV_ACTIVATE% && echo Virtual environment activated && exit /b 0 || exit /b 1

:deactivate
    call %VIRTUAL_ENV_DEACTIVATE% && echo Virtual environment deactivated && exit /b 0 || exit /b 1
    
:set_alias 
    setlocal
    ( where %~1 2> nul 1> nul && for /f "delims=" %%a in ('%~1 --version') do set pythonVersion=%%a ) || endlocal && exit /b 1
    set minimumPythonVersion=Python 3.5
    for /f "tokens=2,3,4 delims=. " %%a in ("%minimumPythonVersion%") do (
        for /f "tokens=2,3,4 delims=. " %%i in ("%pythonVersion%") do (
            if %%i geq %%a (
                if %%j geq %%b (
                    echo System Alias: %~1 && echo Python Version: %pythonVersion% 
                    endlocal && set PYTHON=%~1 && exit /b 0
                )
            )
        )
    )
    echo Warning, found python installed under alias %~1 with version %pythonVersion% but needs upgrade to %minimumPythonVersion% 
    endlocal && exit /b 1

