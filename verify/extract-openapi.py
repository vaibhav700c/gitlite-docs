#!/usr/bin/env python3
"""Extract the documented subset of the GitLite OpenAPI 3 spec into openapi.json.

Usage: python3 verify/extract-openapi.py ../gitlite && node verify/json-to-yaml.mjs
"""
import json
import sys

KEEP = [
    "/version",
    "/settings/api",
    "/user",
    "/user/repos",
    "/users/{username}/tokens",
    "/repos/{owner}/{repo}",
    "/repos/{owner}/{repo}/issues",
    "/repos/{owner}/{repo}/issues/{index}",
    "/repos/{owner}/{repo}/hooks",
    "/orgs",
    "/orgs/{org}",
    "/orgs/{org}/repos",
]

product = sys.argv[1] if len(sys.argv) > 1 else "../gitlite"
raw = open(f"{product}/templates/swagger/v1_openapi3_json.tmpl").read()
raw = raw.replace("{{.SwaggerAppSubUrl}}", "").replace("{{.SwaggerAppVer}}", "1.27.3")
spec = json.loads(raw)
comps = spec["components"]
paths = {p: spec["paths"][p] for p in KEEP}

needed = set()


def walk(node):
    if isinstance(node, dict):
        for key, value in node.items():
            if key == "$ref":
                _, _, kind, name = value.split("/")
                if (kind, name) not in needed:
                    needed.add((kind, name))
                    walk(comps[kind][name])
            else:
                walk(value)
    elif isinstance(node, list):
        for value in node:
            walk(value)


walk(paths)
out = {
    "openapi": spec["openapi"],
    "info": {
        "title": "GitLite API",
        "version": "1.27.3",
        "description": "Subset of the GitLite API covered by these docs. Extracted from templates/swagger/v1_openapi3_json.tmpl in the gitlite repository.",
        "license": spec["info"]["license"],
    },
    "servers": [{"url": "http://localhost:3000/api/v1"}],
    "security": spec.get("security", []),
    "paths": paths,
    "components": {"securitySchemes": comps["securitySchemes"]},
}
for kind, name in sorted(needed):
    out["components"].setdefault(kind, {})[name] = comps[kind][name]

json.dump(out, open("openapi.json", "w"), indent=2)
print(f"{len(paths)} paths, {len(needed)} components")
