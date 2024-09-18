#!/bin/bash
set -euox pipefail

CMD=$1

obsidian_to_hugo () {
    mkdir -p content/blog
    python -m obsidian_to_hugo \
    --obsidian-vault-dir=docs \
    --hugo-content-dir=content/blog
}

cmdRun () {
    obsidian_to_hugo
    hugo server -D
}

cmdPublish () {
    obsidian_to_hugo
    hugo --destination site
}

case $CMD in
    "run") cmdRun ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
