#!/usr/bin/env zsh

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.0.4.1.jdk/Contents/Home
## Declare local variables
#DOOM_HOME=/Users/imarmole/doom-emacs/doom
#BOSS_HOME=/Users/imarmole/Software/boss-tools
BOSS_HOME=/Users/imarmole/boss-cli
MAVEN_HOME=/usr/local/Cellar/maven/3.8.4

## Export statements
export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
export PATH=/usr/local/bin:$PATH:$BOSS_HOME/bin:$HOME/bin
export EDITOR=nvim
export JDTLS_HOME=$HOME/lsp/Java/jdtls
export WORKSPACE=$HOME/lsp/workspace
export XDG_CONFIG_HOME=$HOME/.config
export DOOMDIR=$HOME/emacs-doom/config
export FACP_SSH_HOME=$HOME/DevProjects/scripts/faaas_ssh_configs

## Aliases
alias ll='ls -ltrhGF'
alias lla='ls -altrhGF'
alias docker=podman
alias vi="nvim"
alias v="nvim"
alias sopen='fd | fzf-tmux -p | xargs $EDITOR'
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lcfg='lazygit --git-dir=$HOME/.cfg --work-tree=$HOME'

# source $FACP_SSH_HOME/aliases
