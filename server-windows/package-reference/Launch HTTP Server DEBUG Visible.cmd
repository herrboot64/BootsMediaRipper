@echo off
title Boot's Media Ripper HTTP Server - DEBUG
set "SCRIPT_DIR=%~dp0"
set "HTTP_PS1=%SCRIPT_DIR%.assets\BootsMediaRipperHttpServer.ps1"

powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%HTTP_PS1%" -AppRoot "%SCRIPT_DIR%" -AssetsRoot "%SCRIPT_DIR%.assets" -OutputRoot "%SCRIPT_DIR%OUTPUT" -ConfigPath "%SCRIPT_DIR%.assets\server_config.json"
pause
