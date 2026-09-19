#!/usr/bin/env bash
set -euo pipefail

# opencode-config install script
# Installs shared OpenCode configuration for any user account.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cggherasim/opencode-config/main/install.sh | bash
# or
#   wget -qO-  https://raw.githubusercontent.com/cggherasim/opencode-config/main/install.sh | bash
#
# Options:
#   --prefix DIR      Install under DIR instead of $XDG_CONFIG_HOME or ~/.config
#   --dry-run         Show what would be done, but do not change the system
#   --force           Replace existing files and symlinks
#   --help            Show usage
#   --uninstall       Remove symlinks created by this script (does not delete the
#                     cloned repository)
#
# This script does NOT:
#   - install OpenCode itself;
#   - manage provider credentials;
#   - modify cloud resources or repositories.

REPO_URL="https://github.com/cggherasim/opencode-config.git"

PREFIX=""
DRY_RUN="false"
FORCE="false"
UNINSTALL="false"

usage() {
  cat <<EOF
opencode-config OpenCode configuration installer

Usage:
  install.sh [options]

Options:
  --prefix DIR      Install under DIR instead of the default ~/.config
  --dry-run         Show planned actions without changing the system
  --force           Replace existing files and symlinks
  --uninstall       Remove symlinks created by this installer
  --help            Show this help text

Environment:
  XDG_CONFIG_HOME   Base directory for user configuration (default: ~/.config)

This installer:
  - clones or updates the opencode-config repository;
  - creates an opencode/ directory under the config base;
  - symlinks AGENTS.md, opencode.json, and global agents.
EOF
}

say() { printf '%s\n' "$*"; }

run() {
  if [ "$DRY_RUN" = "true" ]; then
    printf '[dry-run] %s\n' "$*"
  else
    printf '[run] %s\n' "$*"
    eval "$@"
  fi
}

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefix)
      shift
      [ "$#" -gt 0 ] || { say 'ERROR: --prefix requires a directory'; exit 1; }
      PREFIX="$1"
      ;;
    --dry-run)
      DRY_RUN="true"
      ;;
    --force)
      FORCE="true"
      ;;
    --uninstall)
      UNINSTALL="true"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      say "ERROR: unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

# Determine base directories
CONFIG_BASE="${PREFIX:-${XDG_CONFIG_HOME:-$HOME/.config}}"
REPO_DIR="$CONFIG_BASE/opencode-config"
LEGACY_REPO_DIR="$CONFIG_BASE/developer-config"
OPENCODE_DIR="$CONFIG_BASE/opencode"

say "Config base: $CONFIG_BASE"
say "Repository directory: $REPO_DIR"
say "OpenCode directory: $OPENCODE_DIR"

mkdir_cmd="mkdir -p '$CONFIG_BASE' '$OPENCODE_DIR'"
run "$mkdir_cmd"

if [ "$UNINSTALL" = "true" ]; then
  say "Uninstalling OpenCode configuration symlinks..."
  for target in "AGENTS.md" "opencode.json" "agents/code-reviewer.md" "agents/security-reviewer.md"; do
    dest="$OPENCODE_DIR/$target"
    if [ -L "$dest" ]; then
      run "rm '$dest'"
    else
      say "skip: $dest (not a symlink)"
    fi
  done
  exit 0
fi

# Migrate clones created by versions published before the repository rename.
if [ ! -e "$REPO_DIR" ] && [ -d "$LEGACY_REPO_DIR/.git" ]; then
  legacy_origin="$(git -C "$LEGACY_REPO_DIR" remote get-url origin 2>/dev/null || true)"
  case "$legacy_origin" in
    https://github.com/cggherasim/developer-config.git|https://github.com/cggherasim/opencode-config.git|git@github.com:cggherasim/developer-config.git|git@github.com:cggherasim/opencode-config.git)
      say "Migrating legacy clone from $LEGACY_REPO_DIR..."
      run "mv '$LEGACY_REPO_DIR' '$REPO_DIR'"
      if [ "$DRY_RUN" != "true" ]; then
        run "git -C '$REPO_DIR' remote set-url origin '$REPO_URL'"
      fi
      ;;
    *)
      say "WARNING: $LEGACY_REPO_DIR exists but points to an unexpected remote; leaving it unchanged."
      ;;
  esac
fi

# Clone or update repository
if [ -d "$REPO_DIR/.git" ]; then
  say "Updating existing clone..."
  run "git -C '$REPO_DIR' remote set-url origin '$REPO_URL'"
  run "git -C '$REPO_DIR' fetch origin main && git -C '$REPO_DIR' checkout main && git -C '$REPO_DIR' pull --ff-only origin main"
else
  say "Cloning repository..."
  run "git clone --branch main --depth 1 '$REPO_URL' '$REPO_DIR'"
fi

# Symlink configuration files
link_file() {
  src="$1"
  dest="$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    if [ "$FORCE" != "true" ]; then
      say "skip: $dest exists and is not a symlink (use --force to replace)"
      return 0
    fi
  fi

  run "ln -sfn '$src' '$dest'"
}

SRC_BASE="$REPO_DIR/opencode"

link_file "$SRC_BASE/AGENTS.md" "$OPENCODE_DIR/AGENTS.md"
link_file "$SRC_BASE/opencode.json" "$OPENCODE_DIR/opencode.json"

mkdir_agents_cmd="mkdir -p '$OPENCODE_DIR/agents'"
run "$mkdir_agents_cmd"

link_file "$SRC_BASE/agents/code-reviewer.md" "$OPENCODE_DIR/agents/code-reviewer.md"
link_file "$SRC_BASE/agents/security-reviewer.md" "$OPENCODE_DIR/agents/security-reviewer.md"

say "Installation complete. Restart OpenCode to pick up the updated configuration."
