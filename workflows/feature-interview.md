---
description: Start a requirement-gathering interview process for a major new feature
---

// turbo-all
1. Read the `GEMINI.md` file to understand the project context (if it exists).
2. Conduct an interview with the user following the Spec-driven development methodology, asking clarifying questions:
   - What is the primary business goal of this feature? (What should it achieve ultimately).
   - What is explicitly OUT of scope for this task (Non-goals)?
   - What are the technical constraints or assumptions (e.g., platforms, libraries, performance targets, UI)?
   - How will we verify that the feature is done (Acceptance Criteria / Validation Plan)?
3. Do NOT write code at this stage! Analytics only.
4. After receiving answers, generate a specification file based on the `.gemini/templates/micro-spec.md` template and save it in `docs/specs/<feature-name>.md`.
5. Ask the user to approve the specification before starting the implementation.
