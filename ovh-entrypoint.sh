#!/bin/sh
set -eu

DATA_DIR="${FORGE_DATA_DIR:-/workspace/forge-data}"
PORT="${FORGE_PORT:-7860}"
PYTHON_BIN="/home/1001/.local/bin/python"

mkdir -p \
  "$HOME" \
  "$DATA_DIR" \
  "$DATA_DIR/models" \
  "$DATA_DIR/outputs" \
  "$DATA_DIR/config_states" \
  "$XDG_CACHE_HOME" \
  /tmp

if [ ! -x "$PYTHON_BIN" ]; then
  PYTHON_BIN=python3
fi

exec /usr/bin/dumb-init -- \
  "$PYTHON_BIN" \
  /app/launch.py \
  --listen \
  --port "$PORT" \
  --data-dir "$DATA_DIR" \
  "$@"
