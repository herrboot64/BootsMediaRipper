@echo off
set "D=%~dp0"
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%D%.assets\BootsMediaRipperServer.ps1"
