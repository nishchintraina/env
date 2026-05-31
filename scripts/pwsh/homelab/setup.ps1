# Clones or pulls the homelab repo
$path = "C:\Users\nish\repos\homelab"
if (Test-Path "$path\.git") {
    git -C $path pull
} else {
    git clone -b develop https://github.com/nishchintraina/homelab.git $path
}
Write-Host "homelab ready at $path"