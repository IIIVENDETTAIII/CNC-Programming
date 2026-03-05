param()

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Get-GitGlobalValue {
    param([string]$Key)
    return (git config --global --get $Key 2>$null)
}

if (-not (Test-CommandExists -Name 'git')) {
    Write-Host '[ERROR] Git is not found in PATH.' -ForegroundColor Red
    exit 2
}

Write-Host 'Checking local auth-related state (without gh)...' -ForegroundColor Cyan

$userName = Get-GitGlobalValue -Key 'user.name'
$userEmail = Get-GitGlobalValue -Key 'user.email'
$credHelper = Get-GitGlobalValue -Key 'credential.helper'

$cmdkeyOutput = cmdkey /list 2>$null
$hasGithubCred = $false
if ($cmdkeyOutput) {
    $hasGithubCred = [bool]($cmdkeyOutput | Select-String -Pattern 'github.com|git:https://github.com' -SimpleMatch:$false)
}

Write-Host ''
Write-Host 'Global git config:' -ForegroundColor Cyan
if ([string]::IsNullOrWhiteSpace($userName)) {
    Write-Host '- user.name: (not set)' -ForegroundColor DarkYellow
} else {
    Write-Host "- user.name: $userName" -ForegroundColor Gray
}

if ([string]::IsNullOrWhiteSpace($userEmail)) {
    Write-Host '- user.email: (not set)' -ForegroundColor DarkYellow
} else {
    Write-Host "- user.email: $userEmail" -ForegroundColor Gray
}

if ([string]::IsNullOrWhiteSpace($credHelper)) {
    Write-Host '- credential.helper: (not set)' -ForegroundColor DarkYellow
} else {
    Write-Host "- credential.helper: $credHelper" -ForegroundColor Gray
}

Write-Host ''
if ($hasGithubCred) {
    Write-Host '[INFO] Windows Credential Manager has GitHub-related entries.' -ForegroundColor Yellow
} else {
    Write-Host '[INFO] No GitHub-related entries found in Windows Credential Manager.' -ForegroundColor Green
}

$looksLoggedOut = [string]::IsNullOrWhiteSpace($userName) -and
                 [string]::IsNullOrWhiteSpace($userEmail) -and
                 [string]::IsNullOrWhiteSpace($credHelper) -and
                 (-not $hasGithubCred)

Write-Host ''
if ($looksLoggedOut) {
    Write-Host '[OK] Status: looks LOGGED OUT on this PC.' -ForegroundColor Green
    exit 0
}

Write-Host '[WARN] Status: login or saved credentials likely exist on this PC.' -ForegroundColor Yellow
exit 1
