---
name: /session-recap
description: Summarizes the current session, decisions made, and files modified, saving the context for the next agent or session.
---

# 📝 Session Recap Workflow

**Trigger:** The user invokes this workflow by typing `/recap` or `/session-recap`.

## Objective
To prevent context loss when closing the IDE or switching to a new agent. This workflow mimics the Claude Code `/recap` feature by analyzing the current session's work and persisting it into a standard state file.

## Execution Steps

### 1. Context Analysis
- Review the current conversation history to understand the user's initial request and the problem being solved.
- Run `git status` and `git diff --stat` to identify exactly which files were created or modified during this session.
- Identify the core architectural or design decisions that were made.

### 2. Recap Generation
Formulate a concise summary containing:
- **🎯 Objective:** What was the goal of this session?
- **✅ Completed Work:** What features were implemented or bugs fixed?
- **📂 Modified Files:** A list of key files touched.
- **🧠 Key Decisions:** Why certain technical choices were made (e.g., "Chose context API over Redux for simplicity").
- **🚀 Next Steps:** What is left to do in the next session?

### 3. State Persistence
- Open or create `SWARM_STATE.md` in the project root (or `.gemini/recap.md` if the user prefers).
- Overwrite or append the generated recap into this file under a dated header (e.g., `## Session Recap: [Date]`).
- If `GEMINI.md` exists, ensure that any major architectural shifts (like adding a new database or library) are updated in its `Stack` section.

### 4. User Handoff
- Output the generated recap directly into the chat for the user to review.
- Conclude with: *"Session state saved to `SWARM_STATE.md`. You can safely close this chat. The next agent will read this file to resume work."*
