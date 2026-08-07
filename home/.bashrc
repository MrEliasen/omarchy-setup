# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
alias myip="curl https://ipecho.net/plain; echo"

v () {
  FILEPATH=".";
  if [ ! -z "$1" ]; then
    FILEPATH="$1"
  fi;

  nvim "$FILEPATH"
}

o () {
  LOCATION=".";
  if [ ! -z "$1" ]; then
    LOCATION="$1"
  fi;

  open "$LOCATION"
}

alias gmap="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# >>> Codex installer >>>
# $HOME rather than the hardcoded path the installer writes, so this survives a
# move to a machine with a different username.
export PATH="$HOME/.local/bin:$PATH"
# <<< Codex installer <<<

# Per-directory PHP version switching (edit PHP83_DIRS in there)
source ~/.config/php-switcher.bash
