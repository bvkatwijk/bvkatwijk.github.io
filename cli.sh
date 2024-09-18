#!/bin/bash
set -euo pipefail

CMD=$1

cmdRun () {
    hugo server -D
}

case $CMD in
    "run") cmdRun ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac