# Data Validation Scripts

This package contains validation scripts for the `data/4` folder structure.

## Requirements

- Flutter Version Manager (fvm), pinned Flutter 3.47.5 in the repository `.fvmrc`
- DTO 1.6.5 and dependency versions pinned by `pubspec.lock`
- `ffprobe` and `ffmpeg` on PATH for probing and decoding audio

## Installation

```bash
cd validation
fvm dart pub get --enforce-lockfile
```

## Usage

### Validate data/4 folder

Run the validation script to check the data/4 folder structure and content:

```bash
cd validation
fvm dart run bin/validate_data_4.dart ..
```

Validation is read-only, including failures and unexpected `.DS_Store` files.
The optional root argument permits disposable fixtures without touching real
content. Existing maintenance scripts such as `fix_images.dart` and `run.dart`
are separate mutation tools and are never invoked by the validation pipeline.

## D10 Contract

- `ReadyContent` calls DTO 1.6.5 runtime readiness, without depending on Dart
  assertions. It rejects invalid/duplicate IDs, fractional integer metadata,
  dangling or duplicate crew members, missing/invalid images, audio metadata
  mismatches and unexpected filesystem entries. Image extensions must match
  decoded formats. Audio is probed and fully decoded with FFmpeg, with a
  two-minute per-command timeout. Symlinks are rejected before media reads.
- Gzip must match `toProdJson()`, not the editorial DTO: hidden records remain,
  while review flags and comments are excluded. Validators never regenerate it.
- `AuthoringValidator` checks the console's version-1 JSON contract, not ready
  field completeness. It verifies IDs, typed references, contiguous revision
  history, applied receipts, immutable media names/sizes/SHA-256, duplicate
  active targets and retained media. Unknown keys/schema versions, pending
  staging, promotion markers and unrecognized files fail closed. This is a
  read-only schema adapter, not a second draft writer or serializer; changes to
  the console contract require coordinated version/fixture updates here.
- `validate_branch_ids.dart` compares immutable ancestor/base/head collections
  and base applied-receipt reservations. Independently introduced IDs collide
  even if their JSON is identical. This cannot reconstruct identity lost by an
  earlier manual merge that already overwrote a record; validate before merging.
- `build_mobile_delivery.dart` validates first, then creates a new directory
  outside the checkout with only gzip lists, person thumbnails, tale image
  thumbnails and audio thumbnails under `data/4`. No originals, editorial JSON,
  authoring metadata/media, old versions or repository files enter the artifact.
  Existing destinations are never replaced; interrupted output must not be
  published. Use a fresh destination and upload only after successful exit.

Run isolated tests from this directory:

```bash
fvm dart test --reporter expanded
fvm dart run bin/build_mobile_delivery.dart .. /absolute/new-output-directory
fvm dart run bin/validate_branch_ids.dart .. ANCESTOR_SHA BASE_SHA HEAD_SHA
```

Local verification: **32 tests**, including real JPEG/WAV/AAC decoding, real
isolated Git history, assertions-disabled CLI rejection, authoring corruption,
receipts/history, byte-identical draft-only delivery and DTO production readers.
Person 58's WebP original has now been renamed to `.webp` with unchanged bytes.
The subsequent real-content audit fails closed on tale 234's audio duration:
464.124 seconds stored versus 464.149333 seconds measured by FFprobe. Audio and
metadata remain unchanged pending investigation of measurement semantics.

Scoped analysis matching CI is clean. Full-package analysis still reports the
pre-existing missing `lints` include, removed `avoid_returning_null_for_future`
rule and unused import in the unrelated mutation script `lib/run.dart`.

The artifact is verification output, not a replacement for current raw-GitHub
delivery. Hosted CI, branch protection, supported-release mobile tests, legacy
console retirement and Windows validation remain rollout gates. Local tests use
the current DTO reader, not every shipped mobile binary. Reads assume an
immutable CI checkout; this is not protection against a concurrent external
writer or image/decompression resource exhaustion. No automatic content repair.

## What it validates

The `validate_data_4.dart` script performs the following checks:

### 1. Folder Existence
- ✅ Checks that `data/4` folder exists

### 2. Folder Structure
- ✅ Validates presence of `data/4/people` folder
- ✅ Validates presence of `data/4/tales` folder
- ✅ Checks for `list.json` in both folders

### 3. JSON Parsing
- ✅ Parses `data/4/people/list.json` into `PersonDto` list
- ✅ Parses `data/4/tales/list.json` into `TaleDto` list
- ✅ Detects duplicate IDs in both lists

### 4. People Folder Structure
For each person in the list:
- ✅ Checks that a folder exists with the person's ID
- ❌ Error if `photo.thumbnail.jpg` is missing
- ❌ Error if `photo.original.*` is missing (any format accepted)
- ❌ Error if folder contains more than 2 files
- ❌ Error if folder contains unexpected files
- ❌ Error for orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/people/
  list.json
  {id}/
    photo.thumbnail.jpg
    photo.original.{ext}  # Any format: jpg, png, jpeg, webp, etc.
```

### 5. Tales Folder Structure
For each tale in the list:
- ✅ Checks that a folder exists with the tale's ID
- ❌ Error if `img/` folder is missing
- ❌ Error if `img/` folder doesn't have valid image pairs
- ❌ Error if tale has "audio" tag but `audio/` folder is missing
- ❌ Error if tale has `audio/` folder but no "audio" tag
- ❌ Error for unexpected files or folders
- ❌ Error for orphaned folders (folders without corresponding entry in list.json)

Expected structure:
```
data/4/tales/
  list.json
  list.json.gz        # Compressed version (gzip)
  {id}/
    img/
      0.thumbnail.jpg
      0.original.{ext}  # Any format
      1.thumbnail.jpg   # Optional, if tale has multiple images
      1.original.{ext}  # Optional
      ...
    audio/              # Only if tale has "audio" tag
      thumbnail.m4a     # Required audio thumbnail
      original.{ext}    # Required original audio file (any format)
```

### 6. Compressed Files
- ✅ Checks that `list.json.gz` exists for tales
- ✅ Checks that `list.json.gz` exists for people
- ✅ Validates compressed files can be decompressed
- ✅ Compares decompressed content matches original `list.json`
- ❌ Error if compressed file is missing
- ❌ Error if decompressed content doesn't match original
- ❌ Error if item counts differ between compressed and uncompressed

## Detailed Validation Rules

### Tale Images
Tales must have image pairs in the `img/` folder:
- `{index}.thumbnail.jpg` - Thumbnail version (must be JPG format)
- `{index}.original.{ext}` - Original version (any format: png, jpg, jpeg, webp, etc.)
- Must have at least one image pair with index 0
- All image pairs must have matching indices
- Indices must be sequential starting from 0 (0, 1, 2, 3, ...)

### Tale Audio
Tales with the "audio" tag **must** have an `audio/` folder containing:
- `thumbnail.m4a` - Required audio thumbnail file
- `original.{ext}` - Required original audio file (any format)

Tales **without** the "audio" tag must **not** have an `audio/` folder.

### Person Photos  
Each person folder must have exactly 2 files:
- `photo.thumbnail.jpg` - Required thumbnail (must be JPG format)
- `photo.original.{ext}` - Required original (any format, but only ONE file)

No other files are allowed in person folders.

## Output

The script outputs:
- ✅ Success messages for passed validations
- ❌ Errors for validation failures

At the end, it provides a summary:
- Total number of errors
- Detailed list of all errors (if any)
