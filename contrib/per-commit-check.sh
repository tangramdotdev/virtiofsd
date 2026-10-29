#!/bin/sh
# Check that every commit in a range builds, passes tests, and has
# no lint or formatting issues.
#
# Usage: contrib/per-commit-check.sh [BASE]
#
# BASE defaults to the merge base between the current branch and main.
# In CI, pass CI_MERGE_REQUEST_DIFF_BASE_SHA.
#
# Set CARGO_BUILD_TARGET to build for a specific target.

set -eu

BASE="${1:-$(git merge-base main HEAD)}"
ORIGINAL_REF=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || git rev-parse HEAD)

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "ERROR: working tree has uncommitted changes. Commit or stash them first."
    exit 1
fi

trap 'git checkout --quiet "${ORIGINAL_REF}"' EXIT

COMMITS=$(git rev-list --reverse "${BASE}..HEAD")
if [ -z "${COMMITS}" ]; then
    echo "ERROR: no commits found in range ${BASE}..HEAD"
    exit 1
fi

for COMMIT in ${COMMITS}; do
    echo "Checking $(git log -1 --format='%h %s' "${COMMIT}")"
    git checkout --quiet "${COMMIT}"

    if [ "${PREV_COMMIT:-}" ] && ! git diff --quiet "${PREV_COMMIT}" -- Cargo.lock 2>/dev/null; then
        cargo clean
    fi

    cargo fmt -- --check
    cargo build --locked
    cargo test --locked
    cargo clippy --locked -- -Dwarnings -Aclippy::manual-c-str-literals

    if ! git diff --quiet; then
        echo "ERROR: commit ${COMMIT} modified tracked files during build"
        git diff --name-only
        exit 1
    fi

    PREV_COMMIT="${COMMIT}"
done

echo "All commits OK"
