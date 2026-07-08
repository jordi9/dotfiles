# AGENTS.md — ~/dev

This directory is a workspace containing multiple independent repositories. It is **not** a single monorepo.

Use this file as a quick reference for active projects when an agent is launched from `~/dev`.

## Active projects

| Project | Path | Notes |
| --- | --- | --- |
| Dos Comas site | `./doscomas-site/` | Public Astro site / marketing website. |
| Dos Comas app | `./doscomas-app/` | SPA / product application. |
| Dos Comas API | `./doscomas-api/` | Backend/API service. |
| Industries | `./jordi9-industries/` | Indie hacker strategy, decisions. |

Other projects under ~/dev should also follow this file instructions.

## Guidance for agents

- Treat each listed path as a separate project/repository.
- Do not assume dependencies, scripts, or git history are shared across projects.
- Before changing files inside a project, check whether that project has its own `AGENTS.md` and follow it.
- Run commands from the target project directory unless explicitly asked to work across multiple projects.
- Avoid broad destructive commands from `~/dev`.
- NEVER make changes in a backwards compatible way if you don't know. Don't guess, always ask the user.
- Use subagent Explore when you need to understand code or repository to avoid context creep

## Cross-repo slice sessions

For Dos Comas end-to-end product slices, usually start the agent session in `./doscomas-app/`, because it owns the user-facing verification seam.

Start in `./doscomas-api/` when the slice is primarily backend/domain/API-contract work.
Start in `./jordi9-industries/` only for strategy or product-direction decisions.

Do not start implementation sessions from `~/dev` unless explicitly coordinating across repos. If a session launched from `~/dev` needs to edit code, first choose the target repo and follow that repo's guidance.

