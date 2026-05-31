# Contributing to CopilotOnToast

Thank you for your interest in contributing! This document covers how to report issues, suggest improvements, and submit code changes.

---

## Reporting bugs

Before opening a new issue, please [search existing issues](https://github.com/melodiouscoders/CopilotOnToast/issues) to avoid duplicates.

When reporting a bug, include:

- Your Windows version and PowerShell version (`$PSVersionTable`)
- Your Copilot CLI version (`copilot --version`)
- Whether BurntToast is installed and which version (`Get-Module BurntToast -ListAvailable`)
- Steps to reproduce the issue
- What you expected to happen vs what actually happened

For security vulnerabilities, see [SECURITY.md](SECURITY.md) — please do **not** use a public issue.

---

## Suggesting features

Open an issue with the `enhancement` label. Describe the feature, the problem it solves, and — if relevant — how you'd expect it to work.

---

## Submitting a pull request

1. **Fork** the repository and create a branch from `main`:

   ```bash
   git checkout -b my-feature
   ```

2. **Make your changes.** Keep commits focused and use clear commit messages.

3. **Test your changes** by running a Copilot CLI session and verifying that notifications fire correctly for the hooks you modified.

4. **Open a pull request** against `main`. Fill in the PR description with:
   - What changed and why
   - How you tested it
   - Any follow-up work or known limitations

---

## Development setup

### Prerequisites

- Windows with PowerShell 7+ (`pwsh`)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli)
- [BurntToast](https://github.com/Windos/BurntToast) PowerShell module

  ```powershell
  Install-Module BurntToast -Scope CurrentUser
  ```

### Testing hooks locally

You can test the notification script directly by piping a JSON payload into it:

```powershell
# Test agentStop notification
'{}' | $env:COPILOT_HOOK_EVENT = 'agentStop'; pwsh -NoProfile -File .github/hooks/copilot-on-toast.ps1
```

```powershell
# Test permissionRequest with a tool name
$env:COPILOT_HOOK_EVENT = 'permissionRequest'; '{"toolName":"bash"}' | pwsh -NoProfile -File .github/hooks/copilot-on-toast.ps1
```

Or start a real Copilot CLI session in this repository — the hooks in `.github/hooks/` will fire automatically.

---

## Code style

- PowerShell: follow the existing style in `copilot-on-toast.ps1` — single quotes for strings, `SilentlyContinue` for expected errors, graceful fallback to `Write-Host` when BurntToast is unavailable.
- JSON: 2-space indentation, consistent with the existing `copilot-on-toast.json`.
- Keep the PowerShell script self-contained — no external dependencies beyond BurntToast.
