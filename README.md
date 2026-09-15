# GitLite Docs

**The product documented here is [GitLite](https://github.com/vaibhav700c/gitlite), a fork of
[Gitea](https://github.com/go-gitea/gitea), an existing MIT-licensed open-source project.
GitLite is not affiliated with or endorsed by Gitea. What this project built is the
documentation system in this repository and its Thally Track integration, which detects
product changes in GitLite and opens evidence-backed documentation pull requests.**

Built for the Thally Sync Hackathon 2026, "Keep Product Knowledge Current" track.

## What is in this repository

| Path | Purpose |
| --- | --- |
| `src/content/` | 13 MDX pages. Every example reads the `Authorization` header from `GITLITE_AUTH`, so an auth-scheme change edits one line per home page, not every sample: quickstart, authentication, pagination, three API reference pages, four guides, `[api]` configuration reference, changelog, introduction. |
| `docs.json` | Navigation (Getting Started, Guides, Reference) and site features. |
| `verify/` | Runs every `curl` and JavaScript example against a fresh, seeded GitLite server. |

Every page carries `lastVerified`, `verifiedVersion`, and internal `sources` /
`verifiedCommit` frontmatter that point at the GitLite source files and commit the
page was checked against. The internal keys are stripped from every public output.

## Verify the examples

Build GitLite first (`TAGS="sqlite sqlite_unlock_notify" make backend` in a sibling
`gitlite` checkout), then:

```bash
verify/verify.sh before ../gitlite
```

The script starts a throwaway server on port 3000, seeds a user, token, repositories,
an issue, and an organization, runs every sample in navigation order, and writes
`verify/report-<label>.md`. Pages that document failures (`guides/errors`) may
return `401` and `404`; every other sample must return `2xx`.

## Run the site locally

```bash
npm install
npm run dev
```

Open [http://localhost:3040](http://localhost:3040).

## Validate changes

```bash
npm test
npm run build
npm ci --ignore-scripts --prefix .github/thally-tooling
.github/thally-tooling/node_modules/.bin/thally check --ci .
```

## Credits and license

Scaffolded with `create-thally-docs` 0.10.37. Site code is MIT licensed; see
[LICENSE](LICENSE). GitLite and Gitea are MIT licensed; see the
[GitLite NOTICE](https://github.com/vaibhav700c/gitlite/blob/main/NOTICE.md).
