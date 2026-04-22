# 🌍 Antigravity AI Ecosystem

> **The ultimate native macOS hub and command center for AI-driven development. Zero bloat, zero context hallucinations, maximum Apple Silicon performance.**

![Architecture](https://img.shields.io/badge/Architecture-Flat_Global_Topology-blue.svg)
![Status](https://img.shields.io/badge/Status-Production_Ready-success.svg)
![macOS](https://img.shields.io/badge/Platform-macOS_Native-black.svg)

## 🎯 What is this project?

This repository is a **master orchestration database** for the Antigravity IDE. It transforms a standard AI coding assistant into a fully autonomous, context-aware development team. 

Instead of relying on basic LLM prompts, this ecosystem provides:
1. **Curated Skills (`/skills`)**: Highly specific technical instructions (e.g., Swift Native Apple APIs, Next.js App Router, Rust lifetimes).
2. **Global Workflows (`/global_workflows`)**: Step-by-step CI/CD and orchestration pipelines triggered via `/slash-commands` (e.g., `/qa-start`, `/pr-writer`, and `/recap` to save session states).
3. **Specialized Agents (`/agents`)**: Distinct AI personas (Architect, QA, DevOps) that can be swapped dynamically.
4. **Architectural Templates (`/templates`)**: Standardized project configurations like `SWARM_STATE.md` (for agent handovers) and `SECRETS_MAP.md` (for strict environment security).

---

## 🏛️ The "Lean Architecture" Paradigm

**We strictly enforce the Flat Global Architecture Rule.**
Unlike older setups where every project had its own messy `.gemini/` hidden folder full of duplicate prompts, this ecosystem runs centrally from `~/.gemini/antigravity/`. 

* **No Duplicates**: A skill is updated here, and it instantly applies to all your projects.
* **No Blind Spots**: The IDE parses the exact same workflows regardless of what directory your terminal is in.
* **Auto-Formatting Hooks**: Seamless integration with `prettier`, `rustfmt`, and `ruff` on the IDE level.

---

## ⚡ The Antigravity Bar (Status Bar App)

This project includes a native macOS menu bar application written in Swift, which acts as the bridge between this GitHub repository and your Local System.

**Core Capabilities:**
- **Zero-Prompt Onboarding**: Drop the GitHub repo link into the chat, and the AI will analyze your local system (`uname`, `package.json`, `Cargo.toml`), select the relevant skills, and build your environment automatically.
- **Ecosystem Syncing**: Automatically fetches and updates the latest workflows and skills directly from GitHub.
- **Context Switching**: The Status Bar detects the active IDE window and dynamically swaps your active `PROFILE.md` pre-sets to prevent AI context hallucination.
- **macOS Permissions Management**: Natively handles requesting required system permissions (Accessibility, Full Disk Access) before running scripts.
- **Security Guardrails**: Enforces "Safe Mode" blocking rogue `npm` scripts and requiring strict `pnpm`/`cargo` validation.

---

## 🚀 First-Time Onboarding

There are two ways to set up your perfectly tailored environment:

### Flow A: AI-Driven Onboarding (Recommended)
1. Open **Antigravity IDE**.
2. Drop the repository link into the AI chat: `https://github.com/helgklaizar/AI-Ecosystem`
3. The Agent will autonomously find `AI_ONBOARDING.md`, read the instructions, install the Status Bar, and interactively compile your `settings.json` based on your stack.

### Flow B: Visual Setup
1. Compile and launch the **Antigravity Bar** from the `status-bar/` folder.
2. Follow the sleek macOS setup wizard.
3. Select your tech stack. The Status Bar will pull ONLY the necessary assets from this Global Database into your `~/.gemini/antigravity/` folder to keep your IDE blazing fast.

---

## 🧠 Documentation & Standards

- 📖 **[The Ecosystem Guide](ECOSYSTEM_GUIDE.md)** — The curated list of essential stacks and architectural rules.
- 🚀 **[The Onboarding Script](AI_ONBOARDING.md)** — Core AI instructions for generating dynamic configurations.
- 🏗️ **[Templates & Security](templates/)** — Explore the Swarm State protocols and Secrets mapping.

---
## 📄 License
MIT
