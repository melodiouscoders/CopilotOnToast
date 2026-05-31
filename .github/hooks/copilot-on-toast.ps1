# copilot-on-toast.ps1
# Fires a toast notification when Copilot CLI hooks are triggered.
# Copilot CLI passes hook data as JSON via stdin.
# The hook event name is passed via COPILOT_HOOK_EVENT env var.

$ErrorActionPreference = 'SilentlyContinue'

# Parse the JSON payload
$stdin = $input | Out-String
$payload = $stdin | ConvertFrom-Json

$hide = 0

# Load config and check if this event's notification is enabled (default: enabled if not listed)
$configPath = Join-Path $PSScriptRoot 'copilot-on-toast.config.json'
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    $eventEnabled = $config.notifications.PSObject.Properties[$env:COPILOT_HOOK_EVENT]
    if ($null -ne $eventEnabled -and $eventEnabled.Value -eq $false) {
        exit 0
    }
}

# Notification title and message from message
switch ($env:COPILOT_HOOK_EVENT) {
    "sessionStart" {
        $title = "Copilot - Started"
        $message = "Session started."
    }
    "sessionEnd" {
        $reason = if ($payload.reason) { $payload.reason } else { "complete" }
        $title = "Copilot - Done"
        $message = "Session ended: $reason"
    }
    "agentStop" {
        $title = "Copilot - Turn Complete"
        $message = "Agent finished responding."
    }
    "permissionRequest" {
        $toolName = if ($payload.toolName) { $payload.toolName } else { "unknown" }
        $title = "Copilot - Action Needed"
        $message = "Awaiting approval for: $toolName"
    }
    "errorOccurred" {
        $errorDetail = if ($payload.error.message) { $payload.error.message } elseif ($payload.error) { $payload.error } else { "An error occurred" }
        $title = "Copilot - Error"
        $message = if ($errorDetail.Length -gt 80) { $errorDetail.Substring(0, 77) + "..." } else { $errorDetail }
    }
    "userPromptSubmitted" {
        $prompt = if ($payload.prompt) { $payload.prompt } else { "" }
        $title = "Copilot - Prompt Sent"
        $message = if ($prompt.Length -gt 60) { $prompt.Substring(0, 57) + "..." } else { $prompt }
    }
    "postToolUseFailure" {
        $toolName = if ($payload.toolName) { $payload.toolName } else { "unknown" }
        $title = "Copilot - Tool Failed"
        $message = "Tool failed: $toolName"
    }
    "preToolUse" {
        $toolName = if ($payload.toolName) { $payload.toolName } else { "unknown" }
        $title = "Copilot - Using Tool"
        $message = "Using tool: $toolName"

        $hide = 1
    }
    default {
        exit 0 # Unhandled event types are ignored and do not trigger a notification.
    }
}

if ($hide -eq 1) {
    exit 0
}

$icon = Join-Path $PSScriptRoot 'copilot-icon.png'

# Send Windows Toast notification via BurntToast when available; otherwise fall back to console output.
$burntToastAvailable = [bool](Get-Module -ListAvailable BurntToast -ErrorAction SilentlyContinue | Select-Object -First 1)

if (-not $burntToastAvailable) {
    Write-Host "[$title] $message"
    exit 0
}

try {
    Import-Module BurntToast -ErrorAction Stop

    if (Test-Path $icon) {
        New-BurntToastNotification -Text $title, $message -AppLogo $icon
    }
    else {
        New-BurntToastNotification -Text $title, $message
    }
}
catch {
    Write-Host "[$title] $message"
}
