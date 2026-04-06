# Perf enhancements
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
ZSH_DISABLE_COMPFIX=true
skip_global_compinit=1

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Completions (cached)
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
mkdir -p ~/.zsh/cache 2>/dev/null
autoload -Uz compinit
compinit -C

# Environment
export PATH="/opt/homebrew/bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:$HOME/go/bin:$PATH"

# Lazy-load pyenv
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

  function pyenv {
    unset -f pyenv
    eval "$(command pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv "$@"
  }
fi

# Aliases
alias vim="nvim"
alias a="alias | grep"
alias keymaps='vim $HOME/dotfiles/nvim/.config/nvim/lua/serge/keymaps.lua'
alias zshrc='vim ~/.zshrc'

alias t="tmux"
alias tls="tmux ls"
alias ta="tmux attach -t"
alias tk="tmux kill-session -t"

# Functions
copy() { tee /dev/tty | pbcopy }

tn() {
    tmux new -A -s "$(basename "$PWD")"
}

ws() {
    if [[ "$1" == "." ]]; then
        cd "$HOME/Workspace"
    else
        local dir
        dir=$(ls "$HOME/Workspace" | fzf --exact --query="${1:-}" --select-1 --exit-0) && cd "$HOME/Workspace/$dir"
    fi
}

_ws() {
    local dirs=("$HOME/Workspace"/*(/:t))
    compadd -a dirs
}
compdef _ws ws

syncmain() {
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout main && git pull origin main && git branch -d "$current_branch"
}

todoinit() {
  if [[ ! -d .git ]]; then
    echo "❌ Not a git repo"
    return 1
  fi

  local file="TODO.md"
  local exclude=".git/info/exclude"

  if [[ ! -f $file ]]; then
    echo "# TODO" > "$file"
    echo "✅ Created $file"
  else
    echo "ℹ️ $file already exists"
  fi

  mkdir -p .git/info
  touch "$exclude"
  if ! grep -qx "$file" "$exclude"; then
    echo "$file" >> "$exclude"
    echo "✅ Added $file to local exclude"
  else
    echo "ℹ️ $file already excluded"
  fi
}

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Crosby
# Pytest with loud stdout, good for using tests as print debugging
alias ptt='pytest -rP --capture=sys --show-capture=stdout --no-cov -vv'

# Pytest run all tests without coverage, fastest way to run a directory
alias pta='pytest --capture=sys --show-capture=stdout --no-cov'

# Pytest with loud stdout but only for failing tests
alias ptx='pytest -rx --capture=sys --show-capture=stdout --no-cov -vv'

alias activate='source .venv/bin/activate'
#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###
