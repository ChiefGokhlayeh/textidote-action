#!/usr/bin/env bash

: error MSG CODE
error() {
    echo "::error ::$1"
    exit "${2:-1}"
}

root_file="$1"
working_directory="$2"
report_type="$3"
report_file="$4"
threshold_error="$5"
args="$6"

IFS=' ' read -r -a args <<<"$args"

if [[ -z "$report_type" ]]; then
    report_type='plain'
fi

cmd="/usr/local/bin/textidote --output $report_type ${args[*]}"
if [[ -z "$root_file" ]]; then
    error "Input ROOT_FILE missing! Please spcify valid file path to document which shall be checked (or '-' to read from stdin)."
fi

if [[ "$root_file" != '-' ]]; then
    cmd="$cmd $root_file"
fi

if [[ -n "$working_directory" ]]; then
    cd "$working_directory" || error "Unable to cd into WORKING_DIR (=$working_directory)! Make sure directory exists and is accessible."
fi

if [[ -n "$report_file" ]]; then
    cmd="$cmd > $report_file"
fi

{
    IFS=$'\n' read -r -d '' stderr
    cat -
} < <((printf '\0%s\n' "$(eval "$cmd")" 1>&2) 2>&1)

num_warnings="$( (echo "$stderr" | grep -Po 'Found \K[0-9]* warning\(s\)' | grep -o '[0-9]*') || echo "-1")"

echo "::set-output name=num_warnings::$num_warnings"

if [[ "$num_warnings" -lt 0 ]]; then
    error "$(printf 'Unable to parse warnings from TeXtidote stderr! See what was returned below:\n%s' "$stderr")"
fi

if [[ "$threshold_error" > -1 ]] && [[ "$threshold_error" < "$num_warnings" ]]; then
    error "Linter warnings above error threshold ($num_warnings > $threshold_error)!" "$num_warnings"
fi
