# Changelog

All notable changes to CopilotOnToast will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [1.0.1] - 2026-05-31

### Fixed

- Install script now installs the `/toast` skill (`SKILL.md`) into `.github/skills/toast/` in addition to the hook files

---

## [1.0.0] - 2026-05-31

### Added

- `copilot-on-toast.ps1` — PowerShell hook script that fires Windows toast notifications via [BurntToast](https://github.com/Windos/BurntToast)
- `copilot-on-toast.json` — Copilot CLI hooks configuration covering `sessionStart`, `sessionEnd`, `agentStop`, `preToolUse`, `errorOccurred`, `userPromptSubmitted`, and `postToolUseFailure`
- `install.ps1` — one-liner install script with `-InstallBurntToast`, `-Force`, and `-Path` parameters
- Graceful fallback to `Write-Host` when BurntToast is not installed
- `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`
- GitHub issue templates, PR template, and CI workflow
