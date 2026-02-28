#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

# Whitelist of allowed server entry points (exact match)
case "${1:-}" in
  codex-server.ts|copilot-server.ts|cursor-server.ts|gemini-server.ts|quorum-server.ts|cli.ts) ;;
  *)
    echo "Usage: run.sh <server>" >&2
    echo "Allowed: codex-server.ts copilot-server.ts cursor-server.ts gemini-server.ts quorum-server.ts cli.ts" >&2
    exit 1
    ;;
esac

# Auto-install deps (or repair broken node_modules)
TSX="$DIR/node_modules/.bin/tsx"
if ! "$TSX" --version >/dev/null 2>&1; then
  rm -rf "$DIR/node_modules"
  npm install --prefix "$DIR" --silent >&2
fi

if ! "$TSX" --version >/dev/null 2>&1; then
  echo "tsx broken after npm install" >&2
  exit 1
fi

exec "$TSX" "$DIR/src/$1"
