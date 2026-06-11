#!/bin/bash
set -euo pipefail

# Only run in remote Claude Code environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Restore personal ~/.claude files (cogito-protocol skill + user CLAUDE.md)
# from the copies checked into .claude/home/. The container's home dir is
# ephemeral, so these must be re-seeded on every session start.
# SKILL.md is overwritten (repo is its source of truth); CLAUDE.md and
# LESSONS.md are only seeded if missing so in-session appends survive resumes.
HOME_SEED="$PROJECT_DIR/.claude/home"
if [ -d "$HOME_SEED" ]; then
  echo "==> Restoring ~/.claude from .claude/home/..." >&2
  for skill_dir in "$HOME_SEED"/skills/*/; do
    name=$(basename "$skill_dir")
    mkdir -p "$HOME/.claude/skills/$name"
    cp "$skill_dir/SKILL.md" "$HOME/.claude/skills/$name/SKILL.md"
  done
  [ -f "$HOME/.claude/CLAUDE.md" ] || cp "$HOME_SEED/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  [ -f "$HOME/.claude/skills/cogito-protocol/LESSONS.md" ] || cp "$HOME_SEED/skills/cogito-protocol/LESSONS.md" "$HOME/.claude/skills/cogito-protocol/LESSONS.md"
fi
