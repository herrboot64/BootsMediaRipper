# Force-Apply-EmbyRipper-Icon.ps1
# Injects .assets\bmrIcon.ico into BootsMediaRipperServer.exe.
# Run from the server app root.

[CmdletBinding()]
param(
    [string]$ExePath = (Join-Path $PSScriptRoot "BootsMediaRipperServer.exe"),
    [string]$IconPath = (Join-Path $PSScriptRoot ".assets\bmrIcon.ico")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ExePath)) { throw "EXE not found: $ExePath" }
if (-not (Test-Path -LiteralPath $IconPath)) { throw "ICO not found: $IconPath" }

$backupPath = "$ExePath.pre_emby_icon_backup"
if (-not (Test-Path -LiteralPath $backupPath)) {
    Copy-Item -LiteralPath $ExePath -Destination $backupPath -Force
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class BmrRes {
    [DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern IntPtr BeginUpdateResource(string pFileName, bool bDeleteExistingResources);
    [DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern bool UpdateResource(IntPtr hUpdate, IntPtr lpType, IntPtr lpName, ushort wLanguage, byte[] lpData, int cbData);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool EndUpdateResource(IntPtr hUpdate, bool fDiscard);
    public static IntPtr MAKEINTRESOURCE(int id) { return new IntPtr(id); }
}
"@

function U16([byte[]]$b,[int]$o){ [BitConverter]::ToUInt16($b,$o) }
function U32([byte[]]$b,[int]$o){ [BitConverter]::ToUInt32($b,$o) }
function S16([byte[]]$b,[int]$o,[UInt16]$v){ [Array]::Copy([BitConverter]::GetBytes($v),0,$b,$o,2) }
function S32([byte[]]$b,[int]$o,[UInt32]$v){ [Array]::Copy([BitConverter]::GetBytes($v),0,$b,$o,4) }

$ico=[IO.File]::ReadAllBytes($IconPath)
if((U16 $ico 0) -ne 0 -or (U16 $ico 2) -ne 1){ throw "Invalid ICO file." }
$count=U16 $ico 4
if($count -lt 1){ throw "ICO has no images." }

$entries=@()
for($i=0;$i -lt $count;$i++){
    $eo=6+($i*16)
    $bytes=U32 $ico ($eo+8)
    $offset=U32 $ico ($eo+12)
    $data=New-Object byte[] $bytes
    [Array]::Copy($ico,[int]$offset,$data,0,[int]$bytes)
    $entries += [pscustomobject]@{
        Width=$ico[$eo]; Height=$ico[$eo+1]; Color=$ico[$eo+2]; Reserved=$ico[$eo+3];
        Planes=(U16 $ico ($eo+4)); Bits=(U16 $ico ($eo+6)); Bytes=$bytes; Data=$data; Id=($i+1)
    }
}

$group=New-Object byte[] (6+($count*14))
S16 $group 0 0
S16 $group 2 1
S16 $group 4 ([UInt16]$count)

for($i=0;$i -lt $count;$i++){
    $e=$entries[$i]; $o=6+($i*14)
    $group[$o]=$e.Width; $group[$o+1]=$e.Height; $group[$o+2]=$e.Color; $group[$o+3]=$e.Reserved
    S16 $group ($o+4) ([UInt16]$e.Planes)
    S16 $group ($o+6) ([UInt16]$e.Bits)
    S32 $group ($o+8) ([UInt32]$e.Bytes)
    S16 $group ($o+12) ([UInt16]$e.Id)
}

$RT_ICON=3; $RT_GROUP_ICON=14; $LANG=0; $GROUP_ID=1
$h=[BmrRes]::BeginUpdateResource($ExePath,$false)
if($h -eq [IntPtr]::Zero){ throw "BeginUpdateResource failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())" }
$discard=$true
try{
    foreach($e in $entries){
        $ok=[BmrRes]::UpdateResource($h,[BmrRes]::MAKEINTRESOURCE($RT_ICON),[BmrRes]::MAKEINTRESOURCE([int]$e.Id),[UInt16]$LANG,[byte[]]$e.Data,[int]$e.Data.Length)
        if(-not $ok){ throw "UpdateResource RT_ICON failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())" }
    }
    $ok=[BmrRes]::UpdateResource($h,[BmrRes]::MAKEINTRESOURCE($RT_GROUP_ICON),[BmrRes]::MAKEINTRESOURCE($GROUP_ID),[UInt16]$LANG,[byte[]]$group,[int]$group.Length)
    if(-not $ok){ throw "UpdateResource RT_GROUP_ICON failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())" }
    $discard=$false
}
finally{
    $ended=[BmrRes]::EndUpdateResource($h,$discard)
    if(-not $ended){ throw "EndUpdateResource failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())" }
}

Write-Host "Icon patched into:"
Write-Host "  $ExePath"
Write-Host ""
Write-Host "If Explorer still shows the old icon, restart Explorer or rename the EXE once."
pause
