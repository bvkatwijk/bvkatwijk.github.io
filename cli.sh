#!/bin/bash
set -euox pipefail

CMD=$1

obsidian_to_hugo () {
    rm -rf content/*
    python -m obsidian_to_hugo \
    --obsidian-vault-dir=docs \
    --hugo-content-dir=content
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
