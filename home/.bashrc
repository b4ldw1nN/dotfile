export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# Migrated from Fish — ~/.config/fish/config.fish + fish_variables + w.fish
# =============================================================================

# --- Deduplicated PATH helper (like fish_add_path) ---
_add_path() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$PATH:$1" ;;
    esac
}
_prepend_path() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$1:$PATH" ;;
    esac
}

# --- Environment (from fish config + fish_variables) ---
export EDITOR="code"
export VISUAL="code"
export BROWSER="firefox"

export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export ANDROID_HOME="/home/zoro/Android/Sdk"
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

# API / AI tools
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export CLAUDE_CODE_SKIP_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS=1

# fzf integration (from fish)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=1 {}'"

# Clipboard server (from fish) — async to not block startup (was 15ms sync)
export CLIPBOARD_SERVER_HOST=""
if command -v tailscale &>/dev/null; then
    # Populate in background; cache for instant next shell
    ( CLIPBOARD_SERVER_HOST="$(tailscale ip -4 2>/dev/null | head -n1)"; export CLIPBOARD_SERVER_HOST; echo "$CLIPBOARD_SERVER_HOST" > /tmp/.clipboard_host_cache 2>/dev/null ) & disown 2>/dev/null
    # Use cache if available for instant value
    [[ -f /tmp/.clipboard_host_cache ]] && export CLIPBOARD_SERVER_HOST="$(cat /tmp/.clipboard_host_cache 2>/dev/null)"
fi

# --- PATH (fish_user_paths + fish_add_path merged, deduplicated) ---
# fish_user_paths: go/bin, .opencode/bin, .local/bin, .cargo/bin, .bun/bin, pnpm, npm-global, brew, cuda, jvm
# + w.fish extras: .spicetify, .lmstudio/bin, .kimi-code/bin
_add_path "$HOME/go/bin"
_add_path "$HOME/.opencode/bin"
_add_path "$HOME/.cargo/bin"
_add_path "$BUN_INSTALL/bin"
_add_path "$PNPM_HOME"
_add_path "$HOME/.npm-global/bin"
_add_path "$HOME/.kimi-code/bin"
_add_path "$HOME/.spicetify"
_add_path "$HOME/.lmstudio/bin"
_add_path "/opt/brew/bin"
_add_path "/opt/cuda/bin"
_add_path "/usr/lib/jvm/default/bin"
_add_path "$HOME/bin"
_add_path "$HOME/.local/dart-sdk/bin"
_add_path "$ANDROID_HOME/emulator"
_add_path "$ANDROID_HOME/platform-tools"
_add_path "$ANDROID_HOME/tools"

# Ensure cargo env (rustup) — same as fish conf.d/rustup.fish + .cargo/env
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Hyprshell dynamic colors
if [ -f "$HOME/.config/hyprshell/colors.sh" ]; then
    source "$HOME/.config/hyprshell/colors.sh"
elif [ -f "$HOME/.config/hypr/hyprshell/colors.sh" ]; then
    source "$HOME/.config/hypr/hyprshell/colors.sh"
fi

