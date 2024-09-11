@echo off

if "%~1"=="INIT" (
    for /f "tokens=1,2 delims==" %%a in ('type .env') do call set %%a=%%b

    if not defined VIRTUAL_ENV goto :ERROR
    if not defined VIRTUAL_ENV_REQUIREMENTS goto :ERROR
    if not defined PYTHONPATH goto :ERROR
    exit /b 0
)

if "%~1"=="CLEANUP" (
    for /f "tokens=1,2 delims==" %%a in ('type .env') do call set %%a=
    if defined VIRTUAL_ENV goto :ERROR
    if defined VIRTUAL_ENV_REQUIREMENTS goto :ERROR
    if defined PYTHONPATH goto :ERROR
    exit /b 0
)

echo Error, please specify INIT or CLEANUP to configure environment variables 
exit /b 1

:ERROR
echo Error, %~1 environment variables failed 
exit /b 1