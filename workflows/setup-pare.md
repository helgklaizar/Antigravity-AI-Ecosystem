---
description: Install and configure Pare MCP to optimize CLI calls
---

# Pare MCP Setup (Structured CLI output)

The workflow for setting up Pare MCP in the current project/environment. Pare allows agents to receive clean JSON instead of incompatible CLI text, saving context tokens and significantly improving parsing.

1. Initializing Pare servers:
// turbo
```bash
npx -y @paretools/init --client gemini --preset web
```
*(Available presets: `web`, `python`, `rust`, `go`, `jvm`, `dotnet`, `ruby`, `swift`, `mobile`, `devops`, `full`)*

2. Verification that servers are correctly setup (this should run a diagnostic):
```bash
npx -y @paretools/doctor
```

3. Ensure the agent is reset/restarted to pick up the new MCP tools if the server configurations were modified.
