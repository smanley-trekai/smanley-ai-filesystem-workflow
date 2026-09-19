# Filesystem Specification

## Reading order

When entering a project for the first time, a human or AI assistant should read:

1. `README.md` — navigation and project summary.
2. `PROJECT.md` — goals, scope, people, constraints, and success criteria.
3. `STATUS.md` — what is happening now, blockers, and next actions.
4. `AGENTS.md` — rules for AI-assisted work.
5. `02-context/decisions/DECISION-LOG.md` — decisions that constrain the work.

This order is written into every generated `AGENTS.md`.

## Common directories

| Path | Purpose | Put here | Do not put here |
|---|---|---|---|
| `01-planning` | Define the work | Brief, requirements, roadmap | Meeting notes or final output |
| `02-context` | Explain the environment | Background, terms, links, decisions | Active drafts |
| `03-work` | Produce the work | Source, drafts, analysis, tests | Final approved exports |
| `04-assets` | Store reusable media | Images, video, audio, design sources | Final reports or releases |
| `05-notes` | Capture working memory | Daily, meeting, research, idea notes | Binding decisions only recorded here |
| `06-changes` | Explain project evolution | Changelog, change proposals | Untracked scratch notes |
| `07-deliverables` | Hold outputs | Review copies and final outputs | Editable source assets |
| `90-archive` | Retain inactive history | Superseded and closed material | Current work |

## Code profile

```text
03-work/
├── src/        # Product or library source
├── tests/      # Automated tests and fixtures
├── config/     # Example and non-secret configuration
├── scripts/    # Project automation
└── docs/       # Technical documentation
```

Secrets, credentials, generated dependencies, caches, and build output should
not be committed. The generated `.gitignore` covers common macOS and development
artifacts; add tool-specific rules as needed.

## Non-code profile

```text
03-work/
├── research/   # Collected and synthesized research
├── drafts/     # Work in progress
├── content/    # Structured working content
├── data/       # Source data and analysis inputs
└── reviews/    # Feedback and review material
```

Editable originals belong in `03-work`; presentation-ready exports belong in
`07-deliverables`.

## Asset taxonomy

`04-assets` is identical in both profiles:

- `images` — photos, screenshots, illustrations, and raster graphics.
- `video` — source clips and working video files.
- `audio` — recordings, narration, music, and sound effects.
- `design` — editable design files and visual specifications.
- `fonts` — distributable project fonts and their licenses.
- `source` — unmodified source media that does not fit the above.

Use descriptive names such as `homepage-hero-v02-2026-09-19.png`. Avoid names
like `final-final-2.png`. Large binary projects may replace these directories
with cloud-storage pointers; record the canonical location in the asset README.

## Naming rules

- Directories use lowercase kebab-case.
- Markdown documents use uppercase names when they are project-level controls
  (`STATUS.md`) and lowercase kebab-case for dated or topical notes.
- Dates use ISO 8601: `YYYY-MM-DD`.
- A meeting note can be named `2026-09-19-weekly-sync.md`.
- A decision ID uses `DEC-001`, `DEC-002`, and so on.
- Never encode confidential data in a filename.

## Source-of-truth rules

- `PROJECT.md` owns project scope and success criteria.
- `STATUS.md` owns current state, blockers, and next actions.
- `DECISION-LOG.md` owns durable decisions and their rationale.
- `CHANGELOG.md` owns notable changes to the project's outputs or direction.
- Task-management software may own detailed tasks; link it from `STATUS.md`
  rather than duplicating every task.

If two files disagree, update them or explicitly identify the authoritative one.
