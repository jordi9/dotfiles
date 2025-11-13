---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Git commit with staged/unstaged changes
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Create a git commit with this structure:

### Commit Structure
- **Header**: Conventional commit type with description (max 72 characters)
- **Body paragraph**: Explain the motivation or problem being solved (the "why")
- **Bulleted list**: Specific changes made (the "what")

### Rules
- Use conventional commits format: `<type>[optional scope]: <description>`
- Always use present tense throughout
- Review all staged and unstaged changes with git diff
- Stage relevant files and create the commit
- Do NOT check PRs or GitHub
- Do NOT push the commit unless I ask you to
- Do NOT include metadata (file counts, test numbers, etc.)
- Do NOT add Claude signature to commits
- Show me the commit message when finished

## Format Example

```
<type>[optional scope]: <description>

[Paragraph explaining the motivation or problem being solved - the "why".
Write in one paragraph if possible.]

Changes:
- First specific change made
- Second specific change made
- Third specific change made

[optional footer(s)]
```
