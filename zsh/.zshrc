# Starship prompt
eval "$(starship init zsh)"

# Disable bell
unsetopt BEEP

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt HIST_VERIFY

# Better completion
autoload -Uz compinit && compinit

# Arrow key history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias zshrc='nano ~/.zshrc'
alias reload='source ~/.zshrc'

. "$HOME/.cargo/env"
export EDITOR=nvim

export PATH=$PATH:/usr/local/go/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$HOME/.local/bin:$PATH"

export LS_COLORS="$(vivid generate one-dark)"
