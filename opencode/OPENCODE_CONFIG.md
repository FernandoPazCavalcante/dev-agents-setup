# OpenCode Configuration - Cost Optimization Strategy

## Config Location

Global config: `~/.config/opencode/opencode.json`

## Agent Model Assignments

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | Claude Sonnet 4.6 | Primary - code generation & edits | $3 in / $15 out |
| **plan** | Claude Opus 4.6 | Primary - analysis without edits | $5 in / $25 out |
| **general** | Claude Sonnet 4.6 | Primary + Subagent (`mode: all`) - research & multi-step tasks | $3 in / $15 out |
| **explore** | Claude Haiku 4.5 | Primary + Subagent (`mode: all`) - read-only codebase search | $1 in / $5 out |
| **title** | Claude Haiku 4.5 | System - session title generation | $1 in / $5 out |
| **summary** | Claude Haiku 4.5 | System - session summary | $1 in / $5 out |
| **compaction** | Claude Sonnet 4.6 | System - context compaction | $3 in / $15 out |

## Step Limits

| Agent | Max Steps | Reason |
|-------|-----------|--------|
| **explore** | 10 | Read-only searches should be fast |
| **general** | 15 | Research tasks capped to avoid runaway costs |

## Rationale

- **Build (Sonnet 4.6):** Sonnet 4.6 is excellent at code generation. Build produces the most output tokens, so using Sonnet here saves the most (40% cheaper output vs Opus).
- **Plan (Opus 4.6):** Architecture and planning decisions benefit from Opus-level reasoning. Planning is input-heavy with shorter outputs, so the cost impact is lower.
- **General (Sonnet 4.6, `mode: all`):** Multi-step research tasks. Tab-switchable so you can use it as a primary agent, and still available as a subagent. Sonnet handles these well at 40% less cost.
- **Explore (Haiku 4.5, `mode: all`):** Read-only file search, grep, glob. Tab-switchable for quick codebase exploration, and still available as a subagent. Haiku is more than capable at 80% cheaper.
- **Title/Summary (Haiku 4.5):** Trivial tasks (5-word titles, short summaries). 80% cheaper.
- **Compaction (Sonnet 4.6):** Context summarization. Sonnet handles this well.

## Estimated Savings

Assuming subagents and system agents consume ~40% of total tokens:
- Before: 100% at Opus pricing
- After: ~60% Opus + ~25% Sonnet + ~15% Haiku
- **Estimated savings: 30-50% on total bill**

## Usage Tips

1. **Use Tab to cycle agents:** Build -> Plan -> General -> Explore. All four are Tab-switchable.
2. **Use Explore mode** (Tab to it) for codebase questions instead of letting Build search with Opus
3. **Use General mode** (Tab to it) for research tasks — runs on cheaper Sonnet with full tool access
4. **Use `@explore` or `@general`** to invoke them as subagents from Build or Plan mode
5. **Set monthly limits** in Zen dashboard to avoid surprises
6. **Switch models on the fly** with `/models` when you need Opus for a complex task

## Config Snapshot

```json
{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": false,
  "model": "opencode/claude-opus-4-6",
  "agent": {
    "build": {
      "model": "opencode/claude-sonnet-4-6"
    },
    "plan": {
      "model": "opencode/claude-opus-4-6"
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

## Last Updated

March 17, 2026
