---
name: nextjs-app-router-patterns
description: "Comprehensive patterns for Next.js 14+ App Router architecture, Server Components, and modern full-stack React development."
risk: safe
source: community
date_added: "2026-02-27"
---

# Next.js App Router Patterns

Comprehensive patterns for Next.js 14+ App Router architecture, Server Components, and modern full-stack React development.

## Use this skill when

- Building new Next.js applications with App Router
- Migrating from Pages Router to App Router
- Implementing Server Components and streaming
- Setting up parallel and intercepting routes
- Optimizing data fetching and caching
- Building full-stack features with Server Actions

## Do not use this skill when

- The task is unrelated to next.js app router patterns
- You need a different domain or tool outside this scope

## Instructions

- Clarify goals, constraints, and required inputs.
- Apply relevant best practices and validate outcomes.
- Provide actionable steps and verification.
- If detailed examples are required, open `resources/implementation-playbook.md`.

## Resources

- `resources/implementation-playbook.md` for detailed patterns and examples.

## Limitations
- Use this skill only when the task clearly matches the scope described above.
- Do not treat the output as a substitute for environment-specific validation, testing, or expert review.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.


---

## Merged Content from frontend/nextjs-app-router.md

# Nextjs App Router Coding Standards

This skill provides language, framework, and tooling rules.

// Next.js App Router .GEMINI.md

// Next.js App Router best practices
const nextjsAppRouterBestPractices = [
  "Use server components by default",
  "Implement client components only when necessary",
  "Utilize the new file-based routing system",
  "Use layout.js for shared layouts",
  "Implement loading.js for loading states",
  "Use error.js for error handling",
  "Utilize route handlers for API routes",
];

// Folder structure
const folderStructure = `
app/
  layout.js
  page.js
  components/
  lib/
  styles/
public/
`;

// Additional instructions
const additionalInstructions = `
1. Use TypeScript for type safety
2. Implement proper metadata for SEO
3. Utilize Next.js Image component for optimized images
4. Use CSS Modules or Tailwind CSS for styling
5. Implement proper error boundaries
6. Follow Next.js naming conventions for special files
7. Use environment variables for configuration
`;




`🔄 **Context:** [Agent: Current] | [Skill: nextjs-app-router] | [Workflow: Current]`
