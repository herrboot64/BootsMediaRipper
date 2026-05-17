[CmdletBinding()]
param([switch]$FailOnWarnings)
$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
Set-Location $RepoRoot
$Warnings = New-Object System.Collections.Generic.List[string]
$Files = Get-ChildItem -Recurse -File -Force | Where-Object { $_.FullName -notmatch "\\.git\\" -and $_.Name -notlike "GitHubify-BootsMediaRipper*.ps1" }
foreach ($File in $Files) {
  $Rel = $File.FullName.Substring($RepoRoot.Length + 1).Replace("\","/")
  if ($Rel -match "server_config\.json|config\.json|clients\.json|secrets\.json|media_inventory|movies_inventory|tv_inventory|inventory_summary|inventory_log|All_Media_Summary|\.apk$|\.aab$|\.exe$") { $Warnings.Add("Suspicious file should not be committed: $Rel") }
  if ($File.Length -gt 5MB) { $Warnings.Add("Large file detected: $Rel") }
  $TextExts = @(".md",".txt",".json",".csv",".ps1",".cmd",".vbs",".xml",".yml",".yaml",".gradle",".kt",".java",".cs",".js",".ts",".html",".css")
  if ($TextExts -contains $File.Extension.ToLowerInvariant()) {
    $Content = Get-Content -LiteralPath $File.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -ne $Content) {
      if ($Content -match "\b(10\.\d{1,3}\.\d{1,3}\.\d{1,3}|192\.168\.\d{1,3}\.\d{1,3}|172\.(1[6-9]|2\d|3[0-1])\.\d{1,3}\.\d{1,3})\b") { $Warnings.Add("Private IPv4 address detected in $Rel") }
      if ($Content -match "\b100\.(6[4-9]|[7-9]\d|1[01]\d|12[0-7])\.\d{1,3}\.\d{1,3}\b") { $Warnings.Add("Tailscale CGNAT IP detected in $Rel") }
      if ($Content -match "(?i)\b[a-z0-9-]+\.ts\.net\b") { $Warnings.Add("Tailnet DNS detected in $Rel") }
      if ($Content -match "(?i)(password|passwd|pwd|secret|token)\s*[:=]") { $Warnings.Add("Possible secret assignment detected in $Rel") }
    }
  }
}
Write-Host ""
Write-Host "=== Secret/private-data preflight ===" -ForegroundColor Cyan
if ($Warnings.Count -eq 0) { Write-Host "No obvious secrets/private files found." -ForegroundColor Green; exit 0 }
Write-Host "Warnings found:" -ForegroundColor Yellow
$Warnings | Sort-Object -Unique | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }
if ($FailOnWarnings) { exit 1 }
