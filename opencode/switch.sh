#!/usr/bin/env bash

set -e

PROVIDER="${1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
TARGET="$CONFIG_DIR/opencode.json"

if [[ "$PROVIDER" != "anthropic" && "$PROVIDER" != "zen" ]]; then
  echo "Usage: ./switch.sh [anthropic|zen]"
  echo ""
  echo "  anthropic  — use your Anthropic API key directly"
  echo "  zen        — use OpenCode's Zen platform billing"
  exit 1
fi

mkdir -p "$CONFIG_DIR"
cp "$SCRIPT_DIR/configs/$PROVIDER.json" "$TARGET"
echo "Switched to provider: $PROVIDER"
echo "Config written to: $TARGET"
