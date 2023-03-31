#!/usr/bin/env zsh

EDITOR=nvim
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.0.4.1.jdk/Contents/Home
## Declare local variables
#DOOM_HOME=/Users/imarmole/doom-emacs/doom
#BOSS_HOME=/Users/imarmole/Software/boss-tools
BOSS_HOME=/Users/imarmole/boss-cli
MAVEN_HOME=/usr/local/Cellar/maven/3.8.4

## Export statements
export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
export PATH=/usr/local/bin:$PATH:$BOSS_HOME/bin:$HOME/bin:$HOME/emacs-doom/.emacs.d/bin
export EDITOR=vim
export JDTLS_HOME=$HOME/lsp/Java/jdtls
export WORKSPACE=$HOME/lsp/workspace
export XDG_CONFIG_HOME=$HOME/.config
export DOOMDIR=$HOME/emacs-doom/config
export FACP_SSH_HOME=$HOME/DevProjects/scripts/faaas_ssh_configs

## Aliases
alias ll='ls -ltrhGF'
alias lla='ls -altrhGF'
alias cfgz='vim $ZDOTDIR/.zshrc'
alias cfgzm='f() { vim $ZDOTDIR/plugins/zsh-$1 };f' # Alterantively can be move to a function in functions plugin
alias cfgzp='f() { vim $ZDOTDIR/plugins/zsh-$1 };f' # Alterantively can be move to a function in functions plugin
alias brew_fix_link='sudo chown -R $(whoami) $(brew --prefix)/*'
alias emacsc='emacsclient -c'
alias emacs_ide="/usr/local/Cellar/emacs-plus@28/28.0.50/bin/emacs --with-profile ide"
alias emacs_test="/usr/local/Cellar/emacs-plus@28/28.0.50/bin/emacs --with-profile test"
alias docker=podman
alias doom_emacs="emacs --with-profile doom-ide"
alias vi="nvim"
alias v="nvim"
alias sopen='fd | fzf-tmux -p | xargs $EDITOR'
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lcfg='lazygit --git-dir=$HOME/.cfg --work-tree=$HOME'

# source $FACP_SSH_HOME/aliases
