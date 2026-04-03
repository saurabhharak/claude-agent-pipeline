# Claude Agent Pipeline

A pre-configured multi-agent development pipeline for [Claude Code](https://claude.ai/code). Nine specialized agents orchestrated by a manager agent handle the full feature lifecycle — from brainstorming through architecture, design, security review, implementation, and code review.

Copy this into any project. Fill in one config file. Start building.

## Pipeline

```
                          ┌──────────────────┐
                          │     manager      │
                          │   (orchestrator) │
                          └────────┬─────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              ▼                    │                     │
     ┌─────────────┐              │                     │
     │ brainstormer │              │                     │
     │  feature spec│              │                     │
     └──────┬──────┘              │                     │
            ▼                     │                     │
     ┌─────────────┐              │                     │
     │  architect   │              │                     │
     │  tech design │              │                     │
     └──────┬──────┘              │                     │
            │                     │                     │
     ┌──────┴──────┐              │                     │
     ▼             ▼              │                     │
┌──────────┐ ┌───────────┐       │                     │
│arch-     │ │security-  │       │                     │
│reviewer  │ │reviewer   │  parallel                   │
└────┬─────┘ └─────┬─────┘       │                     │
     └──────┬──────┘              │                     │
            ▼                     │                     │
     ⏸️ USER APPROVAL              │                     │
            │                     │                     │
     ┌──────┴──────┐              │                     │
     ▼             ▼              │                     │
┌──────────┐ ┌───────────┐       │                     │
│ux-       │ │ux-        │       │                     │
│designer  │ │reviewer   │  parallel                   │
└────┬─────┘ └─────┬─────┘       │                     │
     └──────┬──────┘              │                     │
            ▼                     │                     │
     ⏸️ USER APPROVAL              │                     │
            │                     │                     │
            ▼                     │                     │
     ┌─────────────┐              │                     │
     │ implementer  │              │                     │
     │  write code  │              │                     │
     └──────┬──────┘              │                     │
            ▼                     │                     │
     ┌─────────────┐              │                     │
     │code-reviewer │              │                     │
     │  final check │              │                     │
     └──────┬──────┘              │                     │
            ▼                     │                     │
     ⏸️ USER APPROVAL              │                     │
```

Not every task needs the full pipeline. The manager adapts:

| Task | Pipeline |
|------|----------|
| Bug fix | implementer → code-reviewer |
| UI change | ux-designer → ux-reviewer → implementer → code-reviewer |
| New feature | Full pipeline |

## Quick Start

**Option A — Setup script:**

```bash
git clone https://github.com/YOUR_USERNAME/claude-agent-pipeline.git
cd claude-agent-pipeline
bash setup.sh /path/to/your-project
```

**Option B — Manual copy:**

```bash
# Copy .claude/ folder and CLAUDE.md into your project
cp -r .claude/ /path/to/your-project/.claude/
cp CLAUDE.md /path/to/your-project/CLAUDE.md
```

Then:

1. Edit `.claude/PROJECT_CONTEXT.md` — fill in your project name, stack, design system, and conventions
2. Copy `.claude/settings.local.json.example` to `.claude/settings.local.json` and adjust permissions
3. Run `claude --agent manager` and describe what you want to build

## Prerequisites

### Claude Code

Install [Claude Code](https://claude.ai/code) and have an active API key or subscription.

### Plugin: Superpowers

The agents rely on skills from the [Superpowers plugin](https://github.com/claude-plugins-official/superpowers). Install it:

```
claude install-plugin superpowers
```

This provides: `superpowers:brainstorming`, `superpowers:writing-plans`, `superpowers:executing-plans`, `superpowers:dispatching-parallel-agents`, `superpowers:subagent-driven-development`, `superpowers:test-driven-development`, `superpowers:verification-before-completion`, `superpowers:requesting-code-review`, `superpowers:receiving-code-review`.

### Community Skills

Install these skills (the agents reference them by name). Sources listed so you can install from GitHub:

| Skill | Source | Used by |
|-------|--------|---------|
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Discovery |
| `vercel-react-best-practices` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | ux-reviewer, implementer, code-reviewer |
| `vercel-composition-patterns` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | ux-reviewer |
| `web-design-guidelines` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | ux-designer, ux-reviewer |
| `fastapi-python` | [mindrally/skills](https://github.com/mindrally/skills) | implementer |
| `breakdown-epic-arch` | [github/awesome-copilot](https://github.com/github/awesome-copilot) | architect |
| `security-review` | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | security-reviewer |
| `github-pr-review` | [fvadicamo/dev-agent-skills](https://github.com/fvadicamo/dev-agent-skills) | PR workflows |

Use the `find-skills` skill to discover and install these, or clone the repos and symlink to `~/.claude/skills/`.

### MCP Server (Optional)

The **ux-designer** agent uses [Stitch MCP](https://stitch.design) for screen mockups. If you don't need design mockups, skip this — the agent will still work but without Stitch tools.

## Agents

| Agent | Model | Role | Key skills |
|-------|-------|------|------------|
| **manager** | opus | Orchestrates the pipeline, delegates tasks, gates approvals | dispatching-parallel-agents, subagent-driven-development |
| **brainstormer** | opus | Explores ideas, asks questions, writes feature specs | brainstorming |
| **architect** | opus | Creates technical architecture and implementation plans | breakdown-epic-arch, writing-plans |
| **arch-reviewer** | opus | Reviews architecture for consistency and pattern compliance | receiving-code-review |
| **security-reviewer** | opus | OWASP Top 10, auth, access control, input validation | security-review |
| **ux-designer** | sonnet | Creates screen mockups via Stitch MCP | web-design-guidelines |
| **ux-reviewer** | sonnet | Reviews UI for accessibility and best practices | web-design-guidelines, react-best-practices, composition-patterns |
| **implementer** | sonnet | Writes production code following the plan | TDD, executing-plans, verification, fastapi-python, react-best-practices |
| **code-reviewer** | opus | Reviews code for bugs, type safety, and cross-layer consistency | requesting-code-review, verification |

## Configuration

### PROJECT_CONTEXT.md

This is the **only file you edit per project**. The manager reads it and briefs all other agents.

```markdown
## Project
- **Name:** My App
- **Description:** What it does

## Stack
- **Backend:** FastAPI
- **Frontend:** React/TypeScript
- **Database:** PostgreSQL

## Design System
- **Theme:** Dark
- **Primary colors:** ...

## Project Conventions
- **Models:** backend/app/models.py
- **Routes:** backend/app/routers/*.py
...

## Domain Context
Any business rules or domain knowledge agents should know.
```

### settings.local.json

Controls which tools are auto-approved (not prompted). Start with the example file:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

Edit to match your project's needs (e.g., add `WebFetch` domains for APIs you use).

## Testing

Smoke test all agents:

```bash
bash test-agents.sh
```

This runs each agent in headless mode (`--max-turns 1`) to verify it loads, sees its role, tools, and skills. Also verifies the manager can see all 8 sub-agents.

## Customization

### Adding an agent

1. Create `.claude/agents/my-agent.md` with YAML frontmatter (`name`, `description`, `tools`, `model`, `color`, `skills`)
2. Add it to the manager's `tools` field: `Agent(..., my-agent)`
3. Add it to the manager's workflow pipeline

### Removing an agent

Delete the file and remove it from the manager's `tools` field and pipeline.

### Changing models

Edit the `model` field in each agent's frontmatter. Use `opus` for reasoning-heavy tasks (review, architecture) and `sonnet` for execution tasks (implementation, design).

## License

[MIT](LICENSE)
