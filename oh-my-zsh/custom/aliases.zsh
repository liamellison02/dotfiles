################################
#####                      #####
#####     core helpers     #####
#####                      #####
################################

alias ali="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias aliases="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias nv="nvim"
alias vsh="nvim ~/.zshrc"
alias src="source ~/.zshrc"


################################
#####                      #####
#####       dir nav        #####
#####                      #####
################################

alias cdg="cd ~/git/"
alias xx="cd ~/scratch/ && nvim"
alias ml="cd ~/git/mlcpp/"
alias dsa="cd ~/git/dsa-solutions/"


################################
#####                      #####
#####     don't            #####
#####     abbreviate       #####
#####     competitive      #####
#####     programming      #####
#####                      #####
################################

alias dsa="cd ~/git/dsa-solutions/"
alias lc='sed -n 30,69p ~/git/dsa-solutions/templates/lc.cpp | pbcopy'
alias cpp="clang++ -std=c++20 -O2"


################################
#####                      #####
#####        git           #####
#####        push          #####
#####        git           #####
#####        paid          #####
#####                      #####
################################

alias gcm="git commit -m"
alias ga="git add"
alias gp="git push"
alias gpf="git push --force"
alias gpl="git pull"
alias gsc="git switch -c"
alias gsw="git switch"
alias gdh="git diff HEAD"
alias gs="git status"
alias gb="git branch"
alias grs="git restore --staged"
alias gca="git commit --amend --no-edit"
alias sync="git add . && git commit 'sync' && git push"


################################
#####                      #####
#####       kubectl        #####
#####                      #####
################################

alias k="kubectl"
alias kl="kubectl logs"
alias kgj="kubectl get jobs"
alias kgjn="kubectl get jobs -n"
alias kgp="kubectl get pods"
alias kgpn="kubectl get pods -n"
alias kdj="kubectl describe jobs"
alias kdjn="kubectl describe jobs -n"
alias kdp="kubectl describe pods"
alias kdpn="kubectl describe pods -n"



