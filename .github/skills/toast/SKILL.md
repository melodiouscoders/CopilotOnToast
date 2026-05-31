---
name: toast
description: Manages CopilotOnToast desktop notification settings. Use this skill when the user asks to enable, disable, mute, silence, or configure desktop toast notifications, or mentions specific notification events like "permission toasts", "session notifications", "error toasts", etc.
---

CopilotOnToast sends Windows desktop toast notifications for Copilot CLI hook events. Notification settings are controlled by the config file at:

```
.github/hooks/copilot-on-toast.config.json
```

## Config format

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

Set any event to `false` to silence it. Any event omitted from the file defaults to **enabled**.

## Event reference

| Key                   | When it fires                                              |
|-----------------------|------------------------------------------------------------|
| `sessionStart`        | A Copilot CLI session begins                               |
| `sessionEnd`          | A Copilot CLI session ends                                 |
| `agentStop`           | The agent finishes a turn (most useful for "done" alerts)  |
| `permissionRequest`   | Copilot asks to use a tool — fires even in `/yolo` mode   |
| `errorOccurred`       | An error occurs during the session                         |
| `userPromptSubmitted` | The user submits a prompt                                  |
| `postToolUseFailure`  | A tool call fails                                          |

## Instructions

- To **show current settings**: read `.github/hooks/copilot-on-toast.config.json` and summarise which notifications are on and off.
- To **change a setting**: edit the file and update the relevant boolean. Confirm what changed.
- To **silence all notifications**: set every value to `false`.
- To **restore defaults**: set all values to `true`.
- If the config file does not exist, it can be created with all values set to `true`.
- Always confirm the change back to the user in plain language (e.g. "Permission request toasts are now disabled.").
