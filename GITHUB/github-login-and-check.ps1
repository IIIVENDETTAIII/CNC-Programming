param(
    [string]$UserName,
    [string]$UserEmail,
    [switch]$SkipCredentialManagerLogin
)

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Test-CommandExists -Name 'git')) {
    Write-Host '[ERROR] Git is not found in PATH.' -ForegroundColor Red
    exit 2
}

if ([string]::IsNullOrWhiteSpace($UserName)) {
    $UserName = Read-Host 'Enter git user.name'
}

if ([string]::IsNullOrWhiteSpace($UserEmail)) {
    $UserEmail = Read-Host 'Enter git user.email'
}

if ([string]::IsNullOrWhiteSpace($UserName) -or [string]::IsNullOrWhiteSpace($UserEmail)) {
    Write-Host '[ERROR] user.name and user.email are required.' -ForegroundColor Red
    exit 1
}

Write-Host 'Step 1/3: Setting global git identity...' -ForegroundColor Cyan
git config --global user.name "$UserName"
git config --global user.email "$UserEmail"

Write-Host 'Step 2/3: Setting credential helper to manager-core...' -ForegroundColor Cyan
git config --global credential.helper manager-core

$gcmAttempted = $false
$gcmOk = $false

if (-not $SkipCredentialManagerLogin) {
    $oldEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'

    # Detect which command style exists on this PC.
    $hasGcmCore = $false
    $hasGcm = $false

    $null = git credential-manager-core --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $hasGcmCore = $true
    } else {
        $null = git credential-manager version 2>$null
        if ($LASTEXITCODE -eq 0) {
            $hasGcm = $true
        }
    }

    if ($hasGcmCore -or $hasGcm) {
        $gcmAttempted = $true
        Write-Host 'Step 3/3: Starting browser sign-in via Git Credential Manager...' -ForegroundColor Cyan

        if ($hasGcmCore) {
            $null = git credential-manager-core github login 2>&1
            if ($LASTEXITCODE -eq 0) {
                $gcmOk = $true
            }
        } elseif ($hasGcm) {
            $null = git credential-manager github login 2>&1
            if ($LASTEXITCODE -eq 0) {
                $gcmOk = $true
            }
        }
    } else {
        Write-Host '[WARN] Git Credential Manager is not available. Skipping browser login.' -ForegroundColor Yellow
    }

    $ErrorActionPreference = $oldEap
} else {
    Write-Host 'Step 3/3: Skipped credential manager login by parameter.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Verifying login-related state...' -ForegroundColor Cyan
$currentUserName = git config --global --get user.name 2>$null
$currentUserEmail = git config --global --get user.email 2>$null
$currentHelper = git config --global --get credential.helper 2>$null
$cmdkeyOutput = cmdkey /list 2>$null
$hasGithubCred = $false
if ($cmdkeyOutput) {
    $hasGithubCred = [bool]($cmdkeyOutput | Select-String -Pattern 'github.com|git:https://github.com' -SimpleMatch:$false)
}

$identityOk = (-not [string]::IsNullOrWhiteSpace($currentUserName)) -and
              (-not [string]::IsNullOrWhiteSpace($currentUserEmail)) -and
              (-not [string]::IsNullOrWhiteSpace($currentHelper))

if ($identityOk) {
    Write-Host '[OK] Git identity configured.' -ForegroundColor Green
    Write-Host "- user.name: $currentUserName" -ForegroundColor Gray
    Write-Host "- user.email: $currentUserEmail" -ForegroundColor Gray
    Write-Host "- credential.helper: $currentHelper" -ForegroundColor Gray
} else {
    Write-Host '[ERROR] Git identity configuration is incomplete.' -ForegroundColor Red
    exit 1
}

if ($gcmAttempted) {
    if ($gcmOk -or $hasGithubCred) {
        Write-Host '[OK] Credential login looks successful (credential entry found or command succeeded).' -ForegroundColor Green
        exit 0
    }

    Write-Host '[WARN] Identity is set, but GitHub credential entry was not confirmed.' -ForegroundColor Yellow
    Write-Host 'Try VS Code Accounts -> Sign In with GitHub, or run git push once to trigger auth.' -ForegroundColor Yellow
    exit 1
}

Write-Host '[OK] Identity setup complete. Run VS Code Accounts -> Sign In with GitHub to finish auth if needed.' -ForegroundColor Green
exit 0
