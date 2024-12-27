#!/bin/bash

set -eu

export GH_TOKEN="$(ghtoken generate -b "${GH_APP_PRIVATE_KEY}" -i "${GH_APP_ID}" | jq -r '.token')"

pushd source-repo

cat <<EOF >> ../body.md
# Bump Shared Tasks

This PR syncs in this repository, shared CI tasks from [concourse-shared](https://github.com/GaloyMoney/concourse-shared).
EOF

gh pr close ${PR_BRANCH} || true
gh pr create \
  --title "ci(shared): bump vendored ci files" \
  --body-file ../body.md \
  --base ${BRANCH} \
  --head ${PR_BRANCH} \
  --label galoybot
