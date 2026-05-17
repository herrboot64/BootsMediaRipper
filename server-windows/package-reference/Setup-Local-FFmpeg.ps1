# Setup-Local-FFmpeg.ps1
# Downloads a private app-local ffmpeg into:
#   .tools\ffmpeg\bin\ffmpeg.exe
#
# This avoids using TDARR/system ffmpeg and keeps Boot's Media Ripper self-contained.

[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$AppRoot = $PSScriptRoot
$ToolsRoot = Join-Path $AppRoot ".tools"
$DownloadRoot = Join-Path $ToolsRoot "downloads"
$FfmpegRoot = Join-Path $ToolsRoot "ffmpeg"
$FfmpegExe = Join-Path $FfmpegRoot "bin\ffmpeg.exe"
$LogsRoot = Join-Path $AppRoot "LOGS"
$LogPath = Join-Path $LogsRoot "setup_local_ffmpeg.log"

New-Item -ItemType Directory -Path $ToolsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $DownloadRoot -Force | Out-Null
New-Item -ItemType Directory -Path $LogsRoot -Force | Out-Null

function Log($m){
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $m"
    Write-Host $line
    Add-Content -Path $LogPath -Value $line
}

Log "Starting local ffmpeg setup."
Log "Target: $FfmpegExe"

if((Test-Path -LiteralPath $FfmpegExe) -and -not $Force){
    Log "Local ffmpeg already exists."
    & $FfmpegExe -version
    Write-Host ""
    Write-Host "Local ffmpeg is ready:"
    Write-Host "  $FfmpegExe"
    pause
    exit 0
}

# BtbN Windows builds are direct zip URLs and avoid scraping gyan.dev.
# This is a GPL build with ffmpeg.exe included.
$Url = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
$ZipPath = Join-Path $DownloadRoot "ffmpeg-master-latest-win64-gpl.zip"
$ExtractRoot = Join-Path $DownloadRoot "extract"

if(Test-Path $ExtractRoot){Remove-Item $ExtractRoot -Recurse -Force}
New-Item -ItemType Directory -Path $ExtractRoot -Force | Out-Null

Log "Downloading:"
Log "  $Url"
Log "To:"
Log "  $ZipPath"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing

Log "Extracting..."
Expand-Archive -Path $ZipPath -DestinationPath $ExtractRoot -Force

$found = Get-ChildItem -Path $ExtractRoot -Recurse -Filter ffmpeg.exe -File | Select-Object -First 1

if(-not $found){
    throw "Could not find ffmpeg.exe inside downloaded archive."
}

if(Test-Path $FfmpegRoot){Remove-Item $FfmpegRoot -Recurse -Force}
New-Item -ItemType Directory -Path (Join-Path $FfmpegRoot "bin") -Force | Out-Null

$sourceBin = Split-Path -Parent $found.FullName
Log "Copying ffmpeg bin folder:"
Log "  $sourceBin"
Copy-Item -Path (Join-Path $sourceBin "*") -Destination (Join-Path $FfmpegRoot "bin") -Recurse -Force

if(-not(Test-Path $FfmpegExe)){
    throw "Local ffmpeg setup failed. Missing: $FfmpegExe"
}

Log "Local ffmpeg installed."
Log "Testing ffmpeg..."
& $FfmpegExe -version

Write-Host ""
Write-Host "Local ffmpeg is ready:"
Write-Host "  $FfmpegExe"
Write-Host ""
pause
