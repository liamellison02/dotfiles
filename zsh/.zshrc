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
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	web-search
)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/bin:$PATH"
export EDITOR='nvim'



################################
####                        ####
####    oh-my-zsh plugins   ####
####                        ####
################################

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
)

# autojump setup (must add to plugins first ^^)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh



################################
####                        ####
####        aliases         ####
####                        ####
################################
# (more found in oh-my-zsh/custom/aliases.zsh)

sol() {
  rg -l -U "platform:\s*$1\s*\nid:\s*$2\b" "~/git/dsa-solutions/problems"
}


source $ZSH/oh-my-zsh.sh



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
export PNPM_HOME="~/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. "$HOME/.local/bin/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"



# keep here
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
