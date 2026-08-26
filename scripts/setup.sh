#!/usr/bin/env bash
#
# setup.sh - bootstrap a fresh macOS machine into a fully configured dev environment.
#
# Idempotent: safe to re-run. Existing *real* files at a symlink target are backed up
# (renamed to <name>.bak.<timestamp>) before the symlink is created; existing symlinks
# are simply repointed.
#
# Usage:
#   # 1. install git (Xcode CLT) if you don't have it, or let this script trigger it
#   xcode-select --install
#   # 2. clone and run
#   git clone https://github.com/liamellison02/dotfiles ~/git/dotfiles
#   ~/git/dotfiles/scripts/setup.sh
#
set -euo pipefail

# Repo root = the parent of this script's dir (scripts/), resolved through any symlink.
DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m%s\n' "$*"; }

if [ "$(uname -s)" != "Darwin" ]; then
  warn "this script targets macOS only. exiting."
  exit 1
fi

# ---------------------------------------------------------------------------
# symlink helper
# ---------------------------------------------------------------------------
link() {
  local src="$1" dest="$2"
  if [ ! -e "$src" ]; then
    warn "source missing, skipping: $src"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    warn "backed up existing $dest -> $backup"
  fi
  ln -sfn "$src" "$dest"
  info "linked $dest -> $src"
}

# clone a third-party checkout once; never touched again on re-runs.
clone_once() {
  local repo="$1" dest="$2" name="$3"
  if [ ! -d "$dest" ]; then
    info "installing $name..."
    git clone --depth=1 "$repo" "$dest" || warn "clone of $name failed"
  fi
}

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools (git, compilers)
# ---------------------------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  info "installing Xcode Command Line Tools (accept the GUI prompt, then re-run)..."
  xcode-select --install || true
  warn "re-run this script once the Command Line Tools finish installing."
  exit 0
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# put brew on PATH for this session (Apple Silicon vs Intel)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
# Homebrew 5+ prompts "Do you want to proceed? [y/n]" before every install; this script
# has to run unattended, so opt out of ask-mode (and the post-install env hints).
export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_ENV_HINTS=1

# ---------------------------------------------------------------------------
# 3. formulae & casks
#    NOTE: no zsh here on purpose - macOS ships zsh 5.9 at /bin/zsh, which is what
#    step 9 sets as the login shell. A Homebrew zsh would just shadow it.
# ---------------------------------------------------------------------------
info "installing brew formulae..."
for f in git neovim; do
  brew list --formula "$f" >/dev/null 2>&1 || brew install "$f" || warn "brew install $f failed"
done

info "installing brew casks..."
for c in ghostty iterm2; do
  brew list --cask "$c" >/dev/null 2>&1 && continue
  # A cask install aborts if an app of that name is already in /Applications (e.g. ghostty
  # installed by hand from the binary download). That abort is harmless - it leaves the
  # existing app alone. Do NOT reach for --adopt to work around it: adoption shells out to
  # xattr, which trips over quarantine attributes, and brew's rollback then DELETES the
  # very app it was adopting.
  if ! brew install --cask "$c"; then
    warn "brew install --cask $c failed."
    warn "    if that is because an app of the same name is already in /Applications,"
    warn "    quit it and delete it, then re-run this script to let brew manage it."
  fi
done

# ---------------------------------------------------------------------------
# 4. oh-my-zsh (unattended: don't switch shell or overwrite .zshrc here)
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------------------------------------------------------------------------
# 5. dotfile symlinks
#    (done before cloning plugins/themes, so the custom dir points at the repo first)
# ---------------------------------------------------------------------------
info "linking dotfiles..."
link "$DOTFILES/zsh/.zshrc"              "$HOME/.zshrc"
link "$DOTFILES/zsh/.p10k.zsh"           "$HOME/.p10k.zsh"
link "$DOTFILES/oh-my-zsh/custom"        "$HOME/.oh-my-zsh/custom"
link "$DOTFILES/nvim"                    "$HOME/.config/nvim"
link "$DOTFILES/ghostty/config"          "$HOME/.config/ghostty/config"
link "$DOTFILES/ghostty/themes"          "$HOME/.config/ghostty/themes"
link "$DOTFILES/claude/CLAUDE.md"        "$HOME/.claude/CLAUDE.md"
link "$DOTFILES/claude/keybindings.json" "$HOME/.claude/keybindings.json"
link "$DOTFILES/claude/hooks"            "$HOME/.claude/hooks"

