---
title: Configuration
description: Customise which notifications fire and manage settings conversationally with the /toast skill.
---

CopilotOnToast is controlled by a config file in your repository. You can edit it directly or use the `/toast` skill to manage settings conversationally inside a Copilot CLI session.

## Config file

The config file lives at `.github/hooks/copilot-on-toast.config.json` in your repository:

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

Set any event to `false` to silence it. Any event not listed in the file defaults to **enabled**.

## Using the `/toast` skill

The install script also sets up a Copilot CLI skill that lets you manage notification settings conversationally — no manual JSON editing required.

In any Copilot CLI session, use natural language or the `/toast` slash command:

```
/toast disable permission toasts
```
```
/toast silence everything except errors
```
```
/toast show me which notifications are enabled
```
```
/toast enable all
```

Copilot will read and update `copilot-on-toast.config.json` for you and confirm what changed.

## Yolo mode tip

`permissionRequest` notifications fire **before** the permission service runs, which means they fire even in `/yolo` mode. If you use yolo and don't want these prompts:

```
/toast disable permission toasts
```

Re-enable them after your yolo session:

```
/toast enable all
```

## Customising notification text

To change the wording of a notification, edit `.github/hooks/copilot-on-toast.ps1`. Each event's title and body are set near the top of the `switch` block.

## Removing a hook entirely

To stop a hook event from firing at all (not just suppress the toast), remove its entry from `.github/hooks/copilot-on-toast.json`.