# --- Interactive only ---
if [[ $- == *i* ]]; then
    # Synchronize Foot terminal palette to hyprshell wallpaper colors
    if [[ "$TERM" == foot* || -n "$FOOT_TERMINAL" ]]; then
        printf "\033]10;%s\007\033]11;%s\007" "${FOREGROUND:-#f0f3f8}" "${TERMINAL_BG:-$BACKGROUND}"
    fi

    # History
    export HISTCONTROL=ignoredups:erasedups
    shopt -s histappend

    # Fix Fish→bash annoyances: no ! history expansion, no cut long lines
    set +H 2>/dev/null  # disable ! history expansion (fixes EOF: history expansion failed)
    shopt -s checkwinsize 2>/dev/null  # update COLUMNS on resize (fixes long line wrap)
    shopt -s globstar 2>/dev/null  # enable ** for recursive globbing
    shopt -s cdspell 2>/dev/null  # auto-correct minor spelling errors in cd

    # Bash completion
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    # blesh — Fish-like autosuggestions (ghost text) + syntax highlighting + auto-completion
    # Must be loaded first. Provides ghost text (history-based) with → to accept, Fish-like highlighting.
    if [[ -f /usr/share/blesh/ble.sh ]]; then
        source /usr/share/blesh/ble.sh --attach=none
    fi

    # Starship (fish: starship init fish | source)
    if command -v starship &>/dev/null; then
        eval "$(starship init bash)"
    fi

    # zoxide (fish: zoxide init fish | source + alias cd=z)
    if command -v zoxide &>/dev/null; then
        eval "$(zoxide init bash)"
        # zoxide already provides 'z' and 'zi'; complete alias handled automatically
    fi

    # fzf (fish: fzf --fish | source)
    if command -v fzf &>/dev/null; then
        # fzf 0.48+ uses --bash
        if fzf --bash &>/dev/null 2>&1; then
            eval "$(fzf --bash 2>/dev/null)"
        elif [ -f ~/.fzf.bash ]; then
            source ~/.fzf.bash
        fi
    fi

    # fnm (fish: fnm env --use-on-cd | source)
    if command -v fnm &>/dev/null; then
        eval "$(fnm env --use-on-cd --shell bash)"
    fi

    # thefuck — lazy load to save ~150ms on startup
    if command -v thefuck &>/dev/null; then
        fuck() {
            unset -f fuck 2>/dev/null
            eval "$(thefuck --alias)"
            if type fuck &>/dev/null; then
                fuck "$@"
            else
                command thefuck "$@"
            fi
        }
    fi

    # fastfetch — removed per user request (was async 13ms, now disabled for instant prompt)
    # Use `fast` alias to run manually: fastfetch -c ~/.config/fastfetch/config-compact.jsonc

    # Fix bracketed paste — stops ^[[200~ raw escape on paste
    bind 'set enable-bracketed-paste on' 2>/dev/null
    # Ensure long lines wrap properly instead of scrolling horizontally
    bind 'set horizontal-scroll-mode off' 2>/dev/null

    # atuin — better history (Ctrl+R) + daemon for fast fuzzy search
    if command -v atuin &>/dev/null; then
        eval "$(atuin init bash)"
    fi

    # carapace — smart Tab completions for yay/docker/cargo etc (needs yay -S carapace)
    if command -v carapace &>/dev/null; then
        source <(carapace _carapace)
    fi

    # blesh attach — must be last in interactive block
    [[ ${BLE_VERSION-} ]] && ble-attach
    # Disable blesh MULTILINE (RET inserts newline) — make Enter always run
    if [[ ${BLE_VERSION-} ]]; then
        ble-bind -f 'RET' 'accept-line' 2>/dev/null
        ble-bind -f 'C-m' 'accept-line' 2>/dev/null
        # Hide [ble: exit 2] marker after failed commands
        bleopt exec_errexit_mark='' 2>/dev/null
        # Fix paste wrapping: disable line limit so multi-line paste displays fully
        bleopt line_limit_type=none 2>/dev/null
        bleopt line_limit_length=0 2>/dev/null
        # Tuning: faster ghost text, Fish-like (fixed: empty disabled it)
        bleopt complete_auto_complete=1 2>/dev/null
        bleopt complete_auto_delay=150 2>/dev/null
        bleopt complete_menu_complete=1 2>/dev/null
        bleopt complete_menu_maxlines=8 2>/dev/null
        bleopt highlight_syntax=1 2>/dev/null
        bleopt highlight_filename=1 2>/dev/null
        bleopt highlight_variable=1 2>/dev/null
        # Dir-aware ghost: disable history ghost (was suggesting ls legacy from other dir), keep file-aware syntax ghost
        bleopt complete_auto_complete_opts='history-disabled' 2>/dev/null
        # Accept ghost with Right (default) — keep C-l as extra
        ble-bind -m emacs -f 'C-l' 'ble/widget/complete' 2>/dev/null
    fi
fi

# --- Aliases (from fish) ---
# eza family (fish used eza --icons --git, hecate used exa — override to fish)
alias ls='eza --icons --git --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias tree='eza --tree --icons'

alias la='eza -a --icons --group-directories-first'
alias lt='eza -T --icons --level=2'

# Navigation — fish: alias cd="z" (zoxide)
alias cd='z'

# Package managers (fish)
alias pii='paru -S'
alias pi='paru -Rns'
alias suii='sudo pacman -Syu'
alias sui='sudo pacman -S'
alias ded='sudo pacman -Rns'

# gdrive on-demand (was autostart 109M)
alias gdrive-on='systemctl --user start gdrive-pool.service'
alias gdrive-off='systemctl --user stop gdrive-pool.service'
alias gdrive-status='systemctl --user status gdrive-pool.service'

