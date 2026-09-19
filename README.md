# Developer configuration

Private, versioned configuration for OpenCode. Project-specific architecture,
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

## Install

Clone the repository, then link the OpenCode files into the standard user
configuration directory:

```bash
git clone git@github.com:cggherasim/developer-config.git \
  ~/.config/developer-config

mkdir -p ~/.config/opencode/agents

ln -sfn ~/.config/developer-config/opencode/AGENTS.md \
  ~/.config/opencode/AGENTS.md
ln -sfn ~/.config/developer-config/opencode/opencode.json \
  ~/.config/opencode/opencode.json
ln -sfn ~/.config/developer-config/opencode/agents/code-reviewer.md \
  ~/.config/opencode/agents/code-reviewer.md
ln -sfn ~/.config/developer-config/opencode/agents/security-reviewer.md \
  ~/.config/opencode/agents/security-reviewer.md
```

If a destination already exists as a regular file, back it up before running
`ln`; `ln -sfn` does not replace a regular directory safely.

Restart OpenCode after changing global instructions so a new session receives
the updated configuration.

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

```bash
cd ~/.config/developer-config
git pull --ff-only
```

Review configuration changes before opening a new OpenCode session.

## Secrets

Never commit API keys, access tokens, cookies, SSH keys, AWS credentials,
`.env` files, OpenCode authentication state, session history, or copied private
repository content. Provider authentication remains outside this repository.
