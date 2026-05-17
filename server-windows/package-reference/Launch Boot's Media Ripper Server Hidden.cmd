@echo off
set "SCRIPT_DIR=%~dp0"
set "SERVER_PS1=%SCRIPT_DIR%.assets\BootsMediaRipperServer.ps1"

if not exist "%SERVER_PS1%" (
    msg * "Boot's Media Ripper Server script not found: %SERVER_PS1%"
    exit /b 1
)

start "" /min powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SERVER_PS1%"
