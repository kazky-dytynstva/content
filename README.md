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
unchanged. Tale 232's mislabeled SVG original was rendered to a genuine PNG.
With approval, all 145 audio tales now store the measured playback duration
in JSON and paired gzip; audio bytes are unchanged. A complete playback audit
confirms all files decode, their sizes agree and no duration mismatches remain.
Duration validity allows an inclusive absolute difference of **50 ms** in both
the console and CI; larger differences fail. Newly measured metadata is not
rounded to this tolerance. The console uses `just_audio`, while CI uses FFprobe.
The approved image repairs converted eight SVG/EPS originals to PNG, corrected
five filename extensions and retained only the PNG original for tale 47.
All 724 remaining images decode and all 362 original/thumbnail pairs are valid.
Thumbnails, audio and collection metadata are unchanged by these repairs.
The full local content validator now passes for all 99 people and 254 tales.

Versioned drafts live only under `authoring/v1`. Incomplete payloads are valid;
unknown schemas, interrupted writes, invalid history/receipts and damaged media
are not. Ready records, including hidden tales, must pass the shared DTO 1.6.5
runtime rules and media/reference checks before publication.

PR CI validates the merge candidate on both `dev` and `main`, tests immutable
head/base ID evidence, and retains a mobile-only artifact. It does not deploy
that artifact. Current mobile code still reads `data/4` directly from GitHub;
authoring files in the repository are not private merely because they are
excluded from the artifact. Required branch checks must protect both branches.

Before draft UI activation: obtain hosted CI evidence for the repaired content,
verify all supported mobile releases and both console platforms, and establish
a minimum compatible console version. Old consoles must not write authoring
stores. No branch-protection setting, release, push or workflow dispatch is
performed by this change. See [validation/README.md](validation/README.md).

