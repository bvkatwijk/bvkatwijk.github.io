#!/bin/bash
set -euox pipefail

set -a; source .env; set +a

CMD=$1

obsidian_to_hugo () {
    rm -rf content/
    mkdir content/
    python -m obsidian_to_hugo \
    --obsidian-vault-dir=vault \
    --hugo-content-dir=content
}

cmdRun () {
    obsidian_to_hugo
    hugo server -D
}

cmdPublish () {
    rm -rf docs/*
    obsidian_to_hugo
    HUGO_ENV=production hugo --destination docs
}

case $CMD in
    "run") cmdRun ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
