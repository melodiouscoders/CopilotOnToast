# CopilotOnToast 🍞

> Desktop toast notifications for [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) — get notified when your agent finishes, needs approval, hits an error, and more.

Walk away from your terminal while Copilot works. CopilotOnToast pops a Windows toast notification for every key agent event so you never miss a beat.

---

## Events

| Hook event            | Notification title       | Notification body                       |
| --------------------- | ------------------------ | --------------------------------------- |
| `sessionStart`        | Copilot – Started        | Session started.                        |
| `sessionEnd`          | Copilot – Done           | Session ended: *{reason}*               |
| `agentStop`           | Copilot – Turn Complete  | Agent finished responding.              |
| `permissionRequest`   | Copilot – Action Needed  | Awaiting approval for: *{tool}*         |
| `errorOccurred`       | Copilot – Error          | *{error message}*                       |
| `userPromptSubmitted` | Copilot – Prompt Sent    | *{prompt preview}*                      |
| `postToolUseFailure`  | Copilot – Tool Failed    | Tool failed: *{tool}*                   |

---

## Requirements

| Requirement | Notes |
|---|---|
| Windows | Toast notifications use the Windows notification system |
| [PowerShell 7+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) | `pwsh` must be on your PATH — run `winget install Microsoft.PowerShell` |
| [BurntToast](https://github.com/Windos/BurntToast) PowerShell module | Used to fire toast notifications — install instructions below |
| [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli) | Hooks require Copilot CLI v1.0+ |

---

## Installation

### Quick install (one-liner)

Run this from the root of any repository where you want notifications:

```powershell
irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 | iex
```

This copies the hook files into `.github/hooks/` of your current directory. It will **not** overwrite files that already exist (use `-Force` to override — see below).

### With automatic BurntToast install

If you don't have BurntToast installed yet, download the script first so you can pass parameters:

```powershell
irm https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/install.ps1 -OutFile install.ps1
.\install.ps1 -InstallBurntToast
Remove-Item install.ps1
```

### Install parameters

| Parameter | Description |
|---|---|
| `-InstallBurntToast` | Automatically installs the BurntToast module (`-Scope CurrentUser`) if it's missing |
| `-Force` | Overwrite existing hook files |
| `-Path <dir>` | Target a specific repository root instead of the current git repo |

### Manual install

1. Copy `.github/hooks/copilot-on-toast.json`, `.github/hooks/copilot-on-toast.ps1`, and `.github/hooks/copilot-icon.png` from this repo into the `.github/hooks/` directory of your repository.
2. Install BurntToast: `Install-Module BurntToast -Scope CurrentUser`
3. Restart Copilot CLI — hooks are loaded at session start.

---

## Customisation

### Enabling and disabling notifications

Edit `.github/hooks/copilot-on-toast.config.json` to turn individual notifications on or off:

```json
{
  "notifications": {
    "sessionStart":        true,
    "sessionEnd":          true,
    "agentStop":           true,
    "permissionRequest":   true,
    "errorOccurred":       true,
    "userPromptSubmitted": true,
    "postToolUseFailure":  true
  }
}
```

Set any event to `false` to silence it. Any event not listed defaults to **enabled**.

> **Tip — yolo mode:** If you use `/yolo` and don't want permission toasts, set `"permissionRequest": false`.

### Changing notification text

To change the wording of a notification, edit `.github/hooks/copilot-on-toast.ps1`.

### Managing notifications via Copilot

This repo includes a Copilot CLI skill that lets you manage notification settings conversationally. In a Copilot CLI session, just ask naturally or use `/toast` directly:

```
/toast disable permission toasts
```
```
/toast silence everything except errors
```
```
/toast show me which notifications are enabled
```

Copilot will read and update `copilot-on-toast.config.json` for you.

> **Tip — `/yolo` mode:** Since yolo is a per-session toggle with no persistent state, the easiest workflow is to ask Copilot to disable permission toasts before starting a yolo session, and re-enable them afterward.

### Removing specific hook triggers

To stop a hook firing altogether (not just suppress the toast), remove its entry from `.github/hooks/copilot-on-toast.json`.

---

## Uninstall

Remove the three installed files from `.github/hooks/`:

```powershell
Remove-Item .github/hooks/copilot-on-toast.json, .github/hooks/copilot-on-toast.ps1, .github/hooks/copilot-icon.png
```

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

Please see [SECURITY.md](SECURITY.md) for how to report vulnerabilities responsibly.

## Support the project

If you find CopilotOnToast useful, consider supporting its development:

- ☕ [Buy me a coffee](https://buymeacoffee.com/melodiouscode)
- ❤️ [Sponsor on GitHub](https://github.com/sponsors/melodiouscoders)

## License

[MIT](LICENSE)
