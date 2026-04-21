# Project Context (GEMINI)

## Pre-Flight Checklist
Before writing any code or making changes, you MUST:
- [ ] Review `~/.ai-ecosystem/STRUCTURE.md` to ensure you understand the global architecture.
- [ ] Check `.ai/brain/` for any historical context or recent architecture decisions.
- [ ] Understand the Data Flow and how the changes impact existing logic.

## Project
- **Name**: [project-name]
- **Stack**: [e.g., Swift, React, Python, Rust]
- **Goal**: [one sentence describing what this project does]
- **Status**: [active / paused / done]

## Architecture & Data Flow
[Brief description of the main components. How does data flow from the UI to the backend? What state management is used?]

## Secrets & Env
- **Env Location**: [e.g., `.env.local`]
- **Handling**: NEVER hardcode secrets. Always use environment variables. NEVER output secrets or keys in the chat.

## Key Decisions
- [decision]: [why]

## Important Notes
[Anything the AI should always know about this project]
