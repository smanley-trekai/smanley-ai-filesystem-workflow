#!/bin/bash

# Create a consistent, human- and AI-readable project workspace.
# Compatible with the Bash 3.2 version shipped with macOS.

set -eu

SCRIPT_VERSION="1.0.0"
PROJECT_NAME=""
PROJECT_TYPE=""
DESTINATION="$(pwd)"
FOLDER_NAME=""
DRY_RUN=0
INIT_GIT=0

usage() {
  cat <<'EOF'
AI + Human Project Filesystem

Usage:
  ./create-project.sh --name NAME --type TYPE [options]

Required:
  -n, --name NAME          Display name for the project
  -t, --type TYPE          Project profile: code or non-code

Options:
  -d, --destination DIR   Parent directory (default: current directory)
  -f, --folder NAME       Override the generated folder name
      --git               Initialize a local Git repository
      --dry-run           Preview paths without creating anything
  -h, --help              Show this help
  -v, --version           Show the script version

Examples:
  ./create-project.sh -n "Customer Portal" -t code
  ./create-project.sh -n "Fall Campaign" -t non-code -d "$HOME/Documents"
  ./create-project.sh -n "Research" -t non-code --folder research-2026 --git
EOF
}

die() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_value() {
  option="$1"
  value="${2-}"
  if [ -z "$value" ]; then
    die "$option requires a value."
  fi
}

slugify() {
  printf '%s' "$1" \
    | LC_ALL=C tr '[:upper:]' '[:lower:]' \
    | LC_ALL=C sed -e 's/[^a-z0-9][^a-z0-9]*/-/g' -e 's/^-//' -e 's/-$//'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -n|--name)
      require_value "$1" "${2-}"
      PROJECT_NAME="$2"
      shift 2
      ;;
    -t|--type)
      require_value "$1" "${2-}"
      PROJECT_TYPE="$2"
      shift 2
      ;;
    -d|--destination)
      require_value "$1" "${2-}"
      DESTINATION="$2"
      shift 2
      ;;
    -f|--folder)
      require_value "$1" "${2-}"
      FOLDER_NAME="$2"
      shift 2
      ;;
    --git)
      INIT_GIT=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -v|--version)
      printf '%s\n' "$SCRIPT_VERSION"
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      die "Unknown option: $1. Run with --help for usage."
      ;;
  esac
done

[ -n "$PROJECT_NAME" ] || die "--name is required."
[ -n "$PROJECT_TYPE" ] || die "--type is required."

case "$PROJECT_TYPE" in
  code)
    ;;
  non-code|noncode)
    PROJECT_TYPE="non-code"
    ;;
  *)
    die "--type must be 'code' or 'non-code'."
    ;;
esac

if [ -z "$FOLDER_NAME" ]; then
  FOLDER_NAME="$(slugify "$PROJECT_NAME")"
else
  FOLDER_NAME="$(slugify "$FOLDER_NAME")"
fi

[ -n "$FOLDER_NAME" ] || die "The project name must contain at least one letter or number."

case "$DESTINATION" in
  ~*) die "Use \$HOME instead of an unexpanded ~ in --destination." ;;
esac

PROJECT_ROOT="${DESTINATION%/}/$FOLDER_NAME"
CREATED_DATE="$(date '+%Y-%m-%d')"

COMMON_DIRS="
01-planning
02-context/background
02-context/references
02-context/decisions
03-work
04-assets/images
04-assets/video
04-assets/audio
04-assets/design
04-assets/fonts
04-assets/source
05-notes/daily
05-notes/meetings
05-notes/research
05-notes/ideas
06-changes/requests
07-deliverables/review
07-deliverables/final
90-archive
"

if [ "$PROJECT_TYPE" = "code" ]; then
  PROFILE_DIRS="
03-work/src
03-work/tests
03-work/config
03-work/scripts
03-work/docs
"
else
  PROFILE_DIRS="
03-work/research
03-work/drafts
03-work/content
03-work/data
03-work/reviews
"
fi

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'Would create %s project: %s\n' "$PROJECT_TYPE" "$PROJECT_ROOT"
  printf '%s\n%s\n' "$COMMON_DIRS" "$PROFILE_DIRS" | while IFS= read -r directory; do
    if [ -n "$directory" ]; then
      printf '  %s/%s/\n' "$PROJECT_ROOT" "$directory"
    fi
  done
  printf '  Plus project guides, templates, folder READMEs, and .gitignore\n'
  if [ "$INIT_GIT" -eq 1 ]; then
    printf '  Would initialize Git repository\n'
  fi
  exit 0
fi

[ -d "$DESTINATION" ] || die "Destination does not exist: $DESTINATION"
[ ! -e "$PROJECT_ROOT" ] || die "Path already exists; nothing was changed: $PROJECT_ROOT"
if [ "$INIT_GIT" -eq 1 ]; then
  command -v git >/dev/null 2>&1 || die "Git is not installed; nothing was changed."
fi

mkdir -p "$PROJECT_ROOT"
printf '%s\n%s\n' "$COMMON_DIRS" "$PROFILE_DIRS" | while IFS= read -r directory; do
  if [ -n "$directory" ]; then
    mkdir -p "$PROJECT_ROOT/$directory"
  fi
done

cat > "$PROJECT_ROOT/README.md" <<EOF
# $PROJECT_NAME

> One-sentence project summary goes here.

**Profile:** $PROJECT_TYPE  
**Created:** $CREATED_DATE  
**Status:** Planning

## Start here

1. Read [PROJECT.md](PROJECT.md) for goals, scope, and constraints.
2. Read [STATUS.md](STATUS.md) for current work and next actions.
3. Read [AGENTS.md](AGENTS.md) before using an AI assistant.
4. Review [the decision log](02-context/decisions/DECISION-LOG.md) before
   changing an established direction.

## Project map

| Location | Purpose |
|---|---|
| \`01-planning\` | Brief, requirements, and roadmap |
| \`02-context\` | Background, references, glossary, and decisions |
| \`03-work\` | Active project work |
| \`04-assets\` | Images, video, audio, design files, fonts, and source media |
| \`05-notes\` | Daily notes, meetings, research, and ideas |
| \`06-changes\` | Changelog and change requests |
| \`07-deliverables\` | Review-ready and final output |
| \`90-archive\` | Superseded or inactive material |

## Important links

- Task tracker: _Add link or “Not used”_
- Shared drive: _Add link or “Not used”_
- Main deliverable: _Add relative path when known_
- Primary contact: _Add name and preferred contact method_
EOF

cat > "$PROJECT_ROOT/PROJECT.md" <<EOF
# Project Definition: $PROJECT_NAME

**Owner:** _Name or team_  
**Created:** $CREATED_DATE  
**Target date:** _YYYY-MM-DD or ongoing_  
**Project type:** $PROJECT_TYPE

## Purpose

_Why does this project exist? What problem or opportunity does it address?_

## Goals

- _Goal 1_
- _Goal 2_

## Success criteria

- [ ] _A specific, observable outcome_
- [ ] _A quality, performance, or acceptance measure_

## In scope

- _Included work_

## Out of scope

- _Explicitly excluded work_

## Audience and stakeholders

| Person or group | Role | Need or expectation |
|---|---|---|
| _Name_ | _Owner/reviewer/audience_ | _What matters to them_ |

## Constraints

- **Time:** _Deadlines or milestones_
- **Budget:** _Limits or “Not specified”_
- **Tools:** _Required or prohibited tools_
- **Privacy/security:** _Data handling rules_
- **Other:** _Legal, brand, accessibility, or technical constraints_

## Assumptions

- _Assumption that should be verified_

## Risks

| Risk | Likelihood | Impact | Response |
|---|---|---|---|
| _Risk_ | _Low/medium/high_ | _Low/medium/high_ | _Mitigation_ |
EOF

cat > "$PROJECT_ROOT/STATUS.md" <<EOF
# Status: $PROJECT_NAME

**Phase:** Planning  
**Health:** Not yet assessed  
**Last updated:** $CREATED_DATE by _name_

## Current focus

_Describe the single most important area of work right now._

## Recently completed

- _Nothing recorded yet._

## In progress

- [ ] Complete the project definition in \`PROJECT.md\`.
- [ ] Confirm the first milestone and owner.

## Blockers and open questions

- _None recorded._

## Next actions

1. _Next action, owner, and target date._
2. _Next action, owner, and target date._
3. _Next action, owner, and target date._

## Handoff notes

_What should the next person or AI session know before continuing?_
EOF

cat > "$PROJECT_ROOT/AGENTS.md" <<'EOF'
# AI Collaboration Guide

## Required reading order

Before making changes, read:

1. `README.md`
2. `PROJECT.md`
3. `STATUS.md`
4. This file
5. `02-context/decisions/DECISION-LOG.md` when the work may affect a decision

## Working rules

- Preserve the established directory structure unless the task explicitly
  requires changing it.
- Work only within the stated project scope and call out ambiguous requirements.
- Check existing work before creating a duplicate file or solution.
- Place active work in `03-work`, reusable media in `04-assets`, working notes in
  `05-notes`, and completed output in `07-deliverables`.
- Record durable choices in the decision log, not only in chat or a daily note.
- Update `STATUS.md` after material work so another contributor can continue.
- Update `06-changes/CHANGELOG.md` for notable output or direction changes.
- Never add credentials, tokens, private keys, or personal secrets to this tree.
- Do not delete or overwrite material unless the task clearly authorizes it;
  prefer moving superseded work to `90-archive` with explanatory context.
- Use ISO dates (`YYYY-MM-DD`) and descriptive filenames.

## Completion checklist

- [ ] Requested work is complete and verified.
- [ ] Relevant documentation matches the result.
- [ ] Important decisions and changes are recorded.
- [ ] `STATUS.md` accurately describes the handoff state.
- [ ] Deliverables are in the correct folder and source assets remain separate.
EOF

cat > "$PROJECT_ROOT/01-planning/BRIEF.md" <<EOF
# Project Brief: $PROJECT_NAME

## Problem or opportunity

_What needs attention, and why now?_

## Intended outcome

_What should be different when this work succeeds?_

## Audience

_Who is this for?_

## Approach

_Summarize the proposed direction._

## Key milestones

| Milestone | Owner | Target | State |
|---|---|---|---|
| _Milestone_ | _Name_ | _YYYY-MM-DD_ | Planned |
EOF

cat > "$PROJECT_ROOT/01-planning/REQUIREMENTS.md" <<'EOF'
# Requirements

## Must have

- [ ] _Required capability, content, or outcome_

## Should have

- [ ] _Important but negotiable item_

## Could have

- [ ] _Optional enhancement_

## Will not have in this phase

- _Intentional exclusion_

## Acceptance checklist

- [ ] _Objective test or review condition_
EOF

cat > "$PROJECT_ROOT/01-planning/ROADMAP.md" <<'EOF'
# Roadmap

| Phase | Outcome | Target | State |
|---|---|---|---|
| Discover | Scope and context are understood | _YYYY-MM-DD_ | Planned |
| Create | Core work is produced | _YYYY-MM-DD_ | Planned |
| Review | Feedback is resolved | _YYYY-MM-DD_ | Planned |
| Deliver | Final output is accepted | _YYYY-MM-DD_ | Planned |
EOF

cat > "$PROJECT_ROOT/02-context/BACKGROUND.md" <<'EOF'
# Background

## Situation

_Describe the history and environment a new contributor needs to understand._

## Known facts

- _Fact and, when possible, its source_

## Unknowns

- _Question that still needs investigation_

## Related work

- _Project, document, or link_
EOF

cat > "$PROJECT_ROOT/02-context/GLOSSARY.md" <<'EOF'
# Glossary

| Term | Meaning in this project |
|---|---|
| _Term or acronym_ | _Plain-language definition_ |
EOF

cat > "$PROJECT_ROOT/02-context/README.md" <<'EOF'
# Context

This area explains the environment around the work:

- `BACKGROUND.md` summarizes history, known facts, unknowns, and related work.
- `GLOSSARY.md` defines project-specific language.
- `background` holds detailed background documents when one summary is not enough.
- `references` records external and internal sources.
- `decisions` is the durable record of consequential choices and their reasons.

Context should help a new contributor understand the project without reading
every working note. Active drafts and outputs belong in `03-work`.
EOF

cat > "$PROJECT_ROOT/02-context/references/REFERENCES.md" <<'EOF'
# References

| Source | Why it matters | Accessed |
|---|---|---|
| _Title and link/path_ | _Relevance and key point_ | _YYYY-MM-DD_ |

For external sources, record the title, canonical URL, author or organization,
and access date. Note whether a local copy is permitted and where it lives.
EOF

cat > "$PROJECT_ROOT/02-context/decisions/DECISION-LOG.md" <<'EOF'
# Decision Log

Use one entry for each durable decision. Keep superseded entries and change their
status rather than deleting history.

## DEC-001: Establish the initial project direction

- **Date:** _YYYY-MM-DD_
- **Status:** Proposed
- **Owner:** _Name_
- **Context:** _What situation or question requires a decision?_
- **Decision:** _What was or will be chosen?_
- **Reason:** _Why is this the best option?_
- **Alternatives:** _What else was considered?_
- **Consequences:** _What becomes easier, harder, required, or ruled out?_
EOF

cat > "$PROJECT_ROOT/05-notes/README.md" <<'EOF'
# Notes

Working memory lives here. Use `YYYY-MM-DD-topic.md` for individual notes.

- `daily` — session logs and short-lived working notes.
- `meetings` — agenda, attendees, discussion, decisions, and actions.
- `research` — observations and source synthesis not yet promoted to context.
- `ideas` — possibilities that are not approved plans.

Move durable facts to `02-context`, binding decisions to the decision log, and
current actions to `STATUS.md`.
EOF

cat > "$PROJECT_ROOT/05-notes/NOTE-TEMPLATE.md" <<'EOF'
# Note title

**Date:** _YYYY-MM-DD_  
**Author:** _Name_  
**Type:** _Daily / meeting / research / idea_

## Purpose

_Why this note exists._

## Details

_Observations, discussion, or findings._

## Decisions to record

- _Decision, or “None”._

## Actions

- [ ] _Action — owner — due date_
EOF

cat > "$PROJECT_ROOT/06-changes/CHANGELOG.md" <<EOF
# Changelog

Notable changes to project direction and deliverables are recorded here.

## $CREATED_DATE

- Created the project using filesystem template version $SCRIPT_VERSION.
EOF

cat > "$PROJECT_ROOT/06-changes/requests/CHANGE-REQUEST-TEMPLATE.md" <<'EOF'
# Change Request: Short title

**Requested:** _YYYY-MM-DD by name_  
**Status:** Proposed  
**Decision owner:** _Name_

## Requested change

_What should change?_

## Reason

_Why is the change needed?_

## Impact

- **Scope:** _Impact_
- **Schedule:** _Impact_
- **Cost/effort:** _Impact_
- **Quality/risk:** _Impact_

## Decision

_Approved, declined, deferred, or pending—with reason._
EOF

cat > "$PROJECT_ROOT/07-deliverables/README.md" <<'EOF'
# Deliverables

- `review` contains review-ready copies that are not yet approved.
- `final` contains approved or released outputs.

Keep editable sources in `03-work` or `04-assets`. Include version, date, and
approval context in filenames or an adjacent README when multiple releases exist.
EOF

cat > "$PROJECT_ROOT/90-archive/README.md" <<'EOF'
# Archive

Store superseded, closed, or inactive material here when it may still be useful
for history or recovery. Preserve original filenames where practical and add a
dated note explaining why material was archived. Do not use this for backups or
for files that are still active.
EOF

cat > "$PROJECT_ROOT/04-assets/README.md" <<'EOF'
# Assets

Reusable media and editable visual source files live here:

- `images` — photos, screenshots, illustrations, and raster graphics.
- `video` — source clips and working video files.
- `audio` — recordings, narration, music, and sound effects.
- `design` — editable design files and visual specifications.
- `fonts` — distributable fonts and license information.
- `source` — unmodified source media that does not fit another category.

Use descriptive names, keep license/attribution details, and never treat this
directory as the only backup for irreplaceable media. Final exports belong in
`07-deliverables`.
EOF

cat > "$PROJECT_ROOT/.gitignore" <<'EOF'
# macOS and Finder
.DS_Store
.AppleDouble
.LSOverride
Icon?
._*

# Editors
.vscode/
.idea/
*.swp
*~

# Secrets and local environment
.env
.env.*
!.env.example
*.key
*.pem

# Temporary and generated output
*.tmp
*.temp
*.log
.cache/
tmp/
EOF

if [ "$PROJECT_TYPE" = "code" ]; then
  cat > "$PROJECT_ROOT/03-work/README.md" <<'EOF'
# Code Workspace

- `src` — application, package, or automation source code.
- `tests` — automated tests, fixtures, and test documentation.
- `config` — safe configuration examples; never store secrets here.
- `scripts` — repeatable development, build, or maintenance automation.
- `docs` — architecture, API, runbook, and other technical documentation.

Document language-specific setup and verification commands below as the project
develops.

## Setup

_Add exact setup commands._

## Run

_Add exact run commands._

## Test

_Add exact verification commands._
EOF

  cat >> "$PROJECT_ROOT/.gitignore" <<'EOF'

# Common code artifacts (keep only those relevant to this project)
node_modules/
dist/
build/
coverage/
.venv/
venv/
__pycache__/
*.py[cod]
EOF
else
  cat > "$PROJECT_ROOT/03-work/README.md" <<'EOF'
# Non-code Workspace

- `research` — collected and synthesized research used by the work.
- `drafts` — incomplete working versions.
- `content` — structured copy, outlines, and production content.
- `data` — source data and analysis inputs, subject to privacy rules.
- `reviews` — consolidated feedback and review notes.

Editable work stays here. Copy or export review-ready and approved versions to
`07-deliverables`.
EOF
fi

# Keep leaf directories visible in Git and explain their purpose in Finder.
printf '%s\n%s\n' "$COMMON_DIRS" "$PROFILE_DIRS" | while IFS= read -r directory; do
  if [ -n "$directory" ] && [ -z "$(find "$PROJECT_ROOT/$directory" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    : > "$PROJECT_ROOT/$directory/.gitkeep"
  fi
done

if [ "$INIT_GIT" -eq 1 ]; then
  git -C "$PROJECT_ROOT" init -q
fi

printf '\nCreated %s project at:\n  %s\n\n' "$PROJECT_TYPE" "$PROJECT_ROOT"
printf 'Next steps:\n'
printf '  1. Edit %s/PROJECT.md\n' "$PROJECT_ROOT"
printf '  2. Edit %s/STATUS.md\n' "$PROJECT_ROOT"
printf '  3. Begin work in %s/03-work\n' "$PROJECT_ROOT"
if [ "$INIT_GIT" -eq 1 ]; then
  printf '  4. Review files and create the first Git commit\n'
fi
