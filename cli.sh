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
    npx -y pagefind --site public
    hugo server -D
}

cmdPublish () {
    npx -y pagefind --site public
    rm -rf docs/*
    obsidian_to_hugo
    HUGO_ENV=production hugo --destination docs
    echo -n "bvankatwijk.nl" > ./docs/CNAME
}

# Create github issue for blog if no GHissueID frontmatter set
checkBlog () {
    blog=$(echo $1 | cut -d "," -f 1,8,9,10)
    IFS=',' read -r -a array <<< "$blog"
    path="${array[0]}"
    if cat "$path" | grep "GHissueID" > /dev/null ; then
        echo "✅ $path already has issue"
    else
        title=$(echo "${array[0]}" | sed -r 's/content/Article/g' | sed -r 's/\// - /g')
        label="${array[2]},${array[3]}"
        gh label create "${array[2]}" || true
        gh label create "${array[3]}" || true
        gh issue create \
            --title "$title" \
            --body "Issue for article: $title" \
            --label "$label"  
    fi
}

checkBlogs () {
    listBlogs | while read blog ; do
        checkBlog "$blog"
    done
}

cmdIssues () {
    checkBlogs
}

case "$CMD" in
    "run") cmdRun ;;
    "issues") cmdIssues ;;
    "publish") cmdPublish ;;
    *) echo "Unknown command $CMD"; exit 1 ;;
esac
