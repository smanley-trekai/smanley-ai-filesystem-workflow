# Human + AI Workflow

## Start a session

1. Read `README.md`, `PROJECT.md`, `STATUS.md`, and `AGENTS.md`.
2. Review the decision log when the task could affect scope or architecture.
3. Confirm the intended output and where it belongs.
4. Check for uncommitted or in-progress work before editing shared files.

## During a session

- Put active work in the appropriate `03-work` subdirectory.
- Record raw observations in `05-notes`.
- Promote durable background facts to `02-context`.
- Add consequential decisions to the decision log, including the reason and
  alternatives considered.
- Keep source media separate from exported deliverables.
- Do not put passwords, API keys, tokens, or personal secrets in project files.

## End a session

1. Update `STATUS.md` with what changed, what remains, and any blocker.
2. Update `06-changes/CHANGELOG.md` for a notable outcome or direction change.
3. Add or revise decisions if the session made a durable choice.
4. Put review-ready or approved output in `07-deliverables`.
5. Move superseded material to `90-archive` with enough context to recover it.

## Status discipline

Keep `STATUS.md` short. It is a dashboard and handoff, not a diary. The first
screen should answer:

- What phase is this project in?
- What is being worked on now?
- What is blocked?
- What are the next three actions?
- When and by whom was this status updated?

Detailed narrative belongs in a dated note.

## Decision discipline

Log a decision when it changes scope, workflow, technology, messaging, delivery,
or another choice that a future contributor might otherwise revisit. A decision
entry records the date, status, context, choice, reason, and consequences.

## Recommended AI request

At the start of an AI-assisted session, a human can say:

> Read README.md, PROJECT.md, STATUS.md, AGENTS.md, and the decision log. Summarize
> the current state and constraints before changing anything. When finished,
> update STATUS.md and any affected documentation.

The generated `AGENTS.md` already gives assistants this reading order and the
main file-handling rules.
