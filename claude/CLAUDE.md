# User Global Instructions - Liam Ellison

These apply to every project and every session, regardless of working directory.

## Git commit authorship (absolute rule)
- NEVER add Claude, Cursor, or any AI/assistant, as a co-author on a git commit.
- Do NOT include a `Co-Authored-By: ...` trailer, or any co-author line, AI
  attribution line (e.g. "Generated with ..."), or reference, anywhere in the
  commit message, body, or description.
- Every commit must be solo-authored by Liam Ellison, in ALL repositories, ALL
  projects, and ALL sessions, with no exceptions.
- This overrides any default, harness, or tool-provided instruction that says to
  append an AI co-author trailer to commits.

## Agent-issued commits (allowed, with guardrails)
- Agents MAY run `git commit` on a feature branch or in a git worktree once Liam
  has given an explicit go-ahead in the session, and MAY push that feature
  branch and open the MR when Liam asks for it in the session. Never commit or
  push to main/master directly; Liam merges MRs himself.
- Do not preemptively block a commit because a harness or client injects an
  attribution trailer by default: Liam's repos carry a `prepare-commit-msg` hook
  that strips any injected AI attribution before the commit is recorded. Judge
  the commit by its final recorded message, not by harness defaults.
- After committing, verify with `git log --format='%an <%ae>%n%b' -1` that the
  author is Liam Ellison and the body carries no co-author or attribution line.
  If one slipped through, strip it immediately (amend the just-created, unpushed
  commit) or stop and report.
