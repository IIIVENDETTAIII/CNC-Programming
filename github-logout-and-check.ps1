param(
    [string]$HostName = 'github.com'
)

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Remove-GitGlobalKey {
    param([string]$Key)
    git config --global --unset-all $Key 2>$null
}

if (-not (Test-CommandExists -Name 'gh')) {
    Write-Host '[ERROR] GitHub CLI (gh) not found. Install gh and retry.' -ForegroundColor Red
    exit 2
}

Write-Host "Logging out from GitHub CLI host: $HostName" -ForegroundColor Cyan
$null = gh auth logout -h $HostName --yes 2>&1
$logoutExitCode = $LASTEXITCODE

if ($logoutExitCode -eq 0) {
    Write-Host '[OK] Logout command completed.' -ForegroundColor Green
} else {
    Write-Host "[WARN] Logout returned code $logoutExitCode. Continue with verification." -ForegroundColor Yellow
}

Write-Host 'Cleaning global git config keys: user.name, user.email, credential.helper' -ForegroundColor Cyan
Remove-GitGlobalKey -Key 'user.name'
Remove-GitGlobalKey -Key 'user.email'
Remove-GitGlobalKey -Key 'credential.helper'

Write-Host ''
Write-Host 'Verifying logout status...' -ForegroundColor Cyan
$null = gh auth status -h $HostName 2>&1
$checkExitCode = $LASTEXITCODE

if ($checkExitCode -ne 0) {
    Write-Host '[OK] Logout verified: no active GitHub CLI session.' -ForegroundColor Green
    exit 0
}

Write-Host '[ERROR] Session still appears active.' -ForegroundColor Red
Write-Host 'Tip: also sign out in VS Code Accounts and clear Windows Credential Manager entries for github.com.' -ForegroundColor Yellow
exit 1
