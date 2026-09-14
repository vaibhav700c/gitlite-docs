// Runs every curl and JavaScript sample in the docs, in navigation order, and
// writes a pass/fail table. Needs a seeded server (see verify.sh) and
// GITLITE_TOKEN, GITLITE_USER, GITLITE_PASSWORD in the environment.
import { execFileSync, spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync, mkdtempSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

const label = process.argv[2] ?? 'run'
const docs = JSON.parse(readFileSync('docs.json', 'utf8'))
const pages = docs.tabs.flatMap((t) => t.groups ?? []).flatMap((g) => g.pages)
// Pages that document failures on purpose may return these statuses.
const allowed = { 'guides/errors': [401, 404] }

const dir = mkdtempSync(join(tmpdir(), 'gitlite-samples-'))
const fetchShim = join(dir, 'shim.mjs')
writeFileSync(
  fetchShim,
  `const f = globalThis.fetch
globalThis.fetch = async (...a) => { const r = await f(...a); process.stderr.write('__STATUS:' + r.status + '\\n'); return r }\n`,
)
// Wraps curl so every request reports its status on stderr. A sample's own -w
// format is kept and extended, because curl honors only the last -w.
const curlShim = `curl() {
  local args=() found= next=
  for a in "$@"; do
    if [ -n "$next" ]; then args+=("$a%{stderr}__STATUS:%{http_code}\\n"); next=; continue; fi
    [ "$a" = "-w" ] && { found=1; next=1; }
    args+=("$a")
  done
  [ -z "$found" ] && args+=(-w "%{stderr}__STATUS:%{http_code}\\n")
  command curl "\${args[@]}"
}
`

const rows = []
for (const page of pages) {
  const src = readFileSync(`src/content/${page}.mdx`, 'utf8')
  const blocks = [...src.matchAll(/^[ \t]*```(bash|js)\n([\s\S]*?)^[ \t]*```/gm)]
  let index = 0
  for (const [, lang, raw] of blocks) {
    const indent = raw.match(/^[ \t]*/)[0]
    const code = raw.split('\n').map((l) => (l.startsWith(indent) ? l.slice(indent.length) : l)).join('\n')
    if (lang === 'bash' && !code.includes('curl')) continue
    if (code.includes('<your')) continue
    index++
    const file = join(dir, `${page.replaceAll('/', '_')}-${index}.${lang === 'js' ? 'mjs' : 'sh'}`)
    writeFileSync(file, lang === 'js' ? code : curlShim + code)
    const run =
      lang === 'js'
        ? spawnSync('node', ['--import', fetchShim, file], { encoding: 'utf8', timeout: 30000 })
        : spawnSync('bash', [file], { encoding: 'utf8', timeout: 30000 })
    const statuses = [...run.stderr.matchAll(/__STATUS:(\d+)/g)].map((m) => Number(m[1]))
    const ok =
      run.status === 0 &&
      statuses.length > 0 &&
      statuses.every((s) => (s >= 200 && s < 300) || (allowed[page] ?? []).includes(s))
    const firstLine = code.trim().split('\n')[0].slice(0, 70)
    rows.push({ page, index, lang, command: firstLine, exit: run.status, statuses, ok })
    if (!ok) console.error(`FAIL ${page}#${index}\n${run.stdout}\n${run.stderr}`)
  }
}

const passed = rows.filter((r) => r.ok).length
const version = execFileSync('curl', ['-s', 'http://localhost:3000/api/v1/version'], { encoding: 'utf8' })
const table = [
  `# Example verification: ${label}`,
  '',
  `Captured ${new Date().toISOString()} against ${version.trim()}. ${passed}/${rows.length} passed.`,
  '',
  '| Page | # | Lang | Command | Exit | Status | Result |',
  '| --- | --- | --- | --- | --- | --- | --- |',
  ...rows.map(
    (r) =>
      `| ${r.page} | ${r.index} | ${r.lang} | \`${r.command.replaceAll('|', '\\|')}\` | ${r.exit} | ${r.statuses.join(', ')} | ${r.ok ? 'pass' : 'FAIL'} |`,
  ),
  '',
].join('\n')
writeFileSync(`verify/report-${label}.md`, table)
console.log(`${passed}/${rows.length} passed; wrote verify/report-${label}.md`)
process.exit(passed === rows.length ? 0 : 1)
