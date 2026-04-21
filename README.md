# 🌍 AI Ecosystem (The Ultimate Sync Assistant)

> Your personal agent-driven assistant to keep your local AI environment updated, standardized, and aligned with the latest "AI fashion."

**AI Ecosystem** is not just a repository. It is an **ever-evolving Synchronization Service**. It ensures that your IDEs (Cursor, Windsurf, Claude, Copilot, Antigravity) are always configured with the most cutting-edge prompts, the latest directory structures, and the newest agent workflows available on the market.

No manual setup. No standalone installers. Just talk to your AI.

---

## 🚀 How It Works (Agent-Driven Setup)

We replaced traditional setup scripts with a pure Agentic workflow. Your AI configures itself.

1. Open your AI IDE (Antigravity, Cursor, Claude, etc.).
2. Tell the AI: *"Read `AI_ONBOARDING.md` from the AI-Ecosystem repo and bootstrap my system."*
3. The AI conducts a quick onboarding interview in the chat (asking for your profession, stack, and project paths).
4. The AI uses its terminal access to automatically deploy your environment:

```text
~/.ai-ecosystem/          ← Global Ecosystem (Source of Truth)
├── agents/               ← Specialized AI Personas
├── skills/               ← Framework-specific knowledge (React, Rust)
├── templates/            ← Senior-level code standards (QA_RULES, PRD)
└── workflows/            ← Standard operating procedures
```

It is fully idempotent (safe to run multiple times) and automatically maps native configs (`.cursorrules`, `CLAUDE.md`, `.windsurfrules`) to this single source of truth.

---

## ⚡ The `/update` Command (Sync Assistant)

This repository is the central hub for cutting-edge AI configs.

To keep your machine up-to-date:
1. Type `/update` in any of your active AI projects.
2. Your AI Assistant will automatically run `git pull` in your global `~/.ai-ecosystem/` folder.
3. The AI will read the latest `AI_ONBOARDING.md` and safely inject new agents, rules (like `DESIGN.md`), or syntax optimizations into your current workspace.

---

## 📚 The Actionable Sources Index

Where do AI agents get their skills? 

We have compiled the **Ultimate AI Sources Index** in [`base/SOURCES.md`](./base/SOURCES.md). 

This is an actionable database for your AI. If you ask your AI to do something it doesn't know how to do (e.g., "Connect to a PostgreSQL database" or "Give me a Next.js rule"), it will consult `SOURCES.md`, navigate to the top community repositories (like `awesome-mcp-servers` or `cursor.directory`), extract the exact code it needs, and install it into your local ecosystem.

---

## 🏛️ Supported AI Tools (Native Routing)

AI Ecosystem is totally agnostic. During setup, the AI creates the exact files your specific tool expects:

| Tool | Config files generated |
|---|---|
| **Antigravity** | `GEMINI.md`, `.gemini/agents/`, `.ai/brain/` memory |
| **Cursor** | `.cursorrules`, `.cursorignore`, `.cursor/rules/*.mdc` |
| **Windsurf** | `.windsurfrules`, `.windsurfignore`, `.windsurf/rules/` |
| **Claude / RooCode** | `CLAUDE.md`, `AGENTS.md` |
| **GitHub Copilot** | `.github/copilot-instructions.md`, `.github/copilot-agents/` |

---

## 📄 License
MIT
