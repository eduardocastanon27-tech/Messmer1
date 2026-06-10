# Messmer1 — Claude Code project template

A starter template that ships my personal Claude Code setup (the
**cogito-protocol** skill, user-level `CLAUDE.md`, and lessons ledger) into
every new repository, so remote Claude Code sessions start with the full
setup already in place.

## How to use it

1. On GitHub: **Settings → General → check "Template repository"** (one-time).
2. When creating a new repo, pick **"Use this template"** instead of starting
   empty. The new repo inherits everything below.

## What's inside

```
.claude/
├── settings.json              Registers the SessionStart hook
├── hooks/
│   └── session-start.sh       Re-seeds ~/.claude on every remote session start
└── home/                      Checked-in copies of personal ~/.claude files
    ├── CLAUDE.md              User-level instructions (lessons-capture behavior)
    └── skills/cogito-protocol/
        ├── SKILL.md           The cogito-protocol metacognitive skill
        └── LESSONS.md         Lessons ledger (SYMPTOM -> ROOT CAUSE -> RULE)
```

## Why the hook exists

Remote Claude Code sessions run in ephemeral containers: the home directory
(and with it `~/.claude`) is wiped between sessions, while the repo is cloned
fresh. The SessionStart hook copies `.claude/home/` back into `~/.claude` at
startup so personal skills and instructions survive:

- `SKILL.md` is **always overwritten** — the repo copy is the source of truth.
- `CLAUDE.md` and `LESSONS.md` are **only seeded if missing**, so anything
  appended during a session survives a resume within the same container.

The hook only runs when `CLAUDE_CODE_REMOTE=true`, so it never touches a
local machine's `~/.claude`.

## Keeping it current

Template copies are snapshots — repos created from this template won't pick
up later changes automatically. When the skill or lessons evolve:

1. Edit the files under `.claude/home/` **in this repo** (the canonical copy).
2. For active projects that should get the update, copy the changed files
   into that repo's `.claude/home/` and commit.
