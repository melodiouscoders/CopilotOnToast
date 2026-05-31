---
title: Events Reference
description: All hook events supported by CopilotOnToast, what triggers them, and their default notification content.
---

CopilotOnToast registers seven Copilot CLI hook events. This page describes each one — when it fires, the default notification it shows, and any relevant notes.

## Events

| Event key | Notification title | Notification body | When it fires |
|---|---|---|---|
| `sessionStart` | Copilot – Started | Session started. | A Copilot CLI session begins |
| `sessionEnd` | Copilot – Done | Session ended: *{reason}* | A Copilot CLI session ends |
| `agentStop` | Copilot – Turn Complete | Agent finished responding. | The agent finishes a turn |
| `permissionRequest` | Copilot – Action Needed | Awaiting approval for: *{tool}* | Copilot asks to use a tool |
| `errorOccurred` | Copilot – Error | *{error message}* | An error occurs during the session |
| `userPromptSubmitted` | Copilot – Prompt Sent | *{prompt preview}* | The user submits a prompt |
| `postToolUseFailure` | Copilot – Tool Failed | Tool failed: *{tool}* | A tool call fails after execution |

## Notes

### `agentStop`
This is the most useful event for "done" alerts — it fires whenever the agent finishes a turn and is waiting for your input. If you only want one notification enabled, this is the one.

### `permissionRequest`
Fires when Copilot needs your approval before using a tool. This fires **before** the permission service runs, so it fires even in `/yolo` mode. See [Yolo mode tip](/guides/configuration/#yolo-mode-tip) to disable it for yolo sessions.

### `sessionEnd`
The notification body includes the session end reason (e.g., `user_ended`, `timeout`).

### `userPromptSubmitted`
The notification body shows a preview of the prompt text. Useful as a confirmation that your prompt was received, though most users prefer to disable this one to reduce noise.

### `postToolUseFailure`
Fires after a tool call completes with a failure status. The notification body includes the name of the tool that failed.
