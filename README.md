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

---

## tools

### zsh

**macOS:** included by default. **linux:**

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

### neofetch

```sh
brew install neofetch
```

```sh
mkdir -p ~/.config/neofetch
ln -sf ~/git/dotfiles/neofetch/config.conf ~/.config/neofetch/config.conf
```

---

## symlink map

| dotfile location | repo path |
|---|---|
| `~/.zshrc` | `zsh/.zshrc` |
| `~/.p10k.zsh` | `zsh/.p10k.zsh` |
| `~/.oh-my-zsh/custom` | `oh-my-zsh/custom/` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.config/ghostty/themes` | `ghostty/themes/` |
| `~/.config/neofetch/config.conf` | `neofetch/config.conf` |
| iterm2 preferences dir | `iterm2/` (via iterm2 settings, not a symlink) |
