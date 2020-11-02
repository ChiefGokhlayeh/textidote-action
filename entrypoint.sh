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
args="${5}"

IFS=' ' read -r -a args <<< "$args"

if [[ -z "$root_file" ]]; then
  error "Input 'root_file' is missing."
fi

if [[ -n "$working_directory" ]]; then
  cd "$working_directory"
fi

exec /usr/local/bin/textidote --output "$report_type" "${args[@]}" "$root_file" > "$report_file"
