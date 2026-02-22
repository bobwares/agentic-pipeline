#!/usr/bin/env bash
# agentic-pipeline installer
# Usage: bash install.sh [target-project-dir]
# Default target: current directory

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║          agentic-pipeline v1.0.0 installer           ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Source:  $REPO_DIR"
echo "Target:  $TARGET_DIR"
echo ""

# Validate target
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Target directory does not exist: $TARGET_DIR"
  exit 1
fi

CLAUDE_TARGET="$TARGET_DIR/.claude"

# Backup existing .claude if present
if [ -d "$CLAUDE_TARGET" ]; then
  BACKUP="$TARGET_DIR/.claude.backup.$(date +%Y%m%d_%H%M%S)"
  echo "⚠️  Existing .claude directory found. Backing up to:"
  echo "   $BACKUP"
  cp -r "$CLAUDE_TARGET" "$BACKUP"
  echo ""
fi

# Copy .claude directory
echo "📁 Installing .claude configuration..."
cp -r "$REPO_DIR/.claude" "$TARGET_DIR/"
echo "   ✅ agents/         (14 specialist agents)"
echo "   ✅ skills/         (29 skills — domain + workflow)"
echo "   ✅ memory/         (6-file memory bank — templates)"
echo "   ✅ hooks/          (skill-eval + audit-log)"
echo "   ✅ rules/          (tech standards + coordination)"
echo "   ✅ settings.json   (permissions + hooks)"

# Copy CLAUDE.md if target doesn't have one
if [ ! -f "$TARGET_DIR/CLAUDE.md" ]; then
  cp "$REPO_DIR/CLAUDE.md" "$TARGET_DIR/"
  echo "   ✅ CLAUDE.md      (project memory + standards)"
else
  echo "   ⚠️  CLAUDE.md already exists — skipping (keeping yours)"
fi

# Make hook scripts executable
chmod +x "$CLAUDE_TARGET/hooks/skill-eval.sh" 2>/dev/null || true
chmod +x "$CLAUDE_TARGET/hooks/audit-log.sh" 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║                  Installation complete!              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "  1. cd $TARGET_DIR"
echo "  2. claude                    # Open Claude Code"
echo "  3. /memory-init              # Initialize memory bank from your project"
echo "  4. /spec-prd-new <feature>   # Define your first feature"
echo ""
echo "Available skills:"
echo "  /session-start    Load memory + orient to your project"
echo "  /spec-prd-new     Write a new PRD with guided questions"
echo "  /spec-prd-parse   Transform PRD into epic + task breakdown"
echo "  /spec-epic-start  Begin implementing an epic"
echo "  /verify-all       Run full quality gate"
echo "  /git-commit-push-pr  Commit, push, create PR"
echo ""
echo "Available agents (invoked automatically by orchestrator):"
echo "  orchestrator      code-architect    nextjs-engineer"
echo "  nestjs-engineer   spring-engineer   drizzle-dba"
echo "  ai-engineer       code-reviewer     test-writer"
echo "  verify-app        security-auditor  doc-generator"
echo "  git-guardian      memory-bank"
echo ""
echo "Happy building! 🚀"
