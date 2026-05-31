---
title: Getting Started
description: Install CopilotOnToast and get Windows desktop notifications for GitHub Copilot CLI in minutes.
---

CopilotOnToast hooks into [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) to pop Windows toast notifications for every key agent event. This page will get you up and running in minutes.

## Requirements

| Requirement | Notes |
|---|---|
| **Windows** | Toast notifications use the Windows notification system |
| **[PowerShell 7+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)** | `pwsh` must be on your PATH — run `winget install Microsoft.PowerShell` |
| **[BurntToast](https://github.com/Windos/BurntToast)** | PowerShell module used to fire toast notifications |
| **[GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli)** | Hooks require Copilot CLI v1.0+ |

## Quick install

Run this from the root of any repository where you want notifications:

```powershell
irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 | iex
```

This copies the hook files into `.github/hooks/` of your current directory. It will **not** overwrite files that already exist (use `-Force` to override).

## With automatic BurntToast install

If you don't have BurntToast installed yet, download the script first so you can pass parameters:

```powershell
irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 -OutFile install.ps1
.\install.ps1 -InstallBurntToast
Remove-Item install.ps1
```

## Install parameters

| Parameter | Description |
|---|---|
| `-InstallBurntToast` | Automatically installs BurntToast (`-Scope CurrentUser`) if it's missing |
| `-Force` | Overwrite existing hook files |
| `-Path <dir>` | Target a specific repository root instead of the current git repo |

## Manual install

1. Copy `.github/hooks/copilot-on-toast.json`, `.github/hooks/copilot-on-toast.ps1`, `.github/hooks/copilot-on-toast.config.json`, and `.github/hooks/copilot-icon.png` from this repo into the `.github/hooks/` directory of your repository.
2. Install BurntToast: `Install-Module BurntToast -Scope CurrentUser`
3. Restart Copilot CLI — hooks are loaded at session start.

## Verify it's working

Start a Copilot CLI session. You should see a **"Copilot – Started"** toast notification appear. If not, check:

- BurntToast is installed: `Get-Module BurntToast -ListAvailable`
- PowerShell 7 is on your PATH: `pwsh --version`
- Hook files are present in `.github/hooks/`

## Uninstall

Remove the installed files from `.github/hooks/`:

```powershell
Remove-Item .github/hooks/copilot-on-toast.json,
            .github/hooks/copilot-on-toast.ps1,
            .github/hooks/copilot-on-toast.config.json,
            .github/hooks/copilot-icon.png
```

Remove the skill file if installed:

```powershell
Remove-Item .github/skills/toast/SKILL.md
```
