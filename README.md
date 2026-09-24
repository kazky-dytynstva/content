# Kazky Content Data

**Current Version: 4**

All data modifications must target `/data/4/` and pass validation before merging.

## Modifying Data (Version 4)

1. Create branch `data_update`
2. Modify data in `/data/4/` (tales/people)
3. **Run validation**: `cd validation && fvm dart run bin/validate_data_4.dart ..`
4. Fix any validation errors
5. Commit, push, and create PR
6. Merge to `main` after validation passes

## Validation

Before committing changes to version 4:
- Run from `validation/`: `fvm dart run bin/validate_data_4.dart ..`
- Ensure all checks pass (JSON structure, references, images)
- Fix errors before creating PR

## Draft Pipeline Rollout

The D10 pipeline implementation is locally tested, but rollout is **blocked**.
The read-only legacy audit stops at `data/4/people/58/photo.original.jpg`: its
bytes are WebP, not JPEG. No content files were repaired or rewritten. Correct
that record through a separately approved content edit, then rerun the full
audit; this first failure is not an exhaustive inventory of legacy defects.

Versioned drafts live only under `authoring/v1`. Incomplete payloads are valid;
unknown schemas, interrupted writes, invalid history/receipts and damaged media
are not. Ready records, including hidden tales, must pass the shared DTO 1.6.5
runtime rules and media/reference checks before publication.

PR CI validates the merge candidate on both `dev` and `main`, tests immutable
head/base ID evidence, and retains a mobile-only artifact. It does not deploy
that artifact. Current mobile code still reads `data/4` directly from GitHub;
authoring files in the repository are not private merely because they are
excluded from the artifact. Required branch checks must protect both branches.

Before draft UI activation: obtain hosted CI evidence, remediate legacy content,
verify all supported mobile releases and both console platforms, and establish
a minimum compatible console version. Old consoles must not write authoring
stores. No branch-protection setting, release, push or workflow dispatch is
performed by this change. See [validation/README.md](validation/README.md).

