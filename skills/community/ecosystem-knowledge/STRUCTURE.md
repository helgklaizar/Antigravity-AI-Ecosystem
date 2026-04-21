# AI Ecosystem — 3-Pillar Minimalist Architecture

> Everything is an Agent, a Skill, or a Workflow.

## 📁 The Root
```
AI-Ecosystem/
├── agents/                   ← The Doers (e.g. backend-developer.md)
├── skills/                   ← The Knowledge (e.g. IDE rules, MCPs, API docs)
└── workflows/                ← The Processes (e.g. new-project.md)
    └── templates/            ← Boilerplate files injected by workflows
```

## 📄 Universal Templates (`workflows/templates/`)
| File | Purpose |
|---|---|
| `PROJECT_CONTEXT.md` | Universal project context (stack, goals, status) |
| `AGENTS.md` | Universal agent instructions for any AI |
| `CLAUDE.md` | Entry point for Claude (points to CONTEXT) |
| `.cursorrules` | Entry point for Cursor (points to CONTEXT) |
| `DESIGN.md` | Design tokens |
