#!/usr/bin/env bash
# Manage only the customize-bash block in ~/.bashrc.
set -euo pipefail

usage() {
    printf 'Usage: %s [--dry-run]%s\n' "$command_name" "$([[ $action == install ]] && printf ' [--profile NAME]')"
    printf '%s\n' 'Manage customize-bash in ~/.bashrc (without sourcing ~/.bashrc).'
}

fail() { printf 'customize-bash: %s\n' "$*" >&2; exit 1; }

[[ $# -ge 1 ]] || fail 'missing action'
action=$1
shift
[[ $action == install || $action == uninstall ]] || fail 'invalid action'
command_name="./${action}.sh"
dry_run=false
profile=default
while (($#)); do
    case $1 in
        --dry-run) dry_run=true; shift ;;
        --profile)
            [[ $action == install ]] || fail '--profile is only supported by install.sh'
            [[ $# -ge 2 ]] || fail '--profile requires a name'
            profile=$2; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) fail "unknown argument: $1" ;;
    esac
done

[[ -n ${HOME:-} ]] || fail 'HOME is not set'
[[ -d $HOME ]] || fail 'HOME directory does not exist'
# The installer wrappers are inside the cloned repository.
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
if [[ $action == install ]]; then
    [[ $profile =~ ^[[:alnum:]_-]+$ ]] || fail 'invalid profile name'
    [[ -d $repo_dir/profiles/$profile ]] || fail "profile not found: $profile"
    [[ -f $repo_dir/init.sh ]] || fail 'init.sh not found'
fi

rc=$HOME/.bashrc
[[ ! -L $rc ]] || fail 'refusing to replace a symlinked ~/.bashrc'
[[ ! -e $rc || -f $rc ]] || fail '.bashrc is not a regular file'
if [[ -f $rc && ! -r $rc ]]; then fail '.bashrc is not readable'; fi

begin='# >>> customize-bash v2 >>>'
end='# <<< customize-bash v2 <<<'
temp=$(mktemp "${rc}.customize-bash.XXXXXXXX")
cleanup() { rm -f -- "$temp"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Keep the existing ~/.bashrc file mode intact.
if [[ -f $rc ]]; then cp -p -- "$rc" "$temp"; fi

render() {
    local line inside=false seen=false
    if [[ -f $rc ]]; then
        while IFS= read -r line || [[ -n $line ]]; do
            if [[ $line == "$begin" ]]; then
                [[ $inside == false && $seen == false ]] || fail 'duplicate or nested customize-bash block'
                inside=true
                seen=true
                continue
            fi
            if [[ $line == "$end" ]]; then
                [[ $inside == true ]] || fail 'orphan customize-bash block end marker'
                inside=false
                continue
            fi
            if [[ $inside == true ]]; then continue; fi
            # Migrate the exact hook inserted by the original 2017 installer.
            # Do not remove the old installation directory or user customizations.
            if [[ $action == install && ( $line == ". $HOME/.customize-bash/.bash_customize" || $line == "source $HOME/.customize-bash/.bash_customize" ) ]]; then
                continue
            fi
            printf '%s\n' "$line"
        done < "$rc"
        [[ $inside == false ]] || fail 'unterminated customize-bash block'
    fi
    if [[ $action == install ]]; then
        local quoted_init
        printf -v quoted_init '%q' "$repo_dir/init.sh"
        printf '%s\n' "$begin"
        printf 'CUSTOMIZE_BASH_PROFILE=%q\n' "$profile"
        printf 'if [[ -f %s ]]; then\n    . %s\nfi\n' "$quoted_init" "$quoted_init"
        printf '%s\n' "$end"
    fi
}

# Build the full candidate in a temporary file first. Invalid blocks never touch ~/.bashrc.
render > "$temp"
if [[ -f $rc ]] && cmp -s -- "$temp" "$rc"; then
    echo 'customize-bash: already up to date'
    exit 0
fi
if [[ $action == uninstall && ! -f $rc ]]; then
    echo 'customize-bash: nothing to uninstall'
    exit 0
fi
if [[ $dry_run == true ]]; then
    rc_before=$rc
    [[ -f $rc ]] || rc_before=/dev/null
    echo 'customize-bash: dry run (no changes made)'
    diff -u -- "${rc_before}" "$temp" || [[ $? == 1 ]]
    exit 0
fi

if [[ -f $rc ]]; then
    backup="${rc}.customize-bash.bak.$(date +%Y%m%d%H%M%S).$$"
    cp -p -- "$rc" "$backup"
    printf 'customize-bash: backup: %s\n' "$backup"
fi
mv -f -- "$temp" "$rc"
printf 'customize-bash: %s complete (%s)\n' "$action" "$rc"
if [[ $action == install ]]; then
    echo 'customize-bash: start a new Bash session to load the configuration'
else
    echo 'customize-bash: existing shells retain their current aliases until restarted'
fi
