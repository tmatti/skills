---
name: hoard
description: Launch a background investigation that researches a topic, builds an interactive artifact, and pushes it to the tmatti/hoard knowledge-base repo. Use when the user invokes /hoard <topic>, or asks to "hoard" something or add it to the hoard.
disable-model-invocation: true
---

# Hoard investigation launcher

Fire-and-forget: compose a brief, launch the runner in the background, keep working. The investigation runs headless in an isolated worktree of the hoard repo and pushes its artifact to master when done.

## Steps

1. **Compose the investigation brief.** A self-contained markdown document with:
   - **Topic** — from the arguments. If the arguments are thin and the current conversation is clearly what the user wants captured, derive the topic from the conversation.
   - **Context** — pull anything relevant from the current conversation: links, error messages, code snippets, findings so far, decisions already made. The background agent has NO access to this conversation; the brief is all it gets.
   - **Questions to answer** — 2–5 concrete questions the artifact should resolve.
   - **Suggested folder name** — kebab-case.

   Do NOT restate hoard repo conventions (folder structure, notes.md, index.html, design system) — the repo's AGENTS.md handles all of that automatically.

2. **Write the brief to a temp file**, e.g. `$(mktemp -t hoard-brief).md`.

3. **Launch the runner as a background task** (Bash with `run_in_background: true`):

   ```
   ~/.claude/skills/hoard/run.sh <brief-file> <kebab-slug> [model]
   ```

   The optional third argument (or `HOARD_MODEL` env var) sets the model for the headless run, e.g. `opus`. Omit it to use the default. Pass it when the user asks for a specific model.

4. **Tell the user it's launched**, then return to whatever you were doing. When the background task completes you'll be re-invoked: report the outcome — pushed folder + commit on success, or the log path on failure (logs live in `~/.local/state/hoard/logs/`).

## Notes

- The runner creates a temporary git worktree, so the user's hoard checkout and parallel `/hoard` runs are unaffected. Failed runs keep their worktree (under `~/.local/state/hoard/runs/`) for inspection. Override the state location with `HOARD_STATE_DIR`.
- Runs typically take 5–30 minutes. Do not poll; the background task notifies on exit.
- Requires the hoard repo at `~/dev/github/tmatti/hoard` (override with `HOARD_REPO` env var).
