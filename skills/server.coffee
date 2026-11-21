#!/usr/bin/env bun
# mcp-skills: skill-file lookup as an MCP stdio server. One tool,
# `skills(name?) -> string`, speaking exactly what the `skills` CLI speaks:
#
#   skills()                  -> full listing (CLI tools + discovered files)
#   skills("available")       -> full listing (CLI alias)
#   skills("<name>")          -> "executing: cat /path\n\n<contents>" like `skills <name>`,
#                                with fuzzy resolution (named map -> file-name
#                                substring match -> did-you-mean)
#   skills("--help")          -> CLI help text
#
# Config is the same ~/.config/skills/*.yaml the CLI uses. Only reads skill
# files; loadConfig() (shared with the CLI) creates ~/.config/skills/config.yaml
# on first run if missing — same as running the CLI itself.
# Core logic is shared with the CLI (/workspace/cli/skills/lib/core.js).
import {
  detectTerminalColumns,
  helpText,
  listOutput,
  loadConfig,
  skillFileOutput,
} from "file:///workspace/cli/skills/lib/core.js"
import { runMcpStdioServer, textResult } from "./shared/mcp-stdio.mjs"

tools =
  skills:
    description: "Read AI skill files by name — the skills CLI (config ~/.config/skills/*.yaml) exposed as one tool. " +
      "Omit `name` (or pass \"available\") to list every available CLI skill plus discovered skill files. " +
      "Pass a skill name to get its full contents in the CLI's exact format: an `executing: cat /path` " +
      "header line, blank line, then the file body. Resolution order: named tools, then file-name substring " +
      "matches across configured discovery paths, then fuzzy did-you-mean suggestions. Read-only."
    inputSchema:
      type: "object"
      properties:
        name:
          type: "string"
          description: "Skill name (e.g. \"jira\", \"zen-browser\", \"task\"). Omit, or pass \"available\", " +
            "to list everything; \"--help\" for usage."
      required: []
    handler: (args) ->
      name = String(args?.name ? "").trim()
      config = await loadConfig()
      out = if name is "" then await listOutput(config, 80) else if name is "available" then await listOutput(config, 80) else if name is "--help" then helpText() else await skillFileOutput(config, name)
      return textResult String(out)

await runMcpStdioServer
  name: "mcp-skills"
  version: "0.1.0"
  tools: tools
