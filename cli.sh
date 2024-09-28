#!/bin/bash
set -euo pipefail

OWNER_REPO=bvkatwijk/bvkatwijk.github.io

set -a; source .env; set +a

CMD=$1

obsidian_to_hugo () {
    rm -rf content/
    mkdir content/
    python -m obsidian_to_hugo \
    --obsidian-vault-dir=vault \
    --hugo-content-dir=content
}

createIssue () {
    curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/${OWNER_REPO}/issues \
        -d '{"title":"Found a bug","body":"I'\''m having a problem with this.","labels":["bug"]}'
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

cmdCheck () {
    hugo list published \
        | cut -d "," -f 1 \
        | grep Blog \
        | sed -r 's/content/Article/g' \
        | sed -r 's/\// - /g'
}

case $CMD in
    "run") cmdRun ;;
    "issue") createIssue ;;
    "check") cmdCheck ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
