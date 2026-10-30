#!/usr/bin/env bash
# This script must be sourced from an interactive Bash startup file.
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    printf 'customize-bash: source init.sh instead of executing it\n' >&2
    exit 1
fi

_cb_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
_cb_profile=${CUSTOMIZE_BASH_PROFILE:-default}
if [[ ! $_cb_profile =~ ^[[:alnum:]_-]+$ || ! -d $_cb_root/profiles/$_cb_profile ]]; then
    printf 'customize-bash: invalid or missing profile: %s\n' "$_cb_profile" >&2
    unset _cb_root _cb_profile
    return 1
fi
_cb_profile_dir=$_cb_root/profiles/$_cb_profile
_cb_config_dir=${XDG_CONFIG_HOME:-$HOME/.config}/customize-bash

# Order matters: colors, profile settings, prompt, aliases, extra modules.
. "$_cb_root/core/bash_customize_colors.sh"
if [[ -f $_cb_config_dir/profile.sh ]]; then
    . "$_cb_config_dir/profile.sh"
elif [[ -f $_cb_profile_dir/bash_customize_profile.sh ]]; then
    . "$_cb_profile_dir/bash_customize_profile.sh"
elif [[ -f $_cb_profile_dir/bash_customize_profile.sh.dist ]]; then
    . "$_cb_profile_dir/bash_customize_profile.sh.dist"
else
    printf 'customize-bash: missing profile settings for %s\n' "$_cb_profile" >&2
    unset _cb_root _cb_profile _cb_profile_dir _cb_config_dir
    return 1
fi
. "$_cb_root/core/bash_customize_prompt_extras.sh"
. "$_cb_root/core/bash_customize_prompt_colors.sh"
. "$_cb_root/core/bash_customize_shell.sh"

for _cb_file in "$_cb_profile_dir"/*.sh; do
    [[ -f $_cb_file ]] || continue
    case ${_cb_file##*/} in
        bash_customize_profile.sh|bash_customize.sh) continue ;;
    esac
    . "$_cb_file"
done
# Machine-specific modules can live outside the Git clone.
for _cb_file in "$_cb_config_dir"/modules/*.sh; do
    [[ -f $_cb_file ]] || continue
    . "$_cb_file"
done
unset _cb_file _cb_root _cb_profile _cb_profile_dir _cb_config_dir
