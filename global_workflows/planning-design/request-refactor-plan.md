Create a detailed refactoring plan with tiny, atomic commits via a user interview, then file it as a GitHub Issue. Use when the user wants to plan a refactor, create a refactoring RFC, or break a large code overhaul into safe, incremental steps.

This skill is invoked when the user wants to create a refactor request. Go through the steps below. You may skip steps if you consider them unnecessary in the current context.

1. **Problem Statement**: Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.
2. **Explore Codebase**: Explore the repository to verify their assertions and understand the current state of the codebase.
3. **Alternatives**: Ask the user whether they have considered other options, and present alternative approaches to them.
4. **Implementation Interview**: Interview the user thoroughly about the implementation details. Be extremely detailed and thorough.
5. **Scope Boundaries**: Hammer out the exact scope of the implementation. Decide exactly what is planned to change and what will not be touched.
6. **Test Coverage**: Check the codebase for test coverage in the area being modified. If coverage is insufficient, ask the user about their plans for testing.
7. **Atomic Commits**: Break the implementation down into a plan of tiny commits. Remember Martin Fowler's advice: "make each refactoring step as small as possible, so that you can always see the program working."
8. **Create Issue**: Create a GitHub Issue with the refactor plan. Use the following template for the issue description:

<refactor-plan-template>

## Problem Statement
The problem the developer is facing, from their perspective.

## Solution
The solution to the problem, from the developer's perspective.

## Commits
A LONG, detailed implementation plan. Write the plan in plain English, breaking down the implementation into the tiniest possible commits. Each commit must leave the codebase in a working state.

## Decision Document
A list of architectural and implementation decisions made. This can include:
- Modules that will be built/modified
- Interfaces of modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes (DB, etc.)
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets here. They may become outdated very quickly.

## Testing Decisions
A list of testing decisions made. Includes:
- A description of what makes a good test (testing external behavior, not implementation details)
- Which modules will be tested
- Prior art in the project (similar types of tests already existing in the codebase)

## Out of Scope
A description of things that fall outside the scope of this refactor (what we are not touching).

## Further Notes (optional)
Any additional notes about the refactor.

</refactor-plan-template>
