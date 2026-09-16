# ~/.config/fish/config.fish

# -----------------------------------------------------------------------------
# Greeting
# -----------------------------------------------------------------------------

set -g fish_greeting

# -----------------------------------------------------------------------------
# Environment
# -----------------------------------------------------------------------------

set -gx EDITOR code
set -gx VISUAL code
set -gx BROWSER firefox

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx BUN_INSTALL "$HOME/.bun"

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------

fish_add_path \
    "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    "$BUN_INSTALL/bin" \
    "$PNPM_HOME" \
    "$HOME/.npm-global/bin" \
    "$HOME/.kimi-code/bin" \
    /opt/cuda/bin \
    /usr/lib/jvm/default/bin

# -----------------------------------------------------------------------------
# Prompt
# -----------------------------------------------------------------------------

if type -q starship
    starship init fish | source
end

# -----------------------------------------------------------------------------
# zoxide
# -----------------------------------------------------------------------------

if type -q zoxide
    zoxide init fish | source
    complete --erase --command z 
    complete --command z --arguments '(__zoxide_z_complete)'
end

# -----------------------------------------------------------------------------
# fzf & bat / fd Integration
# -----------------------------------------------------------------------------

if type -q fzf
    fzf --fish | source
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=1 {}'"
end

# -----------------------------------------------------------------------------
# Fastfetch
# -----------------------------------------------------------------------------

if status is-interactive
    if test -t 1
        if type -q fastfetch
            fastfetch 2>/dev/null
        end
    end
end

# -----------------------------------------------------------------------------
# Aliases & Custom Helper Functions
# -----------------------------------------------------------------------------

alias ls='eza --icons --git --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --style=plain'

alias cd="z"
alias pii='yay -S'
alias pi='yay -Rns'

alias suii='sudo pacman -Syu'
alias sui='sudo pacman -S'
alias ded='sudo pacman -Rns'

alias lock='fusermount -u ~/unvault'
alias unlock='gocryptfs ~/vault ~/unvault'

alias pia="/home/zoro/.npm-global/bin/pi"

# 1-Command Switcher for b4ldw1nN account
function baldwin
    git config user.name "b4ldw1nN"
    git config user.email "dreadful.locus@gmail.com"
    echo "Switched current repo to b4ldw1nN (dreadful.locus@gmail.com)"
end

# 1-Command Switcher for ashvin-to account
function ashvinto
    git config user.name "ashvin-to"
    git config user.email "mrsinghashvin@gmail.com"
    echo "Switched current repo to ashvin-to (mrsinghashvin@gmail.com)"
end

# Clone helper for b4ldw1nN
function clone-baldwin
    if test (count $argv) -lt 1
        echo "Usage: clone-baldwin <repo_or_url>"
        return 1
    end
    set -l repo $argv[1]
    set -l target (string replace -r "^git@github\.com:" "git@gh-b4ldw1nN:" "$repo")
    if not string match -q "git@*" "$target"
        set target "git@gh-b4ldw1nN:$target.git"
    end

    git clone $target
    if test $status -eq 0
        set -l folder_name (basename $target .git)
        if test -d "$folder_name"
            cd "$folder_name"
            baldwin
        end
    end
end

# -----------------------------------------------------------------------------
# Clear
# -----------------------------------------------------------------------------

function clear
    command clear
end

# -----------------------------------------------------------------------------
# Command Not Found
# -----------------------------------------------------------------------------

function fish_command_not_found
    set_color red
    echo "Oops, you entered the wrong command!"
    set_color normal
    echo "fish: Unknown command: $argv"
end

# Claude Code / OpenRouter
set -x ANTHROPIC_BASE_URL "https://openrouter.ai/api"
set -x CLAUDE_CODE_SKIP_NONESSENTIAL_TRAFFIC 1
set -x CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS 1


# fnm
if status is-interactive
    if type -q fnm
        fnm env --use-on-cd | source
    end
end

export PATH="$PATH:/home/zoro/.local/bin"

# thefuck

    if type -q thefuck
        thefuck --alias | source
    end


set -x CLIPBOARD_SERVER_HOST (tailscale ip -4 2>/dev/null | head -n1)
