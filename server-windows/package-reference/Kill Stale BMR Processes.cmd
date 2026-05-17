@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Kill-BMR-Stale-Processes.ps1"
