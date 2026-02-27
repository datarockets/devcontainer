---
name: omo
description: |-
  Manage oh-my-opencode configuration files and upgrades. Locate config files, check current versions, and safely upgrade while preserving custom provider/agent configurations. Use proactively when user asks about oh-my-opencode setup, configuration locations, version upgrades, or model/provider changes.

  Examples:
  - user: "Where is my oh-my-opencode config?" → explain file locations and show current config
  - user: "Upgrade oh-my-opencode" → check current version, show upgrade diff, ask for confirmation
  - user: "Update my omo config" → locate config, review changes needed, ask before modifying
  - user: "What version of oh-my-opencode do I have?" → check version in config and node_modules
  - user: "How do I change the model for oracle agent?" → guide to agents configuration section
---

# Oh-My-OpenCode (omo) Configuration Management

Manage oh-my-opencode plugin configuration and upgrades safely.

## Configuration File Locations

oh-my-opencode uses JSONC (JSON with Comments) configuration files.

### Priority Order (project overrides user):

1. **Project-level** (highest priority):
   - `.opencode/oh-my-opencode.jsonc`
   - `.opencode/oh-my-opencode.json`

2. **User-level**:
   - macOS/Linux: `~/.config/opencode/oh-my-opencode.jsonc`
   - Windows: `%APPDATA%\opencode\oh-my-opencode.jsonc`

### Also check for plugin installation:

The plugin itself is installed as an npm package:
- **Version tracked in: `~/.config/opencode/opencode.json(c)` plugins section**
- Plugins are automatically installed when first loaded — no manual `npm install` needed
- If you see version mismatches between what's installed vs what's loaded, clear the cache (see below)


## Core Configuration Sections

Reference: https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md

### Key Sections:

| Section | Purpose |
|---------|---------|
| `agents` | Override built-in agents (sisyphus, oracle, librarian, explore, etc.) |
| `categories` | Model delegation for task() tool (visual-engineering, ultrabrain, deep, quick, etc.) |
| `background_task` | Concurrency limits for parallel execution |
| `skills` | Enable/disable skills and configure skill sources |
| `experimental` | Feature flags (aggressive_truncation, task_system, etc.) |

### Critical: Preserving Custom Provider Configurations

When reviewing upgrades or configuration changes, **NEVER** modify:

- Custom `model` assignments per agent/category
- `fallback_models` chains
- `providerOptions` or provider-specific settings
- `variant` specifications (max, high, medium, low, xhigh)
- `temperature`, `top_p`, or other generation parameters

**For built-in agents and categories, refer to official documentation for model recommendations:**

- Built-in categories default models: https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md#built-in-categories
- Built-in agent provider chains: https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md#agent-provider-chains

**DO NOT** suggest model changes for built-in agents/categories based on your own judgment. Use the official omo documentation recommendations.

**For custom agents and categories** (user-defined, not in official docs): You may suggest appropriate models based on the task description.

**If you identify incorrect or suboptimal model/provider usage:**
1. Explain the issue to the user
2. Reference the official documentation for the recommended model
3. **Ask for explicit confirmation** before modifying

## Upgrade Process

### Automatic Updates (Default)

oh-my-opencode includes an `auto-update-checker` hook that:
1. Runs when OpenCode starts a new session
2. Checks for new versions in the background
3. Shows toast notification if update available
4. Applies update on next restart

### Explicit Version Pins

**If the user has an explicit version pinned** (e.g., `"oh-my-opencode": "3.8.2"` in `opencode.json` or `opencode.jsonc` plugins section):

- **Keep it explicit** — do not change to `@latest`
- Check the current pinned version and determine the appropriate target version
- Look at the GitHub releases to see what versions are available
- Ask the user which specific version they want to upgrade to
- **Update the explicit version in `opencode.json(c)` plugins section** (not `package.json`)

**Example workflow:**
```
Current in opencode.json: "oh-my-opencode": "3.8.2"
Available: 3.8.5 (latest)

Ask: "You're currently pinned to 3.8.2. Should I upgrade to 3.8.5 (latest),
      or would you prefer a different version?"
```

