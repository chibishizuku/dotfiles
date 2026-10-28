
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh
eval "$(zoxide init zsh)"
source <(fzf --zsh)

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:$HOME/Android/Sdk/build-tools/34.0.0"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
export FZF_DEFAULT_OPTS=" \
--height=60% --layout=reverse --border=rounded \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"

export BAT_THEME="ansi"

alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons --group-directories-first'
alias ll='eza -lha --icons --sort=name --group-directories-first --git'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons --tree --level=2'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'

fv() {
    local f
    f=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}') && nvim "$f"
}

rgv() {
    local sel
    sel=$(rg --line-number --no-heading --color=always "${1:-.}" |
        fzf --ansi --delimiter : \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}-10') || return
    nvim "+$(cut -d: -f2 <<< "$sel")" "$(cut -d: -f1 <<< "$sel")"
}

fkill() {
    local pid
    pid=$(ps -eo pid,user,comm,args --sort=-%cpu | sed 1d | fzf --header 'kill process' | awk '{print $1}')
    [[ -n "$pid" ]] && kill "${1:--15}" "$pid"
}

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="$HOME/.cargo/bin:$PATH"
