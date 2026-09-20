# dotfiles

Personal Linux dotfiles managed with symlinks. Real files live in this repo;
`~` contains nothing but symlinks pointing here (plus a few local-only files).

## Layout

```
dotfiles/
├── install.sh          # bootstrap script — recreates all symlinks (idempotent)
├── home/
│   ├── .bashrc         # sources ~/.bashrc.secrets (local, not tracked)
│   ├── .gitconfig
│   ├── .inputrc
│   ├── .profile
│   └── .config/
│       ├── atuin/ btop/ fastfetch/ foot/ gtk-3.0/ gtk-4.0/ Kvantum/
│       ├── mpv/        # full mpv setup: conf, scripts, shaders, fonts
│       ├── nvim/       # undodir/ and backup/ are gitignored
│       ├── qt5ct/ qt6ct/ rofi/
│       ├── fish/       # see "Secrets" below
│       ├── mimeapps.list  starship.toml  gtkrc  gtkrc-2.0
│       └── user-dirs.dirs  user-dirs.locale
├── hypr/    → git submodule (separate repo, lives in ~/.config/hypr)
└── hyprshell/ → git submodule (separate repo, lives in ~/.config/hyprshell)
```

### Symlink map

| Repo path | Target |
|---|---|
| `home/.{bashrc,gitconfig,inputrc,profile}` | `~/` (direct symlink) |
| `home/.config/{atuin,btop,fastfetch,foot,gtk-3.0,gtk-4.0,Kvantum,mpv,nvim,qt5ct,qt6ct,rofi}` | `~/.config/` (direct symlink) |
| `home/.config/{mimeapps.list,starship.toml,gtkrc,gtkrc-2.0,user-dirs.dirs,user-dirs.locale}` | `~/.config/` (direct symlink) |
| `home/.config/fish/{config.fish,w.fish,functions,completions,conf.d}` | symlinked **into** a real `~/.config/fish/` dir |

`~/.config/fish/` is deliberately a real directory so that machine-local
files (`secrets.fish`, `fish_variables`) can live alongside the symlinked
config.

## Secrets

Secrets are **never** committed. They live in two local, gitignored-pattern
files (mode 600) that the tracked configs source conditionally:

| Local file (not in repo) | Sourced by | Contains |
|---|---|---|
| `~/.bashrc.secrets` | end of `.bashrc` | API keys / tokens as `export` lines |
| `~/.config/fish/secrets.fish` | end of `config.fish` | same, as `set -x` lines |

Recreate them after cloning:

```bash
# ~/.bashrc.secrets
export ANTHROPIC_BASE_URL="..."
export ANTHROPIC_AUTH_TOKEN="..."
export ANTHROPIC_API_KEY="..."
```

```fish
# ~/.config/fish/secrets.fish
set -x ANTHROPIC_BASE_URL "..."
set -x ANTHROPIC_AUTH_TOKEN "..."
set -x ANTHROPIC_API_KEY ""
```

Both source lines are guarded, so the configs also work with the files absent.

Also local-only (not tracked):
- `~/.config/fish/fish_variables` — fish universal variables (machine state)
- `~/.config/nvim/undodir/`, `~/.config/nvim/backup/` — editor state (gitignored)

## Usage

### New machine

```bash
git clone --recurse-submodules <repo-url> ~/dotfiles
~/dotfiles/install.sh
```

Then create the two secrets files listed above.

### install.sh

- Idempotent: re-running is safe; already-correct symlinks are skipped (`ok`).
- Non-symlink files/dirs in the way are moved aside to `<name>.dotfiles-bak`.
- Initializes the `hypr` and `hyprshell` submodules.
- Warns about any missing secrets files.

### Updating

```bash
git -C ~/dotfiles pull
git -C ~/dotfiles submodule update --init --recursive
```

Edits made under `~` land directly in the repo — just commit and push.

## Notes

- `hypr` and `hyprshell` are separate repos pulled in as git submodules —
  don't symlink them, commit inside their own checkouts.
- wallust regenerates several files (`gtk-*/colors.css`, `fish/conf.d/wallust-colors.fish`,
  `foot/wallust-colors.ini`, `Kvantum/wallust/`, gtk-4.0 theme symlinks);
  expect those to show as modified after a theme change.
