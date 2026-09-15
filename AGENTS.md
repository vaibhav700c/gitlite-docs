# Documentation project instructions

## Repository role

Thally has three distinct repositories. `thallylabs/thally` is the only
authored source for the open-source runtime and toolchain,
`thallylabs/starter` is this complete customer-ready template, and
`thallylabs/thally-cloud` is the private control plane.

The sole production architecture authority is
[`thally-cloud/ARCHITECTURE.md`](https://github.com/thallylabs/thally-cloud/blob/main/ARCHITECTURE.md).
That repository is private; this file defines only starter-local ownership and
workflow rules. Do not create another architecture document here.

Runtime-owned files in this repository are a generated snapshot, not a second
implementation. Never hand-apply a runtime fix here. Run the **Sync Thally
runtime** workflow, review its generated pull request, and let CI prove that
the snapshot matches the exact runtime commit in `starter-release.json`.

Before placing a feature, trace the actual creation or request path in code and
identify the deployed artifact. Do not infer ownership from repository names
or an outdated planning document.

Package versions, scaffold releases, managed site releases, and Cloud platform
releases are separate identities. A starter synchronization does not itself
upgrade an existing site or move a production release pointer.

## Project boundaries

- Pages are MDX files in `src/content/`.
- Navigation and portable product features are configured in `docs.json`.
- Site identity and versioned brand defaults live in `src/data/site.ts`.
- `starter-release.json` and runtime-owned paths listed in it are
  machine-managed; do not hand-edit them.
- Runtime changes belong in `thallylabs/thally` and arrive here only through
  the generated synchronization pull request.
- Starter-owned seed content and portable defaults are authored here. Paid
  service internals remain in `thallylabs/thally-cloud`.
- Never place credentials in source files. Use `.env.local` locally and secret
  storage in the deployment platform.

## Writing standards

- Address the reader as “you” and use active voice.
- Lead with the outcome, then state prerequisites and the shortest working path.
- Use sentence-case headings and concise paragraphs.
- Format commands, files, configuration keys, and code with backticks.
- Tell readers what success looks like and link the next useful task.
- Keep advanced or optional paths outside the primary workflow.

## Content model

- Every page needs `title` and `description` frontmatter.
- Keep page slugs stable once published.
- Add pages to `docs.json`; do not leave useful pages orphaned.
- Update `openapi.yaml` when API behavior changes.
- Run `npm ci --ignore-scripts --prefix .github/thally-tooling`, then
  `.github/thally-tooling/node_modules/.bin/thally check --ci .`, `npm test`,
  and `npm run build` before publishing.

## Product context

These docs describe the GitLite REST API at `/api/v1`. GitLite is a fork of Gitea.

Knowledge map. Each product fact has exactly one home page. Update the home and leave pages that only link to it alone:

| Product fact | Home page(s) | Pages that only reference it |
| --- | --- | --- |
| Authorization scheme, including the `GITLITE_AUTH` value and deprecation or sunset headers | `authentication`, `quickstart` | all API reference pages and guides, which use `$GITLITE_AUTH` |
| Authentication error messages (`401` bodies) | `guides/errors` | `authentication` |
| Default and maximum page size, pagination response headers | `pagination` | `api/*` pages, which link to Pagination |
| `[api]` settings and defaults, including new keys | `reference/configuration-api` | `guides/rate-limits` (defaults table) |
| Response size caps | `guides/rate-limits` | none |

Working efficiently:

- Every code example reads the header from `$GITLITE_AUTH` or `process.env.GITLITE_AUTH`. A scheme change is a one-line edit to the `export GITLITE_AUTH=...` line on the home pages. Do not rewrite individual examples.
- Read only the home pages named above for the fact being changed. Do not read every page.
- When a page needs more than three separate span edits, make one `update_page` call instead of many `replace_page_text` calls.
- There is no OpenAPI file in this repository. Do not look for one.

MDX safety rules. A draft that breaks these fails the site build even when `thally check` passes:

- Never write a bare angle-bracket placeholder such as <token> or <sha> in prose, tables, or headings. MDX parses it as an unclosed JSX tag. Always wrap placeholders in backticks, for example `Authorization: Bearer <token>`, or put them inside a fenced code block.
- Wrap HTTP header lines, header names, and config keys in backticks: `Deprecation: true`, `X-HasMore`, `ALLOW_LEGACY_TOKEN_SCHEME`.
- Keep the existing Tabs/Tab structure and use one curl example plus one JavaScript example per operation.
- Keep `lastVerified`, `verifiedVersion`, `sources`, and `verifiedCommit` frontmatter keys. When a page is updated for a product change, set `verifiedCommit` to the product merge commit and `lastVerified` to the update date.
- Do not edit `src/content/changelog.mdx`. Maintainers write release notes.
- Pages that do not describe the changed behavior (for example `guides/webhooks`, `guides/deployment`, `introduction`) should stay unchanged.

Terminology: "access token", "authorization scheme", "page size". Code samples target `http://localhost:3000/api/v1` and read the token from `GITLITE_TOKEN`.
