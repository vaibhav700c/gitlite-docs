# Example verification: before

Captured 2026-09-14T20:31:12.643Z against {"version":"1.27.3"}. 49/49 passed.

| Page | # | Lang | Command | Exit | Status | Result |
| --- | --- | --- | --- | --- | --- | --- |
| quickstart | 1 | bash | `curl -s http://localhost:3000/api/v1/user \` | 0 | 200 | pass |
| quickstart | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/user', {` | 0 | 200 | pass |
| quickstart | 3 | bash | `curl -s -X POST http://localhost:3000/api/v1/user/repos \` | 0 | 201 | pass |
| quickstart | 4 | js | `const res = await fetch('http://localhost:3000/api/v1/user/repos', {` | 0 | 201 | pass |
| authentication | 1 | bash | `curl -s http://localhost:3000/api/v1/user \` | 0 | 200 | pass |
| authentication | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/user', {` | 0 | 200 | pass |
| authentication | 3 | bash | `curl -s -X POST "http://localhost:3000/api/v1/users/$GITLITE_USER/toke` | 0 | 201 | pass |
| authentication | 4 | js | `const { GITLITE_USER, GITLITE_PASSWORD } = process.env` | 0 | 201 | pass |
| pagination | 1 | bash | `curl -s http://localhost:3000/api/v1/settings/api \` | 0 | 200 | pass |
| pagination | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/settings/api', {` | 0 | 200 | pass |
| pagination | 3 | bash | `curl -s -D - -o /dev/null "http://localhost:3000/api/v1/user/repos?pag` | 0 | 200 | pass |
| pagination | 4 | js | `let url = 'http://localhost:3000/api/v1/user/repos?limit=50'` | 0 | 200 | pass |
| guides/errors | 1 | bash | `curl -s -w "\n%{http_code}\n" http://localhost:3000/api/v1/user` | 0 | 401, 401 | pass |
| guides/errors | 2 | js | `for (const headers of [{}, { Authorization: 'token 0000000000000000000` | 0 | 401, 401 | pass |
| guides/errors | 3 | bash | `status=$(curl -s -o response.json -w "%{http_code}" \` | 0 | 404 | pass |
| guides/errors | 4 | js | `async function gitlite(path, init = {}) {` | 0 | 404 | pass |
| guides/rate-limits | 1 | bash | `curl -s "http://localhost:3000/api/v1/user/repos?limit=1000" \` | 0 | 200 | pass |
| guides/rate-limits | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/user/repos?limit` | 0 | 200 | pass |
| guides/webhooks | 1 | bash | `curl -s -X POST "http://localhost:3000/api/v1/repos/$GITLITE_USER/hell` | 0 | 201 | pass |
| guides/webhooks | 2 | js | `const owner = process.env.GITLITE_USER` | 0 | 201 | pass |
| guides/deployment | 1 | bash | `curl -s http://localhost:3000/api/v1/version` | 0 | 200 | pass |
| api/repositories | 1 | bash | `curl -s "http://localhost:3000/api/v1/user/repos?limit=5" \` | 0 | 200 | pass |
| api/repositories | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/user/repos?limit` | 0 | 200 | pass |
| api/repositories | 3 | bash | `curl -s -X POST http://localhost:3000/api/v1/user/repos \` | 0 | 201 | pass |
| api/repositories | 4 | js | `const res = await fetch('http://localhost:3000/api/v1/user/repos', {` | 0 | 201 | pass |
| api/repositories | 5 | bash | `curl -s "http://localhost:3000/api/v1/repos/$GITLITE_USER/hello-gitlit` | 0 | 200 | pass |
| api/repositories | 6 | js | `const owner = process.env.GITLITE_USER` | 0 | 200 | pass |
| api/repositories | 7 | bash | `curl -s -X PATCH "http://localhost:3000/api/v1/repos/$GITLITE_USER/hel` | 0 | 200 | pass |
| api/repositories | 8 | js | `const owner = process.env.GITLITE_USER` | 0 | 200 | pass |
| api/repositories | 9 | bash | `curl -s -o /dev/null -w "%{http_code}\n" -X DELETE \` | 0 | 204 | pass |
| api/repositories | 10 | js | `const owner = process.env.GITLITE_USER` | 0 | 204 | pass |
| api/issues | 1 | bash | `curl -s "http://localhost:3000/api/v1/repos/$GITLITE_USER/hello-gitlit` | 0 | 200 | pass |
| api/issues | 2 | js | `const owner = process.env.GITLITE_USER` | 0 | 200 | pass |
| api/issues | 3 | bash | `curl -s -X POST "http://localhost:3000/api/v1/repos/$GITLITE_USER/hell` | 0 | 201 | pass |
| api/issues | 4 | js | `const owner = process.env.GITLITE_USER` | 0 | 201 | pass |
| api/issues | 5 | bash | `curl -s "http://localhost:3000/api/v1/repos/$GITLITE_USER/hello-gitlit` | 0 | 200 | pass |
| api/issues | 6 | js | `const owner = process.env.GITLITE_USER` | 0 | 200 | pass |
| api/issues | 7 | bash | `curl -s -X PATCH "http://localhost:3000/api/v1/repos/$GITLITE_USER/hel` | 0 | 201 | pass |
| api/issues | 8 | js | `const owner = process.env.GITLITE_USER` | 0 | 201 | pass |
| api/organizations | 1 | bash | `curl -s "http://localhost:3000/api/v1/orgs?limit=10" \` | 0 | 200 | pass |
| api/organizations | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/orgs?limit=10', ` | 0 | 200 | pass |
| api/organizations | 3 | bash | `curl -s -X POST http://localhost:3000/api/v1/orgs \` | 0 | 201 | pass |
| api/organizations | 4 | js | `const res = await fetch('http://localhost:3000/api/v1/orgs', {` | 0 | 201 | pass |
| api/organizations | 5 | bash | `curl -s http://localhost:3000/api/v1/orgs/acme \` | 0 | 200 | pass |
| api/organizations | 6 | js | `const res = await fetch('http://localhost:3000/api/v1/orgs/acme', {` | 0 | 200 | pass |
| api/organizations | 7 | bash | `curl -s "http://localhost:3000/api/v1/orgs/acme/repos?page=1&limit=20"` | 0 | 200 | pass |
| api/organizations | 8 | js | `const res = await fetch('http://localhost:3000/api/v1/orgs/acme/repos?` | 0 | 200 | pass |
| reference/configuration-api | 1 | bash | `curl -s http://localhost:3000/api/v1/settings/api \` | 0 | 200 | pass |
| reference/configuration-api | 2 | js | `const res = await fetch('http://localhost:3000/api/v1/settings/api', {` | 0 | 200 | pass |
