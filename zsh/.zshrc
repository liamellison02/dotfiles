################################
####                        ####
####     shell configs      ####
####                        ####
################################

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"



################################
####                        ####
####    oh-my-zsh plugins   ####
####                        ####
################################
# installed by scripts/setup.sh into ~/.oh-my-zsh/custom/plugins/.
# zsh-syntax-highlighting has to stay LAST: it wraps the widgets every other
# plugin has already registered.

plugins=(
	git
	web-search
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# autojump setup (must add to plugins first ^^)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export EDITOR='nvim'



################################
####                        ####
####        aliases         ####
####                        ####
################################
# (more found in oh-my-zsh/custom/aliases.zsh)

sol() {
  rg -l -U "platform:\s*$1\s*\nid:\s*$2\b" "$HOME/git/dsa-solutions/problems"
}



################################
####                        ####
####   user env variables   ####
####                        ####
################################

export OPENAI_API_KEY="1234-56789-yo-momma-she-so-fine"
export prod_uri="mongodb://sikeyouthought:6769"



################################
####                        ####
####    n*de.js configs     ####
####                        ####
################################

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# uv (only exists once uv has been installed)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"



# keep here
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
