# Setup-BMR-Server-RunAsAdmin.ps1
# Run once as Administrator on BOOT-MSI.
[CmdletBinding()]param([int]$Port=8787,[string]$User='Everyone')
$ErrorActionPreference='Stop'
$prefix="http://+:$Port/"
Write-Host "Adding URL ACL for $prefix"
netsh http delete urlacl url=$prefix 2>$null | Out-Null
netsh http add urlacl url=$prefix user=$User
Write-Host "Adding firewall rule for TCP $Port"
$rule="Boot's Media Ripper Server TCP $Port"
Get-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName $rule -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port -Profile Private | Out-Null
Write-Host "Done. Open http://home-server.local:$Port/ after launching server."
pause

