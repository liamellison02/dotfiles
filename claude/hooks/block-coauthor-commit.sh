#!/usr/bin/env bash
# PreToolUse(Bash) guard: block any `git commit` that carries a co-author trailer.
# Liam Ellison must be the sole author of every commit (see ~/.claude/CLAUDE.md).
#
# Fires on every Bash call; only denies when the command is a git COMMIT that also
# contains "co-authored-by". History-rewrite/scrub commands (filter-branch,
# filter-repo, --msg-filter, rebase) are explicitly allowed so the trailer can be
# REMOVED. Non-git commands and trailer-free commits pass through untouched.

input=$(cat)

# Extract the command (jq, with a python fallback so the guard never silently no-ops).
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null) || cmd=""
if [ -z "$cmd" ]; then
  cmd=$(printf '%s' "$input" | python3 -c 'import sys,json
try: print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception: print("")' 2>/dev/null || printf '')
fi

if printf '%s' "$cmd" | grep -qiE 'co-authored-by' \
   && printf '%s' "$cmd" | grep -qE '\bgit\b' \
   && printf '%s' "$cmd" | grep -qE '\bcommit\b' \
   && ! printf '%s' "$cmd" | grep -qiE 'filter-branch|filter-repo|--msg-filter|rebase'; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked by global policy (~/.claude/CLAUDE.md): this git commit includes a Co-Authored-By trailer. Every commit must be solo-authored by Liam Ellison with no co-author. Remove the Co-Authored-By line from the commit message and retry."}}
JSON
fi
exit 0
