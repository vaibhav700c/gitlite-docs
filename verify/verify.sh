#!/usr/bin/env bash
# Start a fresh GitLite server, seed it, run every docs sample, and stop the server.
# Usage: verify/verify.sh <label> [path-to-gitlite-checkout]
set -euo pipefail

label=${1:?label, for example before or after}
src=$(cd "${2:-../gitlite}" && pwd)
work=$(mktemp -d)
api=http://localhost:3000/api/v1

mkdir -p "$work/custom/conf"
cat > "$work/custom/conf/app.ini" <<EOF
APP_NAME = GitLite
RUN_MODE = prod
WORK_PATH = $work
[server]
HTTP_PORT = 3000
ROOT_URL = http://localhost:3000/
DISABLE_SSH = true
OFFLINE_MODE = true
STATIC_ROOT_PATH = $src
[database]
DB_TYPE = sqlite3
PATH = $work/data/gitlite.db
[security]
INSTALL_LOCK = true
[log]
MODE = file
ROOT_PATH = $work/log
EOF

export GITLITE_USER=docs-demo GITLITE_PASSWORD='docs-demo-pass-1!'
"$src/gitea" migrate -c "$work/custom/conf/app.ini" >/dev/null
"$src/gitea" admin user create -c "$work/custom/conf/app.ini" --admin --must-change-password=false \
  --username "$GITLITE_USER" --password "$GITLITE_PASSWORD" --email docs-demo@example.com >/dev/null
GITLITE_TOKEN=$("$src/gitea" admin user generate-access-token -c "$work/custom/conf/app.ini" \
  --username "$GITLITE_USER" --token-name verify --scopes all --raw)
export GITLITE_TOKEN
export GITLITE_AUTH="token $GITLITE_TOKEN"

"$src/gitea" web -c "$work/custom/conf/app.ini" >"$work/server.out" 2>&1 &
server=$!
trap 'kill $server 2>/dev/null; wait $server 2>/dev/null; rm -rf "$work"' EXIT
until curl -sf "$api/version" >/dev/null; do sleep 1; done

post() { curl -sf -o /dev/null -X POST "$api$1" -H "Authorization: token $GITLITE_TOKEN" -H 'Content-Type: application/json' -d "$2"; }
post /user/repos '{"name":"hello-gitlite","auto_init":true}'
for i in $(seq -w 1 34); do post /user/repos "{\"name\":\"seed-repo-$i\"}"; done
post "/repos/$GITLITE_USER/hello-gitlite/issues" '{"title":"Seed issue"}'
post /orgs '{"username":"acme"}'

node verify/run-samples.mjs "$label"
