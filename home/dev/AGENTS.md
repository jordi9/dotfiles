# AGENTS.md — ~/dev

This directory is a workspace containing multiple independent repositories. It is **not** a single monorepo.

Use this file as a quick reference for active projects when an agent is launched from `~/dev`.

## Active projects

| Project | Path | Notes |
| --- | --- | --- |
| Dos Comas | `./doscomas/` | Polyglot product monorepo: React web app and Kotlin/Ktor API. |
| Dos Comas site | `./doscomas-site/` | Public Astro site / marketing website. |
| Industries | `./jordi9-industries/` | Indie hacker strategy and decisions. |

Other projects under `~/dev` should also follow this file's instructions.

## Guidance for agents

- Treat each listed path as a separate project/repository.
- Do not assume dependencies, scripts, or git history are shared between the listed repositories.
- Before changing files inside a project, check whether that project has its own `AGENTS.md` and follow it.
- Run commands from the target project directory unless explicitly asked to work across multiple projects.
- Avoid broad destructive commands from `~/dev`.
- NEVER make changes in a backwards compatible way if you've not been asked to. Don't guess, always ask the user.
- Use explorer when you need to understand code or repository to avoid context creep
