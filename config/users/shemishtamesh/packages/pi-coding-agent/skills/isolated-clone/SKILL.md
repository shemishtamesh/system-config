---
name: isolated-clone
description: Isolate substantial Git editing tasks in ordinary local clones and delegate edits to subagents, then review and integrate their commits. Use when isolation or parallelism benefits outweigh cloning and integration overhead; not for small, straightforward changes.
---

# Isolated clone workflow

- For substantial editing tasks in a Git repository, use an isolated local clone when
  isolation or parallelism benefits outweigh cloning and integration overhead; make small,
  straightforward changes directly. Place each clone at
  <repository-root>/.worktrees/.pi-clones/<task-id>, using a unique descriptive task
  identifier, not necessarily a branch name. These are ordinary Git clones despite the
  .worktrees directory name: do not use git worktree or the subagents extension's
  managed-worktree allocation for this workflow.

- Before cloning, inspect the source working tree and verify that the clone destination is
  Git-ignored. Clones do not include uncommitted changes: if those changes matter to the task,
  stop and resolve how to include them with the user; never silently omit them, commit them,
  or stash them without permission. Clone from the intended source branch or commit using a
  normal local clone; hard-linked Git objects are acceptable, but do not use --shared or
  --reference, which depend on object storage outside the clone.

- Spawn the editing subagent with cwd set to its clone, worktree: false, and fresh context
  plus a bounded task handoff. The child must be confined to its own clone, not granted access
  to the source checkout or sibling clones; cwd alone is not a sandbox, so do not assume
  confinement if sandbox configuration changes. Use output: false when report artifacts
  outside the child's cwd would be denied, and request an inline completion report.

- Tell the subagent to edit and test inside its clone, commit only its task changes, and ask
  the parent to integrate them via contact_supervisor or its completion report. Require the
  clone path, branch, commit ID, test results, and remaining risks. The child must not modify
  the parent checkout or push over the network. The parent reviews the result, fetches the
  completed branch from the local clone, and merges or cherry-picks the intended commits into
  the intended target branch; prefer explicit fetch and integration over git pull. Preserve
  unrelated parent changes and retain the clone until integration is verified; do not
  automatically discard failed or unfinished work.
