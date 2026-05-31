# Windows entry point — mirrors setup.sh for PowerShell
# Usage: .\setup.ps1
# Run from the cloned env repo root.

$reposDir = "C:\Users\nish\repos"
$repos = @(
    @{ name = "homelab";       url = "https://github.com/nishchintraina/homelab.git";       branch = "develop" },
    @{ name = "claude-config"; url = "https://github.com/nishchintraina/claude-config.git"; branch = "develop" }
)

New-Item -ItemType Directory -Force $reposDir | Out-Null

foreach ($repo in $repos) {
    $path = Join-Path $reposDir $repo.name
    if (Test-Path "$path\.git") {
        Write-Host "Pulling $($repo.name)..." -ForegroundColor Cyan
        git -C $path pull
    } else {
        Write-Host "Cloning $($repo.name)..." -ForegroundColor Cyan
        git clone -b $repo.branch $repo.url $path
    }

    $setup = Join-Path $path "setup.ps1"
    if (Test-Path $setup) {
        Write-Host "Running setup for $($repo.name)..." -ForegroundColor Yellow
        & $setup
    }
}

Write-Host ""
Write-Host "Windows repos ready. To install systemd timers, run in WSL:" -ForegroundColor Green
Write-Host "  bash /mnt/c/Users/nish/repos/homelab/desktop/systemd/install.sh" -ForegroundColor Gray