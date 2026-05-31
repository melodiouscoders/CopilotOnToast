# install.ps1
# Installs CopilotOnToast hooks into a repository's .github/hooks directory.
#
# Usage (simple):
#   irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 | iex
#
# Usage (with options — download first, then run):
#   irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 -OutFile install.ps1
#   .\install.ps1 [-InstallBurntToast] [-Force] [-Path <repo-root>]
#   Remove-Item install.ps1

[CmdletBinding()]
param(
    # Automatically install the BurntToast module (requires PowerShell Gallery access).
    [switch]$InstallBurntToast,

    # Overwrite existing hook files without prompting.
    [switch]$Force,

    # Path to the repository root. Defaults to the current git repository root.
    [string]$Path
)

$ErrorActionPreference = 'Stop'
$version  = 'v1.0.1'
$baseUrl  = "https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/$version"
$hookFiles  = @('copilot-on-toast.json', 'copilot-on-toast.ps1', 'copilot-on-toast.config.json', 'copilot-icon.png')
$skillFiles = @('SKILL.md')

Write-Host ""
Write-Host "  CopilotOnToast Installer" -ForegroundColor Cyan
Write-Host "  ========================" -ForegroundColor Cyan
Write-Host ""

# Resolve target repository root
if ($Path) {
    $repoRoot = Resolve-Path $Path
} else {
    try {
        $repoRoot = git rev-parse --show-toplevel 2>$null
        if (-not $repoRoot) { throw }
    } catch {
        Write-Host "  ERROR: Not inside a git repository." -ForegroundColor Red
        Write-Host "  Run this script from your repo root, or use -Path <repo-root>." -ForegroundColor Red
        exit 1
    }
}

$targetDir = Join-Path $repoRoot '.github\hooks'
Write-Host "  Target directory : $targetDir"

# Create .github/hooks if it doesn't exist
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "  Created           : $targetDir" -ForegroundColor DarkGray
}

# Download hook files
foreach ($file in $hookFiles) {
    $dest = Join-Path $targetDir $file

    if ((Test-Path $dest) -and -not $Force) {
        Write-Host "  SKIP (exists)     : $file  (use -Force to overwrite)" -ForegroundColor Yellow
        continue
    }

    $url = "$baseUrl/.github/hooks/$file"
    Write-Host "  Downloading       : $file"
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    Write-Host "  Installed         : $dest" -ForegroundColor Green
}

# Download skill files
$skillDir = Join-Path $repoRoot '.github\skills\toast'
if (-not (Test-Path $skillDir)) {
    New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
    Write-Host "  Created           : $skillDir" -ForegroundColor DarkGray
}

foreach ($file in $skillFiles) {
    $dest = Join-Path $skillDir $file

    if ((Test-Path $dest) -and -not $Force) {
        Write-Host "  SKIP (exists)     : skills/toast/$file  (use -Force to overwrite)" -ForegroundColor Yellow
        continue
    }

    $url = "$baseUrl/.github/skills/toast/$file"
    Write-Host "  Downloading       : skills/toast/$file"
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    Write-Host "  Installed         : $dest" -ForegroundColor Green
}

Write-Host ""

# Check for BurntToast
$burntToastAvailable = [bool](Get-Module -ListAvailable BurntToast -ErrorAction SilentlyContinue | Select-Object -First 1)

if ($burntToastAvailable) {
    Write-Host "  BurntToast        : found" -ForegroundColor Green
} elseif ($InstallBurntToast) {
    Write-Host "  Installing BurntToast..." -ForegroundColor Cyan
    Install-Module BurntToast -Scope CurrentUser -Force
    Write-Host "  BurntToast        : installed" -ForegroundColor Green
} else {
    Write-Host "  BurntToast not found. Toast notifications require it." -ForegroundColor Yellow
    Write-Host "  Install it with:" -ForegroundColor Yellow
    Write-Host "    Install-Module BurntToast -Scope CurrentUser" -ForegroundColor White
    Write-Host ""
    Write-Host "  Re-run with -InstallBurntToast to install it automatically."
}

Write-Host ""
Write-Host "  Done! CopilotOnToast hooks and skill are installed." -ForegroundColor Green
Write-Host "  See .github/hooks/copilot-on-toast.config.json to configure notifications."
Write-Host "  Use /toast in a Copilot CLI session to manage notifications conversationally."
Write-Host ""
