# PHP version by directory, scoped to THIS shell/tab via PATH (never changes
# anything global, so multiple tabs each keep their own version).
# php83 for the listed roots (and their subdirs); php85 everywhere else.

PHP_DEFAULT_VERSION="8.5"
PHP_SHIM_ROOT="$HOME/.local/share/php-versions"

PHP83_DIRS=(
  "$HOME/Projects/php83"
  # "$HOME/Projects/another-8.3-project"
)

# Arch's AUR packages install suffixed binaries into a shared /usr/bin
# (/usr/bin/php83, /usr/bin/php85), so unlike Homebrew there is no per-version
# bin dir to prepend. Build one: a dir per version holding a plain `php` that
# symlinks to the suffixed real binary. Created on demand so this keeps working
# if a version is installed later.
_php_ensure_shim() {
  local ver="$1" nodot="${1//./}" dir="$PHP_SHIM_ROOT/$1"

  [[ -x "$dir/php" ]] && return 0
  [[ -x "/usr/bin/php$nodot" ]] || return 1

  mkdir -p "$dir" || return 1
  ln -sfn "/usr/bin/php$nodot" "$dir/php"
  local tool
  for tool in php-config phpize phar; do
    [[ -e "/usr/bin/$tool$nodot" ]] && ln -sfn "/usr/bin/$tool$nodot" "$dir/$tool"
  done
  return 0
}

# switchphp            -> pick version from $PWD (what the prompt hook calls)
# switchphp 8.3 | 8.5  -> pin this shell to a version, ignoring $PWD
# switchphp auto       -> drop the pin, go back to picking by directory
switchphp() {
  local target verbose=""

  case "${1-}" in
    "")     ;;
    -v)     verbose=1 ;;
    auto)   PHP_PIN=""; verbose=1 ;;
    8.3|83) PHP_PIN="8.3"; verbose=1 ;;
    8.5|85) PHP_PIN="8.5"; verbose=1 ;;
    *)      echo "usage: switchphp [8.3|8.5|auto|-v]" >&2; return 2 ;;
  esac

  if [[ -n "${PHP_PIN-}" ]]; then
    target="$PHP_PIN"
  else
    target="$PHP_DEFAULT_VERSION"
    local d
    for d in "${PHP83_DIRS[@]}"; do
      if [[ "$PWD" == "$d" || "$PWD" == "$d"/* ]]; then
        target="8.3"
        break
      fi
    done
  fi

  if ! _php_ensure_shim "$target"; then
    # Stay quiet when no PHP is installed at all -- that is not this script's
    # problem, and it would warn on every new shell.
    if compgen -G "/usr/bin/php[0-9][0-9]" > /dev/null; then
      echo "switchphp: PHP $target not installed (no /usr/bin/php${target//./})" >&2
      echo "           install it with: yay -S php${target//./}-cli" >&2
    fi
    return 1
  fi

  # Drop any shim dir we injected earlier (no stacking), then put the target
  # first. read -ra rather than word-splitting $PATH, so a glob char in a PATH
  # entry cannot expand.
  local -a parts
  IFS=: read -ra parts <<< "$PATH"
  local p newpath=""
  for p in "${parts[@]}"; do
    [[ "$p" == "$PHP_SHIM_ROOT"/* ]] && continue
    newpath="${newpath:+$newpath:}$p"
  done
  export PATH="$PHP_SHIM_ROOT/$target:$newpath"

  hash -r 2>/dev/null   # forget cached command paths (no-op under Omarchy's `set +h`)
  [[ -n "$verbose" ]] && php -v | head -n1
  return 0
}

# Per-tab auto-switch: safe here because PATH is per-shell, not global.
# bash has no chpwd hook, so this rides PROMPT_COMMAND, guarded on $PWD actually
# changing so it does not re-run on every prompt.
_php_auto_switch() {
  [[ "$PWD" == "${_PHP_LAST_PWD-}" ]] && return 0
  _PHP_LAST_PWD="$PWD"
  switchphp
}

if [[ $- == *i* ]]; then
  # Omarchy sets PROMPT_COMMAND as an array (starship, title, zoxide) -- append
  # to it rather than overwrite, and only once if this file gets re-sourced.
  if [[ " ${PROMPT_COMMAND[*]-} " != *" _php_auto_switch "* ]]; then
    if [[ "$(declare -p PROMPT_COMMAND 2>/dev/null)" == "declare -a"* ]]; then
      PROMPT_COMMAND+=(_php_auto_switch)
    else
      PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_php_auto_switch"
    fi
  fi

  _PHP_LAST_PWD="$PWD"
  switchphp || true   # set the correct version for this tab's starting directory
fi
