#!/usr/bin/env bash
# Runs a hoard investigation in an isolated git worktree, then pushes to master.
# Usage: run.sh <brief-file> [slug] [model]
set -euo pipefail

HOARD_REPO="${HOARD_REPO:-$HOME/dev/github/tmatti/hoard}"
HOARD_MODEL="${3:-${HOARD_MODEL:-}}"
# Runtime state lives outside the skill dir so worktrees of the (private)
# hoard repo never sit inside another repo's checkout.
STATE_DIR="${HOARD_STATE_DIR:-$HOME/.local/state}/hoard"
RUNS_DIR="$STATE_DIR/runs"
LOGS_DIR="$STATE_DIR/logs"

BRIEF_FILE="${1:?usage: run.sh <brief-file> [slug]}"
SLUG="${2:-investigation}"
STAMP="$(date +%Y%m%d-%H%M%S)"
RUN_ID="${SLUG}-${STAMP}"
WORKTREE="$RUNS_DIR/$RUN_ID"
LOG="$LOGS_DIR/$RUN_ID.log"

mkdir -p "$RUNS_DIR" "$LOGS_DIR"
exec > >(tee "$LOG") 2>&1

echo "[hoard] run: $RUN_ID"
echo "[hoard] brief: $BRIEF_FILE"

git -C "$HOARD_REPO" fetch origin master
git -C "$HOARD_REPO" worktree prune
git -C "$HOARD_REPO" worktree add --detach "$WORKTREE" origin/master

echo "[hoard] launching claude -p in $WORKTREE"
set +e
(
  cd "$WORKTREE"
  MODEL_ARGS=()
  [ -n "$HOARD_MODEL" ] && MODEL_ARGS=(--model "$HOARD_MODEL")
  claude -p "$(cat "$BRIEF_FILE")" \
    --permission-mode acceptEdits \
    --output-format text \
    ${MODEL_ARGS[@]+"${MODEL_ARGS[@]}"}
)
CLAUDE_EXIT=$?
set -e
if [ "$CLAUDE_EXIT" -ne 0 ]; then
  echo "[hoard] WARNING: claude exited with $CLAUDE_EXIT; checking for salvageable work"
fi

cd "$WORKTREE"

# Salvage-commit only if the agent made no commit at all. If it did commit,
# anything left uncommitted was excluded deliberately (per AGENTS.md) — log it
# but don't sweep it in.
if [ "$(git rev-parse HEAD)" = "$(git rev-parse origin/master)" ]; then
  if [ -n "$(git status --porcelain)" ]; then
    echo "[hoard] agent made no commit; salvaging working tree"
    git add -A
    git commit -m "Investigation: $SLUG"
  else
    echo "[hoard] ERROR: no commits produced; worktree kept for inspection: $WORKTREE"
    echo "[hoard] log: $LOG"
    exit 1
  fi
elif [ -n "$(git status --porcelain)" ]; then
  echo "[hoard] leaving uncommitted leftovers behind (excluded by agent):"
  git status --porcelain
fi

# Push with rebase-retry in case master moved during the run
for attempt in 1 2 3; do
  git fetch origin master
  if ! git rebase origin/master; then
    git rebase --abort
    echo "[hoard] ERROR: rebase conflict with origin/master; worktree kept: $WORKTREE"
    exit 1
  fi
  if git push origin HEAD:master; then
    COMMIT="$(git rev-parse --short HEAD)"
    cd "$HOARD_REPO"
    git worktree remove --force "$WORKTREE"
    echo "[hoard] SUCCESS: pushed $COMMIT to master ($RUN_ID)"
    exit 0
  fi
  echo "[hoard] push failed (attempt $attempt), retrying"
  sleep 2
done

echo "[hoard] ERROR: push failed after 3 attempts; worktree kept: $WORKTREE"
exit 1
