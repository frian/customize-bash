#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

# shellcheck source=../core/bash_customize_shell.sh
source "$root/core/bash_customize_shell.sh"
[[ $(alias b) == *"cd .."* ]] || fail 'navigation alias changed'
[[ $(alias b5) == *'../../../../..'* ]] || fail 'deep navigation alias changed'
[[ $(alias grep) == *'--color=auto'* ]] || fail 'grep still forces colors'
[[ $(alias egrep) == *'grep -E --color=auto'* ]] || fail 'egrep still invokes deprecated utility'
[[ $(alias fgrep) == *'grep -F --color=auto'* ]] || fail 'fgrep still invokes deprecated utility'
[[ $(alias ls) == *'--color=auto'* ]] || fail 'ls still forces colors'
[[ $(alias ll) == *'ls -lh'* ]] || fail 'long listing is not human-readable'
[[ $(alias lla) == *'ls -lah'* ]] || fail 'hidden long listing missing'
[[ $(alias ports) == *'ss -tulnp'* ]] || fail 'ports alias still uses netstat'
[[ $(alias dus) == *'du -ah | sort -rh | head -20'* ]] || fail 'disk usage shortcut missing'
[[ $(alias lal) == *'alias -p'* ]] || fail 'alias listing is not builtin'
[[ $(listAliasCommand) == *'alias b='* ]] || fail 'legacy listAliasCommand function missing'

old_path=$PATH
PATH='/a directory:/b:/c'
[[ $(path) == $'/a directory\n/b\n/c' ]] || fail 'path split failed'
LD_LIBRARY_PATH='/some library:/another'
[[ $(libpath) == $'/some library\n/another' ]] || fail 'libpath split failed'
unset LD_LIBRARY_PATH
[[ -z $(libpath) ]] || fail 'libpath should handle unset variable'
PATH=$old_path

fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/work"
: > "$fixture/work/My FILE with spaces.txt"
(cd "$fixture/work"; [[ $(nfind '*with spaces*') == './My FILE with spaces.txt' ]]) || fail 'nfind failed on spaced names'
if nfind >/dev/null 2>&1; then fail 'nfind accepted no arguments'; fi
if psgrep >/dev/null 2>&1; then fail 'psgrep accepted no arguments'; fi

# Stub external commands so tests do not use the network or depend on Git.
printf '%s\n' '#!/bin/sh' 'printf "%s\\n" "$@" > "$TEST_CAPTURE_FILE"' 'printf "203.0.113.42"' > "$fixture/bin/curl"
printf '%s\n' '#!/bin/sh' 'printf "%s\\n" "$@" > "$TEST_CAPTURE_FILE"' > "$fixture/bin/git"
chmod +x "$fixture/bin/curl" "$fixture/bin/git"
export TEST_CAPTURE_FILE="$fixture/capture"
PATH="$fixture/bin:/usr/bin:/bin"
[[ $(pubip) == '203.0.113.42' ]] || fail 'pubip output wrong'
[[ $(tail -n 1 "$TEST_CAPTURE_FILE") == 'https://api.ipify.org' ]] || fail 'pubip must use HTTPS'
grep -Fx -- '--max-time' "$TEST_CAPTURE_FILE" >/dev/null || fail 'pubip timeout missing'

# shellcheck source=../samples/bash_customize_git.sh
source "$root/samples/bash_customize_git.sh"
[[ $(alias gitl) == *'--oneline --graph'* ]] || fail 'existing Git aliases changed'
if gitCommit >/dev/null 2>&1; then fail 'gitc accepted no commit message'; fi
gitCommit a spaced commit message
[[ $(cat "$TEST_CAPTURE_FILE") == $'commit\n-m\na spaced commit message' ]] || fail 'gitc did not send a single message'
gitCommit 'message with quotes and spaces'
[[ $(cat "$TEST_CAPTURE_FILE") == $'commit\n-m\nmessage with quotes and spaces' ]] || fail 'gitc broke quoted messages'

# shellcheck source=../samples/bash_customize_symfony.sh
source "$root/samples/bash_customize_symfony.sh"
[[ $(alias sf) == *'php bin/console'* ]] || fail 'Symfony console path is obsolete'

printf 'PASS: core aliases, safe functions, optional Git and Symfony\n'
