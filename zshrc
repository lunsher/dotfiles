
. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion
source ~/.zsh/lscolors.zsh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc
