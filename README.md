# AI + Human Project Filesystem

A reproducible macOS-friendly project structure designed to make a project easy
to navigate for both people and AI assistants.

It supports two profiles:

- `code` — software, automation, data, and technical projects.
- `non-code` — writing, research, operations, campaigns, events, and other work.

Both profiles share the same information architecture, so switching between
projects does not mean relearning where context, decisions, notes, assets, or
deliverables live.

## Quick start on macOS

No packages are required. The script works with the Bash version included with
macOS.

```bash
chmod +x create-project.sh

# Create a software project in the current directory
./create-project.sh --name "Customer Portal" --type code

# Create a non-code project in a chosen directory
./create-project.sh \
  --name "Fall Campaign" \
  --type non-code \
  --destination "$HOME/Documents/Projects"
```

The generated folder name is a filesystem-safe version of the project name,
such as `customer-portal`. Preview without creating anything:

```bash
./create-project.sh --name "Customer Portal" --type code --dry-run
```

Run `./create-project.sh --help` for every option.

## The shared structure

```text
project-name/
├── README.md                 # Human-friendly front door
├── AGENTS.md                 # Instructions and boundaries for AI assistants
├── PROJECT.md                # Purpose, scope, owners, and constraints
├── STATUS.md                 # Current state and next actions
├── 01-planning/              # Brief, requirements, roadmap
├── 02-context/               # Background, glossary, references, decisions
├── 03-work/                  # The actual work; varies by project profile
├── 04-assets/                # Images, video, audio, design, fonts, source media
├── 05-notes/                 # Daily notes, meetings, research, ideas
├── 06-changes/               # Changelog and proposed changes
├── 07-deliverables/          # Review-ready and final outputs
└── 90-archive/               # Superseded or inactive material
```

Numbered folders keep the intended reading order stable in Finder and the
terminal. Only the main workflow folders are numbered; files inside use clear,
ordinary names.

The `code` profile adds `src`, `tests`, `config`, `scripts`, and technical docs
under `03-work`. The `non-code` profile adds `research`, `drafts`, `content`,
`data`, and `reviews` instead.

Choose `code` when executable source or automated tests are a primary output.
Choose `non-code` when documents, research, media, operations, or plans are the
primary output. For a hybrid project, use `code` and add content-specific folders
under `03-work` only when they are actually needed.

See [docs/FILESYSTEM-SPEC.md](docs/FILESYSTEM-SPEC.md) for the design rules and
[docs/WORKFLOW.md](docs/WORKFLOW.md) for the daily human/AI workflow.

## How it works, in plain language

Think of each project as a well-labeled filing cabinet. Humans and AI assistants
use the same labels, so both know where to find information and where new work
should be saved.

Four files at the top of every generated project act as its front desk:

| File | What it tells you |
|---|---|
| `README.md` | How the project is organized and where to begin |
| `PROJECT.md` | What the project should accomplish and what is in or out of scope |
| `STATUS.md` | What is happening now, what is blocked, and what happens next |
| `AGENTS.md` | How an AI assistant should work inside the project |

The numbered folders follow the natural life of a project:

1. `01-planning` — decide what will be done.
2. `02-context` — collect the background needed to understand the work.
3. `03-work` — perform the actual work.
4. `04-assets` — store images, video, audio, fonts, and design sources.
5. `05-notes` — capture meetings, research, ideas, and daily observations.
6. `06-changes` — explain what changed and why.
7. `07-deliverables` — hold work that is ready for review or delivery.
8. `90-archive` — preserve material that is no longer active.

The numbers keep these folders in a predictable order in Finder and Terminal.

### How an AI navigates the project

An AI assistant should begin at the project root and read files in this order:

```text
README.md
    ↓
PROJECT.md
    ↓
STATUS.md
    ↓
AGENTS.md
    ↓
Decision log and task-relevant files
```

This gives the AI a map, the objective, the current state, the working rules,
and the history behind important choices. It should then inspect only the parts
of the project relevant to its assigned task.

For example, when asked to update a homepage with approved images, the AI should:

1. Read the four root files.
2. Check `02-context/decisions/DECISION-LOG.md` for established design choices.
3. Find approved images in `04-assets/images`.
4. Perform the work in the appropriate `03-work` folder.
5. Put a review-ready result in `07-deliverables/review`.
6. Record a notable change in `06-changes/CHANGELOG.md`.
7. Update `STATUS.md` so the next person or AI knows what happened.

### How the project gives AI a memory

AI chat sessions do not always remember earlier conversations. The project files
provide durable memory that can be read by a new session, a different AI tool,
or another person:

- Decisions go in `02-context/decisions/DECISION-LOG.md`.
- Current progress and next actions go in `STATUS.md`.
- Meetings and working observations go in `05-notes`.
- Important project changes go in `06-changes/CHANGELOG.md`.
- Approved output goes in `07-deliverables/final`.

This documentation allows work to continue without relying on an old chat or
one person's memory.

### Code and non-code work

Both profiles use the same overall filing system. Only the active workspace is
specialized:

- A `code` project uses `src`, `tests`, `config`, `scripts`, and technical docs.
- A `non-code` project uses `research`, `drafts`, `content`, `data`, and `reviews`.

That distinction helps an AI choose the correct location instead of mixing
source code, rough drafts, assets, and finished deliverables.

### Starting an AI work session

Not every AI tool automatically reads `AGENTS.md`. Open the AI tool from the
project's top-level folder whenever possible. If the tool does not automatically
load project instructions, begin with this request:

> Read `README.md`, `PROJECT.md`, `STATUS.md`, `AGENTS.md`, and the decision log.
> Summarize the current project state and rules before changing anything. When
> finished, update `STATUS.md` and any affected documentation.

At the end of a work session, the human or AI should update `STATUS.md`, record
important decisions and changes, and place review-ready or final output in the
correct deliverables folder. This keeps the project understandable for whoever
opens it next.

## Design principles

1. **A clear front door.** Start with `README.md`, then `PROJECT.md`,
   `STATUS.md`, and `AGENTS.md`.
2. **Context is separate from output.** Background and decisions do not get
   mixed into drafts or source code.
3. **Current state is explicit.** `STATUS.md` is the handoff document between
   a person, an AI assistant, and the next work session.
4. **Assets are source material, not deliverables.** Editable media stays in
   `04-assets`; exported outputs go to `07-deliverables`.
5. **History is preserved.** Explain important changes in `06-changes`; move
   obsolete material to `90-archive` rather than silently deleting it.
6. **Empty folders explain themselves.** Each generated folder contains a short
   README or placeholder, so its purpose remains understandable.

## Sharing and customization

Copy the single `create-project.sh` file to another Mac or keep this repository
in a shared team location. Generated projects have no dependency on this
repository.

To customize the standard for a team, edit the directory lists and Markdown
writer functions in the script, then commit the change so everyone generates
the same version.

## License

MIT — see [LICENSE](LICENSE).
