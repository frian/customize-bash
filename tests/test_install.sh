#!/usr/bin/env bash
set -euo pipefail
source_repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
repo="$work/clone with spaces"
home="$work/test home"
mkdir -p "$repo" "$home"
cp -R "$source_repo"/. "$repo"/

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
assert_count() {
    local expected=$1 value=$2 file=$3
    local actual
    actual=$(grep -Fc -- "$value" "$file" || true)
    [[ $actual == "$expected" ]] || fail "expected $expected matches of '$value' in $file; got $actual"
}

# Safe preview does not create ~/.bashrc (including first installation).
HOME=$home bash "$repo/install.sh" --dry-run >/dev/null
[[ ! -e $home/.bashrc ]] || fail 'dry-run created .bashrc'

printf '# existing user config\nexport MY_KEEP=1\n' > "$home/.bashrc"
HOME=$home bash "$repo/install.sh" >/dev/null
assert_count 1 '# >>> customize-bash v2 >>>' "$home/.bashrc"
assert_count 1 '# <<< customize-bash v2 <<<' "$home/.bashrc"
assert_count 1 'export MY_KEEP=1' "$home/.bashrc"
[[ -n $(find "$home" -maxdepth 1 -name '.bashrc.customize-bash.bak.*' -print -quit) ]] || fail 'missing install backup'
old_hash=$(sha256sum "$home/.bashrc" | cut -d' ' -f1)
HOME=$home bash "$repo/install.sh" | grep -q 'already up to date' || fail 'second install not idempotent'
[[ $(sha256sum "$home/.bashrc" | cut -d' ' -f1) == "$old_hash" ]] || fail 'install changed .bashrc on rerun'

# The generated snippet works even when the checkout path contains spaces.
HOME=$home XDG_CONFIG_HOME="$home/.config" SSH_CONNECTION='10.0.0.1 2222 10.0.0.2 22' SSH_CLIENT='' SSH_TTY='' TERM=dumb \
    bash --noprofile --norc -c 'source "$HOME/.bashrc"; [[ $CONN == ssh ]] && [[ $MY_KEEP == 1 ]] && alias ll >/dev/null' \
    || fail 'SSH load failed'
HOME=$home XDG_CONFIG_HOME="$home/.config" SSH_CONNECTION='' SSH_CLIENT='' SSH_TTY='' TERM=dumb \
    bash --noprofile --norc -c 'source "$HOME/.bashrc"; [[ $CONN == lcl ]]' \
    || fail 'local load failed'

# Add user module outside the clone; changing profiles must not remove it.
mkdir -p "$home/.config/customize-bash/modules"
printf 'CB_TEST_MODULE_LOADED=yes\n' > "$home/.config/customize-bash/modules/test.sh"
HOME=$home XDG_CONFIG_HOME="$home/.config" SSH_CONNECTION='' SSH_CLIENT='' SSH_TTY='' TERM=dumb \
    bash --noprofile --norc -c 'source "$HOME/.bashrc"; [[ $CB_TEST_MODULE_LOADED == yes ]]' \
    || fail 'user module did not load'

# The old sourced entrypoint stays non-destructive and updates the v2 hook.
HOME=$home bash -c 'f=$1; shift; . "$f"' _ "$repo/customize-bash.sh" >/dev/null 2>&1 || fail 'compat wrapper failed'
assert_count 1 '# >>> customize-bash v2 >>>' "$home/.bashrc"

# Named profiles remain supported.
mkdir -p "$repo/profiles/work"
cp "$repo/profiles/default/bash_customize_profile.sh.dist" "$repo/profiles/work/bash_customize_profile.sh"
printf 'CB_EXTRA_FROM_PROFILE=yes\n' > "$repo/profiles/work/extra.sh"
HOME=$home bash "$repo/install.sh" --profile work >/dev/null
HOME=$home XDG_CONFIG_HOME="$home/.config" SSH_CONNECTION='' SSH_CLIENT='' SSH_TTY='' TERM=dumb \
    bash --noprofile --norc -c 'source "$HOME/.bashrc"; [[ $CB_EXTRA_FROM_PROFILE == yes && $CUSTOMIZE_BASH_PROFILE == work ]]' \
    || fail 'named profile did not load'
assert_count 1 '# >>> customize-bash v2 >>>' "$home/.bashrc"

# Profile validation must not write to ~/.bashrc.
old_hash=$(sha256sum "$home/.bashrc" | cut -d' ' -f1)
if HOME=$home bash "$repo/install.sh" --profile ../escape >/dev/null 2>&1; then fail 'unsafe profile accepted'; fi
[[ $(sha256sum "$home/.bashrc" | cut -d' ' -f1) == "$old_hash" ]] || fail 'invalid profile modified .bashrc'

# Simulate the exact original installer hook and migrate it cleanly.
printf '. %s/.customize-bash/.bash_customize\n' "$home" >> "$home/.bashrc"
HOME=$home bash "$repo/install.sh" >/dev/null
assert_count 0 "$home/.customize-bash/.bash_customize" "$home/.bashrc"
assert_count 1 '# >>> customize-bash v2 >>>' "$home/.bashrc"

# Uninstall removes its own block, not user configuration or modules.
HOME=$home bash "$repo/uninstall.sh" --dry-run >/dev/null
assert_count 1 '# >>> customize-bash v2 >>>' "$home/.bashrc"
HOME=$home bash "$repo/uninstall.sh" >/dev/null
assert_count 0 '# >>> customize-bash v2 >>>' "$home/.bashrc"
assert_count 1 'export MY_KEEP=1' "$home/.bashrc"
[[ -f $home/.config/customize-bash/modules/test.sh ]] || fail 'uninstall deleted a user module'
HOME=$home bash "$repo/uninstall.sh" | grep -q 'already up to date' || fail 'second uninstall not idempotent'

# Malformed markers must abort without damaging configuration.
printf '\n# >>> customize-bash v2 >>>\ntruncated\n' >> "$home/.bashrc"
old_hash=$(sha256sum "$home/.bashrc" | cut -d' ' -f1)
if HOME=$home bash "$repo/install.sh" >/dev/null 2>&1; then fail 'malformed block accepted'; fi
[[ $(sha256sum "$home/.bashrc" | cut -d' ' -f1) == "$old_hash" ]] || fail 'malformed block damaged .bashrc'

printf 'PASS: install, migration, profile, module, dry-run, uninstall and malformed block\n'