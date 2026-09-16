# ==============================
# FISH CONFIG (CLEAN + STABLE)
# ==============================

# ----------------------
# SAFE PATH SETUP
# ----------------------

# Start clean (prevents inherited duplication)
set -e PATH

# System paths (highest priority)
fish_add_path -g /usr/bin
fish_add_path -g /usr/local/bin
fish_add_path -g /usr/sbin
fish_add_path -g /usr/local/sbin
fish_add_path -g /sbin
fish_add_path -g /bin

# User paths
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $HOME/.bun/bin
fish_add_path -g $HOME/.local/share/pnpm
fish_add_path -g $HOME/.npm-global/bin
fish_add_path -g $HOME/.spicetify
fish_add_path -g $HOME/.lmstudio/bin

# Optional system tools
fish_add_path -g /opt/cuda/bin
fish_add_path -g /usr/lib/jvm/default/bin


# ----------------------
# ENV VARIABLES
# ----------------------

set -x SSH_AUTH_SOCK /run/user/(id -u)/ssh-agent.socket
set -gx EDITOR code
set -gx VISUAL code
set -gx BROWSER firefox


# ----------------------
# INTERACTIVE GUARDS
# ----------------------

if not status is-interactive
    return
end

set -g fish_greeting ""


# ----------------------
# STARSHIP PROMPT
# ----------------------

if type -q starship
    starship init fish | source
end


# ----------------------
# ALIASES
# ----------------------

alias pamcan pacman
alias pac pacman
alias ls 'eza --icons'
alias pi "yay -Rns"
alias pii "yay -S"
alias ded "sudo pacman -Rns"
alias suii "sudo pacman -Syu"
alias sui "sudo pacman -S"
alias ls="eza --icons --git --group-directories-first"
alias ll="eza -lh --icons --git --group-directories-first"
alias tree="eza --tree --icons"


# ----------------------
# CLEAR FUNCTION
# ----------------------

function show_image_and_clear
    command clear
end

alias clear show_image_and_clear


# ----------------------
# FASTFETCH (SAFE)
# ----------------------

if status is-interactive
    if test -t 1
        if type -q fastfetch
            fastfetch 2>/dev/null
        end
    end
end


# ----------------------
# COMMAND NOT FOUND
# ----------------------

function fish_command_not_found
    set_color red
    echo "Oops, you entered the wrong command!"
    set_color normal
    echo "fish: Unknown command: $argv"
end


# ----------------------
# PNPM (SAFE)
# ----------------------

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -g $PNPM_HOME


# ----------------------
# BUN (SAFE - NO PATH OVERWRITE BUG)
# ----------------------

set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path -g $BUN_INSTALL/bin




fish_add_path /opt/brew/bin


# Added by Antigravity CLI installer
set -gx PATH "/home/zoro/.local/bin" $PATH

# kimi-code
fish_add_path -g "/home/zoro/.kimi-code/bin"

# tweaks 
echo "PATH before tweaks:"
printf '%s\n' $PATH

source ~/.config/fish/generated/zoxide.fish

echo "PATH after zoxide:"
printf '%s\n' $PATH

source ~/.config/fish/generated/fzf.fish

echo "PATH after fzf:"
printf '%s\n' $PATH
source ~/.config/fish/generated/zoxide.fish
source ~/.config/fish/generated/fzf.fish
