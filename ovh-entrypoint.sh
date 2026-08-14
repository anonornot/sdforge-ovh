#!/bin/sh
set -eu

DATA_DIR="${FORGE_DATA_DIR:-/workspace/data}"
PORT="${FORGE_PORT:-7860}"
PYTHON_BIN="/home/1001/.local/bin/python"

mkdir -p \
  "$HOME" \
  "$DATA_DIR" \
  "$DATA_DIR/models" \
  "$DATA_DIR/models/Stable-diffusion" \
  "$DATA_DIR/outputs" \
  "$DATA_DIR/config_states" \
  "$XDG_CACHE_HOME" \
  /tmp

for model in /opt/forge-models/*; do
  [ -f "$model" ] || continue
  target="$DATA_DIR/models/Stable-diffusion/$(basename "$model")"
  if [ ! -f "$target" ]; then
    cp "$model" "$target"
  fi
done

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
