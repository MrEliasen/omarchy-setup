#!/usr/bin/env bash
#
# Symlinks everything in this repo to where it belongs, so the repo stays the
# source of truth: edit files here, and the live config changes with them.
#
# Anything already at a destination is moved aside to <name>.bak.<timestamp>
# rather than deleted. Safe to re-run; already-correct links are left alone.
#
#   ./install.sh --dry-run    show what would happen, change nothing
#   ./install.sh              do it
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
[[ "${1-}" == "--dry-run" || "${1-}" == "-n" ]] && DRY_RUN=1

say() { printf '%s\n' "$*"; }
run() {
  if ((DRY_RUN)); then
    say "         would run: $*"
  else
    "$@"
  fi
}

# _link <sudo|""> <path-in-repo> <destination>
_link() {
  local -a S=()
  [[ -n "$1" ]] && S=(sudo)
  local src="$REPO/$2" dest="$3"

  if [[ ! -e "$src" ]]; then
    say "  MISSING  $2 is not in the repo"
    return 1
  fi

  # Already pointing at the right place -- nothing to do.
  if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
    say "  ok       $dest"
    return 0
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    say "  backup   $dest -> $(basename "$dest").bak.$STAMP"
    run "${S[@]}" mv "$dest" "$dest.bak.$STAMP"
  fi

  run "${S[@]}" mkdir -p "$(dirname "$dest")"
  run "${S[@]}" ln -sfn "$src" "$dest"
  say "  link     $dest"
}

link() { _link "" "$1" "$2"; }
link_root() { _link sudo "$1" "$2"; }

((DRY_RUN)) && say "DRY RUN -- nothing will be changed" && say ""

say "==> Shell"
link home/.bashrc              "$HOME/.bashrc"
link config/php-switcher.bash  "$HOME/.config/php-switcher.bash"

say "==> Neovim"
# The whole directory is linked, so plugin updates write lazy-lock.json straight
# back into the repo.
link config/nvim               "$HOME/.config/nvim"

say "==> Hyprland"
# Only the files actually customised -- the rest of ~/.config/hypr is Omarchy
# stock and is left alone.
for f in bindings input monitors hypridle; do
  link "config/hypr/$f.conf"   "$HOME/.config/hypr/$f.conf"
done

say "==> keyd"
link config/keyd/app.conf      "$HOME/.config/keyd/app.conf"
link config/systemd/user/keyd-application-mapper.service \
                               "$HOME/.config/systemd/user/keyd-application-mapper.service"
# Note: this points /etc at a file in $HOME. Fine on a normal single-filesystem
# box, but if /home ever lives on a separate late-mounted disk, copy this one
# instead of linking it.
link_root etc/keyd/default.conf /etc/keyd/default.conf

say "==> Theme"
# omarchy-theme-set regenerates ~/.config/omarchy/current/theme/, which is where
# Neovim's colourscheme comes from. Re-applying the recorded theme is harmless
# if it's already set, and on a fresh machine it's what pins the look.
THEME="$(cat "$REPO/config/omarchy/theme.name" 2>/dev/null || echo '')"
if [[ -n "$THEME" ]] && command -v omarchy-theme-set >/dev/null; then
  say "  theme    $THEME"
  run omarchy-theme-set "$THEME"
else
  say "  skipped  (no theme.name, or omarchy-theme-set not on PATH)"
fi

# omarchy-nvim creates this link once at install time, as a *relative* path.
# That breaks the moment ~/.config/nvim points into this repo, because it then
# resolves from the repo root instead of ~/.config. An absolute link works from
# wherever the repo lives, and Omarchy's migration for this file explicitly
# leaves customised links alone. It's gitignored, so it won't dirty the repo.
say "  link     ~/.config/nvim/lua/plugins/theme.lua"
run mkdir -p "$HOME/.config/nvim/lua/plugins"
run ln -sfn "$HOME/.config/omarchy/current/theme/neovim.lua" \
            "$HOME/.config/nvim/lua/plugins/theme.lua"

say ""
say "==> Applying"

if ((DRY_RUN)); then
  say "         would reload keyd, systemd and Hyprland"
else
  # keyd exits non-zero on warnings too, so don't let it abort the script.
  keyd check /etc/keyd/default.conf || true

  sudo systemctl enable --now keyd
  sudo keyd reload

  systemctl --user daemon-reload
  systemctl --user enable --now keyd-application-mapper.service

  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE-}" ]] && command -v hyprctl >/dev/null; then
    hyprctl reload
  else
    say "  (not in a Hyprland session -- run 'hyprctl reload' or log back in)"
  fi
fi

say ""
say "Done. Open a new shell for .bashrc, and run nvim once to let lazy.nvim"
say "install plugins at the versions pinned in lazy-lock.json."
