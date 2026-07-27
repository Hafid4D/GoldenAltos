# One-time install of GoldenAltos pre-commit hook (Windows)
Set-Location $PSScriptRoot\..

python scripts/install_git_hooks.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Done. catalog.4DCatalog changes are validated before each commit."
