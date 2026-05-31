# Windows entry point — run once after cloning env to C:\Users\nish\.env
# Usage: C:\Users\nish\.env\setup.ps1

$reposDir = "C:\Users\nish\repos"
$claudeDir = "C:\Users\nish\.claude"
$token = (Get-Content "$claudeDir\..\secrets.json" -ErrorAction SilentlyContinue | ConvertFrom-Json).GITHUB_PERSONAL_ACCESS_TOKEN

function Clone-Or-Pull($url, $path, $branch = "develop") {
    if (Test-Path "$path\.git") {
        Write-Host "Pulling $(Split-Path $path -Leaf)..." -ForegroundColor Cyan
        git -C $path pull
    } else {
        Write-Host "Cloning $(Split-Path $path -Leaf)..." -ForegroundColor Cyan
        $authUrl = $url -replace "https://", "https://nishchintraina:$token@"
        git clone -b $branch $authUrl $path
    }
}

# homelab -> C:\Users\nish\repos\homelab
Clone-Or-Pull "https://github.com/nishchintraina/homelab.git" "$reposDir\homelab"

# claude-config -> C:\Users\nish\.claude (IS the repo)
Clone-Or-Pull "https://github.com/nishchintraina/claude-config.git" $claudeDir

# Register scheduled tasks (needs admin - prompt separately)
Write-Host ""
Write-Host "To register scheduled tasks, run as admin:" -ForegroundColor Yellow
Write-Host "  $reposDir\homelab\desktop\setup-scheduled-tasks.ps1"

Write-Host ""
Write-Host "Done. Restart Claude Code." -ForegroundColor Green