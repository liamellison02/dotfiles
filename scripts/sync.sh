#!/usr/bin/env bash
#
# sync.sh - commit & push any local dotfile changes. Run daily by a LaunchAgent
# (installed by setup.sh), and safe to run by hand anytime. Does nothing when the
# working tree is clean, so it never creates empty commits.
#
set -euo pipefail

# Repo root = the parent of this script's dir (scripts/), resolved through any symlink.
DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# launchd hands scripts a minimal environment, so put git (CLT + Homebrew) on PATH.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

LOG="$HOME/.local/state/dotfiles-sync.log"
mkdir -p "$(dirname "$LOG")"
log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG"; }

cd "$DOTFILES"

# sanity: is this a git repo with an origin?
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  log "not a git repo: $DOTFILES"; exit 1
fi
if ! git remote get-url origin >/dev/null 2>&1; then
  log "no 'origin' remote configured"; exit 1
fi

# nothing to do if the tree is clean
if [ -z "$(git status --porcelain)" ]; then
  log "clean tree; nothing to sync"
  exit 0
fi

log "changes detected, syncing..."
git add -A

# commit (solo-authored, no co-author trailer - see ~/.claude/CLAUDE.md policy)
if git commit -m "chore: auto-sync dotfiles $(date '+%Y-%m-%d %H:%M')" >>"$LOG" 2>&1; then
  log "committed"
else
  log "commit produced no change; skipping push"
  exit 0
fi

branch="$(git rev-parse --abbrev-ref HEAD)"
if git push origin "$branch" >>"$LOG" 2>&1; then
  log "pushed $branch -> origin"
else
  log "PUSH FAILED - is a credential cached for origin? (see README auto-sync note)"
  exit 1
fi