After user confirmation, update in `opencode.json(c)`:
```jsonc
{
  "plugin": ["oh-my-opencode@3.8.5"],
}
```

Users pin versions for stability — respect that choice and help them pick the right version rather than blindly moving to latest.

## IMPORTANT: Never Auto-Update Configuration Files

**You MUST NOT modify any configuration files automatically.**

When user asks to upgrade or change configuration:

1. **Locate and read** the current configuration
2. **Identify** what would change (version bump, new fields, etc.)
3. **Explain the diff** clearly to the user
4. **Ask for explicit confirmation** before making changes
5. If user has custom providers/models, **warn about preserving them**

### Example workflow for upgrade request:

```
User: "Upgrade oh-my-opencode"

You:
1. Read ~/.config/opencode/opencode.json(c) to find current version in plugins section
2. Check if auto-update is enabled in config (disabled_hooks)
3. Explain current version and available upgrade path
4. Show what would change (plugins section version bump)
5. Ask: "Should I proceed with the upgrade?"
```

## Checking Current Version

**Always run the doctor command to check version:**

```bash
# Check installed and loaded versions
bunx oh-my-opencode doctor

# Verbose output with full status
bunx oh-my-opencode doctor --verbose
```

The doctor command shows both the version configured in `opencode.json(c)` and the version actually loaded by the plugin — this helps identify version mismatches.

⚠️ **CRITICAL: IGNORE doctor's automatic fix suggestions** ⚠️

When the doctor detects version mismatches (e.g., "loaded version smaller than latest"), it may suggest automatic fixes. **DO NOT follow those suggestions.**

Instead, **ALWAYS refer to the "Fixing Plugin Version Mismatches" section below in this skill** — it contains the correct procedure for this specific setup.

```bash
# Alternative: check config file directly
cat ~/.config/opencode/opencode.jsonc | grep oh-my-opencode
```

## Fixing Plugin Version Mismatches

If after checking version you see a mismatch between **installed** and **loaded** versions:

**Clear the OpenCode cache and restart:**

### Linux/macOS:
```bash
# Delete cache directory
rm -rf ~/.cache/opencode

# Or use file manager
# Navigate to ~/.cache/opencode and delete it
```

### Windows:
1. Press `WIN+R`
2. Paste: `%USERPROFILE%\.cache\opencode`
3. Press Enter
4. Delete the folder contents

**After clearing cache:** Restart OpenCode completely. The plugin will be re-installed automatically on next load.

## Common Configuration Tasks

### Change model for an agent:

**For built-in agents** (sisyphus, oracle, librarian, explore, etc.):
- Refer to: https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md#agent-provider-chains
- Do NOT suggest models based on your own judgment

**Example structure** (check official docs for recommended model):
```jsonc
{
  "agents": {
    "oracle": {
      "model": "<see-official-docs>",
      "variant": "<see-official-docs>"
    }
  }
}
```

### Change model for a category:

**For built-in categories** (quick, deep, ultrabrain, visual-engineering, etc.):
- Refer to: https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md#built-in-categories
- Do NOT suggest models based on your own judgment

**Example structure** (check official docs for recommended model):
```jsonc
{
  "categories": {
    "quick": {
      "model": "<see-official-docs>"
    }
  }
}
```

**For custom categories** (user-defined):
- You may suggest appropriate models based on the category description
- Consider the task type and domain when recommending

### Disable auto-update checker:

```jsonc
{
  "disabled_hooks": ["auto-update-checker"]
}
```

## Configuration Schema

For autocomplete in editors, add this to the top of your config:

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"
}
```

## When to Update This Skill

**If the official configuration reference changes significantly**, recommend the user update this skill:

> "I've noticed the oh-my-opencode configuration reference has been updated. The current skill may not reflect the latest configuration options. Consider updating the `omo` skill to ensure accurate guidance."

Link to official reference:
https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/configuration.md