# ~/.claude/settings.json is deliberately NOT tracked or symlinked: it accumulates
# per-machine plugin + permission state, and linking it would feed that straight into
# the daily auto-sync commits. Seed it from the example once, then it's yours to edit.
if [ ! -e "$HOME/.claude/settings.json" ]; then
  mkdir -p "$HOME/.claude"
  cp "$DOTFILES/claude/settings.example.json" "$HOME/.claude/settings.json"
  info "seeded $HOME/.claude/settings.json from claude/settings.example.json"
fi

# ---------------------------------------------------------------------------
# 6. oh-my-zsh plugins + powerlevel10k
#    These land inside the repo via the symlinked custom dir, so all three are
#    gitignored - they're third-party checkouts, not part of these dotfiles.
# ---------------------------------------------------------------------------
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
clone_once https://github.com/zsh-users/zsh-autosuggestions.git \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" "zsh-autosuggestions"
clone_once https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"
clone_once https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k" "powerlevel10k"

# ---------------------------------------------------------------------------
# 7. Claude Code
# ---------------------------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  info "installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || warn "claude install failed"
fi

# ---------------------------------------------------------------------------
# 8. iterm2: load preferences from the repo folder
# ---------------------------------------------------------------------------
if [ -d "$DOTFILES/iterm2" ]; then
  info "pointing iterm2 at $DOTFILES/iterm2..."
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

# ---------------------------------------------------------------------------
# 9. default shell -> the zsh macOS ships
#    Hardcoded to /bin/zsh rather than "$(command -v zsh)": PATH resolution would pick
#    up a Homebrew zsh if one were ever installed. /bin/zsh is always present and is
#    already listed in /etc/shells, so this needs no sudo.
# ---------------------------------------------------------------------------
ZSH_PATH="/bin/zsh"
# $SHELL is inherited from whatever launched this script and goes stale, so read the
# login shell straight from the directory service.
LOGIN_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
if [ "$LOGIN_SHELL" != "$ZSH_PATH" ]; then
  info "setting default shell to $ZSH_PATH (currently ${LOGIN_SHELL:-unknown})..."
  chsh -s "$ZSH_PATH" || warn "chsh failed; set it by hand with: chsh -s $ZSH_PATH"
fi

# ---------------------------------------------------------------------------
# 10. daily auto-sync LaunchAgent (commit & push dotfile changes)
#     launchd runs the job at SYNC_HOUR:SYNC_MINUTE local time, and - unlike cron -
#     runs any missed occurrence on the next wake if the Mac was asleep/off.
# ---------------------------------------------------------------------------
SYNC_HOUR=13     # 24h local time
SYNC_MINUTE=0
LABEL="com.liamellison.dotfiles-sync"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
info "installing daily auto-sync LaunchAgent ($LABEL)..."
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.local/state"
cat >"$PLIST" <<PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$DOTFILES/scripts/sync.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>$SYNC_HOUR</integer>
        <key>Minute</key>
        <integer>$SYNC_MINUTE</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$HOME/.local/state/dotfiles-sync.out.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.local/state/dotfiles-sync.err.log</string>
</dict>
</plist>
PLIST_EOF
# reload so re-running setup.sh picks up any changes to the schedule
launchctl unload "$PLIST" 2>/dev/null || true
if launchctl load "$PLIST"; then
  info "auto-sync scheduled daily at $(printf '%02d:%02d' "$SYNC_HOUR" "$SYNC_MINUTE") (logs: ~/.local/state/dotfiles-sync.log)"
else
  warn "launchctl load failed; auto-sync not scheduled"
fi

info "done. open a new terminal (or run: exec zsh) to load everything."
warn "settings.local.json is intentionally machine-local - recreate any per-machine"
warn "Claude Code permission rules there by hand; it is not tracked in this repo."
warn "auto-sync pushes over HTTPS headlessly: run 'git -C \"$DOTFILES\" push' once by"
warn "hand first so the credential is cached in the macOS keychain (or use an SSH remote)."
