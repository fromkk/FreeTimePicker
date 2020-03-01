#!/bin/sh

function usage() {
    cat <<EOF
$(basename ${0}) is a tool for git-tag
Usage:
  $(basename ${0}) [version_string] [message]
  e.g.
  $(basename ${0}) "2.5" "Add awesome feature"
version_string:
  e.g. "1.0" "2.5"
EOF
}

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

MESSAGE=$2
VERSION=$1
COMMIT=$((`git log --oneline | wc -l | sed -e 's/ *//g'`))

git tag -am "$MESSAGE" "$VERSION($COMMIT)"

exit 0

