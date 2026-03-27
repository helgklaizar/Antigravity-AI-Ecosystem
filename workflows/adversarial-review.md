---
description: Act as a Devil's Advocate to pressure-test a completed specification or architectural plan.
---

// turbo-all
1. The user must provide a link to the specification or feature plan.
2. Your task is NOT to write code, but to act as a senior staff engineer whose sole purpose is to find vulnerabilities, logic gaps, scope creep, and edge cases.
3. Evaluate the spec against the following criteria:
   - Coverage: Are the negative scenarios covered (API errors, offline states, bad or empty data)?
   - Scope Creep: Is the spec trying to do "too much" at once? Can it be broken down into smaller milestones?
   - Non-goals: Is it clearly stated what we are NOT doing within this task? Are these constraints sufficient?
   - Testability: Can we objectively test what is described in the Acceptance Criteria?
4. Critize the plan and provide harsh, direct feedback pointing out exactly what must be fixed or clarified.
