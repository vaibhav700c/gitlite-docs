import { readFileSync, writeFileSync, rmSync } from 'node:fs'
import YAML from 'yaml'

writeFileSync('openapi.yaml', YAML.stringify(JSON.parse(readFileSync('openapi.json', 'utf8'))))
rmSync('openapi.json')
