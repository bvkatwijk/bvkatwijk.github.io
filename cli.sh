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
    gh issue create \
        --title "I found a bug" \
        --body "Nothing works" \
        --label "bug,help wanted"
}

listIssues() {
    gh issue list
}

listBlogs() {
    hugo list published | grep /Blog/
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

checkBlog () {
    blog=$1
    echo =$blog=
}

checkBlogs () {
    listBlogs | while read blog ; do
        checkBlog "$blog"
    done
}

cmdCheck () {
    checkBlogs
    # for blog 
    #     | cut -d "," -f 1,8,9,10
    #     # \
    #     # | sed -r 's/content/Article/g' \
    #     # | sed -r 's/\// - /g'
}

case $CMD in
    "run") cmdRun ;;
    "issues") listIssues ;;
    "check") cmdCheck ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
