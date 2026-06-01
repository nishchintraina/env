<#
.SYNOPSIS
    Master bootstrap. Idempotent - safe to re-run.
    Prompts for missing secrets, clones/pulls all repos, then calls each repo's setup.ps1.

.NOTES
    Bootstrap (one-time):
        git clone https://nishchintraina:<PAT>@github.com/nishchintraina/env C:\Users\nish\.env
        C:\Users\nish\.env\setup.ps1
#>

$ErrorActionPreference = "Stop"
$user        = "nishchintraina"
$secretsFile = "C:\Users\nish\secrets.json"

# ---------------------------------------------------------------------------
# SECRETS — prompt for any missing, save to secrets.json
# ---------------------------------------------------------------------------
$requiredSecrets = @(
    @{
        Key          = "GITHUB_PERSONAL_ACCESS_TOKEN"
        Description  = "GitHub Personal Access Token (repo cloning + GitHub MCP)"
        Instructions = @"
  How to create a GitHub PAT:
    1. Go to: https://github.com/settings/tokens
    2. Click "Generate new token (classic)"
    3. Name it (e.g. homelab), set expiration: No expiration
    4. Scopes: repo (full), read:org, user
    5. Click Generate and copy immediately
"@
    }
)

$secrets = if (Test-Path $secretsFile) {
    Get-Content $secretsFile -Raw | ConvertFrom-Json
} else {
    [PSCustomObject]@{}
}

$changed = $false
foreach ($s in $requiredSecrets) {
    if ($secrets.PSObject.Properties[$s.Key]?.Value) {
        Write-Host "OK: $($s.Key) already set." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Missing: $($s.Description)" -ForegroundColor Yellow
        Write-Host $s.Instructions
        $value = Read-Host "Paste value"
        $secrets | Add-Member -NotePropertyName $s.Key -NotePropertyValue $value.Trim() -Force
        $changed = $true
    }
}

if ($changed) {
    $secrets | ConvertTo-Json | Out-File $secretsFile -Encoding utf8
    Write-Host ""
    Write-Host "Secrets saved to $secretsFile" -ForegroundColor Green
}

$pat     = $secrets.GITHUB_PERSONAL_ACCESS_TOKEN
$baseUrl = "https://${user}:${pat}@github.com/${user}"

# ---------------------------------------------------------------------------
# REPOS — clone if missing, pull if present, always refresh remote URL
# Each entry can optionally have a SetupScript to call after sync
# ---------------------------------------------------------------------------
$repos = @(
    @{
        Name        = "homelab"
        Path        = "C:\Users\nish\repos\homelab"
        Branch      = "develop"
        SetupScript = "setup.ps1"
    },
    @{
        Name        = "claude-config"
        Path        = "C:\Users\nish\.claude"
        Branch      = "develop"
        SetupScript = $null
    }
)

foreach ($r in $repos) {
    $remoteUrl = "$baseUrl/$($r.Name).git"
    Write-Host ""
    if (Test-Path (Join-Path $r.Path ".git")) {
        Write-Host "Updating $($r.Name)..." -ForegroundColor Cyan
        git -C $r.Path remote set-url origin $remoteUrl
        git -C $r.Path pull --ff-only
    } else {
        Write-Host "Cloning $($r.Name) -> $($r.Path)..." -ForegroundColor Cyan
        git clone --branch $r.Branch $remoteUrl $r.Path
    }

    if ($r.SetupScript) {
        $script = Join-Path $r.Path $r.SetupScript
        if (Test-Path $script) {
            Write-Host "Running $($r.Name)\$($r.SetupScript)..." -ForegroundColor Cyan
            & $script
        }
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
