param(
    [string]$HostName = 'github.com'
)

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Test-CommandExists -Name 'gh')) {
    Write-Host '[ERROR] GitHub CLI (gh) ne naiden. Ustanovite gh i povtorite.' -ForegroundColor Red
    exit 2
}

Write-Host "Proverka avtorizatsii GitHub CLI dlya $HostName ..." -ForegroundColor Cyan
$null = gh auth status -h $HostName 2>&1
$ghExitCode = $LASTEXITCODE

if ($ghExitCode -eq 0) {
    Write-Host '[OK] Vy avtorizovany v GitHub CLI.' -ForegroundColor Green
} else {
    Write-Host '[WARN] Vy NE avtorizovany v GitHub CLI.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Proverka global git-config:' -ForegroundColor Cyan

$userName = git config --global --get user.name 2>$null
$userEmail = git config --global --get user.email 2>$null
$credHelper = git config --global --get credential.helper 2>$null

if ([string]::IsNullOrWhiteSpace($userName)) {
    Write-Host '- user.name: (ne zadan)' -ForegroundColor DarkYellow
} else {
    Write-Host "- user.name: $userName" -ForegroundColor Gray
}

if ([string]::IsNullOrWhiteSpace($userEmail)) {
    Write-Host '- user.email: (ne zadan)' -ForegroundColor DarkYellow
} else {
    Write-Host "- user.email: $userEmail" -ForegroundColor Gray
}

if ([string]::IsNullOrWhiteSpace($credHelper)) {
    Write-Host '- credential.helper: (ne zadan)' -ForegroundColor DarkYellow
} else {
    Write-Host "- credential.helper: $credHelper" -ForegroundColor Gray
}

Write-Host ''
if ($ghExitCode -eq 0) {
    exit 0
}

exit 1
