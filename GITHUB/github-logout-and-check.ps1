param()

$ErrorActionPreference = 'Stop'

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Remove-GitGlobalKey {
    param([string]$Key)
    git config --global --unset-all $Key 2>$null
}

if (-not (Test-CommandExists -Name 'git')) {
    Write-Host '[ERROR] Git is not found in PATH.' -ForegroundColor Red
    exit 2
}

Write-Host 'Step 1/3: Clearing global git config (user.name, user.email, credential.helper)...' -ForegroundColor Cyan
Remove-GitGlobalKey -Key 'user.name'
Remove-GitGlobalKey -Key 'user.email'
Remove-GitGlobalKey -Key 'credential.helper'

Write-Host 'Step 2/3: Clearing GitHub entries from Windows Credential Manager...' -ForegroundColor Cyan
$targets = @('git:https://github.com', 'github.com')
foreach ($target in $targets) {
    cmdkey /delete:$target 1>$null 2>$null
}

# Try to discover and delete additional GitHub-related entries.
$cmdkeyOutput = cmdkey /list 2>$null
if ($cmdkeyOutput) {
    $foundTargets = @()
    foreach ($line in $cmdkeyOutput) {
        if ($line -match 'Target:\s*(.+)') {
            $t = $Matches[1].Trim()
            if ($t -match 'github.com|git:https://github.com') {
                $foundTargets += $t
            }
        }
    }
    $foundTargets = $foundTargets | Select-Object -Unique
    foreach ($t in $foundTargets) {
        cmdkey /delete:$t 1>$null 2>$null
    }
}

Write-Host 'Step 3/3: Verifying logout state...' -ForegroundColor Cyan
$userName = git config --global --get user.name 2>$null
$userEmail = git config --global --get user.email 2>$null
$credHelper = git config --global --get credential.helper 2>$null
$cmdkeyAfter = cmdkey /list 2>$null
$hasGithubCred = $false
if ($cmdkeyAfter) {
    $hasGithubCred = [bool]($cmdkeyAfter | Select-String -Pattern 'github.com|git:https://github.com' -SimpleMatch:$false)
}

$ok = [string]::IsNullOrWhiteSpace($userName) -and
      [string]::IsNullOrWhiteSpace($userEmail) -and
      [string]::IsNullOrWhiteSpace($credHelper) -and
      (-not $hasGithubCred)

if ($ok) {
    Write-Host '[OK] Logout verified for local machine state.' -ForegroundColor Green
    Write-Host 'Reminder: In VS Code also click Accounts -> Sign Out.' -ForegroundColor Yellow
    exit 0
}

Write-Host '[WARN] Some data still exists.' -ForegroundColor Yellow
Write-Host "- user.name: $userName"
Write-Host "- user.email: $userEmail"
Write-Host "- credential.helper: $credHelper"
Write-Host "- github creds in cmdkey: $hasGithubCred"
Write-Host 'Also do manual sign-out in VS Code Accounts and clear credentials in Windows Credential Manager.' -ForegroundColor Yellow
exit 1
