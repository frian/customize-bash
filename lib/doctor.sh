#!/usr/bin/env bash
# Read-only diagnosis. Never source a user's shell startup file or config.
set -uo pipefail

if (($#)); then
    if [[ $# == 1 && ( $1 == --help || $1 == -h ) ]]; then
        printf 'Usage: ./doctor.sh (read-only Bash installation diagnosis)\n'
        exit 0
    fi
    printf 'customize-bash doctor: unknown argument\n' >&2
    exit 2
fi

problems=0
ok() { printf '[OK] %s\n' "$*"; }
warning() { printf '[WARN] %s\n' "$*"; }
error() { printf '[FAIL] %s\n' "$*"; (( problems += 1 )); }

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
printf 'customize-bash doctor — Bash %s\n' "$BASH_VERSION"
for file in init.sh core/bash_customize_colors.sh core/bash_customize_prompt_extras.sh core/bash_customize_prompt_colors.sh core/bash_customize_shell.sh; do
    if [[ -r $repo_dir/$file ]]; then
        ok "Available: $file"
    else
        error "Missing or unreadable: $file"
    fi
done

if [[ ! -d ${HOME:-} ]]; then
    error 'HOME missing or invalid'
    printf '%s error(s) detected\n' "$problems"
    exit 1
fi

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}/customize-bash
rc=$HOME/.bashrc
begin='# >>> customize-bash v2 >>>'
end='# <<< customize-bash v2 <<<'
if [[ ! -f $rc || ! -r $rc ]]; then
    error '.bashrc missing or unreadable'
else
    begins=0
    ends=0
    inside=false
    path_found=false
    profile_line=
    printf -v expected_init '%q' "$repo_dir/init.sh"
    while IFS= read -r line || [[ -n $line ]]; do
        if [[ $line == "$begin" ]]; then
            (( begins += 1 ))
            inside=true
        elif [[ $line == "$end" ]]; then
            (( ends += 1 ))
            inside=false
        elif [[ $inside == true ]]; then
            if [[ $line == *"$expected_init"* ]]; then path_found=true; fi
            if [[ $line == CUSTOMIZE_BASH_PROFILE=* ]]; then
                profile_line=${line#CUSTOMIZE_BASH_PROFILE=}
            fi
        elif [[ $line == *'.customize-bash/.bash_customize'* ]]; then
            warning 'Legacy v1 startup hook detected (review before migration)'
        fi
    done < "$rc"

    if (( begins == 1 && ends == 1 )) && [[ $inside == false ]]; then
        ok 'One complete v2 hook in .bashrc'
    else
        error "Invalid v2 hook markers: $begins start(s), $ends end(s)"
    fi
    if [[ $path_found == true ]]; then
        ok 'Hook points to this checkout'
    else
        error 'Hook does not point to this checkout (reinstall from its current location)'
    fi

    if [[ $profile_line =~ ^[[:alnum:]_-]+$ && -d $repo_dir/profiles/$profile_line ]]; then
        if [[ -f $config_dir/profile.sh || -f $repo_dir/profiles/$profile_line/bash_customize_profile.sh || -f $repo_dir/profiles/$profile_line/bash_customize_profile.sh.dist ]]; then
            ok "Installed profile: $profile_line"
        else
            error "Profile settings missing for $profile_line"
        fi
    else
        error "Installed profile invalid or unavailable: ${profile_line:-<missing>}"
    fi
fi

if [[ -f $config_dir/profile.sh ]]; then
    ok "User profile override available: $config_dir/profile.sh"
else
    ok 'No user profile override (using repository profile)'
fi
count=0
for file in "$config_dir"/modules/*.sh; do
    [[ -f $file ]] || continue
    (( count += 1 ))
done
ok "$count user module(s) available"
if [[ -d $HOME/.customize-bash ]]; then
    warning 'Old .customize-bash directory preserved (not deleted)'
fi

if (( problems > 0 )); then
    printf 'customize-bash doctor: %s issue(s) detected\n' "$problems"
    exit 1
fi
printf 'customize-bash doctor: all required checks passed\n'
