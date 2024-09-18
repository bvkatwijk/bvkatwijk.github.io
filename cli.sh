#!/bin/bash
set -euo pipefail

CMD=$1

cmdRun () {
    hugo server -D
}

cmdPublish () {
    python -m obsidian_to_hugo \
    --obsidian-vault-dir=docs \
    --hugo-content-dir=content/blog
    hugo --destination site
}

case $CMD in
    "run") cmdRun ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
