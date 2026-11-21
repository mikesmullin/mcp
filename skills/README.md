# mcp-skills

MCP stdio server exposing the **skills CLI** as a single tool.

`skills(name?) -> string` — same config, same resolution, same output as
`/workspace/cli/skills` (`bun skills`), over the MCP protocol:

- **no `name`** (or `name: "available"`) → full listing: named CLI tools
  (aligned columns) + discovered skill files with frontmatter descriptions
- **`name: "<skill>"`** → the skill file contents in the CLI's exact format:
  `executing: cat /abs/path`, blank line, file body. Fuzzy resolution:
  named tool → file-name substring match → did-you-mean suggestions
- **`name: "--help"`** → CLI help text

Read-only; never writes config or skill files. Core logic is
`/workspace/cli/skills/lib/core.js`, shared with the CLI. Config comes from
`~/.config/skills/*.yaml` (the same file the CLI auto-creates from
`config.yaml.example`).

## Run

```bash
bun server.coffee                 # stdio; spawn as a child from any MCP client
bun server.coffee | head -1       # sanity check: sends initialize
```

## Ada

Wired into `ada-back` as the `skills` mcp entry (env override
`ADA_SKILLS_MCP`, default `/workspace/mcp-skills/server.coffee`, which is a
symlink to this directory). Ada can `skills jira`, `skills video-reader`,
etc., from her tool catalog.

## Install

```bash
cd /workspace/mcp/skills && bun install
# (Ada picks up the server path; no other install needed)
```
