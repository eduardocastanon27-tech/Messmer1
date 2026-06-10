# Lessons Ledger — raw entries, one line each: SYMPTOM -> ROOT CAUSE -> RULE

- "Can't delete the default branch" error on a throwaway work branch -> the first branch pushed to an empty GitHub repo becomes its default, regardless of configured default name -> when seeding an empty repo, establish `main` first (or switch default immediately) before pushing work branches. [pending: systems-thinking skill]
- Could not open the requested PR -> empty repo had no base branch, and PRs need a base sharing history with the head -> in a fresh repo, create a root commit on `main` and build branches on top of it before promising PRs. [pending: systems-thinking skill]

## ARCHIVE

### 2026-06-10 — folded into cogito-protocol SKILL.md
- git push --delete reported "Everything up-to-date" but the remote branch survived -> the session's git proxy silently drops ref deletions -> verify remote mutations with `git ls-remote`, never trust push output across a proxy. (→ §5 Solve vs. ask)
- Cross-repo copy of .claude setup was denied at both the MCP layer and the git proxy -> remote sessions are hard-scoped to the session's repos, so private sources are unreachable exactly when needed -> keep shared personal setup in a public template repo (or checked-in seed) that any session can fetch anonymously. (→ Core stance)
- This ledger stayed empty through four loggable events -> lessons were narrated in chat but never written to the file at the moment they occurred -> append to LESSONS.md the moment a lesson happens, not retrospectively at session end. (→ §4b)
