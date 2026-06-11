#!/bin/bash
set -euo pipefail

# Only run in remote Claude Code environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Restore personal ~/.claude files (skills + user CLAUDE.md) on every session
# start, since the container's home dir is ephemeral.
#
# Seed preference order:
#   1. Live: shallow-clone the public Messmer1 template repo so updates made
#      there reach every project immediately, without re-syncing snapshots.
#   2. Fallback: the snapshot checked into this repo's .claude/home/ (covers
#      offline containers and network policies that block github.com).
# When this repo IS the template, the local checkout is already the live copy.
TEMPLATE_URL="https://github.com/eduardocastanon27-tech/Messmer1"
HOME_SEED="$PROJECT_DIR/.claude/home"

origin=$(git -C "$PROJECT_DIR" remote get-url origin 2>/dev/null || true)
case "$origin" in
  *[Mm]essmer1*) ;;  # already the template; local copy is canonical
  *)
    TMP_CLONE=$(mktemp -d)
    trap 'rm -rf "$TMP_CLONE"' EXIT
    if timeout 30 git clone --quiet --depth 1 "$TEMPLATE_URL" "$TMP_CLONE/template" 2>/dev/null \
       && [ -d "$TMP_CLONE/template/.claude/home" ]; then
      HOME_SEED="$TMP_CLONE/template/.claude/home"
      echo "==> Seeding ~/.claude from live Messmer1 template" >&2
    else
      echo "==> Live template unreachable; using local .claude/home snapshot" >&2
    fi
    ;;
esac

# SKILL.md files are overwritten (template is their source of truth);
# CLAUDE.md and LESSONS.md are only seeded if missing so in-session
# appends survive resumes.
if [ -d "$HOME_SEED" ]; then
  echo "==> Restoring ~/.claude from $HOME_SEED..." >&2
  for skill_dir in "$HOME_SEED"/skills/*/; do
    name=$(basename "$skill_dir")
    mkdir -p "$HOME/.claude/skills/$name"
    cp "$skill_dir/SKILL.md" "$HOME/.claude/skills/$name/SKILL.md"
  done
  [ -f "$HOME/.claude/CLAUDE.md" ] || cp "$HOME_SEED/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  [ -f "$HOME/.claude/skills/cogito-protocol/LESSONS.md" ] || cp "$HOME_SEED/skills/cogito-protocol/LESSONS.md" "$HOME/.claude/skills/cogito-protocol/LESSONS.md"
fi
