# Developer configuration

Public, versioned configuration for OpenCode. Project-specific architecture,
commands, and deployment rules remain in each application's own `AGENTS.md`.

## Layout

```text
opencode/
├── AGENTS.md
├── opencode.json
└── agents/
    ├── code-reviewer.md
    └── security-reviewer.md
```

## Quick install

On macOS or Linux with Git available:

```bash
curl -fsSL https://raw.githubusercontent.com/cggherasim/developer-config/main/install.sh | bash
```

Or, if you prefer `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/cggherasim/developer-config/main/install.sh | bash
```

This will:

- clone or update `cggherasim/developer-config` under your user config directory;
- create an `opencode/` directory under `$XDG_CONFIG_HOME` or `~/.config`;
- symlink the shared `AGENTS.md`, `opencode.json`, and global review agents.

The script does not install OpenCode itself or manage provider credentials.

## Manual install

Clone the repository, then link the OpenCode files into the standard user
configuration directory:

```bash
git clone https://github.com/cggherasim/developer-config.git \
  "$HOME/.config/developer-config"

mkdir -p "$HOME/.config/opencode/agents"

ln -sfn "$HOME/.config/developer-config/opencode/AGENTS.md" \
  "$HOME/.config/opencode/AGENTS.md"
ln -sfn "$HOME/.config/developer-config/opencode/opencode.json" \
  "$HOME/.config/opencode/opencode.json"
ln -sfn "$HOME/.config/developer-config/opencode/agents/code-reviewer.md" \
  "$HOME/.config/opencode/agents/code-reviewer.md"
ln -sfn "$HOME/.config/developer-config/opencode/agents/security-reviewer.md" \
  "$HOME/.config/opencode/agents/security-reviewer.md"
```

If a destination already exists as a regular file or directory, back it up
before running `ln`; `ln -sfn` does not replace a regular directory safely.

Restart OpenCode after changing global instructions so a new session receives
the updated configuration.

### Script options

The installer supports several options when run directly:

```bash
install.sh [options]

Options:
  --prefix DIR      Install under DIR instead of $XDG_CONFIG_HOME or ~/.config
  --dry-run         Show planned actions without changing the system
  --force           Replace existing files and symlinks
  --uninstall       Remove symlinks created by this installer
  --help            Show usage
```

## Responsibilities

Global files contain only preferences that should apply to every repository:

- conservative editing and approval behavior;
- truthful validation and completion reporting;
- secret, privacy, and destructive-operation safeguards;
- reusable read-only review agents.

Each application repository remains responsible for:

- architecture and repository boundaries;
- exact build and test commands;
- project-specific security invariants;
- deployment procedures and production risks.

## Updating

If you installed via the script, re-run it to pick up configuration changes.
Otherwise, update manually:

```bash
cd "$HOME/.config/developer-config"
git pull --ff-only
```

Review configuration changes before opening a new OpenCode session.

## Security

Never commit API keys, access tokens, cookies, SSH keys, AWS credentials,
`.env` files, OpenCode authentication state, session history, or copied private
repository content. Provider authentication remains outside this repository.
