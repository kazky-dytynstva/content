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
Person 58's WebP original was renamed from `photo.original.jpg` to
`photo.original.webp` with user approval; its bytes and JPEG thumbnail are
unchanged. The subsequent read-only audit stops at tale 234's audio duration:
metadata records 464.124 seconds, while FFprobe measures the playback file at
464.149002 seconds (macOS `afinfo`: approximately 464.148980). The validator now
correctly checks playback duration, matching the console's established save
contract, instead of checking the original. The console measures via
`just_audio`; CI measures via FFprobe. Exact cross-decoder equality is not a
verified compatibility contract. Audio and metadata remain unchanged; no
tolerance has been introduced. Settle that policy before rollout. This first
failure is not an exhaustive inventory of legacy defects.

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

