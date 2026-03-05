param(
    [string]$HostName = 'github.com',
    [ValidateSet('https', 'ssh')]
    [string]$GitProtocol = 'https'
)

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Test-CommandExists -Name 'gh')) {
    Write-Host '[ERROR] GitHub CLI (gh) not found. Install gh and retry.' -ForegroundColor Red
    exit 2
}

Write-Host "Starting GitHub CLI login for host: $HostName" -ForegroundColor Cyan
Write-Host 'Browser auth flow will open. Complete login in browser.' -ForegroundColor DarkCyan

$null = gh auth login -h $HostName --git-protocol $GitProtocol --web 2>&1
$loginExitCode = $LASTEXITCODE

if ($loginExitCode -ne 0) {
    Write-Host "[ERROR] Login did not complete. Exit code: $loginExitCode" -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host 'Verifying login status...' -ForegroundColor Cyan
$verifyOutput = gh auth status -h $HostName 2>&1
$checkExitCode = $LASTEXITCODE

if ($checkExitCode -eq 0) {
    Write-Host '[OK] Login verified: active GitHub CLI session found.' -ForegroundColor Green
    exit 0
}

Write-Host '[ERROR] Login could not be verified after auth flow.' -ForegroundColor Red
Write-Host 'gh auth status output:' -ForegroundColor Yellow
$verifyOutput | ForEach-Object { Write-Host $_ }
exit 1
