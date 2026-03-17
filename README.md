# dev-agents-setup

Cost-optimized configurations for [OpenCode](https://opencode.ai) and [Claude Code](https://claude.ai/code) that assign the right model to each agent, cutting your bill by 30-50% without sacrificing quality.

## Repository Structure

```
.
├── opencode/
│   ├── configs/
│   │   ├── anthropic.json   # Use your Anthropic API key directly
│   │   └── zen.json         # Use OpenCode's Zen platform billing
│   ├── switch.sh            # Switch between providers
│   └── OPENCODE_CONFIG.md   # Rationale and cost breakdown
└── claude-code/
    ├── settings.json        # Global config → ~/.claude/settings.json
    └── agents/
        ├── plan.md          # Opus 4.6 — planning and architecture
        └── explore.md       # Haiku 4.5 — fast read-only search
```

---

## OpenCode

### Model Assignments

| Agent | Model | Role |
|-------|-------|------|
| **build** | Sonnet 4.6 | Writes and edits code (Tab-switchable) |
| **plan** | Opus 4.6 | Analysis and planning without edits (Tab-switchable) |
| **general** | Sonnet 4.6 | Multi-step research, full tool access (Tab-switchable + subagent) |
| **explore** | Haiku 4.5 | Fast read-only codebase search (Tab-switchable + subagent) |
| **title** | Haiku 4.5 | Session title generation (system) |
| **summary** | Haiku 4.5 | Session summaries (system) |
| **compaction** | Sonnet 4.6 | Context compaction (system) |

### Quick Start

Choose your billing provider and run the switch script:

```bash
# Use your Anthropic API key
./opencode/switch.sh anthropic

# Use OpenCode's Zen platform
./opencode/switch.sh zen
```

This copies the chosen config to `~/.config/opencode/opencode.json`. Run it any time to switch providers.

Launch OpenCode and press `Tab` to cycle through agents: **Build → Plan → General → Explore**.

### Usage Tips

| Task | Best agent | Why |
|------|-----------|-----|
| Write or edit code | **Build** (Sonnet) | Excellent for code gen, 40% cheaper than Opus |
| Architecture, code review | **Plan** (Opus) | Deep reasoning where it counts |
| Research across files, fetch docs | **General** (Sonnet) | Full tool access, multi-step capable |
| Find files, search code | **Explore** (Haiku) | Read-only, 80% cheaper than Opus |

Use `@explore` or `@general` to invoke them as subagents from Build or Plan mode.

See [`opencode/OPENCODE_CONFIG.md`](opencode/OPENCODE_CONFIG.md) for full rationale and cost breakdown.

---

## Claude Code

### Model Assignments

| Context | Model | How |
|---------|-------|-----|
| Main session (build) | Sonnet 4.6 | Default via `settings.json` |
| `plan` subagent | Opus 4.6 | `agents/plan.md` |
| `explore` subagent | Haiku 4.5 | `agents/explore.md` |

### Quick Start

```bash
# Global settings
cp claude-code/settings.json ~/.claude/settings.json

# Custom subagents (global)
mkdir -p ~/.claude/agents
cp claude-code/agents/plan.md ~/.claude/agents/plan.md
cp claude-code/agents/explore.md ~/.claude/agents/explore.md
```

Or for per-project agents, copy into `.claude/agents/` in your project root.

### Usage Tips

Claude Code automatically delegates to the right subagent based on the task description. You can also invoke them explicitly:

- **"Use the explore agent to find..."** → runs on Haiku 4.5
- **"Use the plan agent to review..."** → runs on Opus 4.6
- **Main session** → Sonnet 4.6 for all coding work

Use `/model` inside a session to switch models on the fly when needed.

---

## Cost Model

| Model | Price (per 1M tokens) |
|-------|-----------------------|
| Claude Opus 4.6 | $5 in / $25 out |
| Claude Sonnet 4.6 | $3 in / $15 out |
| Claude Haiku 4.5 | $1 / $5 out |

**Strategy:** Sonnet for build (high output volume, 40% cheaper than Opus), Opus for plan (shorter sessions, deeper reasoning), Haiku for search (trivial read-only tasks).

Estimated savings vs running everything on Opus: **30-50%**.

## References

- [OpenCode Documentation](https://opencode.ai/docs)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
