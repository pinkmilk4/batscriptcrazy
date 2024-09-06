@echo off 
setlocal enabledelayedexpansion

@REM working directory is python_venv
set workingDir=%cd%
set venv=%workingDir%\venv
set venvRequirements=%workingDir%\requirements.txt

@REM find python alias for system
( 
    call :check_system_alias python3 && set pythonCmd=python3 
) || ( 
    call :check_system_alias python && set pythonCmd=python 
) || (
    call :check_system_alias py && set pythonCmd=py
) || (
    echo error could not find python.exe in system path && goto :eof
)

@REM create virtual environment
if exist %venv% (
    echo cleaning up environment
    ( call :deactivate_venv && rmdir /q /s %venv% ) || (
        echo error cleaning up virtual environment && goto :eof 
    )
)

( %pythonCmd% -m venv %venv% && echo virtual environment created ) || (
    echo error creating virtual environment && goto :eof 
)

@REM find alias for the virtual environment
( 
    call :check_venv_alias python3 && set pythonCmd=python3 
) || ( 
    call :check_venv_alias python && set pythonCmd=python 
) || (
    call :check_venv_alias py && set pythonCmd=py
) || (
    echo error could not find python.exe in virtual environment, exiting  && goto :eof
)

@REM activate virtual environment and install packages
( call :activate_venv ) || ( echo exiting %errorlevel% && goto :eof )

echo starting package installation
( %pythonCmd% -m pip install -r %venvRequirements% > nul ) || ( 
    echo error installing packages && call :deactivate_venv && goto :eof
)

echo virtual environment ready && call :deactivate_venv
goto :eof

:activate_venv
    if not exist %venv%\Scripts\activate.bat ( 
        echo error can't find virtual environment activate script && exit /b 1 
    )

    call %venv%\Scripts\activate.bat

    set /A isActive=0
    call :check_venv_activated isActive 
    if !isActive! == 0 ( 
        echo error could not activate virtual env &&  exit /b 1 
    ) 
    echo virtual env activated && exit /b 0

:deactivate_venv
    if not exist %venv%\Scripts\deactivate.bat ( 
        exit /b 0 
    )
    set /A isActive=0
    call :check_venv_activated isActive 
    if !isActive! == 1 (
        call %venv%\Scripts\deactivate.bat
        call :check_venv_activated isActive 
        if !isActive! == 1 ( 
            echo error could not deactivate virtual env && exit /b 1 
        )
        echo virtual env deactivated && exit /b 0
    )
    exit /b 0

:check_venv_activated
    for /f "delims= " %%i in ('where %pythonCmd%') do (
        if %%i == %venv%\Scripts\python.exe ( 
            set /A %~1=1 && exit /b 0 
        ) 
    )
    set /A %~1=0 && exit /b 0

:check_version
    @REM TODO: check version
    @REM for /f "delims=" %%i in ('%pythonAlias% --version') do ( set pythonVersion=%%i )
    @REM echo %pythonCmd% using version %pythonVersion%
    exit /b 0 

:check_system_alias 
    where %~1 2> nul 1> nul && exit /b 0 || exit /b 1  

:check_venv_alias
    if exist %venv%\Scripts\%~1.exe ( exit /b 0 ) else ( exit /b 1 )

endlocal