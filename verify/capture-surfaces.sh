#!/usr/bin/env bash
# Save raw copies of the agent-facing surfaces of a docs site.
# Usage: verify/capture-surfaces.sh <site-origin> <out-dir>
# Example: verify/capture-surfaces.sh https://gitlite.thally.app ../evidence/surfaces/before
set -euo pipefail

site=${1:?site origin}
out=${2:?output directory}
mkdir -p "$out"

mcp() {
  curl -s -X POST "$site/api/mcp" -H 'Content-Type: application/json' \
    -H 'Accept: application/json, text/event-stream' -d "$1"
}

curl -s "$site/llms.txt" >"$out/llms.txt"
curl -s "$site/authentication.md" >"$out/authentication.md"
curl -s "$site/pagination.md" >"$out/pagination.md"
curl -s "$site/api/agent-readiness" >"$out/agent-readiness.json"
mcp '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"search_docs","arguments":{"query":"how do I authenticate with the GitLite API?"}}}' >"$out/mcp-search-authenticate.json"
mcp '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"read_page","arguments":{"pageId":"authentication"}}}' >"$out/mcp-read-authentication.json"
mcp '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"read_page","arguments":{"pageId":"pagination"}}}' >"$out/mcp-read-pagination.json"

{
  echo "site: $site"
  echo "captured_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "files:"
  for f in "$out"/*; do [ "$(basename "$f")" = capture.txt ] || echo "  - $(basename "$f") $(shasum -a 256 "$f" | cut -c1-16)"; done
} >"$out/capture.txt"

echo "Authorization scheme mentions:"
grep -ho 'Authorization: [A-Za-z]*' "$out/authentication.md" "$out/mcp-read-authentication.json" | sort | uniq -c
echo "Default page size mentions:"
grep -ho 'default of `[0-9]*`\|| `limit` | integer | `[0-9]*`' "$out/pagination.md" | sort | uniq -c
