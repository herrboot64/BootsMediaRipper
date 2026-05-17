@echo off
title Boot's Media Ripper HTTP Syntax Test
set "SCRIPT_DIR=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$null = [scriptblock]::Create((Get-Content -Raw '%SCRIPT_DIR%.assets\BootsMediaRipperHttpServer.ps1')); Write-Host 'Syntax OK'; pause"
