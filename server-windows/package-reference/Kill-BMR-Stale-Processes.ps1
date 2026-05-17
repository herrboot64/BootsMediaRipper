# Kill-BMR-Stale-Processes.ps1
# Kills stale Boot's Media Ripper PowerShell worker processes.

$ErrorActionPreference = "Continue"
$root = $PSScriptRoot
$logs = Join-Path $root "LOGS"
New-Item -ItemType Directory -Path $logs -Force | Out-Null
$log = Join-Path $logs "kill_stale_processes.log"

function Log($m){
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $m"
    Write-Host $line
    Add-Content -Path $log -Value $line
}

Log "Scanning for stale Boot's Media Ripper processes..."

$matches = Get-CimInstance Win32_Process | Where-Object {
    $_.ProcessId -ne $PID -and
    $_.CommandLine -and
    (
        $_.CommandLine -like '*BootsMediaRipperHttpServer.ps1*' -or
        $_.CommandLine -like '*BootsMediaRipperServer.ps1*'
    )
}

foreach($p in @($matches)){
    Log "Killing PID $($p.ProcessId): $($p.CommandLine)"
    Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue
}

$pidFile = Join-Path $root ".assets\server_http.pid"
if(Test-Path $pidFile){
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    Log "Removed pid file: $pidFile"
}

Log "Done."
pause
