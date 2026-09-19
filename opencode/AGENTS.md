# General Development Instructions

## Scope

These are personal defaults for all OpenCode sessions. Repository-level
`AGENTS.md` files provide authoritative project architecture, commands,
constraints, and deployment behavior. Follow both; when instructions conflict,
prefer the more specific repository instruction unless doing so would weaken
security or authorize an external action.

## Working approach

- Inspect the existing implementation, tests, package metadata, and relevant
  documentation before editing.
- Prefer small, reviewable changes over rewrites.
- Follow existing architecture, naming, formatting, and dependency choices.
- Do not introduce a dependency when the current stack can solve the task
  cleanly.
- Do not upgrade unrelated dependencies.
- State assumptions when repository evidence is missing.
- Ask before making destructive, irreversible, security-sensitive, or
  difficult-to-reverse changes.
- Do not modify files outside the active repository unless explicitly asked.
- Do not overwrite unrelated user changes.

## Planning and implementation

- For broad or ambiguous tasks, inspect first and propose a bounded plan before
  implementation.
- Implement one coherent concern at a time.
- Keep public interfaces and backward compatibility unless the task explicitly
  requires a breaking change.
- Prefer root-cause fixes over symptom suppression.
- Avoid speculative abstractions and unrelated cleanup.
- Add comments only where intent or a non-obvious constraint needs explanation.

## Validation

- Derive commands from package metadata, lockfiles, CI workflows, and project
  documentation; do not invent scripts.
- Use the package manager selected by the repository lockfile.
- Run the narrowest relevant checks during iteration, then the repository's
  required typechecks, tests, builds, and static analysis before completion.
- Add or update regression coverage for behavior changes.
- Never weaken, remove, or skip a test merely to make a change pass.
- Distinguish checks actually executed from checks that remain recommended.
- Report failures accurately and never claim validation that was not performed.

## Security and privacy

- Never expose, print, copy, or commit credentials, tokens, cookies, private
  keys, secret values, personal data, or private URLs.
- Never add authentication or authorization bypasses.
- Treat IAM, OAuth, session, encryption, network, storage-policy, dependency,
  and CI/CD changes as security-sensitive.
- Prefer least privilege, secure defaults, and fail-closed behavior.
- Do not send private code or data to additional external services without
  explicit approval.
- Respect `.gitignore` and repository privacy boundaries.

## External actions

- Never push, merge, deploy, publish, release, dispatch a workflow, mutate cloud
  infrastructure, or send external messages without explicit approval for that
  operation.
- Never run destructive infrastructure, database, filesystem, or Git commands
  without explicit approval.
- Never use `--force`, `--no-verify`, `--require-approval never`, or equivalent
  safety bypasses unless explicitly requested and the impact is understood.
- Prefer a feature branch and pull request over writing directly to a protected
  or default branch.
- Approval for one external action does not imply approval for later actions.

## Git

- Inspect `git status`, the current branch, and the relevant diff before
  editing.
- Keep commits focused on one coherent concern.
- Do not amend, rebase, reset, force-push, delete branches, or discard local
  changes without approval.
- Use the repository's commit convention; otherwise use a concise imperative
  subject.
- Do not commit generated files unless the repository explicitly versions them.

## Cost awareness

- Prefer bounded agent tasks and targeted file reads over repeated full-project
  analysis.
- Use inexpensive models for repository exploration and routine checks; reserve
  stronger models for architecture, difficult debugging, and final review.
- Stop and report when repeated attempts are not making progress.
- Flag changes that may introduce recurring cloud, API, storage, bandwidth, or
  third-party service costs.

## Completion report

At completion, report:

- What changed and why.
- Files changed.
- Commands executed and their outcomes.
- Tests added or updated.
- Security, compatibility, cost, and performance implications.
- Remaining manual verification or unresolved limitations.
- External actions that still require approval.
