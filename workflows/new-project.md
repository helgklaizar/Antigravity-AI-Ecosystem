---
description: Questions and initialization workflow when starting a new project
---

// turbo-all
1. If the user says "Create a new project" or "Scaffold a new backend/frontend" without details — **Stop code generation**. Ask 4 mandatory questions:
   - **Stack:** What technologies and databases are we using?
   - **Primary Role / Architecture:** What is the main purpose of the project?
   - **Red Flags (Constraints):** What am I absolutely forbidden to do?
   - **Contracts (API / IPC):** Do we need to formalize contracts right away?
2. Wait for the user's answers.
3. Only after receiving the answers, perform the scaffold (framework installation).
4. IMMEDIATELY (before the first commit), create a `GEMINI.md` file in the root, strictly using the template `.gemini/templates/project-index.md`. Fill in the stack, architecture, red flags, and documentation paths. Do not store tasks verbosely in GEMINI.md, only the path to the sprint file.
5. Create the folder structure `docs/sprints/` and the first weekly sprint file (e.g., `docs/sprints/week-1.md`), where we will write all micro-specs and tasks for the current week. New week = new file.
6. Refresh the root `README.md`.
7. Ask the user: "The base is ready. What is the first task we are tossing into the current weekly sprint? Shall we start a `/feature-interview`?"
