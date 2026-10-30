# Optional, lightweight interactive prompt features.
# No DEBUG trap or PROMPT_COMMAND changes; no external commands unless Git is enabled.

cb_prompt_exit_status() {
    local code=${1:-0}
    if (( code != 0 )); then
        printf ' [!%s]' "$code"
    fi
}

cb_prompt_git_ref() {
    command -v git >/dev/null 2>&1 || return 0
    local ref
    ref=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
    [[ -n $ref ]] && printf ' [%s]' "$ref"
    return 0
}

# Deferred expansion: helpers are evaluated by Bash at prompt display time.
PROMPT_EXTRA=
if [[ ${CUSTOMIZE_BASH_PROMPT_STATUS:-0} == 1 ]]; then
    PROMPT_EXTRA+='$(cb_prompt_exit_status "$?")'
fi
if [[ ${CUSTOMIZE_BASH_PROMPT_GIT:-0} == 1 ]]; then
    PROMPT_EXTRA+='$(cb_prompt_git_ref)'
fi
