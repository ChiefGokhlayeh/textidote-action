#!/usr/bin/env bash

set -e

error() {
  echo "::error :: $1"
  exit 1
}

root_file="${1}"
working_directory="${2}"
report_type="${3}"
report_file="${4}"
threshold_error="${5}"
args="${6}"

IFS=' ' read -r -a args <<< "$args"

if [[ -z "$root_file" ]]; then
  error "Input 'root_file' is missing."
fi

if [[ -n "$working_directory" ]]; then
  cd "$working_directory"
fi

set +e

cmd="/usr/local/bin/textidote --output $report_type ${args[*]} $root_file"
if [[ -z "$report_file" ]]; then
  eval "${cmd[@]}"
else
  eval "${cmd[@]}" > "$report_file"
fi
textidote_exit="$?"

echo "Linter counted $textidote_exit warnings."

set -e

if [[ "$threshold_error" > -1 ]] && [[ "$threshold_error" < "$textidote_exit" ]]; then
  echo "Linter warnings above error threshold ($textidote_exit > $threshold_error)!"
  exit "$textidote_exit"
fi
