# AI Ecosystem Sources & Registries

This repository acts as the central hub (Ecosystem) for your AI development. When you need to expand your AI's capabilities, follow the hierarchy below to find the best tools, agents, and workflows.

---

## 🟢 Level 0: Native Ecosystem (Start Here)
**Agent Instruction:** Before searching the web or external repositories, always check the local ecosystem folders first.
- **`~/.ai-ecosystem/agents/`**: Core personas (Architect, DevOps, UX-Animator).
- **`~/.ai-ecosystem/workflows/`**: Established company workflows (Crash Detect, API integrations).
- **`~/.ai-ecosystem/skills/`**: Curated, pre-approved skills.
- **`~/.ai-ecosystem/templates/`**: Base project templates (GEMINI, AGENTS, DESIGN, PRD, SECURITY).

---

## 🔵 Level 1: Tool-Specific Rules & Databases
If a specific framework rule (e.g., Next.js, Rust, SwiftUI) is missing locally, pull from the best community standards tailored to your current IDE:

### Cursor
- **[cursor.directory](https://cursor.directory/)**: The largest web directory of framework-specific `.cursorrules` and `.mdc` files.
- **[PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)**: Massive GitHub collection of curated rules.
- **[tugkanboz/awesome-cursorrules](https://github.com/tugkanboz/awesome-cursorrules)**: High-quality, context-aware rule templates.

### Windsurf
- **[detailobsessed/awesome-windsurf](https://github.com/detailobsessed/awesome-windsurf)**: Curated repository for Windsurf IDE workflows and `.windsurfrules`.

### Claude Code / Cline / RooCode
- **[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)**: Focuses specifically on the Claude Code CLI ecosystem.
- **[JhonMA82/awesome-clinerules](https://github.com/JhonMA82/awesome-clinerules)**: Rules optimized for Cline / RooCode AI agents.
- **[webfuse-com/awesome-claude](https://github.com/webfuse-com/awesome-claude)**: Comprehensive directory of Claude workflows.

---

## 🟣 Level 2: Prompts & System Instructions
When you need to adjust an agent's persona or find an expert-level prompt for a complex task:
- **[langgptai/awesome-claude-prompts](https://github.com/langgptai/awesome-claude-prompts)**: Community-curated collections of prompt examples for coding, roleplaying, and expert tasks.

---

## 🟠 Level 3: Model Context Protocol (MCP) Servers
MCP allows the AI IDE to directly connect to external databases, APIs, and tools. If you need a new capability (querying PostgreSQL, searching Google, reading Notion), install an MCP server:
- **[modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)**: The official Anthropic/MCP repository (Postgres, Google Drive, Slack, GitHub, Puppeteer).
- **[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)**: The largest community-curated list of MCP servers.
- **[win4r/Awesome-Claude-MCP-Servers](https://github.com/win4r/Awesome-Claude-MCP-Servers)**: Frameworks and integration examples for MCP.

---

## 🔴 Level 4: Skills & Framework Integrations
To give the AI specific domain capabilities (like executing cloud deployments or building complex UI):
- **Agent Frameworks:**
  - **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)**: Specialized sub-agents across DevOps, QA, Data/ML.
  - **[huggingface/smolagents](https://github.com/huggingface/smolagents)**: HuggingFace's library for building minimalist, powerful agents.
- **Vendor Skills:**
  - **[angular/skills](https://github.com/angular/skills)**: Official Angular team skills.
  - **[stripe/agent-toolkit](https://github.com/stripe/agent-toolkit)**: Official Stripe integration tools.
  - **[vercel/vercel](https://github.com/vercel/vercel)**: Official Vercel CLI deployments.
  - **[trycourier/courier-skills](https://github.com/trycourier/courier-skills)**: Notifications integration.

---

> **Final Agent Instruction:** 
> If the user asks for a capability you lack, use your terminal to clone, curl, or read from the repositories listed above to dynamically learn the skill and add it to the user's `~/.ai-ecosystem/` folder!
