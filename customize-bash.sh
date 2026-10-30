#!/usr/bin/env bash
# Backwards-compatible entrypoint. The old installer used to delete files.
_cb_legacy_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
printf '%s\n' 'customize-bash: source customize-bash.sh is deprecated; use ./install.sh instead.' >&2
if (($# == 0)); then
    bash "$_cb_legacy_root/install.sh"
elif (($# == 1)) && [[ $1 =~ ^[[:alnum:]_-]+$ ]]; then
    bash "$_cb_legacy_root/install.sh" --profile "$1"
else
    printf '%s\n' 'customize-bash: legacy options (including -f) are not supported; see ./install.sh --help' >&2
    false
fi
_cb_legacy_status=$?
unset _cb_legacy_root
# Return when sourced; exit when executed. Never exit the caller's shell.
return "$_cb_legacy_status" 2>/dev/null || exit "$_cb_legacy_status"
