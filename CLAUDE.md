# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Start

1. Fill in `.claude/PROJECT_CONTEXT.md` with your project's name, stack, design system, and conventions.
2. The manager agent reads it and briefs all other agents — no need to edit individual agent files.

## Agent Pipeline

Nine specialized agents orchestrated by a manager in a phased pipeline:

```
brainstormer (opus) → architect (opus) → [arch-reviewer + security-reviewer] (parallel, opus)
    → [ux-designer + ux-reviewer] (sonnet) → implementer (sonnet) → code-reviewer (opus)
```

User approval gates between architecture review, design, and final code review. The manager coordinates everything and never writes code directly.

Not every task needs all phases:
- **Bug fix:** implementer → code-reviewer
- **UI-only change:** ux-designer → ux-reviewer → implementer → code-reviewer
- **New feature:** Full pipeline

## Required Skills

Agents depend on these installed skills:
- `superpowers:brainstorming`, `superpowers:writing-plans`, `superpowers:executing-plans`
- `superpowers:dispatching-parallel-agents`, `superpowers:subagent-driven-development`
- `superpowers:test-driven-development`, `superpowers:verification-before-completion`
- `superpowers:requesting-code-review`, `superpowers:receiving-code-review`
- `breakdown-epic-arch`, `fastapi-python`, `security-review`
- `web-design-guidelines`, `vercel-react-best-practices`, `vercel-composition-patterns`

## Required MCP Servers

- **Stitch** — used by ux-designer agent for screen mockups
