#!/usr/bin/env zsh

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.0.4.1.jdk/Contents/Home
## Declare local variables

## Export statements
export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
export PATH=/usr/local/bin:$PATH:$BOSS_HOME/bin:$HOME/bin
# export EDITOR=nvim
# export JDTLS_HOME=$HOME/lsp/Java/jdtls
# export WORKSPACE=$HOME/lsp/workspace
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
# export DOOMDIR=$HOME/emacs-doom/config
export FACP_SSH_HOME=$HOME/DevProjects/scripts/faaas_ssh_configs

## Aliases
alias ll='ls -ltrhGF'
alias lla='ls -altrhGF'
alias docker=podman
alias vi="nvim"
alias v="nvim"
alias vop='fd | fzf-tmux -p | xargs $EDITOR'
alias vo='fd | fzf-tmux | xargs $EDITOR'
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lcfg='lazygit --git-dir=$HOME/.cfg --work-tree=$HOME'

ls_alias=$(which eza)
if [ -x "$ls_alias" ]; then
  alias ll="eza -l --sort=time"
  alias lls="eza -l --sort=size"
  alias lla="eza -al --sort=time"
  alias tree="eza --tree"
fi

# source $FACP_SSH_HOME/aliases
