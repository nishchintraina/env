# Clones or pulls claude-config and symlinks to ~/.claude
$path = "C:\Users\nish\repos\claude-config"
if (Test-Path "$path\.git") {
    git -C $path pull
} else {
    git clone -b develop https://github.com/nishchintraina/claude-config.git $path
}
& "$path\setup.ps1"