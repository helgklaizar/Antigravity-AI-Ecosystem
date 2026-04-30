# ADR: Refactoring AntigravityBar Architecture (Swift UI + Daemon)

## Context
AntigravityBar (Swift macOS app) is taking on too much responsibility. It currently handles UI, parsing of workflows, news tracking, and state management. This makes the Swift codebase fragile, hard to maintain, and slow to update.

## Decision
We will decouple the logic from the presentation layer:
1. **AntigravityBar (Swift)**: Becomes a "dumb" UI layer. It only renders the menu bar, buttons, and system metrics. It connects to a local daemon via XPC, WebSockets, or a local REST API (e.g., `localhost:49100`).
2. **Antigravity Daemon (Rust/Go or Node.js/PM2)**: A headless background process that handles:
   - Parsing AI News from Telegram.
   - Tracking workflow usage logs.
   - Reading/Writing to `~/.gemini/antigravity/brain/swarm.db`.
   - Managing dynamic skill fetching.

## Next Steps
1. Create a `daemon/` directory inside `AI-Ecosystem/`.
2. Select the stack for the daemon (Rust with `axum` or Go with `gin` are recommended for low footprint).
3. Update `WorkflowTracker.swift` to drop local file-parsing logic and instead make an HTTP GET to the daemon.