alias fast='fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc'
alias doc='cd ~/Documents/'
alias dow='cd ~/Downloads/'
alias pic='cd ~/Pictures/'
alias rdb='rm ~/.cache/cliphist/db'
alias meminfo='free -m'
alias cpuinfo='lscpu'
alias ports='sudo netstat -tulanp'
alias df='df -h'
alias du='du -h'
alias warp="$HOME/.config/hypr/scripts/toggle-warp.sh"
alias dns="$HOME/.local/bin/toggle-dns"

# --- Functions (from fish) ---

# ============================================================
# GitHub Account Switchers
# ============================================================

baldwin() {
    git config user.name "b4ldw1nN"
    git config user.email "dreadful.locus@gmail.com"

    local remote
    remote="$(git remote get-url origin 2>/dev/null)"

    if [ -n "$remote" ]; then
        remote="$(echo "$remote" | sed \
            's|git@github.com:|git@gh-b4ldw1nN:|g')"

        git remote set-url origin "$remote"
    fi

    echo "Switched current repo to b4ldw1nN"
}


ashvinto() {
    git config user.name "ashvin-to"
    git config user.email "mrsinghashvin@gmail.com"

    local remote
    remote="$(git remote get-url origin 2>/dev/null)"

    if [ -n "$remote" ]; then
        remote="$(echo "$remote" | sed \
            's|git@gh-b4ldw1nN:|git@github.com:|g')"

        git remote set-url origin "$remote"
    fi

    echo "Switched current repo to ashvin-to"
}


# ============================================================
# Clone using b4ldw1nN
# ============================================================

clone-baldwin() {
    if [ $# -lt 1 ]; then
        echo "Usage: clone-baldwin <repo_or_url>"
        return 1
    fi

    local repo="$1"
    local target

    target="$(echo "$repo" | sed \
        's|git@github.com:|git@gh-b4ldw1nN:|g')"

    if [[ "$target" != git@* ]]; then
        target="git@gh-b4ldw1nN:$target.git"
    fi

    git clone "$target" || return 1

    local folder_name
    folder_name="$(basename "$target" .git)"

    if [ -d "$folder_name" ]; then
        z "$folder_name" 2>/dev/null || cd "$folder_name"
        baldwin
    fi
}

# command-not-found handler (fish: fish_command_not_found)
command_not_found_handle() {
    echo -e "\e[31mOops, you entered the wrong command!\e[0m"
    echo "bash: Unknown command: $1" >&2
    return 127
}

cdf() {
  local dir
  dir=$(fd --type d --hidden --exclude .git . ~ 2>/dev/null | \
    fzf --prompt="📁 Select directory: " \
        --height 50% \
        --preview 'eza --tree --level=2 --icons --color=always {}' 2>/dev/null)
  if [[ -n "$dir" ]]; then
    cd "$dir" || return
    ls
  fi
}

vf() {
  local file
  file=$(fd --type f --hidden --exclude .git 2>/dev/null | \
    fzf --prompt="✏️  Select file to edit: " \
        --height 50% \
        --preview 'bat --color=always --style=numbers --line-range :500 {}' 2>/dev/null)
  if [[ -n "$file" ]]; then
    ${EDITOR:-nvim} "$file"
  fi
}

fh() {
  local cmd
  cmd=$(history | \
    fzf --prompt="🔍 Search history: " \
        --tac \
        --height 50% \
        --preview 'echo {}' \
        --preview-window up:3:wrap 2>/dev/null | \
    sed 's/ *[0-9]* *//')
  if [[ -n "$cmd" ]]; then
    eval "$cmd"
  fi
}

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | \
    fzf --prompt="💀 Select process to kill: " \
        --height 50% \
        --preview 'echo {}' \
        --preview-window down:3:wrap 2>/dev/null | \
    awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "Killing process $pid"
    kill -9 "$pid"
  fi
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Keybinds
bind -x '"\C-g": cdf' 2>/dev/null
bind -x '"\C-e": vf' 2>/dev/null
bind -x '"\C-f": fh' 2>/dev/null

# --- SSH agent ---
# Prefer systemd socket; fallback to ssh-agent
export SSH_AUTH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
if [ ! -S "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

# --- Cleanup helpers ---
unset -f _add_path _prepend_path 2>/dev/null


# local secrets (not in repo)
[ -f ~/.bashrc.secrets ] && . ~/.bashrc.secrets
