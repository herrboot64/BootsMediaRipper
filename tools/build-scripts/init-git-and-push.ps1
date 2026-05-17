[CmdletBinding()]
param(
  [string]$GitHubUser = "herrboot64",
  [string]$RepoName = "BootsMediaRipper",
  [ValidateSet("public","private")]
  [string]$Visibility = "public",
  [switch]$SkipGitHubCreate
)
$ErrorActionPreference = "Stop"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git not found." }
if (-not $SkipGitHubCreate -and -not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "GitHub CLI not found." }
& "$PSScriptRoot\preflight-secret-check.ps1" -FailOnWarnings
git config --global user.name "herrboot64"
git config --global user.email "herrboot64@gmail.com"
if (-not (Test-Path ".git")) { git init }
git branch -M main
git add .
git status --short
git commit -m "Initial public portfolio scaffold"
if ($SkipGitHubCreate) { Write-Host "Skipping GitHub creation. Add remote manually and push." -ForegroundColor Yellow; exit 0 }
gh auth status
$RepoArg = "$GitHubUser/$RepoName"
$Remote = git remote get-url origin 2>$null
if (-not $Remote) { gh repo create $RepoArg --source . --remote origin --$Visibility --description "Local-first Windows and Android media clipping utility portfolio project." }
git push -u origin main
