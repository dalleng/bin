#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <PR_NUMBER> [<COMMIT_SHA1> <COMMIT_SHA2> ...]"
    exit 1
fi

PR_NUMBER=$1
REPO="brighthire/brighthire"  # Replace with your repo
shift
COMMITS=("$@")

echo "Pull Request #$PR_NUMBER"
echo

if [ ${#COMMITS[@]} -eq 0 ]; then
    echo "Commits:"
    gh api repos/$REPO/pulls/$PR_NUMBER/commits | jq -r '.[] | "- \(.sha[0:7]): \(.commit.message)"'
    echo

    echo "Changes:"
    gh api repos/$REPO/pulls/$PR_NUMBER/files | jq -r '.[] | "File: \(.filename)\n\(.patch // "No changes available (binary or large file)")\n"'
else
    echo "Specified Commits:"
    for COMMIT in "${COMMITS[@]}"; do
        gh api repos/$REPO/commits/$COMMIT | jq -r '"- \(.sha[0:7]): \(.commit.message)"'
    done
    echo

    echo "Changes for specified commits:"
    for COMMIT in "${COMMITS[@]}"; do
        echo "Commit: $COMMIT"
        gh api repos/$REPO/commits/$COMMIT | jq -r '.files[] | "File: \(.filename)\n\(.patch // "No changes available (binary or large file)")\n"'
        echo
    done
fi