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

## Command cheat sheet

### Branch creation & daily flow

```bash
# Create a new branch and switch to it
git switch -c feature/my-thing

# Publish it to GitHub (first push only; plain `git push` after that)
git push -u origin feature/my-thing

# See where you are / what exists
git branch -a          # all branches, local + remote
git status             # current branch + pending changes

# Get back to main and bring it up to date
git switch main
git pull origin main

# Update your feature branch with the latest main
git switch feature/my-thing
git merge main

# Clean up after a branch is merged
git branch -d feature/my-thing             # delete local
git push origin --delete feature/my-thing  # delete remote
```

### Adding cogito to an old existing repo

This repo is public, so any repo can pull the `.claude/` setup from it:

```bash
# From inside the old repo, on a fresh branch
git switch -c add-cogito

# Grab the .claude folder from the template's main branch
git fetch https://github.com/eduardocastanon27-tech/Messmer1 main
git checkout FETCH_HEAD -- .claude

# Make the hook executable, then commit and push
chmod +x .claude/hooks/session-start.sh
git add .claude
git commit -m "Add cogito-protocol setup from Messmer1 template"
git push -u origin add-cogito
```

Then open a PR and merge.

**Cautions:**
- If the target repo already has a `.claude/settings.json` with its own
  hooks or permissions, the checkout above overwrites it — check with
  `ls .claude/` first and merge by hand if so.
- Repos with a richer session-start hook (npm install, env pulls) should
  keep their hook; only bring over `.claude/home/`.

## Zero-command phrasebook

Things to say to Claude Code instead of running commands yourself:

- **"Copy the .claude setup from my public Messmer1 repo into this repo, commit, and push."** — retrofits cogito into any old repo.
- **"Create a branch called X for this work and open a PR when you're done."** — full branch + PR flow.
- **"Merge PR #N and delete the branch."** — cleanup after review.
- **"Watch this PR and fix anything that comes up."** — Claude subscribes to PR activity and handles review comments / CI failures.
- **"Checkpoint."** — cogito-protocol writes a one-page state file (decisions, current state, open questions, corrections) into the project.
- **"Update the cogito skill in Messmer1: [describe the change], and merge it to main."** — evolves the canonical skill copy.
- **"Pull the latest .claude/home from Messmer1 into this repo."** — syncs an existing repo with skill updates.
- **"What lessons are in my LESSONS.md?"** / **"Add this lesson: ..."** — reads or appends to the lessons ledger.
- **"Set this repo up for Claude Code on the web."** — adds a session-start hook so remote sessions can install deps and run tests.
