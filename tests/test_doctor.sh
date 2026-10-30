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

if HOME=$home bash "$repo/doctor.sh" >/dev/null 2>&1; then
    fail 'doctor accepted a missing installation'
fi
HOME=$home bash "$repo/install.sh" >/dev/null
HOME=$home bash "$repo/doctor.sh" | grep -q 'all required checks passed' || fail 'doctor rejected a valid install'
HOME=$home bash "$repo/customize-bash" doctor | grep -q 'all required checks passed' || fail 'doctor subcommand failed'

# Diagnosis must not source arbitrary user startup scripts.
mkdir -p "$home/.config/customize-bash"
printf 'touch "$HOME/doctor-should-not-run"\n' > "$home/.config/customize-bash/profile.sh"
HOME=$home bash "$repo/doctor.sh" >/dev/null || fail 'doctor rejected a user profile override'
[[ ! -e $home/doctor-should-not-run ]] || fail 'doctor executed user configuration'

# Check that broken checkout paths are detected.
sed -i 's@init.sh@missing.sh@g' "$home/.bashrc"
if HOME=$home bash "$repo/doctor.sh" >/dev/null 2>&1; then
    fail 'doctor missed a broken checkout path'
fi
printf 'PASS: doctor installation, diagnostics, read-only safety and broken paths\n'
