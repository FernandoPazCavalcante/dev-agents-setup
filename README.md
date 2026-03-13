# OpenCode Setup - Cost-Optimized Agent Configuration

A ready-to-use [OpenCode](https://opencode.ai) configuration that assigns the right model to each agent, cutting your bill by 30-50% without sacrificing quality where it matters.

All four agents -- Build, Plan, General, and Explore -- are Tab-switchable, so you can pick the right cost/capability tradeoff for every task.

## Quick Start

### 1. Install the global config

OpenCode reads its global configuration from `~/.config/opencode/opencode.json`. Copy the config from this repo into that location:

```bash
mkdir -p ~/.config/opencode
cp opencode.json ~/.config/opencode/opencode.json
```

Or create it manually:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": false,
  "model": "opencode/claude-opus-4-6",
  "agent": {
    "build": {
      "model": "opencode/claude-opus-4-6"
    },
    "plan": {
      "model": "opencode/claude-sonnet-4-6"
    },
    "general": {
      "model": "opencode/claude-sonnet-4-6",
      "mode": "all",
      "steps": 15
    },
    "explore": {
      "model": "opencode/claude-haiku-4-5",
      "mode": "all",
      "steps": 10
    },
    "title": {
      "model": "opencode/claude-haiku-4-5"
    },
    "summary": {
      "model": "opencode/claude-haiku-4-5"
    },
    "compaction": {
      "model": "opencode/claude-sonnet-4-6"
    }
  }
}
```

### 2. Verify

Launch OpenCode and press `Tab` repeatedly. You should cycle through four agents: **Build -> Plan -> General -> Explore**.

Run `/models` to confirm your model assignments are active.

## How the Agents Work

OpenCode uses a multi-agent architecture. Each agent has a specific role and can be assigned a different model. This config exploits that to use expensive models only where they add value.

### The `mode` property

OpenCode agents support three modes:

| Mode | Behavior |
|------|----------|
| `"primary"` | Tab-switchable only. Cannot be invoked as a subagent. |
| `"subagent"` | Invocable via `@mention` or automatically by primary agents. Not Tab-switchable. |
| `"all"` | Both. Tab-switchable AND invocable as a subagent. |

By default, `build` and `plan` are `primary`, while `general` and `explore` are `subagent`. This config sets `general` and `explore` to `"mode": "all"`, promoting them to Tab-switchable agents that can still be called as subagents.

### Tab-Switchable Agents

Press `Tab` to cycle through all four agents:

| Agent | Model | Mode | What it does |
|-------|-------|------|-------------|
| **build** | Opus 4.6 | primary | Writes and edits code. Default mode. Uses the best model because code generation quality matters most. |
| **plan** | Sonnet 4.6 | primary | Analyzes code and creates plans without making edits. Cheaper model since it only reads and reasons. |
| **general** | Sonnet 4.6 | all | Multi-step research tasks: exploring a codebase, fetching docs, answering complex questions. Capped at 15 steps. |
| **explore** | Haiku 4.5 | all | Fast, read-only codebase searches (grep, glob, file reads). Capped at 10 steps. The cheapest agent. |

### System Agents (run in the background)

| Agent | Model | What it does |
|-------|-------|-------------|
| **title** | Haiku 4.5 | Generates short session titles. Trivial task, cheapest model. |
| **summary** | Haiku 4.5 | Creates session summaries. Trivial task, cheapest model. |
| **compaction** | Sonnet 4.6 | Compresses conversation context when it gets too long. Needs decent intelligence to preserve important details. |

## Using the Agents Effectively

### Tab to the right agent for the job

The key idea: **press Tab to pick the cheapest agent that can handle your task**.

| Task | Best agent | Why |
|------|-----------|-----|
| Write or edit code | **Build** (Opus) | Highest quality for code generation |
| Review a plan, analyze code | **Plan** (Sonnet) | Read-only, 40% cheaper than Opus |
| Research across multiple files, fetch docs | **General** (Sonnet) | Full tool access, multi-step capable |
| "Where is X?", find files, search code | **Explore** (Haiku) | Read-only, 80% cheaper than Opus |

### Use as Tab-switched primary agent

```
# Press Tab until you see "Explore" in the bottom-right corner
> Where is the database connection configured?
> Find all API route handlers

# Press Tab until you see "General"
> Research how this project handles error boundaries and summarize the pattern

# Press Tab until you see "Plan"
> Explain how authentication works in this project
> What would break if I rename this function?

# Press Tab back to "Build"
> Add input validation to the signup form
```

### Use as @mentioned subagent

Since `general` and `explore` have `"mode": "all"`, they also work as subagents you can invoke from any primary agent with `@`:

```
# From Build mode, delegate a search to the cheaper Explore agent
> @explore Find all files that import the auth module

# From Build mode, delegate research to General
> @general Research how error handling works in this project and give me a summary
```

This is useful when you're in Build mode and want to delegate a subtask without switching agents.

## Cost Breakdown

| Model | Cost (per 1M tokens) | Used by |
|-------|---------------------|---------|
| Claude Opus 4.6 | $5 in / $25 out | build |
| Claude Sonnet 4.6 | $3 in / $15 out | plan, general, compaction |
| Claude Haiku 4.5 | $1 in / $5 out | explore, title, summary |

Estimated savings vs running everything on Opus: **30-50%** depending on usage patterns.

## Customization

### Change a model

Edit `~/.config/opencode/opencode.json` and swap any model value. Available models can be listed with `/models` inside OpenCode.

### Adjust step limits

The `steps` field caps how many tool calls an agent can make per invocation. Lower values save money but may cut off complex tasks early.

```json
"general": {
  "model": "opencode/claude-sonnet-4-6",
  "mode": "all",
  "steps": 20
}
```

### Change agent modes

If you prefer `general` and `explore` as subagents only (not Tab-switchable), change `"mode": "all"` to `"mode": "subagent"` or remove the `mode` field entirely.

### Per-project overrides

Place an `opencode.json` in your project root to override the global config for that project. Project config merges with and takes precedence over the global config.

### Agent definitions via Markdown

You can also define custom agents as Markdown files in `~/.config/opencode/agents/` (global) or `.opencode/agents/` (per-project). The filename becomes the agent name.

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: opencode/claude-sonnet-4-6
tools:
  write: false
  edit: false
  bash: false
---

You are in code review mode. Focus on code quality, potential bugs, and performance.
```

## Additional Tips

1. Set monthly spending limits in your provider dashboard to avoid surprises.
2. Use `/models` to switch models on the fly when a specific task needs more or less intelligence.
3. See `OPENCODE_CONFIG.md` in this repo for the full rationale behind each model assignment.

## References

- [OpenCode Documentation](https://opencode.ai/docs)
- [OpenCode Agents Configuration](https://opencode.ai/docs/agents/)
- [OpenCode Config Reference](https://opencode.ai/docs/config/)
