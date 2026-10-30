#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

unset CUSTOMIZE_BASH_PROMPT_GIT CUSTOMIZE_BASH_PROMPT_STATUS
source "$root/core/bash_customize_prompt_extras.sh"
[[ -z $PROMPT_EXTRA ]] || fail 'prompt extras were not disabled by default'
[[ -z $(cb_prompt_exit_status 0) ]] || fail 'status 0 was displayed'
[[ $(cb_prompt_exit_status 127) == ' [!127]' ]] || fail 'wrong status marker'

if command -v git >/dev/null 2>&1; then
    testroot=$(mktemp -d)
    trap 'rm -rf -- "$testroot"' EXIT
    (cd "$testroot" && [[ -z $(cb_prompt_git_ref) ]]) || fail 'Git marker displayed outside a repository'
    git -C "$testroot" init -q -b testbranch
    [[ $(cd "$testroot" && cb_prompt_git_ref) == ' [testbranch]' ]] || fail 'Git branch not displayed'
    rm -rf -- "$testroot"
    trap - EXIT
fi

export CUSTOMIZE_BASH_PROMPT_GIT=1 CUSTOMIZE_BASH_PROMPT_STATUS=1
source "$root/core/bash_customize_prompt_extras.sh"
[[ $PROMPT_EXTRA == *'cb_prompt_exit_status'* ]] || fail 'missing status hook'
[[ $PROMPT_EXTRA == *'cb_prompt_git_ref'* ]] || fail 'missing Git hook'
[[ $PROMPT_EXTRA == *'"$?"'* ]] || fail 'status hook not deferred until prompt expansion'
printf 'PASS: optional prompt features, errors and Git branch\n'

# A small user override must preserve default color/profile definitions.
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p "$fixture/.config/customize-bash"
printf 'CUSTOMIZE_BASH_PROMPT_GIT=1\n' > "$fixture/.config/customize-bash/profile.sh"
HOME="$fixture" XDG_CONFIG_HOME="$fixture/.config" TERM=dumb SSH_CONNECTION='' SSH_CLIENT='' SSH_TTY='' \
    bash --noprofile --norc -c 'source "$1/init.sh"; [[ -n ${LOCAL_COLOR:-} && $PROMPT_EXTRA == *cb_prompt_git_ref* ]]' _ "$root" \
    || fail 'user overrides lost the selected profile defaults'
