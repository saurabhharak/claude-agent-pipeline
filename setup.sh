#!/bin/bash
# Setup script for Claude Agent Pipeline
# Copies the agent configuration into your target project directory.
#
# Usage:
#   bash setup.sh /path/to/your-project
#   bash setup.sh .                        # current directory

set -e

TARGET="${1:-.}"

if [ ! -d "$TARGET" ]; then
  echo "Error: Directory '$TARGET' does not exist."
  exit 1
fi

if [ -d "$TARGET/.claude/agents" ]; then
  echo "Warning: $TARGET/.claude/agents/ already exists."
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy agent configuration
mkdir -p "$TARGET/.claude/agents"
cp "$SCRIPT_DIR/.claude/agents/"*.md "$TARGET/.claude/agents/"
cp "$SCRIPT_DIR/.claude/PROJECT_CONTEXT.md" "$TARGET/.claude/PROJECT_CONTEXT.md"
cp "$SCRIPT_DIR/.claude/settings.local.json.example" "$TARGET/.claude/settings.local.json"

# Copy CLAUDE.md only if one doesn't exist
if [ ! -f "$TARGET/CLAUDE.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "Created CLAUDE.md"
else
  echo "Skipped CLAUDE.md (already exists)"
fi

echo ""
echo "Done! Agent pipeline installed to $TARGET/.claude/"
echo ""
echo "Next steps:"
echo "  1. Edit $TARGET/.claude/PROJECT_CONTEXT.md with your project details"
echo "  2. Review $TARGET/.claude/settings.local.json for permissions"
echo "  3. Start with: claude --agent manager"
