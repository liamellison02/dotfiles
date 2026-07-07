#!/usr/bin/env bash
# Notification hook: play a sound when Claude needs further input from the user.
# Kills any sound from the other hook first so they never overlap.

# Resolve this script's real directory even though it's invoked through a symlink
# (~/.claude/hooks -> this repo). Sounds live in a sibling sounds/ dir.
src="${BASH_SOURCE[0]}"
while [ -L "$src" ]; do
  dir="$(cd -P "$(dirname "$src")" && pwd)"
  src="$(readlink "$src")"
  [ "${src#/}" = "$src" ] && src="$dir/$src"
done
script_dir="$(cd -P "$(dirname "$src")" && pwd)"

pkill -f "afplay .*/(bomb-has-been-planted-sound-effect-cs-go|revive-me-jett-meme-valorant)\.mp3" 2>/dev/null

afplay "$script_dir/sounds/revive-me-jett-meme-valorant.mp3" &
exit 0
