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

- Treat each listed path as a separate project/repository. Within `./doscomas/`, the web app and API share one repository, workspace, and VCS history.
- Do not assume dependencies, scripts, or git history are shared between the listed repositories.
- Before changing files inside a project, check whether that project has its own `AGENTS.md` and follow it.
- Run commands from the target project directory unless explicitly asked to work across multiple projects.
- Avoid broad destructive commands from `~/dev`.
- NEVER make changes in a backwards compatible way if you don't know. Don't guess, always ask the user.
- Use subagent Explore when you need to understand code or repository to avoid context creep

## Dos Comas sessions

Start Dos Comas product implementation sessions in `./doscomas/`. Its `apps/web/` area owns the user-facing verification seam, while `services/api/` owns backend, domain, persistence, and API-contract work. Cross-stack changes belong in one monorepo workspace, jj change, and pull request; read the root and relevant scoped `AGENTS.md` files first.

Start in `./doscomas-site/` for public-site or marketing implementation. Start in `./jordi9-industries/` only for strategy or product-direction decisions.

Do not start implementation sessions from `~/dev` unless explicitly coordinating across repositories. If a session launched from `~/dev` needs to edit code, first choose the target repository and follow its guidance.

