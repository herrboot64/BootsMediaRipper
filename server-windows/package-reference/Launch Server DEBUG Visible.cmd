@echo off
title Boot's Media Ripper Server - DEBUG visible launcher
set "SCRIPT_DIR=%~dp0"
set "SERVER_PS1=%SCRIPT_DIR%.assets\BootsMediaRipperServer.ps1"

echo Boot's Media Ripper Server visible debug launcher
echo.
echo Script:
echo   %SERVER_PS1%
echo.

if not exist "%SERVER_PS1%" (
    echo ERROR: Server script not found.
    pause
    exit /b 1
)

powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%SERVER_PS1%"
pause
