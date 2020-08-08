#!/bin/bash

SCRIPTS=$(dirname "$(realpath "$0")")
REPODIR="$SCRIPTS/.."

BIN='bundle exec rubocop'
CMD="$BIN --display-cop-names"

if [ -n "$1" ]; then
    args=( "$@" )
else
    cd "$REPODIR" || { echo "Failed to cd to repo root"; exit 1; }
    args=()
fi
# shellcheck disable=SC2086
echo $CMD "${args[@]}"
exec $CMD "${args[@]}"
