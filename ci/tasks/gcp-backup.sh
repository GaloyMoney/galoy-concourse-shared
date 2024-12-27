#!/bin/bash

set -eu

CI_ROOT=$(pwd)
ORG_NAME="GaloyMoney"

cat <<EOF > ${CI_ROOT}/gcloud-creds.json
${GOOGLE_CREDENTIALS}
EOF

gcloud auth activate-service-account --key-file ${CI_ROOT}/gcloud-creds.json

export GH_TOKEN="$(gh-token generate -b "${GH_APP_PRIVATE_KEY}" -i "${GH_APP_ID}" | jq -r '.token')"

# no API keys up to 4,000 private repos.
gh repo list ${ORG_NAME} --limit 4000 | while read -r repo _; do
  gh repo clone "$repo" "$repo"
done

# compress the repo in a tarball
timestamp=$(date +%Y%m%d%H%M%S)
backup_name="${ORG_NAME}-${timestamp}.tar.gz"
tar -czf "${backup_name}" ${ORG_NAME}

gcloud storage cp "${backup_name}" gs://${GOOGLE_BUCKET_NAME}/org_backup/
