#!/usr/bin/env bash
# Dotfiles bootstrap: recreates symlinks from ~/dotfiles/home into $HOME.
# Idempotent — safe to re-run. Existing real files/dirs are backed up to <name>.dotfiles-bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/home"
BACKUP_EXT=".dotfiles-bak"

link() {  # link <source> <target>
  local src="$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    return
  fi
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst$BACKUP_EXT"
    echo "backup  $dst -> $dst$BACKUP_EXT"
  fi
  rm -rf "$dst"
  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
}

echo "== Git submodules (hypr, hyprshell) =="
git -C "$(dirname "$DOTFILES")" submodule update --init --recursive

echo "== Home dotfiles =="
for f in .bashrc .gitconfig .inputrc .profile; do
  link "$DOTFILES/$f" "$HOME/$f"
done

echo "== ~/.config dirs =="
for d in atuin btop fastfetch foot gtk-3.0 gtk-4.0 Kvantum mpv nvim qt5ct qt6ct rofi; do
  link "$DOTFILES/.config/$d" "$HOME/.config/$d"
done

echo "== ~/.config files =="
for f in gtkrc gtkrc-2.0 mimeapps.list starship.toml user-dirs.dirs user-dirs.locale; do
  link "$DOTFILES/.config/$f" "$HOME/.config/$f"
done

echo "== fish (symlinks inside a real dir so secrets stay local) =="
mkdir -p "$HOME/.config/fish"
for item in config.fish w.fish functions completions conf.d; do
  link "$DOTFILES/.config/fish/$item" "$HOME/.config/fish/$item"
done

echo
echo "== Secrets (NOT in repo — create these manually) =="
[[ -f "$HOME/.bashrc.secrets" ]]        || echo "missing  ~/.bashrc.secrets"
[[ -f "$HOME/.config/fish/secrets.fish" ]] || echo "missing  ~/.config/fish/secrets.fish"

echo
echo "Done."
