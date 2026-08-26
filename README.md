# dotfiles

personal dotfiles for macOS and linux.
each tool's config lives here and is symlinked from its standard location so edits in either place are to the same file.

## prerequisites

- [homebrew](https://brew.sh) (macOS and linux)
- [git](https://git-scm.com/install)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## setup

clone this repo to `~/git/dotfiles` (symlink commands below assume this path):

```sh
git clone https://github.com/liamellison02/dotfiles ~/git/dotfiles
```

### automated (recommended)

`scripts/setup.sh` takes a brand-new macOS machine from nothing to fully dev-ready: it
installs homebrew, the CLI tools, oh-my-zsh + its plugins + powerlevel10k, and Claude Code,
then creates every symlink below, points iterm2 at the repo, and schedules a daily
auto-sync (see [auto-sync](#auto-sync)). it's idempotent - safe to re-run, and it backs up
any existing real files before replacing them with symlinks. it deliberately leaves the
login shell as macOS's own `/bin/zsh`.

```sh
# git is needed to clone; install Xcode Command Line Tools first if you don't have it
xcode-select --install
git clone https://github.com/liamellison02/dotfiles ~/git/dotfiles
~/git/dotfiles/scripts/setup.sh
```

then open a new terminal (or `exec zsh`). the per-tool steps below document what the
script automates, in case you'd rather set things up by hand.

---

## tools

### zsh

**macOS:** already there - macOS ships zsh 5.9 at `/bin/zsh`. Do *not* `brew install zsh`;
a Homebrew build just shadows the system one and buys you nothing. If zsh somehow isn't
your login shell:

```sh
chsh -s /bin/zsh
```

**linux:**

```sh
brew install zsh
chsh -s $(which zsh)
```

symlink `.zshrc`:

```sh
ln -sf ~/git/dotfiles/zsh/.zshrc ~/.zshrc
```

---

### oh-my-zsh

install:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

the installer creates `~/.oh-my-zsh/custom/`. replace it with the repo's version:

```sh
rm -rf ~/.oh-my-zsh/custom
ln -sf ~/git/dotfiles/oh-my-zsh/custom ~/.oh-my-zsh/custom
```

---

### zsh plugins

`.zshrc` enables `zsh-autosuggestions` and `zsh-syntax-highlighting`, which aren't bundled
with oh-my-zsh - clone them into the custom dir or every new shell prints
`plugin '...' not found`:

```sh
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

both are gitignored - they're third-party checkouts that happen to land inside the repo
via the symlinked custom dir. keep `zsh-syntax-highlighting` last in the `plugins=()`
array; it wraps the widgets every other plugin has already registered.

---

### powerlevel10k

install the theme into oh-my-zsh:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

symlink the config:

```sh
ln -sf ~/git/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
```

reload your shell. p10k reads `~/.p10k.zsh` on startup - no further configuration needed.

---

### neovim

```sh
brew install neovim
```

symlink config:

```sh
ln -sf ~/git/dotfiles/nvim ~/.config/nvim
```

this config uses [LazyVim](https://lazyvim.github.io). plugins install automatically on first launch.

---

### ghostty

**macOS:**

1. (recommended) download via binary: [ghostty.org](https://ghostty.org/download)

OR

2.
```sh
brew install --cask ghostty
```

**linux:** see [ghostty.org](https://ghostty.org/docs/install/binary) for distro-specific packages.

ghostty reads from `~/.config/ghostty/config`.
symlink the file (not the directory, to preserve the `themes/` subdir structure):

```sh
mkdir -p ~/.config/ghostty
ln -sf ~/git/dotfiles/ghostty/config ~/.config/ghostty/config
ln -sf ~/git/dotfiles/ghostty/themes ~/.config/ghostty/themes
```

---

### iterm2 (macOS only)

```sh
brew install --cask iterm2
```

iterm2 can load its full preferences from a custom directory.
after installing:

1. open iterm2
2. go to **settings > general > preferences**
3. check **"load preferences from a custom folder or URL"**
4. set the path to `~/git/dotfiles/iterm2`
5. click **"save current settings to folder"** when prompted

from that point on, iterm2 reads and writes preferences directly to `~/git/dotfiles/iterm2/com.googlecode.iterm2.plist`.

---

### claude code

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

`~/.claude/` is mostly local state (sessions, cache, telemetry) that shouldn't be synced. only the portable config files are symlinked in - `settings.local.json` stays machine-local and untracked, since it holds per-machine permission rules.

```sh
ln -sf ~/git/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/git/dotfiles/claude/keybindings.json ~/.claude/keybindings.json
ln -sfn ~/git/dotfiles/claude/hooks ~/.claude/hooks
```

`settings.json` is **copied, not symlinked** - it accumulates per-machine plugin and
permission state, so linking it would push that into the daily auto-sync commits. seed it
once from the tracked example (`setup.sh` does this for you) and edit your copy freely:

```sh
cp -n ~/git/dotfiles/claude/settings.example.json ~/.claude/settings.json
```

the `hooks/` dir includes two `Stop`/`Notification` sound hooks and their `.mp3` files
(bundled in `claude/hooks/sounds/`), so they travel with the repo - no re-downloading.
the hook scripts resolve their own location, so the sounds play regardless of where the
repo is cloned. `afplay` (macOS built-in) is used to play them.

---

## symlink map

| dotfile location | repo path |
|---|---|
| `~/.zshrc` | `zsh/.zshrc` |
| `~/.p10k.zsh` | `zsh/.p10k.zsh` |
| `~/.oh-my-zsh/custom` | `oh-my-zsh/custom/` |
| `~/.oh-my-zsh/custom/plugins/` | third-party clones (gitignored) |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.config/ghostty/themes` | `ghostty/themes/` |
| iterm2 preferences dir | `iterm2/` (via iterm2 settings, not a symlink) |
| `~/.claude/settings.json` | `claude/settings.example.json` (copied once, not symlinked) |
| `~/.claude/CLAUDE.md` | `claude/CLAUDE.md` |
| `~/.claude/keybindings.json` | `claude/keybindings.json` |
| `~/.claude/hooks` | `claude/hooks/` (incl. bundled `sounds/`) |

---

## auto-sync

`scripts/setup.sh` installs a macOS **LaunchAgent** (`com.liamellison.dotfiles-sync`) that
runs `scripts/sync.sh` once a day. `sync.sh` stages everything, commits with a dated
message, and pushes - but only when there's something to commit, so it never makes empty
commits. if the Mac is asleep at the scheduled time, launchd runs the missed job on next
wake (cron would just skip it).

- **schedule:** daily at 13:00 local. change `SYNC_HOUR` / `SYNC_MINUTE` near the bottom
  of `scripts/setup.sh` and re-run it to reschedule.
- **logs:** `~/.local/state/dotfiles-sync.log` (plus `dotfiles-sync.{out,err}.log`).
- **run it now:** `~/git/dotfiles/scripts/sync.sh`
- **credentials:** the push runs headlessly, so it can't prompt for a password. do one
  manual `git -C ~/git/dotfiles push` first to cache the credential in the macOS keychain,
  or switch the remote to SSH (`git remote set-url origin git@github.com:...`).
- **disable:** `launchctl unload ~/Library/LaunchAgents/com.liamellison.dotfiles-sync.plist`
  (then delete the plist to make it permanent).
