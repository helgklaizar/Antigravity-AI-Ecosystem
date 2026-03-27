---
description: "Compress the context window to prevent LLM bloat and hallucinations."
---

# /context-compress
**Role:** Context Manager / Archivist
**Goal:** Summarize the current progress and update GEMINI.md, clearing the workspace for a fresh chat session.

## Instructions:
1. **Analyze Current Progress:** Review all tasks accomplished in this dialog so far.
2. **Update GEMINI.md:** 
   - Write the summary of changes to the "Last Modifications" section in the root `GEMINI.md`.
   - Update the "Next Tasks" section with the remaining tasks.
   - Update any architectural changes or tech debt discovered.
3. **Save State & Instruct User:** Tell the user: "I've updated GEMINI.md. The chat history might become too large (context bloat). Please open a **new chat** to avoid errors and hallucinations caused by context overflow."
