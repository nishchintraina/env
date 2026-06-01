# env

Master bootstrap for this machine. Clones all repos and runs their setup scripts.

## Bootstrap (one-time)

```powershell
# Clone env (paste your PAT in the URL)
git clone https://nishchintraina:<PAT>@github.com/nishchintraina/env C:\Users\nish\.env

# Run setup
C:\Users\nish\.env\setup.ps1
```

`setup.ps1` is idempotent — safe to re-run. It will:
- Prompt for any missing secrets (with instructions) and save to `C:\Users\nish\secrets.json`
- Clone each repo if missing, or pull if already present
- Update remote URLs with the current PAT (handles token rotation)
- Call each repo's own `setup.ps1` after syncing

## Repos managed

| Repo | Local path | Post-sync setup |
|------|-----------|----------------|
| homelab | `C:\Users\nish\repos\homelab` | `setup.ps1` → registers scheduled tasks (UAC) |
| claude-config | `C:\Users\nish\.claude` | — |

## Token rotation

Update `C:\Users\nish\secrets.json` with the new PAT, then re-run `setup.ps1`.
All remote URLs are refreshed automatically.
