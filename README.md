# mcp

My proprietary **MCP** (Model Context Protocol) tool servers — the hands for
[Ada](https://github.com/mikesmullin/ada), [Angela](https://github.com/mikesmullin/angela),
and [AGL](https://github.com/mikesmullin/agl).

Each server lives in its own repo and is wired in here as a git submodule,
plus a `shared/` kit of internals for serving MCP over stdio and HTTP —
the common code the servers are built on. Today that means stdio almost
everywhere; HTTP serving is intended but largely unimplemented.

Clone with `git clone --recurse-submodules`, or run `git submodule update --init`
after cloning.

## Packages

| Path | Repo | Description |
|------|------|-------------|
| [`bun-debug/`](./bun-debug/) | [mcp-bun-debug](https://github.com/mikesmullin/mcp-bun-debug) | Debug Bun processes over CDP: `debug_step_to` async stepping |
| [`compact/`](./compact/) | [mcp-compact](https://github.com/mikesmullin/mcp-compact) | Session-history compaction: `context_analysis`, `compact_session_history` |
| [`context-loop/`](./context-loop/) | [mcp-context-loop](https://github.com/mikesmullin/mcp-context-loop) | Context-loop tools (`goto`, `loop_start_marker`) for the Angela session host |
| [`file-io/`](./file-io/) | [mcp-file-io](https://github.com/mikesmullin/mcp-file-io) | Local filesystem: `list_dir`, `read_file`, `write_file`, `edit`, `grep`, `find`, `stat` |
| [`home/`](./home/) | [mcp-home](https://github.com/mikesmullin/mcp-home) | House tools: lights, Pixel Clock alarms/timers, media, apps, activities |
| [`sandbox/`](./sandbox/) | [mcp-sandbox](https://github.com/mikesmullin/mcp-sandbox) | Sandbox container-workspaces: hire/steer/wait/cancel |
| [`term-local/`](./term-local/) | [mcp-term-local](https://github.com/mikesmullin/mcp-term-local) | Local process: `bash`, `exec` (merged streams, throw on nonzero) |
| [`todo/`](./todo/) | [mcp-todo](https://github.com/mikesmullin/mcp-todo) | Session checklist: `todo_read`, `todo_write` (full-list replace or merge-by-id) |
| [`video-transcribe/`](./video-transcribe/) | [mcp-video-transcribe](https://github.com/mikesmullin/mcp-video-transcribe) | YouTube transcripts: `transcript`, `list_caption_tracks` (yt-dlp auto-subs, no download) |
| [`zen/`](./zen/) | [mcp-zen](https://github.com/mikesmullin/mcp-zen) | Zen/Firefox remote-control: persistent MCP HTTP server + browser extension |
| [`shared/mcp-stdio.mjs`](./shared/mcp-stdio.mjs) | (here) | Shared stdio JSON-RPC helper (vendored per package at split time) |

## Run

Every server documents its own invocation in its repo — start there. The shape
is the same everywhere: stdio servers speak newline-delimited JSON-RPC on
stdin/stdout (`tools/list` + `tools/call`), so any MCP-capable agent host can
spawn them directly:

```bash
# filesystem (optional root jail)
MCP_FILE_ROOT=/tmp/sandbox bun ./file-io/server.mjs

# local exec (optional allowlist)
MCP_TERM_ALLOW='echo,ls,pwd' bun ./term-local/server.mjs

# session checklist (optional JSON persist)
MCP_TODO_PATH=/tmp/todos.json bun ./todo/server.mjs
```

The exception is `zen`, which serves MCP over HTTP (persistent server +
browser extension) instead of stdio — see
[mcp-zen](https://github.com/mikesmullin/mcp-zen#readme).

In Ada they are wired as named MCPs (`home`, `work`, `file`, `compact`,
`sandbox`, …) with a deny-by-default allowlist and spoken approval for risky
tools — see [Ada](https://github.com/mikesmullin/ada#readme).

## Env

Env knobs are per server — each package README documents its own
(`MCP_FILE_ROOT`, `MCP_TERM_CWD`, `MCP_TERM_ALLOW`, `MCP_TODO_PATH`, …).
There is no monorepo-wide configuration; `shared/` carries code, not settings.

## License

MIT
