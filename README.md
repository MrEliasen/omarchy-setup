# Omarchy Setup

Just some bits I needed to setup Omarchy on my machine.

This repo is for me, however feel free to nick whatever you want from it.

**This repo is the source of truth.** `./install.sh` symlinks everything into
place, so editing a file here changes the live config, and `git status` shows
what's drifted.

## Setup on a new machine

Install Omarchy first, then:

```bash
git clone <this-repo> ~/Projects/omarchy-setup
cd ~/Projects/omarchy-setup
./install.sh --dry-run   # see what it'll touch
./install.sh
```

Anything already at a destination is moved to `<name>.bak.<timestamp>` rather
than deleted, and re-running is safe — links that are already correct are left
alone. It'll ask for sudo once, for `/etc/keyd/default.conf`.

Afterwards: open a new shell for `.bashrc`, and run `nvim` once so lazy.nvim
installs plugins at the versions pinned in `lazy-lock.json`.

## What's in here

Everything mirrors the path it belongs at on the machine.

| Repo path | Symlinked to | What it is |
| --- | --- | --- |
| `home/.bashrc` | `~/.bashrc` | Aliases (`myip`, `gmap`), `v`/`o` helpers, Codex PATH, sources php-switcher |
| `config/php-switcher.bash` | `~/.config/php-switcher.bash` | Per-directory PHP 8.3/8.5 switching (sourced by `.bashrc`) |
| `config/nvim/` | `~/.config/nvim/` | Full LazyVim-based config: keymaps, LSP setup, plugins, `lazy-lock.json` |
| `config/hypr/bindings.conf` | `~/.config/hypr/bindings.conf` | Keybindings — unbinds most SUPER defaults, Ctrl+Shift focus/workspaces, app launchers |
| `config/hypr/input.conf` | `~/.config/hypr/input.conf` | Caps as compose, repeat rate, flat accel, `follow_mouse = 0`, touchpad + terminal scroll |
| `config/hypr/monitors.conf` | `~/.config/hypr/monitors.conf` | 2x retina scaling (`GDK_SCALE=2`) |
| `config/hypr/hypridle.conf` | `~/.config/hypr/hypridle.conf` | Screensaver/lock timings + logind `IdleHint` listener |
| `etc/keyd/default.conf` | `/etc/keyd/default.conf` | Mac-style Cmd layer: Meta + Caps → `cmd` layer, Cmd+C/V/etc, Home/End nav |
| `config/keyd/app.conf` | `~/.config/keyd/app.conf` | Per-app keyd overrides for Alacritty and Ghostty |
| `config/systemd/user/keyd-application-mapper.service` | `~/.config/systemd/user/` | Runs the daemon that makes `app.conf` work |
| `config/omarchy/theme.name` | applied via `omarchy-theme-set` | Which Omarchy theme to use (`catppuccin`) |
| `fix_audio.sh` | — | Machine-specific 3.5mm jack fix, run by hand (see below) |

The keyd setup follows [omarchy discussion #175](https://github.com/basecamp/omarchy/discussions/175),
with modifications. All three of its files are here.

### fix_audio.sh

Deliberately **not** run by `install.sh`. It's specific to this machine's
hardware — the `hwC1D0` path, pin node `0x18`, and the codec IDs in the patch
file all assume a Conexant SN6140. Run it by hand, only if the headphone jack
is dead:

```bash
./fix_audio.sh
```

It checks the codec before doing anything and exits cleanly on unfamiliar
hardware, listing what it did find. That check matters because the script stops
PipeWire before reconfiguring — without it, a failed write partway through
would leave the session with no sound at all. `--force` skips the check if the
kernel reports the same codec under a different name.

### Cmd+Left / Cmd+Right

Globally these are `home`/`end`, which is what GUI apps want. Terminals want
readline's `C-a`/`C-e` instead, so `app.conf` overrides them per-app for
Alacritty and Ghostty. That's why the binding appears in two places — it isn't a
duplicate. Only safe because tmux's prefix here is `C-Space`; if that ever
changes to `C-a`, this collides.

Only the Hyprland files actually customised are tracked. The rest
(`hyprland.conf`, `looknfeel.conf`, `autostart.conf`, `hyprlock.conf`,
`hyprsunset.conf`, `xdph.conf`) are Omarchy stock and get recreated on install.

## Working on it

Since `~/.config/nvim` is a symlink to `config/nvim/`, plugin updates write
`lazy-lock.json` straight back into the repo — commit it to pin the new versions.

After editing, to pick the changes up:

```bash
# keyd -- check first, it catches silently-dropped bindings
keyd check /etc/keyd/default.conf
sudo keyd reload
systemctl --user restart keyd-application-mapper   # only for app.conf changes

# hyprland
hyprctl reload

# hypridle -- NOT covered by `hyprctl reload`; it's an exec-once daemon,
# so the old config keeps running until it's restarted
omarchy-restart-hypridle
```

`keyd check` is worth the habit. keyd only treats `#` as a comment when it
**starts the line** — a trailing `a = C-a  # select all` is parsed as part of the
value and the binding is dropped without complaint at runtime.

### Notes

- `.bashrc` sources `~/.local/share/omarchy/default/bash/rc`, so Omarchy has to
  be installed before it'll work.
- `php-switcher.bash` expects `php83-cli` / `php85-cli` from the AUR, and has a
  hardcoded `PHP83_DIRS` list — update it for the projects on the new machine.
- Current theme is `catppuccin` (set via `omarchy-theme-set`, not stored here).
- `config/nvim/lua/plugins/theme.lua` is gitignored, and `install.sh` recreates
  it. Omarchy normally makes it a *relative* symlink into
  `~/.config/omarchy/current/`, which breaks once `~/.config/nvim` points at the
  repo — it resolves from the repo root instead. `install.sh` links it
  absolutely, which Omarchy's migration for that file leaves alone.
- `install.sh` points `/etc/keyd/default.conf` at a file in `$HOME`. Fine on a
  normal single-disk box; if `/home` ever ends up on a separately-mounted disk,
  copy that one file instead of linking it.
